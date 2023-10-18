Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F070CDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235265AbjJRVhJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbjJRVg2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC181AC
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337D1C433C8;
        Wed, 18 Oct 2023 21:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664944;
        bh=v9PFO4UQ1LBBEymwLXRpKbjMMBk1Za59T5TH36f7AI8=;
        h=Date:To:From:Subject:From;
        b=Lkgryv8cb0U0ZWLG7KXvfugRytu8dFfctIf+mpAfpmtX/Q9FXmETOQRCGniGmMpbF
         B7iji9vYSIrZZtAs/+iuRDRtCMPZNtLCd5T/+IdOI18TzujNWxBDgIsrwa1LkBCdEn
         drEOGn8lodExrg9PjhMOdTDiFnh3SUDZcosqbBkU=
Date:   Wed, 18 Oct 2023 14:35:43 -0700
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
Subject: [merged mm-stable] mips-implement-xor_unlock_is_negative_byte.patch removed from -mm tree
Message-Id: <20231018213544.337D1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mips: implement xor_unlock_is_negative_byte
has been removed from the -mm tree.  Its filename was
     mips-implement-xor_unlock_is_negative_byte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mips: implement xor_unlock_is_negative_byte
Date: Wed, 4 Oct 2023 17:53:10 +0100

Inspired by the mips test_and_change_bit(), this will surely be more
efficient than the generic one defined in filemap.c

Link: https://lkml.kernel.org/r/20231004165317.1061855-11-willy@infradead.org
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

 arch/mips/include/asm/bitops.h |   26 +++++++++++++++++++++++++-
 arch/mips/lib/bitops.c         |   14 ++++++++++++++
 2 files changed, 39 insertions(+), 1 deletion(-)

--- a/arch/mips/include/asm/bitops.h~mips-implement-xor_unlock_is_negative_byte
+++ a/arch/mips/include/asm/bitops.h
@@ -73,7 +73,8 @@ int __mips_test_and_clear_bit(unsigned l
 			      volatile unsigned long *addr);
 int __mips_test_and_change_bit(unsigned long nr,
 			       volatile unsigned long *addr);
-
+bool __mips_xor_is_negative_byte(unsigned long mask,
+		volatile unsigned long *addr);
 
 /*
  * set_bit - Atomically set a bit in memory
@@ -279,6 +280,29 @@ static inline int test_and_change_bit(un
 	return res;
 }
 
+static inline bool xor_unlock_is_negative_byte(unsigned long mask,
+		volatile unsigned long *p)
+{
+	unsigned long orig;
+	bool res;
+
+	smp_mb__before_atomic();
+
+	if (!kernel_uses_llsc) {
+		res = __mips_xor_is_negative_byte(mask, p);
+	} else {
+		orig = __test_bit_op(*p, "%0",
+				     "xor\t%1, %0, %3",
+				     "ir"(mask));
+		res = (orig & BIT(7)) != 0;
+	}
+
+	smp_llsc_mb();
+
+	return res;
+}
+#define xor_unlock_is_negative_byte xor_unlock_is_negative_byte
+
 #undef __bit_op
 #undef __test_bit_op
 
--- a/arch/mips/lib/bitops.c~mips-implement-xor_unlock_is_negative_byte
+++ a/arch/mips/lib/bitops.c
@@ -146,3 +146,17 @@ int __mips_test_and_change_bit(unsigned
 	return res;
 }
 EXPORT_SYMBOL(__mips_test_and_change_bit);
+
+bool __mips_xor_is_negative_byte(unsigned long mask,
+		volatile unsigned long *addr)
+{
+	unsigned long flags;
+	unsigned long data;
+
+	raw_local_irq_save(flags);
+	data = *addr;
+	*addr = data ^ mask;
+	raw_local_irq_restore(flags);
+
+	return (data & BIT(7)) != 0;
+}
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

