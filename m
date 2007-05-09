From: akpm@linux-foundation.org
Subject: - char-cyclades-fix-tty-device-unregister.patch removed from -mm tree
Date: Tue, 08 May 2007 19:58:54 -0700
Message-ID: <200705090258.l492ws6q010324@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970222AbXEIC66 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:58:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, fix tty device unregister
has been removed from the -mm tree.  Its filename was
     char-cyclades-fix-tty-device-unregister.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, fix tty device unregister
From: Jiri Slaby <jirislaby@gmail.com>

put_tty_driver after unregistering devices

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-fix-tty-device-unregister drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-fix-tty-device-unregister
+++ a/drivers/char/cyclades.c
@@ -5285,8 +5285,6 @@ static void __exit cy_cleanup_module(voi
 		printk(KERN_ERR "failed to unregister Cyclades serial "
 				"driver(%d)\n", e1);
 
-	put_tty_driver(cy_serial_driver);
-
 #ifdef CONFIG_PCI
 	pci_unregister_driver(&cy_pci_driver);
 #endif
@@ -5310,6 +5308,8 @@ static void __exit cy_cleanup_module(voi
 				tty_unregister_device(cy_serial_driver, e1);
 		}
 	}
+
+	put_tty_driver(cy_serial_driver);
 } /* cy_cleanup_module */
 
 module_init(cy_init);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
