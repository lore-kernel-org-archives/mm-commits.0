Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F813C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8D932087C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266298;
	bh=m8IedPhWY4mTv0NH4fvBm/TaNWcTKvupFCb5egiSFQY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=IN6Zg5DgQFUZTGHsEJdIP+mEhvW880gq7sZEtwRu8RxPAnok6d5S9fh+1gNi8SbHs
	 9fQMqNTmz4zzJYMnXQwuwS09CagpxKTFokIYG8wiA7pmzZkwa2aC/4uHrz8/d0degQ
	 mqeWUu/kTWi9NCpZ86hy3ixCOaK+G5U35z1A1gM8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgHLVE6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:04:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726709AbgHLVE6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:04:58 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 711F9207F7;
        Wed, 12 Aug 2020 21:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266296;
        bh=m8IedPhWY4mTv0NH4fvBm/TaNWcTKvupFCb5egiSFQY=;
        h=Date:From:To:Subject:From;
        b=EUYs/y/vCtLZUASRVmdyFabX+t5uq+XcSX8U20apF5luI91iB9N4OKaOwecH/77Oq
         dlSW+v9xJfcZ/6qJasPXEy3jT9FvQ/5gto3a0czUURNrUBOf9ogI5VQT4UNoLtaZ/S
         lKCxvbqVoox0SS9JDS9ZtNYxFg0E2rLNdtUpQIOA=
Date:   Wed, 12 Aug 2020 14:04:56 -0700
From:   akpm@linux-foundation.org
To:     fengyubo3@huawei.com, hirofumi@mail.parknet.co.jp,
        mm-commits@vger.kernel.org
Subject:  [merged]
 fatfs-switch-write_lock-to-read_lock-in-fat_ioctl_get_attributes.patch
 removed from -mm tree
Message-ID: <20200812210456.Uq59NG9EW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fatfs: switch write_lock to read_lock in fat_ioctl_get_attributes
has been removed from the -mm tree.  Its filename was
     fatfs-switch-write_lock-to-read_lock-in-fat_ioctl_get_attributes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yubo Feng <fengyubo3@huawei.com>
Subject: fatfs: switch write_lock to read_lock in fat_ioctl_get_attributes

There is no need to hold write_lock in fat_ioctl_get_attributes. 
write_lock may make an impact on concurrency of fat_ioctl_get_attributes.

Link: http://lkml.kernel.org/r/1593308053-12702-1-git-send-email-fengyubo3@huawei.com
Signed-off-by: Yubo Feng <fengyubo3@huawei.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/fat/file.c~fatfs-switch-write_lock-to-read_lock-in-fat_ioctl_get_attributes
+++ a/fs/fat/file.c
@@ -25,9 +25,9 @@ static int fat_ioctl_get_attributes(stru
 {
 	u32 attr;
 
-	inode_lock(inode);
+	inode_lock_shared(inode);
 	attr = fat_make_attrs(inode);
-	inode_unlock(inode);
+	inode_unlock_shared(inode);
 
 	return put_user(attr, user_attr);
 }
_

Patches currently in -mm which might be from fengyubo3@huawei.com are


