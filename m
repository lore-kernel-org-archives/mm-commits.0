Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BBB4C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbiGRATN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbiGRARo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:17:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3099813D76
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:17:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D29C4B80EE8
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709CCC3411E;
        Mon, 18 Jul 2022 00:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103443;
        bh=ODTIEAG1pf0QWzWsMTFCnpbkJYgz5/Jyp+ehc7sCAjk=;
        h=Date:To:From:Subject:From;
        b=GidHHsty9OypoCYkaBCBaP7dlFBcRCUVVuLOyvhzsNBNxKKnPy5g3HO6SXy1xGAh0
         Md7kWzJdaeFC2eNszKoY5H5ua0C/Wnm8cDLXDY2xJBiMaD9GhutHxytGkAbkUBp3O3
         N3QnCY6Vl3+33LV7ZOLV7enniHNZC17JOCLlutco=
Date:   Sun, 17 Jul 2022 17:17:22 -0700
To:     mm-commits@vger.kernel.org, jgg@nvidia.com, glider@google.com,
        elver@google.com, dvyukov@google.com, linus.walleij@linaro.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_free_pagesc-pass-a-pointer-to-virt_to_page.patch removed from -mm tree
Message-Id: <20220718001723.709CCC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/test_free_pages.c: pass a pointer to virt_to_page()
has been removed from the -mm tree.  Its filename was
     lib-test_free_pagesc-pass-a-pointer-to-virt_to_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Linus Walleij <linus.walleij@linaro.org>
Subject: lib/test_free_pages.c: pass a pointer to virt_to_page()
Date: Thu, 30 Jun 2022 10:41:20 +0200

In a recent change to the Arm architecture with the end goal of removing
highmem we need to convert virt_to_phys() and virt_to_pfn() to static
inline functions.

This will make them strongly typed.

However since virt_to_* is always implemented as macros they have become
polymorphic and accept both (void *) and e.g.  unsigned long as arguments.

Other functions such as virt_to_page() simply wrap virt_to_pfn() and get
affected indirectly.

To be able to proceed, patch mm to use (void *) as argument to affected
functions in all instances.


This patch (of 5):

A pointer into virtual memory is represented by a (void *) not an u32, so
the compiler warns:

lib/test_free_pages.c:20:50: warning: passing argument 1
  of 'virt_to_pfn' makes pointer from integer without a
  cast [-Wint-conversion]

Fix this with an explicit cast.

Link: https://lkml.kernel.org/r/20220630084124.691207-1-linus.walleij@linaro.org
Link: https://lkml.kernel.org/r/20220630084124.691207-2-linus.walleij@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_free_pages.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_free_pages.c~lib-test_free_pagesc-pass-a-pointer-to-virt_to_page
+++ a/lib/test_free_pages.c
@@ -17,7 +17,7 @@ static void test_free_pages(gfp_t gfp)
 
 	for (i = 0; i < 1000 * 1000; i++) {
 		unsigned long addr = __get_free_pages(gfp, 3);
-		struct page *page = virt_to_page(addr);
+		struct page *page = virt_to_page((void *)addr);
 
 		/* Simulate page cache getting a speculative reference */
 		get_page(page);
_

Patches currently in -mm which might be from linus.walleij@linaro.org are


