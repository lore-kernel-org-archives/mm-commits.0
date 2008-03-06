From: akpm@linux-foundation.org
Subject: + drivers-net-3c507c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch added to -mm tree
Date: Wed, 05 Mar 2008 16:12:35 -0800
Message-ID: <200803060012.m260CZdg029030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752650AbYCFANI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 19:13:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkschind@gmail.com


The patch titled
     drivers/net/3c507.c: replace init_module&cleanup_module with module_init&module_exit
has been added to the -mm tree.  Its filename is
     drivers-net-3c507c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/3c507.c: replace init_module&cleanup_module with module_init&module_exit
From: Jon Schindler <jkschind@gmail.com>

Replace init_module and cleanup_module with static functions and
module_init/module_exit.

Signed-off-by: Jon Schindler <jkschind@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/3c507.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/net/3c507.c~drivers-net-3c507c-replace-init_modulecleanup_module-with-module_initmodule_exit drivers/net/3c507.c
--- a/drivers/net/3c507.c~drivers-net-3c507c-replace-init_modulecleanup_module-with-module_initmodule_exit
+++ a/drivers/net/3c507.c
@@ -918,16 +918,16 @@ module_param(irq, int, 0);
 MODULE_PARM_DESC(io, "EtherLink16 I/O base address");
 MODULE_PARM_DESC(irq, "(ignored)");
 
-int __init init_module(void)
+static int __init tc507_module_init(void)
 {
 	if (io == 0)
 		printk("3c507: You should not use auto-probing with insmod!\n");
 	dev_3c507 = el16_probe(-1);
 	return IS_ERR(dev_3c507) ? PTR_ERR(dev_3c507) : 0;
 }
+module_init(tc507_module_init);
 
-void __exit
-cleanup_module(void)
+static void __exit tc507_module_exit(void)
 {
 	struct net_device *dev = dev_3c507;
 	unregister_netdev(dev);
@@ -936,6 +936,8 @@ cleanup_module(void)
 	release_region(dev->base_addr, EL16_IO_EXTENT);
 	free_netdev(dev);
 }
+module_exit(tc507_module_exit);
+
 #endif /* MODULE */
 MODULE_LICENSE("GPL");
 
_

Patches currently in -mm which might be from jkschind@gmail.com are

drivers-net-apnec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-appletalk-copsc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-appletalk-ltpcc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-arcnet-capmodec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-arcnet-com20020c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-at1700c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-atarilancec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-8390c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-ac3200c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-block-floppyc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-char-ip2-ip2mainc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-ide-idec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-3c501c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-3c505c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-3c507c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-3c515c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-3c523c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-3c527c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-82596c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

