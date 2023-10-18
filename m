Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71BAACDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbjJRVhF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235279AbjJRVg0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:26 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3B81A2
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DCDC433CC;
        Wed, 18 Oct 2023 21:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664939;
        bh=aPqunvNvENi2bS2q5zyzFpjK3wtFY9XVlMfksrzt1uA=;
        h=Date:To:From:Subject:From;
        b=DRrXz75MT6LsaS+q8sNBtGSyjXROL6Ru62Mf4P0OP7vA5F0ik4F1D/PgsZni6G8uP
         dKiomrr5Rs/ZERNu+XIId7+pNThoNUfjWMCMKzVMRJNndz5/SsDLs30fez4jLjaG/B
         wZ/bSKZfqvIzSe7PhgAgp1Fp+7urPPVTW/ApeF54=
Date:   Wed, 18 Oct 2023 14:35:38 -0700
To:     mm-commits@vger.kernel.org, tytso@mit.edu,
        tsbogend@alpha.franken.de, svens@linux.ibm.com,
        richard.henderson@linaro.org, paul.walmsley@sifive.com,
        palmer@dabbelt.com, npiggin@gmail.com, mpe@ellerman.id.au,
        mattst88@gmail.com, ink@jurassic.park.msu.ru, hca@linux.ibm.com,
        gor@linux.ibm.com, geert@linux-m68k.org,
        christophe.leroy@csgroup.eu, borntraeger@linux.ibm.com,
        aou@eecs.berkeley.edu, agordeev@linux.ibm.com,
        adilger.kernel@dilger.ca, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-use-folio_end_read.patch removed from -mm tree
Message-Id: <20231018213539.93DCDC433CC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: buffer: use folio_end_read()
has been removed from the -mm tree.  Its filename was
     buffer-use-folio_end_read.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: use folio_end_read()
Date: Wed, 4 Oct 2023 17:53:05 +0100

There are two places that we can use this new helper.

Link: https://lkml.kernel.org/r/20231004165317.1061855-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/fs/buffer.c~buffer-use-folio_end_read
+++ a/fs/buffer.c
@@ -282,13 +282,7 @@ static void end_buffer_async_read(struct
 	} while (tmp != bh);
 	spin_unlock_irqrestore(&first->b_uptodate_lock, flags);
 
-	/*
-	 * If all of the buffers are uptodate then we can set the page
-	 * uptodate.
-	 */
-	if (folio_uptodate)
-		folio_mark_uptodate(folio);
-	folio_unlock(folio);
+	folio_end_read(folio, folio_uptodate);
 	return;
 
 still_busy:
@@ -2433,12 +2427,10 @@ int block_read_full_folio(struct folio *
 
 	if (!nr) {
 		/*
-		 * All buffers are uptodate - we can set the folio uptodate
-		 * as well. But not if get_block() returned an error.
+		 * All buffers are uptodate or get_block() returned an
+		 * error when trying to map them - we can finish the read.
 		 */
-		if (!page_error)
-			folio_mark_uptodate(folio);
-		folio_unlock(folio);
+		folio_end_read(folio, !page_error);
 		return 0;
 	}
 
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-make-folio_create_empty_buffers-return-a-buffer_head.patch
mpage-convert-map_buffer_to_folio-to-folio_create_empty_buffers.patch
ext4-convert-to-folio_create_empty_buffers.patch
buffer-add-get_nth_bh.patch
gfs2-convert-inode-unstuffing-to-use-a-folio.patch
gfs2-convert-gfs2_getbuf-to-folios.patch
gfs2-convert-gfs2_getjdatabuf-to-use-a-folio.patch
gfs2-convert-gfs2_write_buf_to_page-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_freeze_buffer-to-use-a-folio.patch
nilfs2-convert-nilfs_grab_buffer-to-use-a-folio.patch
nilfs2-convert-nilfs_copy_page-to-nilfs_copy_folio.patch
nilfs2-convert-nilfs_mdt_forget_block-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_get_frozen_buffer-to-use-a-folio.patch
nilfs2-remove-nilfs_page_get_nth_block.patch
nilfs2-convert-nilfs_lookup_dirty_data_buffers-to-use-folio_create_empty_buffers.patch
ntfs-convert-ntfs_read_block-to-use-a-folio.patch
ntfs-convert-ntfs_writepage-to-use-a-folio.patch
ntfs-convert-ntfs_prepare_pages_for_non_resident_write-to-folios.patch
ntfs3-convert-ntfs_zero_range-to-use-a-folio.patch
ocfs2-convert-ocfs2_map_page_blocks-to-use-a-folio.patch
reiserfs-convert-writepage-to-use-a-folio.patch
ufs-add-ufs_get_locked_folio-and-ufs_put_locked_folio.patch
ufs-use-ufs_get_locked_folio-in-ufs_alloc_lastblock.patch
ufs-convert-ufs_change_blocknr-to-use-folios.patch
ufs-remove-ufs_get_locked_page.patch
buffer-remove-folio_create_empty_buffers.patch

