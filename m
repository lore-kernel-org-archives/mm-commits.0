From: akpm@linux-foundation.org
Subject: [merged] spi-documentation-emphasise-spi_mastersetup-semantics.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:30:35 -0700
Message-ID: <200904221830.n3MIUZdY006271@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40938 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753084AbZDVScg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:32:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: documentation: emphasise spi_master.setup() semantics
has been removed from the -mm tree.  Its filename was
     spi-documentation-emphasise-spi_mastersetup-semantics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: documentation: emphasise spi_master.setup() semantics
From: David Brownell <dbrownell@users.sourceforge.net>

This is a doc-only patch which I hope will reduce the number of spi_master
controller driver patches starting out with a common implementation bug. 
(As in: almost every spi_master driver I see starts out with its version
of this bug.  Sigh.)

It just re-emphasizes that the setup() method may be called for one device
while a transfer is active on another ...  which means that most driver
implementations shouldn't touch any registers.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/spi/spi-summary |    6 ++++++
 include/linux/spi/spi.h       |    7 ++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff -puN Documentation/spi/spi-summary~spi-documentation-emphasise-spi_mastersetup-semantics Documentation/spi/spi-summary
--- a/Documentation/spi/spi-summary~spi-documentation-emphasise-spi_mastersetup-semantics
+++ a/Documentation/spi/spi-summary
@@ -511,10 +511,16 @@ SPI MASTER METHODS
 	This sets up the device clock rate, SPI mode, and word sizes.
 	Drivers may change the defaults provided by board_info, and then
 	call spi_setup(spi) to invoke this routine.  It may sleep.
+
 	Unless each SPI slave has its own configuration registers, don't
 	change them right away ... otherwise drivers could corrupt I/O
 	that's in progress for other SPI devices.
 
+		** BUG ALERT:  for some reason the first version of
+		** many spi_master drivers seems to get this wrong.
+		** When you code setup(), ASSUME that the controller
+		** is actively processing transfers for another device.
+
     master->transfer(struct spi_device *spi, struct spi_message *message)
     	This must not sleep.  Its responsibility is arrange that the
 	transfer happens and its complete() callback is issued.  The two
diff -puN include/linux/spi/spi.h~spi-documentation-emphasise-spi_mastersetup-semantics include/linux/spi/spi.h
--- a/include/linux/spi/spi.h~spi-documentation-emphasise-spi_mastersetup-semantics
+++ a/include/linux/spi/spi.h
@@ -245,7 +245,12 @@ struct spi_master {
 	 */
 	u16			dma_alignment;
 
-	/* setup mode and clock, etc (spi driver may call many times) */
+	/* Setup mode and clock, etc (spi driver may call many times).
+	 *
+	 * IMPORTANT:  this may be called when transfers to another
+	 * device are active.  DO NOT UPDATE SHARED REGISTERS in ways
+	 * which could break those transfers.
+	 */
 	int			(*setup)(struct spi_device *spi);
 
 	/* bidirectional bulk transfers
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

linux-next.patch
mtd-nand-dont-walk-past-end-of-oobfree.patch
mtd-nand-minor-davinci_nand-cleanup.patch
mtd-nand-davinci_nand-4-bit-ecc-for-smallpage.patch
spi_bfin5xx-limit-reaches-1.patch
spi-move-common-spi_setup-functionality-into-core.patch
spi-move-more-spi_setup-functionality-into-core.patch
rtc-rtc-ds1307-add-ds3231.patch

