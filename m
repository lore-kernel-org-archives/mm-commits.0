From: akpm@osdl.org
Subject: - char-istallion-ifdef-eisa-code.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:10:14 -0800
Message-ID: <200612082010.kB8KAEmo002787@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58747 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946510AbWLHUKT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:10:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: istallion, ifdef eisa code
has been removed from the -mm tree.  Its filename was
     char-istallion-ifdef-eisa-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: istallion, ifdef eisa code
From: Jiri Slaby <jirislaby@gmail.com>

Disable compiling eisa stuff if STLI_EISAPROBE == 0.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/istallion.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN drivers/char/istallion.c~char-istallion-ifdef-eisa-code drivers/char/istallion.c
--- a/drivers/char/istallion.c~char-istallion-ifdef-eisa-code
+++ a/drivers/char/istallion.c
@@ -355,6 +355,7 @@ MODULE_PARM_DESC(board2, "Board 2 config
 module_param_array(board3, charp, NULL, 0);
 MODULE_PARM_DESC(board3, "Board 3 config -> name[,ioaddr[,memaddr]");
 
+#if STLI_EISAPROBE != 0
 /*
  *	Set up a default memory address table for EISA board probing.
  *	The default addresses are all bellow 1Mbyte, which has to be the
@@ -372,6 +373,7 @@ static unsigned long	stli_eisamemprobead
 };
 
 static int	stli_eisamempsize = ARRAY_SIZE(stli_eisamemprobeaddrs);
+#endif
 
 /*
  *	Define the Stallion PCI vendor and device IDs.
@@ -684,7 +686,9 @@ static struct stliport *stli_getport(uns
 
 static int	stli_initecp(struct stlibrd *brdp);
 static int	stli_initonb(struct stlibrd *brdp);
+#if STLI_EISAPROBE != 0
 static int	stli_eisamemprobe(struct stlibrd *brdp);
+#endif
 static int	stli_initports(struct stlibrd *brdp);
 
 /*****************************************************************************/
@@ -3711,6 +3715,7 @@ static int __devinit stli_brdinit(struct
 	return 0;
 }
 
+#if STLI_EISAPROBE != 0
 /*****************************************************************************/
 
 /*
@@ -3804,6 +3809,7 @@ static int stli_eisamemprobe(struct stli
 	}
 	return 0;
 }
+#endif
 
 static int stli_getbrdnr(void)
 {
@@ -3819,6 +3825,7 @@ static int stli_getbrdnr(void)
 	return -1;
 }
 
+#if STLI_EISAPROBE != 0
 /*****************************************************************************/
 
 /*
@@ -3894,6 +3901,9 @@ static int stli_findeisabrds(void)
 
 	return 0;
 }
+#else
+static inline int stli_findeisabrds(void) { return 0; }
+#endif
 
 /*****************************************************************************/
 
@@ -4019,8 +4029,7 @@ static int stli_initbrds(void)
 		stli_brdinit(brdp);
 	}
 
-	if (STLI_EISAPROBE)
-		stli_findeisabrds();
+	stli_findeisabrds();
 
 	retval = pci_register_driver(&stli_pcidriver);
 	/* TODO: check retval and do something */
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-istallion-ifdef-eisa-code.patch
char-istallion-brdnr-locking.patch
char-istallion-free-only-isa.patch
char-istallion-correct-fail-paths.patch
char-istallion-fix-enabling.patch
char-istallion-move-init-and-exit-code.patch
char-istallion-change-init-sequence.patch
char-istallion-dynamic-tty-device.patch
char-istallion-use-mod_timer.patch
char-cyclades-save-indent-levels.patch
char-cyclades-lindent-the-code.patch
char-cyclades-cleanup.patch
char-cyclades-fix-warnings.patch

