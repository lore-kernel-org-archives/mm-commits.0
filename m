Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6419EC4321E
	for <mm-commits@archiver.kernel.org>; Mon,  5 Dec 2022 21:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiLEV3q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Dec 2022 16:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiLEV3m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Dec 2022 16:29:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548DC28E16
        for <mm-commits@vger.kernel.org>; Mon,  5 Dec 2022 13:29:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0608BB81262
        for <mm-commits@vger.kernel.org>; Mon,  5 Dec 2022 21:29:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91584C433D6;
        Mon,  5 Dec 2022 21:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670275776;
        bh=ZyWx11j/DvxkkGPBAJkAA+sqbDZZQDdyo4wAylzVnDI=;
        h=Date:To:From:Subject:From;
        b=o/7rPr1PvRA4sbFVl4RPl0OZ/YF2autIQXTZLpi8+/V3+2paYsQLLRaW1VuvzNTiE
         3fiVNvXL2yFjXDdUjxCYVhu1hcMsLdGicsp/eC11BQtFT+QZK28CPrQ54xvfQD1ZlV
         Ah/4YDMghslJJd580PFGHWx/q8xxip7P7uJa3l3I=
Date:   Mon, 05 Dec 2022 13:29:35 -0800
To:     mm-commits@vger.kernel.org, yangyingliang@huawei.com,
        wangweiyang2@huawei.com, mporter@kernel.crashing.org,
        jhubbard@nvidia.com, jakobkoschel@gmail.com, error27@gmail.com,
        alex.bou9@gmail.com, caixinchen1@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + rapidio-devices-fix-missing-put_device-in-mport_cdev_open.patch added to mm-nonmm-unstable branch
Message-Id: <20221205212936.91584C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: devices: fix missing put_device in mport_cdev_open
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rapidio-devices-fix-missing-put_device-in-mport_cdev_open.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rapidio-devices-fix-missing-put_device-in-mport_cdev_open.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

rapidio-devices-fix-missing-put_device-in-mport_cdev_open.patch

