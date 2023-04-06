Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3151FC77B70
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:54:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235108AbjDFCye (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235180AbjDFCxe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:53:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE74593D7
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:53:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92CA163B7D
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B92C433D2;
        Thu,  6 Apr 2023 02:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749599;
        bh=xvjky2hwSy/0ASWFgmah73cgzv9ipjb+MWIkqJNwF+s=;
        h=Date:To:From:Subject:From;
        b=XDlLA04sLGC3svqkoPopq3GyqhX93NaLcyh07oW8Ku1V629yi/r+3uRyNIfztsJ0f
         4ZxiD5QKZxeBSb8y1vQBqvmCvKoGHrz8dg+MMYLLulWD8uX8/RWUK5PMw1Rv2StPHy
         WQMaXvlIqOtOL4mZtlX7gXquLnvgJly3GoYvpf1c=
Date:   Wed, 05 Apr 2023 19:53:18 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, horms@kernel.org, ebiederm@xmission.com,
        dave.hansen@linux.intel.com, bp@alien8.de, bhe@redhat.com,
        bhelgaas@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] x86-kexec-remove-unnecessary-arch_kexec_kernel_image_load.patch removed from -mm tree
Message-Id: <20230406025318.E8B92C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: x86/kexec: remove unnecessary arch_kexec_kernel_image_load()
has been removed from the -mm tree.  Its filename was
     x86-kexec-remove-unnecessary-arch_kexec_kernel_image_load.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bjorn Helgaas <bhelgaas@google.com>
Subject: x86/kexec: remove unnecessary arch_kexec_kernel_image_load()
Date: Tue, 7 Mar 2023 16:44:15 -0600

Patch series "kexec: Remove unnecessary arch hook", v2.

There are no arch-specific things in arch_kexec_kernel_image_load(), so
remove it and just use the generic version.


This patch (of 2):

The x86 implementation of arch_kexec_kernel_image_load() is functionally
identical to the generic arch_kexec_kernel_image_load():

  arch_kexec_kernel_image_load                # x86
    if (!image->fops || !image->fops->load)
      return ERR_PTR(-ENOEXEC);
    return image->fops->load(image, image->kernel_buf, ...)

  arch_kexec_kernel_image_load                # generic
    kexec_image_load_default
      if (!image->fops || !image->fops->load)
	return ERR_PTR(-ENOEXEC);
      return image->fops->load(image, image->kernel_buf, ...)

Remove the x86-specific version and use the generic
arch_kexec_kernel_image_load().  No functional change intended.

Link: https://lkml.kernel.org/r/20230307224416.907040-1-helgaas@kernel.org
Link: https://lkml.kernel.org/r/20230307224416.907040-2-helgaas@kernel.org
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/kexec.h       |    3 ---
 arch/x86/kernel/machine_kexec_64.c |   11 -----------
 include/linux/kexec.h              |    2 --
 3 files changed, 16 deletions(-)

--- a/arch/x86/include/asm/kexec.h~x86-kexec-remove-unnecessary-arch_kexec_kernel_image_load
+++ a/arch/x86/include/asm/kexec.h
@@ -200,9 +200,6 @@ int arch_kexec_apply_relocations_add(str
 				     const Elf_Shdr *symtab);
 #define arch_kexec_apply_relocations_add arch_kexec_apply_relocations_add
 
-void *arch_kexec_kernel_image_load(struct kimage *image);
-#define arch_kexec_kernel_image_load arch_kexec_kernel_image_load
-
 int arch_kimage_file_post_load_cleanup(struct kimage *image);
 #define arch_kimage_file_post_load_cleanup arch_kimage_file_post_load_cleanup
 #endif
--- a/arch/x86/kernel/machine_kexec_64.c~x86-kexec-remove-unnecessary-arch_kexec_kernel_image_load
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -374,17 +374,6 @@ void machine_kexec(struct kimage *image)
 /* arch-dependent functionality related to kexec file-based syscall */
 
 #ifdef CONFIG_KEXEC_FILE
-void *arch_kexec_kernel_image_load(struct kimage *image)
-{
-	if (!image->fops || !image->fops->load)
-		return ERR_PTR(-ENOEXEC);
-
-	return image->fops->load(image, image->kernel_buf,
-				 image->kernel_buf_len, image->initrd_buf,
-				 image->initrd_buf_len, image->cmdline_buf,
-				 image->cmdline_buf_len);
-}
-
 /*
  * Apply purgatory relocations.
  *
--- a/include/linux/kexec.h~x86-kexec-remove-unnecessary-arch_kexec_kernel_image_load
+++ a/include/linux/kexec.h
@@ -207,12 +207,10 @@ static inline int arch_kimage_file_post_
 }
 #endif
 
-#ifndef arch_kexec_kernel_image_load
 static inline void *arch_kexec_kernel_image_load(struct kimage *image)
 {
 	return kexec_image_load_default(image);
 }
-#endif
 
 #ifdef CONFIG_KEXEC_SIG
 #ifdef CONFIG_SIGNED_PE_FILE_VERIFICATION
_

Patches currently in -mm which might be from bhelgaas@google.com are


