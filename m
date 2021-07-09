Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91EF7C07E9C
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 23:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A492613AF
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 23:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhGIX6K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 19:58:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229854AbhGIX6J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 19:58:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83752613C2;
        Fri,  9 Jul 2021 23:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625874925;
        bh=qrp5xHIGx+aHYnONoYOdQru1BLuilPTQBJz/39PB1RA=;
        h=Date:From:To:Subject:From;
        b=nA37/jNaVxOKAt/lr5I0humb4/G6r/CBD+bBYZpBAzExiGEfikq+gkmlgHXzgxGA0
         BBXAmab4rAspZWrKGFP0Gxi+g+r7Ny3WNdjovCFPf2rMDfrpLXTjkVt+JiwrCWBWLq
         X0t/YrVB+fVGkRikMIbl2yk30O0S3GRm/DEl4pmw=
Date:   Fri, 09 Jul 2021 16:55:25 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, konishi.ryusuke@gmail.com,
        sunnanyong@huawei.com
Subject:  +
 nilfs2-fix-memory-leak-in-nilfs_sysfs_delete_name_group.patch added to -mm
 tree
Message-ID: <20210709235525.4sJVn%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix memory leak in nilfs_sysfs_delete_##name##_group
has been added to the -mm tree.  Its filename is
     nilfs2-fix-memory-leak-in-nilfs_sysfs_delete_name_group.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/nilfs2-fix-memory-leak-in-nilfs_sysfs_delete_name_group.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-fix-memory-leak-in-nilfs_sysfs_delete_name_group.patch

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
Subject: nilfs2: fix memory leak in nilfs_sysfs_delete_##name##_group

The kobject_put() should be used to cleanup the memory associated with the
kobject instead of kobject_del.  See the section "Kobject removal" of
"Documentation/core-api/kobject.rst".

Link: https://lkml.kernel.org/r/20210629022556.3985106-5-sunnanyong@huawei.com
Link: https://lkml.kernel.org/r/1625651306-10829-5-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nilfs2/sysfs.c~nilfs2-fix-memory-leak-in-nilfs_sysfs_delete_name_group
+++ a/fs/nilfs2/sysfs.c
@@ -84,7 +84,7 @@ static int nilfs_sysfs_create_##name##_g
 } \
 static void nilfs_sysfs_delete_##name##_group(struct the_nilfs *nilfs) \
 { \
-	kobject_del(&nilfs->ns_##parent_name##_subgroups->sg_##name##_kobj); \
+	kobject_put(&nilfs->ns_##parent_name##_subgroups->sg_##name##_kobj); \
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

