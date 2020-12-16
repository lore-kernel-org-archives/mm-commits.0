Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04A66C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B001C23436
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgLPRLp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:11:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:32968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726855AbgLPRLp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:11:45 -0500
Date:   Wed, 16 Dec 2020 09:11:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138664;
        bh=COLsiqPvk7gLoohqMZOjzP/lLfoIZo6OzF4aVlsbaJY=;
        h=From:To:Subject:From;
        b=nZRx1Zei08+DZckS3/ajpyRfT2l5pRHa/qNXm7yZLp0xZKRbJCaiFiCuOSM8/wxZs
         tOrY9/cxFHhDoRcDm7FGHkUDTZn8ZswpHxrFNsj9PGcif9HW81IOpxnxKPGgXftomW
         10Thhv3Q01UIO3ZYnDVmCBm3CGi0D4u8Y56ACtZk=
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, hch@lst.de, jani.nikula@intel.com,
        kvalo@codeaurora.org, mm-commits@vger.kernel.org
Subject:  [merged] ath11k-make-relay-callbacks-const.patch removed
 from -mm tree
Message-ID: <20201216171104.njib0Djw3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ath11k: make relay callbacks const
has been removed from the -mm tree.  Its filename was
     ath11k-make-relay-callbacks-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from jani.nikula@intel.com are


