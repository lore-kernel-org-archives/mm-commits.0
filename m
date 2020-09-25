Return-Path: <SRS0=MO2u=DC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7C4FC4346E
	for <mm-commits@archiver.kernel.org>; Fri, 25 Sep 2020 02:55:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74FAE21481
	for <mm-commits@archiver.kernel.org>; Fri, 25 Sep 2020 02:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601002514;
	bh=0928Hhr5r6owJMddPtDvkbl+1+QDEdLcZfjl7WYRLQ0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=IWK0S53gr6E6PryvIqvPc5n+wBXhpauqxVAEFehSSvCQRBJGryWxOohV8GL1sg/Yu
	 weYPkCZ2osSRhJrQef0XwQPFRDGT8pkCzzXC+/+4ttzrOfNdfsnDwfm7lcEEPrCrOL
	 04pbXhmW6mOrVxUqRdSFOZxRhs5ZI5xXl4ocwucY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgIYCzO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Sep 2020 22:55:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbgIYCzM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Sep 2020 22:55:12 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B64CF20888;
        Fri, 25 Sep 2020 02:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601002512;
        bh=0928Hhr5r6owJMddPtDvkbl+1+QDEdLcZfjl7WYRLQ0=;
        h=Date:From:To:Subject:From;
        b=jo+jmzkHJ0fOlqMOrygd3ca+n5585dxq1CbQ47vj1QFqaX8qTXLDNDYTbzQwhcey4
         MdEBKGsZxNmn2cYM3gtVjCiJHvK5hqB0E8aq1T4NLPcdrCKzOiAEZ191H8JQ07XM++
         QB1UopOW85OJISh9zjh7Rz+6FzfvezOvdhvcWMfI=
Date:   Thu, 24 Sep 2020 19:55:11 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mchehab+huawei@kernel.org,
        krzk@kernel.org, corbet@lwn.net, kernel@cdqe.de
Subject:  +
 lib-crc32c-fix-trivial-typo-in-preprocessor-condition.patch added to -mm tree
Message-ID: <20200925025511.iPPZO%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/crc32.c: fix trivial typo in preprocessor condition
has been added to the -mm tree.  Its filename is
     lib-crc32c-fix-trivial-typo-in-preprocessor-condition.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-crc32c-fix-trivial-typo-in-preprocessor-condition.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-crc32c-fix-trivial-typo-in-preprocessor-condition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from kernel@cdqe.de are

lib-crc32c-fix-trivial-typo-in-preprocessor-condition.patch

