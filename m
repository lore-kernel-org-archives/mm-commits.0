From: akpm@linux-foundation.org
Subject: - drivers-net-at1700c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch removed from -mm tree
Date: Mon, 24 Mar 2008 17:19:23 -0700
Message-ID: <200803250019.m2P0JN3C032680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753851AbYCYAT7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 20:19:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkschind@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     drivers/net/at1700.c: replace init_module&cleanup_module with module_init&module_exit
has been removed from the -mm tree.  Its filename was
     drivers-net-at1700c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/at1700.c: replace init_module&cleanup_module with module_init&module_exit
From: Jon Schindler <jkschind@gmail.com>

Replaced init_module and cleanup_module with static functions and
module_init/module_exit.

Signed-off-by: Jon Schindler <jkschind@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/at1700.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/net/at1700.c~drivers-net-at1700c-replace-init_modulecleanup_module-with-module_initmodule_exit drivers/net/at1700.c
--- a/drivers/net/at1700.c~drivers-net-at1700c-replace-init_modulecleanup_module-with-module_initmodule_exit
+++ a/drivers/net/at1700.c
@@ -881,7 +881,7 @@ MODULE_PARM_DESC(io, "AT1700/FMV18X I/O 
 MODULE_PARM_DESC(irq, "AT1700/FMV18X IRQ number");
 MODULE_PARM_DESC(net_debug, "AT1700/FMV18X debug level (0-6)");
 
-int __init init_module(void)
+static int __init at1700_module_init(void)
 {
 	if (io == 0)
 		printk("at1700: You should not use auto-probing with insmod!\n");
@@ -891,13 +891,14 @@ int __init init_module(void)
 	return 0;
 }
 
-void __exit
-cleanup_module(void)
+static void __exit at1700_module_exit(void)
 {
 	unregister_netdev(dev_at1700);
 	cleanup_card(dev_at1700);
 	free_netdev(dev_at1700);
 }
+module_init(at1700_module_init);
+module_exit(at1700_module_exit);
 #endif /* MODULE */
 MODULE_LICENSE("GPL");
 
_

Patches currently in -mm which might be from jkschind@gmail.com are

drivers-ide-idec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
git-net.patch
drivers-net-3c501c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-3c505c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-3c507c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-3c515c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-3c523c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-3c527c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-82596c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-block-floppyc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-char-ip2-ip2mainc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

