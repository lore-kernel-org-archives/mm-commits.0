Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1909F5CB0
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714956994; cv=none; b=sXKHW1Jo+gudIbCtr4w/b6yORk3vR0Q+5GhbOO/QBu+0/zgpAStjjueOHwbdEGlW+t9vaODmJKFyVQ6Kh3VZ6sW1izvhndaW2zR5SdQaRUB6PufAJAKzO2LlipjrlyPYmFlChBznOt0rQ/1ERHQRNcphDWBCOrli8SsC21kf+lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714956994; c=relaxed/simple;
	bh=Xuvw5G+xvbvLYlEuHirZC5hhhAJTSJml+2erNxOG8Wc=;
	h=Date:To:From:Subject:Message-Id; b=raE0N+XgdIYcmbsEHRKHpUaHxFnnXUVhCOZ2x9YZUWNE9y/lT+ugXPFtlH+0mCY5e1rAJV9jhVghuKNaENO5j38Fz3iwM61ruj9LmNMcqWQIIynflwI8tiHfaiC/EqyM3juW1JHdyShMvW5Xd2DjGNLBgDPH8DiBX3XrlLr/0W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=COa8tLk7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="COa8tLk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B02C116B1;
	Mon,  6 May 2024 00:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714956993;
	bh=Xuvw5G+xvbvLYlEuHirZC5hhhAJTSJml+2erNxOG8Wc=;
	h=Date:To:From:Subject:From;
	b=COa8tLk7056TTRGp+hu0qLNd7UVpQgjdksWa1kJXa469PrZ/0IgxGRzqNXebk7bSs
	 B3AA5c18O012sBEUYa5jWrxR/eWdIUJGn5pkS+STmBKe6JhDzgAAWOpygoj2ui4I23
	 QxP9VFluagQnWrj7IUJJ1lo+xyOVEYlnxJBKYk48=
Date: Sun, 05 May 2024 17:56:32 -0700
To: mm-commits@vger.kernel.org,yonghua.huang@intel.com,seanjc@google.com,pbonzini@redhat.com,mingo@redhat.com,hch@lst.de,hca@linux.ibm.com,gerald.schaefer@linux.ibm.com,fei1.li@intel.com,alex.williamson@redhat.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-follow_pte-improvements.patch removed from -mm tree
Message-Id: <20240506005633.75B02C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: follow_pte() improvements
has been removed from the -mm tree.  Its filename was
     mm-follow_pte-improvements.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: follow_pte() improvements
Date: Wed, 10 Apr 2024 17:55:27 +0200

follow_pte() is now our main function to lookup PTEs in VM_PFNMAP/VM_IO
VMAs.  Let's perform some more sanity checks to make this exported
function harder to abuse.

Further, extend the doc a bit, it still focuses on the KVM use case with
MMU notifiers.  Drop the KVM+follow_pfn() comment, follow_pfn() is no
more, and we have other users nowadays.

Also extend the doc regarding refcounted pages and the interaction with
MMU notifiers.

KVM is one example that uses MMU notifiers and can deal with refcounted
pages properly.  VFIO is one example that doesn't use MMU notifiers, and
to prevent use-after-free, rejects refcounted pages: pfn_valid(pfn) &&
!PageReserved(pfn_to_page(pfn)).  Protection changes are less of a concern
for users like VFIO: the behavior is similar to longterm-pinning a page,
and getting the PTE protection changed afterwards.

The primary concern with refcounted pages is use-after-free, which callers
should be aware of.

Link: https://lkml.kernel.org/r/20240410155527.474777-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Fei Li <fei1.li@intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Yonghua Huang <yonghua.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/mm/memory.c~mm-follow_pte-improvements
+++ a/mm/memory.c
@@ -5933,15 +5933,21 @@ int __pmd_alloc(struct mm_struct *mm, pu
  *
  * On a successful return, the pointer to the PTE is stored in @ptepp;
  * the corresponding lock is taken and its location is stored in @ptlp.
- * The contents of the PTE are only stable until @ptlp is released;
- * any further use, if any, must be protected against invalidation
- * with MMU notifiers.
+ *
+ * The contents of the PTE are only stable until @ptlp is released using
+ * pte_unmap_unlock(). This function will fail if the PTE is non-present.
+ * Present PTEs may include PTEs that map refcounted pages, such as
+ * anonymous folios in COW mappings.
+ *
+ * Callers must be careful when relying on PTE content after
+ * pte_unmap_unlock(). Especially if the PTE maps a refcounted page,
+ * callers must protect against invalidation with MMU notifiers; otherwise
+ * access to the PFN at a later point in time can trigger use-after-free.
  *
  * Only IO mappings and raw PFN mappings are allowed.  The mmap semaphore
  * should be taken for read.
  *
- * KVM uses this function.  While it is arguably less bad than the historic
- * ``follow_pfn``, it is not a good general-purpose API.
+ * This function must not be used to modify PTE content.
  *
  * Return: zero on success, -ve otherwise.
  */
@@ -5955,6 +5961,10 @@ int follow_pte(struct vm_area_struct *vm
 	pmd_t *pmd;
 	pte_t *ptep;
 
+	mmap_assert_locked(mm);
+	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
+		goto out;
+
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
 		goto out;
 
_

Patches currently in -mm which might be from david@redhat.com are


