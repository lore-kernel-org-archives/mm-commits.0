Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462D15381E
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247814; cv=none; b=bln34XXnP8eHJBbvM7UyfAooKNoSwxzWkWqN3f78uy9NXwUlFLEIN+Vr7KOsHNiIEDPtLqvE1nrGmlI876c0EIFKxQ1hIH+qhVtHTzOD1noud/Ec/GR3s2J9WMdi8jA/y91AfzMRfjA8Peht9RCgjEfLW4jmkJsMelfyFC9IXuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247814; c=relaxed/simple;
	bh=gK3Whw35ZfS9363zF1EUMzXuzc/8L+XMsTd+HJbeUWg=;
	h=Date:To:From:Subject:Message-Id; b=ZVzuEo6pNE1NsHfPVV8pQSsqmP+0BE+VIdBkoxT5xhVDq+3X0/GfgHDHRWVSXQq3JNz0UCxdoQyMdIcNOsy83LLaOfyUXJOLWFAEtsdmL63hC2uGIsYuN2a9Ut7crR9wI5YryYmuerP5tPDJXpRToOPfqVjWLuD84R1eEBWV6RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CK1eb1Dv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CK1eb1Dv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD0AC4CEC2;
	Mon,  2 Sep 2024 03:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247814;
	bh=gK3Whw35ZfS9363zF1EUMzXuzc/8L+XMsTd+HJbeUWg=;
	h=Date:To:From:Subject:From;
	b=CK1eb1DvqWeKLHlJFN7OLUs+kgDKn3vvqwq2RVwdCL6LEXWFf+ZpltL1by8HWkstn
	 9cDQWY3u0T7A058+X0WUlvtbGMa3DhCR4tgMyLvkRTUYrTYwm1w4wdgpIu2Em8j8tA
	 JKx8GakyUza7Uuhq0jOas8cCTpiHpnlAaHFPovQE=
Date: Sun, 01 Sep 2024 20:30:13 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,tglx@linutronix.de,pedro.falcato@gmail.com,npiggin@gmail.com,Liam.Howlett@oracle.com,jeffxu@google.com,david@redhat.com,christophe.leroy@csgroup.eu,mpe@ellerman.id.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-mm-handle-vdso-unmapping-via-close-rather-than-arch_unmap.patch removed from -mm tree
Message-Id: <20240902033014.1BD0AC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/mm: handle VDSO unmapping via close() rather than arch_unmap()
has been removed from the -mm tree.  Its filename was
     powerpc-mm-handle-vdso-unmapping-via-close-rather-than-arch_unmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: powerpc/mm: handle VDSO unmapping via close() rather than arch_unmap()
Date: Mon, 12 Aug 2024 18:26:03 +1000

Add a close() callback to the VDSO special mapping to handle unmapping of
the VDSO.  That will make it possible to remove the arch_unmap() hook
entirely in a subsequent patch.

Link: https://lkml.kernel.org/r/20240812082605.743814-2-mpe@ellerman.id.au
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/mmu_context.h |    4 ----
 arch/powerpc/kernel/vdso.c             |   17 +++++++++++++++++
 2 files changed, 17 insertions(+), 4 deletions(-)

--- a/arch/powerpc/include/asm/mmu_context.h~powerpc-mm-handle-vdso-unmapping-via-close-rather-than-arch_unmap
+++ a/arch/powerpc/include/asm/mmu_context.h
@@ -263,10 +263,6 @@ extern void arch_exit_mmap(struct mm_str
 static inline void arch_unmap(struct mm_struct *mm,
 			      unsigned long start, unsigned long end)
 {
-	unsigned long vdso_base = (unsigned long)mm->context.vdso;
-
-	if (start <= vdso_base && vdso_base < end)
-		mm->context.vdso = NULL;
 }
 
 #ifdef CONFIG_PPC_MEM_KEYS
--- a/arch/powerpc/kernel/vdso.c~powerpc-mm-handle-vdso-unmapping-via-close-rather-than-arch_unmap
+++ a/arch/powerpc/kernel/vdso.c
@@ -81,6 +81,21 @@ static int vdso64_mremap(const struct vm
 	return vdso_mremap(sm, new_vma, &vdso64_end - &vdso64_start);
 }
 
+static void vdso_close(const struct vm_special_mapping *sm, struct vm_area_struct *vma)
+{
+	struct mm_struct *mm = vma->vm_mm;
+
+	/*
+	 * close() is called for munmap() but also for mremap(). In the mremap()
+	 * case the vdso pointer has already been updated by the mremap() hook
+	 * above, so it must not be set to NULL here.
+	 */
+	if (vma->vm_start != (unsigned long)mm->context.vdso)
+		return;
+
+	mm->context.vdso = NULL;
+}
+
 static vm_fault_t vvar_fault(const struct vm_special_mapping *sm,
 			     struct vm_area_struct *vma, struct vm_fault *vmf);
 
@@ -92,11 +107,13 @@ static struct vm_special_mapping vvar_sp
 static struct vm_special_mapping vdso32_spec __ro_after_init = {
 	.name = "[vdso]",
 	.mremap = vdso32_mremap,
+	.close = vdso_close,
 };
 
 static struct vm_special_mapping vdso64_spec __ro_after_init = {
 	.name = "[vdso]",
 	.mremap = vdso64_mremap,
+	.close = vdso_close,
 };
 
 #ifdef CONFIG_TIME_NS
_

Patches currently in -mm which might be from mpe@ellerman.id.au are


