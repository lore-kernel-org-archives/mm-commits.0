From: akpm@linux-foundation.org
Subject: + drivers-net-apnec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch added to -mm tree
Date: Fri, 29 Feb 2008 15:25:20 -0800
Message-ID: <200802292325.m1TNPKLB026116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757507AbYB2XZa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 18:25:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkschind@gmail.com, jeff@garzik.org


The patch titled
     drivers/net/apne.c: replace init_module&cleanup_module with module_init&module_exit
has been added to the -mm tree.  Its filename is
     drivers-net-apnec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

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
