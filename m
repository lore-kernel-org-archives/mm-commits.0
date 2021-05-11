Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 573DEC433ED
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 21:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BFC26191E
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 21:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhEKVKq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 May 2021 17:10:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230011AbhEKVKp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 May 2021 17:10:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBB3C6191D;
        Tue, 11 May 2021 21:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620767378;
        bh=0KIFyJh1/gEmDNhKqoO7Ek43lQwpqsR9TpxIa36Be8c=;
        h=Date:From:To:Subject:From;
        b=DvJGUtklNP1p/V5ceGHXhVgVGJwWDgI0Y9jwLCgo3SF5/mZcCMRH/QnRXkB3/bVg8
         pFrxRWKL+GmmjcaUz37b7DhorUHWHhniU/o1kyRA3X72ZAJR6h54jptxFYXuiy1VDY
         vx73uvr0Pj1nBPEnmtAYtzdZqOAEHH+aI9LnHiUk=
Date:   Tue, 11 May 2021 14:09:37 -0700
From:   akpm@linux-foundation.org
To:     hsiangkao@redhat.com, joe@perches.com, mm-commits@vger.kernel.org,
        terrelln@fb.com, thisisrast7@gmail.com
Subject:  +
 lz4_decompress-declare-lz4_decompress_safe_withprefix64k-static.patch added
 to -mm tree
Message-ID: <20210511210937.j1pBrEDvm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lz4_decompress: declare LZ4_decompress_safe_withPrefix64k static
has been added to the -mm tree.  Its filename is
     lz4_decompress-declare-lz4_decompress_safe_withprefix64k-static.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lz4_decompress-declare-lz4_decompress_safe_withprefix64k-static.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lz4_decompress-declare-lz4_decompress_safe_withprefix64k-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rajat Asthana <thisisrast7@gmail.com>
Subject: lz4_decompress: declare LZ4_decompress_safe_withPrefix64k static

Declare LZ4_decompress_safe_withPrefix64k as static to fix sparse
warning:

> warning: symbol 'LZ4_decompress_safe_withPrefix64k' was not declared.
> Should it be static?

Link: https://lkml.kernel.org/r/20210511154345.610569-1-thisisrast7@gmail.com
Signed-off-by: Rajat Asthana <thisisrast7@gmail.com>
Reviewed-by: Nick Terrell <terrelln@fb.com>
Cc: Gao Xiang <hsiangkao@redhat.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lz4/lz4_decompress.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/lz4/lz4_decompress.c~lz4_decompress-declare-lz4_decompress_safe_withprefix64k-static
+++ a/lib/lz4/lz4_decompress.c
@@ -481,7 +481,7 @@ int LZ4_decompress_fast(const char *sour
 
 /* ===== Instantiate a few more decoding cases, used more than once. ===== */
 
-int LZ4_decompress_safe_withPrefix64k(const char *source, char *dest,
+static int LZ4_decompress_safe_withPrefix64k(const char *source, char *dest,
 				      int compressedSize, int maxOutputSize)
 {
 	return LZ4_decompress_generic(source, dest,
_

Patches currently in -mm which might be from thisisrast7@gmail.com are

lz4_decompress-declare-lz4_decompress_safe_withprefix64k-static.patch

