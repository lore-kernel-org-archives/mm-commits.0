Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 378E7C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E082223436
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgLPRLm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:11:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:32944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726855AbgLPRLm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:11:42 -0500
Date:   Wed, 16 Dec 2020 09:11:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138661;
        bh=y/9/pTXUP9Bes85Nv5clNmmobi5z1BptwJl2R/EOjQs=;
        h=From:To:Subject:From;
        b=ZFkebqrjwQ9wn4+yx2O/DeJ59SDCRob4dKsemPVTh9xX2A3hWfbSfDEfvCQoFQkeW
         TmIbpEMMdVXmXTBm30KO4iWG6sLXhhu+NTmqAkpJGhAdSiOj8AGZP2sdQoPmKpiH1G
         MLvDS4jhlNkBk3ecVlaVL9i4IGxfV0Pv0S/zG2BQ=
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, hch@lst.de, jani.nikula@intel.com,
        kvalo@codeaurora.org, mm-commits@vger.kernel.org
Subject:  [merged] ath10k-make-relay-callbacks-const.patch removed
 from -mm tree
Message-ID: <20201216171101.lyFI44VVt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ath10k: make relay callbacks const
has been removed from the -mm tree.  Its filename was
     ath10k-make-relay-callbacks-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jani Nikula <jani.nikula@intel.com>
Subject: ath10k: make relay callbacks const

Now that relay_open() accepts const callbacks, make relay callbacks const.

Link: https://lkml.kernel.org/r/85cabc6d4b0d0ca43d4e0fb94897ccd16e3b7930.1606153547.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Acked-by: Kalle Valo <kvalo@codeaurora.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath/ath10k/spectral.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath10k/spectral.c~ath10k-make-relay-callbacks-const
+++ a/drivers/net/wireless/ath/ath10k/spectral.c
@@ -497,7 +497,7 @@ static int remove_buf_file_handler(struc
 	return 0;
 }
 
-static struct rchan_callbacks rfs_spec_scan_cb = {
+static const struct rchan_callbacks rfs_spec_scan_cb = {
 	.create_buf_file = create_buf_file_handler,
 	.remove_buf_file = remove_buf_file_handler,
 };
_

Patches currently in -mm which might be from jani.nikula@intel.com are


