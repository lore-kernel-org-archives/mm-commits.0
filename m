Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EACCEC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D108761CAA
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhGFTZf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:25:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229787AbhGFTZa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:25:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8682E61CA8;
        Tue,  6 Jul 2021 19:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599371;
        bh=m9TtyXjIVCZQ7zL0U+TjrENkMQmUO+vAgnIPyJV9t/A=;
        h=Date:From:To:Subject:From;
        b=NObJe2SOXkea4eZR8MQ4YKolnBXIMHwzGecj+/zUm6NK3RDDLeZLqQ+kJMlxJ7aMO
         TFBNLA9f1XMkqxaodPrxG6dum4rxugLOa3hwMby2Ca1EKV9N/IqA/pN1U+rrOfxeCw
         CxzjwzynvhHq8drPrYEEtdvVXADmLavTV40SXaYw=
Date:   Tue, 06 Jul 2021 12:22:51 -0700
From:   akpm@linux-foundation.org
To:     hsiangkao@redhat.com, joe@perches.com, mm-commits@vger.kernel.org,
        terrelln@fb.com, thisisrast7@gmail.com
Subject:  [merged]
 lz4_decompress-declare-lz4_decompress_safe_withprefix64k-static.patch
 removed from -mm tree
Message-ID: <20210706192251.qzgokR6Oz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lz4_decompress: declare LZ4_decompress_safe_withPrefix64k static
has been removed from the -mm tree.  Its filename was
     lz4_decompress-declare-lz4_decompress_safe_withprefix64k-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


