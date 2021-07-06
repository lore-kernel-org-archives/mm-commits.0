Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D73C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B146261C7B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbhGFTLN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:11:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231701AbhGFTLN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:11:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97B6561C7A;
        Tue,  6 Jul 2021 19:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598514;
        bh=RMmB1RUyLHkSqbL2PEkUtbBrSE1ZkX4KrSuq1lVs+4w=;
        h=Date:From:To:Subject:From;
        b=TWhk5nJxfRyrS5DAt4PPH7Z/tA7OA6sghdwyUP0cdQ/JIDbaMR4138/AUbJOWXZpE
         fuYNHJ+B6wFuS3yFMRPZ4st4ganAi9UbSlkkyxJclaIglSj3svDy8+QlZoQH/bYIlI
         DrxO+Wd3NoRnNnk4g5hcXrGddHPIWUiw9vVRh0dY=
Date:   Tue, 06 Jul 2021 12:08:34 -0700
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com,
        wanjiabing@vivo.com
Subject:  [merged]
 ocfs2-remove-repeated-uptodate-check-for-buffer.patch removed from -mm tree
Message-ID: <20210706190834.6WHcGavW2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove repeated uptodate check for buffer
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-repeated-uptodate-check-for-buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wan Jiabing <wanjiabing@vivo.com>
Subject: ocfs2: remove repeated uptodate check for buffer

In commit 60f91826ca62 ("buffer: Avoid setting buffer bits that are
already set"), function set_buffer_##name was added a test_bit() to check
buffer, which is the same as function buffer_##name.  The
!buffer_uptodate(bh) here is a repeated check.  Remove it.

Link: https://lkml.kernel.org/r/20210425025702.13628-1-wanjiabing@vivo.com
Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/ocfs2/aops.c~ocfs2-remove-repeated-uptodate-check-for-buffer
+++ a/fs/ocfs2/aops.c
@@ -632,8 +632,7 @@ int ocfs2_map_page_blocks(struct page *p
 		}
 
 		if (PageUptodate(page)) {
-			if (!buffer_uptodate(bh))
-				set_buffer_uptodate(bh);
+			set_buffer_uptodate(bh);
 		} else if (!buffer_uptodate(bh) && !buffer_delay(bh) &&
 			   !buffer_new(bh) &&
 			   ocfs2_should_read_blk(inode, page, block_start) &&
_

Patches currently in -mm which might be from wanjiabing@vivo.com are


