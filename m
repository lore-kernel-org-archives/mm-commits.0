From: akpm@linux-foundation.org
Subject: [merged] staging-zcache-enable-ramster-to-be-built-loaded-as-a-module.patch removed from -mm tree
Date: Tue, 07 May 2013 10:46:48 -0700
Message-ID: <20130507174648.97A415A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:34703 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758484Ab3EGRqu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:46:50 -0400
Received: by mail-qe0-f73.google.com with SMTP id a11so85095qen.0
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:46:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.magenheimer@oracle.com, andor.daam@googlemail.com, fengguang.wu@intel.com, fschmaus@gmail.com, ilendir@googlemail.com, konrad.wilk@oracle.com, liwanp@linux.vnet.ibm.com, lliubbo@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: staging: zcache: enable ramster to be built/loaded as a module
has been removed from the -mm tree.  Its filename was
     staging-zcache-enable-ramster-to-be-built-loaded-as-a-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: staging: zcache: enable ramster to be built/loaded as a module

Enable module support for ramster.  Note runtime dependency disallows
loading if cleancache/frontswap lazy initialization patches are not
present.

If built-in (not built as a module), the original mechanism of enabling via
a kernel boot parameter is retained, but this should be considered deprecated.

Note that module unload is explicitly not yet supported.

[v1: Fixed compile issues since ramster_init now has four arguments]
[v2: Fixed rebase on ramster->zcache move]
[akpm@linux-foundation.org: use_frontswap_selfshrink cannot be __initdata]
Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andor Daam <andor.daam@googlemail.com>
Cc: Florian Schmaus <fschmaus@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Stefan Hengelein <ilendir@googlemail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/zcache/ramster.h                     |    6 +-
 drivers/staging/zcache/ramster/debug.c               |    2 
 drivers/staging/zcache/ramster/nodemanager.c         |    9 +--
 drivers/staging/zcache/ramster/ramster.c             |   29 ++++++++--
 drivers/staging/zcache/ramster/ramster.h             |    2 
 drivers/staging/zcache/ramster/ramster_nodemanager.h |    2 
 drivers/staging/zcache/zcache-main.c                 |    2 
 7 files changed, 39 insertions(+), 13 deletions(-)

diff -puN drivers/staging/zcache/ramster.h~staging-zcache-enable-ramster-to-be-built-loaded-as-a-module drivers/staging/zcache/ramster.h
--- a/drivers/staging/zcache/ramster.h~staging-zcache-enable-ramster-to-be-built-loaded-as-a-module
+++ a/drivers/staging/zcache/ramster.h
@@ -11,10 +11,14 @@
 #ifndef _ZCACHE_RAMSTER_H_
 #define _ZCACHE_RAMSTER_H_
 
+#ifdef CONFIG_RAMSTER_MODULE
+#define CONFIG_RAMSTER
+#endif
+
 #ifdef CONFIG_RAMSTER
 #include "ramster/ramster.h"
 #else
-static inline void ramster_init(bool x, bool y, bool z)
+static inline void ramster_init(bool x, bool y, bool z, bool w)
 {
 }
 
diff -puN drivers/staging/zcache/ramster/debug.c~staging-zcache-enable-ramster-to-be-built-loaded-as-a-module drivers/staging/zcache/ramster/debug.c
--- a/drivers/staging/zcache/ramster/debug.c~staging-zcache-enable-ramster-to-be-built-loaded-as-a-module
+++ a/drivers/staging/zcache/ramster/debug.c
@@ -43,7 +43,7 @@ static struct debug_entry {
 };
 #undef ATTR
 
-int __init ramster_debugfs_init(void)
+int ramster_debugfs_init(void)
 {
 	int i;
 	struct dentry *root = debugfs_create_dir("ramster", NULL);
diff -puN drivers/staging/zcache/ramster/nodemanager.c~staging-zcache-enable-ramster-to-be-built-loaded-as-a-module drivers/staging/zcache/ramster/nodemanager.c
--- a/drivers/staging/zcache/ramster/nodemanager.c~staging-zcache-enable-ramster-to-be-built-loaded-as-a-module
+++ a/drivers/staging/zcache/ramster/nodemanager.c
@@ -949,7 +949,7 @@ static void __exit exit_r2nm(void)
 	r2hb_exit();
 }
 
-static int __init init_r2nm(void)
+int r2nm_init(void)
 {
 	int ret = -1;
 
@@ -986,10 +986,11 @@ out_r2hb:
 out:
 	return ret;
 }
+EXPORT_SYMBOL_GPL(r2nm_init);
 
 MODULE_AUTHOR("Oracle");
 MODULE_LICENSE("GPL");
 
-/* module_init(init_r2nm) */
-late_initcall(init_r2nm);
-/* module_exit(exit_r2nm) */
+#ifndef CONFIG_RAMSTER_MODULE
+late_initcall(r2nm_init);
+#endif
diff -puN drivers/staging/zcache/ramster/ramster.c~staging-zcache-enable-ramster-to-be-built-loaded-as-a-module drivers/staging/zcache/ramster/ramster.c
--- a/drivers/staging/zcache/ramster/ramster.c~staging-zcache-enable-ramster-to-be-built-loaded-as-a-module
+++ a/drivers/staging/zcache/ramster/ramster.c
@@ -121,6 +121,7 @@ int ramster_do_preload_flnode(struct tme
 		kmem_cache_free(ramster_flnode_cache, flnode);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ramster_do_preload_flnode);
 
 /*
  * Called by the message handler after a (still compressed) page has been
@@ -388,6 +389,7 @@ void *ramster_pampd_free(void *pampd, st
 	}
 	return local_pampd;
 }
+EXPORT_SYMBOL_GPL(ramster_pampd_free);
 
 void ramster_count_foreign_pages(bool eph, int count)
 {
@@ -408,6 +410,7 @@ void ramster_count_foreign_pages(bool ep
 		}
 	}
 }
+EXPORT_SYMBOL_GPL(ramster_count_foreign_pages);
 
 /*
  * For now, just push over a few pages every few seconds to
@@ -593,7 +596,7 @@ requeue:
 	ramster_remotify_queue_delayed_work(HZ);
 }
 
-void __init ramster_remotify_init(void)
+void ramster_remotify_init(void)
 {
 	unsigned long n = 60UL;
 	ramster_remotify_workqueue =
@@ -768,8 +771,10 @@ static bool frontswap_selfshrinking __re
 static void selfshrink_process(struct work_struct *work);
 static DECLARE_DELAYED_WORK(selfshrink_worker, selfshrink_process);
 
+#ifndef CONFIG_RAMSTER_MODULE
 /* Enable/disable with kernel boot option. */
-static bool use_frontswap_selfshrink __initdata = true;
+static bool use_frontswap_selfshrink = true;
+#endif
 
 /*
  * The default values for the following parameters were deemed reasonable
@@ -824,6 +829,7 @@ static void frontswap_selfshrink(void)
 	frontswap_shrink(tgt_frontswap_pages);
 }
 
+#ifndef CONFIG_RAMSTER_MODULE
 static int __init ramster_nofrontswap_selfshrink_setup(char *s)
 {
 	use_frontswap_selfshrink = false;
@@ -831,6 +837,7 @@ static int __init ramster_nofrontswap_se
 }
 
 __setup("noselfshrink", ramster_nofrontswap_selfshrink_setup);
+#endif
 
 static void selfshrink_process(struct work_struct *work)
 {
@@ -849,6 +856,7 @@ void ramster_cpu_up(int cpu)
 	per_cpu(ramster_remoteputmem1, cpu) = p1;
 	per_cpu(ramster_remoteputmem2, cpu) = p2;
 }
+EXPORT_SYMBOL_GPL(ramster_cpu_up);
 
 void ramster_cpu_down(int cpu)
 {
@@ -864,6 +872,7 @@ void ramster_cpu_down(int cpu)
 		kp->flnode = NULL;
 	}
 }
+EXPORT_SYMBOL_GPL(ramster_cpu_down);
 
 void ramster_register_pamops(struct tmem_pamops *pamops)
 {
@@ -874,9 +883,11 @@ void ramster_register_pamops(struct tmem
 	pamops->repatriate = ramster_pampd_repatriate;
 	pamops->repatriate_preload = ramster_pampd_repatriate_preload;
 }
+EXPORT_SYMBOL_GPL(ramster_register_pamops);
 
-void __init ramster_init(bool cleancache, bool frontswap,
-				bool frontswap_exclusive_gets)
+void ramster_init(bool cleancache, bool frontswap,
+				bool frontswap_exclusive_gets,
+				bool frontswap_selfshrink)
 {
 	int ret = 0;
 
@@ -891,10 +902,17 @@ void __init ramster_init(bool cleancache
 	if (ret)
 		pr_err("ramster: can't create sysfs for ramster\n");
 	(void)r2net_register_handlers();
+#ifdef CONFIG_RAMSTER_MODULE
+	ret = r2nm_init();
+	if (ret)
+		pr_err("ramster: can't init r2net\n");
+	frontswap_selfshrinking = frontswap_selfshrink;
+#else
+	frontswap_selfshrinking = use_frontswap_selfshrink;
+#endif
 	INIT_LIST_HEAD(&ramster_rem_op_list);
 	ramster_flnode_cache = kmem_cache_create("ramster_flnode",
 				sizeof(struct flushlist_node), 0, 0, NULL);
-	frontswap_selfshrinking = use_frontswap_selfshrink;
 	if (frontswap_selfshrinking) {
 		pr_info("ramster: Initializing frontswap selfshrink driver.\n");
 		schedule_delayed_work(&selfshrink_worker,
@@ -902,3 +920,4 @@ void __init ramster_init(bool cleancache
 	}
 	ramster_remotify_init();
 }
+EXPORT_SYMBOL_GPL(ramster_init);
diff -puN drivers/staging/zcache/ramster/ramster.h~staging-zcache-enable-ramster-to-be-built-loaded-as-a-module drivers/staging/zcache/ramster/ramster.h
--- a/drivers/staging/zcache/ramster/ramster.h~staging-zcache-enable-ramster-to-be-built-loaded-as-a-module
+++ a/drivers/staging/zcache/ramster/ramster.h
@@ -147,7 +147,7 @@ extern int r2net_register_handlers(void)
 extern int r2net_remote_target_node_set(int);
 
 extern int ramster_remotify_pageframe(bool);
-extern void ramster_init(bool, bool, bool);
+extern void ramster_init(bool, bool, bool, bool);
 extern void ramster_register_pamops(struct tmem_pamops *);
 extern int ramster_localify(int, struct tmem_oid *oidp, uint32_t, char *,
 				unsigned int, void *);
diff -puN drivers/staging/zcache/ramster/ramster_nodemanager.h~staging-zcache-enable-ramster-to-be-built-loaded-as-a-module drivers/staging/zcache/ramster/ramster_nodemanager.h
--- a/drivers/staging/zcache/ramster/ramster_nodemanager.h~staging-zcache-enable-ramster-to-be-built-loaded-as-a-module
+++ a/drivers/staging/zcache/ramster/ramster_nodemanager.h
@@ -36,4 +36,6 @@
 /* host name, group name, cluster name all 64 bytes */
 #define R2NM_MAX_NAME_LEN        64    /* __NEW_UTS_LEN */
 
+extern int r2nm_init(void);
+
 #endif /* _RAMSTER_NODEMANAGER_H */
diff -puN drivers/staging/zcache/zcache-main.c~staging-zcache-enable-ramster-to-be-built-loaded-as-a-module drivers/staging/zcache/zcache-main.c
--- a/drivers/staging/zcache/zcache-main.c~staging-zcache-enable-ramster-to-be-built-loaded-as-a-module
+++ a/drivers/staging/zcache/zcache-main.c
@@ -1894,7 +1894,7 @@ static int __init zcache_init(void)
 	}
 	if (ramster_enabled)
 		ramster_init(!disable_cleancache, !disable_frontswap,
-				frontswap_has_exclusive_gets);
+				frontswap_has_exclusive_gets, false);
 out:
 	return ret;
 }
_

Patches currently in -mm which might be from dan.magenheimer@oracle.com are

origin.patch

