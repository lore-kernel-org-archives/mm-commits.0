Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2711C001B2
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 03:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbiLLDbm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 22:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbiLLDb3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 22:31:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB96DE95
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 19:31:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CDE660EAC
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 03:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77A9C433D2;
        Mon, 12 Dec 2022 03:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670815880;
        bh=wpGc42DLgKf61/AkN0IbNIwj+QO+AwZwOCacq1iqrlU=;
        h=Date:To:From:Subject:From;
        b=WfRPAt/VMvCzX7QTgy7kHaXckF2IOQOuwLoTOyvHNpNjwjwwkDzjA91rBZQ3ppyyA
         hz7isfJ7j3+EJzj4/65WMw0jSoTa+1h2QBEMhNVSCy4DGqXz6JK5zuIyLbxHE/k6bz
         n3uFbxUGBwcPFsZ2v8tD7Thvq1TokAL5ztwDdoX0=
Date:   Sun, 11 Dec 2022 19:31:19 -0800
To:     mm-commits@vger.kernel.org, yangyingliang@huawei.com,
        wangweiyang2@huawei.com, mporter@kernel.crashing.org,
        jhubbard@nvidia.com, jakobkoschel@gmail.com, error27@gmail.com,
        alex.bou9@gmail.com, caixinchen1@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] rapidio-devices-fix-missing-put_device-in-mport_cdev_open.patch removed from -mm tree
Message-Id: <20221212033120.A77A9C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: rapidio: devices: fix missing put_device in mport_cdev_open
has been removed from the -mm tree.  Its filename was
     rapidio-devices-fix-missing-put_device-in-mport_cdev_open.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Cai Xinchen <caixinchen1@huawei.com>
Subject: rapidio: devices: fix missing put_device in mport_cdev_open
Date: Sat, 3 Dec 2022 08:57:21 +0000

When kfifo_alloc fails, the refcount of chdev->dev is left incremental. 
We should use put_device(&chdev->dev) to decrease the ref count of
chdev->dev to avoid refcount leak.

Link: https://lkml.kernel.org/r/20221203085721.13146-1-caixinchen1@huawei.com
Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Jakob Koschel <jakobkoschel@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Wang Weiyang <wangweiyang2@huawei.com>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-devices-fix-missing-put_device-in-mport_cdev_open
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -1912,6 +1912,7 @@ static int mport_cdev_open(struct inode
 			  sizeof(struct rio_event) * MPORT_EVENT_DEPTH,
 			  GFP_KERNEL);
 	if (ret < 0) {
+		put_device(&chdev->dev);
 		dev_err(&chdev->dev, DRV_NAME ": kfifo_alloc failed\n");
 		ret = -ENOMEM;
 		goto err_fifo;
_

Patches currently in -mm which might be from caixinchen1@huawei.com are


