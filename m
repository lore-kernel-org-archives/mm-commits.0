From: akpm@linux-foundation.org
Subject: + dev_vdbg-available-with-dverbose_debug-docs.patch added to -mm tree
Date: Fri, 13 Jul 2007 16:32:09 -0700
Message-ID: <200707132332.l6DNW9iX028676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39437 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755344AbXGMXc2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 19:32:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, greg@kroah.com


The patch titled
     dev_vdbg(), available with -DVERBOSE_DEBUG (docs)
has been added to the -mm tree.  Its filename is
     dev_vdbg-available-with-dverbose_debug-docs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dev_vdbg(), available with -DVERBOSE_DEBUG (docs)
From: David Brownell <david-b@pacbell.net>

Update CodingStyle to talk about "-DDEBUG" message conventions and the
new "-DVERBOSE_DEBUG" convention.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/CodingStyle |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff -puN Documentation/CodingStyle~dev_vdbg-available-with-dverbose_debug-docs Documentation/CodingStyle
--- a/Documentation/CodingStyle~dev_vdbg-available-with-dverbose_debug-docs
+++ a/Documentation/CodingStyle
@@ -633,12 +633,27 @@ covers RTL which is used frequently with
 
 Kernel developers like to be seen as literate. Do mind the spelling
 of kernel messages to make a good impression. Do not use crippled
-words like "dont" and use "do not" or "don't" instead.
+words like "dont"; use "do not" or "don't" instead.  Make the messages
+concise, clear, and unambiguous.
 
 Kernel messages do not have to be terminated with a period.
 
 Printing numbers in parentheses (%d) adds no value and should be avoided.
 
+There are a number of driver model diagnostic macros in <linux/device.h>
+which you should use to make sure messages are matched to the right device
+and driver, and are tagged with the right level:  dev_err(), dev_warn(),
+dev_info(), and so forth.  For messages that aren't associated with a
+particular device, <linux/kernel.h> defines pr_debug() and pr_info().
+
+Coming up with good debugging messages can be quite a challenge; and once
+you have them, they can be a huge help for remote troubleshooting.  Such
+messages should be compiled out when the DEBUG symbol is not defined (that
+is, by default they are not included).  When you use dev_dbg() or pr_debug(),
+that's automatic.  Many subsystems have Kconfig options to turn on -DDEBUG.
+A related convention uses VERBOSE_DEBUG to add dev_vdbg() messages to the
+ones already enabled by DEBUG.
+
 
 		Chapter 14: Allocating memory
 
@@ -790,4 +805,5 @@ Kernel CodingStyle, by greg@kroah.com at
 http://www.kroah.com/linux/talks/ols_2002_kernel_codingstyle_talk/html/
 
 --
-Last updated on 2006-December-06.
+Last updated on 2007-July-13.
+
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
git-avr32.patch
git-mmc.patch
git-mtd.patch
use-mutex-instead-of-semaphore-in-the-usb-gadget-serial-driver.patch
geode-basic-infrastructure-support-for-amd-geode-class.patch
char-genrtc-use-wait_event_interruptible.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
gpio-calls-dont-need-i-o-barriers.patch
dev_vdbg-available-with-dverbose_debug.patch
dev_vdbg-available-with-dverbose_debug-docs.patch
spi-controller-drivers-check-for-unsupported-modes.patch
spi-add-3wire-mode-flag.patch
spidev-compiler-warning-gone.patch
spi_mpc83xxc-underclocking-hotfix.patch
atmel_spi-minor-updates.patch
atmel_spi-dont-always-deselect-chip-between-messages.patch
s3c24xx-spi-controllers-both-select-bitbang.patch
spi-master-driver-for-xilinx-virtex.patch
spi-omap2_mcspi-driver.patch
use-mutex-instead-of-semaphore-in-spi-core-init-code.patch
rtc-ds1307-cleanups.patch
rtc-rs5c372-becomes-a-new-style-i2c-driver.patch
thecus-n2100-register-rtc-rs5c372-i2c-device.patch
rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported.patch
rtc-dev-return-enotty-in-ioctl-if-irq_set_freq-is-not-implemented-by-driver.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-update.patch
rtc-kconfig-tweax.patch
rtc-add-rtc-m41t80-driver-take-2.patch
rtc-watchdog-support-for-rtc-m41t80-driver-take-2.patch
rtc-ds1307-becomes-new-style-i2c-driver.patch
csb337-supports-new-style-rtc-ds1307.patch
omap-add-ti-twl92330-menelaus-power-management-chip-driver.patch
