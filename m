From: akpm@linux-foundation.org
Subject: + spufs-dont-halt-decrementer-at-restore-step-47.patch added to -mm tree
Date: Fri, 20 Jul 2007 11:51:09 -0700
Message-ID: <200707201851.l6KIp9S8010890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36151 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763949AbXGTSvZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 14:51:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Masato.Noguchi@jp.sony.com, benh@kernel.crashing.org, jk@ozlabs.org, paulus@samba.org


The patch titled
     spufs: don't halt decrementer at restore step 47
has been added to the -mm tree.  Its filename is
     spufs-dont-halt-decrementer-at-restore-step-47.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spufs: don't halt decrementer at restore step 47
From: Masato Noguchi <Masato.Noguchi@jp.sony.com>

No need to halt the SPE decrementer at context restore step 47, it will be
done in step 7.

Signed-off-by: Masato Noguchi <Masato.Noguchi@jp.sony.com>
Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/switch.c |   20 +++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/switch.c~spufs-dont-halt-decrementer-at-restore-step-47 arch/powerpc/platforms/cell/spufs/switch.c
--- a/arch/powerpc/platforms/cell/spufs/switch.c~spufs-dont-halt-decrementer-at-restore-step-47
+++ a/arch/powerpc/platforms/cell/spufs/switch.c
@@ -974,13 +974,13 @@ static inline void terminate_spu_app(str
 	 */
 }
 
-static inline void suspend_mfc(struct spu_state *csa, struct spu *spu)
+static inline void suspend_mfc_and_halt_decr(struct spu_state *csa,
+		struct spu *spu)
 {
 	struct spu_priv2 __iomem *priv2 = spu->priv2;
 
 	/* Restore, Step 7:
-	 * Restore, Step 47.
-	 *     Write MFC_Cntl[Dh,Sc]='1','1' to suspend
+	 *     Write MFC_Cntl[Dh,Sc,Sm]='1','1','0' to suspend
 	 *     the queue and halt the decrementer.
 	 */
 	out_be64(&priv2->mfc_control_RW, MFC_CNTL_SUSPEND_DMA_QUEUE |
@@ -1397,6 +1397,18 @@ static inline void restore_ls_16kb(struc
 	send_mfc_dma(spu, addr, ls_offset, size, tag, rclass, cmd);
 }
 
+static inline void suspend_mfc(struct spu_state *csa, struct spu *spu)
+{
+	struct spu_priv2 __iomem *priv2 = spu->priv2;
+
+	/* Restore, Step 47.
+	 *     Write MFC_Cntl[Sc,Sm]='1','0' to suspend
+	 *     the queue.
+	 */
+	out_be64(&priv2->mfc_control_RW, MFC_CNTL_SUSPEND_DMA_QUEUE);
+	eieio();
+}
+
 static inline void clear_interrupts(struct spu_state *csa, struct spu *spu)
 {
 	/* Restore, Step 49:
@@ -1926,7 +1938,7 @@ static void harvest(struct spu_state *pr
 	set_switch_pending(prev, spu);	        /* Step 5.  */
 	stop_spu_isolate(spu);			/* NEW.     */
 	remove_other_spu_access(prev, spu);	/* Step 6.  */
-	suspend_mfc(prev, spu);	                /* Step 7.  */
+	suspend_mfc_and_halt_decr(prev, spu);	/* Step 7.  */
 	wait_suspend_mfc_complete(prev, spu);	/* Step 8.  */
 	if (!suspend_spe(prev, spu))	        /* Step 9.  */
 		clear_spu_status(prev, spu);	/* Step 10. */
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
