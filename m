Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF5BC4338F
	for <mm-commits@archiver.kernel.org>; Sun,  1 Aug 2021 19:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A191261059
	for <mm-commits@archiver.kernel.org>; Sun,  1 Aug 2021 19:38:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbhHATi7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Aug 2021 15:38:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229529AbhHATi6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 1 Aug 2021 15:38:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 937B460E09;
        Sun,  1 Aug 2021 19:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627846730;
        bh=raf8F7Ez6pGjfIqA+hRlyumh5cpreyKeYGYyqWoS27Y=;
        h=Date:From:To:Subject:From;
        b=oxIetnp5/aEKwKtlGMmCbg/wMjDYKNyzJHLnd/4lMTirzmctTSpHYq47xhuOM/UoU
         e5T7MufR/50M/oYKadkMwPzknEFR6ICU5PsozMnz72qYri4u5WGK+wCWd01cAqbcoQ
         mnjX9jT/Gkaw5QGwzIVwbWPofUdTmGWn4w0ce56E=
Date:   Sun, 01 Aug 2021 12:38:50 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        linux@roeck-us.net, rppt@kernel.org
Subject:  +
 mm-page_alloc-always-initialize-memory-map-for-the-holes-fix.patch added to
 -mm tree
Message-ID: <20210801193850.vHM1x%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-always-initialize-memory-map-for-the-holes-fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-always-initialize-memory-map-for-the-holes-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-always-initialize-memory-map-for-the-holes-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-always-initialize-memory-map-for-the-holes-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page_alloc-always-initialize-memory-map-for-the-holes-fix.patch

