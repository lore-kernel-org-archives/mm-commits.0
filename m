Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85172C38142
	for <mm-commits@archiver.kernel.org>; Sun, 22 Jan 2023 01:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbjAVBVS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 21 Jan 2023 20:21:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjAVBVS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 21 Jan 2023 20:21:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22C123660
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 17:21:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 917DBB80816
        for <mm-commits@vger.kernel.org>; Sun, 22 Jan 2023 01:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0A1C433D2;
        Sun, 22 Jan 2023 01:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674350474;
        bh=jIJ++3Jtj6ZvS2RM47wi5MACpLRNnWzUgg8UXEqbB8Y=;
        h=Date:To:From:Subject:From;
        b=xN/N7/oSrkudie4oIPCj4JolaEZxEJOfMSfLa6ax50/YZsWmfiKXdLo03XED+Clhj
         UPAKtHCBrBJVZy5DC9eaiDMNuZP/5UJuVik0AR30zlXPAZQGaeNXaJKr3zH+zn/PJV
         ObHdG4phkSDR2won87Km+MZ33T9hkJ24MEdDWjkY=
Date:   Sat, 21 Jan 2023 17:21:13 -0800
To:     mm-commits@vger.kernel.org, quic_sibis@quicinc.com,
        manivannan.sadhasivam@linaro.org, andersson@kernel.org, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-remoteproc-qcom_q6v5_mss-map-unmap-metadata-region-before-after-use.patch added to mm-unstable branch
Message-Id: <20230122012114.3C0A1C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "remoteproc: qcom_q6v5_mss: map/unmap metadata region before/after use"
has been added to the -mm mm-unstable branch.  Its filename is
     revert-remoteproc-qcom_q6v5_mss-map-unmap-metadata-region-before-after-use.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-remoteproc-qcom_q6v5_mss-map-unmap-metadata-region-before-after-use.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: Revert "remoteproc: qcom_q6v5_mss: map/unmap metadata region before/after use"
Date: Tue Jan 17 14:28:34 2023 +0530
    
This reverts commit fc156629b23a21181e473e60341e3a78af25a1d4.

This commit manages to do three API violations at once:

 - dereference the return value of dma_alloc_attrs with the
   DMA_ATTR_NO_KERNEL_MAPPING mapping, which is clearly forbidden and
   will do the wrong thing on various dma mapping implementations.  The
   fact that dma-direct uses a struct page as a cookie is an undocumented
   implementation detail
 - include dma-map-ops.h and use pgprot_dmacoherent despite a clear
   comment documenting that this is not acceptable
 - use of the VM_DMA_COHERENT for something that is not the dma-mapping
   code
 - use of VM_FLUSH_RESET_PERMS for vmap, while it is only supported for
   vmalloc

Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sibi Sankar <quic_sibis@quicinc.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230117085840.32356-6-quic_sibis@quicinc.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/drivers/remoteproc/qcom_q6v5_mss.c~revert-remoteproc-qcom_q6v5_mss-map-unmap-metadata-region-before-after-use
+++ a/drivers/remoteproc/qcom_q6v5_mss.c
@@ -10,7 +10,6 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/devcoredump.h>
-#include <linux/dma-map-ops.h>
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
@@ -933,52 +932,27 @@ static void q6v5proc_halt_axi_port(struc
 static int q6v5_mpss_init_image(struct q6v5 *qproc, const struct firmware *fw,
 				const char *fw_name)
 {
-	unsigned long dma_attrs = DMA_ATTR_FORCE_CONTIGUOUS | DMA_ATTR_NO_KERNEL_MAPPING;
-	unsigned long flags = VM_DMA_COHERENT | VM_FLUSH_RESET_PERMS;
-	struct page **pages;
-	struct page *page;
+	unsigned long dma_attrs = DMA_ATTR_FORCE_CONTIGUOUS;
 	dma_addr_t phys;
 	void *metadata;
 	int mdata_perm;
 	int xferop_ret;
 	size_t size;
-	void *vaddr;
-	int count;
+	void *ptr;
 	int ret;
-	int i;
 
 	metadata = qcom_mdt_read_metadata(fw, &size, fw_name, qproc->dev);
 	if (IS_ERR(metadata))
 		return PTR_ERR(metadata);
 
-	page = dma_alloc_attrs(qproc->dev, size, &phys, GFP_KERNEL, dma_attrs);
-	if (!page) {
+	ptr = dma_alloc_attrs(qproc->dev, size, &phys, GFP_KERNEL, dma_attrs);
+	if (!ptr) {
 		kfree(metadata);
 		dev_err(qproc->dev, "failed to allocate mdt buffer\n");
 		return -ENOMEM;
 	}
 
-	count = PAGE_ALIGN(size) >> PAGE_SHIFT;
-	pages = kmalloc_array(count, sizeof(struct page *), GFP_KERNEL);
-	if (!pages) {
-		ret = -ENOMEM;
-		goto free_dma_attrs;
-	}
-
-	for (i = 0; i < count; i++)
-		pages[i] = nth_page(page, i);
-
-	vaddr = vmap(pages, count, flags, pgprot_dmacoherent(PAGE_KERNEL));
-	kfree(pages);
-	if (!vaddr) {
-		dev_err(qproc->dev, "unable to map memory region: %pa+%zx\n", &phys, size);
-		ret = -EBUSY;
-		goto free_dma_attrs;
-	}
-
-	memcpy(vaddr, metadata, size);
-
-	vunmap(vaddr);
+	memcpy(ptr, metadata, size);
 
 	/* Hypervisor mapping to access metadata by modem */
 	mdata_perm = BIT(QCOM_SCM_VMID_HLOS);
@@ -1008,7 +982,7 @@ static int q6v5_mpss_init_image(struct q
 			 "mdt buffer not reclaimed system may become unstable\n");
 
 free_dma_attrs:
-	dma_free_attrs(qproc->dev, size, page, phys, dma_attrs);
+	dma_free_attrs(qproc->dev, size, ptr, phys, dma_attrs);
 	kfree(metadata);
 
 	return ret < 0 ? ret : 0;
_

Patches currently in -mm which might be from hch@lst.de are

revert-remoteproc-qcom_q6v5_mss-map-unmap-metadata-region-before-after-use.patch
mm-reject-vmap-with-vm_flush_reset_perms.patch
mm-remove-__vfree.patch
mm-remove-__vfree_deferred.patch
mm-move-vmalloc_init-and-free_work-down-in-vmallocc.patch
mm-call-vfree-instead-of-__vunmap-from-delayed_vfree_work.patch
mm-move-__remove_vm_area-out-of-va_remove_mappings.patch
mm-use-remove_vm_area-in-__vunmap.patch
mm-move-debug-checks-from-__vunmap-to-remove_vm_area.patch
mm-split-__vunmap.patch
mm-refactor-va_remove_mappings.patch

