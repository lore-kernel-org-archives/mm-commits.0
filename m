Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EAE2E94107
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 19:19:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbjJFTTU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233277AbjJFTTR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 15:19:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C2FB9
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 12:19:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0ADC433CA;
        Fri,  6 Oct 2023 19:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696619951;
        bh=M15LDe8YugbKe+w0dYjCgVNPHy+LZHdshwKZa/A7xG4=;
        h=Date:To:From:Subject:From;
        b=oxZnhYOxD2jbuWAOBPsnjnEnvHczrOzhwvrfLcf376wxlUEsj1HgJh4Qflaro4POg
         UgLi+Ey1lqqrrWRZHhlwTEjq/pCpkfY9uHaPRhL3Lvf+l/aO4FBDzbB13UZ/dwoY3z
         9r2tp7bFBy3h1NvwjlraGvWPo5p04Z09hPMuSqGk=
Date:   Fri, 06 Oct 2023 12:19:08 -0700
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
Subject: + iomap-protect-read_bytes_pending-with-the-state_lock.patch added to mm-unstable branch
Message-Id: <20231006191910.7F0ADC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: iomap: protect read_bytes_pending with the state_lock
has been added to the -mm mm-unstable branch.  Its filename is
     iomap-protect-read_bytes_pending-with-the-state_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/iomap-protect-read_bytes_pending-with-the-state_lock.patch

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
Subject: iomap: protect read_bytes_pending with the state_lock
Date: Wed, 4 Oct 2023 17:53:02 +0100

Perform one atomic operation (acquiring the spinlock) instead of two
(spinlock & atomic_sub) per read completion.

Link: https://lkml.kernel.org/r/20231004165317.1061855-3-willy@infradead.org
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

 fs/iomap/buffered-io.c |   37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

--- a/fs/iomap/buffered-io.c~iomap-protect-read_bytes_pending-with-the-state_lock
+++ a/fs/iomap/buffered-io.c
@@ -29,9 +29,9 @@ typedef int (*iomap_punch_t)(struct inod
  * and I/O completions.
  */
 struct iomap_folio_state {
-	atomic_t		read_bytes_pending;
-	atomic_t		write_bytes_pending;
 	spinlock_t		state_lock;
+	unsigned int		read_bytes_pending;
+	atomic_t		write_bytes_pending;
 
 	/*
 	 * Each block has two bits in this bitmap:
@@ -183,7 +183,7 @@ static void ifs_free(struct folio *folio
 
 	if (!ifs)
 		return;
-	WARN_ON_ONCE(atomic_read(&ifs->read_bytes_pending));
+	WARN_ON_ONCE(ifs->read_bytes_pending != 0);
 	WARN_ON_ONCE(atomic_read(&ifs->write_bytes_pending));
 	WARN_ON_ONCE(ifs_is_fully_uptodate(folio, ifs) !=
 			folio_test_uptodate(folio));
@@ -250,19 +250,29 @@ static void iomap_adjust_read_range(stru
 	*lenp = plen;
 }
 
-static void iomap_finish_folio_read(struct folio *folio, size_t offset,
+static void iomap_finish_folio_read(struct folio *folio, size_t off,
 		size_t len, int error)
 {
 	struct iomap_folio_state *ifs = folio->private;
+	bool uptodate = !error;
+	bool finished = true;
 
-	if (unlikely(error)) {
-		folio_clear_uptodate(folio);
-		folio_set_error(folio);
-	} else {
-		iomap_set_range_uptodate(folio, offset, len);
+	if (ifs) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&ifs->state_lock, flags);
+		if (!error)
+			uptodate = ifs_set_range_uptodate(folio, ifs, off, len);
+		ifs->read_bytes_pending -= len;
+		finished = !ifs->read_bytes_pending;
+		spin_unlock_irqrestore(&ifs->state_lock, flags);
 	}
 
-	if (!ifs || atomic_sub_and_test(len, &ifs->read_bytes_pending))
+	if (error)
+		folio_set_error(folio);
+	if (uptodate)
+		folio_mark_uptodate(folio);
+	if (finished)
 		folio_unlock(folio);
 }
 
@@ -360,8 +370,11 @@ static loff_t iomap_readpage_iter(const
 	}
 
 	ctx->cur_folio_in_bio = true;
-	if (ifs)
-		atomic_add(plen, &ifs->read_bytes_pending);
+	if (ifs) {
+		spin_lock_irq(&ifs->state_lock);
+		ifs->read_bytes_pending += plen;
+		spin_unlock_irq(&ifs->state_lock);
+	}
 
 	sector = iomap_sector(iomap, pos);
 	if (!ctx->bio ||
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

