Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74A11C636F8
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiLAAR0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiLAARC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:17:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7929894E
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:14:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F21A761977
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:14:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D97C433C1;
        Thu,  1 Dec 2022 00:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669853640;
        bh=CKwMowhkoeyWhZVWKkbByt1z8+tiovjM6g73D1RwuLU=;
        h=Date:To:From:Subject:From;
        b=fKUHs7FQgqP2fyZbqb60j40tFKNlK8g0J/jzggWRDKrVbXJgL0gwKQ7ZkQyl2UjzW
         NL//5+s0/Y7oqj+s49SMbJCOsLXzIvDWjAwJ8aTQanLjfVx3cIoKnfn5wbb55C9eE9
         uvV9AUXnN7SXKeATLGSp1V2uk/tnyxscyEJ2qtRA=
Date:   Wed, 30 Nov 2022 16:13:59 -0800
To:     mm-commits@vger.kernel.org, mporter@kernel.crashing.org,
        alex.bou9@gmail.com, yangyingliang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] rapidio-rio-fix-possible-name-leak-in-rio_register_mport.patch removed from -mm tree
Message-Id: <20221201001400.15D97C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: rapidio: rio: fix possible name leak in rio_register_mport()
has been removed from the -mm tree.  Its filename was
     rapidio-rio-fix-possible-name-leak-in-rio_register_mport.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


