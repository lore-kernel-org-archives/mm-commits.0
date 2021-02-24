Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA13C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:05:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F07064F1F
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234663AbhBXUE7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:04:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:55482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235411AbhBXUDH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:03:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B95D64F20;
        Wed, 24 Feb 2021 20:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196969;
        bh=aN4ApV2pMzQ/PNBdet6SPu7L+unhlAHyg8vhrUrR6sg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UrE/NdWpXL5rQp3U9EZioVPHE2XOZu8aY8D2TSkINtWY9QMmpFMEynO4ggDAjviya
         2KnnefqIWEFg9MLr5nYZpdOCnrpVRWa5aPYjbu3DBz90sLdmGOzcTP+AigEIjZYZJ3
         x0c5tD6TUvUC/NhE7zLnFCACE8MlbENSolbZWqys=
Date:   Wed, 24 Feb 2021 12:02:48 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guoyang2@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, npiggin@suse.de,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        zhangshaokun@hisilicon.com
Subject:  [patch 048/173] fs/buffer.c: add checking buffer head
 stat before clear
Message-ID: <20210224200248.86pqR4gin%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yang Guo <guoyang2@huawei.com>
Subject: fs/buffer.c: add checking buffer head stat before clear

clear_buffer_new() is used to clear buffer new stat.  When PAGE_SIZE is
64K, most buffer heads in the list are not needed to clear. 
clear_buffer_new() has an enpensive atomic modification operation, Let's
add checking buffer head before clear it as __block_write_begin_int does
which is good for performance.

Link: https://lkml.kernel.org/r/1612332890-57918-1-git-send-email-zhangshaokun@hisilicon.com
Signed-off-by: Yang Guo <guoyang2@huawei.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/buffer.c~fs-bufferc-add-checking-buffer-head-stat-before-clear
+++ a/fs/buffer.c
@@ -2083,7 +2083,8 @@ static int __block_commit_write(struct i
 			set_buffer_uptodate(bh);
 			mark_buffer_dirty(bh);
 		}
-		clear_buffer_new(bh);
+		if (buffer_new(bh))
+			clear_buffer_new(bh);
 
 		block_start = block_end;
 		bh = bh->b_this_page;
_
