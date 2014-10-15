From: akpm@linux-foundation.org
Subject: +
 drivers-of-add-return-value-to-of_reserved_mem_device_init.patch added to
 -mm tree
Date: Wed, 15 Oct 2014 13:08:09 -0700
Message-ID: <543ed429.mzDHcBpe3PW8/Zwi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36663 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaJOUIJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Oct 2014 16:08:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.szyprowski@samsung.com, arnd@arndb.de, grant.likely@linaro.org, iamjoonsoo.kim@lge.com, joshc@codeaurora.org, kyungmin.park@samsung.com, lauraa@codeaurora.org, mina86@mina86.com, rmk+kernel@arm.linux.org.uk, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers: of: add return value to of_reserved_mem_device_init()
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
Subject: drivers: of: add return value to of_reserved_mem_device_init()

Driver calling of_reserved_mem_device_init() might be interested if the
initialization has been successful or not, so add support for returning
error code.

This fixes a build warining caused by 7bfa5ab6fa1b ("drivers:
dma-coherent: add initialization from device tree"), which has been merged
without this change and without fixing function return value.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Josh Cartwright <joshc@codeaurora.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dma-contiguous.c   |    3 ++-
 drivers/of/of_reserved_mem.c    |   14 +++++++++-----
 include/linux/of_reserved_mem.h |    9 ++++++---
 3 files changed, 17 insertions(+), 9 deletions(-)

diff -puN drivers/base/dma-contiguous.c~drivers-of-add-return-value-to-of_reserved_mem_device_init drivers/base/dma-contiguous.c
--- a/drivers/base/dma-contiguous.c~drivers-of-add-return-value-to-of_reserved_mem_device_init
+++ a/drivers/base/dma-contiguous.c
@@ -223,9 +223,10 @@ bool dma_release_from_contiguous(struct
 #undef pr_fmt
 #define pr_fmt(fmt) fmt
 
-static void rmem_cma_device_init(struct reserved_mem *rmem, struct device *dev)
+static int rmem_cma_device_init(struct reserved_mem *rmem, struct device *dev)
 {
 	dev_set_cma_area(dev, rmem->priv);
+	return 0;
 }
 
 static void rmem_cma_device_release(struct reserved_mem *rmem,
diff -puN drivers/of/of_reserved_mem.c~drivers-of-add-return-value-to-of_reserved_mem_device_init drivers/of/of_reserved_mem.c
--- a/drivers/of/of_reserved_mem.c~drivers-of-add-return-value-to-of_reserved_mem_device_init
+++ a/drivers/of/of_reserved_mem.c
@@ -243,23 +243,27 @@ static inline struct reserved_mem *__fin
  * This function assign memory region pointed by "memory-region" device tree
  * property to the given device.
  */
-void of_reserved_mem_device_init(struct device *dev)
+int of_reserved_mem_device_init(struct device *dev)
 {
 	struct reserved_mem *rmem;
 	struct device_node *np;
+	int ret;
 
 	np = of_parse_phandle(dev->of_node, "memory-region", 0);
 	if (!np)
-		return;
+		return -ENODEV;
 
 	rmem = __find_rmem(np);
 	of_node_put(np);
 
 	if (!rmem || !rmem->ops || !rmem->ops->device_init)
-		return;
+		return -EINVAL;
 
-	rmem->ops->device_init(rmem, dev);
-	dev_info(dev, "assigned reserved memory node %s\n", rmem->name);
+	ret = rmem->ops->device_init(rmem, dev);
+	if (ret == 0)
+		dev_info(dev, "assigned reserved memory node %s\n", rmem->name);
+
+	return ret;
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
drivers-of-add-return-value-to-of_reserved_mem_device_init.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
cma-make-default-cma-area-size-zero-for-x86.patch
linux-next.patch

