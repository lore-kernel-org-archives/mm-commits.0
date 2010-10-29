From: akpm@linux-foundation.org
Subject: + drivers-misc-bh1770glcc-error-handling-in-bh1770_power_state_store-fix.patch added to -mm tree
Date: Fri, 29 Oct 2010 16:08:25 -0700
Message-ID: <201010292308.o9TN8Po6022203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801Ab0J2XJF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Oct 2010 19:09:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, error27@gmail.com, jic23@cam.ac.uk, samu.p.onkalo@nokia.com


The patch titled
     drivers-misc-bh1770glcc-error-handling-in-bh1770_power_state_store-fix
has been added to the -mm tree.  Its filename is
     drivers-misc-bh1770glcc-error-handling-in-bh1770_power_state_store-fix.patch

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
Subject: drivers-misc-bh1770glcc-error-handling-in-bh1770_power_state_store-fix
From: Andrew Morton <akpm@linux-foundation.org>

Fix the |= 

Cc: Dan Carpenter <error27@gmail.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Samu Onkalo <samu.p.onkalo@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/bh1770glc.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN drivers/misc/bh1770glc.c~drivers-misc-bh1770glcc-error-handling-in-bh1770_power_state_store-fix drivers/misc/bh1770glc.c
--- a/drivers/misc/bh1770glc.c~drivers-misc-bh1770glcc-error-handling-in-bh1770_power_state_store-fix
+++ a/drivers/misc/bh1770glc.c
@@ -656,16 +656,22 @@ static ssize_t bh1770_power_state_store(
 
 	mutex_lock(&chip->mutex);
 	if (value) {
+		int lux_rate;
+		int lux_interrupt_control;
+
 		pm_runtime_get_sync(dev);
 
-		ret = bh1770_lux_rate(chip, chip->lux_rate_index);
-		if (ret < 0) {
+		lux_rate = bh1770_lux_rate(chip, chip->lux_rate_index);
+		if (lux_rate < 0) {
+			ret = lux_rate;
 			pm_runtime_put(dev);
 			goto leave;
 		}
 
-		ret = bh1770_lux_interrupt_control(chip, BH1770_ENABLE);
-		if (ret < 0) {
+		lux_interrupt_control =
+			bh1770_lux_interrupt_control(chip, BH1770_ENABLE);
+		if (lux_interrupt_control < 0) {
+			ret = lux_interrupt_control;
 			pm_runtime_put(dev);
 			goto leave;
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hpet-factor-timer-allocate-from-open.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-misc-isl29020c-dont-ignore-the-i2c_smbus_read_byte_data-return-value.patch
drivers-misc-bh1770glcc-error-handling-in-bh1770_power_state_store-fix.patch
mm-vmap-area-cache.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-add-led-trigger-for-input-subsystem-led-events.patch
backlight-add-low-threshold-to-pwm-backlight.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

