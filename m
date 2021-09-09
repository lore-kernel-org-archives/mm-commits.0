Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63648C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D02F611EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347964AbhIIVGq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:06:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346632AbhIIVGQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:06:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86BAD611B0;
        Thu,  9 Sep 2021 21:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221506;
        bh=PNmOVtjSxCIg5qewq/3h0ArPRR1Qcz4X15kEhUswmSk=;
        h=Date:From:To:Subject:From;
        b=2RakEYsmBVl89S/ZoCOo/bybVp0PbqahgxOp/ojIGV1o6XJH/Qjbh4EsKC3iEXfmB
         QB69aMxTdhPv4eUA3607J9Ws1m9GAniwZ3+jrpvJtwK3E65e8qkOjGeAnGvEnHBpsk
         UejVdaHIGDCzjoh5ORseGdMAQl63Luuq4AGVi6BE=
Date:   Thu, 09 Sep 2021 14:05:06 -0700
From:   akpm@linux-foundation.org
To:     konishi.ryusuke@gmail.com, mm-commits@vger.kernel.org,
        sunnanyong@huawei.com
Subject:  [merged]
 nilfs2-fix-memory-leak-in-nilfs_sysfs_create_name_group.patch removed from
 -mm tree
Message-ID: <20210909210506.-BPFDwzQU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix memory leak in nilfs_sysfs_create_##name##_group
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-memory-leak-in-nilfs_sysfs_create_name_group.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


