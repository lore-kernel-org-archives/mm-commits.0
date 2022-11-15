Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49453C43217
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 00:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236787AbiKOAGj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Nov 2022 19:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234078AbiKOAGe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2022 19:06:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36482DF65
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2022 16:06:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B379D614DC
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 00:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4E7C433D7;
        Tue, 15 Nov 2022 00:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668470792;
        bh=1Nk3tRFRoDohMKhkI5X/mXMsAl3m5qlLWlGlf7P9Xjc=;
        h=Date:To:From:Subject:From;
        b=H6Kh8VL7UOEd+eOe5FfEjSZFrcUV29SFkkgFQ6/rDJKP2n8eNOP+ftXDyrTGnl1r4
         T0+iVeopPL1j5Pm1DVdMLn29NVRMxMR3B83xFBMl500SlRxdgcDvMI7L75mFl9T1+v
         5FHQBwmLK88Iwfp45iLVamin2C7AnyHFmows+YlE=
Date:   Mon, 14 Nov 2022 16:06:31 -0800
To:     mm-commits@vger.kernel.org, mporter@kernel.crashing.org,
        alex.bou9@gmail.com, yangyingliang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + rapidio-rio-fix-possible-name-leak-in-rio_register_mport.patch added to mm-nonmm-unstable branch
Message-Id: <20221115000632.0A4E7C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: rio: fix possible name leak in rio_register_mport()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rapidio-rio-fix-possible-name-leak-in-rio_register_mport.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rapidio-rio-fix-possible-name-leak-in-rio_register_mport.patch

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
Subject: rapidio: rio: fix possible name leak in rio_register_mport()
Date: Mon, 14 Nov 2022 23:26:36 +0800

If device_register() returns error, the name allocated by dev_set_name()
need be freed.  It should use put_device() to give up the reference in the
error path, so that the name can be freed in kobject_cleanup(), and
list_del() is called to delete the port from rio_mports.

Link: https://lkml.kernel.org/r/20221114152636.2939035-3-yangyingliang@huawei.com
Fixes: 2aaf308b95b2 ("rapidio: rework device hierarchy and introduce mport class of devices")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/rapidio/rio.c~rapidio-rio-fix-possible-name-leak-in-rio_register_mport
+++ a/drivers/rapidio/rio.c
@@ -2186,11 +2186,16 @@ int rio_register_mport(struct rio_mport
 	atomic_set(&port->state, RIO_DEVICE_RUNNING);
 
 	res = device_register(&port->dev);
-	if (res)
+	if (res) {
 		dev_err(&port->dev, "RIO: mport%d registration failed ERR=%d\n",
 			port->id, res);
-	else
+		mutex_lock(&rio_mport_list_lock);
+		list_del(&port->node);
+		mutex_unlock(&rio_mport_list_lock);
+		put_device(&port->dev);
+	} else {
 		dev_dbg(&port->dev, "RIO: registered mport%d\n", port->id);
+	}
 
 	return res;
 }
_

Patches currently in -mm which might be from yangyingliang@huawei.com are

rapidio-fix-possible-name-leaks-when-rio_add_device-fails.patch
rapidio-rio-fix-possible-name-leak-in-rio_register_mport.patch

