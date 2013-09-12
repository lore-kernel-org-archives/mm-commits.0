From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-aio-performance-regression-for-database-caused-by-thp.patch removed
 from -mm tree
Date: Thu, 12 Sep 2013 12:44:39 -0700
Message-ID: <523219a7.WdCOoX+aMtpiBUa5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58425 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab3ILTok (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:44:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, riel@redhat.com, pshelar@nicira.com, minchan@kernel.org, mel@csn.ul.ie, hannes@cmpxchg.org, cl@linux.com, andi@firstfloor.org, aarcange@redhat.com, khalid.aziz@oracle.com

Subject: [merged] mm-fix-aio-performance-regression-for-database-caused-by-thp.patch removed from -mm tree
To: khalid.aziz@oracle.com,aarcange@redhat.com,andi@firstfloor.org,cl@linux.com,hannes@cmpxchg.org,mel@csn.ul.ie,minchan@kernel.org,pshelar@nicira.com,riel@redhat.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:44:39 -0700


The patch titled
     Subject: mm: fix aio performance regression for database caused by THP
has been removed from the -mm tree.  Its filename was
     mm-fix-aio-performance-regression-for-database-caused-by-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: mm: fix aio performance regression for database caused by THP

I am working with a tool that simulates oracle database I/O workload. 
This tool (orion to be specific -
<http://docs.oracle.com/cd/E11882_01/server.112/e16638/iodesign.htm#autoId24>)
allocates hugetlbfs pages using shmget() with SHM_HUGETLB flag.  It then
does aio into these pages from flash disks using various common block
sizes used by database.  I am looking at performance with two of the most
common block sizes - 1M and 64K.  aio performance with these two block
sizes plunged after Transparent HugePages was introduced in the kernel. 
Here are performance numbers:

		pre-THP		2.6.39		3.11-rc5
1M read		8384 MB/s	5629 MB/s	6501 MB/s
64K read	7867 MB/s	4576 MB/s	4251 MB/s

I have narrowed the performance impact down to the overheads introduced by
THP in __get_page_tail() and put_compound_page() routines.  perf top shows
>40% of cycles being spent in these two routines.  Every time direct I/O
to hugetlbfs pages starts, kernel calls get_page() to grab a reference to
the pages and calls put_page() when I/O completes to put the reference
away.  THP introduced significant amount of locking overhead to get_page()
and put_page() when dealing with compound pages because hugepages can be
split underneath get_page() and put_page().  It added this overhead
irrespective of whether it is dealing with hugetlbfs pages or transparent
hugepages.  This resulted in 20%-45% drop in aio performance when using
hugetlbfs pages.

Since hugetlbfs pages can not be split, there is no reason to go through
all the locking overhead for these pages from what I can see.  I added
code to __get_page_tail() and put_compound_page() to bypass all the
locking code when working with hugetlbfs pages.  This improved performance
significantly.  Performance numbers with this patch:

		pre-THP		3.11-rc5	3.11-rc5 + Patch
1M read		8384 MB/s	6501 MB/s	8371 MB/s
64K read	7867 MB/s	4251 MB/s	6510 MB/s

Performance with 64K read is still lower than what it was before THP, but
still a 53% improvement.  It does mean there is more work to be done but I
will take a 53% improvement for now.

Please take a look at the following patch and let me know if it looks
reasonable.

[akpm@linux-foundation.org: tweak comments]
Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Pravin B Shelar <pshelar@nicira.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   77 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 52 insertions(+), 25 deletions(-)

diff -puN mm/swap.c~mm-fix-aio-performance-regression-for-database-caused-by-thp mm/swap.c
--- a/mm/swap.c~mm-fix-aio-performance-regression-for-database-caused-by-thp
+++ a/mm/swap.c
@@ -31,6 +31,7 @@
 #include <linux/memcontrol.h>
 #include <linux/gfp.h>
 #include <linux/uio.h>
+#include <linux/hugetlb.h>
 
 #include "internal.h"
 
@@ -81,6 +82,19 @@ static void __put_compound_page(struct p
 
 static void put_compound_page(struct page *page)
 {
+	/*
+	 * hugetlbfs pages cannot be split from under us.  If this is a
+	 * hugetlbfs page, check refcount on head page and release the page if
+	 * the refcount becomes zero.
+	 */
+	if (PageHuge(page)) {
+		page = compound_head(page);
+		if (put_page_testzero(page))
+			__put_compound_page(page);
+
+		return;
+	}
+
 	if (unlikely(PageTail(page))) {
 		/* __split_huge_page_refcount can run under us */
 		struct page *page_head = compound_trans_head(page);
@@ -184,38 +198,51 @@ bool __get_page_tail(struct page *page)
 	 * proper PT lock that already serializes against
 	 * split_huge_page().
 	 */
-	unsigned long flags;
 	bool got = false;
-	struct page *page_head = compound_trans_head(page);
+	struct page *page_head;
 
-	if (likely(page != page_head && get_page_unless_zero(page_head))) {
+	/*
+	 * If this is a hugetlbfs page it cannot be split under us.  Simply
+	 * increment refcount for the head page.
+	 */
+	if (PageHuge(page)) {
+		page_head = compound_head(page);
+		atomic_inc(&page_head->_count);
+		got = true;
+	} else {
+		unsigned long flags;
+
+		page_head = compound_trans_head(page);
+		if (likely(page != page_head &&
+					get_page_unless_zero(page_head))) {
+
+			/* Ref to put_compound_page() comment. */
+			if (PageSlab(page_head)) {
+				if (likely(PageTail(page))) {
+					__get_page_tail_foll(page, false);
+					return true;
+				} else {
+					put_page(page_head);
+					return false;
+				}
+			}
 
-		/* Ref to put_compound_page() comment. */
-		if (PageSlab(page_head)) {
+			/*
+			 * page_head wasn't a dangling pointer but it
+			 * may not be a head page anymore by the time
+			 * we obtain the lock. That is ok as long as it
+			 * can't be freed from under us.
+			 */
+			flags = compound_lock_irqsave(page_head);
+			/* here __split_huge_page_refcount won't run anymore */
 			if (likely(PageTail(page))) {
 				__get_page_tail_foll(page, false);
-				return true;
-			} else {
-				put_page(page_head);
-				return false;
+				got = true;
 			}
+			compound_unlock_irqrestore(page_head, flags);
+			if (unlikely(!got))
+				put_page(page_head);
 		}
