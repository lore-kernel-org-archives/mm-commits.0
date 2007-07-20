From: akpm@linux-foundation.org
Subject: + spufs-remove-needless-context-save-restore-code.patch added to -mm tree
Date: Fri, 20 Jul 2007 11:51:01 -0700
Message-ID: <200707201851.l6KIp1I3010877@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33370 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762595AbXGTSvR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 14:51:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Masato.Noguchi@jp.sony.com, benh@kernel.crashing.org, jk@ozlabs.org, paulus@samba.org


The patch titled
     spufs: remove needless context save/restore code
has been added to the -mm tree.  Its filename is
     spufs-remove-needless-context-save-restore-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spufs: remove needless context save/restore code
From: Masato Noguchi <Masato.Noguchi@jp.sony.com>

The following steps are not needed in the SPE context save/restore
paths:

Save Step 12: save_mfc_decr()
  save suspend_time to CSA (It will be done by step 14)
  save ch 7 (decrementer value will be saved in LSCSA by spe-side step 10)

Restore Step 59: restore_ch_part1()
  restore ch 1 (it will be done by spe-side step 15)

This change removes the unnecessary steps.

Signed-off-by: Masato Noguchi <Masato.Noguchi@jp.sony.com>
Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/switch.c |   12 +-----------
 1 files changed, 1 insertion(+), 11 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/switch.c~spufs-remove-needless-context-save-restore-code arch/powerpc/platforms/cell/spufs/switch.c
--- a/arch/powerpc/platforms/cell/spufs/switch.c~spufs-remove-needless-context-save-restore-code
+++ a/arch/powerpc/platforms/cell/spufs/switch.c
@@ -253,11 +253,6 @@ static inline void save_mfc_decr(struct 
 	 */
 	if (in_be64(&priv2->mfc_control_RW) & MFC_CNTL_DECREMENTER_RUNNING) {
 		csa->priv2.mfc_control_RW |= MFC_CNTL_DECREMENTER_RUNNING;
-		csa->suspend_time = get_cycles();
-		out_be64(&priv2->spu_chnlcntptr_RW, 7ULL);
-		eieio();
-		csa->spu_chnldata_RW[7] = in_be64(&priv2->spu_chnldata_RW);
-		eieio();
 	} else {
 		csa->priv2.mfc_control_RW &= ~MFC_CNTL_DECREMENTER_RUNNING;
 	}
@@ -1567,13 +1562,8 @@ static inline void restore_ch_part1(stru
 	int i;
 
 	/* Restore, Step 59:
+	 *	Restore the following CH: [0,3,4,24,25,27]
 	 */
-
-	/* Restore CH 1 without count */
-	out_be64(&priv2->spu_chnlcntptr_RW, 1);
-	out_be64(&priv2->spu_chnldata_RW, csa->spu_chnldata_RW[1]);
-
-	/* Restore the following CH: [0,3,4,24,25,27] */
 	for (i = 0; i < ARRAY_SIZE(ch_indices); i++) {
 		idx = ch_indices[i];
 		out_be64(&priv2->spu_chnlcntptr_RW, idx);
_

Patches currently in -mm which might be from Masato.Noguchi@jp.sony.com are

origin.patch
spufs-fix-array-size-of-channel-index.patch
spufs-remove-needless-context-save-restore-code.patch
spufs-fix-decr_status-meanings.patch
spufs-fix-read-and-write-for-decr_status-file.patch
spufs-limit-saving-mfc_cntl-bits.patch
spufs-dont-halt-decrementer-at-restore-step-47.patch
spufs-change-decrementer-restore-timing.patch
spufs-use-find_first_bit-instead-of-sched_find_first_bit.patch
