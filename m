Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6253CC46CA1
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235250AbjJRVhO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235252AbjJRVgv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21961D48
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6D1C433C8;
        Wed, 18 Oct 2023 21:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664948;
        bh=HKg+AC4N6MPpH9BThFNG7fCxjR2hCBD5uYH1C9AlNXs=;
        h=Date:To:From:Subject:From;
        b=laotFj5o5hmSraSiznF4Dj4TFoY0DhoM0ndVOmxBCRUkG7J+gswyhNHmiNr5hLa+A
         nKIhU8xU8mkPpia/2zg6u/kxNImJv9Rx7o0rf/YJYE+OBIUQC1lUR1Clg4DecD+sP/
         IyThDIB094Plmm2VtEUggw5ZGFmR32r1+U6p743A=
Date:   Wed, 18 Oct 2023 14:35:48 -0700
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
Subject: [merged mm-stable] mm-add-folio_xor_flags_has_waiters.patch removed from -mm tree
Message-Id: <20231018213548.CF6D1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add folio_xor_flags_has_waiters()
has been removed from the -mm tree.  Its filename was
     mm-add-folio_xor_flags_has_waiters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add folio_xor_flags_has_waiters()
Date: Wed, 4 Oct 2023 17:53:15 +0100

Optimise folio_end_read() by setting the uptodate bit at the same time we
clear the unlock bit.  This saves at least one memory barrier and one
write-after-write hazard.

Link: https://lkml.kernel.org/r/20231004165317.1061855-16-willy@infradead.org
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

 include/linux/page-flags.h |   19 +++++++++++++++++++
 mm/filemap.c               |   14 +++++++++++---
 2 files changed, 30 insertions(+), 3 deletions(-)

--- a/include/linux/page-flags.h~mm-add-folio_xor_flags_has_waiters
+++ a/include/linux/page-flags.h
@@ -693,6 +693,25 @@ TESTPAGEFLAG_FALSE(Ksm, ksm)
 u64 stable_page_flags(struct page *page);
 
 /**
+ * folio_xor_flags_has_waiters - Change some folio flags.
+ * @folio: The folio.
+ * @mask: Bits set in this word will be changed.
+ *
+ * This must only be used for flags which are changed with the folio
+ * lock held.  For example, it is unsafe to use for PG_dirty as that
+ * can be set without the folio lock held.  It can also only be used
+ * on flags which are in the range 0-6 as some of the implementations
+ * only affect those bits.
+ *
+ * Return: Whether there are tasks waiting on the folio.
+ */
+static inline bool folio_xor_flags_has_waiters(struct folio *folio,
+		unsigned long mask)
+{
+	return xor_unlock_is_negative_byte(mask, folio_flags(folio, 0));
+}
+
+/**
  * folio_test_uptodate - Is this folio up to date?
  * @folio: The folio.
  *
--- a/mm/filemap.c~mm-add-folio_xor_flags_has_waiters
+++ a/mm/filemap.c
@@ -1497,7 +1497,7 @@ void folio_unlock(struct folio *folio)
 	BUILD_BUG_ON(PG_waiters != 7);
 	BUILD_BUG_ON(PG_locked > 7);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
-	if (xor_unlock_is_negative_byte(1 << PG_locked, folio_flags(folio, 0)))
+	if (folio_xor_flags_has_waiters(folio, 1 << PG_locked))
 		folio_wake_bit(folio, PG_locked);
 }
 EXPORT_SYMBOL(folio_unlock);
@@ -1518,9 +1518,17 @@ EXPORT_SYMBOL(folio_unlock);
  */
 void folio_end_read(struct folio *folio, bool success)
 {
+	unsigned long mask = 1 << PG_locked;
+
+	/* Must be in bottom byte for x86 to work */
+	BUILD_BUG_ON(PG_uptodate > 7);
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+	VM_BUG_ON_FOLIO(folio_test_uptodate(folio), folio);
+
 	if (likely(success))
-		folio_mark_uptodate(folio);
-	folio_unlock(folio);
+		mask |= 1 << PG_uptodate;
+	if (folio_xor_flags_has_waiters(folio, mask))
+		folio_wake_bit(folio, PG_locked);
 }
 EXPORT_SYMBOL(folio_end_read);
 
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

