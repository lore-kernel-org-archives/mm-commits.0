From: akpm@linux-foundation.org
Subject: - char-moxa-notify-about-board-readiness.patch removed from -mm tree
Date: Thu, 01 May 2008 02:29:30 -0700
Message-ID: <200805010929.m419TUT8030685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757419AbYEAJ3e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:29:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, notify about board readiness
has been removed from the -mm tree.  Its filename was
     char-moxa-notify-about-board-readiness.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: moxa, notify about board readiness
From: Jiri Slaby <jirislaby@gmail.com>

Drop a message to dmesg about card being ready.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/char/moxa.c~char-moxa-notify-about-board-readiness drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-notify-about-board-readiness
+++ a/drivers/char/moxa.c
@@ -961,6 +961,9 @@ static int __devinit moxa_pci_probe(stru
 
 	pci_set_drvdata(pdev, board);
 
+	dev_info(&pdev->dev, "board '%s' ready (%u ports, firmware loaded)\n",
+			moxa_brdname[board_type - 1], board->numPorts);
+
 	return 0;
 err_base:
 	iounmap(board->basemem);
@@ -1047,6 +1050,10 @@ static int __init moxa_init(void)
 				continue;
 			}
 
+			printk(KERN_INFO "MOXA isa board found at 0x%.8lu and "
+					"ready (%u ports, firmware loaded)\n",
+					baseaddr[i], brd->numPorts);
+
 			brd++;
 			isabrds++;
 		}
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

