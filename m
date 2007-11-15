From: akpm@linux-foundation.org
Subject: - cris-build-fixes-add-missing-syscalls.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:11:31 -0800
Message-ID: <200711152111.lAFLBVBE015769@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34338 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932275AbXKOVRO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris build fixes: Add missing syscalls
has been removed from the -mm tree.  Its filename was
     cris-build-fixes-add-missing-syscalls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cris build fixes: Add missing syscalls
From: Jesper Nilsson <jesper.nilsson@axis.com>

Add missing syscalls to cris architecture.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/kernel/entry.S |   36 +++++++++++++++++++++++++
 include/asm-cris/unistd.h         |   39 +++++++++++++++++++++++++++-
 2 files changed, 74 insertions(+), 1 deletion(-)

diff -puN arch/cris/arch-v10/kernel/entry.S~cris-build-fixes-add-missing-syscalls arch/cris/arch-v10/kernel/entry.S
--- a/arch/cris/arch-v10/kernel/entry.S~cris-build-fixes-add-missing-syscalls
+++ a/arch/cris/arch-v10/kernel/entry.S
@@ -1135,6 +1135,42 @@ sys_call_table:	
 	.long sys_add_key
 	.long sys_request_key
 	.long sys_keyctl
+	.long sys_ioprio_set
+	.long sys_ioprio_get		/* 290 */
+	.long sys_inotify_init
+	.long sys_inotify_add_watch
+	.long sys_inotify_rm_watch
+	.long sys_migrate_pages
+	.long sys_openat		/* 295 */
+	.long sys_mkdirat
+	.long sys_mknodat
+	.long sys_fchownat
+	.long sys_futimesat
+	.long sys_fstatat64		/* 300 */
+	.long sys_unlinkat
+	.long sys_renameat
+	.long sys_linkat
+	.long sys_symlinkat
+	.long sys_readlinkat		/* 305 */
+	.long sys_fchmodat
+	.long sys_faccessat
+	.long sys_pselect6
+	.long sys_ppoll
+	.long sys_unshare		/* 310 */
+	.long sys_set_robust_list
+	.long sys_get_robust_list
+	.long sys_splice
+	.long sys_sync_file_range
+	.long sys_tee			/* 315 */
+	.long sys_vmsplice
+	.long sys_move_pages
+	.long sys_getcpu
+	.long sys_epoll_pwait
+	.long sys_utimensat		/* 320 */
+	.long sys_signalfd
+	.long sys_timerfd
+	.long sys_eventfd
+	.long sys_fallocate
 
         /*
          * NOTE!! This doesn't have to be exact - we just have
diff -puN include/asm-cris/unistd.h~cris-build-fixes-add-missing-syscalls include/asm-cris/unistd.h
--- a/include/asm-cris/unistd.h~cris-build-fixes-add-missing-syscalls
+++ a/include/asm-cris/unistd.h
@@ -255,6 +255,7 @@
 #define __NR_io_submit		248
 #define __NR_io_cancel		249
 #define __NR_fadvise64		250
+/* 251 is available for reuse (was briefly sys_set_zone_reclaim) */
 #define __NR_exit_group		252
 #define __NR_lookup_dcookie	253
 #define __NR_epoll_create	254
@@ -292,10 +293,46 @@
 #define __NR_add_key		286
 #define __NR_request_key	287
 #define __NR_keyctl		288
+#define __NR_ioprio_set		289
+#define __NR_ioprio_get		290
+#define __NR_inotify_init	291
+#define __NR_inotify_add_watch	292
+#define __NR_inotify_rm_watch	293
+#define __NR_migrate_pages	294
+#define __NR_openat		295
+#define __NR_mkdirat		296
+#define __NR_mknodat		297
+#define __NR_fchownat		298
+#define __NR_futimesat		299
+#define __NR_fstatat64		300
+#define __NR_unlinkat		301
+#define __NR_renameat		302
+#define __NR_linkat		303
+#define __NR_symlinkat		304
+#define __NR_readlinkat		305
+#define __NR_fchmodat		306
+#define __NR_faccessat		307
+#define __NR_pselect6		308
+#define __NR_ppoll		309
+#define __NR_unshare		310
+#define __NR_set_robust_list	311
+#define __NR_get_robust_list	312
+#define __NR_splice		313
+#define __NR_sync_file_range	314
+#define __NR_tee		315
+#define __NR_vmsplice		316
+#define __NR_move_pages		317
+#define __NR_getcpu		318
+#define __NR_epoll_pwait	319
+#define __NR_utimensat		320
+#define __NR_signalfd		321
+#define __NR_timerfd		322
+#define __NR_eventfd		323
+#define __NR_fallocate		324
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 289
+#define NR_syscalls 325
 
 #include <asm/arch/unistd.h>
 
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

origin.patch
cris-build-fixes-atomich-needs-compilerh.patch
git-mtd.patch
