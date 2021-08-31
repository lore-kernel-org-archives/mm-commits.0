Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E7C8C4320E
	for <mm-commits@archiver.kernel.org>; Tue, 31 Aug 2021 22:52:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 521966108B
	for <mm-commits@archiver.kernel.org>; Tue, 31 Aug 2021 22:52:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbhHaWxP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Aug 2021 18:53:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230400AbhHaWxN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 31 Aug 2021 18:53:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFAFF6109D;
        Tue, 31 Aug 2021 22:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630450338;
        bh=tYsNb+TN66yr15lFBoFY+/xRdithb2/7P78efSv0/+E=;
        h=Date:From:To:Subject:From;
        b=sHSfEaaMB4l9FbDUyIAeX0p8uC7xV7HWw+dofHV5+4XHaNjaUabKfQJa0t/Z8T9f2
         ZWyMU5d5OwSVF2PXDbYQ5ZQ0dH6NWBKcPMbGYRj1rCJx3Fhs1kQF8ZfP+CUtxEPJxL
         qyaVOcIReM23aAqc0IH/E94ZZBD4GZF0OUJR7KKA=
Date:   Tue, 31 Aug 2021 15:52:17 -0700
From:   akpm@linux-foundation.org
To:     frowand.list@gmail.com, geert+renesas@glider.be,
        horms@verge.net.au, jlan@sgi.com, magnus.damm@gmail.com,
        mm-commits@vger.kernel.org, robh+dt@kernel.org,
        rppt@linux.vnet.ibm.com, tony.luck@intel.com
Subject:  + ia64-make-reserve_elfcorehdr-static.patch added to -mm
 tree
Message-ID: <20210831225217.35v8TryGI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: make reserve_elfcorehdr() static
has been added to the -mm tree.  Its filename is
     ia64-make-reserve_elfcorehdr-static.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-make-reserve_elfcorehdr-static.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-make-reserve_elfcorehdr-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: ia64: make reserve_elfcorehdr() static

There never was a reason for reserve_elfcorehdr() to be global.  Make the
function static, and move it before its sole caller.

Link: https://lkml.kernel.org/r/fe236cd73b64abc4abd03dd808cb015c907f4c8c.1629884459.git.geert+renesas@glider.be
Fixes: cee87af2a5f75713 ("[IA64] kexec: Use EFI_LOADER_DATA for ELF core header")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: Jay Lan <jlan@sgi.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Simon Horman <horms@verge.net.au>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/meminit.h |    1 
 arch/ia64/kernel/setup.c        |   51 ++++++++++++++----------------
 2 files changed, 25 insertions(+), 27 deletions(-)

--- a/arch/ia64/include/asm/meminit.h~ia64-make-reserve_elfcorehdr-static
+++ a/arch/ia64/include/asm/meminit.h
@@ -40,7 +40,6 @@ extern unsigned long efi_memmap_init(u64
 extern int find_max_min_low_pfn (u64, u64, void *);
 
 extern unsigned long vmcore_find_descriptor_size(unsigned long address);
-extern int reserve_elfcorehdr(u64 *start, u64 *end);
 
 /*
  * For rounding an address to the next IA64_GRANULE_SIZE or order
--- a/arch/ia64/kernel/setup.c~ia64-make-reserve_elfcorehdr-static
+++ a/arch/ia64/kernel/setup.c
@@ -325,6 +325,31 @@ static inline void __init setup_crashker
 {}
 #endif
 
+#ifdef CONFIG_CRASH_DUMP
+static int __init reserve_elfcorehdr(u64 *start, u64 *end)
+{
+	u64 length;
+
+	/* We get the address using the kernel command line,
+	 * but the size is extracted from the EFI tables.
+	 * Both address and size are required for reservation
+	 * to work properly.
+	 */
+
+	if (!is_vmcore_usable())
+		return -EINVAL;
+
+	if ((length = vmcore_find_descriptor_size(elfcorehdr_addr)) == 0) {
+		vmcore_unusable();
+		return -EINVAL;
+	}
+
+	*start = (unsigned long)__va(elfcorehdr_addr);
+	*end = *start + length;
+	return 0;
+}
+#endif /* CONFIG_CRASH_DUMP */
+
 /**
  * reserve_memory - setup reserved memory areas
  *
@@ -522,32 +547,6 @@ static __init int setup_nomca(char *s)
 }
 early_param("nomca", setup_nomca);
 
-#ifdef CONFIG_CRASH_DUMP
-int __init reserve_elfcorehdr(u64 *start, u64 *end)
-{
-	u64 length;
-
-	/* We get the address using the kernel command line,
-	 * but the size is extracted from the EFI tables.
-	 * Both address and size are required for reservation
-	 * to work properly.
-	 */
-
-	if (!is_vmcore_usable())
-		return -EINVAL;
-
-	if ((length = vmcore_find_descriptor_size(elfcorehdr_addr)) == 0) {
-		vmcore_unusable();
-		return -EINVAL;
-	}
-
-	*start = (unsigned long)__va(elfcorehdr_addr);
-	*end = *start + length;
-	return 0;
-}
-
-#endif /* CONFIG_CRASH_DUMP */
-
 void __init
 setup_arch (char **cmdline_p)
 {
_

Patches currently in -mm which might be from geert+renesas@glider.be are

ia64-fix-endif-comment-for-reserve_elfcorehdr.patch
ia64-make-reserve_elfcorehdr-static.patch
ia64-make-num_rsvd_regions-static.patch

