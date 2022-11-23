Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6581C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 23 Nov 2022 19:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbiKWTph (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Nov 2022 14:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233560AbiKWTpg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Nov 2022 14:45:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 245A39373D
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 11:45:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B27D861DB3
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 19:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FDCC433C1;
        Wed, 23 Nov 2022 19:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669232735;
        bh=mqjXEH0cnk8NqznMkmuj9GYZ4hbpraykwzvPxIYUpxc=;
        h=Date:To:From:Subject:From;
        b=oEpmp63dyzCXxU7bcHIMFbULTjWezjBvhkszCJJhy0NmmmKwJSJ0AROO2UsckJN3l
         TvW8S3t8mRP8rdE3MUQJOMveFG5VWGmAwsylcOf91A38G+Civ1EYdYrqcQ1x+jz/t+
         5H2phi+UuLNvpnSp+P7QJM0oOu0k/q/wLD32z4Io=
Date:   Wed, 23 Nov 2022 11:45:34 -0800
To:     mm-commits@vger.kernel.org, yangyingliang@huawei.com,
        mporter@kernel.crashing.org, jhubbard@nvidia.com,
        jakobkoschel@gmail.com, error27@gmail.com, alex.bou9@gmail.com,
        wangweiyang2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + rapidio-fix-possible-uaf-when-kfifo_alloc-fails.patch added to mm-nonmm-unstable branch
Message-Id: <20221123194535.09FDCC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: fix possible UAF when kfifo_alloc() fails
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rapidio-fix-possible-uaf-when-kfifo_alloc-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rapidio-fix-possible-uaf-when-kfifo_alloc-fails.patch

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
From: Wang Weiyang <wangweiyang2@huawei.com>
Subject: rapidio: fix possible UAF when kfifo_alloc() fails
Date: Wed, 23 Nov 2022 17:51:47 +0800

If kfifo_alloc() fails in mport_cdev_open(), goto err_fifo and just free
priv. But priv is still in the chdev->file_list, then list traversal
may cause UAF. This fixes the following smatch warning:

drivers/rapidio/devices/rio_mport_cdev.c:1930 mport_cdev_open() warn: '&priv->list' not removed from list

Link: https://lkml.kernel.org/r/20221123095147.52408-1-wangweiyang2@huawei.com
Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Signed-off-by: Wang Weiyang <wangweiyang2@huawei.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Jakob Koschel <jakobkoschel@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-fix-possible-uaf-when-kfifo_alloc-fails
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -1904,10 +1904,6 @@ static int mport_cdev_open(struct inode
 
 	priv->md = chdev;
 
-	mutex_lock(&chdev->file_mutex);
-	list_add_tail(&priv->list, &chdev->file_list);
-	mutex_unlock(&chdev->file_mutex);
-
 	INIT_LIST_HEAD(&priv->db_filters);
 	INIT_LIST_HEAD(&priv->pw_filters);
 	spin_lock_init(&priv->fifo_lock);
@@ -1926,6 +1922,9 @@ static int mport_cdev_open(struct inode
 	spin_lock_init(&priv->req_lock);
 	mutex_init(&priv->dma_lock);
 #endif
+	mutex_lock(&chdev->file_mutex);
+	list_add_tail(&priv->list, &chdev->file_list);
+	mutex_unlock(&chdev->file_mutex);
 
 	filp->private_data = priv;
 	goto out;
_

Patches currently in -mm which might be from wangweiyang2@huawei.com are

rapidio-fix-possible-uaf-when-kfifo_alloc-fails.patch

