Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76C7BC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  1 Jul 2022 23:02:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbiGAXCk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Jul 2022 19:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiGAXCk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jul 2022 19:02:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431EE7125C
        for <mm-commits@vger.kernel.org>; Fri,  1 Jul 2022 16:02:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D59B66247B
        for <mm-commits@vger.kernel.org>; Fri,  1 Jul 2022 23:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311E4C3411E;
        Fri,  1 Jul 2022 23:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656716558;
        bh=g0gbiJL2iNQiXzaTqtmTkJhnXSvsNriGQfJEleoS/xo=;
        h=Date:To:From:Subject:From;
        b=oJguTChkF69nNJ47iB6tGEEbDnqvW7fPtxcDjeJjxKxtTWhK9zmjCioPDSAsmCZa5
         WBqs9ItgRAnfcaG5/+IWuNd5qXnLGGODXivPaISlvEZ1ilTW5evtd+ALbCMnyamvQ+
         u2b5WQX7Bt/4vmoRJjfPmVmgC5j42f3wZi75TL64=
Date:   Fri, 01 Jul 2022 16:02:37 -0700
To:     mm-commits@vger.kernel.org, jgg@nvidia.com, glider@google.com,
        elver@google.com, dvyukov@google.com, linus.walleij@linaro.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_free_pagesc-pass-a-pointer-to-virt_to_page.patch added to mm-unstable branch
Message-Id: <20220701230238.311E4C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_free_pages.c: pass a pointer to virt_to_page()
has been added to the -mm mm-unstable branch.  Its filename is
     lib-test_free_pagesc-pass-a-pointer-to-virt_to_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_free_pagesc-pass-a-pointer-to-virt_to_page.patch

This patch will later appear in the mm-unstable branch at
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

lib-test_free_pagesc-pass-a-pointer-to-virt_to_page.patch
mm-highmem-pass-a-pointer-to-virt_to_page.patch
mm-kfence-pass-a-pointer-to-virt_to_page.patch
mm-gup-pass-a-pointer-to-virt_to_page.patch
mm-nommu-pass-a-pointer-to-virt_to_page.patch

