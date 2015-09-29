From: akpm@linux-foundation.org
Subject: + dma-debug-allow-poisoning-nonzero-allocations.patch added to
 -mm tree
Date: Tue, 29 Sep 2015 14:41:00 -0700
Message-ID: <560b056c.t57AO2HkHolMObYS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51501 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbbI2VlB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Sep 2015 17:41:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robin.murphy@arm.com, arnd@arndb.de, m.szyprowski@samsung.com, rmk+kernel@arm.linux.org.uk, sakari.ailus@iki.fi, sumit.semwal@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-debug: allow poisoning nonzero allocations
has been added to the -mm tree.  Its filename is
     dma-debug-allow-poisoning-nonzero-allocations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-debug-allow-poisoning-nonzero-allocations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-debug-allow-poisoning-nonzero-allocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Robin Murphy <robin.murphy@arm.com>
Subject: dma-debug: allow poisoning nonzero allocations

Since some dma_alloc_coherent implementations return a zeroed buffer
regardless of whether __GFP_ZERO is passed, there exist drivers which are
implicitly dependent on this and pass otherwise uninitialised buffers to
hardware.  This can lead to subtle and awkward-to-debug issues using those
drivers on different platforms, where nonzero uninitialised junk may for
instance occasionally look like a valid command which causes the hardware
to start misbehaving.  To help with debugging such issues, add the option
to make uninitialised buffers much more obvious.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/dma-mapping-common.h |    2 +-
 include/linux/dma-debug.h                |    6 ++++--
 include/linux/poison.h                   |    3 +++
 lib/Kconfig.debug                        |   10 ++++++++++
 lib/dma-debug.c                          |    6 +++++-
 5 files changed, 23 insertions(+), 4 deletions(-)

diff -puN include/asm-generic/dma-mapping-common.h~dma-debug-allow-poisoning-nonzero-allocations include/asm-generic/dma-mapping-common.h
--- a/include/asm-generic/dma-mapping-common.h~dma-debug-allow-poisoning-nonzero-allocations
+++ a/include/asm-generic/dma-mapping-common.h
@@ -260,7 +260,7 @@ static inline void *dma_alloc_attrs(stru
 		return NULL;
 
 	cpu_addr = ops->alloc(dev, size, dma_handle, flag, attrs);
-	debug_dma_alloc_coherent(dev, size, *dma_handle, cpu_addr);
+	debug_dma_alloc_coherent(dev, size, *dma_handle, cpu_addr, flag);
 	return cpu_addr;
 }
 
diff -puN include/linux/dma-debug.h~dma-debug-allow-poisoning-nonzero-allocations include/linux/dma-debug.h
--- a/include/linux/dma-debug.h~dma-debug-allow-poisoning-nonzero-allocations
+++ a/include/linux/dma-debug.h
@@ -51,7 +51,8 @@ extern void debug_dma_unmap_sg(struct de
 			       int nelems, int dir);
 
 extern void debug_dma_alloc_coherent(struct device *dev, size_t size,
-				     dma_addr_t dma_addr, void *virt);
+				     dma_addr_t dma_addr, void *virt,
+				     gfp_t flags);
 
 extern void debug_dma_free_coherent(struct device *dev, size_t size,
 				    void *virt, dma_addr_t addr);
@@ -132,7 +133,8 @@ static inline void debug_dma_unmap_sg(st
 }
 
 static inline void debug_dma_alloc_coherent(struct device *dev, size_t size,
-					    dma_addr_t dma_addr, void *virt)
+					    dma_addr_t dma_addr, void *virt,
+					    gfp_t flags)
 {
 }
 
diff -puN include/linux/poison.h~dma-debug-allow-poisoning-nonzero-allocations include/linux/poison.h
--- a/include/linux/poison.h~dma-debug-allow-poisoning-nonzero-allocations
+++ a/include/linux/poison.h
@@ -77,6 +77,9 @@
 #define MUTEX_DEBUG_INIT	0x11
 #define MUTEX_DEBUG_FREE	0x22
 
+/********** lib/dma_debug.c **********/
+#define DMA_ALLOC_POISON	0xee
+
 /********** lib/flex_array.c **********/
 #define FLEX_ARRAY_FREE	0x6c	/* for use-after-free poisoning */
 
diff -puN lib/Kconfig.debug~dma-debug-allow-poisoning-nonzero-allocations lib/Kconfig.debug
--- a/lib/Kconfig.debug~dma-debug-allow-poisoning-nonzero-allocations
+++ a/lib/Kconfig.debug
@@ -1752,6 +1752,16 @@ config DMA_API_DEBUG
 
 	  If unsure, say N.
 
+config DMA_API_DEBUG_POISON
+	bool "Poison coherent DMA buffers"
+	depends on DMA_API_DEBUG && EXPERT
+	help
+	  Poison DMA buffers returned by dma_alloc_coherent unless __GFP_ZERO
+	  is explicitly specified, to catch drivers depending on zeroed buffers
+	  without passing the correct flags.
+
+	  Only say Y if you're prepared for almost everything to break.
+
 config TEST_LKM
 	tristate "Test module loading with 'hello world' module"
 	default n
diff -puN lib/dma-debug.c~dma-debug-allow-poisoning-nonzero-allocations lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-allow-poisoning-nonzero-allocations
+++ a/lib/dma-debug.c
@@ -30,6 +30,7 @@
 #include <linux/sched.h>
 #include <linux/ctype.h>
 #include <linux/list.h>
+#include <linux/poison.h>
 #include <linux/slab.h>
 
 #include <asm/sections.h>
@@ -1447,7 +1448,7 @@ void debug_dma_unmap_sg(struct device *d
 EXPORT_SYMBOL(debug_dma_unmap_sg);
 
 void debug_dma_alloc_coherent(struct device *dev, size_t size,
-			      dma_addr_t dma_addr, void *virt)
+			      dma_addr_t dma_addr, void *virt, gfp_t flags)
 {
 	struct dma_debug_entry *entry;
 
@@ -1457,6 +1458,9 @@ void debug_dma_alloc_coherent(struct dev
 	if (unlikely(virt == NULL))
 		return;
 
+	if (IS_ENABLED(CONFIG_DMA_API_DEBUG_POISON) && !(flags & __GFP_ZERO))
+		memset(virt, DMA_ALLOC_POISON, size);
+
 	entry = dma_entry_alloc();
 	if (!entry)
 		return;
_

Patches currently in -mm which might be from robin.murphy@arm.com are

dmapool-fix-overflow-condition-in-pool_find_page.patch
dma-mapping-tidy-up-dma_parms-default-handling.patch
dma-debug-check-nents-in-dma_sync_sg.patch
dma-debug-allow-poisoning-nonzero-allocations.patch

