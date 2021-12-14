Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8E82C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 14 Dec 2021 18:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbhLNSav (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Dec 2021 13:30:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhLNSau (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Dec 2021 13:30:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C213EC061574
        for <mm-commits@vger.kernel.org>; Tue, 14 Dec 2021 10:30:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 625CB61694
        for <mm-commits@vger.kernel.org>; Tue, 14 Dec 2021 18:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7B4C34600;
        Tue, 14 Dec 2021 18:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639506649;
        bh=DxdLDUOP+mYAA6cixg+RsXTdIoP+M0DqAw0x5YvImy4=;
        h=Date:From:To:Subject:From;
        b=vEK5Zda2rlM/bbOAU5mjpSK+wZqIvRKb6ayvenxJsGuLrAhOb2b1I3BjmP635nI2g
         1TOuiiMTQOFf4xUVy41nXFiibv1UoRXCXSn4kHJXpSPCEKkgtbMnpO3nTw29p+WJV1
         xWJMu5Qvlq6lKeU98skooQ7R1T5Yy2kA2Q/SbJ8I=
Date:   Tue, 14 Dec 2021 10:30:49 -0800
From:   akpm@linux-foundation.org
To:     danielmicay@gmail.com, keescook@chromium.org,
        levente@leventepolyak.net, mm-commits@vger.kernel.org,
        thibaut.sautereau@ssi.gouv.fr
Subject:  +
 mm-page_alloc-fix-__alloc_size-attribute-for-alloc_pages_exact_nid.patch
 added to -mm tree
Message-ID: <20211214183049.d_I5txWxI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: fix __alloc_size attribute for alloc_pages_exact_nid
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fix-__alloc_size-attribute-for-alloc_pages_exact_nid.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fix-__alloc_size-attribute-for-alloc_pages_exact_nid.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fix-__alloc_size-attribute-for-alloc_pages_exact_nid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
Subject: mm/page_alloc: fix __alloc_size attribute for alloc_pages_exact_nid

The second parameter of alloc_pages_exact_nid is the one indicating the
size of memory pointed by the returned pointer.

Link: https://lkml.kernel.org/r/YbjEgwhn4bGblp//@coeus
Fixes: abd58f38dfb4 ("mm/page_alloc: add __alloc_size attributes for better bounds checking")
Signed-off-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Levente Polyak <levente@leventepolyak.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/gfp.h~mm-page_alloc-fix-__alloc_size-attribute-for-alloc_pages_exact_nid
+++ a/include/linux/gfp.h
@@ -624,7 +624,7 @@ extern unsigned long get_zeroed_page(gfp
 
 void *alloc_pages_exact(size_t size, gfp_t gfp_mask) __alloc_size(1);
 void free_pages_exact(void *virt, size_t size);
-__meminit void *alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask) __alloc_size(1);
+__meminit void *alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask) __alloc_size(2);
 
 #define __get_free_page(gfp_mask) \
 		__get_free_pages((gfp_mask), 0)
_

Patches currently in -mm which might be from thibaut.sautereau@ssi.gouv.fr are

mm-page_alloc-fix-__alloc_size-attribute-for-alloc_pages_exact_nid.patch

