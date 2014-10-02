From: akpm@linux-foundation.org
Subject: +
 mm-migrate-close-race-between-migration-completion-and-mprotect.patch added to -mm tree
Date: Thu, 02 Oct 2014 13:06:43 -0700
Message-ID: <542db053.3UdgNeol18U1McJh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbaJBUGo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Oct 2014 16:06:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, davej@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, riel@redhat.com, sasha.levin@oracle.com, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: close race between migration completion and mprotect
has been added to the -mm tree.  Its filename is
     mm-migrate-close-race-between-migration-completion-and-mprotect.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-close-race-between-migration-completion-and-mprotect.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-close-race-between-migration-completion-and-mprotect.patch

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
Subject: mm: migrate: close race between migration completion and mprotect

A migration entry is marked as write if pte_write was true at the time the
entry was created.  The VMA protections are not double checked when
migration entries are being removed as mprotect marks
write-migration-entries as read.  It means that potentially we take a
spurious fault to mark PTEs write again but it's straight-forward. 
However, there is a race between write migrations being marked read and
migrations finishing.  This potentially allows a PTE to be write that
should have been read.  Close this race by double checking the VMA
permissions using maybe_mkwrite when migration completes.

[torvalds@linux-foundation.org: use maybe_mkwrite]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Kirill A Shutemov <kirill.shutemov@linux.intel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-migrate-close-race-between-migration-completion-and-mprotect mm/migrate.c
--- a/mm/migrate.c~mm-migrate-close-race-between-migration-completion-and-mprotect
+++ a/mm/migrate.c
@@ -146,8 +146,11 @@ static int remove_migration_pte(struct p
 	pte = pte_mkold(mk_pte(new, vma->vm_page_prot));
 	if (pte_swp_soft_dirty(*ptep))
 		pte = pte_mksoft_dirty(pte);
+
+	/* Recheck VMA as permissions can change since migration started  */
 	if (is_write_migration_entry(entry))
-		pte = pte_mkwrite(pte);
+		pte = maybe_mkwrite(pte, vma);
+
 #ifdef CONFIG_HUGETLB_PAGE
 	if (PageHuge(new)) {
 		pte = pte_mkhuge(pte);
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-migrate-close-race-between-migration-completion-and-mprotect.patch
mm-numa-do-not-mark-ptes-pte_numa-when-splitting-huge-pages.patch
mm-page_alloc-fix-zone-allocation-fairness-on-up.patch
mm-remove-misleading-arch_uses_numa_prot_none.patch
mm-page_alloc-determine-migratetype-only-once.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range-fix.patch
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
mm-page_alloc-default-node-ordering-on-64-bit-numa-zone-ordering-on-32-bit-v2.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
x86-optimize-resource-lookups-for-ioremap.patch
x86-optimize-resource-lookups-for-ioremap-fix.patch
x86-use-optimized-ioresource-lookup-in-ioremap-function.patch
linux-next.patch

