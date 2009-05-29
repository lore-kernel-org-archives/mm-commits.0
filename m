From: akpm@linux-foundation.org
Subject: + sparc-add-sync_single_for_device-and-sync_sg_for_device-to-struct-dma_ops.patch added to -mm tree
Date: Fri, 29 May 2009 16:49:13 -0700
Message-ID: <200905292349.n4TNnE0R000795@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752454AbZE2XtR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 May 2009 19:49:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, reif@earthlink.net


The patch titled
     sparc: add sync_single_for_device and sync_sg_for_device to struct dma_ops
has been added to the -mm tree.  Its filename is
     sparc-add-sync_single_for_device-and-sync_sg_for_device-to-struct-dma_ops.patch

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
Subject: sparc: add sync_single_for_device and sync_sg_for_device to struct dma_ops
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This adds sync_single_for_device() and sync_sg_for_device() to struct
dma_ops in order to unify dma-mpping_{32|64}.h.  dma-mpping_32.h needs
them though dma-mpping_64.h doesn't.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Tested-by: Robert Reif <reif@earthlink.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/dma-mapping_64.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN arch/sparc/include/asm/dma-mapping_64.h~sparc-add-sync_single_for_device-and-sync_sg_for_device-to-struct-dma_ops arch/sparc/include/asm/dma-mapping_64.h
--- a/arch/sparc/include/asm/dma-mapping_64.h~sparc-add-sync_single_for_device-and-sync_sg_for_device-to-struct-dma_ops
+++ a/arch/sparc/include/asm/dma-mapping_64.h
@@ -23,9 +23,15 @@ struct dma_ops {
 	void (*sync_single_for_cpu)(struct device *dev,
 				    dma_addr_t dma_handle, size_t size,
 				    enum dma_data_direction direction);
+	void (*sync_single_for_device)(struct device *dev,
+				       dma_addr_t dma_handle, size_t size,
+				       enum dma_data_direction direction);
 	void (*sync_sg_for_cpu)(struct device *dev, struct scatterlist *sg,
 				int nelems,
 				enum dma_data_direction direction);
+	void (*sync_sg_for_device)(struct device *dev,
+				   struct scatterlist *sg, int nents,
+				   enum dma_data_direction dir);
 };
 extern const struct dma_ops *dma_ops;
 
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
vino-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
ib-mthca-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
net-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
sg_io-dont-perform-unneeded-copy-in-compat-code.patch
sparc-move-the-duplication-in-dma-mapping_3264h-to-dma-mappingh.patch
sparc-add-sync_single_for_device-and-sync_sg_for_device-to-struct-dma_ops.patch
sparc-use-dma_map_page-instead-of-dma_map_single.patch
sparc-remove-dma-mapping_3264h.patch
usb-replace-dma_sync_single-and-dma_sync_sg-with-dma_sync_single_for_cpu-and-dma_sync_sg_for_cpu.patch
dma-mapping-mark-dma_nbits_mask-as-deprecated.patch
dma-mapping-mark-dma_sync_single-and-dma_sync_sg-as-deprecated.patch
dma-mapping-add-asm-generic-dma-mapping-commonh.patch
dma-mapping-add-asm-generic-dma-mapping-commonh-fix.patch
dma-mapping-add-asm-generic-dma-mapping-commonh-fix-fix.patch
dma-mapping-x86-use-asm-generic-dma-mapping-commonh.patch
dma-mapping-ia64-use-asm-generic-dma-mapping-commonh.patch
dma-mapping-ia64-add-config_dma_api_debug-support.patch
dma-mapping-dma-debug-fix-compiler-warnings-on-ia64.patch

