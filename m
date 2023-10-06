Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D77DEE94108
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 19:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbjJFTTc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233433AbjJFTTb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 15:19:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959CBAD
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 12:19:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E91C433C7;
        Fri,  6 Oct 2023 19:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696619966;
        bh=//5P+ccrFFHX2Bn9L1lzPu/o4i36EPFvTvEwui1YEz8=;
        h=Date:To:From:Subject:From;
        b=2arCvIiFjQW6P2lSDei/ar/ujHHndI2tvRABoLAZ1yyZHhPspPn2B1xY+j4ZTYB+y
         6RfAjctdPGAMmFqgPNBf25epbefXhGCgwMgTpqYASNX4g9kgyFF44/5dn4aeltk2lv
         qy2xvnvV98kHm1yUDvJlYTI1208wbxYxMypI5Nds=
Date:   Fri, 06 Oct 2023 12:19:23 -0700
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
Subject: + buffer-use-folio_end_read.patch added to mm-unstable branch
Message-Id: <20231006191925.80E91C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: use folio_end_read()
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-use-folio_end_read.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-use-folio_end_read.patch

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
Subject: buffer: use folio_end_read()
Date: Wed, 4 Oct 2023 17:53:05 +0100

There are two places that we can use this new helper.

Link: https://lkml.kernel.org/r/20231004165317.1061855-6-willy@infradead.org
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

 fs/buffer.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/fs/buffer.c~buffer-use-folio_end_read
+++ a/fs/buffer.c
@@ -282,13 +282,7 @@ static void end_buffer_async_read(struct
 	} while (tmp != bh);
 	spin_unlock_irqrestore(&first->b_uptodate_lock, flags);
 
-	/*
-	 * If all of the buffers are uptodate then we can set the page
-	 * uptodate.
-	 */
-	if (folio_uptodate)
-		folio_mark_uptodate(folio);
-	folio_unlock(folio);
+	folio_end_read(folio, folio_uptodate);
 	return;
 
 still_busy:
@@ -2433,12 +2427,10 @@ int block_read_full_folio(struct folio *
 
 	if (!nr) {
 		/*
-		 * All buffers are uptodate - we can set the folio uptodate
-		 * as well. But not if get_block() returned an error.
+		 * All buffers are uptodate or get_block() returned an
+		 * error when trying to map them - we can finish the read.
 		 */
-		if (!page_error)
-			folio_mark_uptodate(folio);
-		folio_unlock(folio);
+		folio_end_read(folio, !page_error);
 		return 0;
 	}
 
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

