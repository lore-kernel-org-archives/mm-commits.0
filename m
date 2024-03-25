Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A904B4CB54
	for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2024 20:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711397735; cv=none; b=owBxDLwek8/JT4QR+T4hkIAc9OtuzmWa6nkUcGXrBq8HnV6cha804i7rnCLoXHXGwIVqGwn5vt59m+RWCl5I+5+N7sGl7SLON3zI8+C70y9pQbhBHMK7EZtxWazEIaQG87PPrUJJ23IaazkwQrFsiQX22wgKB3zAIXbOt9nM1Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711397735; c=relaxed/simple;
	bh=99nlgccY4LU71TebK7sKCwRyTlIp92NHg7Lxv0dq/RE=;
	h=Date:To:From:Subject:Message-Id; b=t3oKvrsL5rUQaKpLPt3uiP5ocmuDDGTgR7QvA5NGVUotmBJrkDcDkhfi0bcl/szNveH6zWvV+YkEvMsKn/o/pUKuGSxBuQ23AxTupjb351u4BgIhX26QuZtCeQiPKkd6h+31wNCXKWxklqZYENTlNSyyX2BAjzgDYMc8Pzzx/R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MAQCpBzz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MAQCpBzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA00AC433B2;
	Mon, 25 Mar 2024 20:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711397734;
	bh=99nlgccY4LU71TebK7sKCwRyTlIp92NHg7Lxv0dq/RE=;
	h=Date:To:From:Subject:From;
	b=MAQCpBzzEN3wFf3TMAP+RYx4xRAyZRzcBt7Nx3roSG/pneXG1SSKlyrCUAVV8eP1Z
	 bzRt4OQVf4f2DOI2GydHmI5okoc2nmXOEX6RecDZ6NNduSNNie+7pXTxg4g/OLmSm0
	 prqDcpNcRD2SoQWUYY1eXGM9zVr1c9xpIxXFmS8M=
Date: Mon, 25 Mar 2024 13:15:34 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,mingo@kernel.org,luto@kernel.org,fei1.li@intel.com,david@redhat.com,dave.hansen@linux.intel.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-follow_phys-to-arch-x86-mm-pat-memtypec.patch added to mm-unstable branch
Message-Id: <20240325201534.DA00AC433B2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: move follow_phys to arch/x86/mm/pat/memtype.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-follow_phys-to-arch-x86-mm-pat-memtypec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-follow_phys-to-arch-x86-mm-pat-memtypec.patch

This patch will later appear in the mm-unstable branch at
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
From: Christoph Hellwig <hch@lst.de>
Subject: mm: move follow_phys to arch/x86/mm/pat/memtype.c
Date: Mon, 25 Mar 2024 07:45:42 +0800

follow_phys is only used by two callers in arch/x86/mm/pat/memtype.c.  Move
it there and hardcode the two arguments that get the same values passed by
both callers.

Link: https://lkml.kernel.org/r/20240324234542.2038726-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Fei Li <fei1.li@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat/memtype.c |   22 ++++++++++++++++++++--
 include/linux/mm.h        |    2 --
 mm/memory.c               |   28 ----------------------------
 3 files changed, 20 insertions(+), 32 deletions(-)

--- a/arch/x86/mm/pat/memtype.c~mm-move-follow_phys-to-arch-x86-mm-pat-memtypec
+++ a/arch/x86/mm/pat/memtype.c
@@ -947,6 +947,24 @@ static void free_pfn_range(u64 paddr, un
 		memtype_free(paddr, paddr + size);
 }
 
+static int follow_phys(struct vm_area_struct *vma, unsigned long *prot,
+		resource_size_t *phys)
+{
+	pte_t *ptep, pte;
+	spinlock_t *ptl;
+
+	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
+		return -EINVAL;
+
+	if (follow_pte(vma->vm_mm, vma->vm_start, &ptep, &ptl))
+		return -EINVAL;
+	pte = ptep_get(ptep);
+	*prot = pgprot_val(pte_pgprot(pte));
+	*phys = (resource_size_t)pte_pfn(pte) << PAGE_SHIFT;
+	pte_unmap_unlock(ptep, ptl);
+	return 0;
+}
+
 /*
  * track_pfn_copy is called when vma that is covering the pfnmap gets
  * copied through copy_page_range().
@@ -966,7 +984,7 @@ int track_pfn_copy(struct vm_area_struct
 		 * reserve the whole chunk covered by vma. We need the
 		 * starting address and protection from pte.
 		 */
-		if (follow_phys(vma, vma->vm_start, 0, &prot, &paddr)) {
+		if (follow_phys(vma, &prot, &paddr)) {
 			WARN_ON_ONCE(1);
 			return -EINVAL;
 		}
@@ -1053,7 +1071,7 @@ void untrack_pfn(struct vm_area_struct *
 	/* free the chunk starting from pfn or the whole chunk */
 	paddr = (resource_size_t)pfn << PAGE_SHIFT;
 	if (!paddr && !size) {
-		if (follow_phys(vma, vma->vm_start, 0, &prot, &paddr)) {
+		if (follow_phys(vma, &prot, &paddr)) {
 			WARN_ON_ONCE(1);
 			return;
 		}
--- a/include/linux/mm.h~mm-move-follow_phys-to-arch-x86-mm-pat-memtypec
+++ a/include/linux/mm.h
@@ -2424,8 +2424,6 @@ int
 copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
 int follow_pte(struct mm_struct *mm, unsigned long address,
 	       pte_t **ptepp, spinlock_t **ptlp);
-int follow_phys(struct vm_area_struct *vma, unsigned long address,
-		unsigned int flags, unsigned long *prot, resource_size_t *phys);
 int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 			void *buf, int len, int write);
 
--- a/mm/memory.c~mm-move-follow_phys-to-arch-x86-mm-pat-memtypec
+++ a/mm/memory.c
@@ -5928,34 +5928,6 @@ out:
 EXPORT_SYMBOL_GPL(follow_pte);
 
 #ifdef CONFIG_HAVE_IOREMAP_PROT
-int follow_phys(struct vm_area_struct *vma,
-		unsigned long address, unsigned int flags,
-		unsigned long *prot, resource_size_t *phys)
-{
-	int ret = -EINVAL;
-	pte_t *ptep, pte;
-	spinlock_t *ptl;
-
-	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
-		goto out;
-
-	if (follow_pte(vma->vm_mm, address, &ptep, &ptl))
-		goto out;
-	pte = ptep_get(ptep);
-
-	if ((flags & FOLL_WRITE) && !pte_write(pte))
-		goto unlock;
-
-	*prot = pgprot_val(pte_pgprot(pte));
-	*phys = (resource_size_t)pte_pfn(pte) << PAGE_SHIFT;
-
-	ret = 0;
-unlock:
-	pte_unmap_unlock(ptep, ptl);
-out:
-	return ret;
-}
-
 /**
  * generic_access_phys - generic implementation for iomem mmap access
  * @vma: the vma to access
_

Patches currently in -mm which might be from hch@lst.de are

virt-acrn-stop-using-follow_pfn.patch
mm-remove-follow_pfn.patch
mm-move-follow_phys-to-arch-x86-mm-pat-memtypec.patch

