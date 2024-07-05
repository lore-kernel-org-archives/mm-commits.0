Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61F9A955
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141594; cv=none; b=kKly6em60cBmosrRD7zCaBJaX+ih3zLNeVq+/nUaApotPQXZe/hu+aalNDwbqmwHPoRE7DeW+zNVRTP1my8yyTGZbQlHysDfLEnnR9Rjs7dPIo5ZwVuOTbXk72y/mi90F+01eLiFP5pvoIGOftLZkm98n6w3N34LF1PZOJyMCHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141594; c=relaxed/simple;
	bh=3NLTx5WGy0L/x/7d4U2jt5sxSzh1d4oTPgjM7LpBCR0=;
	h=Date:To:From:Subject:Message-Id; b=KbDrQ1aP/hiHosqSBO6BGSGjwgUelUJJK9G2DMcdd6VjsWTKkICYBI3VsEBbpraR0ee7HRxFxH0UOkAxSKM21p4yzkdLNNm1wA/1r+/BzrjJYNDSGlUPcslFhytQTxPmWHNpmkMQAhQjVfiW8vam37u61fcxkAuv23HOzj6jj40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZnnmuaTG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZnnmuaTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D74CC3277B;
	Fri,  5 Jul 2024 01:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141594;
	bh=3NLTx5WGy0L/x/7d4U2jt5sxSzh1d4oTPgjM7LpBCR0=;
	h=Date:To:From:Subject:From;
	b=ZnnmuaTGGsgrdBk5vmGbuVnVjwmQLLJ5HzRq9Btuk0wOMzGe+TrkuopZpbNhpUiY0
	 vJfwVUDPA+u6Ma+UMgKA3SwGzVorqOP4SrlVYwJar02f0tdRF0q4IXhkoAruoTF4WY
	 KRE0d2JOpdU8HvjMwwVA31M+zgev5IWB5mqW6iP0=
Date: Thu, 04 Jul 2024 18:06:33 -0700
To: mm-commits@vger.kernel.org,shr@devkernel.io,hughd@google.com,david@redhat.com,aarcange@redhat.com,chengming.zhou@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-refactor-out-try_to_merge_with_zero_page.patch removed from -mm tree
Message-Id: <20240705010634.4D74CC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: refactor out try_to_merge_with_zero_page()
has been removed from the -mm tree.  Its filename was
     mm-ksm-refactor-out-try_to_merge_with_zero_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <chengming.zhou@linux.dev>
Subject: mm/ksm: refactor out try_to_merge_with_zero_page()
Date: Fri, 21 Jun 2024 15:54:29 +0800

Patch series "mm/ksm: cmp_and_merge_page() optimizations and cleanup", v2.

This series mainly optimizes cmp_and_merge_page() to have more efficient
separate code flow for ksm page and non-ksm anon page.

- ksm page: don't need to calculate the checksum obviously.
- anon page: don't need to search stable tree if changing fast and try
  to merge with zero page before searching ksm page on stable tree.

Please see the patch-2 for details.

Patch-3 is cleanup also a little optimization for the chain()/chain_prune
interfaces, which made the stable_tree_search()/stable_tree_insert() over
complex.

I have done simple testing using "hackbench -g 1 -l 300000" (maybe I need
to use a better workload) on my machine, have seen a little CPU usage
decrease of ksmd and some improvements of cmp_and_merge_page() latency:

We can see the latency of cmp_and_merge_page() when handling non-ksm anon
pages has been improved.


This patch (of 3):

In preparation for later changes, refactor out a new function called
try_to_merge_with_zero_page(), which tries to merge with zero page.

Link: https://lkml.kernel.org/r/20240621-b4-ksm-scan-optimize-v2-0-1c328aa9e30b@linux.dev
Link: https://lkml.kernel.org/r/20240621-b4-ksm-scan-optimize-v2-1-1c328aa9e30b@linux.dev
Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 
 mm/ksm.c     |   70 ++++++++++++++++++++++++++++---------------------
 2 files changed, 40 insertions(+), 31 deletions(-)

--- a/mm/hugetlb.c~mm-ksm-refactor-out-try_to_merge_with_zero_page
+++ a/mm/hugetlb.c
@@ -2666,7 +2666,6 @@ static int gather_surplus_pages(struct h
 retry:
 	spin_unlock_irq(&hugetlb_lock);
 	for (i = 0; i < needed; i++) {
-		folio = NULL;
 		for_each_node_mask(node, cpuset_current_mems_allowed) {
 			if (!mbind_nodemask || node_isset(node, *mbind_nodemask)) {
 				folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
--- a/mm/ksm.c~mm-ksm-refactor-out-try_to_merge_with_zero_page
+++ a/mm/ksm.c
@@ -1528,6 +1528,44 @@ out:
 }
 
 /*
+ * This function returns 0 if the pages were merged or if they are
+ * no longer merging candidates (e.g., VMA stale), -EFAULT otherwise.
+ */
+static int try_to_merge_with_zero_page(struct ksm_rmap_item *rmap_item,
+				       struct page *page)
+{
+	struct mm_struct *mm = rmap_item->mm;
+	int err = -EFAULT;
+
+	/*
+	 * Same checksum as an empty page. We attempt to merge it with the
+	 * appropriate zero page if the user enabled this via sysfs.
+	 */
+	if (ksm_use_zero_pages && (rmap_item->oldchecksum == zero_checksum)) {
+		struct vm_area_struct *vma;
+
+		mmap_read_lock(mm);
+		vma = find_mergeable_vma(mm, rmap_item->address);
+		if (vma) {
+			err = try_to_merge_one_page(vma, page,
+					ZERO_PAGE(rmap_item->address));
+			trace_ksm_merge_one_page(
+				page_to_pfn(ZERO_PAGE(rmap_item->address)),
+				rmap_item, mm, err);
+		} else {
+			/*
+			 * If the vma is out of date, we do not need to
+			 * continue.
+			 */
+			err = 0;
+		}
+		mmap_read_unlock(mm);
+	}
+
+	return err;
+}
+
+/*
  * try_to_merge_with_ksm_page - like try_to_merge_two_pages,
  * but no new kernel page is allocated: kpage must already be a ksm page.
  *
@@ -2302,7 +2340,6 @@ static void stable_tree_append(struct ks
  */
 static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_item)
 {
-	struct mm_struct *mm = rmap_item->mm;
 	struct ksm_rmap_item *tree_rmap_item;
 	struct page *tree_page = NULL;
 	struct ksm_stable_node *stable_node;
@@ -2371,36 +2408,9 @@ static void cmp_and_merge_page(struct pa
 		return;
 	}
 
-	/*
-	 * Same checksum as an empty page. We attempt to merge it with the
-	 * appropriate zero page if the user enabled this via sysfs.
-	 */
-	if (ksm_use_zero_pages && (checksum == zero_checksum)) {
-		struct vm_area_struct *vma;
+	if (!try_to_merge_with_zero_page(rmap_item, page))
+		return;
 
-		mmap_read_lock(mm);
-		vma = find_mergeable_vma(mm, rmap_item->address);
-		if (vma) {
-			err = try_to_merge_one_page(vma, page,
-					ZERO_PAGE(rmap_item->address));
-			trace_ksm_merge_one_page(
-				page_to_pfn(ZERO_PAGE(rmap_item->address)),
-				rmap_item, mm, err);
-		} else {
-			/*
-			 * If the vma is out of date, we do not need to
-			 * continue.
-			 */
-			err = 0;
-		}
-		mmap_read_unlock(mm);
-		/*
-		 * In case of failure, the page was not really empty, so we
-		 * need to continue. Otherwise we're done.
-		 */
-		if (!err)
-			return;
-	}
 	tree_rmap_item =
 		unstable_tree_search_insert(rmap_item, page, &tree_page);
 	if (tree_rmap_item) {
_

Patches currently in -mm which might be from chengming.zhou@linux.dev are

mm-zswap-use-only-one-pool-in-zswap.patch
mm-zswap-use-only-one-pool-in-zswap-v2.patch
mm-zswap-use-only-one-pool-in-zswap-v3.patch
mm-zsmalloc-fix-class-per-fullness-zspage-counts.patch
mm-zsmalloc-move-record_obj-into-obj_malloc.patch

