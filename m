Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1E9FC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C149611C3
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347624AbhIIVGx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348310AbhIIVGW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:06:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 840A9611AF;
        Thu,  9 Sep 2021 21:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221512;
        bh=cDuUDYDXoEHvbT87BZz3HYdcVkoa0/caRZPmdz+rhQU=;
        h=Date:From:To:Subject:From;
        b=f4d2K2OT3uOOzTccNN4awNOhLNunlYqF593LdE9EzqfxCVcabLkrd1NJ7SX/RlZ6E
         DwGoB7aJTjh6m2LM+Zb8/sdwlgx7Vh40YT9Hkx58s8vusgEChBmrDHxIcOxl0O2rJL
         pUIHOeJjAigeBx/cufAs0ktpZe9oUP2FZbT7FVpE=
Date:   Thu, 09 Sep 2021 14:05:12 -0700
From:   akpm@linux-foundation.org
To:     konishi.ryusuke@gmail.com, mm-commits@vger.kernel.org,
        sunnanyong@huawei.com
Subject:  [merged]
 nilfs2-fix-memory-leak-in-nilfs_sysfs_delete_snapshot_group.patch removed
 from -mm tree
Message-ID: <20210909210512.UdF3C2cPG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix memory leak in nilfs_sysfs_delete_snapshot_group
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-memory-leak-in-nilfs_sysfs_delete_snapshot_group.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nanyong Sun <sunnanyong@huawei.com>
Subject: nilfs2: fix memory leak in nilfs_sysfs_delete_snapshot_group

kobject_put() should be used to cleanup the memory associated with the
kobject instead of kobject_del().  See the section "Kobject removal" of
"Documentation/core-api/kobject.rst".

Link: https://lkml.kernel.org/r/20210629022556.3985106-7-sunnanyong@huawei.com
Link: https://lkml.kernel.org/r/1625651306-10829-7-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nilfs2/sysfs.c~nilfs2-fix-memory-leak-in-nilfs_sysfs_delete_snapshot_group
+++ a/fs/nilfs2/sysfs.c
@@ -202,7 +202,7 @@ int nilfs_sysfs_create_snapshot_group(st
 
 void nilfs_sysfs_delete_snapshot_group(struct nilfs_root *root)
 {
-	kobject_del(&root->snapshot_kobj);
+	kobject_put(&root->snapshot_kobj);
 }
 
 /************************************************************************
_

Patches currently in -mm which might be from sunnanyong@huawei.com are


