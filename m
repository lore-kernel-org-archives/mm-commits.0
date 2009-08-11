From: akpm@linux-foundation.org
Subject: [merged] asm-generic-remove-calling-flush_write_buffers-in-dma_sync__for_cpu.patch removed from -mm tree
Date: Tue, 11 Aug 2009 12:58:20 -0700
Message-ID: <200908111958.n7BJwKEg022823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752740AbZHKUA2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Aug 2009 16:00:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tom.leiming@gmail.com, arnd@arndb.de, fujita.tomonori@lab.ntt.co.jp, joerg.roedel@amd.com, mm-commits@vger.kernel.org


The patch titled
     asm-generic: remove calling flush_write_buffers() in dma_sync_*_for_cpu
has been removed from the -mm tree.  Its filename was
     asm-generic-remove-calling-flush_write_buffers-in-dma_sync__for_cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asm-generic: remove calling flush_write_buffers() in dma_sync_*_for_cpu
From: Ming Lei <tom.leiming@gmail.com>

dma_sync_*_for_cpu() is introduced to make cpu access dma buffers safely when
dma transfer is over, it seems there is nothing to do with cpu write buffer,
so remove it.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/dma-mapping-common.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN include/asm-generic/dma-mapping-common.h~asm-generic-remove-calling-flush_write_buffers-in-dma_sync__for_cpu include/asm-generic/dma-mapping-common.h
--- a/include/asm-generic/dma-mapping-common.h~asm-generic-remove-calling-flush_write_buffers-in-dma_sync__for_cpu
+++ a/include/asm-generic/dma-mapping-common.h
@@ -103,7 +103,6 @@ static inline void dma_sync_single_for_c
 	if (ops->sync_single_for_cpu)
 		ops->sync_single_for_cpu(dev, addr, size, dir);
 	debug_dma_sync_single_for_cpu(dev, addr, size, dir);
-	flush_write_buffers();
 }
 
 static inline void dma_sync_single_for_device(struct device *dev,
@@ -132,7 +131,6 @@ static inline void dma_sync_single_range
 		ops->sync_single_range_for_cpu(dev, addr, offset, size, dir);
 		debug_dma_sync_single_range_for_cpu(dev, addr, offset, size, dir);
 
-		flush_write_buffers();
 	} else
 		dma_sync_single_for_cpu(dev, addr, size, dir);
 }
@@ -165,7 +163,6 @@ dma_sync_sg_for_cpu(struct device *dev, 
 	if (ops->sync_sg_for_cpu)
 		ops->sync_sg_for_cpu(dev, sg, nelems, dir);
 	debug_dma_sync_sg_for_cpu(dev, sg, nelems, dir);
-	flush_write_buffers();
 }
 
 static inline void
_

Patches currently in -mm which might be from tom.leiming@gmail.com are

linux-next.patch
drivers-video-add-kmalloc-null-tests.patch
drivers-video-add-kmalloc-null-tests-fix.patch

