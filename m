Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 758B9CDB483
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbjJRVhQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235283AbjJRVg0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:26 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBF019D
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB063C433D9;
        Wed, 18 Oct 2023 21:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664936;
        bh=ahnhUdci1fZRnD//AKphzcISNjGXfqmdHAuHcrxVdJk=;
        h=Date:To:From:Subject:From;
        b=oHNC0V3qLtXFXarwNE/YCn4vS08518TVKduti88/0CaMxvz5GaCdJjcwGPLwywR0h
         s71Ajt4SgTpckTt812YXf8aZy3comL/WrqGajW2WexWrQ7yGIIpwQGQAVBarwY/BCR
         Sk1AeX6sWaCUvLWks9WJeY+9NF+d7q6izYyry8H8=
Date:   Wed, 18 Oct 2023 14:35:36 -0700
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
Subject: [merged mm-stable] iomap-protect-read_bytes_pending-with-the-state_lock.patch removed from -mm tree
Message-Id: <20231018213536.BB063C433D9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: iomap: protect read_bytes_pending with the state_lock
has been removed from the -mm tree.  Its filename was
     iomap-protect-read_bytes_pending-with-the-state_lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: iomap: protect read_bytes_pending with the state_lock
Date: Wed, 4 Oct 2023 17:53:02 +0100

Perform one atomic operation (acquiring the spinlock) instead of two
(spinlock & atomic_sub) per read completion.

Link: https://lkml.kernel.org/r/20231004165317.1061855-3-willy@infradead.org
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

 fs/iomap/buffered-io.c |   37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

--- a/fs/iomap/buffered-io.c~iomap-protect-read_bytes_pending-with-the-state_lock
+++ a/fs/iomap/buffered-io.c
@@ -29,9 +29,9 @@ typedef int (*iomap_punch_t)(struct inod
  * and I/O completions.
  */
 struct iomap_folio_state {
-	atomic_t		read_bytes_pending;
-	atomic_t		write_bytes_pending;
 	spinlock_t		state_lock;
+	unsigned int		read_bytes_pending;
+	atomic_t		write_bytes_pending;
 
 	/*
 	 * Each block has two bits in this bitmap:
@@ -183,7 +183,7 @@ static void ifs_free(struct folio *folio
 
 	if (!ifs)
 		return;
-	WARN_ON_ONCE(atomic_read(&ifs->read_bytes_pending));
+	WARN_ON_ONCE(ifs->read_bytes_pending != 0);
 	WARN_ON_ONCE(atomic_read(&ifs->write_bytes_pending));
 	WARN_ON_ONCE(ifs_is_fully_uptodate(folio, ifs) !=
 			folio_test_uptodate(folio));
@@ -250,19 +250,29 @@ static void iomap_adjust_read_range(stru
 	*lenp = plen;
 }
 
-static void iomap_finish_folio_read(struct folio *folio, size_t offset,
+static void iomap_finish_folio_read(struct folio *folio, size_t off,
 		size_t len, int error)
 {
 	struct iomap_folio_state *ifs = folio->private;
+	bool uptodate = !error;
+	bool finished = true;
 
-	if (unlikely(error)) {
-		folio_clear_uptodate(folio);
-		folio_set_error(folio);
-	} else {
-		iomap_set_range_uptodate(folio, offset, len);
+	if (ifs) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&ifs->state_lock, flags);
+		if (!error)
+			uptodate = ifs_set_range_uptodate(folio, ifs, off, len);
+		ifs->read_bytes_pending -= len;
+		finished = !ifs->read_bytes_pending;
+		spin_unlock_irqrestore(&ifs->state_lock, flags);
 	}
 
-	if (!ifs || atomic_sub_and_test(len, &ifs->read_bytes_pending))
+	if (error)
+		folio_set_error(folio);
+	if (uptodate)
+		folio_mark_uptodate(folio);
+	if (finished)
 		folio_unlock(folio);
 }
 
@@ -360,8 +370,11 @@ static loff_t iomap_readpage_iter(const
 	}
 
 	ctx->cur_folio_in_bio = true;
-	if (ifs)
-		atomic_add(plen, &ifs->read_bytes_pending);
+	if (ifs) {
+		spin_lock_irq(&ifs->state_lock);
+		ifs->read_bytes_pending += plen;
+		spin_unlock_irq(&ifs->state_lock);
+	}
 
 	sector = iomap_sector(iomap, pos);
 	if (!ctx->bio ||
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

