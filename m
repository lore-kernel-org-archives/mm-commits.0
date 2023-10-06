Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 584ACE94104
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 19:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbjJFTUA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233421AbjJFTT7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 15:19:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B389995
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 12:19:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1267C433C8;
        Fri,  6 Oct 2023 19:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696619997;
        bh=ktKYPJcEGmTD4KoUGBa6Nrjw2EJ6+I8IgMzwNfC9dI4=;
        h=Date:To:From:Subject:From;
        b=rUSx9IAQSxw6pvWAIBGq7qv1j9Sn5aKu1tQ73d/j50gsozUizlZQyK8MzKu9jRFG9
         HItc4gjmZUorSMSGK82+rGaQR7ge6FkR8rCjr1XqIajP5v6OwxPg4N35L0xFSYUFuT
         oADOo9OjGAPvm5nqOMV5PSXu72bjsTDEeHhDwG6s=
Date:   Fri, 06 Oct 2023 12:19:54 -0700
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
Subject: + mm-use-folio_xor_flags_has_waiters-in-folio_end_writeback.patch added to mm-unstable branch
Message-Id: <20231006191956.F1267C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use folio_xor_flags_has_waiters() in folio_end_writeback()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-folio_xor_flags_has_waiters-in-folio_end_writeback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-folio_xor_flags_has_waiters-in-folio_end_writeback.patch

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

