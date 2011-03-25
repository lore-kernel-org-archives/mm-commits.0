From: akpm@linux-foundation.org
Subject: [merged] rapidio-fix-potential-null-deref-on-failure-path.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:26:20 -0700
Message-ID: <201103250726.p2P7QEW5026122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933849Ab1CYH0Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:26:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, @vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     rapidio: fix potential null deref on failure path
has been removed from the -mm tree.  Its filename was
     rapidio-fix-potential-null-deref-on-failure-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: fix potential null deref on failure path
From: Dan Carpenter <[error27@gmail.com]>

If rio is not a switch then "rswitch" is null.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rapidio/rio-scan.c~rapidio-fix-potential-null-deref-on-failure-path drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-fix-potential-null-deref-on-failure-path
+++ a/drivers/rapidio/rio-scan.c
@@ -517,7 +517,7 @@ static struct rio_dev __devinit *rio_set
 	return rdev;
 
 cleanup:
-	if (rswitch->route_table)
+	if (rio_is_switch(rdev))
 		kfree(rswitch->route_table);
 
 	kfree(rdev);
_

Patches currently in -mm which might be from [error27@gmail.com] are

origin.patch
memstick-add-driver-for-ricoh-r5c592-card-reader.patch
codafs-fix-build-break-when-config_proc_sysctl=n.patch
ipcns-fix-use-after-free-in-free_ipc_ns.patch
backlight-new-driver-for-the-adp8870-backlight-devices.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
include-asm-generic-vmlinuxldsh-fix-__modver-section-warnings.patch
acerhdf-add-support-for-aspire-1410-bios-v13314.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
x86-fix-mmap-random-address-range.patch
msm-timer-migrate-to-timer-based-__delay.patch
arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch
audit-always-follow-va_copy-with-va_end.patch
fs-btrfs-inodec-eliminate-memory-leak.patch
btrfs-dont-dereference-extent_mapping-if-null.patch
drivers-dma-ipu-ipu_irqc-irq_data-conversion.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
fb-fix-potential-deadlock-between-lock_fb_info-and-console_lock.patch
cyber2000fb-avoid-palette-corruption-at-higher-clocks.patch
llist-irq_work-use-llist-in-irq_work.patch
drivers-leds-leds-pca9532c-add-gpio-capability.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
net-convert-%p-usage-to-%pk.patch
llist-net-rds-replace-xlist-in-net-rds-xlisth-with-llist.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
i915-add-native-backlight-control.patch
btusb-patch-add_apple_macbookpro62.patch
drivers-message-fusion-mptsasc-fix-warning.patch
scsi-fix-a-header-to-include-linux-typesh.patch
aic94xx-world-writable-sysfs-update_bios-file.patch
drbd-fix-warning.patch
usb-yurex-recognize-generalkeys-wireless-presenter-as-generic-hid.patch
mm.patch
mm-remove-unused-token-argument-from-apply_to_page_range-callback.patch
mm-add-apply_to_page_range_batch.patch
ioremap-use-apply_to_page_range_batch-for-ioremap_page_range.patch
vmalloc-use-plain-pte_clear-for-unmaps.patch
vmalloc-use-apply_to_page_range_batch-for-vunmap_page_range.patch
vmalloc-use-apply_to_page_range_batch-for-vmap_page_range_noflush.patch
vmalloc-use-apply_to_page_range_batch-in-alloc_vm_area.patch
xen-mmu-use-apply_to_page_range_batch-in-xen_remap_domain_mfn_range.patch
xen-grant-table-use-apply_to_page_range_batch.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix-fix.patch
mm-add-vm-counters-for-transparent-hugepages.patch
mm-add-vm-counters-for-transparent-hugepages-checkpatch-fixes.patch
memsw-remove-noswapaccount-kernel-parameter.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
xattrh-expose-string-defines-to-userspace.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
rtc-driver-for-pt7c4338-chip.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
gpio-add-new-altera-pio-driver.patch
gpio-add-new-altera-pio-driver-update.patch
gpio-make-gpio_requestfree_array-gpio-array-parameter-const.patch
jbd-remove-dependency-on-__gfp_nofail.patch
cgroup-remove-the-ns_cgroup.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch
sysctl-add-proc_dointvec_bool-handler.patch
sysctl-use-proc_dointvec_bool-where-appropriate.patch
sysctl-add-proc_dointvec_unsigned-handler.patch
sysctl-use-proc_dointvec_unsigned-where-appropriate.patch
fs-execc-provide-the-correct-process-pid-to-the-pipe-helper.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks.patch
memstick-add-support-for-legacy-memorysticks-update-2.patch
kexec-remove-kmsg_dump_kexec.patch
make-sure-nobodys-leaking-resources.patch
journal_add_journal_head-debug.patch
releasing-resources-with-children.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
add-debugging-aid-for-memory-initialisation-problems.patch
workaround-for-a-pci-restoring-bug.patch
prio_tree-debugging-patch.patch
single_open-seq_release-leak-diagnostics.patch
add-a-refcount-check-in-dput.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

