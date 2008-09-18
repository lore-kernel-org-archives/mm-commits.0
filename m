From: akpm@linux-foundation.org
Subject: - documentation-abi-sys-class-gpio.patch removed from -mm tree
Date: Thu, 18 Sep 2008 13:56:08 -0700
Message-ID: <200809182056.m8IKu8G6019168@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754962AbYIRU4d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Sep 2008 16:56:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Documentation/ABI: /sys/class/gpio
has been removed from the -mm tree.  Its filename was
     documentation-abi-sys-class-gpio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/ABI: /sys/class/gpio
From: David Brownell <dbrownell@users.sourceforge.net>

Provide summary ABI docs about the /sys/class/gpio files.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-gpio |   26 +++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff -puN /dev/null Documentation/ABI/testing/sysfs-gpio
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-gpio
@@ -0,0 +1,26 @@
+What:		/sys/class/gpio/
+Date:		July 2008
+KernelVersion:	2.6.27
+Contact:	David Brownell <dbrownell@users.sourceforge.net>
+Description:
+
+  As a Kconfig option, individual GPIO signals may be accessed from
+  userspace.  GPIOs are only made available to userspace by an explicit
+  "export" operation.  If a given GPIO is not claimed for use by
+  kernel code, it may be exported by userspace (and unexported later).
+  Kernel code may export it for complete or partial access.
+
+  GPIOs are identified as they are inside the kernel, using integers in
+  the range 0..INT_MAX.  See Documentation/gpio.txt for more information.
+
+    /sys/class/gpio
+	/export ... asks the kernel to export a GPIO to userspace
+	/unexport ... to return a GPIO to the kernel
+	/gpioN ... for each exported GPIO #N
+	    /value ... always readable, writes fail for input GPIOs
+	    /direction ... r/w as: in, out (default low); write: high, low
+	/gpiochipN ... for each gpiochip; #N is its first GPIO
+	    /base ... (r/o) same as N
+	    /label ... (r/o) descriptive, not necessarily unique
+	    /ngpio ... (r/o) number of GPIOs; numbered N to N + (ngpio - 1)
+
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
rtc-fix-kernel-panic-on-second-use-of-sigio-nofitication.patch
linux-next.patch
acpi-cope-with-pnpacpi-tables-missing-an-rtc-entry.patch
acpi-cope-with-pnpacpi-tables-missing-an-rtc-entry-fix.patch
spi-simplify-spi_write_then_read.patch
spi_s3c24xx-pin-configuration-updates.patch
pxa2xx_spi-minor-cleanup.patch
pxa2xx_spi-fix-chip_info-defaults-and-documentation.patch
rtc-ds1307-alarm-support-for-ds1337-ds1339.patch
rtc-remove-some-nop-open-release-methods.patch
legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option.patch
rtc-file-close-consistently-disables-repeating-irqs.patch
rtc-cmos-strongly-avoid-hpet-emulation.patch
rtc-cmos-export-second-nvram-bank.patch
make-gpiochip-label-const.patch
genirq-record-trigger-type.patch
genirq-record-trigger-type-fix.patch
irq-warn-about-irqf_disabledirqf_shared.patch

