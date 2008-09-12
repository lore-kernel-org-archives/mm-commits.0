From: akpm@linux-foundation.org
Subject: + drivers-infiniband-hw-drop-code-after-return.patch added to -mm tree
Date: Fri, 12 Sep 2008 12:40:06 -0700
Message-ID: <200809121940.m8CJe6Kk000565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753202AbYILTko (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Sep 2008 15:40:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, richard.genoud@gmail.com, rolandd@cisco.com


The patch titled
     drivers/infiniband/hw: drop code after return
has been added to the -mm tree.  Its filename is
     drivers-infiniband-hw-drop-code-after-return.patch

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
Subject: drivers/infiniband/hw: drop code after return
From: Julia Lawall <julia@diku.dk>

The break after the return serves no purpose.

Signed-off-by: Julia Lawall <julia@diku.dk>
Reviewed-by: Richard Genoud <richard.genoud@gmail.com>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/amso1100/c2_provider.c |    1 -
 drivers/infiniband/hw/nes/nes_verbs.c        |    3 ---
 2 files changed, 4 deletions(-)

diff -puN drivers/infiniband/hw/amso1100/c2_provider.c~drivers-infiniband-hw-drop-code-after-return drivers/infiniband/hw/amso1100/c2_provider.c
--- a/drivers/infiniband/hw/amso1100/c2_provider.c~drivers-infiniband-hw-drop-code-after-return
+++ a/drivers/infiniband/hw/amso1100/c2_provider.c
@@ -272,7 +272,6 @@ static struct ib_qp *c2_create_qp(struct
 		pr_debug("%s: Invalid QP type: %d\n", __func__,
 			init_attr->qp_type);
 		return ERR_PTR(-EINVAL);
-		break;
 	}
 
 	if (err) {
diff -puN drivers/infiniband/hw/nes/nes_verbs.c~drivers-infiniband-hw-drop-code-after-return drivers/infiniband/hw/nes/nes_verbs.c
--- a/drivers/infiniband/hw/nes/nes_verbs.c~drivers-infiniband-hw-drop-code-after-return
+++ a/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1467,7 +1467,6 @@ static struct ib_qp *nes_create_qp(struc
 		default:
 			nes_debug(NES_DBG_QP, "Invalid QP type: %d\n", init_attr->qp_type);
 			return ERR_PTR(-EINVAL);
-			break;
 	}
 
 	/* update the QP table */
@@ -2498,7 +2497,6 @@ static struct ib_mr *nes_reg_user_mr(str
 			nes_debug(NES_DBG_MR, "Leaving, ibmr=%p", ibmr);
 
 			return ibmr;
-			break;
 		case IWNES_MEMREG_TYPE_QP:
 		case IWNES_MEMREG_TYPE_CQ:
 			nespbl = kzalloc(sizeof(*nespbl), GFP_KERNEL);
@@ -2572,7 +2570,6 @@ static struct ib_mr *nes_reg_user_mr(str
 			nesmr->ibmr.lkey = -1;
 			nesmr->mode = req.reg_type;
 			return &nesmr->ibmr;
-			break;
 	}
 
 	return ERR_PTR(-ENOSYS);
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

