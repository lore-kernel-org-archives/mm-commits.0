Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1299C43334
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jul 2022 00:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiGQAgG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Jul 2022 20:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiGQAgF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 16 Jul 2022 20:36:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD024E091
        for <mm-commits@vger.kernel.org>; Sat, 16 Jul 2022 17:36:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6893960C11
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 00:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8125C34114;
        Sun, 17 Jul 2022 00:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658018163;
        bh=NpgjethCN6fYBbA2JejrTn9G4+Xcl9QXQpsKdbnAIok=;
        h=Date:To:From:Subject:From;
        b=0ZduSohac2dwYq7Qbwkpm8vz1ZUekT0T2F/+4c+wZd6HynTPbIROYw1Su+YNQGy3i
         Fhu2wDx0jzhRyht9NPCgA2w0veLeK7Cq9xv6oTWUV0Pi7ziMUTyw7/UAd1osG07ugG
         P4MJMYuti9Xt1oEL/064QZ5I9h9Po1Wu92PKHi1U=
Date:   Sat, 16 Jul 2022 17:36:03 -0700
To:     mm-commits@vger.kernel.org, johannes.thumshirn@wdc.com,
        jack@suse.cz, xiujianfeng@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-cleanup-inode_to_wb_is_valid.patch added to mm-unstable branch
Message-Id: <20220717003603.B8125C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: writeback: remove inode_to_wb_is_valid()
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-cleanup-inode_to_wb_is_valid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-cleanup-inode_to_wb_is_valid.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: writeback: remove inode_to_wb_is_valid()
Date: Thu, 14 Jul 2022 16:41:47 +0800

inode_to_wb_is_valid() is no longer used since commit fe55d563d417
("remove inode_congested()"), remove it.

Link: https://lkml.kernel.org/r/20220714084147.140324-1-xiujianfeng@huawei.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |   17 -----------------
 1 file changed, 17 deletions(-)

--- a/include/linux/backing-dev.h~writeback-cleanup-inode_to_wb_is_valid
+++ a/include/linux/backing-dev.h
@@ -230,18 +230,6 @@ wb_get_create_current(struct backing_dev
 }
 
 /**
- * inode_to_wb_is_valid - test whether an inode has a wb associated
- * @inode: inode of interest
- *
- * Returns %true if @inode has a wb associated.  May be called without any
- * locking.
- */
-static inline bool inode_to_wb_is_valid(struct inode *inode)
-{
-	return inode->i_wb;
-}
-
-/**
  * inode_to_wb - determine the wb of an inode
  * @inode: inode of interest
  *
@@ -339,11 +327,6 @@ wb_get_create_current(struct backing_dev
 	return &bdi->wb;
 }
 
-static inline bool inode_to_wb_is_valid(struct inode *inode)
-{
-	return true;
-}
-
 static inline struct bdi_writeback *inode_to_wb(struct inode *inode)
 {
 	return &inode_to_bdi(inode)->wb;
_

Patches currently in -mm which might be from xiujianfeng@huawei.com are

mm-mprotect-remove-the-redundant-initialization-for-error.patch
writeback-cleanup-bdi_sched_wait.patch
writeback-cleanup-inode_to_wb_is_valid.patch

