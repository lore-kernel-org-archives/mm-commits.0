From: akpm@linux-foundation.org
Subject: - drivers-ide-idec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch removed from -mm tree
Date: Wed, 26 Mar 2008 11:24:35 -0700
Message-ID: <200803261824.m2QIOZaJ027999@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761503AbYCZSYh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 14:24:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkschind@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/ide/ide.c: replace init_module&cleanup_module with module_init&module_exit
has been removed from the -mm tree.  Its filename was
     drivers-ide-idec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/ide/ide.c: replace init_module&cleanup_module with module_init&module_exit
From: Jon Schindler <jkschind@gmail.com>

Replace init_module and cleanup_module with static functions and
module_init/module_exit.

Signed-off-by: Jon Schindler <jkschind@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/ide/ide.c~drivers-ide-idec-replace-init_modulecleanup_module-with-module_initmodule_exit drivers/ide/ide.c
--- a/drivers/ide/ide.c~drivers-ide-idec-replace-init_modulecleanup_module-with-module_initmodule_exit
+++ a/drivers/ide/ide.c
@@ -1194,7 +1194,7 @@ static char *options = NULL;
 module_param(options, charp, 0);
 MODULE_LICENSE("GPL");
 
-static void __init parse_options (char *line)
+static void __init parse_options(char *line)
 {
 	char *next = line;
 
@@ -1208,13 +1208,14 @@ static void __init parse_options (char *
 	}
 }
 
-int __init init_module (void)
+static int __init ide_module_init(void)
 {
 	parse_options(options);
 	return ide_init();
 }
+module_init(ide_module_init);
 
-void __exit cleanup_module (void)
+static void __exit ide_module_exit(void)
 {
 	int index;
 
@@ -1227,6 +1228,7 @@ void __exit cleanup_module (void)
 
 	bus_unregister(&ide_bus_type);
 }
+module_exit(ide_module_exit);
 
 #else /* !MODULE */
 
_

Patches currently in -mm which might be from jkschind@gmail.com are

drivers-ide-idec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
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

