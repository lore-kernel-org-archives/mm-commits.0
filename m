Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C27E94107
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 19:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbjJFTT4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbjJFTTv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 15:19:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13435A6
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 12:19:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B5CC433C8;
        Fri,  6 Oct 2023 19:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696619988;
        bh=m/oxeO3sbxzOVqiBc9L/vu2XBYpVDvF2EP0Fi8GZ4vw=;
        h=Date:To:From:Subject:From;
        b=mj1GcJM1s7gufGagWc43Bv2d3vMJ8auWJSyEwuaMEcwtzQhDgA8pyCXDPamcTZY9V
         XBT9BZPHiQ8jZzPYUjP5+BJBd/SbuG7U7eT9+YYJ/+5l8Wu8tknyP9cYt/OgSulzMd
         H4o/d+wO6Jtazddfy8uwj5NytkYk+qCAOKOW7ccE=
Date:   Fri, 06 Oct 2023 12:19:46 -0700
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
Subject: + mm-delete-checks-for-xor_unlock_is_negative_byte.patch added to mm-unstable branch
Message-Id: <20231006191948.48B5CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: delete checks for xor_unlock_is_negative_byte()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-delete-checks-for-xor_unlock_is_negative_byte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-delete-checks-for-xor_unlock_is_negative_byte.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch
mm-call-wp_page_copy-under-the-vma-lock.patch
mm-handle-shared-faults-under-the-vma-lock.patch
mm-handle-cow-faults-under-the-vma-lock.patch
mm-handle-read-faults-under-the-vma-lock.patch
mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch
iomap-hold-state_lock-over-call-to-ifs_set_range_uptodate.patch
iomap-protect-read_bytes_pending-with-the-state_lock.patch
mm-add-folio_end_read.patch
ext4-use-folio_end_read.patch
buffer-use-folio_end_read.patch
iomap-use-folio_end_read.patch
bitops-add-xor_unlock_is_negative_byte.patch
alpha-implement-xor_unlock_is_negative_byte.patch
m68k-implement-xor_unlock_is_negative_byte.patch
mips-implement-xor_unlock_is_negative_byte.patch
powerpc-implement-arch_xor_unlock_is_negative_byte-on-32-bit.patch
riscv-implement-xor_unlock_is_negative_byte.patch
s390-implement-arch_xor_unlock_is_negative_byte.patch
mm-delete-checks-for-xor_unlock_is_negative_byte.patch
mm-add-folio_xor_flags_has_waiters.patch
mm-make-__end_folio_writeback-return-void.patch
mm-use-folio_xor_flags_has_waiters-in-folio_end_writeback.patch

