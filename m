From: akpm@linux-foundation.org
Subject: + sparc64-add-missing-dma_get_cache_alignment.patch added to -mm tree
Date: Tue, 31 Jul 2007 00:30:15 -0700
Message-ID: <200707310734.l6V7YvlW021775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50786 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191AbXGaHfG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 03:35:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davem@davemloft.net


The patch titled
     sparc64: add missing dma_get_cache_alignment()
has been added to the -mm tree.  Its filename is
     sparc64-add-missing-dma_get_cache_alignment.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sparc64: add missing dma_get_cache_alignment()
From: Andrew Morton <akpm@linux-foundation.org>

drivers/infiniband/hw/mthca/mthca_main.c: In function `mthca_init_icm':
drivers/infiniband/hw/mthca/mthca_main.c:468: error: implicit declaration of function `dma_get_cache_alignment'

Pinch the one from asm-generic/dma-mapping.h

Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-sparc64/dma-mapping.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN include/asm-sparc64/dma-mapping.h~sparc64-add-missing-dma_get_cache_alignment include/asm-sparc64/dma-mapping.h
--- a/include/asm-sparc64/dma-mapping.h~sparc64-add-missing-dma_get_cache_alignment
+++ a/include/asm-sparc64/dma-mapping.h
@@ -127,6 +127,13 @@ static inline int dma_mapping_error(dma_
 	return (dma_addr == DMA_ERROR_CODE);
 }
 
+static inline int dma_get_cache_alignment(void)
+{
+	/* no easy way to get cache size on all processors, so return
+	 * the maximum possible, to be safe */
+	return (1 << INTERNODE_CACHE_SHIFT);
+}
+
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 #define dma_is_consistent(d, h)	(1)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
parport_pc-locking-fix.patch
revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
kdebugh-forward-declare-struct-struct-notifier_block.patch
fs-9p-convc-error-path-fix.patch
ip2main-warning-fix.patch
sparc64-add-missing-dma_get_cache_alignment.patch
