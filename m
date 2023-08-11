Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05107C04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:59:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236959AbjHKW7I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236604AbjHKW6x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:58:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF2F30EE
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:58:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C97BA66B5A
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9E3C433C8;
        Fri, 11 Aug 2023 22:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794731;
        bh=z/bNZViV4PL9FghRg6cbOVVGsuYFQm/q/aSsP+p12X0=;
        h=Date:To:From:Subject:From;
        b=sITaFc9zARAaY0r2lEHv8sI6C7RcyNfyGIkVPoy6mxUHB2/b/V7RAzgltuh1Fs87w
         g6gLTkL8izglO4QHbPj8phgAfAVVxmdXTi2lAMkVy9JFfaSCjJ8E30Xa+0KFoRjp+J
         /LKt89B42ZgQDyVZBkzDDcRAYc/jc6xjcMoDTu8c=
Date:   Fri, 11 Aug 2023 15:58:50 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        matthias.bgg@gmail.com, jack@suse.cz,
        angelogioacchino.delregno@collabora.com, haibo.li@mediatek.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filemapc-fix-update-prev_pos-after-one-read-request-done.patch removed from -mm tree
Message-Id: <20230811225851.2C9E3C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/filemap.c: fix update prev_pos after one read request done
has been removed from the -mm tree.  Its filename was
     mm-filemapc-fix-update-prev_pos-after-one-read-request-done.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/filemap.c~mm-filemapc-fix-update-prev_pos-after-one-read-request-done
+++ a/mm/filemap.c
@@ -2632,6 +2632,7 @@ ssize_t filemap_read(struct kiocb *iocb,
 	int i, error = 0;
 	bool writably_mapped;
 	loff_t isize, end_offset;
+	loff_t last_pos = ra->prev_pos;
 
 	if (unlikely(iocb->ki_pos >= inode->i_sb->s_maxbytes))
 		return 0;
@@ -2682,8 +2683,8 @@ ssize_t filemap_read(struct kiocb *iocb,
 		 * When a read accesses the same folio several times, only
 		 * mark it as accessed the first time.
 		 */
-		if (!pos_same_folio(iocb->ki_pos, ra->prev_pos - 1,
-							fbatch.folios[0]))
+		if (!pos_same_folio(iocb->ki_pos, last_pos - 1,
+				    fbatch.folios[0]))
 			folio_mark_accessed(fbatch.folios[0]);
 
 		for (i = 0; i < folio_batch_count(&fbatch); i++) {
@@ -2710,7 +2711,7 @@ ssize_t filemap_read(struct kiocb *iocb,
 
 			already_read += copied;
 			iocb->ki_pos += copied;
-			ra->prev_pos = iocb->ki_pos;
+			last_pos = iocb->ki_pos;
 
 			if (copied < bytes) {
 				error = -EFAULT;
@@ -2724,7 +2725,7 @@ put_folios:
 	} while (iov_iter_count(iter) && iocb->ki_pos < isize && !error);
 
 	file_accessed(filp);
-
+	ra->prev_pos = last_pos;
 	return already_read ? already_read : error;
 }
 EXPORT_SYMBOL_GPL(filemap_read);
_

Patches currently in -mm which might be from haibo.li@mediatek.com are


