Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B80D2C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbiATCKA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:10:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51214 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233524AbiATCJ4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:09:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F4E6B81C9B
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9EAC004E1;
        Thu, 20 Jan 2022 02:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644594;
        bh=V89IGnwPibMNEAd7a4UZ75xVtd1PT+OQiTs+DG/Gpvs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wfbxxGOVD+uJLrOSO3Ur/0jk5u8dFlYQYV+N8mAAQbKFRvHqK/wl1I1/j6P/g+zrO
         2o3RwF3kDjkSgTdavpIJPtEbc8U+mV+BT/ftPkzyklFJSVgWoL6lyzbO6xfCY28H2w
         8Rp7TPbsB0Rji7J1+wemPGx9Js7s4LKDYoSYgSyM=
Date:   Wed, 19 Jan 2022 18:09:53 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chi.minghao@zte.com.cn,
        christian.brauner@ubuntu.com, gregkh@linuxfoundation.org,
        jack@suse.cz, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, zealci@zte.com.cm
Subject:  [patch 41/55] fs/adfs: remove unneeded variable make code
 cleaner
Message-ID: <20220120020953.ikMtjV7Qq%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>
Subject: fs/adfs: remove unneeded variable make code cleaner

Return value directly instead of taking this in a variable.

Link: https://lkml.kernel.org/r/20211210023211.424609-1-chi.minghao@zte.com.cn
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cm>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/inode.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/adfs/inode.c~fs-adfs-remove-unneeded-variable-make-code-cleaner
+++ a/fs/adfs/inode.c
@@ -355,7 +355,6 @@ int adfs_write_inode(struct inode *inode
 {
 	struct super_block *sb = inode->i_sb;
 	struct object_info obj;
-	int ret;
 
 	obj.indaddr	= ADFS_I(inode)->indaddr;
 	obj.name_len	= 0;
@@ -365,6 +364,5 @@ int adfs_write_inode(struct inode *inode
 	obj.attr	= ADFS_I(inode)->attr;
 	obj.size	= inode->i_size;
 
-	ret = adfs_dir_update(sb, &obj, wbc->sync_mode == WB_SYNC_ALL);
-	return ret;
+	return adfs_dir_update(sb, &obj, wbc->sync_mode == WB_SYNC_ALL);
 }
_
