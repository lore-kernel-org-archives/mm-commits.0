From: akpm@linux-foundation.org
Subject: + kerneldoc-for-linux-clkh.patch added to -mm tree
Date: Mon, 10 Mar 2008 21:19:03 -0700
Message-ID: <200803110419.m2B4J3kX021766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751519AbYCKET6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Mar 2008 00:19:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, rdunlap@xenotime.net, rmk@arm.linux.org.uk


The patch titled
     kerneldoc for <linux/clk.h>
has been added to the -mm tree.  Its filename is
     kerneldoc-for-linux-clkh.patch

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
Subject: kerneldoc for <linux/clk.h>
From: David Brownell <david-b@pacbell.net>

Add <linux/clk.h> to the generated kerneldoc, with some overview
to go along with those per-function descriptions.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-api.tmpl |   55 ++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff -puN Documentation/DocBook/kernel-api.tmpl~kerneldoc-for-linux-clkh Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~kerneldoc-for-linux-clkh
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -650,4 +650,59 @@ X!Idrivers/video/console/fonts.c
 !Edrivers/i2c/i2c-core.c
   </chapter>
 
+  <chapter id="clk">
+     <title>Clock Framework</title>
+
+     <para>
+	The clock framework defines programming interfaces to support
+	software management of the system clock tree.
+	This framework is widely used with System-On-Chip (SOC) platforms
+	to support power management and various devices which may need
+	custom clock rates.
+	Note that these "clocks" don't relate to timekeeping or real
+	time clocks (RTCs), each of which have separate frameworks.
+	These <structname>struct clk</structname> instances may be used
+	to manage for example a 96 MHz signal that is used to shift bits
+	into and out of peripherals or busses, or otherwise trigger
+	synchronous state machine transitions in system hardware.
+     </para>
+
+     <para>
+	Power management is supported by explicit software clock gating:
+	unused clocks are disabled, so the system doesn't waste power
+	changing the state of transistors that aren't in active use.
+	On some systems this may be backed by hardware clock gating.
+	Circuits will still have leakage current to be managed, which
+	costs more with finer cicuit geometries, but for CMOS circuits
+	power is mostly spent by clocked state changes.
+	Sections of chips that are powered but not clocked may be able
+	to retain their last state.
+	This low power state is often called a <emphasis>retention
+	mode</emphasis>, in contrast to <emphasis>off</emphasis> where
+	power is cut and no state is retained but where leakage currents
+	may have a significant impact on battery life.
+     </para>
+
+     <para>
+	Power-aware drivers only enable their clocks when the device
+	they manage is in active use.  Also, system sleep states often
+	differ according to which clock domains are active:  while a
+	"standby" state may allow wakeup from several active domains, a
+	"mem" (suspend-to-RAM) state may require a more wholesale shutdown
+	of clocks derived from higher speed PLLs and oscillators, limiting
+	the number of possible wakeup event sources.  A driver's suspend
+	method may need to be aware of system-specific clock constraints
+	on the target sleep state.
+     </para>
+
+     <para>
+        Some platforms support programmable clock generators.  These
+	can be used by external chips of various kinds, such as other
+	CPUs, multimedia codecs, and devices with strict requirements
+	for interface clocking.
+     </para>
+
+!Iinclude/linux/clk.h
+  </chapter>
+
 </book>
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
git-acpi.patch
git-arm-master.patch
git-avr32.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
usb-net-asix-does-not-really-need-10-100mbit.patch
spi-pxa2xx_spi-sparse-fixes.patch
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
rtc-replace-remaining-__function__-occurrences.patch
remove-duplicated-unlikely-in-is_err.patch

