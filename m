From: akpm@linux-foundation.org
Subject: - ehci-ps3-ohci-ps3-fix-compilation.patch removed from -mm tree
Date: Mon, 07 May 2007 17:07:58 -0700
Message-ID: <200705080007.l4807wAs009336@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967423AbXEHAIb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:08:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geoffrey.levand@am.sony.com, adobriyan@gmail.com, geert@linux-m68k.org, greg@kroah.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     ehci-ps3, ohci-ps3: fix compilation
has been removed from the -mm tree.  Its filename was
     ehci-ps3-ohci-ps3-fix-compilation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ehci-ps3, ohci-ps3: fix compilation
From: Geoff Levand <geoffrey.levand@am.sony.com>

As seen on powerpc-cell et al:

  CC [M]  drivers/usb/host/ehci-hcd.o
In file included from drivers/usb/host/ehci-hcd.c:941:
drivers/usb/host/ehci-ps3.c:79: error: conflicting types for 'dev_dbg'
include/linux/device.h:576: error: previous definition of 'dev_dbg' was here
make[4]: *** [drivers/usb/host/ehci-hcd.o] Error 1
  CC [M]  drivers/usb/host/ohci-hcd.o
In file included from drivers/usb/host/ohci-hcd.c:921:
drivers/usb/host/ohci-ps3.c:83: error: conflicting types for 'dev_dbg'
include/linux/device.h:576: error: previous definition of 'dev_dbg' was here

dev_dbg() will check format string for you in dummy case also, so remove
buggers.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg KH <greg@kroah.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Geoff Levand <geoffrey.levand@am.sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/ehci-ps3.c |    7 -------
 drivers/usb/host/ohci-ps3.c |    8 --------
 2 files changed, 15 deletions(-)

diff -puN drivers/usb/host/ehci-ps3.c~ehci-ps3-ohci-ps3-fix-compilation drivers/usb/host/ehci-ps3.c
--- a/drivers/usb/host/ehci-ps3.c~ehci-ps3-ohci-ps3-fix-compilation
+++ a/drivers/usb/host/ehci-ps3.c
@@ -73,13 +73,6 @@ static const struct hc_driver ps3_ehci_h
 #endif
 };
 
-#if !defined(DEBUG)
-#undef dev_dbg
-static inline int __attribute__ ((format (printf, 2, 3))) dev_dbg(
-	const struct device *_dev, const char *fmt, ...) {return 0;}
-#endif
-
-
 static int ps3_ehci_sb_probe(struct ps3_system_bus_device *dev)
 {
 	int result;
diff -puN drivers/usb/host/ohci-ps3.c~ehci-ps3-ohci-ps3-fix-compilation drivers/usb/host/ohci-ps3.c
--- a/drivers/usb/host/ohci-ps3.c~ehci-ps3-ohci-ps3-fix-compilation
+++ a/drivers/usb/host/ohci-ps3.c
@@ -75,14 +75,6 @@ static const struct hc_driver ps3_ohci_h
 #endif
 };
 
-/* redefine dev_dbg to do a syntax check */
-
-#if !defined(DEBUG)
-#undef dev_dbg
-static inline int __attribute__ ((format (printf, 2, 3))) dev_dbg(
-	const struct device *_dev, const char *fmt, ...) {return 0;}
-#endif
-
 static int ps3_ohci_sb_probe(struct ps3_system_bus_device *dev)
 {
 	int result;
_

Patches currently in -mm which might be from geoffrey.levand@am.sony.com are

origin.patch
git-powerpc.patch
powerpc-ps3-use-__maybe_unused.patch
fbdev-avoid-vertical-overflow-when-making-space-for-the-logo.patch
fbdev-fb_do_show_logo-updates.patch
