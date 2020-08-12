Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F832C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:35:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8002B20658
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196157;
	bh=L3A9BOBdX907+FYbNRPAAp1VSqAriS3H/L6o5riRNnI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=KNJjbnASj3znPmCKgO0J61dTbXLZz/AasyYVGlxiqGhdz5CW4ovB1wZ75c2bEnv+a
	 3QMHIa80ynGHznW7O/FqpXDeZpaUgQYQVgnOV5NldFkQzKPgedyU7W6i2wwwKWgThQ
	 BYPeQL9RXv4yKHK8hwuJ3t0i8TkNPjEyz2r526r8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgHLBf5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:35:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBf5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:35:57 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86FFF206B2;
        Wed, 12 Aug 2020 01:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196156;
        bh=L3A9BOBdX907+FYbNRPAAp1VSqAriS3H/L6o5riRNnI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sADkuKr3LTk8y3uYDrzkVSR+garTelFCsdvRvCzjDCpmSIGih5f8hgXajK6R+QEIP
         B5W190kaklO6ZsqeTwV8YjR3uiey119AyxmwtvcfQa7nr0GDMnOoagbsFDeuhcn759
         iVspPE906XjJwjj0FBZWN8twBPOQ+iBZB5LXuHPg=
Date:   Tue, 11 Aug 2020 18:35:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, fengyubo3@huawei.com,
        hirofumi@mail.parknet.co.jp, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 108/165] fatfs: switch write_lock to read_lock in
 fat_ioctl_get_attributes
Message-ID: <20200812013556.BSc55f05O%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
