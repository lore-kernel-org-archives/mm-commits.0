From: akpm@linux-foundation.org
Subject: [merged] cgroups-subsystem-module-loading-interface.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:58:18 -0400
Message-ID: <201003150658.o2F6wpMl016487@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759605Ab0COG7L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:59:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bblum@andrew.cmu.edu, davem@davemloft.net, kamezawa.hiroyu@jp.fujitsu.com, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: subsystem module loading interface
has been removed from the -mm tree.  Its filename was
     cgroups-subsystem-module-loading-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: subsystem module loading interface
From: Ben Blum <bblum@andrew.cmu.edu>

Add interface between cgroups subsystem management and module loading

This patch implements rudimentary module-loading support for cgroups -
namely, a cgroup_load_subsys (similar to cgroup_init_subsys) for use as a
module initcall, and a struct module pointer in struct cgroup_subsys.

Several functions that might be wanted by modules have had EXPORT_SYMBOL
added to them, but it's unclear exactly which functions want it and which
won't.

Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cgroups.txt |    4 
 include/linux/cgroup.h            |    4 
 kernel/cgroup.c                   |  150 +++++++++++++++++++++++++++-
 3 files changed, 153 insertions(+), 5 deletions(-)

diff -puN Documentation/cgroups/cgroups.txt~cgroups-subsystem-module-loading-interface Documentation/cgroups/cgroups.txt
--- a/Documentation/cgroups/cgroups.txt~cgroups-subsystem-module-loading-interface
+++ a/Documentation/cgroups/cgroups.txt
@@ -488,6 +488,10 @@ Each subsystem should:
 - add an entry in linux/cgroup_subsys.h
 - define a cgroup_subsys object called <name>_subsys
 
+If a subsystem can be compiled as a module, it should also have in its
+module initcall a call to cgroup_load_subsys(&its_subsys_struct). It
+should also set its_subsys.module = THIS_MODULE in its .c file.
+
 Each subsystem may export the following methods. The only mandatory
 methods are create/destroy. Any others that are null are presumed to
 be successful no-ops.
diff -puN include/linux/cgroup.h~cgroups-subsystem-module-loading-interface include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-subsystem-module-loading-interface
+++ a/include/linux/cgroup.h
@@ -37,6 +37,7 @@ extern void cgroup_post_fork(struct task
 extern void cgroup_exit(struct task_struct *p, int run_callbacks);
 extern int cgroupstats_build(struct cgroupstats *stats,
 				struct dentry *dentry);
+extern int cgroup_load_subsys(struct cgroup_subsys *ss);
 
 extern const struct file_operations proc_cgroup_operations;
 
@@ -486,6 +487,9 @@ struct cgroup_subsys {
 	/* used when use_id == true */
 	struct idr idr;
 	spinlock_t id_lock;
+
+	/* should be defined only by modular subsystems */
+	struct module *module;
 };
 
 #define SUBSYS(_x) extern struct cgroup_subsys _x ## _subsys;
diff -puN kernel/cgroup.c~cgroups-subsystem-module-loading-interface kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-subsystem-module-loading-interface
+++ a/kernel/cgroup.c
@@ -44,6 +44,7 @@
 #include <linux/string.h>
 #include <linux/sort.h>
 #include <linux/kmod.h>
+#include <linux/module.h>
 #include <linux/delayacct.h>
 #include <linux/cgroupstats.h>
 #include <linux/hash.h>
@@ -254,7 +255,8 @@ struct cg_cgroup_link {
 static struct css_set init_css_set;
 static struct cg_cgroup_link init_css_set_link;
 
-static int cgroup_subsys_init_idr(struct cgroup_subsys *ss);
+static int cgroup_init_idr(struct cgroup_subsys *ss,
+			   struct cgroup_subsys_state *css);
 
 /* css_set_lock protects the list of css_set objects, and the
  * chain of tasks off each css_set.  Nests outside task->alloc_lock
@@ -2125,6 +2127,7 @@ int cgroup_add_file(struct cgroup *cgrp,
 		error = PTR_ERR(dentry);
 	return error;
 }
+EXPORT_SYMBOL_GPL(cgroup_add_file);
 
 int cgroup_add_files(struct cgroup *cgrp,
 			struct cgroup_subsys *subsys,
@@ -2139,6 +2142,7 @@ int cgroup_add_files(struct cgroup *cgrp
 	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cgroup_add_files);
 
 /**
  * cgroup_task_count - count the number of tasks in a cgroup.
@@ -3292,7 +3296,144 @@ static void __init cgroup_init_subsys(st
 	mutex_init(&ss->hierarchy_mutex);
 	lockdep_set_class(&ss->hierarchy_mutex, &ss->subsys_key);
 	ss->active = 1;
+
+	/* this function shouldn't be used with modular subsystems, since they
+	 * need to register a subsys_id, among other things */
+	BUG_ON(ss->module);
+}
+
+/**
+ * cgroup_load_subsys: load and register a modular subsystem at runtime
+ * @ss: the subsystem to load
+ *
+ * This function should be called in a modular subsystem's initcall. If the
+ * subsytem is built as a module, it will be assigned a new subsys_id and set
+ * up for use. If the subsystem is built-in anyway, work is delegated to the
+ * simpler cgroup_init_subsys.
+ */
+int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
+{
+	int i;
+	struct cgroup_subsys_state *css;
+
+	/* check name and function validity */
+	if (ss->name == NULL || strlen(ss->name) > MAX_CGROUP_TYPE_NAMELEN ||
+	    ss->create == NULL || ss->destroy == NULL)
+		return -EINVAL;
+
+	/*
+	 * we don't support callbacks in modular subsystems. this check is
+	 * before the ss->module check for consistency; a subsystem that could
+	 * be a module should still have no callbacks even if the user isn't
+	 * compiling it as one.
+	 */
+	if (ss->fork || ss->exit)
+		return -EINVAL;
+
+	/*
+	 * an optionally modular subsystem is built-in: we want to do nothing,
+	 * since cgroup_init_subsys will have already taken care of it.
+	 */
+	if (ss->module == NULL) {
+		/* a few sanity checks */
+		BUG_ON(ss->subsys_id >= CGROUP_BUILTIN_SUBSYS_COUNT);
+		BUG_ON(subsys[ss->subsys_id] != ss);
+		return 0;
+	}
+
+	/*
+	 * need to register a subsys id before anything else - for example,
+	 * init_cgroup_css needs it.
+	 */
+	mutex_lock(&cgroup_mutex);
+	/* find the first empty slot in the array */
+	for (i = CGROUP_BUILTIN_SUBSYS_COUNT; i < CGROUP_SUBSYS_COUNT; i++) {
+		if (subsys[i] == NULL)
+			break;
+	}
+	if (i == CGROUP_SUBSYS_COUNT) {
+		/* maximum number of subsystems already registered! */
+		mutex_unlock(&cgroup_mutex);
+		return -EBUSY;
+	}
+	/* assign ourselves the subsys_id */
+	ss->subsys_id = i;
+	subsys[i] = ss;
+
+	/*
+	 * no ss->create seems to need anything important in the ss struct, so
+	 * this can happen first (i.e. before the rootnode attachment).
+	 */
+	css = ss->create(ss, dummytop);
+	if (IS_ERR(css)) {
+		/* failure case - need to deassign the subsys[] slot. */
+		subsys[i] = NULL;
+		mutex_unlock(&cgroup_mutex);
+		return PTR_ERR(css);
+	}
+
+	list_add(&ss->sibling, &rootnode.subsys_list);
+	ss->root = &rootnode;
+
+	/* our new subsystem will be attached to the dummy hierarchy. */
+	init_cgroup_css(css, ss, dummytop);
+	/* init_idr must be after init_cgroup_css because it sets css->id. */
+	if (ss->use_id) {
+		int ret = cgroup_init_idr(ss, css);
+		if (ret) {
+			dummytop->subsys[ss->subsys_id] = NULL;
+			ss->destroy(ss, dummytop);
+			subsys[i] = NULL;
+			mutex_unlock(&cgroup_mutex);
+			return ret;
+		}
+	}
+
+	/*
+	 * Now we need to entangle the css into the existing css_sets. unlike
+	 * in cgroup_init_subsys, there are now multiple css_sets, so each one
+	 * will need a new pointer to it; done by iterating the css_set_table.
+	 * furthermore, modifying the existing css_sets will corrupt the hash
+	 * table state, so each changed css_set will need its hash recomputed.
+	 * this is all done under the css_set_lock.
+	 */
+	write_lock(&css_set_lock);
+	for (i = 0; i < CSS_SET_TABLE_SIZE; i++) {
+		struct css_set *cg;
+		struct hlist_node *node, *tmp;
+		struct hlist_head *bucket = &css_set_table[i], *new_bucket;
+
+		hlist_for_each_entry_safe(cg, node, tmp, bucket, hlist) {
+			/* skip entries that we already rehashed */
+			if (cg->subsys[ss->subsys_id])
+				continue;
+			/* remove existing entry */
+			hlist_del(&cg->hlist);
+			/* set new value */
+			cg->subsys[ss->subsys_id] = css;
+			/* recompute hash and restore entry */
+			new_bucket = css_set_hash(cg->subsys);
+			hlist_add_head(&cg->hlist, new_bucket);
+		}
+	}
+	write_unlock(&css_set_lock);
+
+	mutex_init(&ss->hierarchy_mutex);
+	lockdep_set_class(&ss->hierarchy_mutex, &ss->subsys_key);
+	ss->active = 1;
+
+	/*
+	 * pin the subsystem's module so it doesn't go away. this shouldn't
+	 * fail, since the module's initcall calls us.
+	 * TODO: with module unloading, move this elsewhere
+	 */
+	BUG_ON(!try_module_get(ss->module));
+
+	/* success! */
+	mutex_unlock(&cgroup_mutex);
+	return 0;
 }
+EXPORT_SYMBOL_GPL(cgroup_load_subsys);
 
 /**
  * cgroup_init_early - cgroup initialization at system boot
@@ -3364,7 +3505,7 @@ int __init cgroup_init(void)
 		if (!ss->early_init)
 			cgroup_init_subsys(ss);
 		if (ss->use_id)
-			cgroup_subsys_init_idr(ss);
+			cgroup_init_idr(ss, init_css_set.subsys[ss->subsys_id]);
 	}
 
 	/* Add init_css_set to the hash table */
@@ -4033,15 +4174,14 @@ err_out:
 
 }
 
-static int __init cgroup_subsys_init_idr(struct cgroup_subsys *ss)
+static int __init_or_module cgroup_init_idr(struct cgroup_subsys *ss,
+					    struct cgroup_subsys_state *rootcss)
 {
 	struct css_id *newid;
-	struct cgroup_subsys_state *rootcss;
 
 	spin_lock_init(&ss->id_lock);
 	idr_init(&ss->idr);
 
-	rootcss = init_css_set.subsys[ss->subsys_id];
 	newid = get_new_cssid(ss, 0);
 	if (IS_ERR(newid))
 		return PTR_ERR(newid);
_

Patches currently in -mm which might be from bblum@andrew.cmu.edu are

origin.patch
cgroups-net_cls-as-module.patch

