From: akpm@linux-foundation.org
Subject: - fs-dlm-proper-prototypes.patch removed from -mm tree
Date: Fri, 09 Nov 2007 11:13:04 -0800
Message-ID: <200711091913.lA9JD40u027980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58863 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755135AbXKITNg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 14:13:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, swhiteho@redhat.com, teigland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fs/dlm/: proper prototypes
has been removed from the -mm tree.  Its filename was
     fs-dlm-proper-prototypes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs/dlm/: proper prototypes
From: Adrian Bunk <bunk@kernel.org>

This patch adds a proper prototype for some functions in fs/dlm/dlm_internal.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: David Teigland <teigland@redhat.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dlm/dlm_internal.h |   16 ++++++++++++++++
 fs/dlm/lock.c         |    1 -
 fs/dlm/lockspace.c    |    8 --------
 fs/dlm/main.c         |   10 ----------
 4 files changed, 16 insertions(+), 19 deletions(-)

diff -puN fs/dlm/dlm_internal.h~fs-dlm-proper-prototypes fs/dlm/dlm_internal.h
--- a/fs/dlm/dlm_internal.h~fs-dlm-proper-prototypes
+++ a/fs/dlm/dlm_internal.h
@@ -570,5 +570,21 @@ static inline int dlm_no_directory(struc
 	return (ls->ls_exflags & DLM_LSFL_NODIR) ? 1 : 0;
 }
 
+int dlm_netlink_init(void);
+void dlm_netlink_exit(void);
+void dlm_timeout_warn(struct dlm_lkb *lkb);
+
+#ifdef CONFIG_DLM_DEBUG
+int dlm_register_debugfs(void);
+void dlm_unregister_debugfs(void);
+int dlm_create_debug_file(struct dlm_ls *ls);
+void dlm_delete_debug_file(struct dlm_ls *ls);
+#else
+static inline int dlm_register_debugfs(void) { return 0; }
+static inline void dlm_unregister_debugfs(void) { }
+static inline int dlm_create_debug_file(struct dlm_ls *ls) { return 0; }
+static inline void dlm_delete_debug_file(struct dlm_ls *ls) { }
+#endif
+
 #endif				/* __DLM_INTERNAL_DOT_H__ */
 
diff -puN fs/dlm/lock.c~fs-dlm-proper-prototypes fs/dlm/lock.c
--- a/fs/dlm/lock.c~fs-dlm-proper-prototypes
+++ a/fs/dlm/lock.c
@@ -88,7 +88,6 @@ static void __receive_convert_reply(stru
 static int receive_extralen(struct dlm_message *ms);
 static void do_purge(struct dlm_ls *ls, int nodeid, int pid);
 static void del_timeout(struct dlm_lkb *lkb);
-void dlm_timeout_warn(struct dlm_lkb *lkb);
 
 /*
  * Lock compatibilty matrix - thanks Steve
diff -puN fs/dlm/lockspace.c~fs-dlm-proper-prototypes fs/dlm/lockspace.c
--- a/fs/dlm/lockspace.c~fs-dlm-proper-prototypes
+++ a/fs/dlm/lockspace.c
@@ -24,14 +24,6 @@
 #include "recover.h"
 #include "requestqueue.h"
 
-#ifdef CONFIG_DLM_DEBUG
-int dlm_create_debug_file(struct dlm_ls *ls);
-void dlm_delete_debug_file(struct dlm_ls *ls);
-#else
-static inline int dlm_create_debug_file(struct dlm_ls *ls) { return 0; }
-static inline void dlm_delete_debug_file(struct dlm_ls *ls) { }
-#endif
-
 static int			ls_count;
 static struct mutex		ls_lock;
 static struct list_head		lslist;
diff -puN fs/dlm/main.c~fs-dlm-proper-prototypes fs/dlm/main.c
--- a/fs/dlm/main.c~fs-dlm-proper-prototypes
+++ a/fs/dlm/main.c
@@ -18,16 +18,6 @@
 #include "memory.h"
 #include "config.h"
 
-#ifdef CONFIG_DLM_DEBUG
-int dlm_register_debugfs(void);
-void dlm_unregister_debugfs(void);
-#else
-static inline int dlm_register_debugfs(void) { return 0; }
-static inline void dlm_unregister_debugfs(void) { }
-#endif
-int dlm_netlink_init(void);
-void dlm_netlink_exit(void);
-
 static int __init init_dlm(void)
 {
 	int error;
_

Patches currently in -mm which might be from bunk@kernel.org are

lguest_userc-fix-memory-leak.patch
video-sis-fix-negative-array-index.patch
git-avr32.patch
git-dvb.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-mtd.patch
git-net.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
git-netdev-all.patch
drivers-net-chelsio-if-0-unused-functions.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-nfs-make-nfs_wb_page_priority-static.patch
fs-nfs-dirc-should-include-internalh.patch
git-ocfs2.patch
proper-prototype-for-kernel-schedcmigration_init.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-qla2xxx-possible-cleanups.patch
usb-mon-mon_binc-cleanups.patch
xtensa-iss_net_setup-must-be-__init.patch
xtensa-kernel-setupc-remove-dead-code.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
feature-removal-schedule-remove-sa_-flags-entry.patch
kernel-taskstatsc-fix-bogus-nlmsg_free.patch
mm-hugetlbc-make-a-function-static.patch
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
blackfin-remove-dump_thread.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kernel-power-move-function-prototypes-to-header.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
remove-__attribute_used__.patch
remove-__attribute_used__-checkpatch-fixes.patch
proper-show_interrupts-prototype.patch
scheduled-oss-driver-removal.patch
linux-inith-simplify-__meminitexit-dependencies.patch
proper-prototype-for-signals_init.patch
kernel-ptracec-should-include-linux-syscallsh.patch
make-srcu_readers_active-static.patch
kernel-notifierc-should-include-linux-rebooth.patch
proper-prototype-for-get_filesystem_list.patch
fs-utimesc-should-include-linux-syscallsh.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
proper-prototype-for-vty_init.patch
drivers-misc-lkdtmc-cleanups.patch
power_supply_ledssysfsc-should-include-power_supplyh.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
ext4-superc-fix-ifdefs.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
remove-documentation-smptxt.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
reiser4.patch
