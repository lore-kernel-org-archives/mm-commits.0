Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3EA3C43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233272AbiGRAS5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233212AbiGRARn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:17:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A55413D70
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:17:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26E4860F0F
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7730EC341C0;
        Mon, 18 Jul 2022 00:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103444;
        bh=et34hpu3Tr4yflBg8eKMS3cj8As9GI4Q34+4Um5EFzY=;
        h=Date:To:From:Subject:From;
        b=O2ODirbfhJDbagJ9HSALD8RjN/4kfFskDH8X+Jq5Cig5NGDbKWfKz+l+GIwhcA05Q
         vHD+sqvjb1VjkNeRbxPR+46yw14ohUhNP334iB9oGogI04rrKOsSzZsh9D/V9sx4Nc
         bpIj5NXUWGG60PFSlLEBYwnnm7We7xMagZgGdANU=
Date:   Sun, 17 Jul 2022 17:17:23 -0700
To:     mm-commits@vger.kernel.org, jgg@nvidia.com, glider@google.com,
        elver@google.com, dvyukov@google.com, linus.walleij@linaro.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-highmem-pass-a-pointer-to-virt_to_page.patch removed from -mm tree
Message-Id: <20220718001724.7730EC341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/highmem: pass a pointer to virt_to_page()
has been removed from the -mm tree.  Its filename was
     mm-highmem-pass-a-pointer-to-virt_to_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Linus Walleij <linus.walleij@linaro.org>
Subject: mm/highmem: pass a pointer to virt_to_page()
Date: Thu, 30 Jun 2022 10:41:21 +0200

Functions that work on a pointer to virtual memory such as virt_to_pfn()
and users of that function such as virt_to_page() are supposed to pass a
pointer to virtual memory, ideally a (void *) or other pointer.  However
since many architectures implement virt_to_pfn() as a macro, this function
becomes polymorphic and accepts both a (unsigned long) and a (void *).

If we instead implement a proper virt_to_pfn(void *addr) function the
following happens (occurred on arch/arm):

mm/highmem.c:153:29: warning: passing argument 1 of
  'virt_to_pfn' makes pointer from integer without a
  cast [-Wint-conversion]

We already have a proper void * pointer in the scope of this function
named "vaddr" so pass that instead.

Link: https://lkml.kernel.org/r/20220630084124.691207-3-linus.walleij@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/highmem.c~mm-highmem-pass-a-pointer-to-virt_to_page
+++ a/mm/highmem.c
@@ -150,7 +150,7 @@ struct page *__kmap_to_page(void *vaddr)
 		return pte_page(pkmap_page_table[i]);
 	}
 
-	return virt_to_page(addr);
+	return virt_to_page(vaddr);
 }
 EXPORT_SYMBOL(__kmap_to_page);
 
_

Patches currently in -mm which might be from linus.walleij@linaro.org are


