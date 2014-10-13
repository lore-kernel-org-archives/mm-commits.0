From: akpm@linux-foundation.org
Subject: [merged]
 fs-notify-groupc-make-fsnotify_final_destroy_group-static.patch removed
 from -mm tree
Date: Mon, 13 Oct 2014 11:17:13 -0700
Message-ID: <543c1729.c9yeHqenpI5HpqAh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59914 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbaJMSRN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:17:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/notify/group.c: make fsnotify_final_destroy_group() static
has been removed from the -mm tree.  Its filename was
     fs-notify-groupc-make-fsnotify_final_destroy_group-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/notify/group.c: make fsnotify_final_destroy_group() static

No callers outside this file.

Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fsnotify.h |    3 ---
 fs/notify/group.c    |    2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/notify/fsnotify.h~fs-notify-groupc-make-fsnotify_final_destroy_group-static fs/notify/fsnotify.h
--- a/fs/notify/fsnotify.h~fs-notify-groupc-make-fsnotify_final_destroy_group-static
+++ a/fs/notify/fsnotify.h
@@ -23,9 +23,6 @@ extern int fsnotify_add_vfsmount_mark(st
 				      struct fsnotify_group *group, struct vfsmount *mnt,
 				      int allow_dups);
 
-/* final kfree of a group */
-extern void fsnotify_final_destroy_group(struct fsnotify_group *group);
-
 /* vfsmount specific destruction of a mark */
 extern void fsnotify_destroy_vfsmount_mark(struct fsnotify_mark *mark);
 /* inode specific destruction of a mark */
diff -puN fs/notify/group.c~fs-notify-groupc-make-fsnotify_final_destroy_group-static fs/notify/group.c
--- a/fs/notify/group.c~fs-notify-groupc-make-fsnotify_final_destroy_group-static
+++ a/fs/notify/group.c
@@ -31,7 +31,7 @@
 /*
  * Final freeing of a group
  */
-void fsnotify_final_destroy_group(struct fsnotify_group *group)
+static void fsnotify_final_destroy_group(struct fsnotify_group *group)
 {
 	if (group->ops->free_group_priv)
 		group->ops->free_group_priv(group);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
kernel-add-support-for-gcc-5-checkpatch-fixes.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans-fix.patch
mm.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch
drivers-dma-contiguous-add-initialization-from-device-tree-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
checkpatch-fix-spello.patch
checkpatch-warn-on-logging-functions-with-kern_level.patch
rtc-rk808-add-rtc-driver-for-rk808-fix.patch
rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-checkpatch-fixes.patch
rtc-max77686-use-ffs-to-calculate-tm_wday-fix.patch
rtc-add-driver-for-maxim-77802-pmic-real-time-clock-v10-fix.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch
x86-optimize-resource-lookups-for-ioremap-fix.patch
init-resolve-shadow-warnings-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
arch-x86-kernel-cpu-commonc-fix-unused-symbol-warning.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable-checkpatch-fixes.patch
lib-string_helpers-introduce-string_escape_mem-fix.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix-2.patch
watchdog-control-hard-lockup-detection-default-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

