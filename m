From: akpm@linux-foundation.org
Subject: + mm-introduce-common-page-state-for-ballooned-memory-fix.patch
 added to -mm tree
Date: Fri, 29 Aug 2014 13:43:34 -0700
Message-ID: <5400e5f6.zsxWc3attSRS9G0r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaH2Unf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Aug 2014 16:43:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aquini@redhat.com, k.khlebnikov@samsung.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-introduce-common-page-state-for-ballooned-memory-fix
has been added to the -mm tree.  Its filename is
     mm-introduce-common-page-state-for-ballooned-memory-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-common-page-state-for-ballooned-memory-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-common-page-state-for-ballooned-memory-fix.patch

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
Subject: mm-introduce-common-page-state-for-ballooned-memory-fix

export __ClearPageBalloon() and __SetPageBalloon() to modules

ERROR: "__ClearPageBalloon" [drivers/virtio/virtio_balloon.ko] undefined!
ERROR: "__SetPageBalloon" [drivers/virtio/virtio_balloon.ko] undefined!

Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/balloon_compaction.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/balloon_compaction.c~mm-introduce-common-page-state-for-ballooned-memory-fix mm/balloon_compaction.c
--- a/mm/balloon_compaction.c~mm-introduce-common-page-state-for-ballooned-memory-fix
+++ a/mm/balloon_compaction.c
@@ -16,6 +16,7 @@ void __SetPageBalloon(struct page *page)
 	atomic_set(&page->_mapcount, PAGE_BALLOON_MAPCOUNT_VALUE);
 	inc_zone_page_state(page, NR_BALLOON_PAGES);
 }
+EXPORT_SYMBOL(__SetPageBalloon);
 
 void __ClearPageBalloon(struct page *page)
 {
@@ -23,6 +24,7 @@ void __ClearPageBalloon(struct page *pag
 	atomic_set(&page->_mapcount, -1);
 	dec_zone_page_state(page, NR_BALLOON_PAGES);
 }
+EXPORT_SYMBOL(__ClearPageBalloon);
 
 /*
  * balloon_devinfo_alloc - allocates a balloon device information descriptor.
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
mm-introduce-common-page-state-for-ballooned-memory-fix.patch
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

