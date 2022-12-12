Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DCFDC001B2
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 03:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiLLDbM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 22:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbiLLDbK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 22:31:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448CED136
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 19:31:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D32F760ED7
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 03:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328A1C43392;
        Mon, 12 Dec 2022 03:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670815868;
        bh=R4Je0aDPcbTJK38yUTl+WOqFEikinrlxDzd1R+e7G0Y=;
        h=Date:To:From:Subject:From;
        b=YkV3CzTb3AWt1fAgIydbjPsEjcFbW7zKIo0QmFOFjYA2z6pTzyB+LxAmDAl3xJh74
         LkAQCYxmRRQXWpD9ahk1m+O9RnA6PjXrMRf8c5EIhn2jKqblpu2hc8NmL8SEc8UQY7
         WCSmdTxFv4SCWwi+1//os/crvv3nJ2TFhy4qdIfA=
Date:   Sun, 11 Dec 2022 19:31:07 -0800
To:     mm-commits@vger.kernel.org, yangyingliang@huawei.com,
        mporter@kernel.crashing.org, jhubbard@nvidia.com,
        jakobkoschel@gmail.com, error27@gmail.com, alex.bou9@gmail.com,
        wangweiyang2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] rapidio-fix-possible-uaf-when-kfifo_alloc-fails.patch removed from -mm tree
Message-Id: <20221212033108.328A1C43392@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: rapidio: fix possible UAF when kfifo_alloc() fails
has been removed from the -mm tree.  Its filename was
     rapidio-fix-possible-uaf-when-kfifo_alloc-fails.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


