Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4AC6C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:17:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D182610A0
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:17:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345768AbhIBVSm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:18:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245379AbhIBVSm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:18:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67F0361059;
        Thu,  2 Sep 2021 21:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630617463;
        bh=MsLe1ufKHETkDI6QIucgEyBPQ/cg7CIeYo5pFVwe4nU=;
        h=Date:From:To:Subject:From;
        b=Dqnpvq16GaYJQc7zDPGNpZG9tpXz6r/YxI7ejSBPESWyfI/7sKpSLuYfkFBdixXiz
         huzG5SipFNKS+HAcolX6yKeo0UoHIgZ0NKgoLPalCMSnVGh/lw4CA6qR8FlGXjRD7A
         WZ95atglVKOhrzPS+qQfvJzGYFYx3tcqxcSpqZCQ=
Date:   Thu, 02 Sep 2021 14:17:43 -0700
From:   akpm@linux-foundation.org
To:     linux@roeck-us.net, mm-commits@vger.kernel.org, rppt@kernel.org,
        sfr@canb.auug.org.au
Subject:  [folded-merged]
 mm-page_alloc-always-initialize-memory-map-for-the-holes-fix.patch removed
 from -mm tree
Message-ID: <20210902211743.nmcuLSK8S%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-always-initialize-memory-map-for-the-holes-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-always-initialize-memory-map-for-the-holes-fix.patch

This patch was dropped because it was folded into mm-page_alloc-always-initialize-memory-map-for-the-holes.patch

------------------------------------------------------
From: Mike Rapoport <rppt@kernel.org>
Subject: mm-page_alloc-always-initialize-memory-map-for-the-holes-fix

It appears that petalogix-ml605 memory starts at 0x50000, but microblaze's
pfn_valid does not reject pfns < ARCH_PFN_OFFSET.

Link: https://lkml.kernel.org/r/YQWW3RCE4eWBuMu/@kernel.org
Tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/include/asm/page.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/microblaze/include/asm/page.h~mm-page_alloc-always-initialize-memory-map-for-the-holes-fix
+++ a/arch/microblaze/include/asm/page.h
@@ -112,8 +112,7 @@ extern int page_is_ram(unsigned long pfn
 #  define page_to_phys(page)     (page_to_pfn(page) << PAGE_SHIFT)
 
 #  define ARCH_PFN_OFFSET	(memory_start >> PAGE_SHIFT)
-#  define pfn_valid(pfn)	((pfn) < (max_mapnr + ARCH_PFN_OFFSET))
-
+#  define pfn_valid(pfn)	((pfn) >= ARCH_PFN_OFFSET && (pfn) < (max_mapnr + ARCH_PFN_OFFSET))
 # endif /* __ASSEMBLY__ */
 
 #define	virt_addr_valid(vaddr)	(pfn_valid(virt_to_pfn(vaddr)))
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-page_alloc-always-initialize-memory-map-for-the-holes.patch

