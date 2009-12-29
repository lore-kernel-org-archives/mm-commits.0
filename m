From: akpm@linux-foundation.org
Subject: [merged] ip2-remove-ifdef-module-from-ip2mainc.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:33:57 -0800
Message-ID: <200912292133.nBTLXv4C008745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752340AbZL2VeA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:34:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rakib.mullick@gmail.com, mhw@WittsEnd.com, mm-commits@vger.kernel.org


The patch titled
     ip2: remove #ifdef MODULE from ip2main.c
has been removed from the -mm tree.  Its filename was
     ip2-remove-ifdef-module-from-ip2mainc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ip2: remove #ifdef MODULE from ip2main.c
From: Rakib Mullick <rakib.mullick@gmail.com>

On the kernel command line we can pass "module parameters".  So #ifdef
MODULE is obsolute now.  Remove it completely.  When CONFIG_PCI=n and
building ip2main.c then we are hit by the following warning.  So move
*pdev into #ifdef CONFIG_PCI.

drivers/char/ip2/ip2main.c: In function `ip2_loadmain':
drivers/char/ip2/ip2main.c:542: warning: unused variable `pdev'

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Acked-by: Michael H. Warfield <mhw@WittsEnd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip2/ip2main.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/char/ip2/ip2main.c~ip2-remove-ifdef-module-from-ip2mainc drivers/char/ip2/ip2main.c
--- a/drivers/char/ip2/ip2main.c~ip2-remove-ifdef-module-from-ip2mainc
+++ a/drivers/char/ip2/ip2main.c
@@ -263,7 +263,7 @@ static int tracewrap;
 /* Macros */
 /**********/
 
-#if defined(MODULE) && defined(IP2DEBUG_OPEN)
+#ifdef IP2DEBUG_OPEN
 #define DBG_CNT(s) printk(KERN_DEBUG "(%s): [%x] ttyc=%d, modc=%x -> %s\n", \
 		    tty->name,(pCh->flags), \
 		    tty->count,/*GET_USE_COUNT(module)*/0,s)
@@ -487,7 +487,6 @@ static const struct firmware *ip2_reques
 	return fw;
 }
 
-#ifndef MODULE
 /******************************************************************************
  *	ip2_setup:
  *		str: kernel command line string
@@ -531,7 +530,6 @@ static int __init ip2_setup(char *str)
 	return 1;
 }
 __setup("ip2=", ip2_setup);
-#endif /* !MODULE */
 
 static int __init ip2_loadmain(void)
 {
@@ -539,7 +537,6 @@ static int __init ip2_loadmain(void)
 	int err = 0;
 	i2eBordStrPtr pB = NULL;
 	int rc = -1;
-	struct pci_dev *pdev = NULL;
 	const struct firmware *fw = NULL;
 
 	if (poll_only) {
@@ -612,6 +609,7 @@ static int __init ip2_loadmain(void)
 		case PCI:
 #ifdef CONFIG_PCI
 		{
+			struct pci_dev *pdev = NULL;
 			u32 addr;
 			int status;
 
@@ -626,7 +624,7 @@ static int __init ip2_loadmain(void)
 
 			if (pci_enable_device(pdev)) {
 				dev_err(&pdev->dev, "can't enable device\n");
-				break;
+				goto out;
 			}
 			ip2config.type[i] = PCI;
 			ip2config.pci_dev[i] = pci_dev_get(pdev);
@@ -638,6 +636,8 @@ static int __init ip2_loadmain(void)
 				dev_err(&pdev->dev, "I/O address error\n");
 
 			ip2config.irq[i] = pdev->irq;
+out:
+			pci_dev_put(pdev);
 		}
 #else
 			printk(KERN_ERR "IP2: PCI card specified but PCI "
@@ -656,7 +656,6 @@ static int __init ip2_loadmain(void)
 			break;
 		}	/* switch */
 	}	/* for */
-	pci_dev_put(pdev);
 
 	for (i = 0; i < IP2_MAX_BOARDS; ++i) {
 		if (ip2config.addr[i]) {
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

linux-next.patch

