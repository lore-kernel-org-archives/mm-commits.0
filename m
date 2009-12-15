From: akpm@linux-foundation.org
Subject: [folded] zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 15 Dec 2009 14:55:13 -0800
Message-ID: <200912152255.nBFMtDk9018760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754507AbZLOWzu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:55:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Joakim.Tjernlund@transmode.se, mm-commits@vger.kernel.org


The patch titled
     zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes.patch

This patch was dropped because it was folded into zlib-optimize-inffast-when-copying-direct-from-output.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#90: FILE: lib/zlib_inflate/inffast.c:250:
+                    /* minimum length is three */$

ERROR: space prohibited before that close parenthesis ')'
#97: FILE: lib/zlib_inflate/inffast.c:257:
+		    if (dist > 2 ) {

WARNING: suspect code indent for conditional statements (24, 28)
#111: FILE: lib/zlib_inflate/inffast.c:271:
+			if (dist == 1)
[...]
+			    pat16 = (pat16 & 0xff) | ((pat16 & 0xff ) << 8);

ERROR: space prohibited before that close parenthesis ')'
#113: FILE: lib/zlib_inflate/inffast.c:273:
+			    pat16 = (pat16 & 0xff) | ((pat16 & 0xff ) << 8);

ERROR: space prohibited before that close parenthesis ')'
#115: FILE: lib/zlib_inflate/inffast.c:275:
+			    pat16 = (pat16 & 0xff00) | ((pat16 & 0xff00 ) >> 8);

total: 4 errors, 1 warnings, 93 lines checked

./patches/zlib-optimize-inffast-when-copying-direct-from-output.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/zlib_inflate/inffast.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN lib/zlib_inflate/inffast.c~zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes lib/zlib_inflate/inffast.c
--- a/lib/zlib_inflate/inffast.c~zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes
+++ a/lib/zlib_inflate/inffast.c
@@ -247,14 +247,14 @@ void inflate_fast(z_streamp strm, unsign
 		    unsigned long loops;
 
                     from = out - dist;          /* copy direct from output */
-                    /* minimum length is three */
+		    /* minimum length is three */
 		    /* Align out addr */
 		    if (!((long)(out - 1 + OFF) & 1)) {
 			PUP(out) = PUP(from);
 			len--;
 		    }
 		    sout = (unsigned short *)(out - OFF);
-		    if (dist > 2 ) {
+		    if (dist > 2) {
 			unsigned short *sfrom;
 
 			sfrom = (unsigned short *)(from - OFF);
@@ -270,9 +270,9 @@ void inflate_fast(z_streamp strm, unsign
 			pat16 = *(sout-2+2*OFF);
 			if (dist == 1)
 #if defined(__BIG_ENDIAN)
-			    pat16 = (pat16 & 0xff) | ((pat16 & 0xff ) << 8);
+			    pat16 = (pat16 & 0xff) | ((pat16 & 0xff) << 8);
 #elif defined(__LITTLE_ENDIAN)
-			    pat16 = (pat16 & 0xff00) | ((pat16 & 0xff00 ) >> 8);
+			    pat16 = (pat16 & 0xff00) | ((pat16 & 0xff00) >> 8);
 #else
 #error __BIG_ENDIAN nor __LITTLE_ENDIAN is defined
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
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
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2-fix-3.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit-cleanup.patch
ipc-remove-unreachable-code-in-semc-fix.patch
char-cyclades-fix-compiler-warning.patch
fs-cache-avoid-maybe-used-uninitialised-warning-on-variable.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-media-video-cx23885-needs-kfifo-updates.patch
revert-tty-sdio_uart-use-kfifo-instead-of-the-messy-circ-stuff.patch
kfifo-move-struct-kfifo-in-place-fix.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch
zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes.patch
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

