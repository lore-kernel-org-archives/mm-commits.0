From: akpm@linux-foundation.org
Subject: + parport_ieee1284_epp_read_addr-patch.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:17:34 -0800
Message-ID: <200801270517.m0R5HVWX031132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44239 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813AbYA0FRj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:17:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: boettcher@physik.uni-kiel.de


The patch titled
     parport: fix ieee1284_epp_read_addr
has been added to the -mm tree.  Its filename is
     parport_ieee1284_epp_read_addr-patch.patch

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
Subject: parport: fix ieee1284_epp_read_addr
From: Stephan Boettcher <boettcher@physik.uni-kiel.de>

We bought chaep notebooks to control our custom data acquisition system, which
requires EPP mode (read/write, data/addr).  The bios does not offer EPP mode,
and indeed hardware EPP mode appears not to work, although the parport driver
tries to use it.  EPPSWE mode does work for data r/w and addr write, but addr
read requires this patch.  

(stephan)rshgse3: lspci

00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT Express Memory Controller Hub (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS/940GML Express Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/940GML Express Integrated Graphics Controller (rev 03)
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 02)
00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 02)
00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #3 (rev 02)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #4 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 02)
00:1f.2 SATA controller: Intel Corporation 82801GBM/GHM (ICH7 Family) Serial ATA Storage Controller AHCI (rev 02)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8055 PCI-E Gigabit Ethernet Controller (rev 12)
05:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG Network Connection (rev 02)
08:03.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev b3)
08:03.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C552 IEEE 1394 Controller (rev 08)
08:03.2 Generic system peripheral [0805]: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 17)

(stephan)rshgse3: grep . /proc/sys/dev/parport/parport0/*

/proc/sys/dev/parport/parport0/base-addr:888    1912
/proc/sys/dev/parport/parport0/dma:-1
/proc/sys/dev/parport/parport0/irq:7
/proc/sys/dev/parport/parport0/modes:PCSPP,TRISTATE,EPP
/proc/sys/dev/parport/parport0/spintime:500


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/ieee1284_ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/parport/ieee1284_ops.c~parport_ieee1284_epp_read_addr-patch drivers/parport/ieee1284_ops.c
--- a/drivers/parport/ieee1284_ops.c~parport_ieee1284_epp_read_addr-patch
+++ a/drivers/parport/ieee1284_ops.c
@@ -888,7 +888,7 @@ size_t parport_ieee1284_epp_read_addr (s
 
 		/* Event 59: set nSelectIn (nAStrb) high */
 		parport_frob_control (port, PARPORT_CONTROL_SELECT,
-				      PARPORT_CONTROL_SELECT);
+				      0);
 
 		/* Event 60: wait for Busy to go low */
 		if (parport_poll_peripheral (port, PARPORT_STATUS_BUSY, 
_

Patches currently in -mm which might be from boettcher@physik.uni-kiel.de are

parport_ieee1284_epp_read_addr-patch.patch
