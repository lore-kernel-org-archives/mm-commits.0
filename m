From: akpm@linux-foundation.org
Subject: [merged] include-linux-migrateh-remove-migratepage-define.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 11:20:19 -0700
Message-ID: <543c17e3.PE8IGRmVbI5obfdU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbaJMSUT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:20:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aquini@redhat.com, k.khlebnikov@samsung.com, mel@csn.ul.ie, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/migrate.h: remove migrate_page #define
has been removed from the -mm tree.  Its filename was
     include-linux-migrateh-remove-migratepage-define.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/migrate.h: remove migrate_page #define

This is designed to avoid a few ifdefs in .c files but it's obnoxious
because it can cause unsuspecting "migrate_page" symbols to get turned into
"NULL".

Just nuke it and use the ifdefs.

Cc: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    3 ---
 mm/shmem.c              |    2 ++
 mm/swap_state.c         |    2 ++
 3 files changed, 4 insertions(+), 3 deletions(-)

diff -puN include/linux/migrate.h~include-linux-migrateh-remove-migratepage-define include/linux/migrate.h
--- a/include/linux/migrate.h~include-linux-migrateh-remove-migratepage-define
+++ a/include/linux/migrate.h
@@ -82,9 +82,6 @@ static inline int migrate_huge_page_move
 	return -ENOSYS;
 }
 
-/* Possible settings for the migrate_page() method in address_operations */
-#define migrate_page NULL
-
 #endif /* CONFIG_MIGRATION */
 
 #ifdef CONFIG_NUMA_BALANCING
diff -puN mm/shmem.c~include-linux-migrateh-remove-migratepage-define mm/shmem.c
--- a/mm/shmem.c~include-linux-migrateh-remove-migratepage-define
+++ a/mm/shmem.c
@@ -3077,7 +3077,9 @@ static const struct address_space_operat
 	.write_begin	= shmem_write_begin,
 	.write_end	= shmem_write_end,
 #endif
+#ifdef CONFIG_MIGRATION
 	.migratepage	= migrate_page,
+#endif
 	.error_remove_page = generic_error_remove_page,
 };
 
diff -puN mm/swap_state.c~include-linux-migrateh-remove-migratepage-define mm/swap_state.c
--- a/mm/swap_state.c~include-linux-migrateh-remove-migratepage-define
+++ a/mm/swap_state.c
@@ -28,7 +28,9 @@
 static const struct address_space_operations swap_aops = {
 	.writepage	= swap_writepage,
 	.set_page_dirty	= swap_set_page_dirty,
+#ifdef CONFIG_MIGRATION
 	.migratepage	= migrate_page,
+#endif
 };
 
 static struct backing_dev_info swap_backing_dev_info = {
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

