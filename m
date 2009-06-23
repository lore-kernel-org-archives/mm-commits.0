From: akpm@linux-foundation.org
Subject: + spi-new-spi-mode-bits.patch added to -mm tree
Date: Tue, 23 Jun 2009 12:18:17 -0700
Message-ID: <200906231918.n5NJIH4m021674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750845AbZFWTSU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 15:18:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, s-paulraj@ti.com


The patch titled
     spi: new spi->mode bits
has been added to the -mm tree.  Its filename is
     spi-new-spi-mode-bits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: new spi->mode bits
From: David Brownell <dbrownell@users.sourceforge.net>

Add two new spi_device.mode bits to accomodate more protocol options, and
pass them through to usermode drivers:

 * SPI_NO_CS ... a second 3-wire variant, where the chipselect
   line is removed instead of a data line; transfers are still
   full duplex.

   This obviously has STRONG protocol implications since the
   chipselect transitions can't be used to synchronize state
   transitions with the SPI master.

 * SPI_READY ... defines open drain signal that's pulled low
   to pause the clock.  This defines a 5-wire variant (normal
   4-wire SPI plus READY) and two 4-wire variants (READY plus
   each of the 3-wire flavors).

   Such hardware flow control can be a big win.  There are ADC
   converters and flash chips that expose READY signals, but not
   many host controllers support it today.

The spi_bitbang code should be changed to use SPI_NO_CS instead of its
current nonportable hack.  That's a mode most hardware can easily support
(unlike SPI_READY).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: "Paulraj, Sandeep" <s-paulraj@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/spi/spidev_test.c |   10 +++++++++-
 drivers/spi/spidev.c            |   17 +++++++++++------
 include/linux/spi/spi.h         |    2 ++
 include/linux/spi/spidev.h      |    2 ++
 4 files changed, 24 insertions(+), 7 deletions(-)

diff -puN Documentation/spi/spidev_test.c~spi-new-spi-mode-bits Documentation/spi/spidev_test.c
--- a/Documentation/spi/spidev_test.c~spi-new-spi-mode-bits
+++ a/Documentation/spi/spidev_test.c
@@ -99,11 +99,13 @@ void parse_opts(int argc, char *argv[])
 			{ "lsb",     0, 0, 'L' },
 			{ "cs-high", 0, 0, 'C' },
 			{ "3wire",   0, 0, '3' },
+			{ "no-cs",   0, 0, 'N' },
+			{ "ready",   0, 0, 'R' },
 			{ NULL, 0, 0, 0 },
 		};
 		int c;
 
-		c = getopt_long(argc, argv, "D:s:d:b:lHOLC3", lopts, NULL);
+		c = getopt_long(argc, argv, "D:s:d:b:lHOLC3NR", lopts, NULL);
 
 		if (c == -1)
 			break;
@@ -139,6 +141,12 @@ void parse_opts(int argc, char *argv[])
 		case '3':
 			mode |= SPI_3WIRE;
 			break;
+		case 'N':
+			mode |= SPI_NO_CS;
+			break;
+		case 'R':
+			mode |= SPI_READY;
+			break;
 		default:
 			print_usage(argv[0]);
 			break;
diff -puN drivers/spi/spidev.c~spi-new-spi-mode-bits drivers/spi/spidev.c
--- a/drivers/spi/spidev.c~spi-new-spi-mode-bits
+++ a/drivers/spi/spidev.c
@@ -58,15 +58,20 @@ static unsigned long	minors[N_SPI_MINORS
 
 
 /* Bit masks for spi_device.mode management.  Note that incorrect
- * settings for CS_HIGH and 3WIRE can cause *lots* of trouble for other
- * devices on a shared bus:  CS_HIGH, because this device will be
- * active when it shouldn't be;  3WIRE, because when active it won't
- * behave as it should.
+ * settings for some settings can cause *lots* of trouble for other
+ * devices on a shared bus:
  *
- * REVISIT should changing those two modes be privileged?
+ *  - CS_HIGH ... this device will be active when it shouldn't be
+ *  - 3WIRE ... when active, it won't behave as it should
+ *  - NO_CS ... there will be no explicit message boundaries; this
+ *	is completely incompatible with the shared bus model
+ *  - READY ... transfers may proceed when they shouldn't.
+ *
+ * REVISIT should changing those flags be privileged?
  */
 #define SPI_MODE_MASK		(SPI_CPHA | SPI_CPOL | SPI_CS_HIGH \
-				| SPI_LSB_FIRST | SPI_3WIRE | SPI_LOOP)
+				| SPI_LSB_FIRST | SPI_3WIRE | SPI_LOOP \
+				| SPI_NO_CS | SPI_READY)
 
 struct spidev_data {
 	dev_t			devt;
diff -puN include/linux/spi/spi.h~spi-new-spi-mode-bits include/linux/spi/spi.h
--- a/include/linux/spi/spi.h~spi-new-spi-mode-bits
+++ a/include/linux/spi/spi.h
@@ -80,6 +80,8 @@ struct spi_device {
 #define	SPI_LSB_FIRST	0x08			/* per-word bits-on-wire */
 #define	SPI_3WIRE	0x10			/* SI/SO signals shared */
 #define	SPI_LOOP	0x20			/* loopback mode */
+#define	SPI_NO_CS	0x40			/* 1 dev/bus, no chipselect */
+#define	SPI_READY	0x80			/* slave pulls low to pause */
 	u8			bits_per_word;
 	int			irq;
 	void			*controller_state;
diff -puN include/linux/spi/spidev.h~spi-new-spi-mode-bits include/linux/spi/spidev.h
--- a/include/linux/spi/spidev.h~spi-new-spi-mode-bits
+++ a/include/linux/spi/spidev.h
@@ -40,6 +40,8 @@
 #define SPI_LSB_FIRST		0x08
 #define SPI_3WIRE		0x10
 #define SPI_LOOP		0x20
+#define SPI_NO_CS		0x40
+#define SPI_READY		0x80
 
 /*---------------------------------------------------------------------------*/
 
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
spi-new-spi-mode-bits.patch
spi-add-spi_master-flag-word.patch

