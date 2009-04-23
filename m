From: akpm@linux-foundation.org
Subject: + page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks.patch added to -mm tree
Date: Thu, 23 Apr 2009 16:08:17 -0700
Message-ID: <200904232308.n3NN8Hkq009776@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754475AbZDWXbT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 19:31:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nickpiggin@yahoo.com.au, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, penberg@cs.helsinki.fi


The patch titled
     page allocator: do not check for compound pages during the page allocator sanity checks
has been added to the -mm tree.  Its filename is
     page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks.patch

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
Subject: page allocator: do not check for compound pages during the page allocator sanity checks
From: Nick Piggin <nickpiggin@yahoo.com.au>

A number of sanity checks are made on each page allocation and free
including that the page count is zero.  page_count() checks for compound
pages and checks the count of the head page if true.  However, in these
paths, we do not care if the page is compound or not as the count of each
tail page should also be zero.

This patch makes two changes to the use of page_count() in the free path. 
It converts one check of page_count() to a VM_BUG_ON() as the count should
have been unconditionally checked earlier in the free path.  It also
avoids checking for compound pages.

[mel@csn.ul.ie: Wrote changelog]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Nick Piggin <nickpiggin@yahoo.com.au>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks
+++ a/mm/page_alloc.c
@@ -425,7 +425,7 @@ static inline int page_is_buddy(struct p
 		return 0;
 
 	if (PageBuddy(buddy) && page_order(buddy) == order) {
-		BUG_ON(page_count(buddy) != 0);
+		VM_BUG_ON(page_count(buddy) != 0);
 		return 1;
 	}
 	return 0;
@@ -501,7 +501,7 @@ static inline int free_pages_check(struc
 {
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
-		(page_count(page) != 0)  |
+		(atomic_read(&page->_count) != 0) |
 		(page->flags & PAGE_FLAGS_CHECK_AT_FREE))) {
 		bad_page(page);
 		return 1;
@@ -646,7 +646,7 @@ static int prep_new_page(struct page *pa
 {
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
-		(page_count(page) != 0)  |
+		(atomic_read(&page->_count) != 0)  |
 		(page->flags & PAGE_FLAGS_CHECK_AT_PREP))) {
 		bad_page(page);
 		return 1;
_

Patches currently in -mm which might be from nickpiggin@yahoo.com.au are

mm-disable-preemption-in-apply_to_pte_range.patch
radix-tree-add-radix_tree_prev_hole.patch
readahead-move-the-random-read-case-to-bottom.patch
readahead-introduce-context-readahead-algorithm.patch
mm-clean-up-get_user_pages_fast-documentation.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-mmu_notifiers-add-set_pte_at_notify.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-page_wrprotect-write-protecting-page.patch
ksm-add-replace_page-change-the-page-pte-is-pointing-to.patch
ksm-add-ksm-kernel-shared-memory-driver.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
ksm-add-ksm-kernel-shared-memory-driver-fix-unsafe-pte-fetching.patch
cpusets-restructure-the-function-cpuset_update_task_memory_state.patch
cpusets-update-tasks-page-slab-spread-flags-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time.patch
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
page-allocator-update-nr_free_pages-only-as-necessary.patch
page-allocator-get-the-pageblock-migratetype-without-disabling-interrupts.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths.patch
page-allocator-slab-use-nr_online_nodes-to-check-for-a-numa-platform.patch
vfs-take-2add-set_page_dirty_notag.patch
reiser4.patch

