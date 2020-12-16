Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EAA4C0018C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFF4C2333F
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgLPEqX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:46:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:50676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbgLPEqX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:46:23 -0500
Date:   Tue, 15 Dec 2020 20:46:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093968;
        bh=y69S9a/TTUaX5w3p7W9CK0RkJtunPlKUrSM6y+oa94o=;
        h=From:To:Subject:In-Reply-To:From;
        b=D+rq73xw53bJnNM5+uyNdkZFwhxSiCAjxtl5Wuinw9h4HOrb/UmH0ITNAw6TT8nRf
         TifIqsymDrWY5JB1Eq8sDrvGv94ACszgp2Jozg4zqTRfQY5poeuRLmeFY+AlAKYuau
         z8TtJrQ+kRbJdEy+XEJP37i+0LqxTySFppJMX79w=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, hch@lst.de,
        jani.nikula@intel.com, kvalo@codeaurora.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 70/95] ath11k: make relay callbacks const
Message-ID: <20201216044606.9qYPUf-n8%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jani Nikula <jani.nikula@intel.com>
Subject: ath11k: make relay callbacks const

Now that relay_open() accepts const callbacks, make relay callbacks
const.

Link: https://lkml.kernel.org/r/44e3d65b71025c462948d0c554061dc7b40ab488.1606153547.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Acked-by: Kalle Valo <kvalo@codeaurora.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath/ath11k/spectral.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath11k/spectral.c~ath11k-make-relay-callbacks-const
+++ a/drivers/net/wireless/ath/ath11k/spectral.c
@@ -148,7 +148,7 @@ static int remove_buf_file_handler(struc
 	return 0;
 }
 
-static struct rchan_callbacks rfs_scan_cb = {
+static const struct rchan_callbacks rfs_scan_cb = {
 	.create_buf_file = create_buf_file_handler,
 	.remove_buf_file = remove_buf_file_handler,
 };
_
