Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 920DEC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46AFF2087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816513;
	bh=ZYjvwyI/eUwAgTG97KnHQSZMik8xQcTqfc6qJ2GjU1k=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=lKK3+tneBF4ZSnLw87C7e0Vkf/gKt0j7DiQdqNsAXGej6FjYLD3kIQCgEqMFXwWV4
	 AIP7wJP1wcVa6RnDqV83GIxCv6Fws1d9byQoJ9Bchjv7lXbuEpsiJCvEobsG+9EV5L
	 8bJQCapdH8hWO9gd3errztHZOwMOb9iON+JgHEBA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393913AbgJPCsc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:48:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388865AbgJPCsc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:48:32 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E1B3208E4;
        Fri, 16 Oct 2020 02:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816511;
        bh=ZYjvwyI/eUwAgTG97KnHQSZMik8xQcTqfc6qJ2GjU1k=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=v3OZIyo97KgwEsiyN+gT1hU6pnoPXzQ4G92k5ex8u4+P0eRB5E/00jtAjiUx68VJy
         IkE3l1k5UYFmmrcF9FmDTb2JjB07QV6kXXl8giaJaeGqEzdF+c7pdbrme/iiL5hE1Z
         vA7Ri6zI0ItjpBlz6cl59zGPe8pUWam6HI9GR7KM=
Date:   Thu, 15 Oct 2020 19:48:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, kernel@cdqe.de,
        krzk@kernel.org, linux-mm@kvack.org, mchehab+huawei@kernel.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 118/156] lib/crc32.c: fix trivial typo in
 preprocessor condition
Message-ID: <20201016024830.ZQ9_xyLez%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Tobias Jordan <kernel@cdqe.de>
Subject: lib/crc32.c: fix trivial typo in preprocessor condition

Whether crc32_be needs a lookup table is chosen based on CRC_LE_BITS. 
Obviously, the _be function should be governed by the _BE_ define.

This probably never pops up as it's hard to come up with a configuration
where CRC_BE_BITS isn't the same as CRC_LE_BITS and as nobody is using
bitwise CRC anyway.

Link: https://lkml.kernel.org/r/20200923182122.GA3338@agrajag.zerfleddert.de
Fixes: 46c5801eaf86 ("crc32: bolt on crc32c")
Signed-off-by: Tobias Jordan <kernel@cdqe.de>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/crc32.c~lib-crc32c-fix-trivial-typo-in-preprocessor-condition
+++ a/lib/crc32.c
@@ -331,7 +331,7 @@ static inline u32 __pure crc32_be_generi
 	return crc;
 }
 
-#if CRC_LE_BITS == 1
+#if CRC_BE_BITS == 1
 u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 {
 	return crc32_be_generic(crc, p, len, NULL, CRC32_POLY_BE);
_
