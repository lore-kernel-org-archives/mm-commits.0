Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE39142A9F
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247815; cv=none; b=penAXlqLocKwoj23+qdVRRtN//oLaKSBGwfE2KVf+0tcbBxu6iouSzMZuliHrVXCuHJbrqxjrdOdZNA91FaeTL2zCuSe1+ttxugXL6ilupd6l/CPfSOG4vzorc7WV1gGSr4adIPD0iguZiXW+8up2edyDV8hZBftDkEU4RTx0g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247815; c=relaxed/simple;
	bh=16YZ6V5Xm0v9bmnw+kLWzZC6PX+zDmE8TTwnaj8my2g=;
	h=Date:To:From:Subject:Message-Id; b=VNf849XLcOOHCO5+VFKQr3hJB3VpHsGrnq4KY1EtnQvcyRy/ob+bI5hGknEnvS9IEZjb8NCWwlhH0IugrPeL530jHQ9pURSDfGgT7oSeIfhrCzYqCYp/vddDkLDP34Wcqr1p+YlUhxDgc4UTxJ6kP2YBUVO4I3SNMDb8Q2aNVB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y3/542qn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y3/542qn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D0CC4CEC2;
	Mon,  2 Sep 2024 03:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247815;
	bh=16YZ6V5Xm0v9bmnw+kLWzZC6PX+zDmE8TTwnaj8my2g=;
	h=Date:To:From:Subject:From;
	b=y3/542qnevC87YkWW6vPuDjPoCRYXMLBEKFbIowMtHEd6ertFD8F5v5VtVnBToBMT
	 t5ZwH0rz9R9MroijYDPgaI6fNPNezg4ocjbnm0UbYkTY/WS6LwzigBywjRgb/BDPlB
	 nJ4cyYU6e7RkxdUFJIpuEykMonMSEp/BL7mtNZ7Q=
Date: Sun, 01 Sep 2024 20:30:14 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,tglx@linutronix.de,pedro.falcato@gmail.com,npiggin@gmail.com,Liam.Howlett@oracle.com,jeffxu@google.com,david@redhat.com,christophe.leroy@csgroup.eu,mpe@ellerman.id.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-arch_unmap.patch removed from -mm tree
Message-Id: <20240902033015.36D0CC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove arch_unmap()
has been removed from the -mm tree.  Its filename was
     mm-remove-arch_unmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: mm: remove arch_unmap()
Date: Mon, 12 Aug 2024 18:26:04 +1000

Now that powerpc no longer uses arch_unmap() to handle VDSO unmapping,
there are no meaningful implementions left.  Drop support for it entirely,
and update comments which refer to it.

Link: https://lkml.kernel.org/r/20240812082605.743814-3-mpe@ellerman.id.au
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/mmu_context.h |    5 -----
 arch/x86/include/asm/mmu_context.h     |    5 -----
 include/asm-generic/mm_hooks.h         |   11 +++--------
 mm/mmap.c                              |    4 +---
 mm/vma.c                               |    8 ++------
 5 files changed, 6 insertions(+), 27 deletions(-)

--- a/arch/powerpc/include/asm/mmu_context.h~mm-remove-arch_unmap
+++ a/arch/powerpc/include/asm/mmu_context.h
@@ -260,11 +260,6 @@ static inline void enter_lazy_tlb(struct
 
 extern void arch_exit_mmap(struct mm_struct *mm);
 
-static inline void arch_unmap(struct mm_struct *mm,
-			      unsigned long start, unsigned long end)
-{
-}
-
 #ifdef CONFIG_PPC_MEM_KEYS
 bool arch_vma_access_permitted(struct vm_area_struct *vma, bool write,
 			       bool execute, bool foreign);
--- a/arch/x86/include/asm/mmu_context.h~mm-remove-arch_unmap
+++ a/arch/x86/include/asm/mmu_context.h
@@ -232,11 +232,6 @@ static inline bool is_64bit_mm(struct mm
 }
 #endif
 
-static inline void arch_unmap(struct mm_struct *mm, unsigned long start,
-			      unsigned long end)
-{
-}
-
 /*
  * We only want to enforce protection keys on the current process
  * because we effectively have no access to PKRU for other
--- a/include/asm-generic/mm_hooks.h~mm-remove-arch_unmap
+++ a/include/asm-generic/mm_hooks.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * Define generic no-op hooks for arch_dup_mmap, arch_exit_mmap
- * and arch_unmap to be included in asm-FOO/mmu_context.h for any
- * arch FOO which doesn't need to hook these.
+ * Define generic no-op hooks for arch_dup_mmap and arch_exit_mmap
+ * to be included in asm-FOO/mmu_context.h for any arch FOO which
+ * doesn't need to hook these.
  */
 #ifndef _ASM_GENERIC_MM_HOOKS_H
 #define _ASM_GENERIC_MM_HOOKS_H
@@ -17,11 +17,6 @@ static inline void arch_exit_mmap(struct
 {
 }
 
-static inline void arch_unmap(struct mm_struct *mm,
-			unsigned long start, unsigned long end)
-{
-}
-
 static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
 		bool write, bool execute, bool foreign)
 {
--- a/mm/mmap.c~mm-remove-arch_unmap
+++ a/mm/mmap.c
@@ -1743,14 +1743,12 @@ int do_vma_munmap(struct vma_iterator *v
 	struct mm_struct *mm = vma->vm_mm;
 
 	/*
-	 * Check if memory is sealed before arch_unmap.
-	 * Prevent unmapping a sealed VMA.
+	 * Check if memory is sealed, prevent unmapping a sealed VMA.
 	 * can_modify_mm assumes we have acquired the lock on MM.
 	 */
 	if (unlikely(!can_modify_mm(mm, start, end)))
 		return -EPERM;
 
-	arch_unmap(mm, start, end);
 	return do_vmi_align_munmap(vmi, vma, mm, start, end, uf, unlock);
 }
 
--- a/mm/vma.c~mm-remove-arch_unmap
+++ a/mm/vma.c
@@ -841,7 +841,7 @@ map_count_exceeded:
  *
  * This function takes a @mas that is either pointing to the previous VMA or set
  * to MA_START and sets it up to remove the mapping(s).  The @len will be
- * aligned and any arch_unmap work will be preformed.
+ * aligned.
  *
  * Return: 0 on success and drops the lock if so directed, error and leaves the
  * lock held otherwise.
@@ -861,16 +861,12 @@ int do_vmi_munmap(struct vma_iterator *v
 		return -EINVAL;
 
 	/*
-	 * Check if memory is sealed before arch_unmap.
-	 * Prevent unmapping a sealed VMA.
+	 * Check if memory is sealed, prevent unmapping a sealed VMA.
 	 * can_modify_mm assumes we have acquired the lock on MM.
 	 */
 	if (unlikely(!can_modify_mm(mm, start, end)))
 		return -EPERM;
 
-	 /* arch_unmap() might do unmaps itself.  */
-	arch_unmap(mm, start, end);
-
 	/* Find the first overlapping VMA */
 	vma = vma_find(vmi, end);
 	if (!vma) {
_

Patches currently in -mm which might be from mpe@ellerman.id.au are


