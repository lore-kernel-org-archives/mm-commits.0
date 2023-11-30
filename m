Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F236C4167B
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 21:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377067AbjK3V5W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 16:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377053AbjK3V5P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 16:57:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E84A8
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 13:57:21 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23302C433C7;
        Thu, 30 Nov 2023 21:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701381441;
        bh=AP6iCHKEf7KE2Oua2AzmIpbvqyamUCkDTQAzg61ArHc=;
        h=Date:To:From:Subject:From;
        b=R64ZMI0zCCXYFKB3iufqEME7b2HvdyUSZBYJ0tNS/RYjifj52OFMiDrDODbGEO28/
         mzjdurpk5Fd3GASbm+r+7geVge7fRcEtkRODSa4mp7qaoAID4d39gm7Td5SVDPYmZM
         XD/rr9xH28e0KKU9+PlrtmzuwF7LykSN1V8iFlbo=
Date:   Thu, 30 Nov 2023 13:57:20 -0800
To:     mm-commits@vger.kernel.org, nathan@kernel.org, joe@perches.com,
        bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_file-parisc-print-out-debugging-message-if-required.patch added to mm-nonmm-unstable branch
Message-Id: <20231130215721.23302C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec_file, parisc: print out debugging message if required
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec_file-parisc-print-out-debugging-message-if-required.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_file-parisc-print-out-debugging-message-if-required.patch

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
Subject: kexec_file, parisc: print out debugging message if required
Date: Thu, 30 Nov 2023 10:39:55 +0800

Replace pr_debug() with the newly added kexec_dprintk() in kexec_file
loading related codes.

Link: https://lkml.kernel.org/r/20231130023955.5257-8-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/kexec_file.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/parisc/kernel/kexec_file.c~kexec_file-parisc-print-out-debugging-message-if-required
+++ a/arch/parisc/kernel/kexec_file.c
@@ -38,8 +38,8 @@ static void *elf_load(struct kimage *ima
 	for (i = 0; i < image->nr_segments; i++)
 		image->segment[i].mem = __pa(image->segment[i].mem);
 
-	pr_debug("Loaded the kernel at 0x%lx, entry at 0x%lx\n",
-		 kernel_load_addr, image->start);
+	kexec_dprintk("Loaded the kernel at 0x%lx, entry at 0x%lx\n",
+		      kernel_load_addr, image->start);
 
 	if (initrd != NULL) {
 		kbuf.buffer = initrd;
@@ -51,7 +51,7 @@ static void *elf_load(struct kimage *ima
 		if (ret)
 			goto out;
 
-		pr_debug("Loaded initrd at 0x%lx\n", kbuf.mem);
+		kexec_dprintk("Loaded initrd at 0x%lx\n", kbuf.mem);
 		image->arch.initrd_start = kbuf.mem;
 		image->arch.initrd_end = kbuf.mem + initrd_len;
 	}
@@ -68,7 +68,7 @@ static void *elf_load(struct kimage *ima
 		if (ret)
 			goto out;
 
-		pr_debug("Loaded cmdline at 0x%lx\n", kbuf.mem);
+		kexec_dprintk("Loaded cmdline at 0x%lx\n", kbuf.mem);
 		image->arch.cmdline = kbuf.mem;
 	}
 out:
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

