From: akpm@linux-foundation.org
Subject: - hugetlb-move-reservation-region-support-earlier.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:22:32 -0700
Message-ID: <200807242322.m6ONMWKu010572@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754116AbYGXXX0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:23:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, agl@us.ibm.com, hannes@saeurebad.de, hugh@veritas.com, mel@csn.ul.ie, mtk.manpages@googlemail.com, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: move reservation region support earlier
has been removed from the -mm tree.  Its filename was
     hugetlb-move-reservation-region-support-earlier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: move reservation region support earlier
From: Andy Whitcroft <apw@shadowen.org>

The following patch will require use of the reservation regions support. 
Move this earlier in the file.  No changes have been made to this code.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Acked-by: Adam Litke <agl@us.ibm.com>
Cc: Johannes Weiner <hannes@saeurebad.de>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |  246 ++++++++++++++++++++++++-------------------------
 1 file changed, 125 insertions(+), 121 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-move-reservation-region-support-earlier mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-move-reservation-region-support-earlier
+++ a/mm/hugetlb.c
@@ -41,6 +41,131 @@ static int hugetlb_next_nid;
 static DEFINE_SPINLOCK(hugetlb_lock);
 
 /*
+ * Region tracking -- allows tracking of reservations and instantiated pages
+ *                    across the pages in a mapping.
+ */
+struct file_region {
+	struct list_head link;
+	long from;
+	long to;
+};
+
+static long region_add(struct list_head *head, long f, long t)
+{
+	struct file_region *rg, *nrg, *trg;
+
+	/* Locate the region we are either in or before. */
+	list_for_each_entry(rg, head, link)
+		if (f <= rg->to)
+			break;
+
+	/* Round our left edge to the current segment if it encloses us. */
+	if (f > rg->from)
+		f = rg->from;
+
+	/* Check for and consume any regions we now overlap with. */
+	nrg = rg;
+	list_for_each_entry_safe(rg, trg, rg->link.prev, link) {
+		if (&rg->link == head)
+			break;
+		if (rg->from > t)
+			break;
+
+		/* If this area reaches higher then extend our area to
+		 * include it completely.  If this is not the first area
+		 * which we intend to reuse, free it. */
+		if (rg->to > t)
+			t = rg->to;
+		if (rg != nrg) {
+			list_del(&rg->link);
+			kfree(rg);
+		}
+	}
+	nrg->from = f;
+	nrg->to = t;
+	return 0;
+}
+
+static long region_chg(struct list_head *head, long f, long t)
+{
+	struct file_region *rg, *nrg;
+	long chg = 0;
+
+	/* Locate the region we are before or in. */
+	list_for_each_entry(rg, head, link)
+		if (f <= rg->to)
+			break;
+
+	/* If we are below the current region then a new region is required.
+	 * Subtle, allocate a new region at the position but make it zero
+	 * size such that we can guarantee to record the reservation. */
+	if (&rg->link == head || t < rg->from) {
+		nrg = kmalloc(sizeof(*nrg), GFP_KERNEL);
+		if (!nrg)
+			return -ENOMEM;
+		nrg->from = f;
+		nrg->to   = f;
+		INIT_LIST_HEAD(&nrg->link);
+		list_add(&nrg->link, rg->link.prev);
+
+		return t - f;
+	}
+
+	/* Round our left edge to the current segment if it encloses us. */
+	if (f > rg->from)
+		f = rg->from;
+	chg = t - f;
+
+	/* Check for and consume any regions we now overlap with. */
+	list_for_each_entry(rg, rg->link.prev, link) {
+		if (&rg->link == head)
+			break;
+		if (rg->from > t)
+			return chg;
+
+		/* We overlap with this area, if it extends futher than
+		 * us then we must extend ourselves.  Account for its
+		 * existing reservation. */
+		if (rg->to > t) {
+			chg += rg->to - t;
+			t = rg->to;
+		}
+		chg -= rg->to - rg->from;
+	}
+	return chg;
+}
+
+static long region_truncate(struct list_head *head, long end)
+{
+	struct file_region *rg, *trg;
+	long chg = 0;
+
+	/* Locate the region we are either in or before. */
+	list_for_each_entry(rg, head, link)
+		if (end <= rg->to)
+			break;
+	if (&rg->link == head)
+		return 0;
+
+	/* If we are in the middle of a region then adjust it. */
+	if (end > rg->from) {
+		chg = rg->to - end;
+		rg->to = end;
+		rg = list_entry(rg->link.next, typeof(*rg), link);
+	}
+
+	/* Drop any remaining regions. */
+	list_for_each_entry_safe(rg, trg, rg->link.prev, link) {
+		if (&rg->link == head)
+			break;
+		chg += rg->to - rg->from;
+		list_del(&rg->link);
+		kfree(rg);
+	}
+	return chg;
+}
+
+/*
  * Convert the address within this vma to the page offset within
  * the mapping, in base page units.
  */
@@ -1429,127 +1554,6 @@ void hugetlb_change_protection(struct vm
 	flush_tlb_range(vma, start, end);
 }
 
-struct file_region {
-	struct list_head link;
-	long from;
-	long to;
-};
-
-static long region_add(struct list_head *head, long f, long t)
-{
-	struct file_region *rg, *nrg, *trg;
-
-	/* Locate the region we are either in or before. */
-	list_for_each_entry(rg, head, link)
-		if (f <= rg->to)
-			break;
-
-	/* Round our left edge to the current segment if it encloses us. */
-	if (f > rg->from)
-		f = rg->from;
-
-	/* Check for and consume any regions we now overlap with. */
-	nrg = rg;
-	list_for_each_entry_safe(rg, trg, rg->link.prev, link) {
-		if (&rg->link == head)
-			break;
-		if (rg->from > t)
-			break;
-
-		/* If this area reaches higher then extend our area to
-		 * include it completely.  If this is not the first area
-		 * which we intend to reuse, free it. */
-		if (rg->to > t)
-			t = rg->to;
-		if (rg != nrg) {
-			list_del(&rg->link);
-			kfree(rg);
-		}
-	}
-	nrg->from = f;
-	nrg->to = t;
-	return 0;
-}
-
-static long region_chg(struct list_head *head, long f, long t)
-{
-	struct file_region *rg, *nrg;
-	long chg = 0;
-
-	/* Locate the region we are before or in. */
-	list_for_each_entry(rg, head, link)
-		if (f <= rg->to)
-			break;
-
-	/* If we are below the current region then a new region is required.
-	 * Subtle, allocate a new region at the position but make it zero
-	 * size such that we can guarantee to record the reservation. */
-	if (&rg->link == head || t < rg->from) {
-		nrg = kmalloc(sizeof(*nrg), GFP_KERNEL);
-		if (!nrg)
-			return -ENOMEM;
-		nrg->from = f;
-		nrg->to   = f;
-		INIT_LIST_HEAD(&nrg->link);
-		list_add(&nrg->link, rg->link.prev);
-
-		return t - f;
-	}
-
-	/* Round our left edge to the current segment if it encloses us. */
-	if (f > rg->from)
-		f = rg->from;
-	chg = t - f;
-
-	/* Check for and consume any regions we now overlap with. */
-	list_for_each_entry(rg, rg->link.prev, link) {
-		if (&rg->link == head)
-			break;
-		if (rg->from > t)
-			return chg;
-
-		/* We overlap with this area, if it extends futher than
-		 * us then we must extend ourselves.  Account for its
-		 * existing reservation. */
-		if (rg->to > t) {
-			chg += rg->to - t;
-			t = rg->to;
-		}
-		chg -= rg->to - rg->from;
-	}
-	return chg;
-}
-
-static long region_truncate(struct list_head *head, long end)
-{
-	struct file_region *rg, *trg;
-	long chg = 0;
-
-	/* Locate the region we are either in or before. */
-	list_for_each_entry(rg, head, link)
-		if (end <= rg->to)
-			break;
-	if (&rg->link == head)
-		return 0;
-
-	/* If we are in the middle of a region then adjust it. */
-	if (end > rg->from) {
-		chg = rg->to - end;
-		rg->to = end;
-		rg = list_entry(rg->link.next, typeof(*rg), link);
-	}
-
-	/* Drop any remaining regions. */
-	list_for_each_entry_safe(rg, trg, rg->link.prev, link) {
-		if (&rg->link == head)
-			break;
-		chg += rg->to - rg->from;
-		list_del(&rg->link);
-		kfree(rg);
-	}
-	return chg;
-}
