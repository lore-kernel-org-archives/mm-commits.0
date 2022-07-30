Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E315C19F29
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:08:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239686AbiG3BIk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239608AbiG3BIZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE592820FD
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABD3DB82922
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C03C433D7;
        Sat, 30 Jul 2022 01:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143302;
        bh=4mJuxEfTBIAzU+NGuI/cWIOMFXrPgEdNZ7a/tTSottk=;
        h=Date:To:From:Subject:From;
        b=MMU3U1ya8zwyioXBFn2yeGApWyvwnBWmOzYoh+04rz2eMej6wI9vMv1dIyL7VvqAE
         wVFI7yaoaPMEJCsnIzjIvx0Own7hswI5LOtLvZElnYbHHAgNrzz+Vv6XJrfVCeYEaR
         YuuRe9UdPDiLJwJOyZ0VKlNhIQBVyZG/i9GQA5m0=
Date:   Fri, 29 Jul 2022 18:08:21 -0700
To:     mm-commits@vger.kernel.org, johannes.thumshirn@wdc.com,
        jack@suse.cz, xiujianfeng@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] writeback-cleanup-inode_to_wb_is_valid.patch removed from -mm tree
Message-Id: <20220730010822.50C03C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: writeback: remove inode_to_wb_is_valid()
has been removed from the -mm tree.  Its filename was
     writeback-cleanup-inode_to_wb_is_valid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

bdi-remove-enum-wb_congested_state.patch

