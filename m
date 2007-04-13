From: akpm@linux-foundation.org
Subject: - doc-gpiotxt-describes-open-drain-emulation.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:28:13 -0700
Message-ID: <200704132328.l3DNSDoi012505@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60316 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030890AbXDMX2T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:28:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     doc: gpio.txt describes open-drain emulation
has been removed from the -mm tree.  Its filename was
     doc-gpiotxt-describes-open-drain-emulation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: doc: gpio.txt describes open-drain emulation
From: David Brownell <david-b@pacbell.net>

Update the GPIO docs to describe the idiom whereby open drain signals are
emulated by toggling the GPIO direction.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/gpio.txt |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff -puN Documentation/gpio.txt~doc-gpiotxt-describes-open-drain-emulation Documentation/gpio.txt
--- a/Documentation/gpio.txt~doc-gpiotxt-describes-open-drain-emulation
+++ a/Documentation/gpio.txt
@@ -27,7 +27,7 @@ The exact capabilities of GPIOs vary bet
   - Output values are writable (high=1, low=0).  Some chips also have
     options about how that value is driven, so that for example only one
     value might be driven ... supporting "wire-OR" and similar schemes
-    for the other value.
+    for the other value (notably, "open drain" signaling).
 
   - Input values are likewise readable (1, 0).  Some chips support readback
     of pins configured as "output", which is very useful in such "wire-OR"
@@ -247,6 +247,35 @@ with gpio_get_value(), for example to in
 when the IRQ is edge-triggered.
 
 
+Emulating Open Drain Signals
+----------------------------
+Sometimes shared signals need to use "open drain" signaling, where only the
+low signal level is actually driven.  (That term applies to CMOS transistors;
+"open collector" is used for TTL.)  A pullup resistor causes the high signal
+level.  This is sometimes called a "wire-AND"; or more practically, from the
+negative logic (low=true) perspective this is a "wire-OR".
+
+One common example of an open drain signal is a shared active-low IRQ line.
+Also, bidirectional data bus signals sometimes use open drain signals.
+
+Some GPIO controllers directly support open drain outputs; many don't.  When
+you need open drain signaling but your hardware doesn't directly support it,
+there's a common idiom you can use to emulate it with any GPIO pin that can
+be used as either an input or an output:
+
+ LOW:	gpio_direction_output(gpio, 0) ... this drives the signal
+	and overrides the pullup.
+
+ HIGH:	gpio_direction_input(gpio) ... this turns off the output,
+	so the pullup (or some other device) controls the signal.
+
+If you are "driving" the signal high but gpio_get_value(gpio) reports a low
+value (after the appropriate rise time passes), you know some other component
+is driving the shared signal low.  That's not necessarily an error.  As one
+common example, that's how I2C clocks are stretched:  a slave that needs a
+slower clock delays the rising edge of SCK, and the I2C master adjusts its
+signaling rate accordingly.
+
 
 What do these conventions omit?
 ===============================
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
make-proc-acpi-wakeup-more-useful.patch
update-documentation-driver-model-platformtxt.patch
at91_cf-minor-fix.patch
scsi-newstyle-hotplug-coldplug-support.patch
usb-gadget-rndis-fix-struct-rndis_packet_msg_type.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
init-dma-masks-in-pnp_dev.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
char-cs5535_gpio-add-module_device_table.patch
parport-dev-driver-model-support.patch
parport-dev-driver-model-support-powerpc-fix.patch
layered-parport-code-uses-parport-dev.patch
pnpacpi-sets-pnpdev-devarchdata.patch
pnpacpi-sets-pnpdev-devarchdata-fix.patch
fix-hotplug-for-legacy-platform-drivers.patch
minor-spi_butterfly-cleanup.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch
rtc-update-to-class-device-removal-patches.patch
rtc-kconfig-cleanup.patch
rtc-cmos-wakeup-interface.patch
acpi-wakeup-hooks-for-rtc-cmos.patch
workaround-rtc-related-acpi-table-bugs.patch
revert-rtc-add-rtc_merge_alarm.patch
remove-rtc_alm_set-mode-bugs.patch
