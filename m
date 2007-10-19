From: akpm@linux-foundation.org
Subject: - remove-config_vt_unicode.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:40:28 -0700
Message-ID: <200710190340.l9J3eSM0012712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42327 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966527AbXJSD4H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@computergmbh.de, notting@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Remove CONFIG_VT_UNICODE
has been removed from the -mm tree.  Its filename was
     remove-config_vt_unicode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove CONFIG_VT_UNICODE
From: Jan Engelhardt <jengelh@computergmbh.de>

Since default_utf8 is already a sysfs attribute, having an extra
CONFIG_VT_UNICODE compile-time option is redundant, since sysfs attributes can
be set at boot and run time.

Also let Linux VCs default to UTF-8 (as per the discussion at
http://lkml.org/lkml/2007/9/6/99).

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
intel-iommu-iommu-gfx-workaround-kconfig-fix.patch
intel-iommu-iommu-floppy-workaround-kconfig-fix.patch
