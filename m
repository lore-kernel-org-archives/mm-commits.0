From: akpm@linux-foundation.org
Subject: - ali-m7101-pmu-also-available-on-sun-netras-too.patch removed from -mm tree
Date: Wed, 13 Aug 2008 01:53:36 -0700
Message-ID: <200808130853.m7D8ragM008343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751443AbYHMIyl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 04:54:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex@digriz.org.uk, davem@davemloft.net, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     ALi M7101 PMU also available on Sun Netra's too
has been removed from the -mm tree.  Its filename was
     ali-m7101-pmu-also-available-on-sun-netras-too.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ALi M7101 PMU also available on Sun Netra's too
From: Alexander Clouter <alex@digriz.org.uk>

My Sun Netra T1 AC200 has one of these... bit harsh not letting me use it
and all :)

==========
alex@woodchuck:~$ lspci -nn
00:01.0 PCI bridge [0604]: Sun Microsystems Computer Corp. Simba Advanced PCI Bridge [108e:5000] (rev 13)
00:01.1 PCI bridge [0604]: Sun Microsystems Computer Corp. Simba Advanced PCI Bridge [108e:5000] (rev 13)
01:03.0 Non-VGA unclassified device [0000]: ALi Corporation M7101 Power Management Controller [PMU] [10b9:7101]
01:05.1 Ethernet controller [0200]: Sun Microsystems Computer Corp. RIO GEM [108e:1101] (rev 01)
01:05.3 USB Controller [0c03]: Sun Microsystems Computer Corp. RIO USB [108e:1103] (rev 01)
01:07.0 ISA bridge [0601]: ALi Corporation M1533/M1535 PCI to ISA Bridge [Aladdin IV/V/V+] [10b9:1533]
01:0c.0 Bridge [0680]: Sun Microsystems Computer Corp. RIO EBUS [108e:1100] (rev 01)
01:0c.1 Ethernet controller [0200]: Sun Microsystems Computer Corp. RIO GEM [108e:1101] (rev 01)
01:0c.3 USB Controller [0c03]: Sun Microsystems Computer Corp. RIO USB [108e:1103] (rev 01)
01:0d.0 IDE interface [0101]: ALi Corporation M5229 IDE [10b9:5229] (rev c3)
02:08.0 SCSI storage controller [0100]: LSI Logic / Symbios Logic 53C896/897 [1000:000b] (rev 07)
02:08.1 SCSI storage controller [0100]: LSI Logic / Symbios Logic 53C896/897 [1000:000b] (rev 07)
==========

Signed-off-by: Alexander Clouter <alex@digriz.org.uk>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/Kconfig |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/watchdog/Kconfig~ali-m7101-pmu-also-available-on-sun-netras-too drivers/watchdog/Kconfig
--- a/drivers/watchdog/Kconfig~ali-m7101-pmu-also-available-on-sun-netras-too
+++ a/drivers/watchdog/Kconfig
@@ -285,10 +285,11 @@ config ALIM1535_WDT
 
 config ALIM7101_WDT
 	tristate "ALi M7101 PMU Computer Watchdog"
-	depends on X86 && PCI
+	depends on PCI
 	help
 	  This is the driver for the hardware watchdog on the ALi M7101 PMU
-	  as used in the x86 Cobalt servers.
+	  as used in the x86 Cobalt servers and also found in some
+	  SPARC Netra servers too.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called alim7101_wdt.
_

Patches currently in -mm which might be from alex@digriz.org.uk are


