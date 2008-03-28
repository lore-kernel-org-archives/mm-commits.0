From: akpm@linux-foundation.org
Subject: - drivers-net-3c505c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch removed from -mm tree
Date: Fri, 28 Mar 2008 15:07:32 -0700
Message-ID: <200803282207.m2SM7WHp013051@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757850AbYC1WIF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Mar 2008 18:08:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkschind@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/net/3c505.c: replace init_module&cleanup_module with module_init&module_exit
has been removed from the -mm tree.  Its filename was
     drivers-net-3c505c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/3c505.c: replace init_module&cleanup_module with module_init&module_exit
From: Jon Schindler <jkschind@gmail.com>

Replace init_module and cleanup_module with static functions and
module_init/module_exit.

Signed-off-by: Jon Schindler <jkschind@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/3c505.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/net/3c505.c~drivers-net-3c505c-replace-init_modulecleanup_module-with-module_initmodule_exit drivers/net/3c505.c
--- a/drivers/net/3c505.c~drivers-net-3c505c-replace-init_modulecleanup_module-with-module_initmodule_exit
+++ a/drivers/net/3c505.c
@@ -1615,7 +1615,7 @@ MODULE_PARM_DESC(io, "EtherLink Plus I/O
 MODULE_PARM_DESC(irq, "EtherLink Plus IRQ number(s) (assigned)");
 MODULE_PARM_DESC(dma, "EtherLink Plus DMA channel(s)");
 
-int __init init_module(void)
+static int __init tc505_module_init(void)
 {
 	int this_dev, found = 0;
 
@@ -1651,8 +1651,9 @@ int __init init_module(void)
 		return -ENODEV;
 	return 0;
 }
+module_init(tc505_module_init);
 
-void __exit cleanup_module(void)
+static void __exit tc505_module_exit(void)
 {
 	int this_dev;
 
@@ -1665,6 +1666,7 @@ void __exit cleanup_module(void)
 		}
 	}
 }
+module_exit(tc505_module_exit);
 
 #endif				/* MODULE */
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from jkschind@gmail.com are

git-net.patch
drivers-net-3c505c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-3c507c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-3c515c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-3c523c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-3c527c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-82596c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-block-floppyc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-char-ip2-ip2mainc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

