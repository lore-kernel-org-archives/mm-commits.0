From: akpm@linux-foundation.org
Subject: [merged] drivers-gpio-ml_ioh_gpioc-needs-slabh.patch removed from -mm tree
Date: Wed, 25 May 2011 13:32:36 -0700
Message-ID: <201105252030.p4PKUxf6015018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754679Ab1EYUnh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:43:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, grant.likely@secretlab.ca, mm-commits@vger.kernel.org


The patch titled
     drivers/gpio/ml_ioh_gpio.c needs slab.h
has been removed from the -mm tree.  Its filename was
     drivers-gpio-ml_ioh_gpioc-needs-slabh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/gpio/ml_ioh_gpio.c needs slab.h
From: Andrew Morton <akpm@linux-foundation.org>

alpha allmodconfig:

drivers/gpio/ml_ioh_gpio.c: In function 'ioh_gpio_probe':
drivers/gpio/ml_ioh_gpio.c:205: error: implicit declaration of function 'kzalloc'
drivers/gpio/ml_ioh_gpio.c:205: warning: assignment makes pointer from integer without a cast

also fix this:

drivers/gpio/ml_ioh_gpio.c:145: warning: 'ioh_gpio_save_reg_conf' defined but not used
drivers/gpio/ml_ioh_gpio.c:154: warning: 'ioh_gpio_restore_reg_conf' defined but not used

Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/ml_ioh_gpio.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/gpio/ml_ioh_gpio.c~drivers-gpio-ml_ioh_gpioc-needs-slabh drivers/gpio/ml_ioh_gpio.c
--- a/drivers/gpio/ml_ioh_gpio.c~drivers-gpio-ml_ioh_gpioc-needs-slabh
+++ a/drivers/gpio/ml_ioh_gpio.c
@@ -15,6 +15,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.
  */
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/pci.h>
 #include <linux/gpio.h>
 
@@ -138,6 +139,7 @@ static int ioh_gpio_direction_input(stru
 	return 0;
 }
 
+#ifdef CONFIG_PM
 /*
  * Save register configuration and disable interrupts.
  */
@@ -157,6 +159,7 @@ static void ioh_gpio_restore_reg_conf(st
 	/* to store contents of PM register */
 	iowrite32(chip->ioh_gpio_reg.pm_reg, &chip->reg->regs[chip->ch].pm);
 }
+#endif
 
 static void ioh_gpio_setup(struct ioh_gpio *chip, int num_port)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
backlight-add-backlight-type-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
revert-m68k-merge-mmu-and-non-mmu-bitopsh.patch
drivers-base-platformc-dont-mark-platform_device_register_resndata-as-__init_or_module.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
mtd-convert-to-seq_file-interface.patch
rfcomm-corec-avoid-dangling-pointer-check-session-exists-checkpatch-fixes.patch
drivers-bcma-host_pcic-needs-slabh.patch
slab-use-numa_no_node.patch
mm.patch
writeback-sync-expired-inodes-first-in-background-writeback-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch-fix.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
documentation-configfs-examples-crash-fix-checkpatch-fixes.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
add-the-pagefault-count-into-memcg-stats.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch
kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

