From: akpm@linux-foundation.org
Subject: + init-raise-log-level.patch added to -mm tree
Date: Mon, 25 Mar 2013 14:18:10 -0700
Message-ID: <20130325211810.749DC31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:56011 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758619Ab3CYVSL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Mar 2013 17:18:11 -0400
Received: by mail-vc0-f201.google.com with SMTP id hf12so663618vcb.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2013 14:18:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at, hpa@zytor.com, jim.cromie@gmail.com, rusty@rustcorp.com.au


The patch titled
     Subject: init: raise log level
has been added to the -mm tree.  Its filename is
     init-raise-log-level.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Richard Weinberger <richard@nod.at>
Subject: init: raise log level

If the kernel was booted with the "quiet" boot option we have currently no
chance to see why an initrd fails.  Change KERN_WARNING to KERN_ERR to see
what is going on.

Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN init/main.c~init-raise-log-level init/main.c
--- a/init/main.c~init-raise-log-level
+++ a/init/main.c
@@ -825,7 +825,7 @@ static int __ref kernel_init(void *unuse
 	if (ramdisk_execute_command) {
 		if (!run_init_process(ramdisk_execute_command))
 			return 0;
-		printk(KERN_WARNING "Failed to execute %s\n",
+		printk(KERN_ERR "Failed to execute %s\n",
 				ramdisk_execute_command);
 	}
 
@@ -838,7 +838,7 @@ static int __ref kernel_init(void *unuse
 	if (execute_command) {
 		if (!run_init_process(execute_command))
 			return 0;
-		printk(KERN_WARNING "Failed to execute %s.  Attempting "
+		printk(KERN_ERR "Failed to execute %s.  Attempting "
 					"defaults...\n", execute_command);
 	}
 	if (!run_init_process("/sbin/init") ||
@@ -884,7 +884,7 @@ static noinline void __init kernel_init_
 
 	/* Open the /dev/console on the rootfs, this should never fail */
 	if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
-		printk(KERN_WARNING "Warning: unable to open an initial console.\n");
+		printk(KERN_ERR "Warning: unable to open an initial console.\n");
 
 	(void) sys_dup(0);
 	(void) sys_dup(0);
_

Patches currently in -mm which might be from richard@nod.at are

linux-next.patch
mm-introduce-free_highmem_page-helper-to-free-highmem-pages-into-buddy-system.patch
mm-um-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
early_printk-consolidate-random-copies-of-identical-code.patch
early_printk-consolidate-random-copies-of-identical-code-v3.patch
init-raise-log-level.patch
lib-add-lz4-compressor-module.patch
crypto-add-lz4-cryptographic-api.patch
crypto-add-lz4-cryptographic-api-fix.patch

