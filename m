Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99120C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FF3720658
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196198;
	bh=EfI1aC9GZtfQHd/AWvSRBxul9CQpQEAB4LLcFqe573Y=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=JNgpu3wj28GGz6BCs9egk3TbX0XsOjNzquI1Ky7T1ZCBDT/3gJWsCALwJIM23b7yt
	 7VdSzLsjrSfDqwuxbAU/bE3sWvmOcIw/9Y8yzhRniGZrOxFOM6plwUouhHjdoCStgA
	 693uyXuAXxAwCFzZ1mwZRQftz94e5U+RXN7gbtps=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgHLBgi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:36:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBgi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:36:38 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 609E22076C;
        Wed, 12 Aug 2020 01:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196197;
        bh=EfI1aC9GZtfQHd/AWvSRBxul9CQpQEAB4LLcFqe573Y=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ehJeueY9geWMa4DRKq9kczNxRGAJKS5VFvYVPDeoHJRn/Y3jARsxpY6ZSnFe+OpkC
         bh9Zp3xep8q2D3YyUmkfZxLRd459yEOte7h+whrQ3MWFuuLw4kmw5B4NyLCLp7S4UV
         6EPkid4Z+cGReky2onWkTH3h/UGFVFdCkPRGJYMc=
Date:   Tue, 11 Aug 2020 18:36:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.bou9@gmail.com,
        gustavoars@kernel.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, mporter@kernel.crashing.org,
        torvalds@linux-foundation.org
Subject:  [patch 120/165] drivers/rapidio/devices/rio_mport_cdev.c:
 use struct_size() helper
Message-ID: <20200812013637.mOmVK2_ld%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
