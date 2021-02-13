Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8101C433E6
	for <mm-commits@archiver.kernel.org>; Sat, 13 Feb 2021 04:41:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8C5664E64
	for <mm-commits@archiver.kernel.org>; Sat, 13 Feb 2021 04:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhBMEle (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Feb 2021 23:41:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:48146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229718AbhBMEld (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Feb 2021 23:41:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8BAC64E9A;
        Sat, 13 Feb 2021 04:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613191252;
        bh=E9yw/P/K82z6Vc0z8wrgG900gvXmXFHctwi0lTNbTyo=;
        h=Date:From:To:Subject:From;
        b=PHItmIuEZLRxDtlfUCBTOsak6/+xg0GotPYR9UaMY2gFxm84bWU+cjJNk9KQBvEEl
         KTYi4xCZS5dqCJU0OWGOYMH8PWjf2r8I3ONUOauKEGisE3ZzZ8jX8WjDJ1pBpr5iwp
         i1f5kfN+h3wrAzWY+SlfcXWa5mI5v8U2eKjuiCEM=
Date:   Fri, 12 Feb 2021 20:40:50 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        tiantao6@hisilicon.com, sjenning@redhat.com, ddstreet@ieee.org,
        colin.king@canonical.com
Subject:  [folded-merged]
 mm-zswap-add-the-flag-can_sleep_mapped-fix-3.patch removed from -mm tree
Message-ID: <20210213044050.ORhTs%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap: fix potential uninitialized pointer read on tmp
has been removed from the -mm tree.  Its filename was
     mm-zswap-add-the-flag-can_sleep_mapped-fix-3.patch

This patch was dropped because it was folded into mm-zswap-add-the-flag-can_sleep_mapped.patch

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

scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch
mm-zswap-add-the-flag-can_sleep_mapped.patch

