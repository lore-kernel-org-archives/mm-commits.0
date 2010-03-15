From: akpm@linux-foundation.org
Subject: [merged] cgroups-blkio-subsystem-as-module.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:58:35 -0400
Message-ID: <201003150659.o2F6x8Sp016505@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935633Ab0COG7v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:59:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bblum@andrew.cmu.edu, davem@davemloft.net, jens.axboe@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, vgoyal@redhat.com, mm-c


The patch titled
     cgroups: blkio subsystem as module
has been removed from the -mm tree.  Its filename was
     cgroups-blkio-subsystem-as-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: blkio subsystem as module
From: Ben Blum <bblum@andrew.cmu.edu>

Modify the Block I/O cgroup subsystem to be able to be built as a module. 
As the CFQ disk scheduler optionally depends on blk-cgroup, config options
in block/Kconfig, block/Kconfig.iosched, and block/blk-cgroup.h are
enhanced to support the new module dependency.

Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/Kconfig             |    2 -
 block/Kconfig.iosched     |    2 -
 block/blk-cgroup.c        |   53 +++++++++++++++++++++++++++---------
 block/blk-cgroup.h        |   10 +++++-
 include/linux/iocontext.h |    2 -
 kernel/cgroup.c           |    9 ++++++
 6 files changed, 61 insertions(+), 17 deletions(-)

diff -puN block/Kconfig~cgroups-blkio-subsystem-as-module block/Kconfig
--- a/block/Kconfig~cgroups-blkio-subsystem-as-module
+++ a/block/Kconfig
@@ -78,7 +78,7 @@ config BLK_DEV_INTEGRITY
 	Protection.  If in doubt, say N.
 
 config BLK_CGROUP
-	bool
+	tristate
 	depends on CGROUPS
 	default n
 	---help---
diff -puN block/Kconfig.iosched~cgroups-blkio-subsystem-as-module block/Kconfig.iosched
--- a/block/Kconfig.iosched~cgroups-blkio-subsystem-as-module
+++ a/block/Kconfig.iosched
@@ -23,6 +23,7 @@ config IOSCHED_DEADLINE
 
 config IOSCHED_CFQ
 	tristate "CFQ I/O scheduler"
+	select BLK_CGROUP if CFQ_GROUP_IOSCHED
 	default y
 	---help---
 	  The CFQ I/O scheduler tries to distribute bandwidth equally
@@ -35,7 +36,6 @@ config IOSCHED_CFQ
 config CFQ_GROUP_IOSCHED
 	bool "CFQ Group Scheduling support"
 	depends on IOSCHED_CFQ && CGROUPS
-	select BLK_CGROUP
 	default n
 	---help---
 	  Enable group IO scheduling in CFQ.
diff -puN block/blk-cgroup.c~cgroups-blkio-subsystem-as-module block/blk-cgroup.c
--- a/block/blk-cgroup.c~cgroups-blkio-subsystem-as-module
+++ a/block/blk-cgroup.c
@@ -23,6 +23,31 @@ static LIST_HEAD(blkio_list);
 struct blkio_cgroup blkio_root_cgroup = { .weight = 2*BLKIO_WEIGHT_DEFAULT };
 EXPORT_SYMBOL_GPL(blkio_root_cgroup);
 
+static struct cgroup_subsys_state *blkiocg_create(struct cgroup_subsys *,
+						  struct cgroup *);
+static int blkiocg_can_attach(struct cgroup_subsys *, struct cgroup *,
+			      struct task_struct *, bool);
+static void blkiocg_attach(struct cgroup_subsys *, struct cgroup *,
+			   struct cgroup *, struct task_struct *, bool);
+static void blkiocg_destroy(struct cgroup_subsys *, struct cgroup *);
+static int blkiocg_populate(struct cgroup_subsys *, struct cgroup *);
+
+struct cgroup_subsys blkio_subsys = {
+	.name = "blkio",
+	.create = blkiocg_create,
+	.can_attach = blkiocg_can_attach,
+	.attach = blkiocg_attach,
+	.destroy = blkiocg_destroy,
+	.populate = blkiocg_populate,
+#ifdef CONFIG_BLK_CGROUP
+	/* note: blkio_subsys_id is otherwise defined in blk-cgroup.h */
+	.subsys_id = blkio_subsys_id,
+#endif
+	.use_id = 1,
+	.module = THIS_MODULE,
+};
+EXPORT_SYMBOL_GPL(blkio_subsys);
+
 struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup)
 {
 	return container_of(cgroup_subsys_state(cgroup, blkio_subsys_id),
@@ -253,7 +278,8 @@ remove_entry:
 done:
 	free_css_id(&blkio_subsys, &blkcg->css);
 	rcu_read_unlock();
-	kfree(blkcg);
+	if (blkcg != &blkio_root_cgroup)
+		kfree(blkcg);
 }
 
 static struct cgroup_subsys_state *
@@ -319,17 +345,6 @@ static void blkiocg_attach(struct cgroup
 	task_unlock(tsk);
 }
 
-struct cgroup_subsys blkio_subsys = {
-	.name = "blkio",
-	.create = blkiocg_create,
-	.can_attach = blkiocg_can_attach,
-	.attach = blkiocg_attach,
-	.destroy = blkiocg_destroy,
-	.populate = blkiocg_populate,
-	.subsys_id = blkio_subsys_id,
-	.use_id = 1,
-};
-
 void blkio_policy_register(struct blkio_policy_type *blkiop)
 {
 	spin_lock(&blkio_list_lock);
@@ -345,3 +360,17 @@ void blkio_policy_unregister(struct blki
 	spin_unlock(&blkio_list_lock);
 }
 EXPORT_SYMBOL_GPL(blkio_policy_unregister);
+
+static int __init init_cgroup_blkio(void)
+{
+	return cgroup_load_subsys(&blkio_subsys);
+}
+
+static void __exit exit_cgroup_blkio(void)
+{
+	cgroup_unload_subsys(&blkio_subsys);
+}
+
+module_init(init_cgroup_blkio);
+module_exit(exit_cgroup_blkio);
+MODULE_LICENSE("GPL");
diff -puN block/blk-cgroup.h~cgroups-blkio-subsystem-as-module block/blk-cgroup.h
--- a/block/blk-cgroup.h~cgroups-blkio-subsystem-as-module
+++ a/block/blk-cgroup.h
@@ -15,7 +15,13 @@
 
 #include <linux/cgroup.h>
 
-#ifdef CONFIG_BLK_CGROUP
+#if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
+
+#ifndef CONFIG_BLK_CGROUP
+/* When blk-cgroup is a module, its subsys_id isn't a compile-time constant */
+extern struct cgroup_subsys blkio_subsys;
+#define blkio_subsys_id blkio_subsys.subsys_id
+#endif
 
 struct blkio_cgroup {
 	struct cgroup_subsys_state css;
@@ -91,7 +97,7 @@ static inline void blkiocg_update_blkio_
 			struct blkio_group *blkg, unsigned long dequeue) {}
 #endif
 
-#ifdef CONFIG_BLK_CGROUP
+#if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
 extern struct blkio_cgroup blkio_root_cgroup;
 extern struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup);
 extern void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
diff -puN include/linux/iocontext.h~cgroups-blkio-subsystem-as-module include/linux/iocontext.h
--- a/include/linux/iocontext.h~cgroups-blkio-subsystem-as-module
+++ a/include/linux/iocontext.h
@@ -42,7 +42,7 @@ struct io_context {
 	unsigned short ioprio;
 	unsigned short ioprio_changed;
 
-#ifdef CONFIG_BLK_CGROUP
+#if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
 	unsigned short cgroup_changed;
 #endif
 
diff -puN kernel/cgroup.c~cgroups-blkio-subsystem-as-module kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-blkio-subsystem-as-module
+++ a/kernel/cgroup.c
@@ -705,6 +705,7 @@ void cgroup_lock(void)
 {
 	mutex_lock(&cgroup_mutex);
 }
+EXPORT_SYMBOL_GPL(cgroup_lock);
 
 /**
  * cgroup_unlock - release lock on cgroup changes
@@ -715,6 +716,7 @@ void cgroup_unlock(void)
 {
 	mutex_unlock(&cgroup_mutex);
 }
+EXPORT_SYMBOL_GPL(cgroup_unlock);
 
 /*
  * A couple of forward declarations required, due to cyclic reference loop:
@@ -1639,6 +1641,7 @@ int cgroup_path(const struct cgroup *cgr
 	memmove(buf, start, buf + buflen - start);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cgroup_path);
 
 /**
  * cgroup_attach_task - attach task 'tsk' to cgroup 'cgrp'
@@ -1805,6 +1808,7 @@ bool cgroup_lock_live_group(struct cgrou
 	}
 	return true;
 }
+EXPORT_SYMBOL_GPL(cgroup_lock_live_group);
 
 static int cgroup_release_agent_write(struct cgroup *cgrp, struct cftype *cft,
 				      const char *buffer)
@@ -4082,6 +4086,7 @@ void __css_put(struct cgroup_subsys_stat
 	rcu_read_unlock();
 	WARN_ON_ONCE(val < 1);
 }
+EXPORT_SYMBOL_GPL(__css_put);
 
 /*
  * Notify userspace when a cgroup is released, by running the
@@ -4197,6 +4202,7 @@ unsigned short css_id(struct cgroup_subs
 		return cssid->id;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(css_id);
 
 unsigned short css_depth(struct cgroup_subsys_state *css)
 {
@@ -4206,6 +4212,7 @@ unsigned short css_depth(struct cgroup_s
 		return cssid->depth;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(css_depth);
 
 bool css_is_ancestor(struct cgroup_subsys_state *child,
 		    const struct cgroup_subsys_state *root)
@@ -4242,6 +4249,7 @@ void free_css_id(struct cgroup_subsys *s
 	spin_unlock(&ss->id_lock);
 	call_rcu(&id->rcu_head, __free_css_id_cb);
 }
+EXPORT_SYMBOL_GPL(free_css_id);
 
 /*
  * This is called by init or create(). Then, calls to this function are
@@ -4358,6 +4366,7 @@ struct cgroup_subsys_state *css_lookup(s
 
 	return rcu_dereference(cssid->css);
 }
+EXPORT_SYMBOL_GPL(css_lookup);
 
 /**
  * css_get_next - lookup next cgroup under specified hierarchy.
_

Patches currently in -mm which might be from bblum@andrew.cmu.edu are

origin.patch
cgroups-net_cls-as-module.patch

