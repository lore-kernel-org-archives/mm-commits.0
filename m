From: akpm@linux-foundation.org
Subject: + ip2-remove-ifdef-module-from-ip2mainc.patch added to -mm tree
Date: Wed, 02 Dec 2009 15:06:24 -0800
Message-ID: <200912022306.nB2N6OOF018470@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754649AbZLBXGt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2009 18:06:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com, mhw@WittsEnd.com


The patch titled
     ip2: remove #ifdef MODULE from ip2main.c
has been added to the -mm tree.  Its filename is
     ip2-remove-ifdef-module-from-ip2mainc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

 drivers/char/ip2/ip2main.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

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
 
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

linux-next.patch
mm-fix-section-mismatch-in-memory_hotplugc.patch
moxa-remove-ifdef-module-completely.patch
ip2-remove-ifdef-module-from-ip2mainc.patch

