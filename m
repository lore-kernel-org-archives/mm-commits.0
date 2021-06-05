Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A047DC4743E
	for <mm-commits@archiver.kernel.org>; Sat,  5 Jun 2021 03:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88DA76140F
	for <mm-commits@archiver.kernel.org>; Sat,  5 Jun 2021 03:01:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbhFEDD2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Jun 2021 23:03:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231609AbhFEDD1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Jun 2021 23:03:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C954761244;
        Sat,  5 Jun 2021 03:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622862100;
        bh=ArsIRloanwjV9E1bU2FjJt/DNCKQUj1U8Q8T5L9BT4g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wtO0Hp4u1wJS+1IfiGjtjydxYhMHAvVCN3H4O8Oe+blSOvzXm8XLUloQJmJrXhjPh
         sqEryEVrKr4yRJ3HWbEUHkkNXtFju8Ohs5DWe5fiFIhrbM667WB48iFqvAOhV/8eR/
         rGwRieBxOVPTzgXKzkRJMEgFU8wwljVhyxpeFLuY=
Date:   Fri, 04 Jun 2021 20:01:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, colyli@suse.de, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, yuehaibing@huawei.com
Subject:  [patch 11/13] lib: crc64: fix kernel-doc warning
Message-ID: <20210605030139.95d2TaarF%akpm@linux-foundation.org>
In-Reply-To: <20210604200040.d8d0406caf195525620c0f3d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Subject: lib: crc64: fix kernel-doc warning

Fix W=1 kernel build warning:

lib/crc64.c:40: warning:
 bad line:         or the previous crc64 value if computing incrementally.

Link: https://lkml.kernel.org/r/20210601135851.15444-1-yuehaibing@huawei.com
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Coly Li <colyli@suse.de>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/crc64.c~lib-crc64-fix-kernel-doc-warning
+++ a/lib/crc64.c
@@ -37,7 +37,7 @@ MODULE_LICENSE("GPL v2");
 /**
  * crc64_be - Calculate bitwise big-endian ECMA-182 CRC64
  * @crc: seed value for computation. 0 or (u64)~0 for a new CRC calculation,
-	or the previous crc64 value if computing incrementally.
+ *       or the previous crc64 value if computing incrementally.
  * @p: pointer to buffer over which CRC64 is run
  * @len: length of buffer @p
  */
_
