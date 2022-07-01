Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98CBFC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  1 Jul 2022 23:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbiGAXCo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Jul 2022 19:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiGAXCl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jul 2022 19:02:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367957125C
        for <mm-commits@vger.kernel.org>; Fri,  1 Jul 2022 16:02:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCC8F6243A
        for <mm-commits@vger.kernel.org>; Fri,  1 Jul 2022 23:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13ACFC3411E;
        Fri,  1 Jul 2022 23:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656716560;
        bh=aSE2zzy+E/ZCwb9QeoZJ5lvSS7y6hqbuAkBin6na2R8=;
        h=Date:To:From:Subject:From;
        b=Zi062hFzM3lhlogyWIEHiENG5t21se1PQtzQOkNvfjoAVJ46w79PDDuIZbA1tlpVb
         cm5JeiBuMWWpn2q+KEBzhg0fvASbVLviUq7wCXzcJVXcBhTjr2loMrTtQg8fVlDJpS
         lEkmMnir/Hj3xyDREt4OxWbOY9s9Fa1ryc5H45M0=
Date:   Fri, 01 Jul 2022 16:02:39 -0700
To:     mm-commits@vger.kernel.org, jgg@nvidia.com, glider@google.com,
        elver@google.com, dvyukov@google.com, linus.walleij@linaro.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-highmem-pass-a-pointer-to-virt_to_page.patch added to mm-unstable branch
Message-Id: <20220701230240.13ACFC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/highmem: pass a pointer to virt_to_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-highmem-pass-a-pointer-to-virt_to_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-highmem-pass-a-pointer-to-virt_to_page.patch

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

lib-test_free_pagesc-pass-a-pointer-to-virt_to_page.patch
mm-highmem-pass-a-pointer-to-virt_to_page.patch
mm-kfence-pass-a-pointer-to-virt_to_page.patch
mm-gup-pass-a-pointer-to-virt_to_page.patch
mm-nommu-pass-a-pointer-to-virt_to_page.patch

