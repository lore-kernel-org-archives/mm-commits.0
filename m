From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bus-mhi-fix-printk-format-for-size_t.patch added to -mm
 tree
Date: Sat, 21 Mar 2020 21:41:36 -0700
Message-ID: <20200322044136.kjmPrLi3F%akpm@linux-foundation.org>
References: <20200321181954.c0564dfd5514cd742b534884@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbgCVElh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 22 Mar 2020 00:41:37 -0400
In-Reply-To: <20200321181954.c0564dfd5514cd742b534884@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hemantk@codeaurora.org, manivannan.sadhasivam@linaro.org, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: bus/mhi: fix printk format for size_t
has been added to the -mm tree.  Its filename is
     bus-mhi-fix-printk-format-for-size_t.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bus-mhi-fix-printk-format-for-size_t.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bus-mhi-fix-printk-format-for-size_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: bus/mhi: fix printk format for size_t

Fix printk format warning by using %z for size_t modifier:

../drivers/bus/mhi/core/boot.c: In function `mhi_rddm_prepare':
../drivers/bus/mhi/core/boot.c:55:15: warning: format `%lx' expects argument of type `long unsigned int', but argument 5 has type `size_t {aka unsigned int}' [-Wformat=]
  dev_dbg(dev, "Address: %p and len: 0x%lx sequence: %u
",

Link: http://lkml.kernel.org/r/c4852a82-cdb9-6318-70a4-96ccb4ba5af2@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: Hemant Kumar <hemantk@codeaurora.org>
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

mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t.patch
bus-mhi-fix-printk-format-for-size_t.patch
