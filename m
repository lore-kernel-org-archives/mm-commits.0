From: akpm@linux-foundation.org
Subject: - kerneldoc-for-linux-clkh.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:50:20 -0700
Message-ID: <200804282150.m3SLoKxU017465@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934603AbYD1Vuk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:50:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, rdunlap@xenotime.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     kerneldoc for <linux/clk.h>
has been removed from the -mm tree.  Its filename was
     kerneldoc-for-linux-clkh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 Documentation/DocBook/kernel-api.tmpl |   54 ++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff -puN Documentation/DocBook/kernel-api.tmpl~kerneldoc-for-linux-clkh Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~kerneldoc-for-linux-clkh
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -645,4 +645,58 @@ X!Idrivers/video/console/fonts.c
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
+	On some systems this may be backed by hardware clock gating,
+	where clocks are gated without being disabled in software.
+	Sections of chips that are powered but not clocked may be able
+	to retain their last state.
+	This low power state is often called a <emphasis>retention
+	mode</emphasis>.
+	This mode still incurs leakage currents, especially with finer
+	circuit geometries, but for CMOS circuits power is mostly used
+	by clocked state changes.
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
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
git-acpi.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
git-mmc.patch
jffs2-summary-allocation-dont-use-vmalloc.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
remove-duplicated-unlikely-in-is_err.patch

