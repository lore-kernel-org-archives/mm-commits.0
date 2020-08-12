Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9068BC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 674D720658
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196205;
	bh=ph4RPS8TfukOflvfx1w3cfe927xmLjn8ezrP3AsRG/8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=1ZMbb2vL8KwL6JLKKcV9HeKAtU75OKEYjpDfzGfppF0gaEekfG2w0/JHAJDFJZ0gs
	 YCe49RyQ82lwiafxTWyEUv0FniH61celdgbqDw+1Hd9lVOasfiyhNVxbMA781lG6pY
	 60z+AJgEdFxojowHlZwpMye60b2HBf+jQWRubuts=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgHLBgp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:36:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbgHLBgo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:36:44 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0516207DA;
        Wed, 12 Aug 2020 01:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196204;
        bh=ph4RPS8TfukOflvfx1w3cfe927xmLjn8ezrP3AsRG/8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=j+OB/MDMP2l+TcpPoW22/etUgfIPjdTbs14b9heYZdhxWXy/MqMJ/gmavQ0iQUaJ5
         xgl+wkXC9CLs7Uz0pg2ObUTlK5jYz8nlWi1nvyAT8/p6PrRGkaUAmbSkEsJ7td81mi
         BSwp2XjlqtWUV6JVerq/HcKvIn+vw5VtnmdaR4c4=
Date:   Tue, 11 Aug 2020 18:36:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.bou9@gmail.com,
        gustavoars@kernel.org, keescook@chromium.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, mporter@kernel.crashing.org,
        torvalds@linux-foundation.org
Subject:  [patch 122/165] rapidio/rio_mport_cdev: use array_size()
 helper in copy_{from,to}_user()
Message-ID: <20200812013643.tCcuuhMQy%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
