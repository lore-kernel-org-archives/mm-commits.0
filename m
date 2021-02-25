Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 064A5C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:22:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A59E264F3C
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:22:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbhBYTWG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:22:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:60064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234687AbhBYTUG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:20:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABA9364F59;
        Thu, 25 Feb 2021 19:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280409;
        bh=DDeKHfQnDdVndP3Bd0tR35KXlJXkKuSLf+3Xs4H5Od8=;
        h=Date:From:To:Subject:From;
        b=1RHmUMTCxVPf9TJEW1AnNmJLwibqluJPwRtTK1lTy7Raqo6OKOH34v+qcA5qffoqF
         hrQs8ftWri/BQ0rxrd1/WQQOp37ZaOdQlD0aZ3szu85sVMRmfaKZPb+ePPnGv8m0n+
         0RwWW6AMDZQVVoWRjXPAEM2wfJb7wbdjZlOVy6lw=
Date:   Thu, 25 Feb 2021 11:13:29 -0800
From:   akpm@linux-foundation.org
To:     guoyang2@huawei.com, mm-commits@vger.kernel.org, npiggin@suse.de,
        viro@zeniv.linux.org.uk, zhangshaokun@hisilicon.com
Subject:  [merged]
 fs-bufferc-add-checking-buffer-head-stat-before-clear.patch removed from
 -mm tree
Message-ID: <20210225191329.Vln9biZxg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/buffer.c: add checking buffer head stat before clear
has been removed from the -mm tree.  Its filename was
     fs-bufferc-add-checking-buffer-head-stat-before-clear.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from guoyang2@huawei.com are


