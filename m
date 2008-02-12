From: akpm@linux-foundation.org
Subject: + wireless-rt2x00-fix-driver-menu-indenting.patch added to -mm tree
Date: Tue, 12 Feb 2008 13:57:24 -0800
Message-ID: <200802122157.m1CLvOhV024288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40124 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755804AbYBLV5n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 16:57:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, IvDoorn@gmail.com, m.bueker@berlin.de


The patch titled
     wireless: rt2x00: fix driver menu indenting
has been added to the -mm tree.  Its filename is
     wireless-rt2x00-fix-driver-menu-indenting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: wireless: rt2x00: fix driver menu indenting
=46rom: Randy Dunlap <randy.dunlap@oracle.com>

Michael B=FCker reports that the RT2x00 drivers are not indented as the=
y
should be, so use proper dependencies to make them be indented as expec=
ted.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Michael B=FCker <m.bueker@berlin.de>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/rt2x00/Kconfig |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/net/wireless/rt2x00/Kconfig~wireless-rt2x00-fix-drive=
r-menu-indenting drivers/net/wireless/rt2x00/Kconfig
--- a/drivers/net/wireless/rt2x00/Kconfig~wireless-rt2x00-fix-driver-me=
nu-indenting
+++ a/drivers/net/wireless/rt2x00/Kconfig
@@ -11,18 +11,17 @@ config RT2X00
 	  will also be created. That library (when the driver is built as
 	  a module) will be called "rt2x00lib.ko".
=20
+if RT2X00
+
 config RT2X00_LIB
 	tristate
-	depends on RT2X00
=20
 config RT2X00_LIB_PCI
 	tristate
-	depends on RT2X00
 	select RT2X00_LIB
=20
 config RT2X00_LIB_USB
 	tristate
-	depends on RT2X00
 	select RT2X00_LIB
=20
 config RT2X00_LIB_FIRMWARE
@@ -39,7 +38,7 @@ config RT2X00_LIB_RFKILL
=20
 config RT2400PCI
 	tristate "Ralink rt2400 pci/pcmcia support"
-	depends on RT2X00 && PCI
+	depends on PCI
 	select RT2X00_LIB_PCI
 	select EEPROM_93CX6
 	---help---
@@ -58,7 +57,7 @@ config RT2400PCI_RFKILL
=20
 config RT2500PCI
 	tristate "Ralink rt2500 pci/pcmcia support"
-	depends on RT2X00 && PCI
+	depends on PCI
 	select RT2X00_LIB_PCI
 	select EEPROM_93CX6
 	---help---
@@ -77,7 +76,7 @@ config RT2500PCI_RFKILL
=20
 config RT61PCI
 	tristate "Ralink rt61 pci/pcmcia support"
-	depends on RT2X00 && PCI
+	depends on PCI
 	select RT2X00_LIB_PCI
 	select RT2X00_LIB_FIRMWARE
 	select EEPROM_93CX6
@@ -97,7 +96,7 @@ config RT61PCI_RFKILL
=20
 config RT2500USB
 	tristate "Ralink rt2500 usb support"
-	depends on RT2X00 && USB
+	depends on USB
 	select RT2X00_LIB_USB
 	---help---
 	  This is an experimental driver for the Ralink rt2500 wireless chip.
@@ -106,7 +105,7 @@ config RT2500USB
=20
 config RT73USB
 	tristate "Ralink rt73 usb support"
-	depends on RT2X00 && USB
+	depends on USB
 	select RT2X00_LIB_USB
 	select RT2X00_LIB_FIRMWARE
 	---help---
@@ -128,3 +127,4 @@ config RT2X00_DEBUG
 	---help---
 	  Enable debugging output for all rt2x00 modules
=20
+endif
_

Patches currently in -mm which might be from randy.dunlap@oracle.com ar=
e

origin.patch
kernel-doc-fix-fs-pipec-notation.patch
docbook-move-pipe-and-splice-to-filesystems-docbook.patch
docbook-sunrpc-filenames-and-notation-fixes.patch
docbook-make-a-networking-book-and-fix-a-few-errors.patch
apanel-fix-kconfig-dependencies.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
x86-visws-fix-printk-format-warnings.patch
profile-likely-unlikely-macros.patch
