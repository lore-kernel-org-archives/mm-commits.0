Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9BAC4167B
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 21:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377050AbjK3V5N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 16:57:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377029AbjK3V5K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 16:57:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF7910DC
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 13:57:16 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5B4C433C7;
        Thu, 30 Nov 2023 21:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701381436;
        bh=OTpOMqJb5hnolP/dHhWhjzXpjIX3pkGgpzatiEiQrno=;
        h=Date:To:From:Subject:From;
        b=pwB860KN5mpEBo18kpb3DNqjagb7i85L8nL0UAvkwuEi3uqzrb3ghhTEk/AU7hTwf
         Zp8hWTxvMI+KtYGNx8O6XMy6VRwk9grS0psLHI8dSkkS1xbWTIMZQHB/YTJmxH6StY
         FilfJEbJESVfyvRq9IL5/1gMr25koJDUhgrHHtL4=
Date:   Thu, 30 Nov 2023 13:57:15 -0800
To:     mm-commits@vger.kernel.org, nathan@kernel.org, joe@perches.com,
        bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_file-x86-print-out-debugging-message-if-required.patch added to mm-nonmm-unstable branch
Message-Id: <20231130215716.3B5B4C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec_file, x86: print out debugging message if required
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec_file-x86-print-out-debugging-message-if-required.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_file-x86-print-out-debugging-message-if-required.patch

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
Subject: kexec_file, x86: print out debugging message if required
Date: Thu, 30 Nov 2023 10:39:51 +0800

Replace pr_debug() with the newly added kexec_dprintk() in kexec_file
loading related codes.

And also print out e820 memmap passed to 2nd kernel just as kexec_load
interface has been doing.

Link: https://lkml.kernel.org/r/20231130023955.5257-4-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/crash.c           |    4 ++--
 arch/x86/kernel/kexec-bzimage64.c |   23 ++++++++++++++---------
 2 files changed, 16 insertions(+), 11 deletions(-)

--- a/arch/x86/kernel/crash.c~kexec_file-x86-print-out-debugging-message-if-required
+++ a/arch/x86/kernel/crash.c
@@ -386,8 +386,8 @@ int crash_load_segments(struct kimage *i
 	if (ret)
 		return ret;
 	image->elf_load_addr = kbuf.mem;
-	pr_debug("Loaded ELF headers at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
-		 image->elf_load_addr, kbuf.bufsz, kbuf.memsz);
+	kexec_dprintk("Loaded ELF headers at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
+		      image->elf_load_addr, kbuf.bufsz, kbuf.memsz);
 
 	return ret;
 }
--- a/arch/x86/kernel/kexec-bzimage64.c~kexec_file-x86-print-out-debugging-message-if-required
+++ a/arch/x86/kernel/kexec-bzimage64.c
@@ -82,7 +82,7 @@ static int setup_cmdline(struct kimage *
 
 	cmdline_ptr[cmdline_len - 1] = '\0';
 
-	pr_debug("Final command line is: %s\n", cmdline_ptr);
+	kexec_dprintk("Final command line is: %s\n", cmdline_ptr);
 	cmdline_ptr_phys = bootparams_load_addr + cmdline_offset;
 	cmdline_low_32 = cmdline_ptr_phys & 0xffffffffUL;
 	cmdline_ext_32 = cmdline_ptr_phys >> 32;
@@ -272,7 +272,12 @@ setup_boot_parameters(struct kimage *ima
 
 	nr_e820_entries = params->e820_entries;
 
+	kexec_dprintk("E820 memmap:\n");
 	for (i = 0; i < nr_e820_entries; i++) {
+		kexec_dprintk("%016llx-%016llx (%d)\n",
+			      params->e820_table[i].addr,
+			      params->e820_table[i].addr + params->e820_table[i].size - 1,
+			      params->e820_table[i].type);
 		if (params->e820_table[i].type != E820_TYPE_RAM)
 			continue;
 		start = params->e820_table[i].addr;
@@ -424,7 +429,7 @@ static void *bzImage64_load(struct kimag
 	 * command line. Make sure it does not overflow
 	 */
 	if (cmdline_len + MAX_ELFCOREHDR_STR_LEN > header->cmdline_size) {
-		pr_debug("Appending elfcorehdr=<addr> to command line exceeds maximum allowed length\n");
+		kexec_dprintk("Appending elfcorehdr=<addr> to command line exceeds maximum allowed length\n");
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -445,7 +450,7 @@ static void *bzImage64_load(struct kimag
 		return ERR_PTR(ret);
 	}
 
-	pr_debug("Loaded purgatory at 0x%lx\n", pbuf.mem);
+	kexec_dprintk("Loaded purgatory at 0x%lx\n", pbuf.mem);
 
 
 	/*
@@ -490,8 +495,8 @@ static void *bzImage64_load(struct kimag
 	if (ret)
 		goto out_free_params;
 	bootparam_load_addr = kbuf.mem;
-	pr_debug("Loaded boot_param, command line and misc at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
-		 bootparam_load_addr, kbuf.bufsz, kbuf.bufsz);
+	kexec_dprintk("Loaded boot_param, command line and misc at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
+		      bootparam_load_addr, kbuf.bufsz, kbuf.bufsz);
 
 	/* Load kernel */
 	kbuf.buffer = kernel + kern16_size;
@@ -505,8 +510,8 @@ static void *bzImage64_load(struct kimag
 		goto out_free_params;
 	kernel_load_addr = kbuf.mem;
 
-	pr_debug("Loaded 64bit kernel at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
-		 kernel_load_addr, kbuf.bufsz, kbuf.memsz);
+	kexec_dprintk("Loaded 64bit kernel at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
+		      kernel_load_addr, kbuf.bufsz, kbuf.memsz);
 
 	/* Load initrd high */
 	if (initrd) {
@@ -520,8 +525,8 @@ static void *bzImage64_load(struct kimag
 			goto out_free_params;
 		initrd_load_addr = kbuf.mem;
 
-		pr_debug("Loaded initrd at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
-				initrd_load_addr, initrd_len, initrd_len);
+		kexec_dprintk("Loaded initrd at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
+			      initrd_load_addr, initrd_len, initrd_len);
 
 		setup_initrd(params, initrd_load_addr, initrd_len);
 	}
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

