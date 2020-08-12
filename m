Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7042C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF9BB2078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266330;
	bh=vB4+a/mp+0stl4ymBhzLV4hFYXstqdOsSvh1WnLak/w=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=IzAjeHfhQZagICiZfon6QFmdBpi4tzlCIyE85OO/xNYlefTxEU+lA/WhWtz2uTpaO
	 5zXVtM/e/d1FD77EArizK0T0aM5GRlqdCmpnM9N9+DU0JFAgTweM6UhwuXemLrNeqP
	 1rICwxn3PbzCyKRY2degTSyU0q3j05nJbL8bqPVU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgHLVFa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:05:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726573AbgHLVFa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:05:30 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82DA52078B;
        Wed, 12 Aug 2020 21:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266329;
        bh=vB4+a/mp+0stl4ymBhzLV4hFYXstqdOsSvh1WnLak/w=;
        h=Date:From:To:Subject:From;
        b=ITcqVhl3g3yHoPh7V/xXoK86Ge0HYpx2aV20/yjNLS9ThzGKSth7sgN3+pZBfHdzY
         LYHC2s8ZWMRZ/+fEEeugNWFNrXQCnafiQchRmHOX+EtvmJ7OUUOqTcEj2s/IJm9yiL
         3tOJN2kKl0j/1S7D7CvvAkIfpeomnlENjqS8PY8Y=
Date:   Wed, 12 Aug 2020 14:05:29 -0700
From:   akpm@linux-foundation.org
To:     alex.bou9@gmail.com, gustavoars@kernel.org,
        mm-commits@vger.kernel.org, mporter@kernel.crashing.org
Subject:  [merged] rapidio-use-struct_size-helper.patch removed
 from -mm tree
Message-ID: <20200812210529.VE7sm1vk2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rapidio/rio-scan.c: use struct_size() helper
has been removed from the -mm tree.  Its filename was
     rapidio-use-struct_size-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from gustavoars@kernel.org are


