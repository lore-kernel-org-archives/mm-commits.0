From: akpm@linux-foundation.org
Subject: - drivers-block-floppyc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:40:31 -0700
Message-ID: <200804300540.m3U5eVgK028971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60671 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754832AbYD3FlC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:41:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkschind@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: replace init_module&cleanup_module with module_init&module_exit
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: replace init_module&cleanup_module with module_init&module_exit
From: Jon Schindler <jkschind@gmail.com>

Replace init_module and cleanup_module with static functions and
module_init/module_exit.

Signed-off-by: Jon Schindler <jkschind@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-replace-init_modulecleanup_module-with-module_initmodule_exit drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-replace-init_modulecleanup_module-with-module_initmodule_exit
+++ a/drivers/block/floppy.c
@@ -4526,14 +4526,15 @@ static void __init parse_floppy_cfg_stri
 	}
 }
 
-int __init init_module(void)
+static int __init floppy_module_init(void)
 {
 	if (floppy)
 		parse_floppy_cfg_string(floppy);
 	return floppy_init();
 }
+module_init(floppy_module_init);
 
-void cleanup_module(void)
+static void __exit floppy_module_exit(void)
 {
 	int drive;
 
@@ -4562,6 +4563,7 @@ void cleanup_module(void)
 	/* eject disk, if any */
 	fd_eject(0);
 }
+module_exit(floppy_module_exit);
 
 module_param(floppy, charp, 0);
 module_param(FLOPPY_IRQ, int, 0);
_

Patches currently in -mm which might be from jkschind@gmail.com are

origin.patch
drivers-char-ip2-ip2mainc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

