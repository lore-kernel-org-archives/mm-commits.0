From: akpm@linux-foundation.org
Subject: - hugetlb-move-update_and_free_page.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:35:44 -0700
Message-ID: <200710162035.l9GKZihG015081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50066 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935557AbXJPVyJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:54:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agl@us.ibm.com, apw@shadowen.org, bill.irwin@oracle.com, dave.mccracken@oracle.com, david@gibson.dropbear.id.au, kenchen@google.com, pbadari@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: Move update_and_free_page
has been removed from the -mm tree.  Its filename was
     hugetlb-move-update_and_free_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hugetlb: Move update_and_free_page
From: Adam Litke <agl@us.ibm.com>

Dynamic huge page pool resizing.


In most real-world scenarios, configuring the size of the hugetlb pool
correctly is a difficult task.  If too few pages are allocated to the pool,
applications using MAP_SHARED may fail to mmap() a hugepage region and
applications using MAP_PRIVATE may receive SIGBUS.  Isolating too much memory
in the hugetlb pool means it is not available for other uses, especially those
programs not using huge pages.

The obvious answer is to let the hugetlb pool grow and shrink in response to
the runtime demand for huge pages.  The work Mel Gorman has been doing to
establish a memory zone for movable memory allocations makes dynamically
resizing the hugetlb pool reliable within the limits of that zone.  This patch
series implements dynamic pool resizing for private and shared mappings while
being careful to maintain existing semantics.  Please reply with your comments
and feedback; even just to say whether it would be a useful feature to you.
Thanks.

How it works
============

Upon depletion of the hugetlb pool, rather than reporting an error immediately,
first try and allocate the needed huge pages directly from the buddy allocator.
Care must be taken to avoid unbounded growth of the hugetlb pool, so the
hugetlb filesystem quota is used to limit overall pool size.

The real work begins when we decide there is a shortage of huge pages.  What
happens next depends on whether the pages are for a private or shared mapping.
Private mappings are straightforward.  At fault time, if alloc_huge_page()
fails, we allocate a page from the buddy allocator and increment the source
node's surplus_huge_pages counter.  When free_huge_page() is called for a page
on a node with a surplus, the page is freed directly to the buddy allocator
instead of the hugetlb pool.

Because shared mappings require all of the pages to be reserved up front, some
additional work must be done at mmap() to support them.  We determine the
reservation shortage and allocate the required number of pages all at once.
These pages are then added to the hugetlb pool and marked reserved.  Where that
is not possible the mmap() will fail.  As with private mappings, the
appropriate surplus counters are updated.  Since reserved huge pages won't
necessarily be used by the process, we can't be sure that free_huge_page() will
always be called to return surplus pages to the buddy allocator.  To prevent
the huge page pool from bloating, we must free unused surplus pages when their
reservation has ended.

Controlling it
==============

With the entire patch series applied, pool resizing is off by default so unless
specific action is taken, the semantics are unchanged.

To take advantage of the flexibility afforded by this patch series one must
tolerate a change in semantics.  To control hugetlb pool growth, the following
techniques can be employed:

 * A sysctl tunable to enable/disable the feature entirely
 * The size= mount option for hugetlbfs filesystems to limit pool size

Performance
===========

When contiguous memory is readily available, it is expected that the cost of
dynamicly resizing the pool will be small.  This series has been performance
tested with 'stream' to measure this cost.

Stream (http://www.cs.virginia.edu/stream/) was linked with libhugetlbfs to
enable remapping of the text and data/bss segments into huge pages.

Stream with small array
-----------------------
Baseline: 	nr_hugepages = 0, No libhugetlbfs segment remapping
Preallocated:	nr_hugepages = 5, Text and data/bss remapping
Dynamic:	nr_hugepages = 0, Text and data/bss remapping

				Rate (MB/s)
Function	Baseline	Preallocated	Dynamic
Copy:		4695.6266	5942.8371	5982.2287
Scale:		4451.5776	5017.1419	5658.7843
Add:		5815.8849	7927.7827	8119.3552
Triad:		5949.4144	8527.6492	8110.6903

Stream with large array
-----------------------
Baseline: 	nr_hugepages =  0, No libhugetlbfs segment remapping
Preallocated:	nr_hugepages = 67, Text and data/bss remapping
Dynamic:	nr_hugepages =  0, Text and data/bss remapping

				Rate (MB/s)
Function	Baseline	Preallocated	Dynamic
Copy:		2227.8281	2544.2732	2546.4947
Scale:		2136.3208	2430.7294	2421.2074
Add:		2773.1449	4004.0021	3999.4331
Triad:		2748.4502	3777.0109	3773.4970

* All numbers are averages taken from 10 consecutive runs with a maximum
  standard deviation of 1.3 percent noted.


This patch:

Simply move update_and_free_page() so that it can be reused later in this
patch series.  The implementation is not changed.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Dave McCracken <dave.mccracken@oracle.com>
Acked-by: William Irwin <bill.irwin@oracle.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Ken Chen <kenchen@google.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-move-update_and_free_page mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-move-update_and_free_page
+++ a/mm/hugetlb.c
@@ -92,6 +92,21 @@ static struct page *dequeue_huge_page(st
 	return page;
 }
 
+static void update_and_free_page(struct page *page)
+{
+	int i;
+	nr_huge_pages--;
+	nr_huge_pages_node[page_to_nid(page)]--;
+	for (i = 0; i < (HPAGE_SIZE / PAGE_SIZE); i++) {
+		page[i].flags &= ~(1 << PG_locked | 1 << PG_error | 1 << PG_referenced |
+				1 << PG_dirty | 1 << PG_active | 1 << PG_reserved |
+				1 << PG_private | 1<< PG_writeback);
+	}
+	set_compound_page_dtor(page, NULL);
+	set_page_refcounted(page);
+	__free_pages(page, HUGETLB_PAGE_ORDER);
+}
+
 static void free_huge_page(struct page *page)
 {
 	BUG_ON(page_count(page));
@@ -201,21 +216,6 @@ static unsigned int cpuset_mems_nr(unsig
 }
 
 #ifdef CONFIG_SYSCTL
-static void update_and_free_page(struct page *page)
-{
-	int i;
-	nr_huge_pages--;
-	nr_huge_pages_node[page_to_nid(page)]--;
-	for (i = 0; i < (HPAGE_SIZE / PAGE_SIZE); i++) {
-		page[i].flags &= ~(1 << PG_locked | 1 << PG_error | 1 << PG_referenced |
-				1 << PG_dirty | 1 << PG_active | 1 << PG_reserved |
-				1 << PG_private | 1<< PG_writeback);
-	}
-	set_compound_page_dtor(page, NULL);
-	set_page_refcounted(page);
-	__free_pages(page, HUGETLB_PAGE_ORDER);
-}
-
 #ifdef CONFIG_HIGHMEM
 static void try_to_free_low(unsigned long count)
 {
_

Patches currently in -mm which might be from agl@us.ibm.com are

origin.patch
