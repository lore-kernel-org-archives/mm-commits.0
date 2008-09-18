From: akpm@linux-foundation.org
Subject: - drivers-dma-ioat_dmac-drop-code-after-return.patch removed from -mm tree
Date: Thu, 18 Sep 2008 13:56:41 -0700
Message-ID: <200809182056.m8IKufPA019207@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754941AbYIRU4s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Sep 2008 16:56:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, dan.j.williams@intel.com, maciej.sosnowski@intel.com, richard.genoud@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/dma/ioat_dma.c: drop code after return
has been removed from the -mm tree.  Its filename was
     drivers-dma-ioat_dmac-drop-code-after-return.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/dma/ioat_dma.c: drop code after return
From: Julia Lawall <julia@diku.dk>

The break after the return serves no purpose.

Signed-off-by: Julia Lawall <julia@diku.dk>
Reviewed-by: Richard Genoud <richard.genoud@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ioat_dma.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/dma/ioat_dma.c~drivers-dma-ioat_dmac-drop-code-after-return drivers/dma/ioat_dma.c
--- a/drivers/dma/ioat_dma.c~drivers-dma-ioat_dmac-drop-code-after-return
+++ a/drivers/dma/ioat_dma.c
@@ -971,11 +971,9 @@ static struct ioat_desc_sw *ioat_dma_get
 	switch (ioat_chan->device->version) {
 	case IOAT_VER_1_2:
 		return ioat1_dma_get_next_descriptor(ioat_chan);
-		break;
 	case IOAT_VER_2_0:
 	case IOAT_VER_3_0:
 		return ioat2_dma_get_next_descriptor(ioat_chan);
-		break;
 	}
 	return NULL;
 }
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-media-common-tuners-drop-code-after-return-or-goto.patch
drivers-infiniband-hw-drop-code-after-return.patch
drivers-atm-use-div_round_up.patch
net-atm-lecc-drop-code-after-return.patch
drivers-net-wan-use-div_round_up.patch
drivers-isdn-capi-kcapic-adjust-error-handling-code-involving-capi_ctr_put.patch
drivers-scsi-use-div_round_up.patch
drivers-scsi-megaraid-use-div_round_up.patch
drivers-block-use-div_round_up.patch
net-9p-trans_fdc-introduce-missing-kfree.patch
fs-9p-use-an-is_err-test-rather-than-a-null-test.patch
fs-namespacec-drop-code-after-return.patch
drivers-misc-use-div_round_up.patch
drivers-net-xen-netfrontc-use-div_round_up.patch
fs-reiserfs-use-an-is_err-test-rather-than-a-null-test.patch

