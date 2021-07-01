Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 139D1C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F41BC61420
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238561AbhGAB6r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:58:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238467AbhGAB6n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:58:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DFFE61418;
        Thu,  1 Jul 2021 01:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104573;
        bh=YFimTB8Trav/BodnvstdleU+peLP5UK6Zk8PfTKBsAE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cMHkhIwCEyxFFt/O0sCWF+GFblcKFbtSTwg7O9NPG552I7uJ6nPjQYxmNWnVtONLT
         RQdS+nnf4K6zudTf2BPqTt3ASIV8oSBkTKeLXOv9iBOGSOiVYH9prB9beiB+wIyz8L
         ZvE2xOfuOOs5EzP9yN/rUUjTD9jAvtbGiFNZCO3Q=
Date:   Wed, 30 Jun 2021 18:56:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hsiangkao@redhat.com, joe@perches.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, terrelln@fb.com,
        thisisrast7@gmail.com, torvalds@linux-foundation.org
Subject:  [patch 171/192] lz4_decompress: declare
 LZ4_decompress_safe_withPrefix64k static
Message-ID: <20210701015613.APX-MDiYp%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
