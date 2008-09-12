From: akpm@linux-foundation.org
Subject: + drivers-dma-ioat_dmac-drop-code-after-return.patch added to -mm tree
Date: Fri, 12 Sep 2008 12:40:15 -0700
Message-ID: <200809121940.m8CJeFam000577@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752013AbYILToV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Sep 2008 15:44:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, dan.j.williams@intel.com, richard.genoud@gmail.com


The patch titled
     drivers/dma/ioat_dma.c: drop code after return
has been added to the -mm tree.  Its filename is
     drivers-dma-ioat_dmac-drop-code-after-return.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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
fs-gfs2-use-an-is_err-test-rather-than-a-null-test.patch
arch-ia64-sn-pci-tioca_providerc-introduce-missing-kfree.patch
drivers-atm-use-div_round_up.patch
drivers-net-wan-use-div_round_up.patch
drivers-isdn-capi-kcapic-adjust-error-handling-code-involving-capi_ctr_put.patch
drivers-scsi-use-div_round_up.patch
drivers-scsi-megaraid-use-div_round_up.patch
drivers-block-use-div_round_up.patch
drivers-usb-misc-use-an-is_err-test-rather-than-a-null-test.patch
net-9p-trans_fdc-introduce-missing-kfree.patch
drivers-misc-use-div_round_up.patch
drivers-net-xen-netfrontc-use-div_round_up.patch
fs-reiserfs-use-an-is_err-test-rather-than-a-null-test.patch
drivers-infiniband-hw-drop-code-after-return.patch
drivers-media-common-tuners-drop-code-after-return-or-goto.patch
fs-namespacec-drop-code-after-return.patch
net-atm-lecc-drop-code-after-return.patch
drivers-dma-ioat_dmac-drop-code-after-return.patch

