Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F99C07E99
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 23:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11F19613AF
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 23:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbhGIX6I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 19:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229854AbhGIX6I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 19:58:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89851613C8;
        Fri,  9 Jul 2021 23:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625874923;
        bh=j/vi99vyG9j6QO9MJrLQaeoxH7M+gCgBSaifpcmHTmc=;
        h=Date:From:To:Subject:From;
        b=SYXsOPdcRhFsBy8CRA9WbB5gR2kq+Bsm5pFcES7erbo60Ku7temXWUQUl52SSMKt2
         49PN8EoaJ6LBcOGjyQsyEplVbQUqwCKTfGJUPTVQeI3TixI++pseinDKTqw/3jzxQr
         HLRyAFu6pS68mMf5ykpzl0wKQXoK4IEHHUIpL830=
Date:   Fri, 09 Jul 2021 16:55:23 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, konishi.ryusuke@gmail.com,
        sunnanyong@huawei.com
Subject:  +
 nilfs2-fix-memory-leak-in-nilfs_sysfs_create_name_group.patch added to -mm
 tree
Message-ID: <20210709235523.3yIyL%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix memory leak in nilfs_sysfs_create_##name##_group
has been added to the -mm tree.  Its filename is
     nilfs2-fix-memory-leak-in-nilfs_sysfs_create_name_group.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/nilfs2-fix-memory-leak-in-nilfs_sysfs_create_name_group.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-fix-memory-leak-in-nilfs_sysfs_create_name_group.patch

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
Subject: nilfs2: fix memory leak in nilfs_sysfs_create_##name##_group

If kobject_init_and_add return with error, kobject_put() is needed here to
avoid memory leak, because kobject_init_and_add may return error without
freeing the memory associated with the kobject it allocated.

Link: https://lkml.kernel.org/r/20210629022556.3985106-4-sunnanyong@huawei.com
Link: https://lkml.kernel.org/r/1625651306-10829-4-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/sysfs.c~nilfs2-fix-memory-leak-in-nilfs_sysfs_create_name_group
+++ a/fs/nilfs2/sysfs.c
@@ -79,8 +79,8 @@ static int nilfs_sysfs_create_##name##_g
 	err = kobject_init_and_add(kobj, &nilfs_##name##_ktype, parent, \
 				    #name); \
 	if (err) \
-		return err; \
-	return 0; \
+		kobject_put(kobj); \
+	return err; \
 } \
 static void nilfs_sysfs_delete_##name##_group(struct the_nilfs *nilfs) \
 { \
_

Patches currently in -mm which might be from sunnanyong@huawei.com are

nilfs2-fix-memory-leak-in-nilfs_sysfs_create_device_group.patch
nilfs2-fix-null-pointer-in-nilfs_name_attr_release.patch
nilfs2-fix-memory-leak-in-nilfs_sysfs_create_name_group.patch
nilfs2-fix-memory-leak-in-nilfs_sysfs_delete_name_group.patch
nilfs2-fix-memory-leak-in-nilfs_sysfs_create_snapshot_group.patch
nilfs2-fix-memory-leak-in-nilfs_sysfs_delete_snapshot_group.patch

