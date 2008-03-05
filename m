From: akpm@linux-foundation.org
Subject: - hugetlb-fix-pool-shrinking-while-in-restricted-cpuset.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:46:47 -0800
Message-ID: <200803050746.m257klJ2021793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756705AbYCEHrT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:47:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nacc@us.ibm.com, Lee.Schermerhonr@hp.com, agl@us.ibm.com, clameter@sgi.com, david@gibson.dropbear.id.au, pj@sgi.com, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: fix pool shrinking while in restricted cpuset
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-pool-shrinking-while-in-restricted-cpuset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: fix pool shrinking while in restricted cpuset
From: Nishanth Aravamudan <nacc@us.ibm.com>

Adam Litke noticed that currently we grow the hugepage pool independent of any
cpuset the running process may be in, but when shrinking the pool, the cpuset
is checked.  This leads to inconsistency when shrinking the pool in a
restricted cpuset -- an administrator may have been able to grow the pool on a
node restricted by a containing cpuset, but they cannot shrink it there.

There are two options: either prevent growing of the pool outside of the
cpuset or allow shrinking outside of the cpuset.  >From previous discussions
on linux-mm, /proc/sys/vm/nr_hugepages is an administrative interface that
should not be restricted by cpusets.  So allow shrinking the pool by removing
pages from nodes outside of current's cpuset.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Acked-by: Adam Litke <agl@us.ibm.com>
Cc: William Irwin <wli@holomorphy.com>
Cc: Lee Schermerhorn <Lee.Schermerhonr@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-fix-pool-shrinking-while-in-restricted-cpuset mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-pool-shrinking-while-in-restricted-cpuset
+++ a/mm/hugetlb.c
@@ -71,7 +71,25 @@ static void enqueue_huge_page(struct pag
 	free_huge_pages_node[nid]++;
 }
 
-static struct page *dequeue_huge_page(struct vm_area_struct *vma,
+static struct page *dequeue_huge_page(void)
+{
+	int nid;
+	struct page *page = NULL;
+
+	for (nid = 0; nid < MAX_NUMNODES; ++nid) {
+		if (!list_empty(&hugepage_freelists[nid])) {
+			page = list_entry(hugepage_freelists[nid].next,
+					  struct page, lru);
+			list_del(&page->lru);
+			free_huge_pages--;
+			free_huge_pages_node[nid]--;
+			break;
+		}
+	}
+	return page;
+}
+
+static struct page *dequeue_huge_page_vma(struct vm_area_struct *vma,
 				unsigned long address)
 {
 	int nid;
@@ -410,7 +428,7 @@ static struct page *alloc_huge_page_shar
 	struct page *page;
 
 	spin_lock(&hugetlb_lock);
-	page = dequeue_huge_page(vma, addr);
+	page = dequeue_huge_page_vma(vma, addr);
 	spin_unlock(&hugetlb_lock);
 	return page ? page : ERR_PTR(-VM_FAULT_OOM);
 }
@@ -425,7 +443,7 @@ static struct page *alloc_huge_page_priv
 
 	spin_lock(&hugetlb_lock);
 	if (free_huge_pages > resv_huge_pages)
-		page = dequeue_huge_page(vma, addr);
+		page = dequeue_huge_page_vma(vma, addr);
 	spin_unlock(&hugetlb_lock);
 	if (!page) {
 		page = alloc_buddy_huge_page(vma, addr);
@@ -578,7 +596,7 @@ static unsigned long set_max_huge_pages(
 	min_count = max(count, min_count);
 	try_to_free_low(min_count);
 	while (min_count < persistent_huge_pages) {
-		struct page *page = dequeue_huge_page(NULL, 0);
+		struct page *page = dequeue_huge_page();
 		if (!page)
 			break;
 		update_and_free_page(page);
_

Patches currently in -mm which might be from nacc@us.ibm.com are


