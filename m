From: akpm@linux-foundation.org
Subject: + remove-config_vt_unicode.patch added to -mm tree
Date: Wed, 17 Oct 2007 14:20:17 -0700
Message-ID: <200710172120.l9HLKHL1008867@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36215 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756654AbXJQVUd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 17:20:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@computergmbh.de, notting@redhat.com


The patch titled
     Remove CONFIG_VT_UNICODE
has been added to the -mm tree.  Its filename is
     remove-config_vt_unicode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove CONFIG_VT_UNICODE
From: Jan Engelhardt <jengelh@computergmbh.de>

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Bill Nottingham <notting@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig |   17 -----------------
 drivers/char/vt.c    |    6 +-----
 2 files changed, 1 insertion(+), 22 deletions(-)

diff -puN drivers/char/Kconfig~remove-config_vt_unicode drivers/char/Kconfig
--- a/drivers/char/Kconfig~remove-config_vt_unicode
+++ a/drivers/char/Kconfig
@@ -36,23 +36,6 @@ config VT
 	  If unsure, say Y, or else you won't be able to do much with your new
 	  shiny Linux system :-)
 
-config VT_UNICODE
-	bool "Virtual console is Unicode by default"
-	depends on VT
-	default n
-	---help---
-	  If you say Y here, the virtual terminal will be in UTF-8 by default,
-	  and the keyboard will run in unicode mode.
-
-	  If you say N here, the virtual terminal will not be in UTF-8 by
-	  default, and the keyboard will run in XLATE mode.
-
-	  This can also be changed by passing 'default_utf8=<0|1>' on the
-	  kernel command line.
-
-	  Historically, the kernel has defaulted to non-UTF8 and XLATE mode.
-	  If unsure, say N here.
-
 config VT_CONSOLE
 	bool "Support for console on virtual terminal" if EMBEDDED
 	depends on VT
diff -puN drivers/char/vt.c~remove-config_vt_unicode drivers/char/vt.c
--- a/drivers/char/vt.c~remove-config_vt_unicode
+++ a/drivers/char/vt.c
@@ -158,11 +158,7 @@ static void blank_screen_t(unsigned long
 static void set_palette(struct vc_data *vc);
 
 static int printable;		/* Is console ready for printing? */
-#ifdef CONFIG_VT_UNICODE
-int default_utf8 = 1;
-#else
-int default_utf8;
-#endif
+int default_utf8 = true;
 module_param(default_utf8, int, S_IRUGO | S_IWUSR);
 
 /*
_

Patches currently in -mm which might be from jengelh@computergmbh.de are

origin.patch
menuconfig-transform-nls-and-dlm-menus.patch
menuconfig-transform-network-filesystems-menu.patch
dont-truncate-proc-pid-environ-at-4096-characters.patch
remove-config_vt_unicode.patch
intel-iommu-iommu-gfx-workaround-kconfig-fix.patch
intel-iommu-iommu-floppy-workaround-kconfig-fix.patch
