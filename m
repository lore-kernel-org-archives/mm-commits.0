Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC36C1A38D0
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 22:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723586674; cv=none; b=tpubPCobWtTmfqqX43C0fyFz6u6ftKIfsIQXJNsE0P0EL4hk9alJNfzXMEKbZkx1Yxyo5qGM5wWrN6bbFgLP65zmmMcsaJOxIlDxVMJSMa01EBXctKK3ro4/3B07y2S+fZL33stnDsUqyXb760if/EPwKHA5FaHijIrOEhDirOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723586674; c=relaxed/simple;
	bh=H6r2iOdYJrLlGrw7NLtylmQHDZntlwxWD09GvojkBCI=;
	h=Date:To:From:Subject:Message-Id; b=TdGWmbZuR+h8uD3/2IGx+me7ExU6AjLUBhz4GTODhh2d+vfMLZ+3p1Q1uOQUdGVQsFeblIETapBqt9VaY4oofUS5GGufvFFmZM58n8bGDdzBB3dY/1NGOcFGj84/d/zpHu7+FaRkHld6MeXsdJf+U1hAoHP8p010LN7ZwzsAssg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DxXGlVbt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DxXGlVbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ECA9C32782;
	Tue, 13 Aug 2024 22:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723586674;
	bh=H6r2iOdYJrLlGrw7NLtylmQHDZntlwxWD09GvojkBCI=;
	h=Date:To:From:Subject:From;
	b=DxXGlVbt0HhmqrG9X563xXgLRzHQCB+nYlAxBoVb/jaeLo5eD8j7m6Shxk35PEovG
	 T5Vt8dGqehxDJz/uHDzCpKi6UwGh2g7EKkF1V0wW3zI7kt0WvNXGTcgoIT97+wqBSV
	 F2xdkKPv8CzTgdjSSBIgFoBaE0mgRMdiRtANAv70=
Date: Tue, 13 Aug 2024 15:04:34 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,tglx@linutronix.de,pedro.falcato@gmail.com,npiggin@gmail.com,Liam.Howlett@oracle.com,jeffxu@google.com,david@redhat.com,christophe.leroy@csgroup.eu,mpe@ellerman.id.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-mm-handle-vdso-unmapping-via-close-rather-than-arch_unmap.patch added to mm-unstable branch
Message-Id: <20240813220434.9ECA9C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/mm: handle VDSO unmapping via close() rather than arch_unmap()
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-mm-handle-vdso-unmapping-via-close-rather-than-arch_unmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-mm-handle-vdso-unmapping-via-close-rather-than-arch_unmap.patch

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

mm-add-optional-close-to-struct-vm_special_mapping.patch
powerpc-mm-handle-vdso-unmapping-via-close-rather-than-arch_unmap.patch
mm-remove-arch_unmap.patch
powerpc-vdso-refactor-error-handling.patch

