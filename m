Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA0F7E9410B
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 19:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbjJFTT6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233451AbjJFTTz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 15:19:55 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A4EB6
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 12:19:54 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A667C433C9;
        Fri,  6 Oct 2023 19:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696619994;
        bh=eAuxXN6O6082xNG5SPzI1PaoFKmLcLSld3swuGvgGlM=;
        h=Date:To:From:Subject:From;
        b=xWN+IhI6yyCzy+r9Ore0EuhPt1RDxZ4QGURxfcNR/0SFUC2No0feJdqdAPAHSrsUA
         Nrapd5t39NVjLUphLpMoTa1x0e6mo/HU4prGSbyUzaGicON9UEgMgHdqWWWlGxfGgK
         TECBVmzpbr+G+n1hFSBGFZ/mfStVvEL3lub+T0zw=
Date:   Fri, 06 Oct 2023 12:19:52 -0700
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
Subject: + mm-add-folio_xor_flags_has_waiters.patch added to mm-unstable branch
Message-Id: <20231006191954.1A667C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add folio_xor_flags_has_waiters()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-folio_xor_flags_has_waiters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-folio_xor_flags_has_waiters.patch

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

