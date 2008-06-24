From: akpm@linux-foundation.org
Subject: + fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact.patch added to -mm tree
Date: Tue, 24 Jun 2008 13:58:20 -0700
Message-ID: <200806242058.m5OKwKnP005714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752808AbYFXU60 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 16:58:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: timur@freescale.com


The patch titled
     fsl-diu-fb: update Freescale DIU driver to use page_alloc_exact()
has been added to the -mm tree.  Its filename is
     fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact.patch

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
Subject: fsl-diu-fb: update Freescale DIU driver to use page_alloc_exact()
From: Timur Tabi <timur@freescale.com>

Update the Freescale DIU driver to use page_alloc_exact() to allocate a
DMA buffer.  This also eliminates the rheap-based memory allocator.  We
can do this now because commit 6ccf61f9 allows us to allocate 8MB
physically- contiguous memory blocks.

Signed-off-by: Timur Tabi <timur@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fsl-diu-fb.c |   59 ++++++++++++-----------------------
 1 file changed, 21 insertions(+), 38 deletions(-)

diff -puN drivers/video/fsl-diu-fb.c~fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact drivers/video/fsl-diu-fb.c
--- a/drivers/video/fsl-diu-fb.c~fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact
+++ a/drivers/video/fsl-diu-fb.c
@@ -279,58 +279,41 @@ static struct diu_hw dr = {
 
 static struct diu_pool pool;
 
-/*	To allocate memory for framebuffer. First try __get_free_pages(). If it
- *	fails, try rh_alloc. The reason is __get_free_pages() cannot allocate
- *	very large memory (more than 4MB). We don't want to allocate all memory
- *	in rheap since small memory allocation/deallocation will fragment the
- *	rheap and make the furture large allocation fail.
+/**
+ * fsl_diu_alloc - allocate memory for the DIU
+ * @size: number of bytes to allocate
+ * @param: returned physical address of memory
+ *
+ * This function allocates a physically-contiguous block of memory.
  */
-
-void *fsl_diu_alloc(unsigned long size, phys_addr_t *phys)
+static void *fsl_diu_alloc(size_t size, phys_addr_t *phys)
 {
 	void *virt;
 
-	pr_debug("size=%lu\n", size);
+	pr_debug("size=%u\n", size);
 
-	virt = (void *)__get_free_pages(GFP_DMA | __GFP_ZERO, get_order(size));
+	virt = alloc_pages_exact(size, GFP_DMA | __GFP_ZERO);
 	if (virt) {
 		*phys = virt_to_phys(virt);
-		pr_debug("virt %p, phys=%llx\n", virt, (uint64_t) *phys);
-		return virt;
-	}
-	if (!diu_ops.diu_mem) {
-		printk(KERN_INFO "%s: no diu_mem."
-			" To reserve more memory, put 'diufb=15M' "
-			"in the command line\n", __func__);
-		return NULL;
-	}
-
-	virt = (void *)rh_alloc(&diu_ops.diu_rh_info, size, "DIU");
-	if (virt) {
-		*phys = virt_to_bus(virt);
-		memset(virt, 0, size);
+		pr_debug("virt=%p, phys=%llx\n", virt, (uint64_t) *phys);
 	}
 
-	pr_debug("rh virt=%p phys=%lx\n", virt, *phys);
-
 	return virt;
 }
 
-void fsl_diu_free(void *p, unsigned long size)
+/**
+ * fsl_diu_free - release DIU memory
+ * @virt: pointer returned by fsl_diu_alloc()
+ * @size: number of bytes allocated by fsl_diu_alloc()
+ *
+ * This function releases memory allocated by fsl_diu_alloc().
+ */
+static void fsl_diu_free(void *virt, size_t size)
 {
-	pr_debug("p=%p size=%lu\n", p, size);
+	pr_debug("virt=%p size=%u\n", virt, size);
 
-	if (!p)
-		return;
