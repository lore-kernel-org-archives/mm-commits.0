From: akpm@osdl.org
Subject: + m68k-atari-2618-atari-ide-interrupt-needs-sa_shirq.patch added to -mm tree
Date: Sat, 09 Dec 2006 14:33:26 -0800
Message-ID: <200612092233.kB9MXQT5006109@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55680 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758877AbWLIWf0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 9 Dec 2006 17:35:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: schmitz@opal.biophys.uni-duesseldorf.de, B.Zolnierkiewicz@elka.pw.edu.pl, alan@lxorguk.ukuu.org.uk, geert@linux-m68k.org, schmitz@biophys.uni-duesseldorf.de


The patch titled
     m68k/Atari: 2.6.18 Atari IDE interrupt needs SA_SHIRQ
has been added to the -mm tree.  Its filename is
     m68k-atari-2618-atari-ide-interrupt-needs-sa_shirq.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m68k/Atari: 2.6.18 Atari IDE interrupt needs SA_SHIRQ
From: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>

Atari IDE: The interrupt needs SA_SHIRQ now to get registered.

Signed-off-by: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/m68k/atari/stdma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/m68k/atari/stdma.c~m68k-atari-2618-atari-ide-interrupt-needs-sa_shirq arch/m68k/atari/stdma.c
--- a/arch/m68k/atari/stdma.c~m68k-atari-2618-atari-ide-interrupt-needs-sa_shirq
+++ a/arch/m68k/atari/stdma.c
@@ -174,7 +174,7 @@ int stdma_islocked(void)
 void __init stdma_init(void)
 {
 	stdma_isr = NULL;
-	request_irq(IRQ_MFP_FDC, stdma_int, IRQ_TYPE_SLOW,
+	request_irq(IRQ_MFP_FDC, stdma_int, IRQ_TYPE_SLOW | SA_SHIRQ,
 	            "ST-DMA: floppy/ACSI/IDE/Falcon-SCSI", stdma_int);
 }
 
_

Patches currently in -mm which might be from schmitz@opal.biophys.uni-duesseldorf.de are

m68k-atari-2618-atari-ide-interrupt-needs-sa_shirq.patch

