From: akpm@linux-foundation.org
Subject: - hugetlb-reservations-move-region-tracking-earlier.patch removed from -mm tree
Date: Thu, 03 Jul 2008 15:26:17 -0700
Message-ID: <200807032226.m63MQInb030517@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754811AbYGCWck (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jul 2008 18:32:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, agl@us.ibm.com, hannes@saeurebad.de, hugh@veritas.com, kniht@linux.vnet.ibm.com, mel@csn.ul.ie, mtk.manpages@googlemail.com, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb reservations: move region tracking earlier
has been removed from the -mm tree.  Its filename was
     hugetlb-reservations-move-region-tracking-earlier.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb reservations: move region tracking earlier
From: Andy Whitcroft <apw@shadowen.org>

As reported by Adam Litke and Jon Tollefson one of the libhugetlbfs
regression tests triggers a negative overall reservation count.  When
this occurs where there is no dynamic pool enabled tests will fail.

Following this email are two patches to address this issue:

hugetlb reservations: move region tracking earlier -- simply moves the
  region tracking code earlier so we do not have to supply prototypes, and

hugetlb reservations: fix hugetlb MAP_PRIVATE reservations across vma
  splits -- which moves us to tracking the consumed reservation so that
  we can correctly calculate the remaining reservations at vma close time.

This stack is against the top of v2.6.25-rc6-mm3, should this solution
prove acceptable it would need slipping underneath Nick's multiple hugepage
size patches and those updated.  I have a modified stack prepared for that.

This version incorporates Mel's feedback (both cosmetic, and an allocation
under spinlock issue) and has an improved layout.

Changes in V2:
 - commentry updates
 - pull allocations out from under hugetlb_lock
 - refactor to match shared code layout
 - reinstate BUG_ON's


This patch:

Move the region tracking code much earlier so we can use it for page
presence tracking later on.  No code is changed, just its location.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Johannes Weiner <hannes@saeurebad.de>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Jon Tollefson <kniht@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |  246 ++++++++++++++++++++++++-------------------------
 1 file changed, 125 insertions(+), 121 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-reservations-move-region-tracking-earlier mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-reservations-move-region-tracking-earlier
+++ a/mm/hugetlb.c
@@ -47,6 +47,131 @@ static unsigned long __initdata default_
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
  * the mapping, in pagecache page units; huge pages here.
  */
@@ -638,127 +763,6 @@ static void return_unused_surplus_pages(
 	}
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
-
 /*
  * Determine if the huge page at addr within the vma has an associated
  * reservation.  Where it does not we will need to logically increase
_

Patches currently in -mm which might be from apw@shadowen.org are

linux-next.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
add-a-helper-function-to-test-if-an-object-is-on-the-stack.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
buddy-clarify-comments-describing-buddy-merge.patch
page-flags-record-page-flag-overlays-explicitly.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
hugetlb-move-hugetlb_acct_memory.patch
hugetlb-reserve-huge-pages-for-reliable-map_private-hugetlbfs-mappings-until-fork.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-move-reservation-region-support-earlier-fix.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
hugetlb-reservations-fix-hugetlb-map_private-reservations-across-vma-splits-v2.patch
vma-page-offset-has-no-callees-drop-it.patch
hugetlb-fix-race-when-reading-proc-meminfo.patch
memory-hotplugallocate-usemap-on-the-section-with-pgdat-take-4.patch
memory-hotplug-small-fixes-to-bootmem-freeing-for-memory-hotremove.patch
memory-hotplug-dont-calculate-vm_total_pages-twice-when-rebuilding-zonelists-in-online_pages.patch
checkpatch-version-020.patch
checkpatch-return-is-not-a-function-parentheses-for-casts-are-ok-too.patch
checkpatch-types-some-types-may-also-be-identifiers.patch
checkpatch-add-a-checkpatch-warning-for-new-uses-of-__initcall.patch
checkpatch-possible-types-__asm__-is-never-a-type.patch
checkpatch-comment-detection-ignore-macro-continuation-when-detecting-associated-comments.patch
checkpatch-types-unary-goto-introduces-unary-context.patch
checkpatch-macros-fix-statement-counting-block-end-detection.patch
checkpatch-trailing-statement-indent-fix-end-of-statement-location.patch
checkpatch-allow-printk-strings-to-exceed-80-characters-to-maintain-their-searchability.patch
checkpatch-switch-report-trailing-statements-on-case-and-default.patch
checkpatch-check-spacing-for-square-brackets.patch
checkpatch-toughen-trailing-if-statement-checks-and-extend-them-to-while-and-for.patch
checkpatch-condition-loop-indent-checks.patch
checkpatch-usb_free_urb-can-take-null.patch
checkpatch-correct-spelling-in-kfree-checks.patch
checkpatch-allow-for-type-modifiers-on-multiple-declarations.patch
checkpatch-improve-type-matcher-debug.patch
checkpatch-possible-modifiers-are-not-being-correctly-matched.patch
checkpatch-macro-complexity-checks-are-meaningless-in-linker-scripts.patch
checkpatch-handle-return-types-of-pointers-to-functions.patch
checkpatch-possible-types-known-modifiers-cannot-be-types.patch
checkpatch-possible-modifiers-handle-multiple-modifiers-and-trailing.patch
checkpatch-add-checks-for-question-mark-and-colon-spacing.patch
checkpatch-variants-move-the-main-unary-binary-operators-to-use-variants.patch
checkpatch-complex-macros-need-to-ignore-comments.patch
checkpatch-types-cannot-start-mid-word-for-pointer-tests.patch
checkpatch-version-021.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
page-owner-tracking-leak-detector.patch

