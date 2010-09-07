From: akpm@linux-foundation.org
Subject: + uml-define-config_no_dma.patch added to -mm tree
Date: Tue, 07 Sep 2010 16:22:19 -0700
Message-ID: <201009072322.o87NMJVb012686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753772Ab0IGXXm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 19:23:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, jdike@addtoit.com, miklos@szeredi.hu, sam@ravnborg.org


The patch titled
     uml: define CONFIG_NO_DMA
has been added to the -mm tree.  Its filename is
     uml-define-config_no_dma.patch

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
Subject: uml: define CONFIG_NO_DMA
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

I think that it's better to detect DMA misuse at build time rather than
calling BUG_ON.  Architectures that can't do DMA need to define
CONFIG_NO_DMA.

Thanks to Sam Ravnborg for explaining how CONFIG_NO_DMA and CONFIG_HAS_DMA
work:

http://marc.info/?l=linux-kernel&m=128359913825550&w=2

HAS_DMA is defined like this:

config HAS_DMA
        boolean
        depends on !NO_DMA
        default y

So to set HAS_DMA to true an arch should do:
1) Do not define NO_DMA
2) Define NO_DMA abd set it to 'n'

Must archs - including um - used principle 1).

In the um case we want to say that we do NOT have any DMA.
This can be done in two ways.
a) define NO_DMA and set it to 'y'
b) redefine HAS_DMA and set it to 'n'.

The patch you provided used principle b) where other archs use principle a).
So I suggest you should use principle a) for um too.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig.um                |    3 
 arch/um/defconfig                 |    1 
 arch/um/include/asm/dma-mapping.h |  112 ----------------------------
 3 files changed, 3 insertions(+), 113 deletions(-)

diff -puN arch/um/Kconfig.um~uml-define-config_no_dma arch/um/Kconfig.um
--- a/arch/um/Kconfig.um~uml-define-config_no_dma
+++ a/arch/um/Kconfig.um
@@ -147,3 +147,6 @@ config KERNEL_STACK_ORDER
 	  This option determines the size of UML kernel stacks.  They will
 	  be 1 << order pages.  The default is OK unless you're running Valgrind
 	  on UML, in which case, set this to 3.
+
+config NO_DMA
+	def_bool y
diff -puN arch/um/defconfig~uml-define-config_no_dma arch/um/defconfig
--- a/arch/um/defconfig~uml-define-config_no_dma
+++ a/arch/um/defconfig
@@ -566,7 +566,6 @@ CONFIG_CRC32=m
 # CONFIG_CRC7 is not set
 # CONFIG_LIBCRC32C is not set
 CONFIG_PLIST=y
-CONFIG_HAS_DMA=y
 
 #
 # SCSI device support
diff -puN arch/um/include/asm/dma-mapping.h~uml-define-config_no_dma /dev/null
--- a/arch/um/include/asm/dma-mapping.h
+++ /dev/null
@@ -1,112 +0,0 @@
-#ifndef _ASM_DMA_MAPPING_H
-#define _ASM_DMA_MAPPING_H
-
-#include <asm/scatterlist.h>
-
-static inline int
-dma_supported(struct device *dev, u64 mask)
-{
-	BUG();
-	return(0);
-}
-
-static inline int
-dma_set_mask(struct device *dev, u64 dma_mask)
-{
-	BUG();
-	return(0);
-}
-
-static inline void *
-dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
-		   gfp_t flag)
-{
-	BUG();
-	return((void *) 0);
-}
-
-static inline void
-dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
-		  dma_addr_t dma_handle)
-{
-	BUG();
-}
-
-static inline dma_addr_t
-dma_map_single(struct device *dev, void *cpu_addr, size_t size,
-	       enum dma_data_direction direction)
-{
-	BUG();
-	return(0);
-}
-
-static inline void
-dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
-		 enum dma_data_direction direction)
-{
-	BUG();
-}
-
-static inline dma_addr_t
-dma_map_page(struct device *dev, struct page *page,
-	     unsigned long offset, size_t size,
-	     enum dma_data_direction direction)
-{
-	BUG();
-	return(0);
-}
-
-static inline void
-dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
-	       enum dma_data_direction direction)
-{
-	BUG();
-}
-
-static inline int
-dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-	   enum dma_data_direction direction)
-{
-	BUG();
-	return(0);
-}
-
-static inline void
-dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
-	     enum dma_data_direction direction)
-{
-	BUG();
-}
-
-static inline void
-dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
-		enum dma_data_direction direction)
-{
-	BUG();
-}
-
-static inline void
-dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
-	    enum dma_data_direction direction)
-{
-	BUG();
-}
-
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
-static inline void
-dma_cache_sync(struct device *dev, void *vaddr, size_t size,
-	       enum dma_data_direction direction)
-{
-	BUG();
-}
-
-static inline int
-dma_mapping_error(struct device *dev, dma_addr_t dma_handle)
-{
-	BUG();
-	return 0;
-}
