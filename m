From: akpm@linux-foundation.org
Subject: + drivers-net-arcnet-capmodec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch added to -mm tree
Date: Fri, 29 Feb 2008 15:25:26 -0800
Message-ID: <200802292325.m1TNPQxV026125@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758796AbYB2XZd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 18:25:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkschind@gmail.com, jeff@garzik.org


The patch titled
     drivers/net/arcnet/capmode.c: replace init_module&cleanup_module with module_init&module_exit
has been added to the -mm tree.  Its filename is
     drivers-net-arcnet-capmodec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

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
Subject: drivers/net/arcnet/capmode.c: replace init_module&cleanup_module with module_init&module_exit
From: Jon Schindler <jkschind@gmail.com>

Replaced init_module and cleanup_module with static functions and
module_init/module_exit.

Signed-off-by: Jon Schindler <jkschind@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/arcnet/capmode.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/net/arcnet/capmode.c~drivers-net-arcnet-capmodec-replace-init_modulecleanup_module-with-module_initmodule_exit drivers/net/arcnet/capmode.c
--- a/drivers/net/arcnet/capmode.c~drivers-net-arcnet-capmodec-replace-init_modulecleanup_module-with-module_initmodule_exit
+++ a/drivers/net/arcnet/capmode.c
@@ -80,17 +80,19 @@ void arcnet_cap_init(void)
 
 #ifdef MODULE
 
-int __init init_module(void)
+static int __init capmode_module_init(void)
 {
 	printk(VERSION);
 	arcnet_cap_init();
 	return 0;
 }
 
-void cleanup_module(void)
+static void __exit capmode_module_exit(void)
 {
 	arcnet_unregister_proto(&capmode_proto);
 }
+module_init(capmode_module_init);
+module_exit(capmode_module_exit);
 
 MODULE_LICENSE("GPL");
 #endif				/* MODULE */
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

