From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-make-paranoid-check-in-move_freepages-a-vm_bug_on.patch added to -mm tree
Date: Wed, 10 Sep 2014 15:24:29 -0700
Message-ID: <5410cf9d.g5jxQou7TonoyW2g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbaIJWYa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Sep 2014 18:24:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: Make paranoid check in move_freepages a VM_BUG_ON
has been added to the -mm tree.  Its filename is
     mm-page_alloc-make-paranoid-check-in-move_freepages-a-vm_bug_on.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-make-paranoid-check-in-move_freepages-a-vm_bug_on.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-make-paranoid-check-in-move_freepages-a-vm_bug_on.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: page_alloc: Make paranoid check in move_freepages a VM_BUG_ON

Since 2.6.24 there has been a paranoid check in move_freepages that looks
up the zone of two pages.  This is a very slow path and the only time I've
seen this bug trigger recently is when memory initialisation was broken
during patch development.  Despite the fact it's a slow path, this patch
converts the check to a VM_BUG_ON anyway as it has served its purpose by
now.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-make-paranoid-check-in-move_freepages-a-vm_bug_on mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-make-paranoid-check-in-move_freepages-a-vm_bug_on
+++ a/mm/page_alloc.c
@@ -1015,7 +1015,7 @@ int move_freepages(struct zone *zone,
 	 * Remove at a later date when no bug reports exist related to
 	 * grouping pages by mobility
 	 */
-	BUG_ON(page_zone(start_page) != page_zone(end_page));
+	VM_BUG_ON(page_zone(start_page) != page_zone(end_page));
 #endif
 
 	for (page = start_page; page <= end_page;) {
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-page_alloc-fix-zone-allocation-fairness-on-up.patch
mm-remove-misleading-arch_uses_numa_prot_none.patch
mm-page_alloc-determine-migratetype-only-once.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
mm-compaction-periodically-drop-lock-and-restore-irqs-in-scanners.patch
mm-compaction-skip-rechecks-when-lock-was-already-held.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
introduce-dump_vma.patch
introduce-dump_vma-fix.patch
introduce-vm_bug_on_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch
mm-page_alloc-avoid-wakeup-kswapd-on-the-unintended-node.patch
mm-clean-up-zone-flags.patch
mm-compaction-fix-warning-of-flags-may-be-used-uninitialized.patch
mm-page_alloc-make-paranoid-check-in-move_freepages-a-vm_bug_on.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
x86-optimize-resource-lookups-for-ioremap.patch
x86-optimize-resource-lookups-for-ioremap-fix.patch
x86-use-optimized-ioresource-lookup-in-ioremap-function.patch
linux-next.patch

