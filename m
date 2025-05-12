Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660ACC2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011113; cv=none; b=h25ek7t98+wWb1XOKBSUBdm9goUgTRIygMJlMCnllDj4QENSf1Vl06AIUTZ6f+6DlclXoQrHsCgIxAEY12KBCtxxTPiVxICbc3BfACUVepHrtGGWL3UqMAwEnHZrj/SXCt5MjwuADlBFPurixV4EOeYPHy4R535TFZcLiKbjPHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011113; c=relaxed/simple;
	bh=hvELWJtdnTQz7VC5xmBsdNDkgin3hoNGj29ffzdPTBo=;
	h=Date:To:From:Subject:Message-Id; b=eab886IL15HjAvG0v2sFwgPyai3fIAdQ0QsyiU1VfhcWn5f1tNKtrn6LHKQZF8S+iPgFkGT98Jp3qR30aFc8mNtVGuLcpMFhk6FGZyv/6BGtt6tJDcwSXFb8srcVrK0Yphygr0O4EGFM78FXO/jQkWzps7yYUZhXLwQNThJzK4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UWksO2ov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UWksO2ov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D07EC4CEE4;
	Mon, 12 May 2025 00:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011113;
	bh=hvELWJtdnTQz7VC5xmBsdNDkgin3hoNGj29ffzdPTBo=;
	h=Date:To:From:Subject:From;
	b=UWksO2ov2yzxRBrKe6eLFl6WWwt53Pn9wrdLb7DY69mscd6xcVSBis0HSSNohJvs3
	 83qwU3XxNwMs4Zl3M6WIgDq7uTh1NWOm9Il2yRbI6uPX+UG6DYrIInn+7JSfCEB5mV
	 4Lg58XtBvPYpW2whux65lkfx5qoYwpWkH5vA4SNw=
Date: Sun, 11 May 2025 17:51:52 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-split-non-tlb-flushing-part-from-zap_page_range_single.patch removed from -mm tree
Message-Id: <20250512005153.3D07EC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: split non-tlb flushing part from zap_page_range_single()
has been removed from the -mm tree.  Its filename was
     mm-memory-split-non-tlb-flushing-part-from-zap_page_range_single.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/memory: split non-tlb flushing part from zap_page_range_single()
Date: Wed, 9 Apr 2025 17:00:21 -0700

Some of zap_page_range_single() callers such as [process_]madvise() with
MADV_DONTNEED[_LOCKED] cannot batch tlb flushes because
zap_page_range_single() flushes tlb for each invocation.  Split out the
body of zap_page_range_single() except mmu_gather object initialization
and gathered tlb entries flushing for such batched tlb flushing usage.

To avoid hugetlb pages allocation failures from concurrent page faults,
the tlb flush should be done before hugetlb faults unlocking, though.  Do
the flush and the unlock inside the split out function in the order for
hugetlb vma case.  Refer to commit 2820b0f09be9 ("hugetlbfs: close race
between MADV_DONTNEED and page fault") for more details about the
concurrent faults' page allocation failure problem.

Link: https://lkml.kernel.org/r/20250410000022.1901-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   49 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 39 insertions(+), 10 deletions(-)

--- a/mm/memory.c~mm-memory-split-non-tlb-flushing-part-from-zap_page_range_single
+++ a/mm/memory.c
@@ -1998,36 +1998,65 @@ void unmap_vmas(struct mmu_gather *tlb,
 	mmu_notifier_invalidate_range_end(&range);
 }
 
-/**
- * zap_page_range_single - remove user pages in a given range
+/*
+ * zap_page_range_single_batched - remove user pages in a given range
+ * @tlb: pointer to the caller's struct mmu_gather
  * @vma: vm_area_struct holding the applicable pages
- * @address: starting address of pages to zap
- * @size: number of bytes to zap
+ * @address: starting address of pages to remove
+ * @size: number of bytes to remove
  * @details: details of shared cache invalidation
  *
- * The range must fit into one VMA.
+ * @tlb shouldn't be NULL.  The range must fit into one VMA.  If @vma is for
+ * hugetlb, @tlb is flushed and re-initialized by this function.
  */
-void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
+static void zap_page_range_single_batched(struct mmu_gather *tlb,
+		struct vm_area_struct *vma, unsigned long address,
 		unsigned long size, struct zap_details *details)
 {
 	const unsigned long end = address + size;
 	struct mmu_notifier_range range;
-	struct mmu_gather tlb;
+
+	VM_WARN_ON_ONCE(!tlb || tlb->mm != vma->vm_mm);
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				address, end);
 	hugetlb_zap_begin(vma, &range.start, &range.end);
-	tlb_gather_mmu(&tlb, vma->vm_mm);
 	update_hiwater_rss(vma->vm_mm);
 	mmu_notifier_invalidate_range_start(&range);
 	/*
 	 * unmap 'address-end' not 'range.start-range.end' as range
 	 * could have been expanded for hugetlb pmd sharing.
 	 */
-	unmap_single_vma(&tlb, vma, address, end, details, false);
+	unmap_single_vma(tlb, vma, address, end, details, false);
 	mmu_notifier_invalidate_range_end(&range);
+	if (is_vm_hugetlb_page(vma)) {
+		/*
+		 * flush tlb and free resources before hugetlb_zap_end(), to
+		 * avoid concurrent page faults' allocation failure.
+		 */
+		tlb_finish_mmu(tlb);
+		hugetlb_zap_end(vma, details);
+		tlb_gather_mmu(tlb, vma->vm_mm);
+	}
+}
+
+/**
+ * zap_page_range_single - remove user pages in a given range
+ * @vma: vm_area_struct holding the applicable pages
+ * @address: starting address of pages to zap
+ * @size: number of bytes to zap
+ * @details: details of shared cache invalidation
+ *
+ * The range must fit into one VMA.
+ */
+void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
+		unsigned long size, struct zap_details *details)
+{
+	struct mmu_gather tlb;
+
+	tlb_gather_mmu(&tlb, vma->vm_mm);
+	zap_page_range_single_batched(&tlb, vma, address, size, details);
 	tlb_finish_mmu(&tlb);
-	hugetlb_zap_end(vma, details);
 }
 
 /**
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damos-quota-goal-metrics-for-memory-node-utilization.patch
mm-damon-sysfs-schemes-implement-file-for-quota-goal-nid-parameter.patch
mm-damon-sysfs-schemes-connect-damos_quota_goal-nid-with-core-layer.patch
docs-mm-damon-design-document-node_mem_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-nid-file.patch
docs-abi-damon-document-nid-file.patch
samples-damon-implement-a-damon-module-for-memory-tiering.patch

