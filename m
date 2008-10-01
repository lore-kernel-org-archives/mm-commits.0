From: akpm@linux-foundation.org
Subject: - drivers-infiniband-hw-drop-code-after-return.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:50:25 -0700
Message-ID: <200810012150.m91LoPHd005837@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753758AbYJAVu6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:50:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, richard.genoud@gmail.com, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     drivers/infiniband/hw: drop code after return
has been removed from the -mm tree.  Its filename was
     drivers-infiniband-hw-drop-code-after-return.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-v4l-dvb.patch
git-infiniband.patch
git-ieee1394.patch
git-async_tx.patch
git-net.patch
git-mtd.patch
git-sound.patch
git-cpufreq.patch
git-gfs2.patch
git-ubifs.patch
git-block.patch
drivers-media-common-tuners-drop-code-after-return-or-goto.patch
drivers-scsi-use-div_round_up.patch
drivers-scsi-megaraid-use-div_round_up.patch
fs-namespacec-drop-code-after-return.patch
drivers-misc-use-div_round_up.patch
drivers-net-xen-netfrontc-use-div_round_up.patch
fs-reiserfs-use-an-is_err-test-rather-than-a-null-test.patch

