From: akpm@linux-foundation.org
Subject: + dma-apitxt-remove-dma_sync_single_range-description.patch added to -mm tree
Date: Thu, 04 Feb 2010 10:28:41 -0800
Message-ID: <201002041828.o14ISf3E014030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757313Ab0BDS3G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2010 13:29:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@suse.de, davem@davemloft.net


The patch titled
     DMA-API.txt: remove dma_sync_single_range description
has been added to the -mm tree.  Its filename is
     dma-apitxt-remove-dma_sync_single_range-description.patch

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
Subject: DMA-API.txt: remove dma_sync_single_range description
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

dma_sync_single_for_cpu/for_device supports a partial sync so there is no
point to have dma_sync_single_range (also dma_sync_single was obsoleted
long ago, replaced with dma_sync_single_for_cpu/for_device).

There is no user of dma_sync_single_range() in mainline and only Alpha
architecture supports dma_sync_single_range().  So it's unlikely that
someone out of the tree uses it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: David Miller <davem@davemloft.net>
Acked-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API.txt |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN Documentation/DMA-API.txt~dma-apitxt-remove-dma_sync_single_range-description Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~dma-apitxt-remove-dma_sync_single_range-description
+++ a/Documentation/DMA-API.txt
@@ -528,16 +528,6 @@ into the width returned by this call.  I
 of two for easy alignment.
 
 void
-dma_sync_single_range(struct device *dev, dma_addr_t dma_handle,
-		      unsigned long offset, size_t size,
-		      enum dma_data_direction direction)
-
-Does a partial sync, starting at offset and continuing for size.  You
-must be careful to observe the cache alignment and width when doing
-anything like this.  You must also be extra careful about accessing
-memory you intend to sync partially.
