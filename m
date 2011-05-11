From: akpm@linux-foundation.org
Subject: [folded] leds-provide-helper-to-register-leds-gpio-devices-fix.patch removed from -mm tree
Date: Wed, 11 May 2011 00:13:43 -0700
Message-ID: <201105110706.p4B76Uei017734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752988Ab1EKPi3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 May 2011 11:38:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fabio.estevam@freescale.com, hartleys@visionengravers.com, richard.purdie@linuxfoundation.org, rmk@arm.linux.org.uk, s.hauer@pengutronix.de, u.kleine-koenig


The patch titled
     leds-provide-helper-to-register-leds-gpio-devices-fix
has been removed from the -mm tree.  Its filename was
     leds-provide-helper-to-register-leds-gpio-devices-fix.patch

This patch was dropped because it was folded into leds-provide-helper-t=
o-register-leds-gpio-devices.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: leds-provide-helper-to-register-leds-gpio-devices-fix
=46rom: Andrew Morton <akpm@linux-foundation.org>

s/CONFIG_LED_REGISTER_GPIO/CONFIG_LEDS_REGISTER_GPIO/

Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Richard Purdie <richard.purdie@linuxfoundation.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Uwe Kleine-K=F6nig  <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig        |    2 +-
 drivers/leds/led-register.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/leds/Kconfig~leds-provide-helper-to-register-leds-gpi=
o-devices-fix drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-provide-helper-to-register-leds-gpio-de=
vices-fix
+++ a/drivers/leds/Kconfig
@@ -14,7 +14,7 @@ config LEDS_CLASS
 	  This option enables the led sysfs class in /sys/class/leds.  You'll
 	  need this to do anything useful with LEDs.  If unsure, say N.
=20
-config LED_REGISTER_GPIO
+config LEDS_REGISTER_GPIO
 	bool
 	help
 	  This option provides the function gpio_led_register_device.
diff -puN drivers/leds/led-register.c~leds-provide-helper-to-register-l=
eds-gpio-devices-fix drivers/leds/led-register.c
--- a/drivers/leds/led-register.c~leds-provide-helper-to-register-leds-=
gpio-devices-fix
+++ a/drivers/leds/led-register.c
@@ -11,7 +11,7 @@
 #include <linux/slab.h>
 #include <linux/leds.h>
=20
-#if defined(CONFIG_LED_REGISTER_GPIO)
+#if defined(CONFIG_LEDS_REGISTER_GPIO)
 struct platform_device *__init gpio_led_register_device(
 		int id, const struct gpio_led_platform_data *pdata)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

mm-use-alloc_bootmem_node_nopanic-on-really-needed-path-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-i2c-busses-i2c-designware-corec-needs-delayh.patch
mm-add-alloc_pages_exact_nid-checkpatch-fixes.patch
mm-add-alloc_pages_exact_nid-fix.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-provide-helper-to-register-leds-gpio-devices.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value-f=
ix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
osst-wrong-index-used-in-inner-loop-checkpatch-fixes.patch
drivers-scsi-osstc-fix-warning.patch
drbd-fix-warning.patch
drivers-usb-misc-usbtestc-fix-warning.patch
slab-use-numa_no_node.patch
mm.patch
mm-nommu-sort-mm-mmap-list-properly-fix.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur-fix.=
patch
mm-mmu_gather-rework-fix.patch
mm-uninline-large-generic-tlbh-functions.patch
mm-thp-optimize-memcg-charge-in-khugepaged-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-checkpatch-fixes.patch
writeback-sync-expired-inodes-first-in-background-writeback-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix.=
patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-=
fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patc=
h
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.pa=
tch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
nommu-add-page-alignment-to-mmap-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
cris-convert-old-cpumask-api-into-new-one-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-fail=
ure-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-fail=
ure-fix.patch
printk-allocate-kernel-log-buffer-earlier-v2-checkpatch-fixes.patch
printk-allocate-kernel-log-buffer-earlier-v2-fix.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
percpu_counter-change-return-value-and-add-comments-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-f=
ix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch-fix.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-add-stats-to-monitor-soft_limit-reclaim-v2-fix.patch
memcg-add-stats-to-monitor-soft_limit-reclaim-v2-fix-2.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-ini=
tialize-spread-rotor-lazily-fix.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oop=
s-fix.patch
kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
