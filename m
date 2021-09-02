Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B10C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:50:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C15B610CF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:50:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347538AbhIBVvE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:51:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232060AbhIBVvE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:51:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45E4560F12;
        Thu,  2 Sep 2021 21:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619405;
        bh=xf84UPadpzjXj13H7EDbimJWmfWf/BtWxQ7uTXeuzZw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=155BVV51D+n14CEo31H2yGf0LB7itAmpmOEW5iydd+X4ii7TXT/iZGkROuSxrLOHS
         VQYD1bZdqB2+9q8N0/wJTxsi0b0yfIcYyqu9Oxe7lC4Y8aHuzVXu6ONBU10GYuKxp5
         6WcIJrcG0nZfL9XfDJHWo6uqfkEHt6RYWo3kJHhc=
Date:   Thu, 02 Sep 2021 14:50:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, frowand.list@gmail.com,
        geert+renesas@glider.be, horms@verge.net.au, jlan@sgi.com,
        linux-mm@kvack.org, magnus.damm@gmail.com,
        mm-commits@vger.kernel.org, robh+dt@kernel.org,
        rppt@linux.vnet.ibm.com, tony.luck@intel.com,
        torvalds@linux-foundation.org
Subject:  [patch 003/212] ia64: make reserve_elfcorehdr() static
Message-ID: <20210902215004.Xtl4qh2JH%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
