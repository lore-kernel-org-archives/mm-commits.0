Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A65C07E99
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 23:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46B21613AF
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 23:55:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbhGIX6O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 19:58:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229854AbhGIX6O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 19:58:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83414613BE;
        Fri,  9 Jul 2021 23:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625874929;
        bh=1ue9uijYclU9YxfAxJkPCyHZMM+B+Pqp/+rxg503Y4M=;
        h=Date:From:To:Subject:From;
        b=ud4olx48BDdJuIzbhs+09lTqlBUTv1WDwF68cPuyFXw2nuDp/U0AkV9Rw+HA0AwfG
         x4Mro73kcq49Lp+VljyoqouxkJOu2WXj4Wc18dqtkH68SwnulDGeEIOLZ1cq8E/ewY
         y/3jhDOe2cbXGr+hZn7b8DITDg3wpgMgh0x/7gWc=
Date:   Fri, 09 Jul 2021 16:55:29 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, konishi.ryusuke@gmail.com,
        sunnanyong@huawei.com
Subject:  +
 nilfs2-fix-memory-leak-in-nilfs_sysfs_delete_snapshot_group.patch added to
 -mm tree
Message-ID: <20210709235529.Cw7th%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix memory leak in nilfs_sysfs_delete_snapshot_group
has been added to the -mm tree.  Its filename is
     nilfs2-fix-memory-leak-in-nilfs_sysfs_delete_snapshot_group.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/nilfs2-fix-memory-leak-in-nilfs_sysfs_delete_snapshot_group.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-fix-memory-leak-in-nilfs_sysfs_delete_snapshot_group.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

nilfs2-fix-memory-leak-in-nilfs_sysfs_create_device_group.patch
nilfs2-fix-null-pointer-in-nilfs_name_attr_release.patch
nilfs2-fix-memory-leak-in-nilfs_sysfs_create_name_group.patch
nilfs2-fix-memory-leak-in-nilfs_sysfs_delete_name_group.patch
nilfs2-fix-memory-leak-in-nilfs_sysfs_create_snapshot_group.patch
nilfs2-fix-memory-leak-in-nilfs_sysfs_delete_snapshot_group.patch

