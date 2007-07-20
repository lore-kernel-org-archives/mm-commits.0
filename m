From: akpm@linux-foundation.org
Subject: + spufs-change-decrementer-restore-timing.patch added to -mm tree
Date: Fri, 20 Jul 2007 11:51:11 -0700
Message-ID: <200707201851.l6KIpBXl010895@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56803 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758221AbXGTSv1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 14:51:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Masato.Noguchi@jp.sony.com, benh@kernel.crashing.org, jk@ozlabs.org, paulus@samba.org


The patch titled
     spufs: change decrementer restore timing
has been added to the -mm tree.  Its filename is
     spufs-change-decrementer-restore-timing.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spufs: change decrementer restore timing
From: Masato Noguchi <Masato.Noguchi@jp.sony.com>

The SPU decrementer should be restored after the LSCSA DMA has completed.

Signed-off-by: Masato Noguchi <Masato.Noguchi@jp.sony.com>
Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/spu_restore.c              |    4 -
 arch/powerpc/platforms/cell/spufs/spu_restore_dump.h_shipped |   36 +++++-----
 2 files changed, 20 insertions(+), 20 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/spu_restore.c~spufs-change-decrementer-restore-timing arch/powerpc/platforms/cell/spufs/spu_restore.c
--- a/arch/powerpc/platforms/cell/spufs/spu_restore.c~spufs-change-decrementer-restore-timing
+++ a/arch/powerpc/platforms/cell/spufs/spu_restore.c
@@ -84,7 +84,7 @@ static inline void restore_decr(void)
 	unsigned int decr_running;
 	unsigned int decr;
 
-	/* Restore, Step 6:
+	/* Restore, Step 6(moved):
 	 *    If the LSCSA "decrementer running" flag is set
 	 *    then write the SPU_WrDec channel with the
 	 *    decrementer value from LSCSA.
@@ -318,10 +318,10 @@ int main()
 	build_dma_list(lscsa_ea);	/* Step 3.  */
 	restore_upper_240kb(lscsa_ea);	/* Step 4.  */
 					/* Step 5: done by 'exit'. */
-	restore_decr();			/* Step 6. */
 	enqueue_putllc(lscsa_ea);	/* Step 7. */
 	set_tag_update();		/* Step 8. */
 	read_tag_status();		/* Step 9. */
+	restore_decr();			/* moved Step 6. */
 	read_llar_status();		/* Step 10. */
 	write_ppu_mb();			/* Step 11. */
 	write_ppuint_mb();		/* Step 12. */
diff -puN arch/powerpc/platforms/cell/spufs/spu_restore_dump.h_shipped~spufs-change-decrementer-restore-timing arch/powerpc/platforms/cell/spufs/spu_restore_dump.h_shipped
--- a/arch/powerpc/platforms/cell/spufs/spu_restore_dump.h_shipped~spufs-change-decrementer-restore-timing
+++ a/arch/powerpc/platforms/cell/spufs/spu_restore_dump.h_shipped
@@ -93,26 +93,21 @@ static unsigned int spu_restore_code[]  
 0x18020204,
 0x24000282,
 0x217ffa09,
-0x04000403,
-0x21a00803,
-0x3fbe0502,
-0x3fe30102,
-0x04000105,
-0x21a00885,
+0x04000402,
+0x21a00802,
+0x3fbe0504,
+0x3fe30204,
+0x21a00884,
 0x42074002,
 0x21a00902,
 0x40803c03,
 0x21a00983,
-0x04000484,
-0x21a00a04,
+0x04000485,
+0x21a00a05,
 0x40802202,
 0x21a00a82,
-0x30809c03,
-0x34000182,
-0x14004102,
-0x21002782,
-0x21a00804,
-0x21a00885,
+0x21a00805,
+0x21a00884,
 0x3fbf0582,
 0x3f200102,
 0x3fbe0102,
@@ -120,13 +115,17 @@ static unsigned int spu_restore_code[]  
 0x21a00902,
 0x40804003,
 0x21a00983,
-0x21a00a04,
+0x21a00a05,
 0x40805a02,
 0x21a00a82,
 0x40800083,
 0x21a00b83,
 0x01a00c02,
-0x01a00d84,
+0x30809c03,
+0x34000182,
+0x14004102,
+0x21002082,
+0x01a00d82,
 0x3080a003,
 0x34000182,
 0x21a00e02,
@@ -145,9 +144,10 @@ static unsigned int spu_restore_code[]  
 0x3080aa03,
 0x34000182,
 0x21a00b02,
+0x4020007f,
 0x3080ae02,
-0x3080ac04,
 0x42004805,
+0x3080ac04,
 0x34000103,
 0x34000202,
 0x1cffc183,
@@ -193,7 +193,7 @@ static unsigned int spu_restore_code[]  
 0x34000182,
 0x21a00382,
 0x4020007f,
-0x327fd700,
+0x327fde00,
 0x409ffe02,
 0x30801203,
 0x40800206,
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
