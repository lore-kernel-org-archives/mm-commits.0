From: akpm@linux-foundation.org
Subject: + spi-doc-update-describe-clock-mode-bits.patch added to -mm tree
Date: Mon, 21 May 2007 14:53:06 -0700
Message-ID: <200705212153.l4LLr6lO020920@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42593 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758081AbXEUVza (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 17:55:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     spi doc update: describe clock mode bits
has been added to the -mm tree.  Its filename is
     spi-doc-update-describe-clock-mode-bits.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi doc update: describe clock mode bits
From: David Brownell <david-b@pacbell.net>

Update the SPI documentation to cover a few points that have proven to be
confusing or unclear; most notably the two clock mode bits.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/spi/spi-summary |   53 ++++++++++++++++++++++++++++----
 1 files changed, 48 insertions(+), 5 deletions(-)

diff -puN Documentation/spi/spi-summary~spi-doc-update-describe-clock-mode-bits Documentation/spi/spi-summary
--- a/Documentation/spi/spi-summary~spi-doc-update-describe-clock-mode-bits
+++ a/Documentation/spi/spi-summary
@@ -1,26 +1,30 @@
 Overview of Linux kernel SPI support
 ====================================
 
-02-Dec-2005
+21-May-2007
 
 What is SPI?
 ------------
 The "Serial Peripheral Interface" (SPI) is a synchronous four wire serial
 link used to connect microcontrollers to sensors, memory, and peripherals.
+It's a simple "de facto" standard, not complicated enough to acquire a
+standardization body.  SPI uses a master/slave configuration.
 
 The three signal wires hold a clock (SCK, often on the order of 10 MHz),
 and parallel data lines with "Master Out, Slave In" (MOSI) or "Master In,
 Slave Out" (MISO) signals.  (Other names are also used.)  There are four
 clocking modes through which data is exchanged; mode-0 and mode-3 are most
 commonly used.  Each clock cycle shifts data out and data in; the clock
-doesn't cycle except when there is data to shift.
+doesn't cycle except when there is a data bit to shift.  Not all data bits
+are used though; not every protocol uses those full duplex capabilities.
 
-SPI masters may use a "chip select" line to activate a given SPI slave
+SPI masters use a fourth "chip select" line to activate a given SPI slave
 device, so those three signal wires may be connected to several chips
-in parallel.  All SPI slaves support chipselects.  Some devices have
+in parallel.  All SPI slaves support chipselects; they are usually active
+low signals, labeled nCSx for slave 'x' (e.g. nCS0).  Some devices have
 other signals, often including an interrupt to the master.
 
-Unlike serial busses like USB or SMBUS, even low level protocols for
+Unlike serial busses like USB or SMBus, even low level protocols for
 SPI slave functions are usually not interoperable between vendors
 (except for commodities like SPI memory chips).
 
@@ -33,6 +37,11 @@ SPI slave functions are usually not inte
   - Some devices may use eight bit words.  Others may different word
     lengths, such as streams of 12-bit or 20-bit digital samples.
 
+  - Words are usually sent with their most significant bit (MSB) first,
+    but sometimes the least significant bit (LSB) goes first instead.
+
+  - Sometimes SPI is used to daisy-chain devices, like shift registers.
+
 In the same way, SPI slaves will only rarely support any kind of automatic
 discovery/enumeration protocol.  The tree of slave devices accessible from
 a given SPI master will normally be set up manually, with configuration
@@ -44,6 +53,14 @@ half-duplex SPI, for request/response pr
 Serial Protocol"), PSP ("Programmable Serial Protocol"), and other
 related protocols.
 
+Some chips eliminate a signal line by combining MOSI and MISO, and
+limiting themselves to half-duplex at the hardware level.  In fact
+some SPI chips have this signal mode as a strapping option.  These
+can be accessed using the same programming interface as SPI, but of
+course they won't handle full duplex transfers.  You may find such
+chips described as using "three wire" signaling: SCK, data, nCSx.
+(That data line is sometimes called MOMI or SISO.)
+
 Microcontrollers often support both master and slave sides of the SPI
 protocol.  This document (and Linux) currently only supports the master
 side of SPI interactions.
@@ -74,6 +91,32 @@ interfaces with SPI modes.  Given SPI su
 cards without needing a special purpose MMC/SD/SDIO controller.
 
 
+I'm confused.  What are these four SPI "clock modes"?
+-----------------------------------------------------
+It's easy to be confused here, and the vendor documentation you'll
+find isn't necessarily helpful.  The four modes combine two mode bits:
+
+ - CPOL indicates the initial clock polarity.  CPOL=0 means the
+   clock starts low, so the first (leading) edge is rising, and
+   the second (trailing) edge is falling.  CPOL=1 means the clock
+   starts high, so the first (leading) edge is falling.
+
+ - CPHA indicates the clock phase used to sample data; CPHA=0 says
+   sample on the leading edge, CPHA=1 means the trailing edge.
+
+   Since the signal needs to stablize before it's sampled, CPHA=0
+   implies that its data is written half a clock before the first
+   clock edge.  The chipselect may have made it become available.
+
+Chip specs won't always say "uses SPI mode X" in as many words,
+but their timing diagrams will make the CPOL and CPHA modes clear.
+
+In the SPI mode number, CPOL is the high order bit and CPHA is the
+low order bit.  So when a chip's timing diagram shows the clock
+starting low (CPOL=0) and data stabilized for sampling during the
+trailing clock edge (CPHA=1), that's SPI mode 1.
+
+
 How do these driver programming interfaces work?
 ------------------------------------------------
 The <linux/spi/spi.h> header file includes kerneldoc, as does the
_

Patches currently in -mm which might be from david-b@pacbell.net are

spi-doc-update-describe-clock-mode-bits.patch
update-documentation-driver-model-platformtxt.patch
git-leds.patch
git-mmc.patch
at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
fix-usb-ohci-subvendor-for-toshiba-portege-4000.patch
rtc-ds1307-cleanups.patch
