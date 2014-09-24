From: akpm@linux-foundation.org
Subject: +
 drivers-of-add-return-value-to-of_reserved_mem_device_init.patch added to
 -mm tree
Date: Wed, 24 Sep 2014 15:30:42 -0700
Message-ID: <54234612.CqyBAJ0lkxscNiE7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51209 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaIXWan (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Sep 2014 18:30:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.szyprowski@samsung.com, arnd@arndb.de, grant.likely@linaro.org, iamjoonsoo.kim@lge.com, joshc@codeaurora.org, kyungmin.park@samsung.com, lauraa@codeaurora.org, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers: of: add return value to of_reserved_mem_device_init
has been added to the -mm tree.  Its filename is
     drivers-of-add-return-value-to-of_reserved_mem_device_init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-of-add-return-value-to-of_reserved_mem_device_init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-of-add-return-value-to-of_reserved_mem_device_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: drivers: of: add return value to of_reserved_mem_device_init

This is another approach to finish support for reserved memory regions
defined in device tree.  Previous attempts
(http://lists.linaro.org/pipermail/linaro-mm-sig/2014-February/003738.html
and https://lkml.org/lkml/2014/7/14/108) ended in merging parts of the
code and documentation.  Merged patches allow to reserve memory, but there
is still no reserved memory drivers nor any code that actually uses
reserved memory regions.

The final conclusion from the above mentioned threads is that there is no
automated reserved memory initialization.  All drivers that want to use
reserved memory, should initialize it on their own.

This patch series provides two driver for reserved memory regions (one
based on CMA and one based on dma_coherent allocator).  The main
improvement comparing to the previous version is removal of automated
reserved memory for every device and support for named memory regions.



This patch (of 3):

Driver calling of_reserved_mem_device_init() might be interested if the
initialization has been successful or not, so add support for returning
error code.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Josh Cartwright <joshc@codeaurora.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/of/of_reserved_mem.c    |    3 ++-
 include/linux/of_reserved_mem.h |    9 ++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/of/of_reserved_mem.c~drivers-of-add-return-value-to-of_reserved_mem_device_init drivers/of/of_reserved_mem.c
--- a/drivers/of/of_reserved_mem.c~drivers-of-add-return-value-to-of_reserved_mem_device_init
+++ a/drivers/of/of_reserved_mem.c
@@ -243,7 +243,7 @@ static inline struct reserved_mem *__fin
  * This function assign memory region pointed by "memory-region" device tree
  * property to the given device.
  */
-void of_reserved_mem_device_init(struct device *dev)
+int of_reserved_mem_device_init(struct device *dev)
 {
 	struct reserved_mem *rmem;
 	struct device_node *np;
@@ -260,6 +260,7 @@ void of_reserved_mem_device_init(struct
 
 	rmem->ops->device_init(rmem, dev);
 	dev_info(dev, "assigned reserved memory node %s\n", rmem->name);
+	return 0;
 }
 
 /**
diff -puN include/linux/of_reserved_mem.h~drivers-of-add-return-value-to-of_reserved_mem_device_init include/linux/of_reserved_mem.h
--- a/include/linux/of_reserved_mem.h~drivers-of-add-return-value-to-of_reserved_mem_device_init
+++ a/include/linux/of_reserved_mem.h
@@ -16,7 +16,7 @@ struct reserved_mem {
 };
 
 struct reserved_mem_ops {
-	void	(*device_init)(struct reserved_mem *rmem,
+	int	(*device_init)(struct reserved_mem *rmem,
 			       struct device *dev);
 	void	(*device_release)(struct reserved_mem *rmem,
 				  struct device *dev);
@@ -28,14 +28,17 @@ typedef int (*reservedmem_of_init_fn)(st
 	_OF_DECLARE(reservedmem, name, compat, init, reservedmem_of_init_fn)
 
 #ifdef CONFIG_OF_RESERVED_MEM
-void of_reserved_mem_device_init(struct device *dev);
+int of_reserved_mem_device_init(struct device *dev);
 void of_reserved_mem_device_release(struct device *dev);
 
 void fdt_init_reserved_mem(void);
 void fdt_reserved_mem_save_node(unsigned long node, const char *uname,
 			       phys_addr_t base, phys_addr_t size);
 #else
-static inline void of_reserved_mem_device_init(struct device *dev) { }
+static inline int of_reserved_mem_device_init(struct device *dev)
+{
+	return -ENOSYS;
+}
 static inline void of_reserved_mem_device_release(struct device *pdev) { }
 
 static inline void fdt_init_reserved_mem(void) { }
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

origin.patch
mm-cma-adjust-address-limit-to-avoid-hitting-low-high-memory-boundary.patch
arm-mm-dont-limit-default-cma-region-only-to-low-memory.patch
drivers-of-add-return-value-to-of_reserved_mem_device_init.patch
drivers-dma-coherent-add-initialization-from-device-tree.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch
drivers-dma-contiguous-add-initialization-from-device-tree.patch
drivers-dma-contiguous-add-initialization-from-device-tree-checkpatch-fixes.patch
linux-next.patch

