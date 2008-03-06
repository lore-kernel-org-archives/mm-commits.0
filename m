From: akpm@linux-foundation.org
Subject: + drivers-char-ip2-ip2mainc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch added to -mm tree
Date: Wed, 05 Mar 2008 16:12:27 -0800
Message-ID: <200803060012.m260CRxO029018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752650AbYCFAND (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 19:13:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkschind@gmail.com


The patch titled
     drivers/char/ip2/ip2main.c: replace init_module&cleanup_module with module_init&module_exit
has been added to the -mm tree.  Its filename is
     drivers-char-ip2-ip2mainc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

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
Subject: drivers/char/ip2/ip2main.c: replace init_module&cleanup_module with module_init&module_exit
From: Jon Schindler <jkschind@gmail.com>

Replace init_module and cleanup_module with static functions and
module_init/module_exit.

Signed-off-by: Jon Schindler <jkschind@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip2/ip2main.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/char/ip2/ip2main.c~drivers-char-ip2-ip2mainc-replace-init_modulecleanup_module-with-module_initmodule_exit drivers/char/ip2/ip2main.c
--- a/drivers/char/ip2/ip2main.c~drivers-char-ip2-ip2mainc-replace-init_modulecleanup_module-with-module_initmodule_exit
+++ a/drivers/char/ip2/ip2main.c
@@ -354,14 +354,15 @@ have_requested_irq( char irq )
 /* the driver initialisation function and returns what it returns.            */
 /******************************************************************************/
 #ifdef MODULE
-int
-init_module(void)
+static int __init
+ip2_init_module(void)
 {
 #ifdef IP2DEBUG_INIT
 	printk (KERN_DEBUG "Loading module ...\n" );
 #endif
     return 0;
 }
+module_init(ip2_init_module);
 #endif /* MODULE */
 
 /******************************************************************************/
@@ -380,8 +381,8 @@ init_module(void)
 /* driver should be returned since it may be unloaded from memory.            */
 /******************************************************************************/
 #ifdef MODULE
-void
-cleanup_module(void)
+void __exit
+ip2_cleanup_module(void)
 {
 	int err;
 	int i;
@@ -451,6 +452,7 @@ cleanup_module(void)
 	printk (KERN_DEBUG "IP2 Unloaded\n" );
 #endif
 }
+module_exit(ip2_cleanup_module);
 #endif /* MODULE */
 
 static const struct tty_operations ip2_ops = {
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

