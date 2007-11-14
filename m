From: akpm@linux-foundation.org
Subject: - remove-references-to-net-modulestxt.patch removed from -mm tree
Date: Wed, 14 Nov 2007 09:41:38 -0800
Message-ID: <200711141741.lAEHfc7I017254@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40379 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756435AbXKNRl5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Nov 2007 12:41:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     remove references to net-modules.txt
has been removed from the -mm tree.  Its filename was
     remove-references-to-net-modulestxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove references to net-modules.txt
From: Adrian Bunk <bunk@kernel.org>

When I removed net-modules.txt because it only contained ancient information I
missed that many Kconfig entries pointed to this ancient information.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/networking/3c505.txt |    3 
 drivers/net/Kconfig                |  199 +++++++++------------------
 drivers/net/arcnet/Kconfig         |   15 --
 drivers/net/tulip/Kconfig          |   21 --
 4 files changed, 82 insertions(+), 156 deletions(-)

diff -puN Documentation/networking/3c505.txt~remove-references-to-net-modulestxt Documentation/networking/3c505.txt
--- a/Documentation/networking/3c505.txt~remove-references-to-net-modulestxt
+++ a/Documentation/networking/3c505.txt
@@ -14,8 +14,7 @@ If no base address is given at boot time
 ports 0x300, 0x280 and 0x310 (in that order).  If no IRQ is given, the driver
 will try to probe for it.
 
-The driver can be used as a loadable module.  See net-modules.txt for details
-of the parameters it can take.  
+The driver can be used as a loadable module.
 
 Theoretically, one instance of the driver can now run multiple cards,
 in the standard way (when loading a module, say "modprobe 3c505
diff -puN drivers/net/Kconfig~remove-references-to-net-modulestxt drivers/net/Kconfig
--- a/drivers/net/Kconfig~remove-references-to-net-modulestxt
+++ a/drivers/net/Kconfig
@@ -366,8 +366,7 @@ config MAC89x0
 	  read the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  This module will
+	  To compile this driver as a module, choose M here. This module will
 	  be called mac89x0.
 
 config MACSONIC
@@ -380,8 +379,7 @@ config MACSONIC
 	  one of these say Y and read the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  This module will
+	  To compile this driver as a module, choose M here. This module will
 	  be called macsonic.
 
 config MACMACE
@@ -619,8 +617,7 @@ config EL1
 	  have problems.  Some people suggest to ping ("man ping") a nearby
 	  machine every minute ("man cron") when using this card.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called 3c501.
 
 config EL2
@@ -632,8 +629,7 @@ config EL2
 	  the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called 3c503.
 
 config ELPLUS
@@ -645,8 +641,7 @@ config ELPLUS
 	  this type, say Y and read the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called 3c505.
 
 config EL16
@@ -657,8 +652,7 @@ config EL16
 	  the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called 3c507.
 
 config EL3
@@ -673,8 +667,7 @@ config EL3
 	  setup disk to disable Plug & Play mode, and to select the default
 	  media type.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called 3c509.
 
 config 3C515
@@ -685,8 +678,7 @@ config 3C515
 	  network card, say Y and read the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called 3c515.
 
 config ELMC
@@ -697,8 +689,7 @@ config ELMC
 	  the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called 3c523.
 
 config ELMC_II
@@ -709,8 +700,7 @@ config ELMC_II
 	  the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called 3c527.
 
 config VORTEX
@@ -733,8 +723,7 @@ config VORTEX
 	  <file:Documentation/networking/vortex.txt> and in the comments at
 	  the beginning of <file:drivers/net/3c59x.c>.
 
-	  To compile this support as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.
+	  To compile this support as a module, choose M here.
 
 config TYPHOON
 	tristate "3cr990 series \"Typhoon\" support"
@@ -751,8 +740,7 @@ config TYPHOON
 	  the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called typhoon.
 
 config LANCE
@@ -789,8 +777,7 @@ config WD80x3
 	  the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called wd.
 
 config ULTRAMCA
@@ -802,8 +789,7 @@ config ULTRAMCA
 	  an MCA based system (PS/2), say Y and read the Ethernet-HOWTO,
 	  available from <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called smc-mca.
 
 config ULTRA
@@ -822,8 +808,7 @@ config ULTRA
 	  this but keep it in mind if you have such a SCSI card and have
 	  problems.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called smc-ultra.
 
 config ULTRA32
@@ -835,8 +820,7 @@ config ULTRA32
 	  the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called smc-ultra32.
 
 config BFIN_MAC
@@ -897,8 +881,7 @@ config SMC9194
 	  <file:Documentation/networking/smc9.txt> and the Ethernet-HOWTO,
 	  available from <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called smc9194.
 
 config SMC91X
@@ -916,8 +899,7 @@ config SMC91X
 	  This driver is also available as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called smc91x.  If you want to compile it as a
-	  module, say M here and read <file:Documentation/kbuild/modules.txt>
-	  as well as <file:Documentation/networking/net-modules.txt>.
+	  module, say M here and read <file:Documentation/kbuild/modules.txt>.
 
 config NET_NETX
 	tristate "NetX Ethernet support"
@@ -926,8 +908,7 @@ config NET_NETX
 	help
 	  This is support for the Hilscher netX builtin Ethernet ports
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called netx-eth.
 
 config DM9000
@@ -938,9 +919,8 @@ config DM9000
 	---help---
 	  Support for DM9000 chipset.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module will be
-	  called dm9000.
+	  To compile this driver as a module, choose M here.  The module
+	  will be called dm9000.
 
 config SMC911X
 	tristate "SMSC LAN911[5678] support"
@@ -980,8 +960,7 @@ config NI5010
 	  <http://www.tldp.org/docs.html#howto>. Note that this is still
 	  experimental code.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called ni5010.
 
 config NI52
@@ -992,8 +971,7 @@ config NI52
 	  the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called ni52.
 
 config NI65
@@ -1004,8 +982,7 @@ config NI65
 	  the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called ni65.
 
 source "drivers/net/tulip/Kconfig"
@@ -1019,8 +996,7 @@ config AT1700
 	  the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called at1700.
 
 config DEPCA
@@ -1033,8 +1009,7 @@ config DEPCA
 	  <http://www.tldp.org/docs.html#howto> as well as
 	  <file:drivers/net/depca.c>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called depca.
 
 config HP100
@@ -1045,8 +1020,7 @@ config HP100
 	  the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called hp100.
 
 config NET_ISA
@@ -1075,8 +1049,7 @@ config E2100
 	  the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called e2100.
 
 config EWRK3
@@ -1090,8 +1063,7 @@ config EWRK3
 	  well as the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called ewrk3.
 
 config EEXPRESS
@@ -1105,8 +1077,7 @@ config EEXPRESS
 	  because the driver was very unreliable. We now have a new driver
 	  that should do better.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called eexpress.
 
 config EEXPRESS_PRO
@@ -1119,8 +1090,7 @@ config EEXPRESS_PRO
 	  driver.  Please read the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called eepro.
 
 config HPLAN_PLUS
@@ -1132,8 +1102,7 @@ config HPLAN_PLUS
 	  the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called hp-plus.
 
 config HPLAN
@@ -1145,8 +1114,7 @@ config HPLAN
 	  the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called hp.
 
 config LP486E
@@ -1165,8 +1133,7 @@ config ETH16I
 	  the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called eth16i.
 
 config NE2000
@@ -1186,8 +1153,7 @@ config NE2000
 	  laptops), say N here and Y to "NE/2 (ne2000 MCA version) support",
 	  below.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called ne.
 
 config ZNET
@@ -1208,8 +1174,7 @@ config SEEQ8005
 	  is for you, read the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called seeq8005.
 
 config NE2_MCA
@@ -1221,8 +1186,7 @@ config NE2_MCA
 	  the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called ne2.
 
 config IBMLANA
@@ -1233,8 +1197,7 @@ config IBMLANA
 	  CONFIG_MCA to use this driver.  It is both available as an in-kernel
 	  driver and as a module.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The only
+	  To compile this driver as a module, choose M here. The only
 	  currently supported card is the IBM LAN Adapter/A for Ethernet.  It
 	  will both support 16K and 32K memory windows, however a 32K window
 	  gives a better security against packet losses.  Usage of multiple
@@ -1248,8 +1211,7 @@ config IBMVETH
 	  This driver supports virtual ethernet adapters on newer IBM iSeries
 	  and pSeries systems.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module will
+	  To compile this driver as a module, choose M here. The module will
 	  be called ibmveth.
 
 source "drivers/net/ibm_emac/Kconfig"
@@ -1279,8 +1241,7 @@ config PCNET32
 	  answer Y here and read the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called pcnet32.
 
 config PCNET32_NAPI
@@ -1307,8 +1268,7 @@ config AMD8111_ETH
 	  answer Y here and read the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called amd8111e.
 
 config AMD8111E_NAPI
@@ -1362,8 +1322,7 @@ config AC3200
 	  the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called ac3200.
 
 config APRICOT
@@ -1374,9 +1333,8 @@ config APRICOT
 	  read the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module will be
-	  called apricot.
+	  To compile this driver as a module, choose M here. The module
+	  will be called apricot.
 
 config B44
 	tristate "Broadcom 440x/47xx ethernet support"
@@ -1388,9 +1346,8 @@ config B44
 	  or M and read the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module will be
-	  called b44.
+	  To compile this driver as a module, choose M here. The module
+	  will be called b44.
 
 # Auto-select SSB PCI-HOST support, if possible
 config B44_PCI_AUTOSELECT
@@ -1419,9 +1376,8 @@ config FORCEDETH
 	  read the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module will be
-	  called forcedeth.
+	  To compile this driver as a module, choose M here. The module
+	  will be called forcedeth.
 
 config FORCEDETH_NAPI
 	bool "Use Rx Polling (NAPI) (EXPERIMENTAL)"
@@ -1447,9 +1403,8 @@ config CS89x0
 	  <http://www.tldp.org/docs.html#howto> as well as
 	  <file:Documentation/networking/cs89x0.txt>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module will be
-	  called cs89x0.
+	  To compile this driver as a module, choose M here. The module
+	  will be called cs89x0.
 
 config TC35815
 	tristate "TOSHIBA TC35815 Ethernet support"
@@ -1465,8 +1420,7 @@ config EEPRO100
 	  card, say Y and read the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called eepro100.
 
 
@@ -1493,8 +1447,7 @@ config E100
 	  More specific information on configuring the driver is in 
 	  <file:Documentation/networking/e100.txt>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called e100.
 
 config LNE390
@@ -1506,8 +1459,7 @@ config LNE390
 	  the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called lne390.
 
 config FEALNX
@@ -1547,8 +1499,7 @@ config NE2K_PCI
 	  NetVin NV5000SC   Via 86C926      SureCom NE34   Winbond
 	  Holtek HT80232    Holtek HT80229
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called ne2k-pci.
 
 config NE3210
@@ -1561,8 +1512,7 @@ config NE3210
 	  <http://www.tldp.org/docs.html#howto>.  Note that this driver
 	  will NOT WORK for NE3200 cards as they are completely different.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called ne3210.
 
 config ES3210
@@ -1574,8 +1524,7 @@ config ES3210
 	  the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called es3210.
 
 config 8139CP
@@ -1705,8 +1654,7 @@ config TLAN
 	  Compaq NetFlex and Olicom cards.  Please read the file
 	  <file:Documentation/networking/tlan.txt> for more details.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called tlan.
 
 	  Please email feedback to <torben.mathiasen@compaq.com>.
@@ -1996,8 +1944,7 @@ config E1000
 	  More specific information on configuring the driver is in 
 	  <file:Documentation/networking/e1000.txt>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called e1000.
 
 config E1000_NAPI
@@ -2042,8 +1989,7 @@ config E1000E
 	  More specific information on configuring the driver is in
 	  <file:Documentation/networking/e1000e.txt>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called e1000e.
 
 source "drivers/net/ixp2000/Kconfig"
@@ -2076,8 +2022,7 @@ config HAMACHI
 	  the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module will be
+	  To compile this driver as a module, choose M here. The module will be
 	  called hamachi.
 
 config YELLOWFIN
@@ -2526,8 +2471,7 @@ config IXGBE
 	  More specific information on configuring the driver is in
 	  <file:Documentation/networking/ixgbe.txt>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called ixgbe.
 
 config IXGB
@@ -2549,8 +2493,7 @@ config IXGB
 	  More specific information on configuring the driver is in 
 	  <file:Documentation/networking/ixgb.txt>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called ixgb.
 
 config IXGB_NAPI
@@ -2603,8 +2546,7 @@ config MYRI10GE
 
 	  <http://www.myri.com/scs/download-Myri10GE.html>
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module
+	  To compile this driver as a module, choose M here. The module
 	  will be called myri10ge.
 
 config NETXEN_NIC
@@ -2828,10 +2770,9 @@ config PLIP
 	  with the PLIP support in Linux versions 1.0.x.  This option enlarges
 	  your kernel by about 8 KB.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module will be
-	  called plip.  If unsure, say Y or M, in case you buy a laptop
-	  later.
+	  To compile this driver as a module, choose M here. The module
+	  will be called plip. If unsure, say Y or M, in case you buy
+	  a laptop later.
 
 config PPP
 	tristate "PPP (point-to-point protocol) support"
@@ -2861,8 +2802,7 @@ config PPP
 	  If you said Y to "Version information on all symbols" above, then
 	  you cannot compile the PPP driver into the kernel; you can then only
 	  compile it as a module. To compile this driver as a module, choose M
-	  here and read <file:Documentation/networking/net-modules.txt>.
-	  The module will be called ppp_generic.
+	  here. The module will be called ppp_generic.
 
 config PPP_MULTILINK
 	bool "PPP multilink support (EXPERIMENTAL)"
@@ -3023,9 +2963,8 @@ config SLIP
 	  <http://www.bart.nl/~patrickr/term-howto/Term-HOWTO.html>). SLIP
 	  support will enlarge your kernel by about 4 KB. If unsure, say N.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module will be
-	  called slip.
+	  To compile this driver as a module, choose M here. The module
+	  will be called slip.
 
 config SLIP_COMPRESSED
 	bool "CSLIP compressed headers"
diff -puN drivers/net/arcnet/Kconfig~remove-references-to-net-modulestxt drivers/net/arcnet/Kconfig
--- a/drivers/net/arcnet/Kconfig~remove-references-to-net-modulestxt
+++ a/drivers/net/arcnet/Kconfig
@@ -19,8 +19,7 @@ menuconfig ARCNET
 	  from <http://www.tldp.org/docs.html#howto>(even though ARCnet
 	  is not really Ethernet).
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module will
+	  To compile this driver as a module, choose M here. The module will
 	  be called arcnet.
 
 if ARCNET
@@ -81,8 +80,7 @@ config ARCNET_COM90xx
 	  have always used the old ARCnet driver without knowing what type of
 	  card you had, this is probably the one for you.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module will
+	  To compile this driver as a module, choose M here. The module will
 	  be called com90xx.
 
 config ARCNET_COM90xxIO
@@ -93,8 +91,7 @@ config ARCNET_COM90xxIO
 	  the normal driver. Only use it if your card doesn't support shared
 	  memory.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module will
+	  To compile this driver as a module, choose M here. The module will
 	  be called com90io.
 
 config ARCNET_RIM_I
@@ -105,8 +102,7 @@ config ARCNET_RIM_I
 	  driver is completely untested, so if you have one of these cards,
 	  please mail <dwmw2@infradead.org>, especially if it works!
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module will
+	  To compile this driver as a module, choose M here. The module will
 	  be called arc-rimi.
 
 config ARCNET_COM20020
@@ -116,8 +112,7 @@ config ARCNET_COM20020
 	  things as promiscuous mode, so packet sniffing is possible, and
 	  extra diagnostic information.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module will
+	  To compile this driver as a module, choose M here. The module will
 	  be called com20020.
 
 config ARCNET_COM20020_ISA
diff -puN drivers/net/tulip/Kconfig~remove-references-to-net-modulestxt drivers/net/tulip/Kconfig
--- a/drivers/net/tulip/Kconfig~remove-references-to-net-modulestxt
+++ a/drivers/net/tulip/Kconfig
@@ -24,8 +24,7 @@ config DE2104X
 	  will say Y here.) Do read the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module will
+	  To compile this driver as a module, choose M here. The module will
 	  be called de2104x.
 
 config TULIP
@@ -42,8 +41,7 @@ config TULIP
 	  will say Y here.) Do read the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module will
+	  To compile this driver as a module, choose M here. The module will
 	  be called tulip.
 
 config TULIP_MWI
@@ -104,8 +102,7 @@ config DE4X5
 	  information is contained in
 	  <file:Documentation/networking/de4x5.txt>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module will
+	  To compile this driver as a module, choose M here. The module will
 	  be called de4x5.
 
 config WINBOND_840
@@ -129,8 +126,7 @@ config DM9102
 	  (Ethernet) card, say Y.  Some information is contained in the file
 	  <file:Documentation/networking/dmfe.txt>.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module will
+	  To compile this driver as a module, choose M here. The module will
 	  be called dmfe.
 
 config ULI526X
@@ -141,8 +137,7 @@ config ULI526X
 	  This driver is for ULi M5261/M5263 10/100M Ethernet Controller
 	  (<http://www.uli.com.tw/>).
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module will
+	  To compile this driver as a module, choose M here. The module will
 	  be called uli526x.
 	  
 config PCMCIA_XIRCOM
@@ -154,8 +149,7 @@ config PCMCIA_XIRCOM
 	  as with work-alike chips from Lite-On (PNIC) and Macronix (MXIC) and
 	  ASIX.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module will
+	  To compile this driver as a module, choose M here. The module will
 	  be called xircom_cb.  If unsure, say N.
 
 config PCMCIA_XIRTULIP
@@ -168,8 +162,7 @@ config PCMCIA_XIRTULIP
 	  as with work-alike chips from Lite-On (PNIC) and Macronix (MXIC) and
 	  ASIX.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>.  The module will
+	  To compile this driver as a module, choose M here. The module will
 	  be called xircom_tulip_cb.  If unsure, say N.
 
 endif # NET_TULIP
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
lguest_userc-fix-memory-leak.patch
video-sis-fix-negative-array-index.patch
mm-hugetlbc-make-a-function-static.patch
git-avr32.patch
git-dvb.patch
remove-saa7134-oss.patch
git-gfs2-nmw.patch
git-libata-all.patch
blk_dev_idecd-help-remove-outdated-note.patch
git-mtd.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
git-netdev-all.patch
drivers-net-chelsio-if-0-unused-functions.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-nfs-make-nfs_wb_page_priority-static.patch
fs-nfs-dirc-should-include-internalh.patch
always-export-pci_scan_single_device.patch
remove-additional-pci_scan_child_bus-prototype.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-qla2xxx-possible-cleanups.patch
usb-mon-mon_binc-cleanups.patch
git-x86.patch
xtensa-iss_net_setup-must-be-__init.patch
xtensa-kernel-setupc-remove-dead-code.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
feature-removal-schedule-remove-sa_-flags-entry.patch
kernel-taskstatsc-fix-bogus-nlmsg_free.patch
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
blackfin-remove-dump_thread.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kernel-power-move-function-prototypes-to-header.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
remove-__attribute_used__.patch
remove-__attribute_used__-checkpatch-fixes.patch
proper-show_interrupts-prototype.patch
scheduled-oss-driver-removal.patch
linux-inith-simplify-__meminitexit-dependencies.patch
proper-prototype-for-signals_init.patch
kernel-ptracec-should-include-linux-syscallsh.patch
make-srcu_readers_active-static.patch
kernel-notifierc-should-include-linux-rebooth.patch
proper-prototype-for-get_filesystem_list.patch
fs-utimesc-should-include-linux-syscallsh.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
proper-prototype-for-vty_init.patch
drivers-misc-lkdtmc-cleanups.patch
power_supply_ledssysfsc-should-include-power_supplyh.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
ext4-superc-fix-ifdefs.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
remove-documentation-smptxt.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
reiser4.patch
