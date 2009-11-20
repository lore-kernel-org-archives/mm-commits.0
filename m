From: akpm@linux-foundation.org
Subject: [to-be-updated] drivers-char-cycladesc-fix-used-uninitialised-bug.patch removed from -mm tree
Date: Fri, 20 Nov 2009 15:50:13 -0800
Message-ID: <200911202350.nAKNoDiq021164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752476AbZKTXuN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 18:50:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@linux.intel.com, gregkh@suse.de, jirislaby@gmail.com, jslaby@novell.com, linux@linux.site, mm-commits@vger.kernel.org


The patch titled
     drivers/char/cyclades.c: fix used-uninitialised bug
has been removed from the -mm tree.  Its filename was
     drivers-char-cycladesc-fix-used-uninitialised-bug.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/cyclades.c: fix used-uninitialised bug
From: Andrew Morton <akpm@linux-foundation.org>

drivers/char/cyclades.c: In function 'cyy_interrupt':
drivers/char/cyclades.c:581: warning: 'info' may be used uninitialized in this function

a bug introduced by

: commit 3aeea5b92210083c7cffd4f08a0bb141d3f2d574
: Author:     Jiri Slaby <jirislaby@gmail.com>
: AuthorDate: Sat Sep 19 13:13:16 2009 -0700
: Commit:     Live-CD User <linux@linux.site>
: CommitDate: Sat Sep 19 13:13:16 2009 -0700
:
:    cyclades: introduce cyy_readb/writeb

The fix is not really optimal but I think it'll work.

Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/cyclades.c~a drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~a
+++ a/drivers/char/cyclades.c
@@ -597,6 +597,7 @@ static void cyy_chip_tx(struct cyclades_
 	channel = save_xir & CyIRChannel;
 	save_car = readb(base_addr + (CyCAR << index));
 	cy_writeb(base_addr + (CyCAR << index), save_xir);
+	info = &cinfo->ports[channel + chip * 4];
 
 	/* validate the port# (as configured and open) */
 	if (channel + chip * 4 >= cinfo->nports) {
@@ -604,7 +605,6 @@ static void cyy_chip_tx(struct cyclades_
 			  readb(base_addr + (CySRER << index)) & ~CyTxRdy);
 		goto end;
 	}
-	info = &cinfo->ports[channel + chip * 4];
 	tty = tty_port_tty_get(&info->port);
 	if (tty == NULL) {
 		cyy_writeb(info, CySRER, cyy_readb(info, CySRER) & ~CyTxRdy);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-media-dvb-dvb-core-dvb_frontendc-needs-semaphoreh.patch
drivers-char-cycladesc-fix-used-uninitialised-bug.patch
char-cyclades-fix-compiler-warning.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
recordmcount-stfu.patch
include-linux-compiler-gcc4h-gcc-402-doesnt-understand-__builtin_object_size.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
acpi-remove-nid_inval.patch
drivers-acpi-acpi_padc-squish-warning.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
kbuild-generate-modulesbuiltin-fix-2-checkpatch-fixes.patch
drivers-leds-leds-ss4200c-fix-return-statement.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch
st-fix-test-of-value-range-in-st_set_options.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
mm-memory_hotplug-make-offline_pages-static.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-cleanup.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
msm_sdccc-add-missing-include-fix-compilation-checkpatch-fixes.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
spi-controller-driver-for-designware-spi-core-fix.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2-fix-3.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch
zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes-cleanup.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-disable.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

