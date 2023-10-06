Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C16C8E9410B
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 19:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbjJFTTr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233443AbjJFTTp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 15:19:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D723AD
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 12:19:37 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED81BC433C7;
        Fri,  6 Oct 2023 19:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696619977;
        bh=WN4DLZ8staP/eCo+RdUAX/xVg9GLpRBpYdMDzHEp8TY=;
        h=Date:To:From:Subject:From;
        b=djchXUwWwaJ+JrEV8ea3eCSKgeRECx8I/cl3W4VJ7zeH3MHBUyjBvECGqGp6OnHs6
         1VQa9icJPWdG6fySg6rdHLxBdxo6ZeQkF7yrm3osvDBWzsVS/MqfUYoG5M5Uw7N76Z
         kpkwzzdaPQ+qWIr1bniOqw4Gu1VAIqKq2YaYCkXo=
Date:   Fri, 06 Oct 2023 12:19:34 -0700
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
Subject: + powerpc-implement-arch_xor_unlock_is_negative_byte-on-32-bit.patch added to mm-unstable branch
Message-Id: <20231006191936.ED81BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: implement arch_xor_unlock_is_negative_byte on 32-bit
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-implement-arch_xor_unlock_is_negative_byte-on-32-bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-implement-arch_xor_unlock_is_negative_byte-on-32-bit.patch

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

