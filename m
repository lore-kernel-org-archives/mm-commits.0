From: akpm@linux-foundation.org
Subject: + documentation-update-firewire-debugging-documentation.patch
 added to -mm tree
Date: Tue, 07 Jan 2014 15:55:11 -0800
Message-ID: <52cc93df.Bqw9Pkk2vxLk+gt2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbaAGXzM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jan 2014 18:55:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stefanr@s5r6.in-berlin.de, rob@landley.net, justinmattock@gmail.com, bk@suse.de, lkundrak@v3.sk

Subject: + documentation-update-firewire-debugging-documentation.patch added to -mm tree
To: lkundrak@v3.sk,bk@suse.de,justinmattock@gmail.com,rob@landley.net,stefanr@s5r6.in-berlin.de
From: akpm@linux-foundation.org
Date: Tue, 07 Jan 2014 15:55:11 -0800


The patch titled
     Subject: Documentation/: update FireWire debugging documentation
has been added to the -mm tree.  Its filename is
     documentation-update-firewire-debugging-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-update-firewire-debugging-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-update-firewire-debugging-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lubomir Rintel <lkundrak@v3.sk>
Subject: Documentation/: update FireWire debugging documentation

The old firewire stack is long dead now and a new version firescope has
been released with support for current kernels.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: Rob Landley <rob@landley.net>
Cc: Justin P. Mattock <justinmattock@gmail.com>
Cc: Bernhard Kaindl <bk@suse.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/debugging-via-ohci1394.txt   |   24 +++++++------------
 Documentation/power/basic-pm-debugging.txt |    2 -
 2 files changed, 10 insertions(+), 16 deletions(-)

diff -puN Documentation/debugging-via-ohci1394.txt~documentation-update-firewire-debugging-documentation Documentation/debugging-via-ohci1394.txt
--- a/Documentation/debugging-via-ohci1394.txt~documentation-update-firewire-debugging-documentation
+++ a/Documentation/debugging-via-ohci1394.txt
@@ -36,17 +36,13 @@ available (notebooks) or too slow for ex
 Drivers
 -------
 
-The ohci1394 driver in drivers/ieee1394 initializes the OHCI-1394 controllers
-to a working state and enables physical DMA by default for all remote nodes.
-This can be turned off by ohci1394's module parameter phys_dma=0.
-
-The alternative firewire-ohci driver in drivers/firewire uses filtered physical
+The firewire-ohci driver in drivers/firewire uses filtered physical
 DMA by default, which is more secure but not suitable for remote debugging.
 Compile the driver with CONFIG_FIREWIRE_OHCI_REMOTE_DMA (Kernel hacking menu:
 Remote debugging over FireWire with firewire-ohci) to get unfiltered physical
 DMA.
 
-Because ohci1394 and firewire-ohci depend on the PCI enumeration to be
+Because the firewire-ohci driver depends on the PCI enumeration to be
 completed, an initialization routine which runs pretty early has been
 implemented for x86.  This routine runs long before console_init() can be
 called, i.e. before the printk buffer appears on the console.
@@ -64,7 +60,7 @@ be used to view the printk buffer of a r
 
 Bernhard Kaindl enhanced firescope to support accessing 64-bit machines
 from 32-bit firescope and vice versa:
-- http://halobates.de/firewire/firescope-0.2.2.tar.bz2
+- http://v3.sk/~lkundrak/firescope/
 
 and he implemented fast system dump (alpha version - read README.txt):
 - http://halobates.de/firewire/firedump-0.1.tar.bz2
@@ -92,11 +88,11 @@ Step-by-step instructions for using fire
 
 1) Verify that your hardware is supported:
 
-   Load the ohci1394 or the fw-ohci module and check your kernel logs.
+   Load the firewire-ohci module and check your kernel logs.
    You should see a line similar to
 
-   ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[18]  MMIO=[fe9ff800-fe9fffff]
-   ... Max Packet=[2048]  IR/IT contexts=[4/8]
+   firewire_ohci 0000:15:00.1: added OHCI v1.0 device as card 2, 4 IR + 4 IT
+   ... contexts, quirks 0x11
 
    when loading the driver. If you have no supported controller, many PCI,
    CardBus and even some Express cards which are fully compliant to OHCI-1394
@@ -113,20 +109,18 @@ Step-by-step instructions for using fire
 
    If an driver is running on both machines you should see a line like
 
-   ieee1394: Node added: ID:BUS[0-01:1023]  GUID[0090270001b84bba]
+   firewire_core 0000:15:00.1: created device fw1: GUID 00061b0020105917, S400
 
    on both machines in the kernel log when the cable is plugged in
    and connects the two machines.
 
 3) Test physical DMA using firescope:
 
-   On the debug host,
-	- load the raw1394 module,
-	- make sure that /dev/raw1394 is accessible,
+   On the debug host, make sure that /dev/fw* is accessible,
    then start firescope:
 
 	$ firescope
-	Port 0 (ohci1394) opened, 2 nodes detected
+	Port 0 (/dev/fw1) opened, 2 nodes detected
 
 	FireScope
 	---------
diff -puN Documentation/power/basic-pm-debugging.txt~documentation-update-firewire-debugging-documentation Documentation/power/basic-pm-debugging.txt
--- a/Documentation/power/basic-pm-debugging.txt~documentation-update-firewire-debugging-documentation
+++ a/Documentation/power/basic-pm-debugging.txt
@@ -172,7 +172,7 @@ you can boot the kernel with the 'no_con
 kernel messages using the serial console.  This may provide you with some
 information about the reasons of the suspend (resume) failure.  Alternatively,
 it may be possible to use a FireWire port for debugging with firescope
-(ftp://ftp.firstfloor.org/pub/ak/firescope/).  On x86 it is also possible to
+(http://v3.sk/~lkundrak/firescope/).  On x86 it is also possible to
 use the PM_TRACE mechanism documented in Documentation/power/s2ram.txt .
 
 2. Testing suspend to RAM (STR)
_

Patches currently in -mm which might be from lkundrak@v3.sk are

documentation-update-firewire-debugging-documentation.patch
linux-next.patch

