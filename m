From: akpm@linux-foundation.org
Subject: + drivers-block-floppyc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch added to -mm tree
Date: Wed, 05 Mar 2008 16:12:25 -0800
Message-ID: <200803060012.m260CPvY029015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752424AbYCFAMz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 19:12:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkschind@gmail.com


The patch titled
     drivers/block/floppy.c: replace init_module&cleanup_module with module_init&module_exit
has been added to the -mm tree.  Its filename is
     drivers-block-floppyc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

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
@@ -4528,14 +4528,15 @@ static void __init parse_floppy_cfg_stri
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
 
@@ -4567,6 +4568,7 @@ void cleanup_module(void)
 
 	wait_for_completion(&device_release);
 }
+module_exit(floppy_module_exit);
 
 module_param(floppy, charp, 0);
 module_param(FLOPPY_IRQ, int, 0);
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

