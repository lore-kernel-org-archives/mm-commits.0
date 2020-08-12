Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FD19C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 300282078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266329;
	bh=ukxpV5eEHOBnefB87NlrYqolpGp6PGMBdLjbKnhWGM0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=oAE7kp8Y57CGiN7LJ2Y1P5LrdJE5MVtKjnlKbRwwXZPywH7awbNsfbotql3gMqNFY
	 m55l5d4KuZlOlhQu1pbUoje2Z9+FAznwEkarmzGvaR8ZmHYKdxkltDwkbFtFmeZCMs
	 HHC8KaFVeH12Gg+OA1r0DRd7r6/agTEpJcah7vyc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgHLVF2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:05:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgHLVF2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:05:28 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8065720774;
        Wed, 12 Aug 2020 21:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266327;
        bh=ukxpV5eEHOBnefB87NlrYqolpGp6PGMBdLjbKnhWGM0=;
        h=Date:From:To:Subject:From;
        b=wr2ybteolgVuhmUvPGZhqqKTCV8vkYgZYOH4dTezhc2nrwsk821vv+rLfTN+L9HQX
         4xyvkoQzMFUkWvfZFYSlAyn0uXTmTqIpWbW6xuok+iHGSdwVa1uVS0pCPhfbo1s4R2
         wrKm5ppsg1HX+80AtoFjQqL6LBrovADpup/p+290=
Date:   Wed, 12 Aug 2020 14:05:27 -0700
From:   akpm@linux-foundation.org
To:     alex.bou9@gmail.com, gustavoars@kernel.org,
        mm-commits@vger.kernel.org, mporter@kernel.crashing.org
Subject:  [merged]
 rapidio-rio_mport_cdev-use-struct_size-helper.patch removed from -mm tree
Message-ID: <20200812210527.XAH_RPyTg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rapidio/devices/rio_mport_cdev.c: use struct_size() helper
has been removed from the -mm tree.  Its filename was
     rapidio-rio_mport_cdev-use-struct_size-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: drivers/rapidio/devices/rio_mport_cdev.c: use struct_size() helper

Make use of the struct_size() helper instead of an open-coded version in
order to avoid any potential type mistakes.

This issue was found with the help of Coccinelle and, audited and fixed
manually.

Addresses KSPP ID: https://github.com/KSPP/linux/issues/83

Link: http://lkml.kernel.org/r/20200619170843.GA24923@embeddedor
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-rio_mport_cdev-use-struct_size-helper
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -1710,8 +1710,7 @@ static int rio_mport_add_riodev(struct m
 	if (rval & RIO_PEF_SWITCH) {
 		rio_mport_read_config_32(mport, destid, hopcount,
 					 RIO_SWP_INFO_CAR, &swpinfo);
-		size += (RIO_GET_TOTAL_PORTS(swpinfo) *
-			 sizeof(rswitch->nextdev[0])) + sizeof(*rswitch);
+		size += struct_size(rswitch, nextdev, RIO_GET_TOTAL_PORTS(swpinfo));
 	}
 
 	rdev = kzalloc(size, GFP_KERNEL);
_

Patches currently in -mm which might be from gustavoars@kernel.org are


