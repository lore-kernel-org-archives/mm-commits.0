Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810E242A9F
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247816; cv=none; b=sHTltOfpvIkA4dHdpf1i4BOO1lPUjRHmyw/2mAlJYsMHr6jV6jg0LyXBmmnd/jhrQZdPttZrfUgMF7E9RhxkpQMNP6DAgsrwYk4epZaW1DnviUDKXfDIZ1RVjWVbBd+c3+Gth/4xB/BQzD6Ec2irXXazEegK4j/8n0SNl0dPxHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247816; c=relaxed/simple;
	bh=Z+buMJFk55jAVStkEFfMseJQaDGXv892vDz6TiXi1gY=;
	h=Date:To:From:Subject:Message-Id; b=F5spxnoLtfQ0CzG3Rbz63JPe1fkLepAQBTuBX+tm3Of6fy1KHBjiExPGAmvRRkpD+T5fv2O5rZ9VaXyzJw2ihWuMB99FqZimiACvQVYAgIfa38wnUsLT6KExGqFhksE8fW/CXZZWiK+Hm34kxTI2KTTqpVT1IX7On0RBIBSEs18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TKY1T5PJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TKY1T5PJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EA6C4CEC2;
	Mon,  2 Sep 2024 03:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247816;
	bh=Z+buMJFk55jAVStkEFfMseJQaDGXv892vDz6TiXi1gY=;
	h=Date:To:From:Subject:From;
	b=TKY1T5PJOKInSkzW4zF+HbfAF4BiN2lW7wDHKsLcp3t1F8gJf2KzdsoAsxHtcVQzp
	 jdRonNesLrNorZ1pGJ6w6ZVsYQySugYP09gFMcsstkVnsHbPeR1iF2JjhRAw+E2XDJ
	 LXzN8rfkN5ZIHLeRRkMouLgt2uXs4SgEsrA0BOVw=
Date: Sun, 01 Sep 2024 20:30:15 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,tglx@linutronix.de,pedro.falcato@gmail.com,npiggin@gmail.com,Liam.Howlett@oracle.com,jeffxu@google.com,david@redhat.com,christophe.leroy@csgroup.eu,mpe@ellerman.id.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-vdso-refactor-error-handling.patch removed from -mm tree
Message-Id: <20240902033016.57EA6C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/vdso: refactor error handling
has been removed from the -mm tree.  Its filename was
     powerpc-vdso-refactor-error-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


