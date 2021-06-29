Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 290C0C11F65
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 145A661D01
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:34:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbhF2Cgg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:36:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231348AbhF2Cgg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:36:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 783B961D05;
        Tue, 29 Jun 2021 02:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934048;
        bh=Ee4kanZuh0Lr8aZRFXAkbEGF7lAeH0dhj2uk6xDLQrw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ufpD4ef1HCyNiOgxkUFAY+KtkI51hOfILmhyjslA4LPmUQArCvVH9k0dhO2i1RjKp
         7IyA3lE/rFXAKrv5YKAv/I6y3BeMyX0hfYmIlBOq2v37uRuD0aYiYk2KYpk30vS9Fc
         KiZH2dRKy8AsGa62lCTkEwZEL/yo1lcZ2dNMG9Pg=
Date:   Mon, 28 Jun 2021 19:34:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com,
        mm-commits@vger.kernel.org, piaojun@huawei.com,
        torvalds@linux-foundation.org, wanjiabing@vivo.com
Subject:  [patch 016/192] ocfs2: remove repeated uptodate check for
 buffer
Message-ID: <20210629023408.Y-WgoJ4Tp%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
