From: akpm@linux-foundation.org
Subject: + fsldma-move-dma_slave-support-functions-to-the-driver.patch added to -mm tree
Date: Tue, 07 Sep 2010 15:09:42 -0700
Message-ID: <201009072209.o87M9g4h009244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752750Ab0IGWKP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 18:10:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: iws@ovro.caltech.edu, dan.j.williams@intel.com


The patch titled
     fsldma: move DMA_SLAVE support functions to the driver
has been added to the -mm tree.  Its filename is
     fsldma-move-dma_slave-support-functions-to-the-driver.patch

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
Subject: fsldma: move DMA_SLAVE support functions to the driver
From: "Ira W. Snyder" <iws@ovro.caltech.edu>

The DMA_SLAVE support functions all existed as static inlines in the
driver specific header arch/powerpc/include/asm/fsldma.h. Move the body
of the functions to the driver itself, and EXPORT_SYMBOL_GPL() them.

At the same time, add the missing linux/list.h header.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/fsldma.h |   70 ++-----------------------
 drivers/dma/fsldma.c              |   77 ++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+), 64 deletions(-)

diff -puN arch/powerpc/include/asm/fsldma.h~fsldma-move-dma_slave-support-functions-to-the-driver arch/powerpc/include/asm/fsldma.h
--- a/arch/powerpc/include/asm/fsldma.h~fsldma-move-dma_slave-support-functions-to-the-driver
+++ a/arch/powerpc/include/asm/fsldma.h
@@ -1,7 +1,7 @@
 /*
  * Freescale MPC83XX / MPC85XX DMA Controller
  *
- * Copyright (c) 2009 Ira W. Snyder <iws@ovro.caltech.edu>
+ * Copyright (c) 2009-2010 Ira W. Snyder <iws@ovro.caltech.edu>
  *
  * This file is licensed under the terms of the GNU General Public License
  * version 2. This program is licensed "as is" without any warranty of any
@@ -11,6 +11,7 @@
 #ifndef __ARCH_POWERPC_ASM_FSLDMA_H__
 #define __ARCH_POWERPC_ASM_FSLDMA_H__
 
+#include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/dmaengine.h>
 
@@ -69,69 +70,10 @@ struct fsl_dma_slave {
 	bool external_pause;
 };
 
-/**
- * fsl_dma_slave_append - add an address/length pair to a struct fsl_dma_slave
- * @slave: the &struct fsl_dma_slave to add to
- * @address: the hardware address to add
- * @length: the length of bytes to transfer from @address
- *
- * Add a hardware address/length pair to a struct fsl_dma_slave. Returns 0 on
- * success, -ERRNO otherwise.
- */
-static inline int fsl_dma_slave_append(struct fsl_dma_slave *slave,
-				       dma_addr_t address, size_t length)
-{
-	struct fsl_dma_hw_addr *addr;
-
-	addr = kzalloc(sizeof(*addr), GFP_ATOMIC);
-	if (!addr)
-		return -ENOMEM;
-
-	INIT_LIST_HEAD(&addr->entry);
-	addr->address = address;
-	addr->length = length;
-
-	list_add_tail(&addr->entry, &slave->addresses);
-	return 0;
-}
-
-/**
- * fsl_dma_slave_free - free a struct fsl_dma_slave
- * @slave: the struct fsl_dma_slave to free
- *
- * Free a struct fsl_dma_slave and all associated address/length pairs
- */
-static inline void fsl_dma_slave_free(struct fsl_dma_slave *slave)
-{
-	struct fsl_dma_hw_addr *addr, *tmp;
-
-	if (slave) {
-		list_for_each_entry_safe(addr, tmp, &slave->addresses, entry) {
-			list_del(&addr->entry);
-			kfree(addr);
-		}
-
-		kfree(slave);
-	}
-}
+struct fsl_dma_slave *fsl_dma_slave_alloc(gfp_t gfp);
+void fsl_dma_slave_free(struct fsl_dma_slave *slave);
 
-/**
- * fsl_dma_slave_alloc - allocate a struct fsl_dma_slave
- * @gfp: the flags to pass to kmalloc when allocating this structure
- *
- * Allocate a struct fsl_dma_slave for use by the DMA_SLAVE API. Returns a new
- * struct fsl_dma_slave on success, or NULL on failure.
- */
-static inline struct fsl_dma_slave *fsl_dma_slave_alloc(gfp_t gfp)
-{
-	struct fsl_dma_slave *slave;
-
-	slave = kzalloc(sizeof(*slave), gfp);
-	if (!slave)
-		return NULL;
-
-	INIT_LIST_HEAD(&slave->addresses);
-	return slave;
-}
+int fsl_dma_slave_append(struct fsl_dma_slave *slave, dma_addr_t address,
+			 size_t length, gfp_t gfp);
 
 #endif /* __ARCH_POWERPC_ASM_FSLDMA_H__ */
diff -puN drivers/dma/fsldma.c~fsldma-move-dma_slave-support-functions-to-the-driver drivers/dma/fsldma.c
--- a/drivers/dma/fsldma.c~fsldma-move-dma_slave-support-functions-to-the-driver
+++ a/drivers/dma/fsldma.c
@@ -38,6 +38,83 @@
 #include <asm/fsldma.h>
 #include "fsldma.h"
 
+/*
+ * External API
+ */
+
+/**
+ * fsl_dma_slave_append - add an address/length pair to a struct fsl_dma_slave
+ * @slave: the &struct fsl_dma_slave to add to
+ * @address: the hardware address to add
+ * @length: the length of bytes to transfer from @address
+ * @gfp: the flags to pass to kmalloc when allocating memory
+ *
+ * Add a hardware address/length pair to a struct fsl_dma_slave. Returns 0 on
+ * success, -ERRNO otherwise.
+ */
+int fsl_dma_slave_append(struct fsl_dma_slave *slave, dma_addr_t address,
+			 size_t length, gfp_t gfp)
+{
+	struct fsl_dma_hw_addr *addr;
+
+	addr = kzalloc(sizeof(*addr), gfp);
+	if (!addr)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&addr->entry);
+	addr->address = address;
+	addr->length = length;
+
+	list_add_tail(&addr->entry, &slave->addresses);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fsl_dma_slave_append);
+
+/**
+ * fsl_dma_slave_free - free a struct fsl_dma_slave
+ * @slave: the struct fsl_dma_slave to free
+ *
+ * Free a struct fsl_dma_slave and all associated address/length pairs
+ */
+void fsl_dma_slave_free(struct fsl_dma_slave *slave)
+{
+	struct fsl_dma_hw_addr *addr, *tmp;
+
+	if (slave) {
+		list_for_each_entry_safe(addr, tmp, &slave->addresses, entry) {
+			list_del(&addr->entry);
+			kfree(addr);
+		}
+
+		kfree(slave);
+	}
+}
+EXPORT_SYMBOL_GPL(fsl_dma_slave_free);
+
+/**
+ * fsl_dma_slave_alloc - allocate a struct fsl_dma_slave
+ * @gfp: the flags to pass to kmalloc when allocating this structure
+ *
+ * Allocate a struct fsl_dma_slave for use by the DMA_SLAVE API. Returns a new
+ * struct fsl_dma_slave on success, or NULL on failure.
+ */
+struct fsl_dma_slave *fsl_dma_slave_alloc(gfp_t gfp)
+{
+	struct fsl_dma_slave *slave;
+
+	slave = kzalloc(sizeof(*slave), gfp);
+	if (!slave)
+		return NULL;
+
+	INIT_LIST_HEAD(&slave->addresses);
+	return slave;
+}
+EXPORT_SYMBOL_GPL(fsl_dma_slave_alloc);
+
+/*
+ * Driver Code
+ */
+
 static void dma_init(struct fsldma_chan *chan)
 {
 	/* Reset the channel */
_

Patches currently in -mm which might be from iws@ovro.caltech.edu are

linux-next.patch
arch-powerpc-include-asm-fsldmah-needs-slabh.patch
kfifo-fix-scatterlist-usage.patch
fsldma-move-dma_slave-support-functions-to-the-driver.patch

