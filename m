Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F53CDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344747AbjJRVhT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235310AbjJRVgv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056B31AB
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:50 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D07C433CB;
        Wed, 18 Oct 2023 21:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664949;
        bh=2TjwIJTVoAVZF63YFrS408FuCV9BWrg/6HnssSro1zU=;
        h=Date:To:From:Subject:From;
        b=yq/HuYHWKoM6TIbrplxXBEZkNxgxlt6sVFIg3apNUWoaOnMVdBRJ5+DZVWS5HVKGR
         +1Qg3CyG/x0552CZTv1zi2IFf09al0BhOButit4E7WMpW72509NldC4LdGGHKMWbZ1
         OA3qU2Igb9u0cmzWjDbnLKWbsSEq2+WfDlgPwSmw=
Date:   Wed, 18 Oct 2023 14:35:49 -0700
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
Subject: [merged mm-stable] mm-make-__end_folio_writeback-return-void.patch removed from -mm tree
Message-Id: <20231018213549.C6D07C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: make __end_folio_writeback() return void
has been removed from the -mm tree.  Its filename was
     mm-make-__end_folio_writeback-return-void.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: make __end_folio_writeback() return void
Date: Wed, 4 Oct 2023 17:53:16 +0100

Rather than check the result of test-and-clear, just check that we have
the writeback bit set at the start.  This wouldn't catch every case, but
it's good enough (and enables the next patch).

Link: https://lkml.kernel.org/r/20231004165317.1061855-17-willy@infradead.org
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

 mm/filemap.c        |    9 +++++++--
 mm/internal.h       |    2 +-
 mm/page-writeback.c |   38 ++++++++++++++++----------------------
 3 files changed, 24 insertions(+), 25 deletions(-)

--- a/mm/filemap.c~mm-make-__end_folio_writeback-return-void
+++ a/mm/filemap.c
@@ -1593,9 +1593,15 @@ EXPORT_SYMBOL(folio_wait_private_2_killa
 /**
  * folio_end_writeback - End writeback against a folio.
  * @folio: The folio.
+ *
+ * The folio must actually be under writeback.
+ *
+ * Context: May be called from process or interrupt context.
  */
 void folio_end_writeback(struct folio *folio)
 {
+	VM_BUG_ON_FOLIO(!folio_test_writeback(folio), folio);
+
 	/*
 	 * folio_test_clear_reclaim() could be used here but it is an
 	 * atomic operation and overkill in this particular case. Failing
@@ -1615,8 +1621,7 @@ void folio_end_writeback(struct folio *f
 	 * reused before the folio_wake().
 	 */
 	folio_get(folio);
-	if (!__folio_end_writeback(folio))
-		BUG();
+	__folio_end_writeback(folio);
 
 	smp_mb__after_atomic();
 	folio_wake(folio, PG_writeback);
--- a/mm/internal.h~mm-make-__end_folio_writeback-return-void
+++ a/mm/internal.h
@@ -105,7 +105,7 @@ static inline void wake_throttle_isolate
 
 vm_fault_t do_swap_page(struct vm_fault *vmf);
 void folio_rotate_reclaimable(struct folio *folio);
-bool __folio_end_writeback(struct folio *folio);
+void __folio_end_writeback(struct folio *folio);
 void deactivate_file_folio(struct folio *folio);
 void folio_activate(struct folio *folio);
 
--- a/mm/page-writeback.c~mm-make-__end_folio_writeback-return-void
+++ a/mm/page-writeback.c
@@ -2940,11 +2940,10 @@ static void wb_inode_writeback_end(struc
 	spin_unlock_irqrestore(&wb->work_lock, flags);
 }
 
-bool __folio_end_writeback(struct folio *folio)
+void __folio_end_writeback(struct folio *folio)
 {
 	long nr = folio_nr_pages(folio);
 	struct address_space *mapping = folio_mapping(folio);
-	bool ret;
 
 	folio_memcg_lock(folio);
 	if (mapping && mapping_use_writeback_tags(mapping)) {
@@ -2953,19 +2952,16 @@ bool __folio_end_writeback(struct folio
 		unsigned long flags;
 
 		xa_lock_irqsave(&mapping->i_pages, flags);
-		ret = folio_test_clear_writeback(folio);
-		if (ret) {
-			__xa_clear_mark(&mapping->i_pages, folio_index(folio),
-						PAGECACHE_TAG_WRITEBACK);
-			if (bdi->capabilities & BDI_CAP_WRITEBACK_ACCT) {
-				struct bdi_writeback *wb = inode_to_wb(inode);
-
-				wb_stat_mod(wb, WB_WRITEBACK, -nr);
-				__wb_writeout_add(wb, nr);
-				if (!mapping_tagged(mapping,
-						    PAGECACHE_TAG_WRITEBACK))
-					wb_inode_writeback_end(wb);
-			}
+		folio_test_clear_writeback(folio);
+		__xa_clear_mark(&mapping->i_pages, folio_index(folio),
+					PAGECACHE_TAG_WRITEBACK);
+		if (bdi->capabilities & BDI_CAP_WRITEBACK_ACCT) {
+			struct bdi_writeback *wb = inode_to_wb(inode);
+
+			wb_stat_mod(wb, WB_WRITEBACK, -nr);
+			__wb_writeout_add(wb, nr);
+			if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
+				wb_inode_writeback_end(wb);
 		}
 
 		if (mapping->host && !mapping_tagged(mapping,
@@ -2974,15 +2970,13 @@ bool __folio_end_writeback(struct folio
 
 		xa_unlock_irqrestore(&mapping->i_pages, flags);
 	} else {
-		ret = folio_test_clear_writeback(folio);
-	}
-	if (ret) {
-		lruvec_stat_mod_folio(folio, NR_WRITEBACK, -nr);
-		zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
-		node_stat_mod_folio(folio, NR_WRITTEN, nr);
+		folio_test_clear_writeback(folio);
 	}
+
+	lruvec_stat_mod_folio(folio, NR_WRITEBACK, -nr);
+	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
+	node_stat_mod_folio(folio, NR_WRITTEN, nr);
 	folio_memcg_unlock(folio);
-	return ret;
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

