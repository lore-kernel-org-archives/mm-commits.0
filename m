Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63A51E94108
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 19:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbjJFTTq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233440AbjJFTTp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 15:19:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804EAB6
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 12:19:40 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16F2C433C8;
        Fri,  6 Oct 2023 19:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696619980;
        bh=WDDJfExVbiq3Si6S/U2nRkoP04r7FaIPQFzoHYEKxHY=;
        h=Date:To:From:Subject:From;
        b=Iu3/UG057lfmOHOrnNrvOweEY3gnnWA8BuYYD8P/5mh7+cukWxU6k8pEXBfNf/3ye
         TxH8kiAvmclxpotY7j2Y96H+G8feLjVXQ/Rlz2v74erdbMmzCMBuQmKSzwhQMgSIoc
         PNyk0HY6Nxm+T8+ZGDAW2DAh1goGohEdKMexA/Dw=
Date:   Fri, 06 Oct 2023 12:19:37 -0700
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
Subject: + mips-implement-xor_unlock_is_negative_byte.patch added to mm-unstable branch
Message-Id: <20231006191939.D16F2C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips: implement xor_unlock_is_negative_byte
has been added to the -mm mm-unstable branch.  Its filename is
     mips-implement-xor_unlock_is_negative_byte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-implement-xor_unlock_is_negative_byte.patch

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

