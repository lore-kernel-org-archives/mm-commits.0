Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24CA9C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:09:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbiATCJv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:09:51 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51154 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbiATCJr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:09:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F000B81C9E
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:09:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E51C004E1;
        Thu, 20 Jan 2022 02:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644584;
        bh=3MpVi9ZSpCjAtGbl6JawZx+bYZ0/IH5q07XDl7taqfI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ffaWhGbWNp8KSaLH/NuH//Y5hcPVp0NEPCFezyxWdotux963qKBUe/Qmjz5szCI8J
         LEt6RaUUAawOfOAf8BZY2QhnnShMqSNZreJ+OAE0B1fCbHZFWekFai7R2ckUG4kIBH
         koNlO1gVf/bjx8Yj0UInIEDxZPBuSpM765OC9LGY=
Date:   Wed, 19 Jan 2022 18:09:44 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, colin.i.king@gmail.com,
        konishi.ryusuke@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 38/55] nilfs2: remove redundant pointer sbufs
Message-ID: <20220120020944.GQSPXcdh_%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Colin Ian King <colin.i.king@gmail.com>
Subject: nilfs2: remove redundant pointer sbufs

Pointer sbufs is being assigned a value but it's not being used later on. 
The pointer is redundant and can be removed.  Cleans up scan-build static
analysis warning:

fs/nilfs2/page.c:203:8: warning: Although the value stored to 'sbufs'
is used in the enclosing expression, the value is never actually read
from 'sbufs' [deadcode.DeadStores]
        sbh = sbufs = page_buffers(src);

Link: https://lkml.kernel.org/r/20211211180955.550380-1-colin.i.king@gmail.com
Link: https://lkml.kernel.org/r/1640712476-15136-1-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/page.c~nilfs2-remove-redundant-pointer-sbufs
+++ a/fs/nilfs2/page.c
@@ -195,12 +195,12 @@ void nilfs_page_bug(struct page *page)
  */
 static void nilfs_copy_page(struct page *dst, struct page *src, int copy_dirty)
 {
-	struct buffer_head *dbh, *dbufs, *sbh, *sbufs;
+	struct buffer_head *dbh, *dbufs, *sbh;
 	unsigned long mask = NILFS_BUFFER_INHERENT_BITS;
 
 	BUG_ON(PageWriteback(dst));
 
-	sbh = sbufs = page_buffers(src);
+	sbh = page_buffers(src);
 	if (!page_has_buffers(dst))
 		create_empty_buffers(dst, sbh->b_size, 0);
 
_
