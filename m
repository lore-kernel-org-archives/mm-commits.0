Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA461A38D0
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 22:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723586677; cv=none; b=nHh0BEUIQT6yMPCKKQkpTCaaJlm5K4QO3G7i1Rpm+yrRJJ3spXxiMThVgKgnSevAZRcapdMsbmJ8F45S5Wm1zkt+1LS0vVAxdvNgfVEBrkBORjOhQ3/kg8R+KqP990eEa9YSR1k7OYIY3VuG9dUm5JwFSgzzeCuq8sRghdWTK0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723586677; c=relaxed/simple;
	bh=fHkgdFCaG6N+lKSLJ+Af6U7n+II3oLWa59kMhTyejUA=;
	h=Date:To:From:Subject:Message-Id; b=oNrNgC64DQNsVaIRVax1jyhU1jNj31zpcrG6UR/mVn3h50Xe/zNAAE34JHh6sTasFU6d7w+aukfIdodeouq/Pte6DzivylvgUQUlFuPMP2vYQ1V6HRh/T+oSPzD4vc0Z2i9ocKMwPfx/sQgCG3sVYFhC+xt3TOTzbT8DgsHHoqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0Avdzagr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0Avdzagr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BBDC32782;
	Tue, 13 Aug 2024 22:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723586677;
	bh=fHkgdFCaG6N+lKSLJ+Af6U7n+II3oLWa59kMhTyejUA=;
	h=Date:To:From:Subject:From;
	b=0AvdzagrwyTAPIDUkgPbRG3mvPyN6nwbO6Yz52VLENqoEfVWe5yEZgxT3vRFcGcOj
	 tExB3MOFX/WRGpOiXsxoXKsaFL0/Oa9ChR1rKlXo2CmQzO8g7M/SYEbAu0l3FdUwBK
	 uRiYw4+1XCXgpKU0zxVkRTgb2RXHaHAQMEGcx0L4=
Date: Tue, 13 Aug 2024 15:04:36 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,tglx@linutronix.de,pedro.falcato@gmail.com,npiggin@gmail.com,Liam.Howlett@oracle.com,jeffxu@google.com,david@redhat.com,christophe.leroy@csgroup.eu,mpe@ellerman.id.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-arch_unmap.patch added to mm-unstable branch
Message-Id: <20240813220437.05BBDC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove arch_unmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-arch_unmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-arch_unmap.patch

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

mm-add-optional-close-to-struct-vm_special_mapping.patch
powerpc-mm-handle-vdso-unmapping-via-close-rather-than-arch_unmap.patch
mm-remove-arch_unmap.patch
powerpc-vdso-refactor-error-handling.patch

