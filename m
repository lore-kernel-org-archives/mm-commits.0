From: akpm@linux-foundation.org
Subject: + x86-ignore-vm_locked-when-determining-if-hugetlb-backed-page-tables-can-be-shared-or-not.patch added to -mm tree
Date: Wed, 27 May 2009 13:14:46 -0700
Message-ID: <200905272014.n4RKEkf5029583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933572AbZE0URj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 May 2009 16:17:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, Lee.Schermerhorn@hp.com, agl@us.ibm.com, apw@canonical.com, ebmunson@us.ibm.com, hugh.dickins@tiscali.co.uk, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, stable@kernel.org, starlight@binnacle.cx


The patch titled
     x86: ignore VM_LOCKED when determining if hugetlb-backed page tables can be shared or not
has been added to the -mm tree.  Its filename is
     x86-ignore-vm_locked-when-determining-if-hugetlb-backed-page-tables-can-be-shared-or-not.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: ignore VM_LOCKED when determining if hugetlb-backed page tables can be shared or not
From: Mel Gorman <mel@csn.ul.ie>

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=13302

On x86 and x86-64, it is possible that page tables are shared beween
shared mappings backed by hugetlbfs.  As part of this,
page_table_shareable() checks a pair of vma->vm_flags and they must match
if they are to be shared.  All VMA flags are taken into account, including
VM_LOCKED.

The problem is that VM_LOCKED is cleared on fork().  When a process with a
shared memory segment forks() to exec() a helper, there will be shared
VMAs with different flags.  The impact is that the shared segment is
sometimes considered shareable and other times not, depending on what
process is checking.

What happens is that the segment page tables are being shared but the
count is inaccurate depending on the ordering of events.  As the page
tables are freed with put_page(), bad pmd's are found when some of the
children exit.  The hugepage counters also get corrupted and the Total and
Free count will no longer match even when all the hugepage-backed regions
are freed.  This requires a reboot of the machine to "fix".

This patch addresses the problem by comparing all flags except VM_LOCKED
when deciding if pagetables should be shared or not for hugetlbfs-backed
mapping.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: <starlight@binnacle.cx>
Cc: Eric B Munson <ebmunson@us.ibm.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/hugetlbpage.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN arch/x86/mm/hugetlbpage.c~x86-ignore-vm_locked-when-determining-if-hugetlb-backed-page-tables-can-be-shared-or-not arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c~x86-ignore-vm_locked-when-determining-if-hugetlb-backed-page-tables-can-be-shared-or-not
+++ a/arch/x86/mm/hugetlbpage.c
@@ -26,12 +26,16 @@ static unsigned long page_table_shareabl
 	unsigned long sbase = saddr & PUD_MASK;
 	unsigned long s_end = sbase + PUD_SIZE;
 
+	/* Allow segments to share if only one is marked locked */
+	unsigned long vm_flags = vma->vm_flags & ~VM_LOCKED;
+	unsigned long svm_flags = svma->vm_flags & ~VM_LOCKED;
+
 	/*
 	 * match the virtual addresses, permission and the alignment of the
 	 * page table page.
 	 */
 	if (pmd_index(addr) != pmd_index(saddr) ||
-	    vma->vm_flags != svma->vm_flags ||
+	    vm_flags != svm_flags ||
 	    sbase < svma->vm_start || svma->vm_end < s_end)
 		return 0;
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

oom-fix-possible-oom_dump_tasks-null-pointer.patch
x86-ignore-vm_locked-when-determining-if-hugetlb-backed-page-tables-can-be-shared-or-not.patch
mm-account-for-map_shared-mappings-using-vm_mayshare-and-not-vm_shared-in-hugetlbfs.patch
linux-next.patch
vmscan-low-order-lumpy-reclaim-also-should-use-pageout_io_sync.patch
mm-alloc_large_system_hash-check-order.patch
page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid.patch
page-allocator-check-only-once-if-the-zonelist-is-suitable-for-the-allocation.patch
page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths.patch
page-allocator-move-check-for-disabled-anti-fragmentation-out-of-fastpath.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-calculate-the-migratetype-for-allocation-only-once.patch
page-allocator-calculate-the-alloc_flags-for-allocation-only-once.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
page-allocator-inline-__rmqueue_smallest.patch
page-allocator-inline-buffered_rmqueue.patch
page-allocator-inline-__rmqueue_fallback.patch
page-allocator-do-not-call-get_pageblock_migratetype-more-than-necessary.patch
page-allocator-do-not-disable-interrupts-in-free_page_mlock.patch
page-allocator-do-not-setup-zonelist-cache-when-there-is-only-one-node.patch
page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark-replace-the-watermark-related-union-in-struct-zone-with-a-watermark-array.patch
page-allocator-update-nr_free_pages-only-as-necessary.patch
page-allocator-update-nr_free_pages-only-as-necessary-fix.patch
page-allocator-get-the-pageblock-migratetype-without-disabling-interrupts.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths-do-not-override-definition-of-node_set_online-with-macro.patch
page-allocator-slab-use-nr_online_nodes-to-check-for-a-numa-platform.patch
page-allocator-move-free_page_mlock-to-page_allocc.patch
page-allocator-sanity-check-order-in-the-page-allocator-slow-path.patch
mm-use-alloc_pages_exact-in-alloc_large_system_hash-to-avoid-duplicated-logic.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator.patch
page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator-fix-gfp-zone-patch.patch
page-allocator-clean-up-functions-related-to-pages_min.patch
add-debugging-aid-for-memory-initialisation-problems.patch

