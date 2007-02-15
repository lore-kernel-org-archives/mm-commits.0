From: akpm@linux-foundation.org
Subject: - ia64-fix-noncoherent-dma-api-so-devres-builds.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:46:48 -0800
Message-ID: <200702150846.l1F8kmTG024930@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39841 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965289AbXBOIqv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:46:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdreier@cisco.com, rolandd@cisco.com, tony.luck@intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     ia64: fix noncoherent DMA API so devres builds
has been removed from the -mm tree.  Its filename was
     ia64-fix-noncoherent-dma-api-so-devres-builds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ia64: fix noncoherent DMA API so devres builds
From: Roland Dreier <rdreier@cisco.com>

On ia64, drivers/base/dma-mapping.c doesn't build because it calls
dma_alloc_noncoherent() and dma_free_noncoherent(), which appear to be
terminally broken; the calls end up generating errors like

    drivers/base/dma-mapping.c: In function 'dmam_noncoherent_release':
    drivers/base/dma-mapping.c:32: error: 'struct ia64_machine_vector' has no member named 'platform_dma_free_coherent'

because the multiple levels of macro expansion in <asm/dma-mapping.h> and
<asm/machvec.h> end up turning a call to dma_free_noncoherent() into
ia64_mv.platform_dma_free_coherent (instead of the intended
ia64_mv.dma_free_coherent).

This patch fixes this by converting dma_{alloc,free}_noncoherent() into
inline functions that call the corresponding coherent functions, instead of
trying to do this with macros.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/dma-mapping.h |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN include/asm-ia64/dma-mapping.h~ia64-fix-noncoherent-dma-api-so-devres-builds include/asm-ia64/dma-mapping.h
--- a/include/asm-ia64/dma-mapping.h~ia64-fix-noncoherent-dma-api-so-devres-builds
+++ a/include/asm-ia64/dma-mapping.h
@@ -8,9 +8,20 @@
 #include <asm/machvec.h>
 
 #define dma_alloc_coherent	platform_dma_alloc_coherent
-#define dma_alloc_noncoherent	platform_dma_alloc_coherent	/* coherent mem. is cheap */
+/* coherent mem. is cheap */
+static inline void *
+dma_alloc_noncoherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
+		      gfp_t flag)
+{
+	return dma_alloc_coherent(dev, size, dma_handle, flag);
+}
 #define dma_free_coherent	platform_dma_free_coherent
-#define dma_free_noncoherent	platform_dma_free_coherent
+static inline void
+dma_free_noncoherent(struct device *dev, size_t size, void *cpu_addr,
+		     dma_addr_t dma_handle)
+{
+	dma_free_coherent(dev, size, cpu_addr, dma_handle);
+}
 #define dma_map_single		platform_dma_map_single
 #define dma_map_sg		platform_dma_map_sg
 #define dma_unmap_single	platform_dma_unmap_single
_

Patches currently in -mm which might be from rdreier@cisco.com are

origin.patch
