Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80F19C43217
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 03:00:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6816A61153
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 03:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347049AbhIHDBi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 23:01:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347430AbhIHDB0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 23:01:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79DE36113C;
        Wed,  8 Sep 2021 03:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631070018;
        bh=oQvRTNRC1cyL8RRAYy11Trs/uOHMKn3GA/M6eAhSCrM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eTesoEuycNwS1sdsWf1ki+d1ElNMW4xyh/CHyzujJhGydPEgY0RHwV2xUSsekx7lF
         BLZuEttl7q7Zj6pPn6XLYBBygyrn2GENcYYhSqLqBvp3vyiIeXlrR2xVGiw1ZlMkMl
         hPT8P1IHlmt9+TBJWAcMZSg7ugKO51X9qDrGYmIE=
Date:   Tue, 07 Sep 2021 20:00:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, konishi.ryusuke@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        sunnanyong@huawei.com, torvalds@linux-foundation.org
Subject:  [patch 133/147] nilfs2: fix memory leak in
 nilfs_sysfs_delete_##name##_group
Message-ID: <20210908030018.F8eJq8J8y%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
