Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51192C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AEA461468
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238442AbhGABw6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:52:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238384AbhGABw6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:52:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36C3F6105A;
        Thu,  1 Jul 2021 01:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104228;
        bh=pUNghmS3UghhRIbrzL3KTLY8WvTwvWERnFSE/dvBWbY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lvTlrjZlu83aCpxLHWiVTgvMRILS6sdL4YojRZ86xdZjZuFyMtlB3fuDRWAafLjfW
         BiseYcKapK3HCC8i6jGRILaPBz2JuX1jeXFDqqy3XxTDB5/npS7yaQEu4GnuzDqwV5
         dJhmh2u1qhGVoiXTAP2WrneBAcLmoXvAA5OIfa9U=
Date:   Wed, 30 Jun 2021 18:50:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hdanton@sina.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vitaly.wool@konsulko.com
Subject:  [patch 061/192] mm/z3fold: avoid possible underflow in
 z3fold_alloc()
Message-ID: <20210701015027.60S0CzrHj%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/z3fold: avoid possible underflow in z3fold_alloc()

It is not enough to just make sure the z3fold header is not larger than
the page size.  When z3fold header is equal to PAGE_SIZE, we would
underflow when check alloc size against PAGE_SIZE - ZHDR_SIZE_ALIGNED -
CHUNK_SIZE in z3fold_alloc().  Make sure there has remaining spaces for
its buddy to fix this theoretical issue.

Link: https://lkml.kernel.org/r/20210619093151.1492174-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-avoid-possible-underflow-in-z3fold_alloc
+++ a/mm/z3fold.c
@@ -1803,8 +1803,11 @@ static int __init init_z3fold(void)
 {
 	int ret;
 
-	/* Make sure the z3fold header is not larger than the page size */
-	BUILD_BUG_ON(ZHDR_SIZE_ALIGNED > PAGE_SIZE);
+	/*
+	 * Make sure the z3fold header is not larger than the page size and
+	 * there has remaining spaces for its buddy.
+	 */
+	BUILD_BUG_ON(ZHDR_SIZE_ALIGNED > PAGE_SIZE - CHUNK_SIZE);
 	ret = z3fold_mount();
 	if (ret)
 		return ret;
_
