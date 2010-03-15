From: akpm@linux-foundation.org
Subject: [merged] cgroups-subsystem-module-unloading.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:58:24 -0400
Message-ID: <201003150658.o2F6wwPB016496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934472Ab0COG7j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:59:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bblum@andrew.cmu.edu, davem@davemloft.net, kamezawa.hiroyu@jp.fujitsu.com, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: subsystem module unloading
has been removed from the -mm tree.  Its filename was
     cgroups-subsystem-module-unloading.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: subsystem module unloading
From: Ben Blum <bblum@andrew.cmu.edu>

Provides support for unloading modular subsystems.

This patch adds a new function cgroup_unload_subsys which is to be used
for removing a loaded subsystem during module deletion.  Reference
counting of the subsystems' modules is moved from once (at load time) to
once per attached hierarchy (in parse_cgroupfs_options and
rebind_subsystems) (i.e., 0 or 1).

Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cgroups.txt |    5 
 include/linux/cgroup.h            |    4 
 kernel/cgroup.c                   |  167 +++++++++++++++++++++++-----
 3 files changed, 148 insertions(+), 28 deletions(-)

diff -puN Documentation/cgroups/cgroups.txt~cgroups-subsystem-module-unloading Documentation/cgroups/cgroups.txt
--- a/Documentation/cgroups/cgroups.txt~cgroups-subsystem-module-unloading
+++ a/Documentation/cgroups/cgroups.txt
@@ -489,8 +489,9 @@ Each subsystem should:
 - define a cgroup_subsys object called <name>_subsys
 
 If a subsystem can be compiled as a module, it should also have in its
-module initcall a call to cgroup_load_subsys(&its_subsys_struct). It
-should also set its_subsys.module = THIS_MODULE in its .c file.
+module initcall a call to cgroup_load_subsys(), and in its exitcall a
+call to cgroup_unload_subsys(). It should also set its_subsys.module =
+THIS_MODULE in its .c file.
 
 Each subsystem may export the following methods. The only mandatory
 methods are create/destroy. Any others that are null are presumed to
diff -puN include/linux/cgroup.h~cgroups-subsystem-module-unloading include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-subsystem-module-unloading
+++ a/include/linux/cgroup.h
@@ -38,6 +38,7 @@ extern void cgroup_exit(struct task_stru
 extern int cgroupstats_build(struct cgroupstats *stats,
 				struct dentry *dentry);
 extern int cgroup_load_subsys(struct cgroup_subsys *ss);
+extern void cgroup_unload_subsys(struct cgroup_subsys *ss);
 
 extern const struct file_operations proc_cgroup_operations;
 
@@ -271,7 +272,8 @@ struct css_set {
 	/*
 	 * Set of subsystem states, one for each subsystem. This array
 	 * is immutable after creation apart from the init_css_set
-	 * during subsystem registration (at boot time).
+	 * during subsystem registration (at boot time) and modular subsystem
+	 * loading/unloading.
 	 */
 	struct cgroup_subsys_state *subsys[CGROUP_SUBSYS_COUNT];
 
diff -puN kernel/cgroup.c~cgroups-subsystem-module-unloading kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-subsystem-module-unloading
+++ a/kernel/cgroup.c
@@ -894,7 +894,9 @@ void cgroup_release_and_wakeup_rmdir(str
 }
 
 /*
- * Call with cgroup_mutex held.
+ * Call with cgroup_mutex held. Drops reference counts on modules, including
+ * any duplicate ones that parse_cgroupfs_options took. If this function
+ * returns an error, no reference counts are touched.
  */
 static int rebind_subsystems(struct cgroupfs_root *root,
 			      unsigned long final_bits)
@@ -950,6 +952,7 @@ static int rebind_subsystems(struct cgro
 			if (ss->bind)
 				ss->bind(ss, cgrp);
 			mutex_unlock(&ss->hierarchy_mutex);
+			/* refcount was already taken, and we're keeping it */
 		} else if (bit & removed_bits) {
 			/* We're removing this subsystem */
 			BUG_ON(ss == NULL);
@@ -963,10 +966,20 @@ static int rebind_subsystems(struct cgro
 			subsys[i]->root = &rootnode;
 			list_move(&ss->sibling, &rootnode.subsys_list);
 			mutex_unlock(&ss->hierarchy_mutex);
+			/* subsystem is now free - drop reference on module */
+			module_put(ss->module);
 		} else if (bit & final_bits) {
 			/* Subsystem state should already exist */
 			BUG_ON(ss == NULL);
 			BUG_ON(!cgrp->subsys[i]);
+			/*
+			 * a refcount was taken, but we already had one, so
+			 * drop the extra reference.
+			 */
+			module_put(ss->module);
+#ifdef CONFIG_MODULE_UNLOAD
+			BUG_ON(ss->module && !module_refcount(ss->module));
+#endif
 		} else {
 			/* Subsystem state shouldn't exist */
 			BUG_ON(cgrp->subsys[i]);
@@ -1010,13 +1023,16 @@ struct cgroup_sb_opts {
 
 /*
  * Convert a hierarchy specifier into a bitmask of subsystems and flags. Call
- * with cgroup_mutex held to protect the subsys[] array.
+ * with cgroup_mutex held to protect the subsys[] array. This function takes
+ * refcounts on subsystems to be used, unless it returns error, in which case
+ * no refcounts are taken.
  */
-static int parse_cgroupfs_options(char *data,
-				     struct cgroup_sb_opts *opts)
+static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 {
 	char *token, *o = data ?: "all";
 	unsigned long mask = (unsigned long)-1;
+	int i;
+	bool module_pin_failed = false;
 
 	BUG_ON(!mutex_is_locked(&cgroup_mutex));
 
@@ -1031,7 +1047,6 @@ static int parse_cgroupfs_options(char *
 			return -EINVAL;
 		if (!strcmp(token, "all")) {
 			/* Add all non-disabled subsystems */
-			int i;
 			opts->subsys_bits = 0;
 			for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 				struct cgroup_subsys *ss = subsys[i];
@@ -1054,7 +1069,6 @@ static int parse_cgroupfs_options(char *
 			if (!opts->release_agent)
 				return -ENOMEM;
 		} else if (!strncmp(token, "name=", 5)) {
-			int i;
 			const char *name = token + 5;
 			/* Can't specify an empty name */
 			if (!strlen(name))
@@ -1078,7 +1092,6 @@ static int parse_cgroupfs_options(char *
 				return -ENOMEM;
 		} else {
 			struct cgroup_subsys *ss;
-			int i;
 			for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 				ss = subsys[i];
 				if (ss == NULL)
@@ -1117,9 +1130,54 @@ static int parse_cgroupfs_options(char *
 	if (!opts->subsys_bits && !opts->name)
 		return -EINVAL;
 
+	/*
+	 * Grab references on all the modules we'll need, so the subsystems
+	 * don't dance around before rebind_subsystems attaches them. This may
+	 * take duplicate reference counts on a subsystem that's already used,
+	 * but rebind_subsystems handles this case.
+	 */
+	for (i = CGROUP_BUILTIN_SUBSYS_COUNT; i < CGROUP_SUBSYS_COUNT; i++) {
+		unsigned long bit = 1UL << i;
+
+		if (!(bit & opts->subsys_bits))
+			continue;
+		if (!try_module_get(subsys[i]->module)) {
+			module_pin_failed = true;
+			break;
+		}
+	}
+	if (module_pin_failed) {
+		/*
+		 * oops, one of the modules was going away. this means that we
+		 * raced with a module_delete call, and to the user this is
+		 * essentially a "subsystem doesn't exist" case.
+		 */
+		for (i--; i >= CGROUP_BUILTIN_SUBSYS_COUNT; i--) {
+			/* drop refcounts only on the ones we took */
+			unsigned long bit = 1UL << i;
+
+			if (!(bit & opts->subsys_bits))
+				continue;
+			module_put(subsys[i]->module);
+		}
+		return -ENOENT;
+	}
+
 	return 0;
 }
 
+static void drop_parsed_module_refcounts(unsigned long subsys_bits)
+{
+	int i;
+	for (i = CGROUP_BUILTIN_SUBSYS_COUNT; i < CGROUP_SUBSYS_COUNT; i++) {
+		unsigned long bit = 1UL << i;
+
+		if (!(bit & subsys_bits))
+			continue;
+		module_put(subsys[i]->module);
+	}
+}
+
 static int cgroup_remount(struct super_block *sb, int *flags, char *data)
 {
 	int ret = 0;
@@ -1136,21 +1194,19 @@ static int cgroup_remount(struct super_b
 	if (ret)
 		goto out_unlock;
 
-	/* Don't allow flags to change at remount */
-	if (opts.flags != root->flags) {
-		ret = -EINVAL;
-		goto out_unlock;
-	}
-
-	/* Don't allow name to change at remount */
-	if (opts.name && strcmp(opts.name, root->name)) {
+	/* Don't allow flags or name to change at remount */
+	if (opts.flags != root->flags ||
+	    (opts.name && strcmp(opts.name, root->name))) {
 		ret = -EINVAL;
+		drop_parsed_module_refcounts(opts.subsys_bits);
 		goto out_unlock;
 	}
 
 	ret = rebind_subsystems(root, opts.subsys_bits);
-	if (ret)
+	if (ret) {
+		drop_parsed_module_refcounts(opts.subsys_bits);
 		goto out_unlock;
+	}
 
 	/* (re)populate subsystem files */
 	cgroup_populate_dir(cgrp);
@@ -1349,7 +1405,7 @@ static int cgroup_get_sb(struct file_sys
 	new_root = cgroup_root_from_opts(&opts);
 	if (IS_ERR(new_root)) {
 		ret = PTR_ERR(new_root);
-		goto out_err;
+		goto drop_modules;
 	}
 	opts.new_root = new_root;
 
@@ -1358,7 +1414,7 @@ static int cgroup_get_sb(struct file_sys
 	if (IS_ERR(sb)) {
 		ret = PTR_ERR(sb);
 		cgroup_drop_root(opts.new_root);
-		goto out_err;
+		goto drop_modules;
 	}
 
 	root = sb->s_fs_info;
@@ -1414,6 +1470,11 @@ static int cgroup_get_sb(struct file_sys
 			free_cg_links(&tmp_cg_links);
 			goto drop_new_super;
 		}
+		/*
+		 * There must be no failure case after here, since rebinding
+		 * takes care of subsystems' refcounts, which are explicitly
+		 * dropped in the failure exit path.
+		 */
 
 		/* EBUSY should be the only error here */
 		BUG_ON(ret);
@@ -1452,6 +1513,8 @@ static int cgroup_get_sb(struct file_sys
 		 * any) is not needed
 		 */
 		cgroup_drop_root(opts.new_root);
+		/* no subsys rebinding, so refcounts don't change */
+		drop_parsed_module_refcounts(opts.subsys_bits);
 	}
 
 	simple_set_mnt(mnt, sb);
@@ -1461,6 +1524,8 @@ static int cgroup_get_sb(struct file_sys
 
  drop_new_super:
 	deactivate_locked_super(sb);
+ drop_modules:
+	drop_parsed_module_refcounts(opts.subsys_bits);
  out_err:
 	kfree(opts.release_agent);
 	kfree(opts.name);
@@ -3422,13 +3487,6 @@ int __init_or_module cgroup_load_subsys(
 	lockdep_set_class(&ss->hierarchy_mutex, &ss->subsys_key);
 	ss->active = 1;
 
-	/*
-	 * pin the subsystem's module so it doesn't go away. this shouldn't
-	 * fail, since the module's initcall calls us.
-	 * TODO: with module unloading, move this elsewhere
-	 */
-	BUG_ON(!try_module_get(ss->module));
-
 	/* success! */
 	mutex_unlock(&cgroup_mutex);
 	return 0;
@@ -3436,6 +3494,65 @@ int __init_or_module cgroup_load_subsys(
 EXPORT_SYMBOL_GPL(cgroup_load_subsys);
 
 /**
+ * cgroup_unload_subsys: unload a modular subsystem
+ * @ss: the subsystem to unload
+ *
+ * This function should be called in a modular subsystem's exitcall. When this
+ * function is invoked, the refcount on the subsystem's module will be 0, so
+ * the subsystem will not be attached to any hierarchy.
+ */
+void cgroup_unload_subsys(struct cgroup_subsys *ss)
+{
+	struct cg_cgroup_link *link;
+	struct hlist_head *hhead;
+
+	BUG_ON(ss->module == NULL);
+
+	/*
+	 * we shouldn't be called if the subsystem is in use, and the use of
+	 * try_module_get in parse_cgroupfs_options should ensure that it
+	 * doesn't start being used while we're killing it off.
+	 */
+	BUG_ON(ss->root != &rootnode);
+
+	mutex_lock(&cgroup_mutex);
+	/* deassign the subsys_id */
+	BUG_ON(ss->subsys_id < CGROUP_BUILTIN_SUBSYS_COUNT);
+	subsys[ss->subsys_id] = NULL;
+
+	/* remove subsystem from rootnode's list of subsystems */
+	list_del(&ss->sibling);
+
+	/*
+	 * disentangle the css from all css_sets attached to the dummytop. as
+	 * in loading, we need to pay our respects to the hashtable gods.
+	 */
+	write_lock(&css_set_lock);
+	list_for_each_entry(link, &dummytop->css_sets, cgrp_link_list) {
+		struct css_set *cg = link->cg;
+
+		hlist_del(&cg->hlist);
+		BUG_ON(!cg->subsys[ss->subsys_id]);
+		cg->subsys[ss->subsys_id] = NULL;
+		hhead = css_set_hash(cg->subsys);
+		hlist_add_head(&cg->hlist, hhead);
+	}
+	write_unlock(&css_set_lock);
+
+	/*
+	 * remove subsystem's css from the dummytop and free it - need to free
+	 * before marking as null because ss->destroy needs the cgrp->subsys
+	 * pointer to find their state. note that this also takes care of
+	 * freeing the css_id.
+	 */
+	ss->destroy(ss, dummytop);
+	dummytop->subsys[ss->subsys_id] = NULL;
+
+	mutex_unlock(&cgroup_mutex);
+}
+EXPORT_SYMBOL_GPL(cgroup_unload_subsys);
+
+/**
  * cgroup_init_early - cgroup initialization at system boot
  *
  * Initialize cgroups at system boot, and initialize any
_

Patches currently in -mm which might be from bblum@andrew.cmu.edu are

origin.patch
cgroups-net_cls-as-module.patch

