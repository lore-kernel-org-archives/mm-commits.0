Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B15C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 31 May 2022 21:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346652AbiEaV2j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 May 2022 17:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346692AbiEaV2j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2022 17:28:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A13703C1
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 14:28:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A672C6134F
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 21:28:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B51C385A9;
        Tue, 31 May 2022 21:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654032517;
        bh=WuO6RRejTbce1cAvuZJicDOiUGF6tws+fH8liSYkrB8=;
        h=Date:To:From:Subject:From;
        b=rWE9QvHEi3UYWGUq+z8tZqU5hDkJDl0nquk5fYCSv1F/3UQvZcEpew7Uv7Nd7k1+/
         tjMAuzlGU4D+7aWDKf/Hk5PIKd20J1LVp+YZaj7aiW1Esmd593IYsyLb7HgnATPv3v
         QrpLUD/A/Lv1/YUydBen52MZSayl8LtXY5vYTDN4=
Date:   Tue, 31 May 2022 14:28:36 -0700
To:     mm-commits@vger.kernel.org, dyoung@redhat.com, bhe@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_file-clean-up-arch_kexec_kernel_image_load.patch added to mm-nonmm-unstable branch
Message-Id: <20220531212837.04B51C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec_file: clean up arch_kexec_kernel_image_load
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec_file-clean-up-arch_kexec_kernel_image_load.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_file-clean-up-arch_kexec_kernel_image_load.patch

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
Subject: kexec_file: clean up arch_kexec_kernel_image_load
Date: Wed, 23 Feb 2022 19:32:25 +0800

arch_kexec_kernel_image_load() has a common weak version which is a
wrapper of kexec_image_load_default() , and has only one arch dependent
version in x86_64.  Now the x86_64 dependent function is not needed any
more.  So clean it up.

And also rename kexec_image_load_default() to kexec_kernel_image_load()
for better reflecting its functionality.

Link: https://lkml.kernel.org/r/20220223113225.63106-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/machine_kexec_64.c |   11 -----------
 include/linux/kexec.h              |    1 -
 kernel/kexec_file.c                |    9 ++-------
 3 files changed, 2 insertions(+), 19 deletions(-)

--- a/arch/x86/kernel/machine_kexec_64.c~kexec_file-clean-up-arch_kexec_kernel_image_load
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
--- a/include/linux/kexec.h~kexec_file-clean-up-arch_kexec_kernel_image_load
+++ a/include/linux/kexec.h
@@ -192,7 +192,6 @@ void *kexec_purgatory_get_symbol_addr(st
 /* Architectures may override the below functions */
 int arch_kexec_kernel_image_probe(struct kimage *image, void *buf,
 				  unsigned long buf_len);
-void *arch_kexec_kernel_image_load(struct kimage *image);
 int arch_kimage_file_post_load_cleanup(struct kimage *image);
 #ifdef CONFIG_KEXEC_SIG
 int arch_kexec_kernel_verify_sig(struct kimage *image, void *buf,
--- a/kernel/kexec_file.c~kexec_file-clean-up-arch_kexec_kernel_image_load
+++ a/kernel/kexec_file.c
@@ -60,7 +60,7 @@ int __weak arch_kexec_kernel_image_probe
 	return kexec_image_probe_default(image, buf, buf_len);
 }
 
-static void *kexec_image_load_default(struct kimage *image)
+static void *kexec_kernel_image_load(struct kimage *image)
 {
 	if (!image->fops || !image->fops->load)
 		return ERR_PTR(-ENOEXEC);
@@ -71,11 +71,6 @@ static void *kexec_image_load_default(st
 				 image->cmdline_buf_len);
 }
 
-void * __weak arch_kexec_kernel_image_load(struct kimage *image)
-{
-	return kexec_image_load_default(image);
-}
-
 int kexec_image_post_load_cleanup_default(struct kimage *image)
 {
 	if (!image->fops || !image->fops->cleanup)
@@ -245,7 +240,7 @@ kimage_file_prepare_segments(struct kima
 	ima_add_kexec_buffer(image);
 
 	/* Call arch image load handlers */
-	ldata = arch_kexec_kernel_image_load(image);
+	ldata = kexec_kernel_image_load(image);
 
 	if (IS_ERR(ldata)) {
 		ret = PTR_ERR(ldata);
_

Patches currently in -mm which might be from bhe@redhat.com are

x86-kexec-fix-memory-leak-of-elf-header-buffer.patch
kexec_file-clean-up-arch_kexec_kernel_image_load.patch

