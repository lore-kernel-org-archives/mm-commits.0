From: akpm@linux-foundation.org
Subject: [merged] moxa-remove-ifdef-module-completely.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:33:54 -0800
Message-ID: <200912292133.nBTLXsg0008738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752848AbZL2Vd5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:33:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rakib.mullick@gmail.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     moxa: remove #ifdef MODULE completely.
has been removed from the -mm tree.  Its filename was
     moxa-remove-ifdef-module-completely.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: moxa: remove #ifdef MODULE completely.
From: Rakib Mullick <rakib.mullick@gmail.com>

We can pass "module parameters" on the kernel command line even when
!MODULE.  So, #ifdef MODULE becomes obsolete.  Also move the declaration
moxa_board_conf at the start of the function, since we were hit by the
following warning.

drivers/char/moxa.c: In function `moxa_init':
drivers/char/moxa.c:1040: warning: ISO C90 forbids mixed declarations and code

Signed-off-by: Rakib Mullick<rakib.mullick@gmail.com>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff -puN drivers/char/moxa.c~moxa-remove-ifdef-module-completely drivers/char/moxa.c
--- a/drivers/char/moxa.c~moxa-remove-ifdef-module-completely
+++ a/drivers/char/moxa.c
@@ -164,24 +164,22 @@ static unsigned int moxaFuncTout = HZ / 
 static unsigned int moxaLowWaterChk;
 static DEFINE_MUTEX(moxa_openlock);
 static DEFINE_SPINLOCK(moxa_lock);
-/* Variables for insmod */
-#ifdef MODULE
+
 static unsigned long baseaddr[MAX_BOARDS];
 static unsigned int type[MAX_BOARDS];
 static unsigned int numports[MAX_BOARDS];
-#endif
 
 MODULE_AUTHOR("William Chen");
 MODULE_DESCRIPTION("MOXA Intellio Family Multiport Board Device Driver");
 MODULE_LICENSE("GPL");
-#ifdef MODULE
+
 module_param_array(type, uint, NULL, 0);
 MODULE_PARM_DESC(type, "card type: C218=2, C320=4");
 module_param_array(baseaddr, ulong, NULL, 0);
 MODULE_PARM_DESC(baseaddr, "base address");
 module_param_array(numports, uint, NULL, 0);
 MODULE_PARM_DESC(numports, "numports (ignored for C218)");
-#endif
+
 module_param(ttymajor, int, 0);
 
 /*
@@ -1024,6 +1022,8 @@ static int __init moxa_init(void)
 {
 	unsigned int isabrds = 0;
 	int retval = 0;
+	struct moxa_board_conf *brd = moxa_boards;
+	unsigned int i;
 
 	printk(KERN_INFO "MOXA Intellio family driver version %s\n",
 			MOXA_VERSION);
@@ -1051,10 +1051,7 @@ static int __init moxa_init(void)
 	}
 
 	/* Find the boards defined from module args. */
-#ifdef MODULE
-	{
-	struct moxa_board_conf *brd = moxa_boards;
-	unsigned int i;
+
 	for (i = 0; i < MAX_BOARDS; i++) {
 		if (!baseaddr[i])
 			break;
@@ -1087,8 +1084,6 @@ static int __init moxa_init(void)
 			isabrds++;
 		}
 	}
-	}
-#endif
 
 #ifdef CONFIG_PCI
 	retval = pci_register_driver(&moxa_pci_driver);
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

linux-next.patch

