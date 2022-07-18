Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72396C43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbiGRATG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233216AbiGRARo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:17:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3273813D78
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:17:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CACB7B80EBC
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F436C3411E;
        Mon, 18 Jul 2022 00:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103445;
        bh=0OB8Hq8+csFAPFQgi0AqHwEUJ4g5j3hdmm+c4P/B0AY=;
        h=Date:To:From:Subject:From;
        b=pqfgL3dDE7uLQZI+0BxNxegkPSsELH9a+l1xK4UY/oiubDwrq0RUprQadihRs0RFc
         fC4FVap2vjAFtMeFBm/g5SRqpnDjakpyD+pAcNM9FCxlCBAZDTCYHuo7gpM5fO9i29
         Qa/6h8rKQtz0IRnHrI0wduXgcqm+KI+ujd13pLkQ=
Date:   Sun, 17 Jul 2022 17:17:24 -0700
To:     mm-commits@vger.kernel.org, jgg@nvidia.com, glider@google.com,
        elver@google.com, dvyukov@google.com, linus.walleij@linaro.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kfence-pass-a-pointer-to-virt_to_page.patch removed from -mm tree
Message-Id: <20220718001725.7F436C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: kfence: pass a pointer to virt_to_page()
has been removed from the -mm tree.  Its filename was
     mm-kfence-pass-a-pointer-to-virt_to_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Linus Walleij <linus.walleij@linaro.org>
Subject: mm: kfence: pass a pointer to virt_to_page()
Date: Thu, 30 Jun 2022 10:41:22 +0200

Functions that work on a pointer to virtual memory such as virt_to_pfn()
and users of that function such as virt_to_page() are supposed to pass a
pointer to virtual memory, ideally a (void *) or other pointer.  However
since many architectures implement virt_to_pfn() as a macro, this function
becomes polymorphic and accepts both a (unsigned long) and a (void *).

If we instead implement a proper virt_to_pfn(void *addr) function the
following happens (occurred on arch/arm):

mm/kfence/core.c:558:30: warning: passing argument 1
  of 'virt_to_pfn' makes pointer from integer without a
  cast [-Wint-conversion]

In one case we can refer to __kfence_pool directly (and that is a proper
(char *) pointer) and in the other call site we use an explicit cast.

Link: https://lkml.kernel.org/r/20220630084124.691207-4-linus.walleij@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kfence/core.c~mm-kfence-pass-a-pointer-to-virt_to_page
+++ a/mm/kfence/core.c
@@ -546,7 +546,7 @@ static unsigned long kfence_init_pool(vo
 	if (!arch_kfence_init_pool())
 		return addr;
 
-	pages = virt_to_page(addr);
+	pages = virt_to_page(__kfence_pool);
 
 	/*
 	 * Set up object pages: they must have PG_slab set, to avoid freeing
@@ -660,7 +660,7 @@ static bool kfence_init_pool_late(void)
 	/* Same as above. */
 	free_size = KFENCE_POOL_SIZE - (addr - (unsigned long)__kfence_pool);
 #ifdef CONFIG_CONTIG_ALLOC
-	free_contig_range(page_to_pfn(virt_to_page(addr)), free_size / PAGE_SIZE);
+	free_contig_range(page_to_pfn(virt_to_page((void *)addr)), free_size / PAGE_SIZE);
 #else
 	free_pages_exact((void *)addr, free_size);
 #endif
_

Patches currently in -mm which might be from linus.walleij@linaro.org are


