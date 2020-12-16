Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7EEFC0018C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:12:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1405233F6
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgLPRMk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:12:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:33620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbgLPRMk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:12:40 -0500
Date:   Wed, 16 Dec 2020 09:11:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138719;
        bh=N2aMr511NwBYhAwPanLl1kjsaOKieqOtqJafRp8Krxs=;
        h=From:To:Subject:From;
        b=x6hqN6z/s7jQ0xiOLMFQpooctTyJ5HqlU/pFdlw0pUvYwZfPaSKjjI/QHgOJMas+1
         NbdvymdAudTft/e1egzH7va35OZZKFnJJkGzqR2izD9Xmx1RwYqsA0C8R2RLZXJ3H0
         Ya+ILsLAF+w4992NIJbHc9nhGMEeIlEMPvzEr/64=
From:   akpm@linux-foundation.org
To:     dave.rodgman@arm.com, mm-commits@vger.kernel.org,
        yanaijie@huawei.com
Subject:  [merged]
 lib-lzo-make-lzogeneric1x_1_compress-static.patch removed from -mm tree
Message-ID: <20201216171159.plzl1DHIs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/lzo/lzo1x_compress.c: make lzogeneric1x_1_compress() static
has been removed from the -mm tree.  Its filename was
     lib-lzo-make-lzogeneric1x_1_compress-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jason Yan <yanaijie@huawei.com>
Subject: lib/lzo/lzo1x_compress.c: make lzogeneric1x_1_compress() static

Fix the following sparse warning:

lib/lzo/lzo1x_compress.c:304:5: warning: symbol
'lzogeneric1x_1_compress' was not declared. Should it be static?

Link: https://lkml.kernel.org/r/20201020031415.136874-1-yanaijie@huawei.com
Signed-off-by: Jason Yan <yanaijie@huawei.com>
Cc: Dave Rodgman <dave.rodgman@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lzo/lzo1x_compress.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/lzo/lzo1x_compress.c~lib-lzo-make-lzogeneric1x_1_compress-static
+++ a/lib/lzo/lzo1x_compress.c
@@ -301,7 +301,7 @@ finished_writing_instruction:
 	return in_end - (ii - ti);
 }
 
-int lzogeneric1x_1_compress(const unsigned char *in, size_t in_len,
+static int lzogeneric1x_1_compress(const unsigned char *in, size_t in_len,
 		     unsigned char *out, size_t *out_len,
 		     void *wrkmem, const unsigned char bitstream_version)
 {
_

Patches currently in -mm which might be from yanaijie@huawei.com are


