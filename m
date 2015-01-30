From: akpm@linux-foundation.org
Subject: +
 mm-remove-remaining-references-to-numa-hinting-bits-and-helpers-fix.patch
 added to -mm tree
Date: Fri, 30 Jan 2015 13:46:54 -0800
Message-ID: <54cbfbce./3XuP2y98yvG4lCv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47235 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763260AbbA3Vqz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Jan 2015 16:46:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, broonie@kernel.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove remaining references to NUMA hinting bits and helpers -fix
has been added to the -mm tree.  Its filename is
     mm-remove-remaining-references-to-numa-hinting-bits-and-helpers-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-remaining-references-to-numa-hinting-bits-and-helpers-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-remaining-references-to-numa-hinting-bits-and-helpers-fix.patch

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
Subject: mm: remove remaining references to NUMA hinting bits and helpers -fix

The patch "mm: remove remaining references to NUMA hinting bits and
helpers" was meant to remove NUMA hinting bits and helpers but broke
is_swap_pte.  >From the original bug report

	For at least the past couple of days tests of libhugetlbfs have
	been hanging on mustang in the mlock test running ARMv8 defconfig
	with both 32 bit and 64 bit userspace - after the mprotect test
	(the one before it) we get no console output for several hours so
	it appears that the test has deadlocked.  The tail of the log is:

	| find_path (2M: 64):   PASS
	| unlinked_fd (2M: 64): PASS
	| readback (2M: 64):    PASS
	| truncate (2M: 64):    PASS
	| shared (2M: 64):      PASS
	| mprotect (2M: 64):    PASS

This patch should address the problem and is a fix to the mmotm patch
mm-remove-remaining-references-to-numa-hinting-bits-and-helpers.patch

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Mark Brown <broonie@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/swapops.h~mm-remove-remaining-references-to-numa-hinting-bits-and-helpers-fix include/linux/swapops.h
--- a/include/linux/swapops.h~mm-remove-remaining-references-to-numa-hinting-bits-and-helpers-fix
+++ a/include/linux/swapops.h
@@ -54,7 +54,7 @@ static inline pgoff_t swp_offset(swp_ent
 /* check whether a pte points to a swap entry */
 static inline int is_swap_pte(pte_t pte)
 {
-	return !pte_none(pte);
+	return !pte_none(pte) && !pte_present(pte);
 }
 #endif
 
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-page_alloc-place-zone_id-check-before-vm_bug_on_page-check.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
mm-numa-do-not-dereference-pmd-outside-of-the-lock-during-numa-hinting-fault.patch
mm-add-p-protnone-helpers-for-use-by-numa-balancing.patch
mm-convert-p_numa-users-to-p_protnone_numa.patch
ppc64-add-paranoid-warnings-for-unexpected-dsisr_protfault.patch
mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch
mm-remove-remaining-references-to-numa-hinting-bits-and-helpers.patch
mm-remove-remaining-references-to-numa-hinting-bits-and-helpers-fix.patch
mm-numa-do-not-trap-faults-on-the-huge-zero-page.patch
x86-mm-restore-original-pte_special-check.patch
mm-numa-add-paranoid-check-around-pte_protnone_numa.patch
mm-numa-avoid-unnecessary-tlb-flushes-when-setting-numa-hinting-entries.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
mm-compaction-change-tracepoint-format-from-decimal-to-hexadecimal.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4.patch
mm-compaction-print-current-range-where-compaction-work.patch
mm-compaction-more-trace-to-understand-when-why-compaction-start-finish.patch
mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer.patch
mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer-v4.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
mm-when-stealing-freepages-also-take-pages-created-by-splitting-buddy-page.patch
mm-always-steal-split-buddies-in-fallback-allocations.patch
mm-more-aggressive-page-stealing-for-unmovable-allocations.patch
vmstat-do-not-use-deferrable-delayed-work-for-vmstat_update.patch
mm-incorporate-read-only-pages-into-transparent-huge-pages.patch
mm-incorporate-read-only-pages-into-transparent-huge-pages-v4.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

