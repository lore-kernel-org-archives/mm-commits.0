Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E74F8CCA47F
	for <mm-commits@archiver.kernel.org>; Fri,  1 Jul 2022 23:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiGAXCs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Jul 2022 19:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbiGAXCr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jul 2022 19:02:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36747127D
        for <mm-commits@vger.kernel.org>; Fri,  1 Jul 2022 16:02:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 744D162471
        for <mm-commits@vger.kernel.org>; Fri,  1 Jul 2022 23:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC42DC3411E;
        Fri,  1 Jul 2022 23:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656716565;
        bh=BhNL8SUkwHjIGSUxq90YqRWEL4CJr2aJxeKW/YhGISg=;
        h=Date:To:From:Subject:From;
        b=xHYNIc216JPgBWS4QozR722aYUzlEPOek2HUF/l1jNLE2lwkEbcHcEiysEPypkPWY
         HeC7jCMOvKdPq35SFs53q4VtsFDAD4M2WbST5S3fjDxwrjUdz2HkgmxhTUa9VsMfp6
         jNsi60edLQgBjLxLbUQWkqr50PZeA7N9dij9wqbU=
Date:   Fri, 01 Jul 2022 16:02:45 -0700
To:     mm-commits@vger.kernel.org, jgg@nvidia.com, glider@google.com,
        elver@google.com, dvyukov@google.com, linus.walleij@linaro.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-nommu-pass-a-pointer-to-virt_to_page.patch added to mm-unstable branch
Message-Id: <20220701230245.CC42DC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: nommu: pass a pointer to virt_to_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-nommu-pass-a-pointer-to-virt_to_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-nommu-pass-a-pointer-to-virt_to_page.patch

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
Subject: mm: nommu: pass a pointer to virt_to_page()
Date: Thu, 30 Jun 2022 10:41:24 +0200

Functions that work on a pointer to virtual memory such as virt_to_pfn()
and users of that function such as virt_to_page() are supposed to pass a
pointer to virtual memory, ideally a (void *) or other pointer.  However
since many architectures implement virt_to_pfn() as a macro, this function
becomes polymorphic and accepts both a (unsigned long) and a (void *).

If we instead implement a proper virt_to_pfn(void *addr) function the
following happens (occurred on arch/arm):

  mm/nommu.c: In function 'free_page_series':
  mm/nommu.c:501:50: warning: passing argument 1 of 'virt_to_pfn'
  makes pointer from integer without a cast [-Wint-conversion]
  struct page *page = virt_to_page(from);

Fix this with an explicit cast.

Link: https://lkml.kernel.org/r/20220630084124.691207-6-linus.walleij@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/nommu.c~mm-nommu-pass-a-pointer-to-virt_to_page
+++ a/mm/nommu.c
@@ -499,7 +499,7 @@ static void delete_nommu_region(struct v
 static void free_page_series(unsigned long from, unsigned long to)
 {
 	for (; from < to; from += PAGE_SIZE) {
-		struct page *page = virt_to_page(from);
+		struct page *page = virt_to_page((void *)from);
 
 		atomic_long_dec(&mmap_pages_allocated);
 		put_page(page);
_

Patches currently in -mm which might be from linus.walleij@linaro.org are

lib-test_free_pagesc-pass-a-pointer-to-virt_to_page.patch
mm-highmem-pass-a-pointer-to-virt_to_page.patch
mm-kfence-pass-a-pointer-to-virt_to_page.patch
mm-gup-pass-a-pointer-to-virt_to_page.patch
mm-nommu-pass-a-pointer-to-virt_to_page.patch

