From: akpm@linux-foundation.org
Subject: + drivers-net-appletalk-ltpcc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch added to -mm tree
Date: Fri, 29 Feb 2008 15:25:24 -0800
Message-ID: <200802292325.m1TNPOqw026122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757878AbYB2XZj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 18:25:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkschind@gmail.com, jeff@garzik.org


The patch titled
     drivers/net/appletalk/ltpc.c: replace init_module&cleanup_module with module_init&module_exit
has been added to the -mm tree.  Its filename is
     drivers-net-appletalk-ltpcc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

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
Subject: drivers/net/appletalk/ltpc.c: replace init_module&cleanup_module with module_init&module_exit
From: Jon Schindler <jkschind@gmail.com>

Replaced init_module and cleanup_module with static functions and
module_init/module_exit.

Signed-off-by: Jon Schindler <jkschind@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/appletalk/ltpc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/appletalk/ltpc.c~drivers-net-appletalk-ltpcc-replace-init_modulecleanup_module-with-module_initmodule_exit drivers/net/appletalk/ltpc.c
--- a/drivers/net/appletalk/ltpc.c~drivers-net-appletalk-ltpcc-replace-init_modulecleanup_module-with-module_initmodule_exit
+++ a/drivers/net/appletalk/ltpc.c
@@ -1252,7 +1252,7 @@ module_param(irq, int, 0);
 module_param(dma, int, 0);
 
 
-int __init init_module(void)
+static int __init ltpc_module_init(void)
 {
         if(io == 0)
 		printk(KERN_NOTICE
@@ -1263,6 +1263,7 @@ int __init init_module(void)
 		return PTR_ERR(dev_ltpc);
 	return 0;
 }
+module_init(ltpc_module_init);
 #endif
 
 static void __exit ltpc_cleanup(void)
_

Patches currently in -mm which might be from jkschind@gmail.com are

drivers-net-8390c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-apnec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-appletalk-copsc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-appletalk-ltpcc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-arcnet-capmodec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-arcnet-com20020c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-at1700c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
drivers-net-atarilancec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

