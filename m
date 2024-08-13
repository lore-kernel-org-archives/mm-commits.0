Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD1B1A38D0
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 22:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723586682; cv=none; b=U3ChJQ3p/PG0A/f8A8Bj4laEiDYUt9PuzeaV9im9zI06kfPsHFj+2VGX1KOxdK9lONZ55xJnFRQ0fKXqRv2AO4t/Wcb334nLd/GTk1NRJ5tBupglXc2gJZba657v8QRF4Su+crWxJKdnunLgHeqKAlHXTz3dUAiEp2RVKJ7WGQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723586682; c=relaxed/simple;
	bh=xe2lQWnTb9oTRrGvT1Qb5Q84UMyXH+UggMy3JKhSYOo=;
	h=Date:To:From:Subject:Message-Id; b=qQg+uMd6/m9Gt42Ei4rgqSBi3t6DpgBy5plC+e+xSgYeeTNGtlfmn4Ocal/+vCofmBG69enRsiAsQTynLSqmVccu9COeTGutdRzpjP4YDXgXwmALPEl3BsmD4H5tdgrQLVuUfuujEwO7798S0uqYbOiRJIIMWMZyJZ+CXJra/6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h4f6uk/r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h4f6uk/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6742BC32782;
	Tue, 13 Aug 2024 22:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723586680;
	bh=xe2lQWnTb9oTRrGvT1Qb5Q84UMyXH+UggMy3JKhSYOo=;
	h=Date:To:From:Subject:From;
	b=h4f6uk/r4kfEJb5BTmm6ZP/18c5DCvxayQeUUFWTwrgOVfo5c/46CziU4ODqRvMSk
	 9lbBB89wpoJz32hw4VU91sX7TZNutAplUF+7whHDzx5mqZwTT/8em8pIvm9g7Y5wMk
	 SS7+J2DFb19xPBuSdXOdCEgLXa9bSlqC5wppEpuU=
Date: Tue, 13 Aug 2024 15:04:39 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,tglx@linutronix.de,pedro.falcato@gmail.com,npiggin@gmail.com,Liam.Howlett@oracle.com,jeffxu@google.com,david@redhat.com,christophe.leroy@csgroup.eu,mpe@ellerman.id.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-vdso-refactor-error-handling.patch added to mm-unstable branch
Message-Id: <20240813220440.6742BC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/vdso: refactor error handling
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-vdso-refactor-error-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-vdso-refactor-error-handling.patch

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
Subject: powerpc/vdso: refactor error handling
Date: Mon, 12 Aug 2024 18:26:05 +1000

Linus noticed that the error handling in __arch_setup_additional_pages()
fails to clear the mm VDSO pointer if _install_special_mapping() fails. 
In practice there should be no actual bug, because if there's an error the
VDSO pointer is cleared later in arch_setup_additional_pages().

However it's no longer necessary to set the pointer before installing the
mapping.  Commit c1bab64360e6 ("powerpc/vdso: Move to
_install_special_mapping() and remove arch_vma_name()") reworked the code
so that the VMA name comes from the vm_special_mapping.name, rather than
relying on arch_vma_name().

So rework the code to only set the VDSO pointer once the mappings have
been installed correctly, and remove the stale comment.

Link: https://lkml.kernel.org/r/20240812082605.743814-4-mpe@ellerman.id.au
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/vdso.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

--- a/arch/powerpc/kernel/vdso.c~powerpc-vdso-refactor-error-handling
+++ a/arch/powerpc/kernel/vdso.c
@@ -214,13 +214,6 @@ static int __arch_setup_additional_pages
 	/* Add required alignment. */
 	vdso_base = ALIGN(vdso_base, VDSO_ALIGNMENT);
 
-	/*
-	 * Put vDSO base into mm struct. We need to do this before calling
-	 * install_special_mapping or the perf counter mmap tracking code
-	 * will fail to recognise it as a vDSO.
-	 */
-	mm->context.vdso = (void __user *)vdso_base + vvar_size;
-
 	vma = _install_special_mapping(mm, vdso_base, vvar_size,
 				       VM_READ | VM_MAYREAD | VM_IO |
 				       VM_DONTDUMP | VM_PFNMAP, &vvar_spec);
@@ -240,10 +233,15 @@ static int __arch_setup_additional_pages
 	vma = _install_special_mapping(mm, vdso_base + vvar_size, vdso_size,
 				       VM_READ | VM_EXEC | VM_MAYREAD |
 				       VM_MAYWRITE | VM_MAYEXEC, vdso_spec);
-	if (IS_ERR(vma))
+	if (IS_ERR(vma)) {
 		do_munmap(mm, vdso_base, vvar_size, NULL);
+		return PTR_ERR(vma);
+	}
+
+	// Now that the mappings are in place, set the mm VDSO pointer
+	mm->context.vdso = (void __user *)vdso_base + vvar_size;
 
-	return PTR_ERR_OR_ZERO(vma);
+	return 0;
 }
 
 int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
@@ -257,8 +255,6 @@ int arch_setup_additional_pages(struct l
 		return -EINTR;
 
 	rc = __arch_setup_additional_pages(bprm, uses_interp);
-	if (rc)
-		mm->context.vdso = NULL;
 
 	mmap_write_unlock(mm);
 	return rc;
_

Patches currently in -mm which might be from mpe@ellerman.id.au are

mm-add-optional-close-to-struct-vm_special_mapping.patch
powerpc-mm-handle-vdso-unmapping-via-close-rather-than-arch_unmap.patch
mm-remove-arch_unmap.patch
powerpc-vdso-refactor-error-handling.patch

