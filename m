From: akpm@linux-foundation.org
Subject: [merged] bus-mhi-fix-printk-format-for-size_t.patch
 removed from -mm tree
Date: Thu, 26 Mar 2020 11:16:24 -0700
Message-ID: <20200326181624.dQfGyYm-3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728428AbgCZSQ0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 26 Mar 2020 14:16:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gregkh@linuxfoundation.org, hemantk@codeaurora.org, manivannan.sadhasivam@linaro.org, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: bus/mhi: fix printk format for size_t
has been removed from the -mm tree.  Its filename was
     bus-mhi-fix-printk-format-for-size_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: bus/mhi: fix printk format for size_t

Fix printk format warning by using %z for size_t modifier:

../drivers/bus/mhi/core/boot.c: In function `mhi_rddm_prepare':
../drivers/bus/mhi/core/boot.c:55:15: warning: format `%lx' expects argument of type `long unsigned int', but argument 5 has type `size_t {aka unsigned int}' [-Wformat=]
  dev_dbg(dev, "Address: %p and len: 0x%lx sequence: %u
",

Link: http://lkml.kernel.org/r/c4852a82-cdb9-6318-70a4-96ccb4ba5af2@infradead.org
Fixes: 6fdfdd27328ce ("bus: mhi: core: Add support for downloading RDDM image during panic")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: Hemant Kumar <hemantk@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bus/mhi/core/boot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bus/mhi/core/boot.c~bus-mhi-fix-printk-format-for-size_t
+++ a/drivers/bus/mhi/core/boot.c
@@ -52,7 +52,7 @@ void mhi_rddm_prepare(struct mhi_control
 			    BHIE_RXVECDB_SEQNUM_BMSK, BHIE_RXVECDB_SEQNUM_SHFT,
 			    sequence_id);
 
-	dev_dbg(dev, "Address: %p and len: 0x%lx sequence: %u\n",
+	dev_dbg(dev, "Address: %p and len: 0x%zx sequence: %u\n",
 		&mhi_buf->dma_addr, mhi_buf->len, sequence_id);
 }
 
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-mempolicy-require-at-least-one-nodeid-for-mpol_preferred.patch
mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t.patch
