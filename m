Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_RED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 575F4C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 412996146D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238551AbhGAB6O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:58:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238463AbhGAB6N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:58:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A27761469;
        Thu,  1 Jul 2021 01:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104544;
        bh=xhHpZARSknPhHNKbcTGGZInnwjH486Rov5ZB19Lj9CA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kxp2NBnjA9sUR515OpUW8nJ7Exxq2llykwn6PuJRebIHzQuh5xoTs9/t2QNBnBwdL
         pdWKo3KJYA24itdGpWerCkPr4X+gJwFOsspiv5pucIkon/ybfT0UYG10NeXzYs8r7/
         MQmuLnv2Tu/5q89xlZQMJh/y8OVK5AMesCZwVTGo=
Date:   Wed, 30 Jun 2021 18:55:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        bfields@fieldses.org, chuck.lever@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 161/192] nfsd: avoid non-flexible API in
 seq_quote_mem()
Message-ID: <20210701015543.qMe2Bv2DX%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: nfsd: avoid non-flexible API in seq_quote_mem()

The seq_escape_mem_ascii() is completely non-flexible and shouldn't be
used.  Replace it with properly called seq_escape_mem().

Link: https://lkml.kernel.org/r/20210504180819.73127-15-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c~nfsd-avoid-non-flexible-api-in-seq_quote_mem
+++ a/fs/nfsd/nfs4state.c
@@ -2351,7 +2351,7 @@ static struct nfs4_client *get_nfsdfs_cl
 static void seq_quote_mem(struct seq_file *m, char *data, int len)
 {
 	seq_printf(m, "\"");
-	seq_escape_mem_ascii(m, data, len);
+	seq_escape_mem(m, data, len, ESCAPE_HEX | ESCAPE_NAP | ESCAPE_APPEND, "\"\\");
 	seq_printf(m, "\"");
 }
 
_
