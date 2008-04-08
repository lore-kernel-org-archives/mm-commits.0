From: akpm@linux-foundation.org
Subject: + spi-documentation-tweaks.patch added to -mm tree
Date: Tue, 08 Apr 2008 01:05:37 -0700
Message-ID: <200804080805.m3885blo015563@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752634AbYDHIGV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2008 04:06:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     spi: documentation tweaks
has been added to the -mm tree.  Its filename is
     spi-documentation-tweaks.patch

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
Subject: spi: documentation tweaks
From: David Brownell <david-b@pacbell.net>

Update SPI documentation to clarify some areas of recent confusion: clock
polarity takes effect when chipselect goes active; and zero length buffers are
OK in certain cases.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/spi/spi-summary |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN Documentation/spi/spi-summary~spi-documentation-tweaks Documentation/spi/spi-summary
--- a/Documentation/spi/spi-summary~spi-documentation-tweaks
+++ a/Documentation/spi/spi-summary
@@ -116,6 +116,13 @@ low order bit.  So when a chip's timing 
 starting low (CPOL=0) and data stabilized for sampling during the
 trailing clock edge (CPHA=1), that's SPI mode 1.
 
+Note that the clock mode is relevant as soon as the chipselect goes
+active.  So the master must set the clock to inactive before selecting
+a slave, and the slave can tell the chosen polarity by sampling the
+clock level when its select line goes active.  That's why many devices
+support for example both modes 0 and 3:  they don't care about polarity,
+and alway clock data in/out on rising clock edges.
+
 
 How do these driver programming interfaces work?
 ------------------------------------------------
@@ -379,8 +386,14 @@ any more such messages.
       + when bidirectional reads and writes start ... by how its
         sequence of spi_transfer requests is arranged;
 
+      + which I/O buffers are used ... each spi_transfer wraps a
+        buffer for each transfer direction, supporting full duplex
+        (two pointers, maybe the same one in both cases) and half
+        duplex (one pointer is NULL) transfers;
+
       + optionally defining short delays after transfers ... using
-        the spi_transfer.delay_usecs setting;
+        the spi_transfer.delay_usecs setting (this delay can be the
+        only protocol effect, if the buffer length is zero);
 
       + whether the chipselect becomes inactive after a transfer and
         any delay ... by using the spi_transfer.cs_change flag;
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
git-acpi.patch
git-arm.patch
git-avr32.patch
git-input.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
jffs2-summary-allocation-dont-use-vmalloc.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
spi-pxa2xx_spi-sparse-fixes.patch
atmel_spi-support-zero-length-transfer.patch
rtc-avoid-legacy-drivers-with-generic-framework.patch
rtc-avoid-legacy-drivers-with-generic-framework-update.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
rtc-silence-section-mismatch-warning-in-rtc-test.patch
make-ds1511_rtc_readset_time-static.patch
kerneldoc-for-linux-clkh.patch
kerneldoc-for-linux-clkh-fix.patch
rtc-rtc-rs5c372-fix-up-null-name-in-transfer-error-path.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
rtc-replace-remaining-__function__-occurrences.patch
gpiochip_reserve-fix-2.patch
remove-duplicated-unlikely-in-is_err.patch
spi-documentation-tweaks.patch

