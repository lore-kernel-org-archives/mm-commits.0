From: akpm@linux-foundation.org
Subject: + mm-isolate_lru_page-dont-enable-local-interrupts.patch added to -mm tree
Date: Mon, 17 Sep 2012 16:23:03 -0700
Message-ID: <20120917232304.102ED200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:48836 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab2IQXXG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Sep 2012 19:23:06 -0400
Received: by wibhr14 with SMTP id hr14so154699wib.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Sep 2012 16:23:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, levinsasha928@gmail.com, mel@csn.ul.ie


The patch titled
     Subject: mm: isolate_lru_page(): don't enable local interrupts
has been added to the -mm tree.  Its filename is
     mm-isolate_lru_page-dont-enable-local-interrupts.patch

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
Subject: mm: isolate_lru_page(): don't enable local interrupts

isolate_lru_page() is called with local interrupts disabled, via

invalidate_complete_page2()
->spin_lock_irq(&mapping->tree_lock)
->clear_page_mlock()
  __clear_page_mlock()
  ->isolate_lru_page()

so it should not unconditionally enable local interrupts.

Sasha hit a lockdep warning when running Trinity as a result of this.

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-isolate_lru_page-dont-enable-local-interrupts mm/vmscan.c
--- a/mm/vmscan.c~mm-isolate_lru_page-dont-enable-local-interrupts
+++ a/mm/vmscan.c
@@ -1161,8 +1161,9 @@ int isolate_lru_page(struct page *page)
 	if (PageLRU(page)) {
 		struct zone *zone = page_zone(page);
 		struct lruvec *lruvec;
+		unsigned long flags;
 
-		spin_lock_irq(&zone->lru_lock);
+		spin_lock_irqsave(&zone->lru_lock, flags);
 		lruvec = mem_cgroup_page_lruvec(page, zone);
 		if (PageLRU(page)) {
 			int lru = page_lru(page);
@@ -1171,7 +1172,7 @@ int isolate_lru_page(struct page *page)
 			del_page_from_lru_list(page, lruvec, lru);
 			ret = 0;
 		}
-		spin_unlock_irq(&zone->lru_lock);
+		spin_unlock_irqrestore(&zone->lru_lock, flags);
 	}
 	return ret;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memory-hotplug-fix-a-double-register-section-info-bug.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
idr-rename-max_level-to-max_idr_level-fix-3.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
audith-replace-defines-with-c-stubs.patch
slab-fix-debug==0-warning.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
mm-isolate_lru_page-dont-enable-local-interrupts.patch
sections-fix-section-conflicts-in-arch-h8300-checkpatch-fixes.patch
sections-fix-section-conflicts-in-drivers-macintosh-checkpatch-fixes.patch
sectons-fix-const-sections-for-crc32-table-checkpatch-fixes.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
idr-rename-max_level-to-max_idr_level-fix.patch
idr-rename-max_level-to-max_idr_level-fix-fix-2.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

