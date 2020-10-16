Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E1DAC43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0941820E65
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816617;
	bh=9Ihgxfa92KwEg88URGFcOCSc9mej9RQlS17RWBSxU5o=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=NsXi4cm3R+67LbOcFPkcGURxUlGaFUX+kOVaIC7u7u/YO+WbqB/4y+GaqTFOPWCwK
	 eA65gRhkFSiCXyBC2M3oKlkJNMJTlzxtiwk8N93iJSigIalczBpRMO+dmD0BBiUiPn
	 2SQJJF+mxowwBIv0nbq1g7NlNi8wmHfeT2pVQFA4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404384AbgJPCuQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:50:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404125AbgJPCuQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:50:16 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 110FA20897;
        Fri, 16 Oct 2020 02:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816615;
        bh=9Ihgxfa92KwEg88URGFcOCSc9mej9RQlS17RWBSxU5o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=g34D3NufnbA5XULn/yazoeF3uzGIZSsCNL4gAsJzPDzNqYiwKSKukz4tRttuKl3a6
         oPtiLXIN5z1uXxMxo+5GrwFQCTYArzxSGt9XoVwTsIqGFLW4JhwqMGdnBKWbRrccUU
         cJXWDpmB087hzjTi0gCg1OEAHp+0CGWwBF/tIeiI=
Date:   Thu, 15 Oct 2020 19:50:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.bou9@gmail.com,
        dan.carpenter@oracle.com, gustavoars@kernel.org,
        jhubbard@nvidia.com, jingxiangfeng@huawei.com,
        keescook@chromium.org, linux-mm@kvack.org,
        madhuparnabhowmik10@gmail.com, mm-commits@vger.kernel.org,
        mporter@kernel.crashing.org, torvalds@linux-foundation.org
Subject:  [patch 147/156] rapidio: fix the missed put_device() for
 rio_mport_add_riodev
Message-ID: <20201016025014.cEd4qRYt0%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>
Subject: rapidio: fix the missed put_device() for rio_mport_add_riodev

rio_mport_add_riodev() misses to call put_device() when the device already
exists.  Add the missed function call to fix it.

Link: https://lkml.kernel.org/r/20200922072525.42330-1-jingxiangfeng@huawei.com
Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-fix-the-missed-put_device-for-rio_mport_add_riodev
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -1680,6 +1680,7 @@ static int rio_mport_add_riodev(struct m
 	struct rio_dev *rdev;
 	struct rio_switch *rswitch = NULL;
 	struct rio_mport *mport;
+	struct device *dev;
 	size_t size;
 	u32 rval;
 	u32 swpinfo = 0;
@@ -1694,8 +1695,10 @@ static int rio_mport_add_riodev(struct m
 	rmcd_debug(RDEV, "name:%s ct:0x%x did:0x%x hc:0x%x", dev_info.name,
 		   dev_info.comptag, dev_info.destid, dev_info.hopcount);
 
-	if (bus_find_device_by_name(&rio_bus_type, NULL, dev_info.name)) {
+	dev = bus_find_device_by_name(&rio_bus_type, NULL, dev_info.name);
+	if (dev) {
 		rmcd_debug(RDEV, "device %s already exists", dev_info.name);
+		put_device(dev);
 		return -EEXIST;
 	}
 
_
