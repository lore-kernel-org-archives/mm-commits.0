From: akpm@linux-foundation.org
Subject: - spufs-limit-saving-mfc_cntl-bits.patch removed from -mm tree
Date: Sat, 21 Jul 2007 03:25:40 -0700
Message-ID: <200707211025.l6LAPekG012013@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42974 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932917AbXGUK0V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Jul 2007 06:26:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Masato.Noguchi@jp.sony.com, benh@kernel.crashing.org, jk@ozlabs.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     spufs: limit saving MFC_CNTL bits
has been removed from the -mm tree.  Its filename was
     spufs-limit-saving-mfc_cntl-bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spufs: limit saving MFC_CNTL bits
From: Masato Noguchi <Masato.Noguchi@jp.sony.com>

At save step 8, the mfc control register in the CSA should be written _only_
with Sc and Sm bits (at least MFC_CNTL[Dh] should be set to 0)

Signed-off-by: Masato Noguchi <Masato.Noguchi@jp.sony.com>
Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/switch.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/switch.c~spufs-limit-saving-mfc_cntl-bits arch/powerpc/platforms/cell/spufs/switch.c
--- a/arch/powerpc/platforms/cell/spufs/switch.c~spufs-limit-saving-mfc_cntl-bits
+++ a/arch/powerpc/platforms/cell/spufs/switch.c
@@ -180,7 +180,7 @@ static inline void save_mfc_cntl(struct 
 	case MFC_CNTL_SUSPEND_COMPLETE:
 		if (csa) {
 			csa->priv2.mfc_control_RW =
-				in_be64(&priv2->mfc_control_RW) |
+				MFC_CNTL_SUSPEND_MASK |
 				MFC_CNTL_SUSPEND_DMA_QUEUE;
 		}
 		break;
@@ -190,9 +190,7 @@ static inline void save_mfc_cntl(struct 
 				  MFC_CNTL_SUSPEND_DMA_STATUS_MASK) ==
 				 MFC_CNTL_SUSPEND_COMPLETE);
 		if (csa) {
-			csa->priv2.mfc_control_RW =
-				in_be64(&priv2->mfc_control_RW) &
-				~MFC_CNTL_SUSPEND_DMA_QUEUE;
+			csa->priv2.mfc_control_RW = 0;
 		}
 		break;
 	}
@@ -251,11 +249,8 @@ static inline void save_mfc_decr(struct 
 	 *     Read MFC_CNTL[Ds].  Update saved copy of
 	 *     CSA.MFC_CNTL[Ds].
 	 */
-	if (in_be64(&priv2->mfc_control_RW) & MFC_CNTL_DECREMENTER_RUNNING) {
-		csa->priv2.mfc_control_RW |= MFC_CNTL_DECREMENTER_RUNNING;
-	} else {
-		csa->priv2.mfc_control_RW &= ~MFC_CNTL_DECREMENTER_RUNNING;
-	}
+	csa->priv2.mfc_control_RW |=
+		in_be64(&priv2->mfc_control_RW) & MFC_CNTL_DECREMENTER_RUNNING;
 }
 
 static inline void halt_mfc_decr(struct spu_state *csa, struct spu *spu)
_

Patches currently in -mm which might be from Masato.Noguchi@jp.sony.com are

origin.patch
