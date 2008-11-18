From: akpm@linux-foundation.org
Subject: + mtd-physmap-make-physmap-compat-explicit.patch added to -mm tree
Date: Tue, 18 Nov 2008 14:56:38 -0800
Message-ID: <200811182256.mAIMuchs007950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750945AbYKRW5T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Nov 2008 17:57:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, Bryan.Wu@analog.com, dwmw2@infradead.org


The patch titled
     mtd/physmap: make physmap compat explicit
has been added to the -mm tree.  Its filename is
     mtd-physmap-make-physmap-compat-explicit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd/physmap: make physmap compat explicit
From: Mike Frysinger <vapier@gentoo.org>

The current method for always showing physmap compat address, size, and
width is a bit confusing.  If length is set to 0, then the address and
width are still shown but silently unused.  The physmap code itself
already has logic which sets compat based on length, so just pull that out
and into the Kconfig to make everything clear.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Bryan Wu <Bryan.Wu@analog.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/Kconfig   |   17 ++++++++++++++---
 drivers/mtd/maps/physmap.c |   16 ++++------------
 2 files changed, 18 insertions(+), 15 deletions(-)

diff -puN drivers/mtd/maps/Kconfig~mtd-physmap-make-physmap-compat-explicit drivers/mtd/maps/Kconfig
--- a/drivers/mtd/maps/Kconfig~mtd-physmap-make-physmap-compat-explicit
+++ a/drivers/mtd/maps/Kconfig
@@ -23,9 +23,20 @@ config MTD_PHYSMAP
 	  To compile this driver as a module, choose M here: the
 	  module will be called physmap.
 
+config MTD_PHYSMAP_COMPAT
+	bool "Physmap compat support"
+	depends on MTD_PHYSMAP
+	default n
+	help
+	  Setup a simple mapping via the Kconfig options.  Normally the
+	  physmap configuration options are done via your board's
+	  resource file.
+
+	  If unsure, say N here.
+
 config MTD_PHYSMAP_START
 	hex "Physical start address of flash mapping"
-	depends on MTD_PHYSMAP
+	depends on MTD_PHYSMAP_COMPAT
 	default "0x8000000"
 	help
 	  This is the physical memory location at which the flash chips
@@ -37,7 +48,7 @@ config MTD_PHYSMAP_START
 
 config MTD_PHYSMAP_LEN
 	hex "Physical length of flash mapping"
-	depends on MTD_PHYSMAP
+	depends on MTD_PHYSMAP_COMPAT
 	default "0"
 	help
 	  This is the total length of the mapping of the flash chips on
@@ -51,7 +62,7 @@ config MTD_PHYSMAP_LEN
 
 config MTD_PHYSMAP_BANKWIDTH
 	int "Bank width in octets"
-	depends on MTD_PHYSMAP
+	depends on MTD_PHYSMAP_COMPAT
 	default "2"
 	help
 	  This is the total width of the data bus of the flash devices
diff -puN drivers/mtd/maps/physmap.c~mtd-physmap-make-physmap-compat-explicit drivers/mtd/maps/physmap.c
--- a/drivers/mtd/maps/physmap.c~mtd-physmap-make-physmap-compat-explicit
+++ a/drivers/mtd/maps/physmap.c
@@ -261,14 +261,7 @@ static struct platform_driver physmap_fl
 };
 
 
-#ifdef CONFIG_MTD_PHYSMAP_LEN
-#if CONFIG_MTD_PHYSMAP_LEN != 0
-#warning using PHYSMAP compat code
-#define PHYSMAP_COMPAT
-#endif
-#endif
-
-#ifdef PHYSMAP_COMPAT
+#ifdef CONFIG_MTD_PHYSMAP_COMPAT
 static struct physmap_flash_data physmap_flash_data = {
 	.width		= CONFIG_MTD_PHYSMAP_BANKWIDTH,
 };
@@ -312,7 +305,7 @@ static int __init physmap_init(void)
 	int err;
 
 	err = platform_driver_register(&physmap_flash_driver);
-#ifdef PHYSMAP_COMPAT
+#ifdef CONFIG_MTD_PHYSMAP_COMPAT
 	if (err == 0)
 		platform_device_register(&physmap_flash);
 #endif
@@ -322,7 +315,7 @@ static int __init physmap_init(void)
 
 static void __exit physmap_exit(void)
 {
-#ifdef PHYSMAP_COMPAT
+#ifdef CONFIG_MTD_PHYSMAP_COMPAT
 	platform_device_unregister(&physmap_flash);
 #endif
 	platform_driver_unregister(&physmap_flash_driver);
@@ -336,8 +329,7 @@ MODULE_AUTHOR("David Woodhouse <dwmw2@in
 MODULE_DESCRIPTION("Generic configurable MTD map driver");
 
 /* legacy platform drivers can't hotplug or coldplg */
-#ifndef PHYSMAP_COMPAT
+#ifndef CONFIG_MTD_PHYSMAP_COMPAT
 /* work with hotplug and coldplug */
 MODULE_ALIAS("platform:physmap-flash");
 #endif
