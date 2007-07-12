From: akpm@linux-foundation.org
Subject: + gpio-calls-dont-need-i-o-barriers.patch added to -mm tree
Date: Thu, 12 Jul 2007 14:00:52 -0700
Message-ID: <200707122100.l6CL0qcV002323@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48915 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762048AbXGLVBI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jul 2007 17:01:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     gpio calls don't need i/o barriers
has been added to the -mm tree.  Its filename is
     gpio-calls-dont-need-i-o-barriers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: gpio calls don't need i/o barriers
From: David Brownell <david-b@pacbell.net>

Clarify that drivers using the GPIO operations don't need to issue io
barrier instructions themselves.  Previously this wasn't clear, and at
least one platform assumed otherwise (and would thus break various
otherwise-portable drivers which don't issue barriers).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/gpio.txt |    3 +++
 1 files changed, 3 insertions(+)

diff -puN Documentation/gpio.txt~gpio-calls-dont-need-i-o-barriers Documentation/gpio.txt
--- a/Documentation/gpio.txt~gpio-calls-dont-need-i-o-barriers
+++ a/Documentation/gpio.txt
@@ -75,6 +75,9 @@ using the include file:
 If you stick to this convention then it'll be easier for other developers to
 see what your code is doing, and help maintain it.
 
+Note that these operations include I/O barriers on platforms which need to
+use them; drivers don't need to add them explicitly.
+
 
 Identifying GPIOs
 -----------------
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
git-avr32.patch
pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm.patch
git-mmc.patch
git-mtd.patch
geode-basic-infrastructure-support-for-amd-geode-class.patch
char-genrtc-use-wait_event_interruptible.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
gpio-calls-dont-need-i-o-barriers.patch
spi-controller-drivers-check-for-unsupported-modes.patch
spi-add-3wire-mode-flag.patch
spidev-compiler-warning-gone.patch
spi_mpc83xxc-underclocking-hotfix.patch
atmel_spi-minor-updates.patch
s3c24xx-spi-controllers-both-select-bitbang.patch
spi-master-driver-for-xilinx-virtex.patch
spi-omap2_mcspi-driver.patch
rtc-ds1307-cleanups.patch
rtc-rs5c372-becomes-a-new-style-i2c-driver.patch
thecus-n2100-register-rtc-rs5c372-i2c-device.patch
rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported.patch
rtc-dev-return-enotty-in-ioctl-if-irq_set_freq-is-not-implemented-by-driver.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch
rtc-kconfig-tweax.patch
rtc-add-rtc-m41t80-driver-take-2.patch
rtc-watchdog-support-for-rtc-m41t80-driver-take-2.patch
