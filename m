Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86780C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4003020658
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196202;
	bh=yFDuguL2mEIHtTiYBxEYdk0/tp6+SdlMRYLyBQy3QpY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=PUiyOYECTngQl9sxPoJ8XXguzCW1ringLtMwan1zheDsxEPEoTLNKyx4Nf9sJTrLH
	 9AKEf/zHM6XL535/G2sBljn6KY5wb1RskMsuPevExJZO+h/xHeNiMZOoKTxF5OpsuK
	 jnRSD+AvN6Kwr2nIrIrYFDVa0drMSzsXxZwk146M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgHLBgm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:36:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbgHLBgl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:36:41 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE45A2076C;
        Wed, 12 Aug 2020 01:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196201;
        bh=yFDuguL2mEIHtTiYBxEYdk0/tp6+SdlMRYLyBQy3QpY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=to+9+LZXEbEDYW++rMRyprahA+qz8CPjchoVL5NXo1/mdCUOkv1m4D8HGRAyYhS9z
         +zToBTHP0K39spa7RduzbaFzNVw98k8atcfMcmR12aYlMz7ZQse1gW4OGRkGK7HBnY
         aRzL7T1R7pAzK6ChI7Xc7dKKX5AM4CtE3GAX7ID0=
Date:   Tue, 11 Aug 2020 18:36:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.bou9@gmail.com,
        gustavoars@kernel.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, mporter@kernel.crashing.org,
        torvalds@linux-foundation.org
Subject:  [patch 121/165] drivers/rapidio/rio-scan.c: use
 struct_size() helper
Message-ID: <20200812013640.6i0R9Swhe%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: drivers/rapidio/rio-scan.c: use struct_size() helper

Make use of the struct_size() helper instead of an open-coded version in
order to avoid any potential type mistakes.

Also, while there, use the preferred form for passing a size of a struct. 
The alternative form where struct name is spelled out hurts readability
and introduces an opportunity for a bug when the pointer variable type is
changed but the corresponding sizeof that is passed as argument is not.

This issue was found with the help of Coccinelle and, audited and fixed
manually.

Addresses KSPP ID: https://github.com/KSPP/linux/issues/83

Link: http://lkml.kernel.org/r/20200619170445.GA22641@embeddedor
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/rapidio/rio-scan.c~rapidio-use-struct_size-helper
+++ a/drivers/rapidio/rio-scan.c
@@ -330,7 +330,7 @@ static struct rio_dev *rio_setup_device(
 	size_t size;
 	u32 swpinfo = 0;
 
-	size = sizeof(struct rio_dev);
+	size = sizeof(*rdev);
 	if (rio_mport_read_config_32(port, destid, hopcount,
 				     RIO_PEF_CAR, &result))
 		return NULL;
@@ -338,10 +338,8 @@ static struct rio_dev *rio_setup_device(
 	if (result & (RIO_PEF_SWITCH | RIO_PEF_MULTIPORT)) {
 		rio_mport_read_config_32(port, destid, hopcount,
 					 RIO_SWP_INFO_CAR, &swpinfo);
-		if (result & RIO_PEF_SWITCH) {
-			size += (RIO_GET_TOTAL_PORTS(swpinfo) *
-				sizeof(rswitch->nextdev[0])) + sizeof(*rswitch);
-		}
+		if (result & RIO_PEF_SWITCH)
+			size += struct_size(rswitch, nextdev, RIO_GET_TOTAL_PORTS(swpinfo));
 	}
 
 	rdev = kzalloc(size, GFP_KERNEL);
_
