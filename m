From: akpm@linux-foundation.org
Subject: + remove-dmam_declarerelease_coherent_memory.patch added to -mm tree
Date: Wed, 27 Feb 2008 15:06:58 -0800
Message-ID: <200802272306.m1RN6ws4002932@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752932AbYB0XHE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 18:07:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@suse.de, htejun@gmail.com


The patch titled
     Remove dmam_{declare,release}_coherent_memory
has been added to the -mm tree.  Its filename is
     remove-dmam_declarerelease_coherent_memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove dmam_{declare,release}_coherent_memory
From: Andi Kleen <ak@suse.de>

No callers in tree, so get rid of them.

Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dma-mapping.c  |   55 ----------------------------------
 include/linux/dma-mapping.h |   17 ----------
 2 files changed, 72 deletions(-)

diff -puN drivers/base/dma-mapping.c~remove-dmam_declarerelease_coherent_memory drivers/base/dma-mapping.c
--- a/drivers/base/dma-mapping.c~remove-dmam_declarerelease_coherent_memory
+++ a/drivers/base/dma-mapping.c
@@ -161,58 +161,3 @@ void dmam_free_noncoherent(struct device
 				&match_data));
 }
 EXPORT_SYMBOL(dmam_free_noncoherent);
-
-#ifdef ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
-
-static void dmam_coherent_decl_release(struct device *dev, void *res)
-{
-	dma_release_declared_memory(dev);
-}
-
-/**
- * dmam_declare_coherent_memory - Managed dma_declare_coherent_memory()
- * @dev: Device to declare coherent memory for
- * @bus_addr: Bus address of coherent memory to be declared
- * @device_addr: Device address of coherent memory to be declared
- * @size: Size of coherent memory to be declared
- * @flags: Flags
- *
- * Managed dma_declare_coherent_memory().
- *
- * RETURNS:
- * 0 on success, -errno on failure.
- */
-int dmam_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
-				 dma_addr_t device_addr, size_t size, int flags)
-{
-	void *res;
-	int rc;
-
-	res = devres_alloc(dmam_coherent_decl_release, 0, GFP_KERNEL);
-	if (!res)
-		return -ENOMEM;
-
-	rc = dma_declare_coherent_memory(dev, bus_addr, device_addr, size,
-					 flags);
-	if (rc == 0)
-		devres_add(dev, res);
-	else
-		devres_free(res);
-
-	return rc;
-}
-EXPORT_SYMBOL(dmam_declare_coherent_memory);
-
-/**
- * dmam_release_declared_memory - Managed dma_release_declared_memory().
- * @dev: Device to release declared coherent memory for
- *
- * Managed dmam_release_declared_memory().
- */
-void dmam_release_declared_memory(struct device *dev)
-{
-	WARN_ON(devres_destroy(dev, dmam_coherent_decl_release, NULL, NULL));
-}
-EXPORT_SYMBOL(dmam_release_declared_memory);
-
-#endif
diff -puN include/linux/dma-mapping.h~remove-dmam_declarerelease_coherent_memory include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~remove-dmam_declarerelease_coherent_memory
+++ a/include/linux/dma-mapping.h
@@ -128,22 +128,5 @@ extern void *dmam_alloc_noncoherent(stru
 				    dma_addr_t *dma_handle, gfp_t gfp);
 extern void dmam_free_noncoherent(struct device *dev, size_t size, void *vaddr,
 				  dma_addr_t dma_handle);
-#ifdef ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
-extern int dmam_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
-					dma_addr_t device_addr, size_t size,
-					int flags);
-extern void dmam_release_declared_memory(struct device *dev);
-#else /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
-static inline int dmam_declare_coherent_memory(struct device *dev,
-				dma_addr_t bus_addr, dma_addr_t device_addr,
-				size_t size, gfp_t gfp)
-{
-	return 0;
-}
-
-static inline void dmam_release_declared_memory(struct device *dev)
-{
-}
-#endif /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
 
 #endif
_

Patches currently in -mm which might be from ak@suse.de are

origin.patch
update-checkpatchpl-to-version-015.patch
git-x86.patch
bkl-removal-convert-cifs-over-to-unlocked_ioctl.patch
git-ocfs2.patch
git-xfs.patch
make-all-drivers-that-use-dma_declare_coherent_memory-depend-on-it.patch
cris-remove-dma_declare_coherent_memory-etc.patch
remove-dmam_declarerelease_coherent_memory.patch
init-move-setup-of-nr_cpu_ids-to-as-early-as-possible-v3.patch
generic-percpu-infrastructure-to-rebase-the-per-cpu-area-to-zero-v3.patch
x86_64-fold-pda-into-per-cpu-area-v3.patch
x86_64-fold-pda-into-per-cpu-area-v3-fix.patch
x86_64-cleanup-non-smp-usage-of-cpu-maps-v3.patch
profile-likely-unlikely-macros.patch
