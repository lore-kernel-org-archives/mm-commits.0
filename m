From: akpm@linux-foundation.org
Subject: - drivers-net-82596c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch removed from -mm tree
Date: Fri, 28 Mar 2008 15:07:43 -0700
Message-ID: <200803282207.m2SM7hMc013066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758982AbYC1WIR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Mar 2008 18:08:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkschind@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/net/82596.c: replace init_module&cleanup_module with module_init&module_exit
has been removed from the -mm tree.  Its filename was
     drivers-net-82596c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/82596.c: replace init_module&cleanup_module with module_init&module_exit
From: Jon Schindler <jkschind@gmail.com>

Replace init_module and cleanup_module with static functions and
module_init/module_exit.

Signed-off-by: Jon Schindler <jkschind@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/82596.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/net/82596.c~drivers-net-82596c-replace-init_modulecleanup_module-with-module_initmodule_exit drivers/net/82596.c
--- a/drivers/net/82596.c~drivers-net-82596c-replace-init_modulecleanup_module-with-module_initmodule_exit
+++ a/drivers/net/82596.c
@@ -1567,7 +1567,7 @@ static int debug = -1;
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "i82596 debug mask");
 
-int __init init_module(void)
+static int __init i82596_module_init(void)
 {
 	if (debug >= 0)
 		i596_debug = debug;
@@ -1576,8 +1576,9 @@ int __init init_module(void)
 		return PTR_ERR(dev_82596);
 	return 0;
 }
+module_init(i82596_module_init);
 
-void __exit cleanup_module(void)
+static void __exit i82596_module_exit(void)
 {
 	unregister_netdev(dev_82596);
 #ifdef __mc68000__
@@ -1595,7 +1596,7 @@ void __exit cleanup_module(void)
 #endif
 	free_netdev(dev_82596);
 }
