Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65498C74A5B
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 22:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjCWWHo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Mar 2023 18:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjCWWHn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Mar 2023 18:07:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F333220076
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 15:07:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CF2FECE23C4
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 22:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06343C433EF;
        Thu, 23 Mar 2023 22:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679609258;
        bh=n+swTAMaJLVU/utj1i+idCdRiyMzWVtD7cyYLyNuBDU=;
        h=Date:To:From:Subject:From;
        b=dymXDnSEWRBUGdxTH+6GPxA5IpBpFdxrYqhlBiPRi4kMkx3Jv2j/W3Z2YXWuIyHZO
         bZIZzBiIg0NMxfRadKl8k2oPEAS3DTfQXaPL4R0NVRn8wJ6COQCUesR9E99nvf81zE
         Vf3iFn3e3Cc5B5iRjnPFj+NGk0gh4PmA9A6httrw=
Date:   Thu, 23 Mar 2023 15:07:37 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, horms@kernel.org, ebiederm@xmission.com,
        dave.hansen@linux.intel.com, bp@alien8.de, bhe@redhat.com,
        bhelgaas@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-remove-unnecessary-arch_kexec_kernel_image_load.patch added to mm-nonmm-unstable branch
Message-Id: <20230323220738.06343C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: remove unnecessary arch_kexec_kernel_image_load()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-remove-unnecessary-arch_kexec_kernel_image_load.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-remove-unnecessary-arch_kexec_kernel_image_load.patch

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
From: Bjorn Helgaas <bhelgaas@google.com>
Subject: kexec: remove unnecessary arch_kexec_kernel_image_load()
Date: Tue, 7 Mar 2023 16:44:16 -0600

arch_kexec_kernel_image_load() only calls kexec_image_load_default(), and
there are no arch-specific implementations.

Remove the unnecessary arch_kexec_kernel_image_load() and make
kexec_image_load_default() static.

No functional change intended.

Link: https://lkml.kernel.org/r/20230307224416.907040-3-helgaas@kernel.org
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

 include/linux/kexec.h |    6 ------
 kernel/kexec_file.c   |    6 +++---
 2 files changed, 3 insertions(+), 9 deletions(-)

--- a/include/linux/kexec.h~kexec-remove-unnecessary-arch_kexec_kernel_image_load
+++ a/include/linux/kexec.h
@@ -190,7 +190,6 @@ int kexec_purgatory_get_set_symbol(struc
 				   void *buf, unsigned int size,
 				   bool get_value);
 void *kexec_purgatory_get_symbol_addr(struct kimage *image, const char *name);
-void *kexec_image_load_default(struct kimage *image);
 
 #ifndef arch_kexec_kernel_image_probe
 static inline int
@@ -207,11 +206,6 @@ static inline int arch_kimage_file_post_
 }
 #endif
 
-static inline void *arch_kexec_kernel_image_load(struct kimage *image)
-{
-	return kexec_image_load_default(image);
-}
-
 #ifdef CONFIG_KEXEC_SIG
 #ifdef CONFIG_SIGNED_PE_FILE_VERIFICATION
 int kexec_kernel_verify_pe_sig(const char *kernel, unsigned long kernel_len);
--- a/kernel/kexec_file.c~kexec-remove-unnecessary-arch_kexec_kernel_image_load
+++ a/kernel/kexec_file.c
@@ -65,7 +65,7 @@ int kexec_image_probe_default(struct kim
 	return ret;
 }
 
-void *kexec_image_load_default(struct kimage *image)
+static void *kexec_image_load_default(struct kimage *image)
 {
 	if (!image->fops || !image->fops->load)
 		return ERR_PTR(-ENOEXEC);
@@ -249,8 +249,8 @@ kimage_file_prepare_segments(struct kima
 	/* IMA needs to pass the measurement list to the next kernel. */
 	ima_add_kexec_buffer(image);
 
-	/* Call arch image load handlers */
-	ldata = arch_kexec_kernel_image_load(image);
+	/* Call image load handler */
+	ldata = kexec_image_load_default(image);
 
 	if (IS_ERR(ldata)) {
 		ret = PTR_ERR(ldata);
_

Patches currently in -mm which might be from bhelgaas@google.com are

x86-kexec-remove-unnecessary-arch_kexec_kernel_image_load.patch
kexec-remove-unnecessary-arch_kexec_kernel_image_load.patch

