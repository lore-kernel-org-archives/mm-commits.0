Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 179CCEB64D9
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 21:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbjGBVFL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 17:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjGBVFK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 17:05:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF793E50
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 14:05:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3193760C7F
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 21:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A04C433C7;
        Sun,  2 Jul 2023 21:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688331906;
        bh=Vq4a6HlHqSHd06XvSAW/og4p1QDidcPr+rQkKvVTy2g=;
        h=Date:To:From:Subject:From;
        b=dnXVXNlwM8+MmIRwXLptPsyxBYmEdYRMcerNA1oSocmVq6cvCIoqi7J1PNxTd+oUu
         DcU9PLal9tj3c4FOwQZd7CafSe48uDy4FAeEusemZYWEIDQ5WuIkj/zQYk07SyBlwp
         hKjLyLwW4MohmqDHn9oDi1rXEa8rIOB5vwPstI6M=
Date:   Sun, 02 Jul 2023 14:05:05 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com,
        haibo.li@mediatek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemapc-fix-update-prev_pos-after-one-read-request-done.patch added to mm-unstable branch
Message-Id: <20230702210506.78A04C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap.c: fix update prev_pos after one read request done
has been added to the -mm mm-unstable branch.  Its filename is
     mm-filemapc-fix-update-prev_pos-after-one-read-request-done.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemapc-fix-update-prev_pos-after-one-read-request-done.patch

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
From: Haibo Li <haibo.li@mediatek.com>
Subject: mm/filemap.c: fix update prev_pos after one read request done
Date: Wed, 28 Jun 2023 19:02:20 +0800

ra->prev_pos tracks the last visited byte in the previous read request. 
It is used to check whether it is sequential read in ondemand_readahead
and thus affects the readahead window.

After commit 06c0444290ce ("mm/filemap.c: generic_file_buffered_read() now
uses find_get_pages_contig"), update logic of prev_pos is changed.  It
updates prev_pos after each return from filemap_get_pages().  But the read
request from user may be not fully completed at this point.  The updated
prev_pos impacts the subsequent readahead window.

The real problem is performance drop of fsck_msdos between linux-5.4 and
linux-5.15(also linux-6.4).  Comparing to linux-5.4,It spends about 110%
time and read 140% pages.  The read pattern of fsck_msdos is not fully
sequential.

Simplified read pattern of fsck_msdos likes below:
1.read at page offset 0xa,size 0x1000
2.read at other page offset like 0x20,size 0x1000
3.read at page offset 0xa,size 0x4000
4.read at page offset 0xe,size 0x1000

Here is the read status on linux-6.4:
1.after read at page offset 0xa,size 0x1000
    ->page ofs 0xa go into pagecache
2.after read at page offset 0x20,size 0x1000
    ->page ofs 0x20 go into pagecache
3.read at page offset 0xa,size 0x4000
    ->filemap_get_pages read ofs 0xa from pagecache and returns
    ->prev_pos is updated to 0xb and goto next loop
    ->filemap_get_pages tends to read ofs 0xb,size 0x3000
    ->initial_readahead case in ondemand_readahead since prev_pos is
      the same as request ofs.
    ->read 8 pages while async size is 5 pages
      (PageReadahead flag at page 0xe)
4.read at page offset 0xe,size 0x1000
    ->hit page 0xe with PageReadahead flag set,double the ra_size.
      read 16 pages while async size is 16 pages
Now it reads 24 pages while actually uses 5 pages

on linux-5.4:
1.the same as 6.4
2.the same as 6.4
3.read at page offset 0xa,size 0x4000
    ->read ofs 0xa from pagecache
    ->read ofs 0xb,size 0x3000 using page_cache_sync_readahead
      read 3 pages
    ->prev_pos is updated to 0xd before generic_file_buffered_read
      returns
4.read at page offset 0xe,size 0x1000
    ->initial_readahead case in ondemand_readahead since
      request ofs-prev_pos==1
    ->read 4 pages while async size is 3 pages

Now it reads 7 pages while actually uses 5 pages.

In above demo, the initial_readahead case is triggered by offset of user
request on linux-5.4.  While it may be triggered by update logic of
prev_pos on linux-6.4.

To fix the performance drop, update prev_pos after finishing one read
request.

Link: https://lkml.kernel.org/r/20230628110220.120134-1-haibo.li@mediatek.com
Signed-off-by: Haibo Li <haibo.li@mediatek.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/filemap.c~mm-filemapc-fix-update-prev_pos-after-one-read-request-done
+++ a/mm/filemap.c
@@ -2633,6 +2633,7 @@ ssize_t filemap_read(struct kiocb *iocb,
 	int i, error = 0;
 	bool writably_mapped;
 	loff_t isize, end_offset;
+	loff_t last_pos = ra->prev_pos;
 
 	if (unlikely(iocb->ki_pos >= inode->i_sb->s_maxbytes))
 		return 0;
@@ -2683,8 +2684,8 @@ ssize_t filemap_read(struct kiocb *iocb,
 		 * When a read accesses the same folio several times, only
 		 * mark it as accessed the first time.
 		 */
-		if (!pos_same_folio(iocb->ki_pos, ra->prev_pos - 1,
-							fbatch.folios[0]))
+		if (!pos_same_folio(iocb->ki_pos, last_pos - 1,
+				    fbatch.folios[0]))
 			folio_mark_accessed(fbatch.folios[0]);
 
 		for (i = 0; i < folio_batch_count(&fbatch); i++) {
@@ -2711,7 +2712,7 @@ ssize_t filemap_read(struct kiocb *iocb,
 
 			already_read += copied;
 			iocb->ki_pos += copied;
-			ra->prev_pos = iocb->ki_pos;
+			last_pos = iocb->ki_pos;
 
 			if (copied < bytes) {
 				error = -EFAULT;
@@ -2725,7 +2726,7 @@ put_folios:
 	} while (iov_iter_count(iter) && iocb->ki_pos < isize && !error);
 
 	file_accessed(filp);
-
+	ra->prev_pos = last_pos;
 	return already_read ? already_read : error;
 }
 EXPORT_SYMBOL_GPL(filemap_read);
_

Patches currently in -mm which might be from haibo.li@mediatek.com are

mm-filemapc-fix-update-prev_pos-after-one-read-request-done.patch

