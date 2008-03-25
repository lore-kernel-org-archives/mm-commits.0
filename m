From: akpm@linux-foundation.org
Subject: - drivers-net-atarilancec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch removed from -mm tree
Date: Mon, 24 Mar 2008 17:19:25 -0700
Message-ID: <200803250019.m2P0JPCW032683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41098 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752351AbYCYA3H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 20:29:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkschind@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     drivers/net/atarilance.c: replace init_module&cleanup_module with module_init&module_exit
has been removed from the -mm tree.  Its filename was
     drivers-net-atarilancec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/atarilance.c: replace init_module&cleanup_module with module_init&module_exit
From: Jon Schindler <jkschind@gmail.com>

Replaced init_module and cleanup_module with static functions and
module_init/module_exit.

Signed-off-by: Jon Schindler <jkschind@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atarilance.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/net/atarilance.c~drivers-net-atarilancec-replace-init_modulecleanup_module-with-module_initmodule_exit drivers/net/atarilance.c
--- a/drivers/net/atarilance.c~drivers-net-atarilancec-replace-init_modulecleanup_module-with-module_initmodule_exit
+++ a/drivers/net/atarilance.c
@@ -1155,7 +1155,7 @@ static int lance_set_mac_address( struct
 #ifdef MODULE
 static struct net_device *atarilance_dev;
 
-int __init init_module(void)
+static int __init atarilance_module_init(void)
 {
 	atarilance_dev = atarilance_probe(-1);
 	if (IS_ERR(atarilance_dev))
@@ -1163,13 +1163,14 @@ int __init init_module(void)
 	return 0;
 }
 
-void __exit cleanup_module(void)
+static void __exit atarilance_module_exit(void)
 {
 	unregister_netdev(atarilance_dev);
 	free_irq(atarilance_dev->irq, atarilance_dev);
 	free_netdev(atarilance_dev);
 }
