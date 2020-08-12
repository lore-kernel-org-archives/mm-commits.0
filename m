Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17705C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2B6D2078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266333;
	bh=vnQFVH1YHyUneQqlLhaTsiidFqx/rhanuHKtQt/eiNU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=n2Tl9RdD24PvkHLAXIRcFVIhptOH8WWBkEQ8+3C+TFQpI5L6vGhqEWqKopwNtImSO
	 uS/n3HBt1wGXxjo1cMZkI+lbsH5dS2cTBFt+rVRrWa0anw7j3wY00i6UEGZ4lcjibW
	 GsR9E3aGlRuMJRpxa3tM1pqy/DPBw+pWscXMnfrQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgHLVFd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:05:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726564AbgHLVFd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:05:33 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 848E42078B;
        Wed, 12 Aug 2020 21:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266331;
        bh=vnQFVH1YHyUneQqlLhaTsiidFqx/rhanuHKtQt/eiNU=;
        h=Date:From:To:Subject:From;
        b=ZaB2jlgMtRvKFp5H1KMnvlccEphR6VWTefTnmgzjD/GOdEQRgiapBX2RFKcLj4laV
         +7gI163eP6048RMyRz39rYehL35CkzpNdbRK7hr1C8CoJfEUU2pjCC01s8lZILtrOO
         6w3EBrw+Cs94a9rtNtlERcYfP0lHrzwmKa1OhWi8=
Date:   Wed, 12 Aug 2020 14:05:31 -0700
From:   akpm@linux-foundation.org
To:     alex.bou9@gmail.com, gustavoars@kernel.org, keescook@chromium.org,
        mm-commits@vger.kernel.org, mporter@kernel.crashing.org
Subject:  [merged]
 rapidio-rio_mport_cdev-use-array_size-helper-in-copy_fromto_user.patch
 removed from -mm tree
Message-ID: <20200812210531.vmU7aE6Z5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/rio_mport_cdev: use array_size() helper in copy_{from,to}_user()
has been removed from the -mm tree.  Its filename was
     rapidio-rio_mport_cdev-use-array_size-helper-in-copy_fromto_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: rapidio/rio_mport_cdev: use array_size() helper in copy_{from,to}_user()

Use array_size() helper instead of the open-coded version in
copy_{from,to}_user().  These sorts of multiplication factors need to be
wrapped in array_size().

This issue was found with the help of Coccinelle and, audited and fixed
manually.

Addresses-KSPP-ID: https://github.com/KSPP/linux/issues/83
Link: http://lkml.kernel.org/r/20200616183050.GA31840@embeddedor
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-rio_mport_cdev-use-array_size-helper-in-copy_fromto_user
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -981,7 +981,7 @@ static int rio_mport_transfer_ioctl(stru
 
 	if (unlikely(copy_from_user(transfer,
 				    (void __user *)(uintptr_t)transaction.block,
-				    transaction.count * sizeof(*transfer)))) {
+				    array_size(sizeof(*transfer), transaction.count)))) {
 		ret = -EFAULT;
 		goto out_free;
 	}
@@ -994,7 +994,7 @@ static int rio_mport_transfer_ioctl(stru
 
 	if (unlikely(copy_to_user((void __user *)(uintptr_t)transaction.block,
 				  transfer,
-				  transaction.count * sizeof(*transfer))))
+				  array_size(sizeof(*transfer), transaction.count))))
 		ret = -EFAULT;
 
 out_free:
_

Patches currently in -mm which might be from gustavoars@kernel.org are


