From: akpm@linux-foundation.org
Subject: + page-allocator-explicitly-retry-hugepage-allocations.patch added to -mm tree
Date: Tue, 15 Apr 2008 00:09:17 -0700
Message-ID: <200804150709.m3F79HLg016185@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752937AbYDOHJr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 03:09:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nacc@us.ibm.com, apw@shadowen.org, clameter@sgi.com, haveblue@us.ibm.com, mel@csn.ul.ie


The patch titled
     page allocator: explicitly retry hugepage allocations
has been added to the -mm tree.  Its filename is
     page-allocator-explicitly-retry-hugepage-allocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: explicitly retry hugepage allocations
From: Nishanth Aravamudan <nacc@us.ibm.com>

Add __GFP_REPEAT to hugepage allocations.  Do so to not necessitate userspace
putting pressure on the VM by repeated echo's into /proc/sys/vm/nr_hugepages
to grow the pool.  With the previous patch to allow for large-order
__GFP_REPEAT attempts to loop for a bit (as opposed to indefinitely), this
increases the likelihood of getting hugepages when the system experiences (or
recently experienced) load.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~page-allocator-explicitly-retry-hugepage-allocations mm/hugetlb.c
--- a/mm/hugetlb.c~page-allocator-explicitly-retry-hugepage-allocations
+++ a/mm/hugetlb.c
@@ -199,7 +199,8 @@ static struct page *alloc_fresh_huge_pag
 	struct page *page;
 
 	page = alloc_pages_node(nid,
-		htlb_alloc_mask|__GFP_COMP|__GFP_THISNODE|__GFP_NOWARN,
+		htlb_alloc_mask|__GFP_COMP|__GFP_THISNODE|
+						__GFP_REPEAT|__GFP_NOWARN,
 		HUGETLB_PAGE_ORDER);
 	if (page) {
 		if (arch_prepare_hugepage(page)) {
@@ -294,7 +295,8 @@ static struct page *alloc_buddy_huge_pag
 	}
 	spin_unlock(&hugetlb_lock);
 
-	page = alloc_pages(htlb_alloc_mask|__GFP_COMP|__GFP_NOWARN,
+	page = alloc_pages(htlb_alloc_mask|__GFP_COMP|
+					__GFP_REPEAT|__GFP_NOWARN,
 					HUGETLB_PAGE_ORDER);
 
 	spin_lock(&hugetlb_lock);
_

Patches currently in -mm which might be from nacc@us.ibm.com are

documentation-correct-overcommit-caveat-in-hugetlbpagetxt.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework.patch
mm-fix-misleading-__gfp_repeat-related-comments.patch
page-allcoator-smarter-retry-of-costly-order-allocations.patch
page-allocator-explicitly-retry-hugepage-allocations.patch

