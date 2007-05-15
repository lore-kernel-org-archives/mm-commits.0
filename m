From: akpm@linux-foundation.org
Subject: + gpio-interface-loosens-call-restrictions.patch added to -mm tree
Date: Mon, 14 May 2007 22:56:51 -0700
Message-ID: <200705150556.l4F5up7T002706@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756224AbXEOF5w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 01:57:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     gpio interface loosens call restrictions
has been added to the -mm tree.  Its filename is
     gpio-interface-loosens-call-restrictions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: gpio interface loosens call restrictions
From: David Brownell <david-b@pacbell.net>

Loosen gpio_{request,free}() and gpio_direction_{in,out}put() call context
restrictions slightly, so a common idiom is no longer an error: board init
code setting up spinlock-safe GPIOs before tasking is enabled.

The issue was caught by some paranoid code with might_sleep() checks.  The
legacy platform-specific GPIO interfaces stick to spinlock-safe GPIOs, so this
change reflects current implementations and won't break anything.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/gpio.txt |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN Documentation/gpio.txt~gpio-interface-loosens-call-restrictions Documentation/gpio.txt
--- a/Documentation/gpio.txt~gpio-interface-loosens-call-restrictions
+++ a/Documentation/gpio.txt
@@ -111,7 +111,9 @@ setting up a platform_device using the G
 
 The return value is zero for success, else a negative errno.  It should
 be checked, since the get/set calls don't have error returns and since
-misconfiguration is possible.  (These calls could sleep.)
+misconfiguration is possible.  You should normally issue these calls from
+a task context.  However, for spinlock-safe GPIOs it's OK to use them
+before tasking is enabled, as part of early board setup.
 
 For output GPIOs, the value provided becomes the initial output value.
 This helps avoid signal glitching during system startup.
@@ -197,7 +199,9 @@ However, many platforms don't currently 
 
 Passing invalid GPIO numbers to gpio_request() will fail, as will requesting
 GPIOs that have already been claimed with that call.  The return value of
-gpio_request() must be checked.  (These calls could sleep.)
+gpio_request() must be checked.  You should normally issue these calls from
+a task context.  However, for spinlock-safe GPIOs it's OK to request GPIOs
+before tasking is enabled, as part of early board setup.
 
 These calls serve two basic purposes.  One is marking the signals which
 are actually in use as GPIOs, for better diagnostics; systems may have
_

Patches currently in -mm which might be from david-b@pacbell.net are

acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
git-leds.patch
at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
rtc-ds1307-cleanups.patch
gpio-interface-loosens-call-restrictions.patch
rtc-omap-build-fix.patch
rtc-kconfig-clarification.patch
use-menuconfig-objects-ii-rtc.patch
