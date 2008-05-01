From: akpm@linux-foundation.org
Subject: - drivers-char-ip2-ip2mainc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch removed from -mm tree
Date: Thu, 01 May 2008 02:29:46 -0700
Message-ID: <200805010929.m419TkNM030709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756268AbYEAJ3s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:29:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkschind@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/char/ip2/ip2main.c: replace init_module&cleanup_module with module_init&module_exit
has been removed from the -mm tree.  Its filename was
     drivers-char-ip2-ip2mainc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -355,14 +355,15 @@ have_requested_irq( char irq )
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
@@ -381,8 +382,8 @@ init_module(void)
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
@@ -452,6 +453,7 @@ cleanup_module(void)
 	printk (KERN_DEBUG "IP2 Unloaded\n" );
 #endif
 }
+module_exit(ip2_cleanup_module);
 #endif /* MODULE */
 
 static const struct tty_operations ip2_ops = {
_

Patches currently in -mm which might be from jkschind@gmail.com are

origin.patch

