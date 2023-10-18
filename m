Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD52BCDB483
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235220AbjJRVhF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235278AbjJRVg0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:26 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C84819F
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C60C43397;
        Wed, 18 Oct 2023 21:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664935;
        bh=DfBN8cEWn/4GjeZP9vBI1jujKr25bjsHswPNcRpoOJQ=;
        h=Date:To:From:Subject:From;
        b=A535VUnCPJj1rQTMII3Kx9WGw0h0/GtyaTX9HMSN9v5jK2cs1cJqNvFunFrHBf39g
         QINOzy2g1aHnUaKnP74T3wog4lZL901NjNQdNbRNbCLqfc+Dz5D9oRzAtYf0IvMLId
         YgDTXy3CC1DDoHP8lwE+TpI8GpEEmNZszvUswnbg=
Date:   Wed, 18 Oct 2023 14:35:35 -0700
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
Subject: [merged mm-stable] iomap-hold-state_lock-over-call-to-ifs_set_range_uptodate.patch removed from -mm tree
Message-Id: <20231018213535.C8C60C43397@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: iomap: hold state_lock over call to ifs_set_range_uptodate()
has been removed from the -mm tree.  Its filename was
     iomap-hold-state_lock-over-call-to-ifs_set_range_uptodate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: iomap: hold state_lock over call to ifs_set_range_uptodate()
Date: Wed, 4 Oct 2023 17:53:01 +0100

Patch series "Add folio_end_read", v2.

The core of this patchset is the new folio_end_read() call which
filesystems can use when finishing a page cache read instead of separate
calls to mark the folio uptodate and unlock it.  As an illustration of its
use, I converted ext4, iomap & mpage; more can be converted.

I think that's useful by itself, but the interesting optimisation is that
we can implement that with a single XOR instruction that sets the uptodate
bit, clears the lock bit, tests the waiter bit and provides a write memory
barrier.  That removes one memory barrier and one atomic instruction from
each page read, which seems worth doing.  That's in patch 15.

The last two patches could be a separate series, but basically we can do
the same thing with the writeback flag that we do with the unlock flag;
clear it and test the waiters bit at the same time.


This patch (of 17):

This is really preparation for the next patch, but it lets us call
folio_mark_uptodate() in just one place instead of two.

Link: https://lkml.kernel.org/r/20231004165317.1061855-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20231004165317.1061855-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/iomap/buffered-io.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/fs/iomap/buffered-io.c~iomap-hold-state_lock-over-call-to-ifs_set_range_uptodate
+++ a/fs/iomap/buffered-io.c
@@ -57,30 +57,32 @@ static inline bool ifs_block_is_uptodate
 	return test_bit(block, ifs->state);
 }
 
-static void ifs_set_range_uptodate(struct folio *folio,
+static bool ifs_set_range_uptodate(struct folio *folio,
 		struct iomap_folio_state *ifs, size_t off, size_t len)
 {
 	struct inode *inode = folio->mapping->host;
 	unsigned int first_blk = off >> inode->i_blkbits;
 	unsigned int last_blk = (off + len - 1) >> inode->i_blkbits;
 	unsigned int nr_blks = last_blk - first_blk + 1;
-	unsigned long flags;
 
-	spin_lock_irqsave(&ifs->state_lock, flags);
 	bitmap_set(ifs->state, first_blk, nr_blks);
-	if (ifs_is_fully_uptodate(folio, ifs))
-		folio_mark_uptodate(folio);
-	spin_unlock_irqrestore(&ifs->state_lock, flags);
+	return ifs_is_fully_uptodate(folio, ifs);
 }
 
 static void iomap_set_range_uptodate(struct folio *folio, size_t off,
 		size_t len)
 {
 	struct iomap_folio_state *ifs = folio->private;
+	unsigned long flags;
+	bool uptodate = true;
+
+	if (ifs) {
+		spin_lock_irqsave(&ifs->state_lock, flags);
+		uptodate = ifs_set_range_uptodate(folio, ifs, off, len);
+		spin_unlock_irqrestore(&ifs->state_lock, flags);
+	}
 
-	if (ifs)
-		ifs_set_range_uptodate(folio, ifs, off, len);
-	else
+	if (uptodate)
 		folio_mark_uptodate(folio);
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

