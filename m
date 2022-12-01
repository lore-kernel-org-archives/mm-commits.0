Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74039C47088
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiLAARZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiLAARC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:17:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235A09896D
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:14:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD8CE61941
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86CCC433D6;
        Thu,  1 Dec 2022 00:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669853638;
        bh=3ZqTFGMZcKHsz4grU+QWs4VH5M/BuyFVnmV2vWTq2KA=;
        h=Date:To:From:Subject:From;
        b=MHpz0q8g6Cg6184mVhnyOQRX/FiyVuDktFBZyjqheLIu4Dtyk2YPiD1lKPTM63YNf
         dnXMw6k0qIir3mHi+d2cyfPmjOHeNt1BKA5BGzlFY3oEvWB0eBnj+iMY6MCeFsEHyk
         8banpYud5JKYh9UuSCKBSO3EBwyBUuHCRZhz6ji4=
Date:   Wed, 30 Nov 2022 16:13:58 -0800
To:     mm-commits@vger.kernel.org, mporter@kernel.crashing.org,
        alex.bou9@gmail.com, yangyingliang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] rapidio-fix-possible-name-leaks-when-rio_add_device-fails.patch removed from -mm tree
Message-Id: <20221201001358.D86CCC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: rapidio: fix possible name leaks when rio_add_device() fails
has been removed from the -mm tree.  Its filename was
     rapidio-fix-possible-name-leaks-when-rio_add_device-fails.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Yingliang <yangyingliang@huawei.com>
Subject: rapidio: fix possible name leaks when rio_add_device() fails
Date: Mon, 14 Nov 2022 23:26:35 +0800

Patch series "rapidio: fix three possible memory leaks".

This patchset fixes three name leaks in error handling.
 - patch #1 fixes two name leaks while rio_add_device() fails.
 - patch #2 fixes a name leak while  rio_register_mport() fails.


This patch (of 2):

If rio_add_device() returns error, the name allocated by dev_set_name()
need be freed.  It should use put_device() to give up the reference in the
error path, so that the name can be freed in kobject_cleanup(), and the
'rdev' can be freed in rio_release_dev().

Link: https://lkml.kernel.org/r/20221114152636.2939035-1-yangyingliang@huawei.com
Link: https://lkml.kernel.org/r/20221114152636.2939035-2-yangyingliang@huawei.com
Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Fixes: 1fa5ae857bb1 ("driver core: get rid of struct device's bus_id string array")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |    7 +++++--
 drivers/rapidio/rio-scan.c               |    8 ++++++--
 2 files changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-fix-possible-name-leaks-when-rio_add_device-fails
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -1804,8 +1804,11 @@ static int rio_mport_add_riodev(struct m
 		rio_init_dbell_res(&rdev->riores[RIO_DOORBELL_RESOURCE],
 				   0, 0xffff);
 	err = rio_add_device(rdev);
-	if (err)
-		goto cleanup;
+	if (err) {
+		put_device(&rdev->dev);
+		return err;
+	}
+
 	rio_dev_get(rdev);
 
 	return 0;
--- a/drivers/rapidio/rio-scan.c~rapidio-fix-possible-name-leaks-when-rio_add_device-fails
+++ a/drivers/rapidio/rio-scan.c
@@ -454,8 +454,12 @@ static struct rio_dev *rio_setup_device(
 				   0, 0xffff);
 
 	ret = rio_add_device(rdev);
-	if (ret)
-		goto cleanup;
+	if (ret) {
+		if (rswitch)
+			kfree(rswitch->route_table);
+		put_device(&rdev->dev);
+		return NULL;
+	}
 
 	rio_dev_get(rdev);
 
_

Patches currently in -mm which might be from yangyingliang@huawei.com are


