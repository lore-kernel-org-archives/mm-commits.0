Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08B06C77B73
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:54:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234523AbjDFCy2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235166AbjDFCxe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:53:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2436658B
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:53:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 955286421B
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB992C433D2;
        Thu,  6 Apr 2023 02:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749600;
        bh=tyoXO7Jr3BTgKaKjHyS9C6G9BqkO4ZCGxHs/OMtBIfw=;
        h=Date:To:From:Subject:From;
        b=X6Mh9N48UxPJ31fBPPQ1LlbvrPN413o5V7H18xDw7gjF2s02MsWKtuQuyHg/08O9J
         FEm3grR0ZR6lWREZwMO/U7eUlca7gHb9KC6GkwmUs1csOyg5T/+DhB568bZBfIldVo
         QcfFPDN+epTmO9ZkwwiClkJ7GUSku29H1gOStKGw=
Date:   Wed, 05 Apr 2023 19:53:19 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, horms@kernel.org, ebiederm@xmission.com,
        dave.hansen@linux.intel.com, bp@alien8.de, bhe@redhat.com,
        bhelgaas@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec-remove-unnecessary-arch_kexec_kernel_image_load.patch removed from -mm tree
Message-Id: <20230406025319.EB992C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kexec: remove unnecessary arch_kexec_kernel_image_load()
has been removed from the -mm tree.  Its filename was
     kexec-remove-unnecessary-arch_kexec_kernel_image_load.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


