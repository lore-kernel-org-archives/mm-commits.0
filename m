Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8954D1DED56
	for <mm-commits@vger.kernel.org>; Thu, 10 Apr 2025 02:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744252463; cv=none; b=bhFh087/3wl3q1cEA9K2ZS4qL+kl+rIhC0eVAyU+h9ID/AzEmeqOW4mLb1dtEdqrcBidZg9SB6v6J15H1R9e1RzZ/tA7TOlv0gC3CKpqmDgMhLwZMlZKJFdICqpfdTU06ZuUDOMFrNmV5VMtdgnSXtFfTaKcBxQR4DbC26N/L08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744252463; c=relaxed/simple;
	bh=WG/LTYjNIHpOhVMwS9Dy6uqxTxG9GVgAQH3/mK0fZA8=;
	h=Date:To:From:Subject:Message-Id; b=a/j/qG/ojlfyhS7xn8rPp2wthNG55GZOzQ5FEjEEmtjOJlpUHw/z365uEZKQ8MIiUPkPA4oL8WiP35Q32eaIC7cYFeHIdnfs2dpxu1kp5n8UNBaq/nCXzFH1564L7yR8JWyDhnpFOP9mr9xOCzlPpa8t+gRzXnn/EaLuZVORkIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QmwH4GD4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QmwH4GD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00894C4CEE2;
	Thu, 10 Apr 2025 02:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744252463;
	bh=WG/LTYjNIHpOhVMwS9Dy6uqxTxG9GVgAQH3/mK0fZA8=;
	h=Date:To:From:Subject:From;
	b=QmwH4GD4wygarng0yVKu7qFw7VkQ5KZcdT4g/CzpgDTGgFyxe+tXlhyaE1sa3CQ5U
	 hrBJ53qKo5ekB3+2BYy9P2IZCIFAsrfGvYaepfftwRRFTtXjgg+LQB+jKc455DU3j/
	 EuqRboFyFj36VXfD2eAlTiSpK4MOUbUtPVtSesWU=
Date: Wed, 09 Apr 2025 19:34:22 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-split-non-tlb-flushing-part-from-zap_page_range_single.patch added to mm-new branch
Message-Id: <20250410023423.00894C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: split non-tlb flushing part from zap_page_range_single()
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-split-non-tlb-flushing-part-from-zap_page_range_single.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-split-non-tlb-flushing-part-from-zap_page_range_single.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-madvise-define-and-use-madvise_behavior-struct-for-madvise_do_behavior.patch
mm-madvise-batch-tlb-flushes-for-madv_free.patch
mm-memory-split-non-tlb-flushing-part-from-zap_page_range_single.patch
mm-madvise-batch-tlb-flushes-for-madv_dontneed.patch

