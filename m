From: akpm@linux-foundation.org
Subject: [folded] rtc-driver-for-pt7c4338-chip-fix.patch removed from -mm tree
Date: Fri, 03 Jun 2011 16:44:08 -0700
Message-ID: <201106032344.p53Ni8qx015149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756511Ab1FCXoj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2011 19:44:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Priyanka.Jain@freescale.com, a.zummo@towertech.it, benh@kernel.crashing.org, galak@gate.crashing.org, mm-commits@vger.kernel.org


The patch titled
     rtc-driver-for-pt7c4338-chip-fix
has been removed from the -mm tree.  Its filename was
     rtc-driver-for-pt7c4338-chip-fix.patch

This patch was dropped because it was folded into rtc-driver-for-pt7c4338-chip.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-driver-for-pt7c4338-chip-fix
From: Andrew Morton <akpm@linux-foundation.org>

include slab.h, remove unused local

drivers/rtc/rtc-pt7c4338.c: In function 'pt7c4338_probe':
drivers/rtc/rtc-pt7c4338.c:159: error: implicit declaration of function 'kzalloc'
drivers/rtc/rtc-pt7c4338.c:159: warning: assignment makes pointer from integer without a cast
drivers/rtc/rtc-pt7c4338.c:176: error: implicit declaration of function 'kfree'
drivers/rtc/rtc-pt7c4338.c:156: warning: unused variable 'adapter'

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Priyanka Jain <Priyanka.Jain@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pt7c4338.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-pt7c4338.c~rtc-driver-for-pt7c4338-chip-fix drivers/rtc/rtc-pt7c4338.c
--- a/drivers/rtc/rtc-pt7c4338.c~rtc-driver-for-pt7c4338-chip-fix
+++ a/drivers/rtc/rtc-pt7c4338.c
@@ -35,6 +35,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/rtc.h>
@@ -153,7 +154,6 @@ static int pt7c4338_probe(struct i2c_cli
 		const struct i2c_device_id *id)
 {
 	struct pt7c4338 *pt7c4338;
-	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
 	int ret;
 
 	pt7c4338 = kzalloc(sizeof(struct pt7c4338), GFP_KERNEL);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
backlight-add-backlight-type-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix-checkpatch-fixes.patch
memcg-add-documentation-for-the-memorynumastat-api-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
drivers-base-platformc-dont-mark-platform_device_register_resndata-as-__init_or_module.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
slab-use-numa_no_node.patch
mm.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
writeback-sync-expired-inodes-first-in-background-writeback.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-calibratec-calibrate_delay-tidy-up-the-pr_info-messages.patch
rtc-driver-for-pt7c4338-chip.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

