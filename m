Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A903C10F04
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 21:57:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377048AbjK3V5O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 16:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377008AbjK3V5M (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 16:57:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF9810DF
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 13:57:19 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF53C433C8;
        Thu, 30 Nov 2023 21:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701381438;
        bh=jO8usPUCSutCmIqQUk9K2DKa1vikvFQS4sYBjb/9Veg=;
        h=Date:To:From:Subject:From;
        b=R4edrrS/5TlBENfHG5wIOzEErd6FtB6QxJx9h+iZ+0JTbaYynTjeJ2fvJpIxScftw
         VEsCSAaTqGLqkCfiBuU4Hp1/Z5t7KDQrEi99VUxFb5djlzxS3PMXuy6GbJKPtlAFjE
         SwkXuyX6JbTvAbK1tr6hXt9JMnKE0+RXcFMtdqGQ=
Date:   Thu, 30 Nov 2023 13:57:18 -0800
To:     mm-commits@vger.kernel.org, nathan@kernel.org, joe@perches.com,
        bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_file-ricv-print-out-debugging-message-if-required.patch added to mm-nonmm-unstable branch
Message-Id: <20231130215718.BFF53C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec_file, ricv: print out debugging message if required
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec_file-ricv-print-out-debugging-message-if-required.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_file-ricv-print-out-debugging-message-if-required.patch

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
Subject: kexec_file, ricv: print out debugging message if required
Date: Thu, 30 Nov 2023 10:39:53 +0800

Replace pr_debug() with the newly added kexec_dprintk() in kexec_file
loading related codes.

And also remove kexec_image_info() because the content has been printed
out in generic code.

Link: https://lkml.kernel.org/r/20231130023955.5257-6-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/kernel/elf_kexec.c     |   11 ++++++-----
 arch/riscv/kernel/machine_kexec.c |   26 --------------------------
 2 files changed, 6 insertions(+), 31 deletions(-)

--- a/arch/riscv/kernel/elf_kexec.c~kexec_file-ricv-print-out-debugging-message-if-required
+++ a/arch/riscv/kernel/elf_kexec.c
@@ -216,7 +216,6 @@ static void *elf_kexec_load(struct kimag
 	if (ret)
 		goto out;
 	kernel_start = image->start;
-	pr_notice("The entry point of kernel at 0x%lx\n", image->start);
 
 	/* Add the kernel binary to the image */
 	ret = riscv_kexec_elf_load(image, &ehdr, &elf_info,
@@ -252,8 +251,8 @@ static void *elf_kexec_load(struct kimag
 		image->elf_load_addr = kbuf.mem;
 		image->elf_headers_sz = headers_sz;
 
-		pr_debug("Loaded elf core header at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
-			 image->elf_load_addr, kbuf.bufsz, kbuf.memsz);
+		kexec_dprintk("Loaded elf core header at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
+			      image->elf_load_addr, kbuf.bufsz, kbuf.memsz);
 
 		/* Setup cmdline for kdump kernel case */
 		modified_cmdline = setup_kdump_cmdline(image, cmdline,
@@ -275,6 +274,8 @@ static void *elf_kexec_load(struct kimag
 		pr_err("Error loading purgatory ret=%d\n", ret);
 		goto out;
 	}
+	kexec_dprintk("Loaded purgatory at 0x%lx\n", kbuf.mem);
+
 	ret = kexec_purgatory_get_set_symbol(image, "riscv_kernel_entry",
 					     &kernel_start,
 					     sizeof(kernel_start), 0);
@@ -293,7 +294,7 @@ static void *elf_kexec_load(struct kimag
 		if (ret)
 			goto out;
 		initrd_pbase = kbuf.mem;
-		pr_notice("Loaded initrd at 0x%lx\n", initrd_pbase);
+		kexec_dprintk("Loaded initrd at 0x%lx\n", initrd_pbase);
 	}
 
 	/* Add the DTB to the image */
@@ -318,7 +319,7 @@ static void *elf_kexec_load(struct kimag
 	}
 	/* Cache the fdt buffer address for memory cleanup */
 	image->arch.fdt = fdt;
-	pr_notice("Loaded device tree at 0x%lx\n", kbuf.mem);
+	kexec_dprintk("Loaded device tree at 0x%lx\n", kbuf.mem);
 	goto out;
 
 out_free_fdt:
--- a/arch/riscv/kernel/machine_kexec.c~kexec_file-ricv-print-out-debugging-message-if-required
+++ a/arch/riscv/kernel/machine_kexec.c
@@ -19,30 +19,6 @@
 #include <linux/irq.h>
 
 /*
- * kexec_image_info - Print received image details
- */
-static void
-kexec_image_info(const struct kimage *image)
-{
-	unsigned long i;
-
-	pr_debug("Kexec image info:\n");
-	pr_debug("\ttype:        %d\n", image->type);
-	pr_debug("\tstart:       %lx\n", image->start);
-	pr_debug("\thead:        %lx\n", image->head);
-	pr_debug("\tnr_segments: %lu\n", image->nr_segments);
-
-	for (i = 0; i < image->nr_segments; i++) {
-		pr_debug("\t    segment[%lu]: %016lx - %016lx", i,
-			image->segment[i].mem,
-			image->segment[i].mem + image->segment[i].memsz);
-		pr_debug("\t\t0x%lx bytes, %lu pages\n",
-			(unsigned long) image->segment[i].memsz,
-			(unsigned long) image->segment[i].memsz /  PAGE_SIZE);
-	}
-}
-
-/*
  * machine_kexec_prepare - Initialize kexec
  *
  * This function is called from do_kexec_load, when the user has
@@ -60,8 +36,6 @@ machine_kexec_prepare(struct kimage *ima
 	unsigned int control_code_buffer_sz = 0;
 	int i = 0;
 
-	kexec_image_info(image);
-
 	/* Find the Flattened Device Tree and save its physical address */
 	for (i = 0; i < image->nr_segments; i++) {
 		if (image->segment[i].memsz <= sizeof(fdt))
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

