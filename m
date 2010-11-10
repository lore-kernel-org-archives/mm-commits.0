From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-isl29020c-dont-ignore-the-i2c_smbus_read_byte_data-return-value.patch removed from -mm tree
Date: Wed, 10 Nov 2010 12:13:12 -0800
Message-ID: <201011102015.oAAKFZ3C003525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756216Ab0KJUPi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Nov 2010 15:15:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@linux.intel.com, arjan@linux.intel.com, hong.liu@intel.com, kalhan.trisal@intel.com, segooon@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/misc/isl29020.c: don't ignore the i2c_smbus_read_byte_data() return value
has been removed from the -mm tree.  Its filename was
     drivers-misc-isl29020c-dont-ignore-the-i2c_smbus_read_byte_data-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc/isl29020.c: don't ignore the i2c_smbus_read_byte_data() return value
From: Andrew Morton <akpm@linux-foundation.org>

If i2c_smbus_read_byte_data() fails, this driver will write a mangled
errno value into the hardware.

Cc: Vasiliy Kulikov <segooon@gmail.com>
Cc: Liu Hong <hong.liu@intel.com>
Cc: Kalhan Trisal <kalhan.trisal@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/isl29020.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/misc/isl29020.c~drivers-misc-isl29020c-dont-ignore-the-i2c_smbus_read_byte_data-return-value drivers/misc/isl29020.c
--- a/drivers/misc/isl29020.c~drivers-misc-isl29020c-dont-ignore-the-i2c_smbus_read_byte_data-return-value
+++ a/drivers/misc/isl29020.c
@@ -106,8 +106,10 @@ static ssize_t als_sensing_range_store(s
 		val = 4;
 
 	ret_val = i2c_smbus_read_byte_data(client, 0x00);
+	if (ret_val < 0)
+		return ret_val;
 
-	ret_val &= 0xFC; /*reset the bit before setting them */
+	ret_val &= 0xFC; /* reset the bit before setting them */
 	ret_val |= val - 1;
 	ret_val = i2c_smbus_write_byte_data(client, 0x00, ret_val);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hpet-factor-timer-allocate-from-open.patch
atomic-add-atomic_inc_not_zero_hint-checkpatch-fixes.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-misc-bh1770glcc-error-handling-in-bh1770_power_state_store.patch
mm-vmap-area-cache.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
irq-use-per_cpu-kstat_irqs-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-add-led-trigger-for-input-subsystem-led-events.patch
backlight-add-low-threshold-to-pwm-backlight.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
sync_inode_metadata-fix-comment.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-make-throttle_vm_writeout-memcg-aware-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

