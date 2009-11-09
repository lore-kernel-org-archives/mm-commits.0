From: akpm@linux-foundation.org
Subject: + spidev-use-declare_bitmap-instead-of-declaring-the-array.patch added to -mm tree
Date: Mon, 09 Nov 2009 12:26:39 -0800
Message-ID: <200911092026.nA9KQdF9000324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754491AbZKIU0x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 15:26:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cascardo@holoscopio.com, dbrownell@users.sourceforge.net


The patch titled
     spidev: use DECLARE_BITMAP instead of declaring the array
has been added to the -mm tree.  Its filename is
     spidev-use-declare_bitmap-instead-of-declaring-the-array.patch

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
Subject: spidev: use DECLARE_BITMAP instead of declaring the array
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/spi/spidev.c~spidev-use-declare_bitmap-instead-of-declaring-the-array drivers/spi/spidev.c
--- a/drivers/spi/spidev.c~spidev-use-declare_bitmap-instead-of-declaring-the-array
+++ a/drivers/spi/spidev.c
@@ -54,7 +54,7 @@
 #define SPIDEV_MAJOR			153	/* assigned */
 #define N_SPI_MINORS			32	/* ... up to 256 */
 
-static unsigned long	minors[N_SPI_MINORS / BITS_PER_LONG];
+static DECLARE_BITMAP(minors,N_SPI_MINORS);
 
 
 /* Bit masks for spi_device.mode management.  Note that incorrect
_

Patches currently in -mm which might be from cascardo@holoscopio.com are

linux-next.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-depends-on-acpi.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array.patch

