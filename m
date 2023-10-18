Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00CC0CDB483
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232858AbjJRVhJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235225AbjJRVg2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DCF1BC
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15219C433CA;
        Wed, 18 Oct 2023 21:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664945;
        bh=tHlhBBY0Np9HM76944Ojf0AbLzRoDdZLgQKQsiAy2/k=;
        h=Date:To:From:Subject:From;
        b=gnPoBwm6caBtOGeBZoonT7D9w+SB0jr7I8PcLsJ5JxHikrucsPohFcH+aN+lbZHr4
         crVHw45Vqe06ChvaOyBNqStoKrJwV4DpFGT86iiOlVtnoydUtM1H2qmZrDde3Zo7cm
         B5pMRsmzanBlAt9LbXFURSkG+IeruhQoqcYXd6wU=
Date:   Wed, 18 Oct 2023 14:35:44 -0700
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
Subject: [merged mm-stable] powerpc-implement-arch_xor_unlock_is_negative_byte-on-32-bit.patch removed from -mm tree
Message-Id: <20231018213545.15219C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: powerpc: implement arch_xor_unlock_is_negative_byte on 32-bit
has been removed from the -mm tree.  Its filename was
     powerpc-implement-arch_xor_unlock_is_negative_byte-on-32-bit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: powerpc: implement arch_xor_unlock_is_negative_byte on 32-bit
Date: Wed, 4 Oct 2023 17:53:11 +0100

Simply remove the ifdef.  The assembly is identical to that in the
non-optimised case of test_and_clear_bits() on PPC32, and it's not clear
to me how the PPC32 optimisation works, nor whether it would work for
arch_xor_unlock_is_negative_byte().  If that optimisation would work,
someone can implement it later, but this is more efficient than the
implementation in filemap.c.

Link: https://lkml.kernel.org/r/20231004165317.1061855-12-willy@infradead.org
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

 arch/powerpc/include/asm/bitops.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/powerpc/include/asm/bitops.h~powerpc-implement-arch_xor_unlock_is_negative_byte-on-32-bit
+++ a/arch/powerpc/include/asm/bitops.h
@@ -233,7 +233,6 @@ static inline int arch_test_and_change_b
 	return test_and_change_bits(BIT_MASK(nr), addr + BIT_WORD(nr)) != 0;
 }
 
-#ifdef CONFIG_PPC64
 static inline bool arch_xor_unlock_is_negative_byte(unsigned long mask,
 		volatile unsigned long *p)
 {
@@ -251,11 +250,8 @@ static inline bool arch_xor_unlock_is_ne
 
 	return (old & BIT_MASK(7)) != 0;
 }
-
 #define arch_xor_unlock_is_negative_byte arch_xor_unlock_is_negative_byte
 
-#endif /* CONFIG_PPC64 */
-
 #include <asm-generic/bitops/non-atomic.h>
 
 static inline void arch___clear_bit_unlock(int nr, volatile unsigned long *addr)
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

