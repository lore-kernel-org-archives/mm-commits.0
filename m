From: akpm@linux-foundation.org
Subject: [to-be-updated] firmware-add-source-and-copyright-notice-for-cis-files-from-pcmcia-cs.patch removed from -mm tree
Date: Fri, 12 Mar 2010 13:01:32 -0800
Message-ID: <201003122101.o2CL1WKC007842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933167Ab0CLVCF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Mar 2010 16:02:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@decadent.org.uk, dahinds@users.sourceforge.net, ken_kawasaki@spring.nifty.jp, linux@dominikbrodowski.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     firmware: add source and copyright notice for CIS files from pcmcia-cs
has been removed from the -mm tree.  Its filename was
     firmware-add-source-and-copyright-notice-for-cis-files-from-pcmcia-cs.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: firmware: add source and copyright notice for CIS files from pcmcia-cs
From: Ben Hutchings <ben@decadent.org.uk>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Ken Kawasaki <ken_kawasaki@spring.nifty.jp>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: David Hinds <dahinds@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 firmware/WHENCE                |   25 ++++++++++++++---
 firmware/cis/src/3CCFEM556.cis |   22 +++++++++++++++
 firmware/cis/src/3CXEM556.cis  |   22 +++++++++++++++
 firmware/cis/src/COMpad2.cis   |   20 ++++++++++++++
 firmware/cis/src/COMpad4.cis   |   14 +++++++++
 firmware/cis/src/DP83903.cis   |   24 ++++++++++++++++
 firmware/cis/src/LA-PCM.cis    |   44 +++++++++++++++++++++++++++++++
 firmware/cis/src/MT5634ZLX.cis |   18 ++++++++++++
 firmware/cis/src/NE2K.cis      |   10 +++++++
 firmware/cis/src/PCMLM28.cis   |   37 ++++++++++++++++++++++++++
 firmware/cis/src/PE-200.cis    |   11 +++++++
 firmware/cis/src/PE520.cis     |   11 +++++++
 firmware/cis/src/RS-COM-2P.cis |   14 +++++++++
 firmware/cis/src/tamarack.cis  |   17 +++++++++++
 14 files changed, 285 insertions(+), 4 deletions(-)

diff -puN firmware/WHENCE~firmware-add-source-and-copyright-notice-for-cis-files-from-pcmcia-cs firmware/WHENCE
--- a/firmware/WHENCE~firmware-add-source-and-copyright-notice-for-cis-files-from-pcmcia-cs
+++ a/firmware/WHENCE
@@ -602,30 +602,42 @@ File: cis/LA-PCM.cis
       cis/tamarack.cis
       cis/PE-200.cis
       cis/PE520.cis
+Source: cis/src/LA-PCM.cis
+Source: cis/src/PCMLM28.cis
+Source: cis/src/DP83903.cis
+Source: cis/src/NE2K.cis
+Source: cis/src/tamarack.cis
+Source: cis/src/PE-200.cis
+Source: cis/src/PE520.cis
 
-Licence: GPL
+Licence: Dual GPLv2/MPL
 
 Originally developed by the pcmcia-cs project
+Copyright (C) 1998, 1999, 2000 David A. Hinds
 
 --------------------------------------------------------------------------
 
 Driver: PCMCIA_3C589 - 3Com PCMCIA adapter
 
 File: cis/3CXEM556.cis
+Source: cis/src/3CXEM556.cis
 
-Licence: GPL
+Licence: Dual GPLv2/MPL
 
 Originally developed by the pcmcia-cs project
+Copyright (C) 1998, 1999, 2000 David A. Hinds
 
 --------------------------------------------------------------------------
 
 Driver: PCMCIA_3C574 - 3Com PCMCIA adapter
 
 File: cis/3CCFEM556.cis
+Source: cis/src/3CCFEM556.cis
 
-Licence: GPL
+Licence: Dual GPLv2/MPL
 
 Originally developed by the pcmcia-cs project
+Copyright (C) 1998, 1999, 2000 David A. Hinds
 
 --------------------------------------------------------------------------
 
@@ -635,10 +647,15 @@ File: cis/MT5634ZLX.cis
       cis/RS-COM-2P.cis
       cis/COMpad2.cis
       cis/COMpad4.cis
+Source: cis/src/MT5634ZLX.cis
+Source: cis/src/RS-COM-2P.cis
+Source: cis/src/COMpad2.cis
+Source: cis/src/COMpad4.cis
 
-Licence: GPL
+Licence: Dual GPLv2/MPL
 
 Originally developed by the pcmcia-cs project
+Copyright (C) 1998, 1999, 2000 David A. Hinds
 
 --------------------------------------------------------------------------
 
diff -puN /dev/null firmware/cis/src/3CCFEM556.cis
--- /dev/null
+++ a/firmware/cis/src/3CCFEM556.cis
@@ -0,0 +1,22 @@
+#
+# This card is MFC-compliant, but identifies itself as single function
+#
+vers_1 5.0, "3Com", "Megahertz 3CCFEM556", "LAN + 56k Modem"
+manfid 0x0101, 0x0556
+funcid 0
+
+mfc {
+  funcid network_adapter
+  config base 0x1000 mask 0x267 last_index 0x07
+  cftable_entry 0x07
+    Vcc Vnom 5V
+    irq mask 0xffff [level]
+    io  0x0000-0x000f [8bit] [16bit]
+}, {
+  funcid serial_port
+  config base 0x1100 mask 0x277 last_index 0x27
+  cftable_entry 0x27
+    Vcc Vnom 5V
+    irq mask 0xffff [level]
+    io  0x0000-0x0007 [8bit]
+}
diff -puN /dev/null firmware/cis/src/3CXEM556.cis
--- /dev/null
+++ a/firmware/cis/src/3CXEM556.cis
@@ -0,0 +1,22 @@
+#
+# This card is MFC-compliant, but identifies itself as single function
+#
+vers_1 5.0, "3Com", "Megahertz 3CXEM556", "LAN + 56k Modem"
+manfid 0x0101, 0x0035
+funcid 0
+
+mfc {
+  funcid network_adapter
+  config base 0x0800 mask 0x63 last_index 0x07
+  cftable_entry 0x07
+    Vcc Vnom 5V
+    irq mask 0xffff [level]
+    io  0x0000-0x000f [8bit] [16bit]
+}, {
+  funcid serial_port
+  config base 0x900 mask 0x63 last_index 0x27
+  cftable_entry 0x27
+    Vcc Vnom 5V
+    irq mask 0xffff [level]
+    io  0x0000-0x0007 [8bit]
+}
diff -puN /dev/null firmware/cis/src/COMpad2.cis
--- /dev/null
+++ a/firmware/cis/src/COMpad2.cis
@@ -0,0 +1,20 @@
+#
+# Replacement CIS for Advantech COMpad-32/85
+#
+dev_info
+  NULL 0ns, 512b
+vers_1 4.1, "ADVANTECH", "COMpad-32/85", "1.0"
+funcid serial_port [post]
+config base 0x0100 mask 0x0003 last_index 0x05
+cftable_entry 0x01 [default]
+  [mwait]
+  io 0x02e8-0x02ef, 0x03e8-0x03ef [lines=10] [8bit] [range]
+  irq mask 0x9eb8 [level]
+cftable_entry 0x02
+  io 0x0330-0x033f [lines=10] [8bit] [range]
+cftable_entry 0x03
+  io 0x0340-0x034f [lines=10] [8bit] [range]
+cftable_entry 0x04
+  io 0x0350-0x035f [lines=10] [8bit] [range]
+cftable_entry 0x05
+  io 0x0360-0x036f [lines=10] [8bit] [range]
diff -puN /dev/null firmware/cis/src/COMpad4.cis
--- /dev/null
+++ a/firmware/cis/src/COMpad4.cis
@@ -0,0 +1,14 @@
+#
+# Replacement CIS for Advantech COMpad-32/85B-4
+#
+dev_info
+  NULL 0ns, 512b
+vers_1 4.1, "ADVANTECH", "COMpad-32/85B-4"
+funcid serial_port [post]
+config base 0x0100 mask 0x0001 last_index 0x02
+cftable_entry 0x01 [default]
+  [mwait]
+  io 0x0240-0x025f [lines=10] [8bit] [range]
+  irq mask 0x9eb8 [level]
+cftable_entry 0x02
+  io 0x0340-0x035f [lines=10] [8bit] [range]
diff -puN /dev/null firmware/cis/src/DP83903.cis
--- /dev/null
+++ a/firmware/cis/src/DP83903.cis
@@ -0,0 +1,24 @@
+#
+# This CIS is for cards based on the National Semiconductor
+# DP83903 Multiple Function Interface Chip
+#
+vers_1 4.1, "Multifunction Card", "", "", "NSC MF LAN/Modem"
+manfid 0x0175, 0x0000
+funcid 0
+
+mfc {
+  funcid network_adapter
+  config base 0x1020 mask 0x277 last_index 0x17
+  cftable_entry 0x17
+    Vcc Vnom 5V
+    irq mask 0xffff [level]
+    io  0x0000-0x001f [8bit] [16bit]
+    memory 0x0000-0x3fff @ 0x0000
+}, {
+  funcid serial_port
+  config base 0x1040 mask 0x0277 last_index 0x07
+  cftable_entry 0x07
+    Vcc Vnom 5V
+    irq mask 0xffff [level]
+    io  0x0000-0x0007 [8bit]
+}
diff -puN /dev/null firmware/cis/src/LA-PCM.cis
--- /dev/null
+++ a/firmware/cis/src/LA-PCM.cis
@@ -0,0 +1,44 @@
+#
+# Replacement CIS for Allied Telesis LA-PCM
+#
+dev_info
+  fn_specific 100ns, 64kb
+  FLASH 150ns, 60kb
+attr_dev_info
+  FLASH 150ns, 4kb
+manfid 0xc00f, 0x0002
+funcid network_adapter [post] [rom]
+vers_1 4.1, "Allied Telesis,K.K", "Ethernet LAN Card", "CentreCOM", "LA-PCM"
+config base 0x20000 mask 0x000b last_index 0x10
+cftable_entry 0x01
+  io 0x0200-0x021f [8bit] [16bit]
+cftable_entry 0x02
+  io 0x0220-0x023f [8bit] [16bit]
+cftable_entry 0x03
+  io 0x0240-0x025f [8bit] [16bit]
+cftable_entry 0x04
+  io 0x0260-0x027f [8bit] [16bit]
+cftable_entry 0x05
+  io 0x0280-0x029f [8bit] [16bit]
+cftable_entry 0x06
+  io 0x02a0-0x02bf [8bit] [16bit]
+cftable_entry 0x07
+  io 0x02c0-0x02df [8bit] [16bit]
+cftable_entry 0x08
+  io 0x02e0-0x02ff [8bit] [16bit]
+cftable_entry 0x09
+  io 0x0300-0x031f [8bit] [16bit]
+cftable_entry 0x0a
+  io 0x0320-0x033f [8bit] [16bit]
+cftable_entry 0x0b
+  io 0x0340-0x035f [8bit] [16bit]
+cftable_entry 0x0c
+  io 0x0360-0x037f [8bit] [16bit]
+cftable_entry 0x0d
+  io 0x0380-0x039f [8bit] [16bit]
+cftable_entry 0x0e
+  io 0x03a0-0x03bf [8bit] [16bit]
+cftable_entry 0x0f
+  io 0x03c0-0x03df [8bit] [16bit]
+cftable_entry 0x10
+  io 0x03e0-0x03ff [8bit] [16bit]
diff -puN /dev/null firmware/cis/src/MT5634ZLX.cis
--- /dev/null
+++ a/firmware/cis/src/MT5634ZLX.cis
@@ -0,0 +1,18 @@
+#
+# Replacement CIS for Multitech MT5634ZLX modems
+#
+dev_info no_info
+vers_1 4.1, "MultiTech", "PCMCIA 56K DataFax"
+manfid 0x0200, 0x0001
+funcid serial_port
+config base 0xff80 mask 0x0067 last_index 0x27
+cftable_entry 0x0f [default]
+  [rdybsy] [audio] [pwrdown]
+  Vcc Vnom 5V Vpp1 Vnom 5V Vpp2 Vnom 5V
+  io 0x03f8-0x03ff [lines=10] [8bit]
+cftable_entry 0x17
+  io 0x02f8-0x02ff [lines=10] [8bit]
+cftable_entry 0x1f
+  io 0x03e8-0x03ef [lines=10] [8bit]
+cftable_entry 0x27
+  io 0x02e8-0x02ef [lines=10] [8bit]
diff -puN /dev/null firmware/cis/src/NE2K.cis
--- /dev/null
+++ a/firmware/cis/src/NE2K.cis
@@ -0,0 +1,10 @@
+#
+# Replacement CIS for various busted NE2000-compatible cards
+#
+vers_1 4.1, "PCMCIA", "Ethernet"
+funcid network_adapter
+config base 0x03f8 mask 0x03 last_index 0x20
+cftable_entry 0x20 [default]
+  Vcc Vnom 5V
+  irq mask 0xffff [level]
+  io 0x0000-0x001f [8bit] [16bit]
diff -puN /dev/null firmware/cis/src/PCMLM28.cis
--- /dev/null
+++ a/firmware/cis/src/PCMLM28.cis
@@ -0,0 +1,37 @@
+#
+# The on-card CIS says it is MFC-compliant, but it is not
+#
+vers_1 4.1, "LINKSYS", "PCMLM28"
+manfid 0x0143, 0xc0ab
+funcid 0
+config base 0x03f8 mask 0x03 last_index 0x2f
+
+cftable_entry 0x24 [default]
+  Vcc Vnom 5V
+  irq mask 0xffff [level]
+  io 0x0300-0x031f, 0x02f8-0x02ff [8bit] [16bit]
+
+cftable_entry 0x25
+  io 0x0320-0x033f, 0x02f8-0x02ff [8bit] [16bit]
+cftable_entry 0x26
+  io 0x0340-0x035f, 0x02f8-0x02ff [8bit] [16bit]
+cftable_entry 0x27
+  io 0x0360-0x037f, 0x02f8-0x02ff [8bit] [16bit]
+
+cftable_entry 0x28
+  io 0x0300-0x031f, 0x03e8-0x03ef [8bit] [16bit]
+cftable_entry 0x29
+  io 0x0320-0x033f, 0x03e8-0x03ef [8bit] [16bit]
+cftable_entry 0x2a
+  io 0x0340-0x035f, 0x03e8-0x03ef [8bit] [16bit]
+cftable_entry 0x2b
+  io 0x0360-0x037f, 0x03e8-0x03ef [8bit] [16bit]
+
+cftable_entry 0x2c
+  io 0x0300-0x031f, 0x02e8-0x02ef [8bit] [16bit]
+cftable_entry 0x2d
+  io 0x0320-0x033f, 0x02e8-0x02ef [8bit] [16bit]
+cftable_entry 0x2e
+  io 0x0340-0x035f, 0x02e8-0x02ef [8bit] [16bit]
+cftable_entry 0x2f
+  io 0x0360-0x037f, 0x02e8-0x02ef [8bit] [16bit]
diff -puN /dev/null firmware/cis/src/PE-200.cis
--- /dev/null
+++ a/firmware/cis/src/PE-200.cis
@@ -0,0 +1,11 @@
+#
+# Replacement CIS for PE-200 ethernet card
+#
+vers_1 4.1, "PMX   ", "PE-200", "ETHERNET", "R01"
+funcid network_adapter [post] [rom]
+config base 0x0100 mask 0x0001 last_index 0x01
+cftable_entry 0x1 [default]
+  [mwait]
+  Vcc Vnom 5V
+  irq mask 0xffff [level]
+  io 0x0000-0x000f, 0x0010-0x001f [8bit] [16bit]
diff -puN /dev/null firmware/cis/src/PE520.cis
--- /dev/null
+++ a/firmware/cis/src/PE520.cis
@@ -0,0 +1,11 @@
+#
+# Replacement CIS for LanPro EP-4000A ethernet card
+#
+vers_1 4.1, "KTI", "PE520 PLUS", "PCMCIA Ethernet"
+manfid 0x0161, 0x0010
+funcid network_adapter
+config base 0x0fd0 mask 0x0b last_index 0x01
+cftable_entry 0x01 [default]
+  Vcc Vnom 5V
+  irq mask 0xffff [level]
+  io 0x0000-0x001f [8bit] [16bit]
diff -puN /dev/null firmware/cis/src/RS-COM-2P.cis
--- /dev/null
+++ a/firmware/cis/src/RS-COM-2P.cis
@@ -0,0 +1,14 @@
+#
+# Replacement CIS for dual-serial-port IO card
+#
+vers_1 4.1, "PCMCIA", "RS-COM 2P"
+funcid serial_port [post]
+config base 0x0100 mask 0x0001 last_index 0x03
+cftable_entry 0x01 [default]
+  [mwait]
+  io 0x03e8-0x03ef, 0x02e8-0x02ef [lines=10] [8bit] [range]
+  irq mask 0x9eb8 [level]
+cftable_entry 0x02
+  io 0x0250-0x0257, 0x0258-0x025f [lines=10] [8bit] [range]
+cftable_entry 0x03
+  io 0x0260-0x0267, 0x0268-0x026f [lines=10] [8bit] [range]
diff -puN /dev/null firmware/cis/src/tamarack.cis
--- /dev/null
+++ a/firmware/cis/src/tamarack.cis
@@ -0,0 +1,17 @@
+#
+# Replacement CIS for Surecom, Tamarack NE2000 cards
+#
+dev_info
+  fn_specific 100ns, 512b
+attr_dev_info
+  EEPROM 250ns, 512b
+vers_1 4.1, "TAMARACK", "Ethernet", "A", "004743118001"
+funcid network_adapter
+config base 0x03f8 mask 0x0003 last_index 0x20
+cftable_entry 0x20 [default]
+  [mwait]
+  Vcc Vnom 5V Vmin 4500mV Vmax 5500mV Istatic 100mA
+    Iavg 170mA Ipeak 200mA
+  timing wait 15us
+  io 0x0000-0x000f, 0x0010-0x001f [lines=5] [8bit] [16bit]
+  irq mask 0xffff [level]
_

Patches currently in -mm which might be from ben@decadent.org.uk are

video-fix-first-line-of-kernel-doc-for-a-few-functions.patch
linux-next.patch
firmware-add-source-and-copyright-notice-for-cis-files-from-pcmcia-cs.patch
mptscsih-fix-first-line-of-kernel-doc-for-a-few-functions.patch

