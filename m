Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CF5CC07E99
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 23:55:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 353DC613BE
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 23:55:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhGIX6M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 19:58:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229854AbhGIX6M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 19:58:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85322613AF;
        Fri,  9 Jul 2021 23:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625874927;
        bh=QJHtfb6Vf2md/HOQnp7H+77rdaSFXnCFz2qV42oH/hw=;
        h=Date:From:To:Subject:From;
        b=GjF5x02RYbyJgJx/WIYg6CH5lsKXmZiP1fF7oSdVOGBQkaDNH5eQc9QXrnzuxFAZI
         ADvu3u+CLccsP563Qu9ZYz4PnTZ7FcRoAK6jIgXGA0OJlVBWVFrTuOQ49NPUF4CTgF
         FKnOxOXDAG/D9Cy6KvpXFxEweok23aQSW05mvjXE=
Date:   Fri, 09 Jul 2021 16:55:27 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, konishi.ryusuke@gmail.com,
        sunnanyong@huawei.com
Subject:  +
 nilfs2-fix-memory-leak-in-nilfs_sysfs_create_snapshot_group.patch added to
 -mm tree
Message-ID: <20210709235527.s6Pb3%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix memory leak in nilfs_sysfs_create_snapshot_group
has been added to the -mm tree.  Its filename is
     nilfs2-fix-memory-leak-in-nilfs_sysfs_create_snapshot_group.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/nilfs2-fix-memory-leak-in-nilfs_sysfs_create_snapshot_group.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-fix-memory-leak-in-nilfs_sysfs_create_snapshot_group.patch

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

nilfs2-fix-memory-leak-in-nilfs_sysfs_create_device_group.patch
nilfs2-fix-null-pointer-in-nilfs_name_attr_release.patch
nilfs2-fix-memory-leak-in-nilfs_sysfs_create_name_group.patch
nilfs2-fix-memory-leak-in-nilfs_sysfs_delete_name_group.patch
nilfs2-fix-memory-leak-in-nilfs_sysfs_create_snapshot_group.patch
nilfs2-fix-memory-leak-in-nilfs_sysfs_delete_snapshot_group.patch

