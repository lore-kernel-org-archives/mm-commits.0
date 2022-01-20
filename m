Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A09C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:31:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377940AbiATVbQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377936AbiATVbQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:31:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DA0C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:31:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2CA4B81E54
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D115C340E0;
        Thu, 20 Jan 2022 21:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714273;
        bh=6SqVKbPTriyRkppYefAb56W3+oeBySGD533zALaXtmg=;
        h=Date:From:To:Subject:From;
        b=BrTVLoFyyuDP/wFBQU2HwkHqJv05T/eChRlIrfPklEckWKLUsOFyOEbhDyK4LmWYP
         VWDrKR7XVd8t9g/wp9p5TzTDucvPXex0PElrCAly5GMF/z+VrNUETnsNP9796xgks2
         6/sWBqjGw9GHpeRpqxIbu2pBfKWR5ICZPNidu0M4=
Date:   Thu, 20 Jan 2022 13:31:12 -0800
From:   akpm@linux-foundation.org
To:     colin.i.king@gmail.com, konishi.ryusuke@gmail.com,
        mm-commits@vger.kernel.org
Subject:  [merged] nilfs2-remove-redundant-pointer-sbufs.patch
 removed from -mm tree
Message-ID: <20220120213112.ZpaMUmBTP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: remove redundant pointer sbufs
has been removed from the -mm tree.  Its filename was
     nilfs2-remove-redundant-pointer-sbufs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from colin.i.king@gmail.com are

kernel-sysctlc-remove-unused-variable-ten_thousand.patch

