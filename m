From: akpm@linux-foundation.org
Subject: - drivers-net-3c501c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch removed from -mm tree
Date: Fri, 28 Mar 2008 15:07:30 -0700
Message-ID: <200803282207.m2SM7Ug3013048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756517AbYC1WID (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Mar 2008 18:08:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkschind@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/net/3c501.c: replace init_module&cleanup_module with module_init&module_exit
has been removed from the -mm tree.  Its filename was
     drivers-net-3c501c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/3c501.c: replace init_module&cleanup_module with module_init&module_exit
From: Jon Schindler <jkschind@gmail.com>

Replace init_module and cleanup_module with static functions and
module_init/module_exit.

Signed-off-by: Jon Schindler <jkschind@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/3c501.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/net/3c501.c~drivers-net-3c501c-replace-init_modulecleanup_module-with-module_initmodule_exit drivers/net/3c501.c
--- a/drivers/net/3c501.c~drivers-net-3c501c-replace-init_modulecleanup_module-with-module_initmodule_exit
+++ a/drivers/net/3c501.c
@@ -869,13 +869,14 @@ MODULE_PARM_DESC(irq, "EtherLink IRQ num
  * here also causes the module to be unloaded
  */
 
-int __init init_module(void)
+static int __init tc501_module_init(void)
 {
 	dev_3c501 = el1_probe(-1);
 	if (IS_ERR(dev_3c501))
 		return PTR_ERR(dev_3c501);
 	return 0;
 }
+module_init(tc501_module_init);
 
 /**
  * cleanup_module:
@@ -884,13 +885,14 @@ int __init init_module(void)
  * and then free up the resources we took when the card was found.
  */
 
-void __exit cleanup_module(void)
+static void __exit tc501_module_exit(void)
 {
 	struct net_device *dev = dev_3c501;
 	unregister_netdev(dev);
 	release_region(dev->base_addr, EL1_IO_EXTENT);
 	free_netdev(dev);
 }
+module_exit(tc501_module_exit);
 
 #endif /* MODULE */
 
_

Patches currently in -mm which might be from jkschind@gmail.com are

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

