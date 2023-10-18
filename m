Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D34FCDB482
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235223AbjJRVhb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235253AbjJRVgv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F31D60
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:50 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34C1C433C8;
        Wed, 18 Oct 2023 21:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664950;
        bh=GiP/NCDftvNYE1HqvNt3k2sPfDE9SKeXvI66HI08Nng=;
        h=Date:To:From:Subject:From;
        b=X8ONqsL8ybLBvlZNdzzZ40yT7Ykx7Zo3phU0Ts9IRem+SmHi/arAvksnviPBva4TQ
         oCs/gQU7sjnD/NhG+AlAfP540auhJle/iIYRHbhkmEXD/0RoHVmqMc9qHHteTdk8Ez
         Hc8AgtiBFXOPbQ7gc4+Xfyhv8W9qyGtdCFkqNTj8=
Date:   Wed, 18 Oct 2023 14:35:50 -0700
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
Subject: [merged mm-stable] mm-use-folio_xor_flags_has_waiters-in-folio_end_writeback.patch removed from -mm tree
Message-Id: <20231018213550.B34C1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: use folio_xor_flags_has_waiters() in folio_end_writeback()
has been removed from the -mm tree.  Its filename was
     mm-use-folio_xor_flags_has_waiters-in-folio_end_writeback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: use folio_xor_flags_has_waiters() in folio_end_writeback()
Date: Wed, 4 Oct 2023 17:53:17 +0100

Match how folio_unlock() works by combining the test for PG_waiters with
the clearing of PG_writeback.  This should have a small performance win,
and removes the last user of folio_wake().

Link: https://lkml.kernel.org/r/20231004165317.1061855-18-willy@infradead.org
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

 mm/filemap.c        |   15 +++------------
 mm/internal.h       |    2 +-
 mm/page-writeback.c |    9 ++++++---
 3 files changed, 10 insertions(+), 16 deletions(-)

--- a/mm/filemap.c~mm-use-folio_xor_flags_has_waiters-in-folio_end_writeback
+++ a/mm/filemap.c
@@ -1175,13 +1175,6 @@ static void folio_wake_bit(struct folio
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 
-static void folio_wake(struct folio *folio, int bit)
-{
-	if (!folio_test_waiters(folio))
-		return;
-	folio_wake_bit(folio, bit);
-}
-
 /*
  * A choice of three behaviors for folio_wait_bit_common():
  */
@@ -1618,13 +1611,11 @@ void folio_end_writeback(struct folio *f
 	 * Writeback does not hold a folio reference of its own, relying
 	 * on truncation to wait for the clearing of PG_writeback.
 	 * But here we must make sure that the folio is not freed and
-	 * reused before the folio_wake().
+	 * reused before the folio_wake_bit().
 	 */
 	folio_get(folio);
-	__folio_end_writeback(folio);
-
-	smp_mb__after_atomic();
-	folio_wake(folio, PG_writeback);
+	if (__folio_end_writeback(folio))
+		folio_wake_bit(folio, PG_writeback);
 	acct_reclaim_writeback(folio);
 	folio_put(folio);
 }
--- a/mm/internal.h~mm-use-folio_xor_flags_has_waiters-in-folio_end_writeback
+++ a/mm/internal.h
@@ -105,7 +105,7 @@ static inline void wake_throttle_isolate
 
 vm_fault_t do_swap_page(struct vm_fault *vmf);
 void folio_rotate_reclaimable(struct folio *folio);
-void __folio_end_writeback(struct folio *folio);
+bool __folio_end_writeback(struct folio *folio);
 void deactivate_file_folio(struct folio *folio);
 void folio_activate(struct folio *folio);
 
--- a/mm/page-writeback.c~mm-use-folio_xor_flags_has_waiters-in-folio_end_writeback
+++ a/mm/page-writeback.c
@@ -2940,10 +2940,11 @@ static void wb_inode_writeback_end(struc
 	spin_unlock_irqrestore(&wb->work_lock, flags);
 }
 
-void __folio_end_writeback(struct folio *folio)
+bool __folio_end_writeback(struct folio *folio)
 {
 	long nr = folio_nr_pages(folio);
 	struct address_space *mapping = folio_mapping(folio);
+	bool ret;
 
 	folio_memcg_lock(folio);
 	if (mapping && mapping_use_writeback_tags(mapping)) {
@@ -2952,7 +2953,7 @@ void __folio_end_writeback(struct folio
 		unsigned long flags;
 
 		xa_lock_irqsave(&mapping->i_pages, flags);
-		folio_test_clear_writeback(folio);
+		ret = folio_xor_flags_has_waiters(folio, 1 << PG_writeback);
 		__xa_clear_mark(&mapping->i_pages, folio_index(folio),
 					PAGECACHE_TAG_WRITEBACK);
 		if (bdi->capabilities & BDI_CAP_WRITEBACK_ACCT) {
@@ -2970,13 +2971,15 @@ void __folio_end_writeback(struct folio
 
 		xa_unlock_irqrestore(&mapping->i_pages, flags);
 	} else {
-		folio_test_clear_writeback(folio);
+		ret = folio_xor_flags_has_waiters(folio, 1 << PG_writeback);
 	}
 
 	lruvec_stat_mod_folio(folio, NR_WRITEBACK, -nr);
 	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
 	node_stat_mod_folio(folio, NR_WRITTEN, nr);
 	folio_memcg_unlock(folio);
+
+	return ret;
 }
 
 bool __folio_start_writeback(struct folio *folio, bool keep_write)
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

