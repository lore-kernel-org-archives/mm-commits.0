Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D1BCC10F04
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 21:57:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbjK3V5J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 16:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjK3V5J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 16:57:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C2C10DE
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 13:57:15 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8909C433C9;
        Thu, 30 Nov 2023 21:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701381435;
        bh=53h+RTdEMJO5ldoGdlS1eq+rA0zeyIS4JCgpaHtj4Lo=;
        h=Date:To:From:Subject:From;
        b=PdOcs9NkFq1reaVO3cTf8Q5mcdGA1wrUJ3IdiBdEJ/4qmxJLRpVkX1WtM3Xol2Wkd
         advo7nChEER+W1FNG/zEWmYA3KfrW/+yMToACfsv7BTRbWbbhCPwbq/uwcqNnEcUYq
         FriFeG0kEEFvXv8AQoQrXuGcR+m3UIwkxpyf7+RM=
Date:   Thu, 30 Nov 2023 13:57:14 -0800
To:     mm-commits@vger.kernel.org, nathan@kernel.org, joe@perches.com,
        bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_file-print-out-debugging-message-if-required.patch added to mm-nonmm-unstable branch
Message-Id: <20231130215714.E8909C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec_file: print out debugging message if required
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec_file-print-out-debugging-message-if-required.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_file-print-out-debugging-message-if-required.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Date: Thu, 30 Nov 2023 10:39:50 +0800

Replace pr_debug() with the newly added kexec_dprintk() in kexec_file
loading related codes.

And also print out type/start/head of kimage and flags to help debug.

Link: https://lkml.kernel.org/r/20231130023955.5257-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c                |    9 ++++++---
 kernel/kexec_file.c                |   11 ++++++++---
 security/integrity/ima/ima_kexec.c |    4 ++--
 3 files changed, 16 insertions(+), 8 deletions(-)

--- a/kernel/crash_core.c~kexec_file-print-out-debugging-message-if-required
+++ a/kernel/crash_core.c
@@ -551,9 +551,12 @@ int crash_prepare_elf64_headers(struct c
 		phdr->p_filesz = phdr->p_memsz = mend - mstart + 1;
 		phdr->p_align = 0;
 		ehdr->e_phnum++;
-		pr_debug("Crash PT_LOAD ELF header. phdr=%p vaddr=0x%llx, paddr=0x%llx, sz=0x%llx e_phnum=%d p_offset=0x%llx\n",
-			phdr, phdr->p_vaddr, phdr->p_paddr, phdr->p_filesz,
-			ehdr->e_phnum, phdr->p_offset);
+#ifdef CONFIG_KEXEC_FILE
+		kexec_dprintk("Crash PT_LOAD ELF header. phdr=%p vaddr=0x%llx, paddr=0x%llx, "
+			      "sz=0x%llx e_phnum=%d p_offset=0x%llx\n",
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

drivers-base-cpu-crash-data-showing-should-depends-on-kexec_core.patch
kernel-kconfigkexec-drop-select-of-kexec-for-crash_dump.patch
loongarch-change-dependency-of-object-files.patch
resource-add-walk_system_ram_res_rev.patch
kexec_file-load-kernel-at-top-of-system-ram-if-required.patch
kexec_file-add-kexec_file-flag-to-control-debug-printing.patch
kexec_file-print-out-debugging-message-if-required.patch
kexec_file-x86-print-out-debugging-message-if-required.patch
kexec_file-arm64-print-out-debugging-message-if-required.patch
kexec_file-ricv-print-out-debugging-message-if-required.patch
kexec_file-power-print-out-debugging-message-if-required.patch
kexec_file-parisc-print-out-debugging-message-if-required.patch

