From: akpm@linux-foundation.org
Subject: - drivers-net-3c515c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch removed from -mm tree
Date: Fri, 28 Mar 2008 15:07:36 -0700
Message-ID: <200803282207.m2SM7aGd013057@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758026AbYC1WIH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Mar 2008 18:08:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkschind@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/net/3c515.c: replace init_module&cleanup_module with module_init&module_exit
has been removed from the -mm tree.  Its filename was
     drivers-net-3c515c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/3c515.c: replace init_module&cleanup_module with module_init&module_exit
From: Jon Schindler <jkschind@gmail.com>

Replace init_module and cleanup_module with static functions and
module_init/module_exit.

Signed-off-by: Jon Schindler <jkschind@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/3c515.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/net/3c515.c~drivers-net-3c515c-replace-init_modulecleanup_module-with-module_initmodule_exit drivers/net/3c515.c
--- a/drivers/net/3c515.c~drivers-net-3c515c-replace-init_modulecleanup_module-with-module_initmodule_exit
+++ a/drivers/net/3c515.c
@@ -415,7 +415,7 @@ MODULE_PARM_DESC(max_interrupt_work, "3c
 /* we will need locking (and refcounting) if we ever use it for more */
 static LIST_HEAD(root_corkscrew_dev);
 
-int init_module(void)
+static int __init tc515_module_init(void)
 {
 	int found = 0;
 	if (debug >= 0)
@@ -426,6 +426,7 @@ int init_module(void)
 		found++;
 	return found ? 0 : -ENODEV;
 }
+module_init(tc515_module_init);
 
 #else
 struct net_device *tc515_probe(int unit)
@@ -1565,7 +1566,7 @@ static const struct ethtool_ops netdev_e
 
 
 #ifdef MODULE
-void cleanup_module(void)
+static void __exit tc515_module_exit(void)
 {
 	while (!list_empty(&root_corkscrew_dev)) {
 		struct net_device *dev;
@@ -1579,6 +1580,8 @@ void cleanup_module(void)
 		free_netdev(dev);
 	}
 }
+module_exit(tc515_module_exit);
+
 #endif				/* MODULE */
 
 /*
_

Patches currently in -mm which might be from jkschind@gmail.com are

git-net.patch
drivers-net-3c515c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-3c523c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-3c527c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-82596c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-block-floppyc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-char-ip2-ip2mainc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

