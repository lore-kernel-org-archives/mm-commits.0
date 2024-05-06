Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EDA3611E
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957126; cv=none; b=BBOHaiqeLQ469lVqn0MtyJAyplimZmkGfdgug4jCrkvZmcSJVd0MWQwywaYZWQ+orG1xBfAm4G3yqPekSAr0HDOFsfa8dWC6Oyd6/bKfsm4ndbANlo1cyhoSrM3yDcg59va7Wb8+nGN2ABXSLwDguw1S7T1jDRDbSGZDqCCh/uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957126; c=relaxed/simple;
	bh=9pEacH10dddu0/4a/Qg2XbbJAZKrEaZOJta78dugLSg=;
	h=Date:To:From:Subject:Message-Id; b=Zsho7S/j8Plo6Dz+VW2XXrioNoaWV00pNPxE57zI06mQxqg4FrVz5ST5L5q2RkTf7Ug8xFqygQFi26zjMeHccE3P5TYxzhMnGcJsLLtaQPL0FJkYIM321SUWwCWRusZsO+Wi4hH83YxNu7um1SZUfVUq7o74jrTLkUcvAFSgTjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xQSrIiAm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xQSrIiAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADFBC113CC;
	Mon,  6 May 2024 00:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957126;
	bh=9pEacH10dddu0/4a/Qg2XbbJAZKrEaZOJta78dugLSg=;
	h=Date:To:From:Subject:From;
	b=xQSrIiAmj/lXfVWpeHn7fItnC+GVQO5qHvgYb4ttYunBoLqho7wdmazOvWS7SsasQ
	 hLqft+SjOO5uzQ7ZBgbH/sMHBWtV2X/gQFezhDaj/xD082lRc4ibFTQjqMTpSml84G
	 dQ7vgi1cb0nx0X3eZr1EGQefbzECBDgst89a6Xm4=
Date: Sun, 05 May 2024 17:58:45 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,jannh@google.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-delay-the-check-for-a-null-anon_vma.patch removed from -mm tree
Message-Id: <20240506005846.6ADFBC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: delay the check for a NULL anon_vma
has been removed from the -mm tree.  Its filename was
     mm-delay-the-check-for-a-null-anon_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: delay the check for a NULL anon_vma
Date: Fri, 26 Apr 2024 15:45:01 +0100

Instead of checking the anon_vma early in the fault path where all page
faults pay the cost, delay it until we know we're going to need the
anon_vma to be filled in.  This will have a slight negative effect on the
first fault in an anonymous VMA, but it shortens every other page fault. 
It also makes the code slightly cleaner as the anon and file backed fault
handling look more similar.

The Intel kernel test bot reports a 3x improvement in vm-scalability
throughput with the small-allocs-mt test.  This is clearly an extreme
situation that won't be replicated in any real-world workload, but it's a
nice win.

https://lore.kernel.org/all/202404261055.c5e24608-oliver.sang@intel.com/

Link: https://lkml.kernel.org/r/20240426144506.1290619-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 ++++--
 mm/memory.c      |   29 ++++++++++++++++++-----------
 2 files changed, 22 insertions(+), 13 deletions(-)

--- a/mm/huge_memory.c~mm-delay-the-check-for-a-null-anon_vma
+++ a/mm/huge_memory.c
@@ -1057,11 +1057,13 @@ vm_fault_t do_huge_pmd_anonymous_page(st
 	gfp_t gfp;
 	struct folio *folio;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
+	vm_fault_t ret;
 
 	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
 		return VM_FAULT_FALLBACK;
-	if (unlikely(anon_vma_prepare(vma)))
-		return VM_FAULT_OOM;
+	ret = vmf_anon_prepare(vmf);
+	if (ret)
+		return ret;
 	khugepaged_enter_vma(vma, vma->vm_flags);
 
 	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
--- a/mm/memory.c~mm-delay-the-check-for-a-null-anon_vma
+++ a/mm/memory.c
@@ -3214,6 +3214,21 @@ static inline vm_fault_t vmf_can_call_fa
 	return VM_FAULT_RETRY;
 }
 
+/**
+ * vmf_anon_prepare - Prepare to handle an anonymous fault.
+ * @vmf: The vm_fault descriptor passed from the fault handler.
+ *
+ * When preparing to insert an anonymous page into a VMA from a
+ * fault handler, call this function rather than anon_vma_prepare().
+ * If this vma does not already have an associated anon_vma and we are
+ * only protected by the per-VMA lock, the caller must retry with the
+ * mmap_lock held.  __anon_vma_prepare() will look at adjacent VMAs to
+ * determine if this VMA can share its anon_vma, and that's not safe to
+ * do with only the per-VMA lock held for this VMA.
+ *
+ * Return: 0 if fault handling can proceed.  Any other value should be
+ * returned to the caller.
+ */
 vm_fault_t vmf_anon_prepare(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
@@ -4439,8 +4454,9 @@ static vm_fault_t do_anonymous_page(stru
 	}
 
 	/* Allocate our own private page. */
-	if (unlikely(anon_vma_prepare(vma)))
-		goto oom;
+	ret = vmf_anon_prepare(vmf);
+	if (ret)
+		return ret;
 	/* Returns NULL on OOM or ERR_PTR(-EAGAIN) if we must retry the fault */
 	folio = alloc_anon_folio(vmf);
 	if (IS_ERR(folio))
@@ -5828,15 +5844,6 @@ retry:
 	if (!vma_start_read(vma))
 		goto inval;
 
-	/*
-	 * find_mergeable_anon_vma uses adjacent vmas which are not locked.
-	 * This check must happen after vma_start_read(); otherwise, a
-	 * concurrent mremap() with MREMAP_DONTUNMAP could dissociate the VMA
-	 * from its anon_vma.
-	 */
-	if (unlikely(vma_is_anonymous(vma) && !vma->anon_vma))
-		goto inval_end_read;
-
 	/* Check since vm_start/vm_end might change before we lock the VMA */
 	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
 		goto inval_end_read;
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

