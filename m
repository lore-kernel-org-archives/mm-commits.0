From: akpm@linux-foundation.org
Subject: - page-allocator-explicitly-retry-hugepage-allocations.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:38:34 -0700
Message-ID: <200804300538.m3U5cYwL028759@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752547AbYD3Fiz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:38:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nacc@us.ibm.com, apw@shadowen.org, clameter@sgi.com, haveblue@us.ibm.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     page allocator: explicitly retry hugepage allocations
has been removed from the -mm tree.  Its filename was
     page-allocator-explicitly-retry-hugepage-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Mel tested the patchset on an x86_32 laptop.  With the patches, it was easier
to use the proc interface to grow the hugepage pool.  The following is the
output of a script that grows the pool as much as possible running on
2.6.25-rc9.

Allocating hugepages test
-------------------------
Disabling OOM Killer for current test process
Starting page count: 0
Attempt 1: 57 pages Progress made with 57 pages
Attempt 2: 73 pages Progress made with 16 pages
Attempt 3: 74 pages Progress made with 1 pages
Attempt 4: 75 pages Progress made with 1 pages
Attempt 5: 77 pages Progress made with 2 pages

77 pages was the most it allocated but it took 5 attempts from userspace
to get it. With the 3 patches in this series applied,

Allocating hugepages test
-------------------------
Disabling OOM Killer for current test process
Starting page count: 0
Attempt 1: 75 pages Progress made with 75 pages
Attempt 2: 76 pages Progress made with 1 pages
Attempt 3: 79 pages Progress made with 3 pages

And 79 pages was the most it got. Your patches were able to allocate the
bulk of possible pages on the first attempt.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Tested-by: Mel Gorman <mel@csn.ul.ie>
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

origin.patch

