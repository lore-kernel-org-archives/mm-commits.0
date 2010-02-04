From: akpm@linux-foundation.org
Subject: + um-remove-dma_sync_single_range.patch added to -mm tree
Date: Thu, 04 Feb 2010 10:28:47 -0800
Message-ID: <201002041828.o14ISlgb014036@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757476Ab0BDSa3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2010 13:30:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net, jdike@addtoit.com


The patch titled
     um: remove dma_sync_single_range
has been added to the -mm tree.  Its filename is
     um-remove-dma_sync_single_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: remove dma_sync_single_range
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

dma_sync_single_for_cpu/for_device supports a partial sync so there is no
point to have dma_sync_single_range (also dma_sync_single was obsoleted
long ago, replaced with dma_sync_single_for_cpu/for_device).

There is no user of dma_sync_single_range() in mainline and only Alpha
architecture supports dma_sync_single_range().  So it's unlikely that
someone out of the tree uses it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeff Dike <jdike@addtoit.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/dma-mapping.h |    8 --------
 1 file changed, 8 deletions(-)

diff -puN arch/um/include/asm/dma-mapping.h~um-remove-dma_sync_single_range arch/um/include/asm/dma-mapping.h
--- a/arch/um/include/asm/dma-mapping.h~um-remove-dma_sync_single_range
+++ a/arch/um/include/asm/dma-mapping.h
@@ -104,14 +104,6 @@ dma_get_cache_alignment(void)
 }
 
 static inline void
-dma_sync_single_range(struct device *dev, dma_addr_t dma_handle,
-		      unsigned long offset, size_t size,
-		      enum dma_data_direction direction)
-{
-	BUG();
-}
