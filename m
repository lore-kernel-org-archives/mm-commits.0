From: akpm@linux-foundation.org
Subject: +
 lib-genalloc-add-a-helper-function-for-dma-buffer-allocation.patch added to -mm tree
Date: Mon, 04 Nov 2013 14:17:06 -0800
Message-ID: <52781ce2.QW1NT6dp5ablAMGo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48760 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3KDWRH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Nov 2013 17:17:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vinod.koul@intel.com, tiwai@suse.de, rob.herring@calxeda.com, perex@perex.cz, nsekhar@ti.com, m.chehab@samsung.com, linux@arm.linux.org.uk, lgirdwood@gmail.com, khilman@deeprootsystems.com, hjk@hansjkoch.de, haojian.zhuang@gmail.com, gregkh@linuxfoundation.org, grant.likely@linaro.org, eric.y.miao@gmail.com, dan.j.williams@intel.com, broonie@kernel.org, b42378@freescale.com

Subject: + lib-genalloc-add-a-helper-function-for-dma-buffer-allocation.patch added to -mm tree
To: b42378@freescale.com,broonie@kernel.org,dan.j.williams@intel.com,eric.y.miao@gmail.com,grant.likely@linaro.org,gregkh@linuxfoundation.org,haojian.zhuang@gmail.com,hjk@hansjkoch.de,khilman@deeprootsystems.com,lgirdwood@gmail.com,linux@arm.linux.org.uk,m.chehab@samsung.com,nsekhar@ti.com,perex@perex.cz,rob.herring@calxeda.com,tiwai@suse.de,vinod.koul@intel.com
From: akpm@linux-foundation.org
Date: Mon, 04 Nov 2013 14:17:06 -0800


The patch titled
     Subject: lib/genalloc: add a helper function for DMA buffer allocation
has been added to the -mm tree.  Its filename is
     lib-genalloc-add-a-helper-function-for-dma-buffer-allocation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-genalloc-add-a-helper-function-for-dma-buffer-allocation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-genalloc-add-a-helper-function-for-dma-buffer-allocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicolin Chen <b42378@freescale.com>
Subject: lib/genalloc: add a helper function for DMA buffer allocation

When using pool space for DMA buffer, there might be duplicated calling of
gen_pool_alloc() and gen_pool_virt_to_phys() in each implementation.

Thus it's better to add a simple helper function, a compatible one to the
common dma_alloc_coherent(), to save some code.

Signed-off-by: Nicolin Chen <b42378@freescale.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/genalloc.h |    2 ++
 lib/genalloc.c           |   28 ++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff -puN include/linux/genalloc.h~lib-genalloc-add-a-helper-function-for-dma-buffer-allocation include/linux/genalloc.h
--- a/include/linux/genalloc.h~lib-genalloc-add-a-helper-function-for-dma-buffer-allocation
+++ a/include/linux/genalloc.h
@@ -94,6 +94,8 @@ static inline int gen_pool_add(struct ge
 }
 extern void gen_pool_destroy(struct gen_pool *);
 extern unsigned long gen_pool_alloc(struct gen_pool *, size_t);
+extern void *gen_pool_dma_alloc(struct gen_pool *pool, size_t size,
+		dma_addr_t *dma);
 extern void gen_pool_free(struct gen_pool *, unsigned long, size_t);
 extern void gen_pool_for_each_chunk(struct gen_pool *,
 	void (*)(struct gen_pool *, struct gen_pool_chunk *, void *), void *);
diff -puN lib/genalloc.c~lib-genalloc-add-a-helper-function-for-dma-buffer-allocation lib/genalloc.c
--- a/lib/genalloc.c~lib-genalloc-add-a-helper-function-for-dma-buffer-allocation
+++ a/lib/genalloc.c
@@ -313,6 +313,34 @@ retry:
 EXPORT_SYMBOL(gen_pool_alloc);
 
 /**
+ * gen_pool_dma_alloc - allocate special memory from the pool for DMA usage
+ * @pool: pool to allocate from
+ * @size: number of bytes to allocate from the pool
+ * @dma: dma-view physical address
+ *
+ * Allocate the requested number of bytes from the specified pool.
+ * Uses the pool allocation function (with first-fit algorithm by default).
+ * Can not be used in NMI handler on architectures without
+ * NMI-safe cmpxchg implementation.
+ */
+void *gen_pool_dma_alloc(struct gen_pool *pool, size_t size, dma_addr_t *dma)
+{
+	unsigned long vaddr;
+
+	if (!pool)
+		return NULL;
+
+	vaddr = gen_pool_alloc(pool, size);
+	if (!vaddr)
+		return NULL;
+
+	*dma = gen_pool_virt_to_phys(pool, vaddr);
+
+	return (void *)vaddr;
+}
+EXPORT_SYMBOL(gen_pool_dma_alloc);
+
+/**
  * gen_pool_free - free allocated special memory back to the pool
  * @pool: pool to free to
  * @addr: starting address of memory to free back to pool
_

Patches currently in -mm which might be from b42378@freescale.com are

linux-next.patch
lib-genalloc-add-a-helper-function-for-dma-buffer-allocation.patch
arch-arm-mach-davinci-sramc-use-gen_pool_dma_alloc-to-sramc.patch
drivers-dma-mmp_tdmac-use-gen_pool_dma_alloc-to-allocate-descriptor.patch
drivers-media-platform-codac-use-gen_pool_dma_alloc-to-allocate-iram-buffer.patch
drivers-uio-uio_prussc-use-gen_pool_dma_alloc-to-allocate-sram-memory.patch
sound-soc-davinci-davinci-pcmc-use-gen_pool_dma_alloc-in-davinci-pcmc.patch
sound-soc-pxa-mmp-pcmc-use-gen_pool_dma_alloc-to-allocate-dma-buffer.patch
sound-core-memallocc-use-gen_pool_dma_alloc-to-allocate-iram-buffer.patch

