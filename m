From: akpm@linux-foundation.org
Subject: + memstick-drop-driver_version-numbers-as-meaningless.patch added to -mm tree
Date: Wed, 05 Mar 2008 15:17:44 -0800
Message-ID: <200803052317.m25NHiN8026676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934050AbYCEXSG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 18:18:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oakad@yahoo.com


The patch titled
     memstick: drop DRIVER_VERSION numbers as meaningless
has been added to the -mm tree.  Its filename is
     memstick-drop-driver_version-numbers-as-meaningless.patch

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
Subject: memstick: drop DRIVER_VERSION numbers as meaningless
From: Alex Dubov <oakad@yahoo.com>

Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/memstick.c    |    2 --
 drivers/memstick/core/mspro_block.c |    2 --
 drivers/memstick/host/tifm_ms.c     |    2 --
 3 files changed, 6 deletions(-)

diff -puN drivers/memstick/core/memstick.c~memstick-drop-driver_version-numbers-as-meaningless drivers/memstick/core/memstick.c
--- a/drivers/memstick/core/memstick.c~memstick-drop-driver_version-numbers-as-meaningless
+++ a/drivers/memstick/core/memstick.c
@@ -18,7 +18,6 @@
 #include <linux/delay.h>
 
 #define DRIVER_NAME "memstick"
-#define DRIVER_VERSION "0.2"
 
 static unsigned int cmd_retries = 3;
 module_param(cmd_retries, uint, 0644);
@@ -636,4 +635,3 @@ module_exit(memstick_exit);
 MODULE_AUTHOR("Alex Dubov");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Sony MemoryStick core driver");
-MODULE_VERSION(DRIVER_VERSION);
diff -puN drivers/memstick/core/mspro_block.c~memstick-drop-driver_version-numbers-as-meaningless drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~memstick-drop-driver_version-numbers-as-meaningless
+++ a/drivers/memstick/core/mspro_block.c
@@ -19,7 +19,6 @@
 #include <linux/memstick.h>
 
 #define DRIVER_NAME "mspro_block"
-#define DRIVER_VERSION "0.2"
 
 static int major;
 module_param(major, int, 0644);
@@ -1348,4 +1347,3 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Alex Dubov");
 MODULE_DESCRIPTION("Sony MemoryStickPro block device driver");
 MODULE_DEVICE_TABLE(memstick, mspro_block_id_tbl);
-MODULE_VERSION(DRIVER_VERSION);
diff -puN drivers/memstick/host/tifm_ms.c~memstick-drop-driver_version-numbers-as-meaningless drivers/memstick/host/tifm_ms.c
--- a/drivers/memstick/host/tifm_ms.c~memstick-drop-driver_version-numbers-as-meaningless
+++ a/drivers/memstick/host/tifm_ms.c
@@ -20,7 +20,6 @@
 #include <asm/io.h>
 
 #define DRIVER_NAME "tifm_ms"
-#define DRIVER_VERSION "0.1"
 
 static int no_dma;
 module_param(no_dma, bool, 0644);
@@ -678,7 +677,6 @@ MODULE_AUTHOR("Alex Dubov");
 MODULE_DESCRIPTION("TI FlashMedia MemoryStick driver");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(tifm, tifm_ms_id_tbl);
-MODULE_VERSION(DRIVER_VERSION);
 
 module_init(tifm_ms_init);
 module_exit(tifm_ms_exit);
_

Patches currently in -mm which might be from oakad@yahoo.com are

memstick-introduce-correct-definitions-in-the-header.patch
memstick-add-memstick_suspend-resume_host-methods.patch
memstick-make-sure-number-of-command-retries-is-exactly-as-specified.patch
memstick-drop-driver_version-numbers-as-meaningless.patch
tifm-fix-the-memorystick-host-fifo-handling-code.patch
tifm-fix-memorystick-host-initialization-code.patch
tifm-clear-interrupt-mask-bits-before-setting-them-on-adapter-init.patch
memstick-add-support-for-decoding-specfile-media-attributes.patch
memstick-fix-parsing-of-assembly_date-attribute-field.patch
memstick-try-harder-to-recover-from-unsuccessful-interface-mode-switch.patch
memstick-add-support-for-jmicron-jmb38x-memorystick-host-controller.patch

