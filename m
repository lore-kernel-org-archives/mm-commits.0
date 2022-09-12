Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85DB4ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiILDeA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiILDcS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:32:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0532A1DA57
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BA96B8085E
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3CDC433D6;
        Mon, 12 Sep 2022 03:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953405;
        bh=s6qwAN4kP1I1xGPu53avs8IJIUN7qsNkETLW0tdv/d8=;
        h=Date:To:From:Subject:From;
        b=ZLaavwqwfhbmg/hiZR7gfNXXOca1UM2YcPkuCRERsYhgJ6/oG8Fl7U2eFU8k6ENjY
         weSaqETv0/AS0HOwJtAwSMkQSCx9AwdEJxLSKFq2o+hbWNzou/bjdrS/P7hTcZBLLu
         VjZ2LOXRzloThFnvK207FnqOlrNbqKwui9LL5GbY=
Date:   Sun, 11 Sep 2022 20:30:04 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, konishi.ryusuke@gmail.com,
        josef@toxicpanda.com, dsterb@suse.com, dsterba@suse.com,
        clm@fb.com, vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nilfs2-convert-nilfs_find_uncommited_extent-to-use-filemap_get_folios_contig.patch removed from -mm tree
Message-Id: <20220912033005.3A3CDC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nilfs2: convert nilfs_find_uncommited_extent() to use filemap_get_folios_contig()
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_find_uncommited_extent-to-use-filemap_get_folios_contig.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: nilfs2: convert nilfs_find_uncommited_extent() to use filemap_get_folios_contig()
Date: Tue, 23 Aug 2022 17:40:21 -0700

Convert function to use folios throughout.  This is in preparation for the
removal of find_get_pages_contig().  Now also supports large folios.

Also clean up an unnecessary if statement - pvec.pages[0]->index > index
will always evaluate to false, and filemap_get_folios_contig() returns 0
if there is no folio found at index.

Link: https://lkml.kernel.org/r/20220824004023.77310-6-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.com>
Cc: David Sterba <dsterb@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.c |   45 ++++++++++++++++++---------------------------
 1 file changed, 18 insertions(+), 27 deletions(-)

--- a/fs/nilfs2/page.c~nilfs2-convert-nilfs_find_uncommited_extent-to-use-filemap_get_folios_contig
+++ a/fs/nilfs2/page.c
@@ -480,41 +480,36 @@ unsigned long nilfs_find_uncommitted_ext
 					    sector_t start_blk,
 					    sector_t *blkoff)
 {
-	unsigned int i;
+	unsigned int i, nr_folios;
 	pgoff_t index;
-	unsigned int nblocks_in_page;
 	unsigned long length = 0;
-	sector_t b;
-	struct pagevec pvec;
-	struct page *page;
+	struct folio_batch fbatch;
+	struct folio *folio;
 
 	if (inode->i_mapping->nrpages == 0)
 		return 0;
 
 	index = start_blk >> (PAGE_SHIFT - inode->i_blkbits);
-	nblocks_in_page = 1U << (PAGE_SHIFT - inode->i_blkbits);
 
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 
 repeat:
-	pvec.nr = find_get_pages_contig(inode->i_mapping, index, PAGEVEC_SIZE,
-					pvec.pages);
-	if (pvec.nr == 0)
+	nr_folios = filemap_get_folios_contig(inode->i_mapping, &index, ULONG_MAX,
+			&fbatch);
+	if (nr_folios == 0)
 		return length;
 
-	if (length > 0 && pvec.pages[0]->index > index)
-		goto out;
-
-	b = pvec.pages[0]->index << (PAGE_SHIFT - inode->i_blkbits);
 	i = 0;
 	do {
-		page = pvec.pages[i];
+		folio = fbatch.folios[i];
 
-		lock_page(page);
-		if (page_has_buffers(page)) {
+		folio_lock(folio);
+		if (folio_buffers(folio)) {
 			struct buffer_head *bh, *head;
+			sector_t b;
 
-			bh = head = page_buffers(page);
+			b = folio->index << (PAGE_SHIFT - inode->i_blkbits);
+			bh = head = folio_buffers(folio);
 			do {
 				if (b < start_blk)
 					continue;
@@ -529,21 +524,17 @@ repeat:
 		} else {
 			if (length > 0)
 				goto out_locked;
-
-			b += nblocks_in_page;
 		}
-		unlock_page(page);
+		folio_unlock(folio);
 
-	} while (++i < pagevec_count(&pvec));
+	} while (++i < nr_folios);
 
-	index = page->index + 1;
-	pagevec_release(&pvec);
+	folio_batch_release(&fbatch);
 	cond_resched();
 	goto repeat;
 
 out_locked:
-	unlock_page(page);
-out:
-	pagevec_release(&pvec);
+	folio_unlock(folio);
+	folio_batch_release(&fbatch);
 	return length;
 }
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

filemap-convert-filemap_range_has_writeback-to-use-folios.patch

