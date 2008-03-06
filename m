From: akpm@linux-foundation.org
Subject: - drivers-net-apnec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:21:57 -0800
Message-ID: <200803062221.m26MLvlj020759@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751438AbYCFWWe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:22:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkschind@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     drivers/net/apne.c: replace init_module&cleanup_module with module_init&module_exit
has been removed from the -mm tree.  Its filename was
     drivers-net-apnec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/apne.c: replace init_module&cleanup_module with module_init&module_exit
From: Jon Schindler <jkschind@gmail.com>

Replaced init_module and cleanup_module with static functions and
module_init/module_exit.

Signed-off-by: Jon Schindler <jkschind@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/apne.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/net/apne.c~drivers-net-apnec-replace-init_modulecleanup_module-with-module_initmodule_exit drivers/net/apne.c
--- a/drivers/net/apne.c~drivers-net-apnec-replace-init_modulecleanup_module-with-module_initmodule_exit
+++ a/drivers/net/apne.c
@@ -569,7 +569,7 @@ static irqreturn_t apne_interrupt(int ir
 #ifdef MODULE
 static struct net_device *apne_dev;
 
-int __init init_module(void)
+static int __init apne_module_init(void)
 {
 	apne_dev = apne_probe(-1);
 	if (IS_ERR(apne_dev))
@@ -577,7 +577,7 @@ int __init init_module(void)
 	return 0;
 }
 
-void __exit cleanup_module(void)
+static void __exit apne_module_exit(void)
 {
 	unregister_netdev(apne_dev);
 
@@ -591,7 +591,8 @@ void __exit cleanup_module(void)
 
 	free_netdev(apne_dev);
 }
-
+module_init(apne_module_init);
+module_exit(apne_module_exit);
 #endif
 
 static int init_pcmcia(void)
_

Patches currently in -mm which might be from jkschind@gmail.com are

drivers-ide-idec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
git-net.patch
drivers-net-appletalk-copsc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-arcnet-com20020c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-at1700c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-atarilancec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-8390c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-3c501c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-3c505c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-3c507c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-3c515c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-3c523c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-3c527c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-82596c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-block-floppyc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-char-ip2-ip2mainc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

