Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8131D78E79
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 20:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d7DIJFYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0916C433C8;
	Wed, 13 Dec 2023 20:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702498478;
	bh=m9KqEQqX66qsAItkacR+5vPt2Tc5MnYGlkYnVT1gMcs=;
	h=Date:To:From:Subject:From;
	b=d7DIJFYU47/AOVn7s4DV24i+RbB9kj329Pjs1jKhzkHlTH66JLFO09wyGGSgzgX59
	 mE17Xglb12cV4+UT7ELi23BRqxs+pw+q0EOf17HOeL1qUK8Sf+sByE0iy0y8VC1rCd
	 LMae1bDz4Ilc5f/QvPtRVT28JDL9v7AJLRaFZz6A=
Date: Wed, 13 Dec 2023 12:14:37 -0800
To: mm-commits@vger.kernel.org,nathan@kernel.org,joe@perches.com,conor@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_file-print-out-debugging-message-if-required.patch added to mm-unstable branch
Message-Id: <20231213201437.E0916C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec_file: print out debugging message if required
has been added to the -mm mm-unstable branch.  Its filename is
     kexec_file-print-out-debugging-message-if-required.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_file-print-out-debugging-message-if-required.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: kexec_file: print out debugging message if required
Date: Wed, 13 Dec 2023 13:57:42 +0800

Then when specifying '-d' for kexec_file_load interface, loaded locations
of kernel/initrd/cmdline etc can be printed out to help debug.

Here replace pr_debug() with the newly added kexec_dprintk() in kexec_file
loading related codes.

And also print out type/start/head of kimage and flags to help debug.

Link: https://lkml.kernel.org/r/20231213055747.61826-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Conor Dooley <conor@kernel.org>
Cc: Joe Perches <joe@perches.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c                |    8 +++++---
 kernel/kexec_file.c                |   11 ++++++++---
 security/integrity/ima/ima_kexec.c |    4 ++--
 3 files changed, 15 insertions(+), 8 deletions(-)

--- a/kernel/crash_core.c~kexec_file-print-out-debugging-message-if-required
+++ a/kernel/crash_core.c
@@ -551,9 +551,11 @@ int crash_prepare_elf64_headers(struct c
 		phdr->p_filesz = phdr->p_memsz = mend - mstart + 1;
 		phdr->p_align = 0;
 		ehdr->e_phnum++;
-		pr_debug("Crash PT_LOAD ELF header. phdr=%p vaddr=0x%llx, paddr=0x%llx, sz=0x%llx e_phnum=%d p_offset=0x%llx\n",
-			phdr, phdr->p_vaddr, phdr->p_paddr, phdr->p_filesz,
-			ehdr->e_phnum, phdr->p_offset);
+#ifdef CONFIG_KEXEC_FILE
+		kexec_dprintk("Crash PT_LOAD ELF header. phdr=%p vaddr=0x%llx, paddr=0x%llx, sz=0x%llx e_phnum=%d p_offset=0x%llx\n",
+			      phdr, phdr->p_vaddr, phdr->p_paddr, phdr->p_filesz,
+			      ehdr->e_phnum, phdr->p_offset);
+#endif
 		phdr++;
 	}
 
--- a/kernel/kexec_file.c~kexec_file-print-out-debugging-message-if-required
+++ a/kernel/kexec_file.c
@@ -204,6 +204,8 @@ kimage_file_prepare_segments(struct kima
 	if (ret < 0)
 		return ret;
 	image->kernel_buf_len = ret;
+	kexec_dprintk("kernel: %p kernel_size: %#lx\n",
+		      image->kernel_buf, image->kernel_buf_len);
 
 	/* Call arch image probe handlers */
 	ret = arch_kexec_kernel_image_probe(image, image->kernel_buf,
@@ -387,13 +389,14 @@ SYSCALL_DEFINE5(kexec_file_load, int, ke
 	if (ret)
 		goto out;
 
+	kexec_dprintk("nr_segments = %lu\n", image->nr_segments);
 	for (i = 0; i < image->nr_segments; i++) {
 		struct kexec_segment *ksegment;
 
 		ksegment = &image->segment[i];
-		pr_debug("Loading segment %d: buf=0x%p bufsz=0x%zx mem=0x%lx memsz=0x%zx\n",
-			 i, ksegment->buf, ksegment->bufsz, ksegment->mem,
-			 ksegment->memsz);
+		kexec_dprintk("segment[%d]: buf=0x%p bufsz=0x%zx mem=0x%lx memsz=0x%zx\n",
+			      i, ksegment->buf, ksegment->bufsz, ksegment->mem,
+			      ksegment->memsz);
 
 		ret = kimage_load_segment(image, &image->segment[i]);
 		if (ret)
@@ -406,6 +409,8 @@ SYSCALL_DEFINE5(kexec_file_load, int, ke
 	if (ret)
 		goto out;
 
+	kexec_dprintk("kexec_file_load: type:%u, start:0x%lx head:0x%lx flags:0x%lx\n",
+		      image->type, image->start, image->head, flags);
 	/*
 	 * Free up any temporary buffers allocated which are not needed
 	 * after image has been loaded
--- a/security/integrity/ima/ima_kexec.c~kexec_file-print-out-debugging-message-if-required
+++ a/security/integrity/ima/ima_kexec.c
@@ -129,8 +129,8 @@ void ima_add_kexec_buffer(struct kimage
 	image->ima_buffer_size = kexec_segment_size;
 	image->ima_buffer = kexec_buffer;
 
-	pr_debug("kexec measurement buffer for the loaded kernel at 0x%lx.\n",
-		 kbuf.mem);
+	kexec_dprintk("kexec measurement buffer for the loaded kernel at 0x%lx.\n",
+		      kbuf.mem);
 }
 #endif /* IMA_KEXEC */
 
_

Patches currently in -mm which might be from bhe@redhat.com are

kexec_file-add-kexec_file-flag-to-control-debug-printing.patch
kexec_file-print-out-debugging-message-if-required.patch
kexec_file-x86-print-out-debugging-message-if-required.patch
kexec_file-arm64-print-out-debugging-message-if-required.patch
kexec_file-ricv-print-out-debugging-message-if-required.patch
kexec_file-power-print-out-debugging-message-if-required.patch
kexec_file-parisc-print-out-debugging-message-if-required.patch
riscv-kexec-fix-the-ifdeffery-for-aflags_kexec_relocateo.patch

