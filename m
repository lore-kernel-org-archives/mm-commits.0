From: akpm@linux-foundation.org
Subject: [patch 059/126] drivers/scsi/sym53c8xx_2/sym_hipd.c:
 convert to use memset32
Date: Fri, 08 Sep 2017 16:14:11 -0700
Message-ID: <20170908231411.Sy_O1DoE1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52488 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757173AbdIHXON (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:14:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, hpa@zytor.com, ink@jurassic.park.msu.ru, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, mattst88@gmail.com, mawilcox@microsoft.com, minchan@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, mpe@ellerman.id.au, ralf@linux-mips.org, rmk+kernel@armlinux.org.uk, rth@twiddle.net, sam@ravnborg.org, sergey.senozhatsky@gmail.com, tglx@linutronix.de, torvalds@linux-foundation.org

From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: drivers/scsi/sym53c8xx_2/sym_hipd.c: convert to use memset32

memset32() can be used to initialise these three arrays.  Minor code
footprint reduction.

Link: http://lkml.kernel.org/r/20170720184539.31609-8-willy@infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sym53c8xx_2/sym_hipd.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/sym53c8xx_2/sym_hipd.c~sym53c8xx_2-convert-to-use-memset32 drivers/scsi/sym53c8xx_2/sym_hipd.c
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c~sym53c8xx_2-convert-to-use-memset32
+++ a/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -4985,13 +4985,10 @@ struct sym_lcb *sym_alloc_lcb (struct sy
 	 *  Compute the bus address of this table.
 	 */
 	if (ln && !tp->luntbl) {
-		int i;
-
 		tp->luntbl = sym_calloc_dma(256, "LUNTBL");
 		if (!tp->luntbl)
 			goto fail;
-		for (i = 0 ; i < 64 ; i++)
-			tp->luntbl[i] = cpu_to_scr(vtobus(&np->badlun_sa));
+		memset32(tp->luntbl, cpu_to_scr(vtobus(&np->badlun_sa)), 64);
 		tp->head.luntbl_sa = cpu_to_scr(vtobus(tp->luntbl));
 	}
 
@@ -5077,8 +5074,7 @@ static void sym_alloc_lcb_tags (struct s
 	/*
 	 *  Initialize the task table with invalid entries.
 	 */
-	for (i = 0 ; i < SYM_CONF_MAX_TASK ; i++)
-		lp->itlq_tbl[i] = cpu_to_scr(np->notask_ba);
+	memset32(lp->itlq_tbl, cpu_to_scr(np->notask_ba), SYM_CONF_MAX_TASK);
 
 	/*
 	 *  Fill up the tag buffer with tag numbers.
@@ -5764,8 +5760,7 @@ int sym_hcb_attach(struct Scsi_Host *sho
 		goto attach_failed;
 
 	np->badlun_sa = cpu_to_scr(SCRIPTB_BA(np, resel_bad_lun));
-	for (i = 0 ; i < 64 ; i++)	/* 64 luns/target, no less */
-		np->badluntbl[i] = cpu_to_scr(vtobus(&np->badlun_sa));
+	memset32(np->badluntbl, cpu_to_scr(vtobus(&np->badlun_sa)), 64);
 
 	/*
 	 *  Prepare the bus address array that contains the bus 
_
