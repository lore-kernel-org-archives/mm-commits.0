Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBEDCC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 00:06:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236505AbiKOAGi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Nov 2022 19:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiKOAGd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2022 19:06:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F95C752
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2022 16:06:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1F66B810A6
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 00:06:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C13C433D7;
        Tue, 15 Nov 2022 00:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668470789;
        bh=4D2JVHdLkIiZD40qPKfTSk3N3ROam67O0ZIzZWIzsMI=;
        h=Date:To:From:Subject:From;
        b=capVQWq7XPxSJdrmrpfsdMX3fUa5oML7i7SAp8oO4Npe9tR57PUUIOEWvtYd4Mkkh
         bNj4hH/jHi4Q+KILy+MIi13bZDpSFsfhYwhyMO+xCWa7nHj0KInTexwzAsdee2Azdo
         gRKCdEMww5yMKjN85+/ObMhcTZxe/x66k4PeiuqM=
Date:   Mon, 14 Nov 2022 16:06:28 -0800
To:     mm-commits@vger.kernel.org, mporter@kernel.crashing.org,
        alex.bou9@gmail.com, yangyingliang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + rapidio-fix-possible-name-leaks-when-rio_add_device-fails.patch added to mm-nonmm-unstable branch
Message-Id: <20221115000629.92C13C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: fix possible name leaks when rio_add_device() fails
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rapidio-fix-possible-name-leaks-when-rio_add_device-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rapidio-fix-possible-name-leaks-when-rio_add_device-fails.patch

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

rapidio-fix-possible-name-leaks-when-rio_add_device-fails.patch
rapidio-rio-fix-possible-name-leak-in-rio_register_mport.patch

