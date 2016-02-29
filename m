From: akpm@linux-foundation.org
Subject: + drivers-dma-coherent-use-memremap_wc-for-dma_memory_map.patch
 added to -mm tree
Date: Mon, 29 Feb 2016 15:32:37 -0800
Message-ID: <56d4d515.OD4oDbhagXt4fFfA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbcB2Xci (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Feb 2016 18:32:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brian.starkey@arm.com, catalin.marinas@arm.com, dan.j.williams@intel.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers: dma-coherent: use MEMREMAP_WC for DMA_MEMORY_MAP
has been added to the -mm tree.  Its filename is
     drivers-dma-coherent-use-memremap_wc-for-dma_memory_map.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-dma-coherent-use-memremap_wc-for-dma_memory_map.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-dma-coherent-use-memremap_wc-for-dma_memory_map.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Brian Starkey <brian.starkey@arm.com>
Subject: drivers: dma-coherent: use MEMREMAP_WC for DMA_MEMORY_MAP

When the DMA_MEMORY_MAP flag is used, memory which can be accessed
directly should be returned, so use memremap(..., MEMREMAP_WC) to provide
a writecombine mapping.

Signed-off-by: Brian Starkey <brian.starkey@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dma-coherent.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff -puN drivers/base/dma-coherent.c~drivers-dma-coherent-use-memremap_wc-for-dma_memory_map drivers/base/dma-coherent.c
--- a/drivers/base/dma-coherent.c~drivers-dma-coherent-use-memremap_wc-for-dma_memory_map
+++ a/drivers/base/dma-coherent.c
@@ -2,6 +2,7 @@
  * Coherent per-device memory handling.
  * Borrowed from i386
  */
+#include <linux/io.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -31,7 +32,10 @@ static bool dma_init_coherent_memory(
 	if (!size)
 		goto out;
 
-	mem_base = ioremap(phys_addr, size);
+	if (flags & DMA_MEMORY_MAP)
+		mem_base = memremap(phys_addr, size, MEMREMAP_WC);
+	else
+		mem_base = ioremap(phys_addr, size);
 	if (!mem_base)
 		goto out;
 
@@ -54,8 +58,12 @@ static bool dma_init_coherent_memory(
 
 out:
 	kfree(dma_mem);
-	if (mem_base)
-		iounmap(mem_base);
+	if (mem_base) {
+		if (flags & DMA_MEMORY_MAP)
+			memunmap(mem_base);
+		else
+			iounmap(mem_base);
+	}
 	return false;
 }
 
@@ -63,7 +71,11 @@ static void dma_release_coherent_memory(
 {
 	if (!mem)
 		return;
-	iounmap(mem->virt_base);
+
+	if (mem->flags & DMA_MEMORY_MAP)
+		memunmap(mem->virt_base);
+	else
+		iounmap(mem->virt_base);
 	kfree(mem->bitmap);
 	kfree(mem);
 }
_

Patches currently in -mm which might be from brian.starkey@arm.com are

memremap-dont-modify-flags.patch
memremap-add-memremap_wc-flag.patch
drivers-dma-coherent-use-memremap_wc-for-dma_memory_map.patch
drivers-dma-coherent-use-memset_io-for-dma_memory_io-mappings.patch

