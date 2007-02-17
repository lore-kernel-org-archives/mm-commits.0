From: akpm@linux-foundation.org
Subject: - gpio-core-documentation.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:13:00 -0800
Message-ID: <200702170713.l1H7D0YU021427@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50703 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946432AbXBQHNJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:13:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     GPIO core documentation
has been removed from the -mm tree.  Its filename was
     gpio-core-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: GPIO core documentation
From: David Brownell <david-b@pacbell.net>

Small updates to the GPIO documentation, addressing feedback and
fixing a few spelling errors.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/gpio.txt |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN Documentation/gpio.txt~gpio-core-documentation Documentation/gpio.txt
--- a/Documentation/gpio.txt~gpio-core-documentation
+++ a/Documentation/gpio.txt
@@ -78,7 +78,8 @@ Identifying GPIOs
 -----------------
 GPIOs are identified by unsigned integers in the range 0..MAX_INT.  That
 reserves "negative" numbers for other purposes like marking signals as
-"not available on this board", or indicating faults.
+"not available on this board", or indicating faults.  Code that doesn't
+touch the underlying hardware treats these integers as opaque cookies.
 
 Platforms define how they use those integers, and usually #define symbols
 for the GPIO lines so that board-specific setup code directly corresponds
@@ -139,10 +140,10 @@ issues including wire-OR and output late
 The get/set calls have no error returns because "invalid GPIO" should have
 been reported earlier in gpio_set_direction().  However, note that not all
 platforms can read the value of output pins; those that can't should always
-return zero.  Also, these calls will be ignored for GPIOs that can't safely
-be accessed wihtout sleeping (see below).
+return zero.  Also, using these calls for GPIOs that can't safely be accessed
+without sleeping (see below) is an error.
 
-Platform-specific implementations are encouraged to optimise the two
+Platform-specific implementations are encouraged to optimize the two
 calls to access the GPIO value in cases where the GPIO number (and for
 output, value) are constant.  It's normal for them to need only a couple
 of instructions in such cases (reading or writing a hardware register),
@@ -239,7 +240,8 @@ options are part of the IRQ interface, e
 system wakeup capabilities.
 
 Non-error values returned from irq_to_gpio() would most commonly be used
-with gpio_get_value().
+with gpio_get_value(), for example to initialize or update driver state
+when the IRQ is edge-triggered.
 
 
 
@@ -260,9 +262,10 @@ pullups (or pulldowns) so that the on-ch
 There are other system-specific mechanisms that are not specified here,
 like the aforementioned options for input de-glitching and wire-OR output.
 Hardware may support reading or writing GPIOs in gangs, but that's usually
-configuration dependednt:  for GPIOs sharing the same bank.  (GPIOs are
+configuration dependent:  for GPIOs sharing the same bank.  (GPIOs are
 commonly grouped in banks of 16 or 32, with a given SOC having several such
-banks.)  Code relying on such mechanisms will necessarily be nonportable.
+banks.)  Some systems can trigger IRQs from output GPIOs.  Code relying on
+such mechanisms will necessarily be nonportable.
 
 Dynamic definition of GPIOs is not currently supported; for example, as
 a side effect of configuring an add-on board with some GPIO expanders.
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
git-acpi.patch
git-avr32.patch
git-md-accel.patch
8250-make-probing-for-txen-bug-a-config-option.patch
loosen-dependancy-on-rtc-cmos.patch
rtc-sa1100-rtc_wklarmenabled-bugfixes.patch
at91_rtc-updates.patch
remove-modpost-false-warnings-on-arm.patch
spi-controller-build-warning-fixes.patch
