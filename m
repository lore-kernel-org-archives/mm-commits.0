From: akpm@linux-foundation.org
Subject: + ehci-ps3-ohci-ps3-fix-compilation.patch added to -mm tree
Date: Thu, 03 May 2007 18:07:29 -0700
Message-ID: <200705040107.l4417TrR026361@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767562AbXEDBHn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 21:07:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, geert@linux-m68k.org, geoffrey.levand@am.sony.com, greg@kroah.com, paulus@samba.org


The patch titled
     ehci-ps3, ohci-ps3: fix compilation
has been added to the -mm tree.  Its filename is
     ehci-ps3-ohci-ps3-fix-compilation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ehci-ps3, ohci-ps3: fix compilation
From: Alexey Dobriyan <adobriyan@gmail.com>

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
Cc: <geoffrey.levand@am.sony.com>
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

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
ehci-ps3-ohci-ps3-fix-compilation.patch
git-dvb.patch
pata_scc-fix-compilation.patch
git-parisc.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
git-watchdog.patch
reiserfs-shrink-superblock-if-no-xattrs.patch
i386-schedh-inclusion-from-moduleh-is-baack.patch
