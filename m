Return-Path: <SRS0=iiPm=C7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C150C2D0E2
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:09:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E11CE23A9C
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600794551;
	bh=P9Pz0ES1gbNaLqaMZB0IQuGtSRMSePYjNZGlkXWsGcU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=2FApotH1eqMRLmoaLUyn+UFF1RcvelEoWtjd2zAwV1PcLRZszd+CMp5HZYTwF3F2r
	 gjmNP0MnSymYocHW0sgXK/dSoHtop878FDGoFbFhk2GRlYIplV+zIrrRDQMkDSaive
	 SzjZ66DZsyhxewYfPis1CWzI77tHjc0FfWB9v41o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgIVRJL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Sep 2020 13:09:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbgIVRJL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Sep 2020 13:09:11 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63983207C3;
        Tue, 22 Sep 2020 17:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600794550;
        bh=P9Pz0ES1gbNaLqaMZB0IQuGtSRMSePYjNZGlkXWsGcU=;
        h=Date:From:To:Subject:From;
        b=wFdFltQ/xcw6La7WYLxSkrD/1ViNi/YYjbK7+eonpzX1CvwO0ucNuZIm+lQe9lpWq
         L+w8kBAzj2eZzzDEOWYQRFWvVhW3LfmOCV/o3uc5qyLhv1viMcedWYziUB5oZlIDtb
         PNnyr+4AamOx8ptnqNklMq4soPsktvLWVzZizmFs=
Date:   Tue, 22 Sep 2020 10:09:09 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mporter@kernel.crashing.org,
        madhuparnabhowmik10@gmail.com, keescook@chromium.org,
        jhubbard@nvidia.com, gustavoars@kernel.org,
        dan.carpenter@oracle.com, alex.bou9@gmail.com,
        jingxiangfeng@huawei.com
Subject:  +
 rapidio-fix-the-missed-put_device-for-rio_mport_add_riodev.patch added to -mm
 tree
Message-ID: <20200922170909.XIrR5%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: fix the missed put_device() for rio_mport_add_riodev
has been added to the -mm tree.  Its filename is
     rapidio-fix-the-missed-put_device-for-rio_mport_add_riodev.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/rapidio-fix-the-missed-put_device-for-rio_mport_add_riodev.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/rapidio-fix-the-missed-put_device-for-rio_mport_add_riodev.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from jingxiangfeng@huawei.com are

rapidio-fix-the-missed-put_device-for-rio_mport_add_riodev.patch

