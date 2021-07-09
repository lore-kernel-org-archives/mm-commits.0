Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88DAEC07E9C
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 23:55:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C84D613AF
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 23:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhGIX6G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 19:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229854AbhGIX6G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 19:58:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2E44613C2;
        Fri,  9 Jul 2021 23:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625874921;
        bh=RKwrKrqtncu3K+Z0ilRrq5vq9X8g69Vk1Y6sbJxJvYk=;
        h=Date:From:To:Subject:From;
        b=LZ5KHiTc2MAgzCJvMpxfQxwXcNl3d/L2e6a1PZGHyzFua0G2cGo559mTatNKOLQ/I
         w+diqhMme92a4OzYj++FN4w3QAhffM2BLXAAaLpG1BlEpvA+04f0PLHYSVIt8AmFHh
         Y9GMrY/Rv6xe0p5R122rVgp7wx0dxYDSdGDEzSA4=
Date:   Fri, 09 Jul 2021 16:55:21 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, konishi.ryusuke@gmail.com,
        sunnanyong@huawei.com
Subject:  + nilfs2-fix-null-pointer-in-nilfs_name_attr_release.patch
 added to -mm tree
Message-ID: <20210709235521.3mODJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix NULL pointer in nilfs_##name##_attr_release
has been added to the -mm tree.  Its filename is
     nilfs2-fix-null-pointer-in-nilfs_name_attr_release.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/nilfs2-fix-null-pointer-in-nilfs_name_attr_release.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-fix-null-pointer-in-nilfs_name_attr_release.patch

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
Subject: nilfs2: fix NULL pointer in nilfs_##name##_attr_release

In nilfs_##name##_attr_release, kobj->parent should not be referenced
because it is a NULL pointer.  The release() method of kobject is always
called in kobject_put(kobj), in the implementation of kobject_put(), the
kobj->parent will be assigned as NULL before call the release() method. 
So just use kobj to get the subgroups, which is more efficient and can fix
a NULL pointer reference problem.

Link: https://lkml.kernel.org/r/20210629022556.3985106-3-sunnanyong@huawei.com
Link: https://lkml.kernel.org/r/1625651306-10829-3-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sysfs.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/fs/nilfs2/sysfs.c~nilfs2-fix-null-pointer-in-nilfs_name_attr_release
+++ a/fs/nilfs2/sysfs.c
@@ -51,11 +51,9 @@ static const struct sysfs_ops nilfs_##na
 #define NILFS_DEV_INT_GROUP_TYPE(name, parent_name) \
 static void nilfs_##name##_attr_release(struct kobject *kobj) \
 { \
-	struct nilfs_sysfs_##parent_name##_subgroups *subgroups; \
-	struct the_nilfs *nilfs = container_of(kobj->parent, \
-						struct the_nilfs, \
-						ns_##parent_name##_kobj); \
-	subgroups = nilfs->ns_##parent_name##_subgroups; \
+	struct nilfs_sysfs_##parent_name##_subgroups *subgroups = container_of(kobj, \
+						struct nilfs_sysfs_##parent_name##_subgroups, \
+						sg_##name##_kobj); \
 	complete(&subgroups->sg_##name##_kobj_unregister); \
 } \
 static struct kobj_type nilfs_##name##_ktype = { \
_

Patches currently in -mm which might be from sunnanyong@huawei.com are

nilfs2-fix-memory-leak-in-nilfs_sysfs_create_device_group.patch
nilfs2-fix-null-pointer-in-nilfs_name_attr_release.patch
nilfs2-fix-memory-leak-in-nilfs_sysfs_create_name_group.patch
nilfs2-fix-memory-leak-in-nilfs_sysfs_delete_name_group.patch
nilfs2-fix-memory-leak-in-nilfs_sysfs_create_snapshot_group.patch
nilfs2-fix-memory-leak-in-nilfs_sysfs_delete_snapshot_group.patch

