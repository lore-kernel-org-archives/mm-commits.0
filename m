From: akpm@linux-foundation.org
Subject: + dma-mapping-parisc-set-arch_dma_minalign.patch added to -mm tree
Date: Thu, 08 Jul 2010 12:53:34 -0700
Message-ID: <201007081953.o68JrYnc025253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758557Ab0GHTyS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jul 2010 15:54:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, deller@gmx.de, jejb@parisc-linux.org, kyle@mcmartin.ca, linux-arch@vger.kernel.org


The patch titled
     dma-mapping: parisc: set ARCH_DMA_MINALIGN
has been added to the -mm tree.  Its filename is
     dma-mapping-parisc-set-arch_dma_minalign.patch

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
Subject: dma-mapping: parisc: set ARCH_DMA_MINALIGN
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Architectures that handle DMA-non-coherent memory need to set
ARCH_DMA_MINALIGN to make sure that kmalloc'ed buffer is DMA-safe: the
buffer doesn't share a cache with the others.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/asm/cache.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/parisc/include/asm/cache.h~dma-mapping-parisc-set-arch_dma_minalign arch/parisc/include/asm/cache.h
--- a/arch/parisc/include/asm/cache.h~dma-mapping-parisc-set-arch_dma_minalign
+++ a/arch/parisc/include/asm/cache.h
@@ -28,6 +28,8 @@
 
 #define SMP_CACHE_BYTES L1_CACHE_BYTES
 
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
+
 #define __read_mostly __attribute__((__section__(".data..read_mostly")))
 
 void parisc_cache_init(void);	/* initializes cache-flushing */
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign.patch
dma-mapping-unify-dma_get_cache_alignment-implementations.patch
dma-mapping-parisc-set-arch_dma_minalign.patch

