Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E31C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C563611C1
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347610AbhIIVGx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348295AbhIIVGU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:06:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82D9561179;
        Thu,  9 Sep 2021 21:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221510;
        bh=HejpHLFO9e9WoneHWIDWDrSviZB3d8ezGS2t0JuyNi8=;
        h=Date:From:To:Subject:From;
        b=q0VyNNU56KQaL0Wtc4b5m3jGcuO3gPDQKzYYJW0Wcou/4uk2BExpXRY0HMJOMK7FI
         2NApnRme6uzxpAGzM4BLxIXurxuo3DagJxKd2oXYaPfncu281JHR8yClnIOL/+4lNg
         6LMEx0WlJsVKa0/5zf5qKbvOzMoyu8zbNR9fq78E=
Date:   Thu, 09 Sep 2021 14:05:10 -0700
From:   akpm@linux-foundation.org
To:     konishi.ryusuke@gmail.com, mm-commits@vger.kernel.org,
        sunnanyong@huawei.com
Subject:  [merged]
 nilfs2-fix-memory-leak-in-nilfs_sysfs_create_snapshot_group.patch removed
 from -mm tree
Message-ID: <20210909210510.BA6BDqkGe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix memory leak in nilfs_sysfs_create_snapshot_group
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-memory-leak-in-nilfs_sysfs_create_snapshot_group.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nanyong Sun <sunnanyong@huawei.com>
Subject: nilfs2: fix memory leak in nilfs_sysfs_create_snapshot_group

If kobject_init_and_add returns with error, kobject_put() is needed here
to avoid memory leak, because kobject_init_and_add may return error
without freeing the memory associated with the kobject it allocated.

Link: https://lkml.kernel.org/r/20210629022556.3985106-6-sunnanyong@huawei.com
Link: https://lkml.kernel.org/r/1625651306-10829-6-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/sysfs.c~nilfs2-fix-memory-leak-in-nilfs_sysfs_create_snapshot_group
+++ a/fs/nilfs2/sysfs.c
@@ -195,9 +195,9 @@ int nilfs_sysfs_create_snapshot_group(st
 	}
 
 	if (err)
-		return err;
+		kobject_put(&root->snapshot_kobj);
 
-	return 0;
+	return err;
 }
 
 void nilfs_sysfs_delete_snapshot_group(struct nilfs_root *root)
_

Patches currently in -mm which might be from sunnanyong@huawei.com are


