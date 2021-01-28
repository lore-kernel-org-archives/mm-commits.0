Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9EB9C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 20:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95D4B64DE5
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 20:50:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhA1UuI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Jan 2021 15:50:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:55346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229646AbhA1Utv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 28 Jan 2021 15:49:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBAE364DD6;
        Thu, 28 Jan 2021 20:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611866951;
        bh=pRhF+mFV+bLodVKfuvualC0XZx/WrnSz0Cnp5enRmvw=;
        h=Date:From:To:Subject:From;
        b=kIYE+0y4jZjyLnx31GEoNIBQXBI3ndRaPiu28UPTQrDMK6x2fRZ08ctzTI7bDu05a
         oBdRLW4qzJp2rpCcv5cPFPAdeaA+Q8IZdhbNx3ks+ggSynZyJQMTybHabS+w3GHXVo
         tUZSEcqaAsUzpXJtGje3jOtNmbL4z+nasHHRGWc8=
Date:   Thu, 28 Jan 2021 12:49:10 -0800
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, ddstreet@ieee.org,
        mm-commits@vger.kernel.org, sjenning@redhat.com,
        tiantao6@hisilicon.com, vitaly.wool@konsulko.com
Subject:  + mm-zswap-add-the-flag-can_sleep_mapped-fix-3.patch
 added to -mm tree
Message-ID: <20210128204910.mTposZmxP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap: fix potential uninitialized pointer read on tmp
has been added to the -mm tree.  Its filename is
     mm-zswap-add-the-flag-can_sleep_mapped-fix-3.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-zswap-add-the-flag-can_sleep_mapped-fix-3.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-zswap-add-the-flag-can_sleep_mapped-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: mm/zswap: fix potential uninitialized pointer read on tmp

In the case where zpool_can_sleep_mapped(pool) returns 0 then tmp is not
allocated and tmp is then an uninitialized pointer.  Later if entry is
null, tmp is freed, hence free'ing an uninitialized pointer.  Fix this by
ensuring tmp is initialized to NULL.

Link: https://lkml.kernel.org/r/20210128141728.639030-1-colin.king@canonical.com
Addresses-Coverity: ("Uninitialized pointer read")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Tian Tao <tiantao6@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-add-the-flag-can_sleep_mapped-fix-3
+++ a/mm/zswap.c
@@ -935,7 +935,7 @@ static int zswap_writeback_entry(struct
 	struct scatterlist input, output;
 	struct crypto_acomp_ctx *acomp_ctx;
 
-	u8 *src, *tmp;
+	u8 *src, *tmp = NULL;
 	unsigned int dlen;
 	int ret;
 	struct writeback_control wbc = {
_

Patches currently in -mm which might be from colin.king@canonical.com are

mm-zswap-add-the-flag-can_sleep_mapped-fix-3.patch

