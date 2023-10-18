Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 968F4CDB483
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbjJRVhN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235228AbjJRVgv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217331A5
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF25FC433CA;
        Wed, 18 Oct 2023 21:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664948;
        bh=+So8KVql+qH31xZipBI3pQQd/18vIaYDvD9RYSjihLI=;
        h=Date:To:From:Subject:From;
        b=CcxmzriYjET6DKkc2jhCE98/zmEhjkkPKoXQmcXNMmwMN/L0aLVcETqS1RpHf+NWi
         JnBlPpKr28AhqOY25EwX6Qwoi2/aM7RRHPogH6AMPbHVfOvfVEh/mXcDb8BTJtO9M7
         En/RsfcNHNkvbpNuyjVJ+MzXuPGDUaH5a6prGWnA=
Date:   Wed, 18 Oct 2023 14:35:47 -0700
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
Subject: [merged mm-stable] mm-delete-checks-for-xor_unlock_is_negative_byte.patch removed from -mm tree
Message-Id: <20231018213547.DF25FC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: delete checks for xor_unlock_is_negative_byte()
has been removed from the -mm tree.  Its filename was
     mm-delete-checks-for-xor_unlock_is_negative_byte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: delete checks for xor_unlock_is_negative_byte()
Date: Wed, 4 Oct 2023 17:53:14 +0100

Architectures which don't define their own use the one in
asm-generic/bitops/lock.h.  Get rid of all the ifdefs around "maybe we
don't have it".

Link: https://lkml.kernel.org/r/20231004165317.1061855-15-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
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

 arch/alpha/include/asm/bitops.h                |    1 
 arch/m68k/include/asm/bitops.h                 |    1 
 arch/mips/include/asm/bitops.h                 |    1 
 arch/riscv/include/asm/bitops.h                |    1 
 include/asm-generic/bitops/instrumented-lock.h |    5 --
 include/asm-generic/bitops/lock.h              |    1 
 kernel/kcsan/kcsan_test.c                      |    3 -
 kernel/kcsan/selftest.c                        |    3 -
 mm/filemap.c                                   |   30 ---------------
 mm/kasan/kasan_test.c                          |    3 -
 10 files changed, 1 insertion(+), 48 deletions(-)

--- a/arch/alpha/include/asm/bitops.h~mm-delete-checks-for-xor_unlock_is_negative_byte
+++ a/arch/alpha/include/asm/bitops.h
@@ -305,7 +305,6 @@ static inline bool xor_unlock_is_negativ
 
 	return (old & BIT(7)) != 0;
 }
-#define xor_unlock_is_negative_byte xor_unlock_is_negative_byte
 
 /*
  * ffz = Find First Zero in word. Undefined if no zero exists,
--- a/arch/m68k/include/asm/bitops.h~mm-delete-checks-for-xor_unlock_is_negative_byte
+++ a/arch/m68k/include/asm/bitops.h
@@ -339,7 +339,6 @@ static inline bool xor_unlock_is_negativ
 	return result;
 #endif
 }
-#define xor_unlock_is_negative_byte xor_unlock_is_negative_byte
 
 /*
  *	The true 68020 and more advanced processors support the "bfffo"
--- a/arch/mips/include/asm/bitops.h~mm-delete-checks-for-xor_unlock_is_negative_byte
+++ a/arch/mips/include/asm/bitops.h
@@ -301,7 +301,6 @@ static inline bool xor_unlock_is_negativ
 
 	return res;
 }
-#define xor_unlock_is_negative_byte xor_unlock_is_negative_byte
 
 #undef __bit_op
 #undef __test_bit_op
--- a/arch/riscv/include/asm/bitops.h~mm-delete-checks-for-xor_unlock_is_negative_byte
+++ a/arch/riscv/include/asm/bitops.h
@@ -202,7 +202,6 @@ static inline bool xor_unlock_is_negativ
 		: "memory");
 	return (res & BIT(7)) != 0;
 }
-#define xor_unlock_is_negative_byte xor_unlock_is_negative_byte
 
 #undef __test_and_op_bit
 #undef __op_bit
--- a/include/asm-generic/bitops/instrumented-lock.h~mm-delete-checks-for-xor_unlock_is_negative_byte
+++ a/include/asm-generic/bitops/instrumented-lock.h
@@ -58,7 +58,6 @@ static inline bool test_and_set_bit_lock
 	return arch_test_and_set_bit_lock(nr, addr);
 }
 
-#if defined(arch_xor_unlock_is_negative_byte)
 /**
  * xor_unlock_is_negative_byte - XOR a single byte in memory and test if
  * it is negative, for unlock.
@@ -80,8 +79,4 @@ static inline bool xor_unlock_is_negativ
 	instrument_atomic_write(addr, sizeof(long));
 	return arch_xor_unlock_is_negative_byte(mask, addr);
 }
-/* Let everybody know we have it. */
-#define xor_unlock_is_negative_byte xor_unlock_is_negative_byte
-#endif
-
 #endif /* _ASM_GENERIC_BITOPS_INSTRUMENTED_LOCK_H */
--- a/include/asm-generic/bitops/lock.h~mm-delete-checks-for-xor_unlock_is_negative_byte
+++ a/include/asm-generic/bitops/lock.h
@@ -75,7 +75,6 @@ static inline bool arch_xor_unlock_is_ne
 	old = raw_atomic_long_fetch_xor_release(mask, (atomic_long_t *)p);
 	return !!(old & BIT(7));
 }
-#define arch_xor_unlock_is_negative_byte arch_xor_unlock_is_negative_byte
 #endif
 
 #include <asm-generic/bitops/instrumented-lock.h>
--- a/kernel/kcsan/kcsan_test.c~mm-delete-checks-for-xor_unlock_is_negative_byte
+++ a/kernel/kcsan/kcsan_test.c
@@ -699,12 +699,9 @@ static void test_barrier_nothreads(struc
 	KCSAN_EXPECT_RW_BARRIER(spin_unlock(&test_spinlock), true);
 	KCSAN_EXPECT_RW_BARRIER(mutex_lock(&test_mutex), false);
 	KCSAN_EXPECT_RW_BARRIER(mutex_unlock(&test_mutex), true);
-
-#ifdef xor_unlock_is_negative_byte
 	KCSAN_EXPECT_READ_BARRIER(xor_unlock_is_negative_byte(1, &test_var), true);
 	KCSAN_EXPECT_WRITE_BARRIER(xor_unlock_is_negative_byte(1, &test_var), true);
 	KCSAN_EXPECT_RW_BARRIER(xor_unlock_is_negative_byte(1, &test_var), true);
-#endif
 	kcsan_nestable_atomic_end();
 }
 
--- a/kernel/kcsan/selftest.c~mm-delete-checks-for-xor_unlock_is_negative_byte
+++ a/kernel/kcsan/selftest.c
@@ -227,12 +227,9 @@ static bool __init test_barrier(void)
 	KCSAN_CHECK_RW_BARRIER(arch_spin_unlock(&arch_spinlock));
 	spin_lock(&test_spinlock);
 	KCSAN_CHECK_RW_BARRIER(spin_unlock(&test_spinlock));
-
-#ifdef xor_unlock_is_negative_byte
 	KCSAN_CHECK_RW_BARRIER(xor_unlock_is_negative_byte(1, &test_var));
 	KCSAN_CHECK_READ_BARRIER(xor_unlock_is_negative_byte(1, &test_var));
 	KCSAN_CHECK_WRITE_BARRIER(xor_unlock_is_negative_byte(1, &test_var));
-#endif
 	kcsan_nestable_atomic_end();
 
 	return ret;
--- a/mm/filemap.c~mm-delete-checks-for-xor_unlock_is_negative_byte
+++ a/mm/filemap.c
@@ -1482,34 +1482,6 @@ void folio_add_wait_queue(struct folio *
 }
 EXPORT_SYMBOL_GPL(folio_add_wait_queue);
 
-#ifdef xor_unlock_is_negative_byte
-#define clear_bit_unlock_is_negative_byte(nr, p)	\
-	xor_unlock_is_negative_byte(1 << nr, p)
-#endif
-
-#ifndef clear_bit_unlock_is_negative_byte
-
-/*
- * PG_waiters is the high bit in the same byte as PG_lock.
- *
- * On x86 (and on many other architectures), we can clear PG_lock and
- * test the sign bit at the same time. But if the architecture does
- * not support that special operation, we just do this all by hand
- * instead.
- *
- * The read of PG_waiters has to be after (or concurrently with) PG_locked
- * being cleared, but a memory barrier should be unnecessary since it is
- * in the same byte as PG_locked.
- */
-static inline bool clear_bit_unlock_is_negative_byte(long nr, volatile void *mem)
-{
-	clear_bit_unlock(nr, mem);
-	/* smp_mb__after_atomic(); */
-	return test_bit(PG_waiters, mem);
-}
-
-#endif
-
 /**
  * folio_unlock - Unlock a locked folio.
  * @folio: The folio.
@@ -1525,7 +1497,7 @@ void folio_unlock(struct folio *folio)
 	BUILD_BUG_ON(PG_waiters != 7);
 	BUILD_BUG_ON(PG_locked > 7);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
-	if (clear_bit_unlock_is_negative_byte(PG_locked, folio_flags(folio, 0)))
+	if (xor_unlock_is_negative_byte(1 << PG_locked, folio_flags(folio, 0)))
 		folio_wake_bit(folio, PG_locked);
 }
 EXPORT_SYMBOL(folio_unlock);
--- a/mm/kasan/kasan_test.c~mm-delete-checks-for-xor_unlock_is_negative_byte
+++ a/mm/kasan/kasan_test.c
@@ -1098,12 +1098,9 @@ static void kasan_bitops_test_and_modify
 	KUNIT_EXPECT_KASAN_FAIL(test, test_and_change_bit(nr, addr));
 	KUNIT_EXPECT_KASAN_FAIL(test, __test_and_change_bit(nr, addr));
 	KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result = test_bit(nr, addr));
-
-#if defined(xor_unlock_is_negative_byte)
 	if (nr < 7)
 		KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result =
 				xor_unlock_is_negative_byte(1 << nr, addr));
-#endif
 }
 
 static void kasan_bitops_generic(struct kunit *test)
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

