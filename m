From: akpm@linux-foundation.org
Subject: [folded] lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 15 Dec 2009 15:54:09 -0800
Message-ID: <200912152354.nBFNs9ZJ021836@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934011AbZLOXzT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 18:55:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, albin.tonnerre@free-electrons.com, hpa@zytor.com, mingo@elte.hu, ralf@linux-mips.org, rmk@arm.linux.org.uk, tglx@linutronix.de, wuzhangjin@gmail.com, mm-com


The patch titled
     lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes.patch

This patch was dropped because it was folded into lib-add-support-for-lzo-compressed-kernels.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: that open brace { should be on the previous line
#184: FILE: lib/decompress_unlzo.c:48:
+static const unsigned char lzop_magic[] =
+	{ 0x89, 0x4c, 0x5a, 0x4f, 0x00, 0x0d, 0x0a, 0x1a, 0x0a };

WARNING: line over 80 characters
#254: FILE: lib/decompress_unlzo.c:118:
+		error("Both input pointer and fill function provided, don't know what to do");

WARNING: line over 80 characters
#259: FILE: lib/decompress_unlzo.c:123:
+		error("NULL input pointer and missing position pointer or fill function");

WARNING: line over 80 characters
#313: FILE: lib/decompress_unlzo.c:177:
+		r = lzo1x_decompress_safe((u8 *) in_buf, src_len, out_buf, &tmp);

total: 1 errors, 3 warnings, 291 lines checked

./patches/lib-add-support-for-lzo-compressed-kernels.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unlzo.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN lib/decompress_unlzo.c~lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes lib/decompress_unlzo.c
--- a/lib/decompress_unlzo.c~lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes
+++ a/lib/decompress_unlzo.c
@@ -44,8 +44,8 @@
 #include <linux/compiler.h>
 #include <asm/unaligned.h>
 
-static const unsigned char lzop_magic[] =
-	{ 0x89, 0x4c, 0x5a, 0x4f, 0x00, 0x0d, 0x0a, 0x1a, 0x0a };
+static const unsigned char lzop_magic[] = {
+	0x89, 0x4c, 0x5a, 0x4f, 0x00, 0x0d, 0x0a, 0x1a, 0x0a };
 
 #define LZO_BLOCK_SIZE        (256*1024l)
 #define HEADER_HAS_FILTER      0x00000800L
@@ -174,7 +174,8 @@ STATIC inline int INIT unlzo(u8 *input, 
 
 		/* decompress */
 		tmp = dst_len;
-		r = lzo1x_decompress_safe((u8 *) in_buf, src_len, out_buf, &tmp);
+		r = lzo1x_decompress_safe((u8 *) in_buf, src_len,
+						out_buf, &tmp);
 
 		if (r != LZO_E_OK || dst_len != tmp) {
 			error("Compressed data violation");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2-fix-3.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit-cleanup.patch
ipc-remove-unreachable-code-in-semc-fix.patch
fs-cache-avoid-maybe-used-uninitialised-warning-on-variable.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
acpi-remove-nid_inval.patch
drivers-acpi-acpi_padc-squish-warning.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
drivers-leds-leds-ss4200c-fix-return-statement.patch
net-sctp-socketc-fix-warning.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
fs-ext4-superc-fix-printk-warning.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch
scsi-aacraid-fix-memory-leak-checkpatch-fixes.patch
aoe-switch-to-the-new-bio_flush_dcache_pages-interface.patch
fs-improve-remountro-vs-buffercache-coherency.patch
drivers-net-wireless-iwlwifi-iwl-txc-fix-gcc-345-warning.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
readahead-add-blk_run_backing_dev.patch
ksm-memory-hotremove-migration-only-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
spi-controller-driver-for-designware-spi-core.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array.patch
char-cyclades-fix-compiler-warning.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-media-video-cx23885-needs-kfifo-updates.patch
revert-tty-sdio_uart-use-kfifo-instead-of-the-messy-circ-stuff.patch
kfifo-move-struct-kfifo-in-place-fix.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch
lib-add-support-for-lzo-compressed-kernels.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes-cleanup.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

