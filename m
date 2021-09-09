Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7A37C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9680D611C9
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346550AbhIIVGr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:06:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346128AbhIIVGO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:06:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8964B6109F;
        Thu,  9 Sep 2021 21:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221504;
        bh=TBqXRn72nqYTPplZbucWwNnWg7Mvj6x4rauszAmoOrY=;
        h=Date:From:To:Subject:From;
        b=IyVyrLx663B4J5AjphXirNYJRgpO7qQTUo9T7URNhEbLhpJ1t6pgkA13UnsovmOzL
         A9XpHoBikFOp3LiBo4CvOsH3T/ScG1LCQm00aJx8gAElZzmeKzN6kbFv8pOF6/lxPI
         CLuM7inpO0iiLeyZ7ZrV2jmvSdaaFkir5xoX5vJo=
Date:   Thu, 09 Sep 2021 14:05:04 -0700
From:   akpm@linux-foundation.org
To:     konishi.ryusuke@gmail.com, mm-commits@vger.kernel.org,
        sunnanyong@huawei.com
Subject:  [merged]
 nilfs2-fix-null-pointer-in-nilfs_name_attr_release.patch removed from -mm
 tree
Message-ID: <20210909210504.zKiIEv7Xl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix NULL pointer in nilfs_##name##_attr_release
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-null-pointer-in-nilfs_name_attr_release.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


