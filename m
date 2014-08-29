From: akpm@linux-foundation.org
Subject: + include-linux-migrateh-remove-migratepage-define.patch added to -mm tree
Date: Fri, 29 Aug 2014 14:38:14 -0700
Message-ID: <5400f2c6.CL63r9h6Lvd2Tcpf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46533 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaH2ViP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Aug 2014 17:38:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aquini@redhat.com, k.khlebnikov@samsung.com, mel@csn.ul.ie, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/migrate.h: remove migrate_page #define
has been added to the -mm tree.  Its filename is
     include-linux-migrateh-remove-migratepage-define.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-migrateh-remove-migratepage-define.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-migrateh-remove-migratepage-define.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
diff -puN mm/shmem.c~include-linux-migrateh-remove-migratepage-define mm/shmem.c
--- a/mm/shmem.c~include-linux-migrateh-remove-migratepage-define
+++ a/mm/shmem.c
@@ -3075,7 +3075,9 @@ static const struct address_space_operat
 	.write_begin	= shmem_write_begin,
 	.write_end	= shmem_write_end,
 #endif
+#ifdef CONFIG_MIGRATION
 	.migratepage	= migrate_page,
+#endif
 	.error_remove_page = generic_error_remove_page,
 };
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
mem-hotplug-let-memblock-skip-the-hotpluggable-memory-regions-in-__next_mem_range-fix.patch
mm-slab_commonc-suppress-warning.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable-checkpatch-fixes.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
mm.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix.patch
include-linux-migrateh-remove-migratepage-define.patch
mm-introduce-common-page-state-for-ballooned-memory-fix.patch
mm-balloon_compaction-general-cleanup-fix.patch
mm-balloon_compaction-general-cleanup-checkpatch-fixes.patch
introduce-dump_vma-fix.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma-checkpatch-fixes.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
zram-zram-memory-size-limitation-fix.patch
zram-zram-memory-size-limitation-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
acct-eliminate-compile-warning-fix.patch
checkpatch-fix-spello.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes.patch
x86-optimize-resource-lookups-for-ioremap-fix.patch
init-resolve-shadow-warnings-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
watchdog-control-hard-lockup-detection-default-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

