Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29323C2BBCA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:47:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE3D523137
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgLPEr3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:47:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:52318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbgLPEr3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:47:29 -0500
Date:   Tue, 15 Dec 2020 20:47:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608094034;
        bh=OvfRqQrU89eElhb34DyheCv8+OA8deiKLhBc5IoYBTU=;
        h=From:To:Subject:In-Reply-To:From;
        b=krjQWoac3+ouXvU+xfZlRyVdEBE2tBlJhkMjBC3DZ94dD2Hko3/I7rQ8joogVKh0w
         FvGRMkX9uTq5+5vraLBIFKWSubywD58mfqX0CPmkCPjF8ZGNHrnHg3JQfH5vOWBvHW
         66QAHHEL24LgD3BvkAWycE+tOBcclQX3rdYj8hUY=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dave.rodgman@arm.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, yanaijie@huawei.com
Subject:  [patch 89/95] lib/lzo/lzo1x_compress.c: make
 lzogeneric1x_1_compress() static
Message-ID: <20201216044713.5Y4b38QSs%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
