From: akpm@linux-foundation.org
Subject: [merged] drivers-tty-vt-vt_ioctlc-repair-insane-expression.patch removed from -mm tree
Date: Wed, 20 Apr 2011 13:54:40 -0700
Message-ID: <201104202050.p3KKoXfC026107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752984Ab1DTUui (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Apr 2011 16:50:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, art@ified.ca, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     drivers/tty/vt/vt_ioctl.c: repair insane ?: expression
has been removed from the -mm tree.  Its filename was
     drivers-tty-vt-vt_ioctlc-repair-insane-expression.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/tty/vt/vt_ioctl.c: repair insane ?: expression
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Arthur Taylor <art@ified.ca>
Cc: Greg KH <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/vt/vt_ioctl.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff -puN drivers/tty/vt/vt_ioctl.c~drivers-tty-vt-vt_ioctlc-repair-insane-expression drivers/tty/vt/vt_ioctl.c
--- a/drivers/tty/vt/vt_ioctl.c~drivers-tty-vt-vt_ioctlc-repair-insane-expression
+++ a/drivers/tty/vt/vt_ioctl.c
@@ -698,11 +698,23 @@ int vt_ioctl(struct tty_struct *tty,
 		break;
 
 	case KDGKBMODE:
-		uival = ((kbd->kbdmode == VC_RAW) ? K_RAW :
-				 (kbd->kbdmode == VC_MEDIUMRAW) ? K_MEDIUMRAW :
-				 (kbd->kbdmode == VC_UNICODE) ? K_UNICODE :
-				 (kbd->kbdmode == VC_OFF) ? K_OFF :
-				 K_XLATE);
+		switch (kbd->kbdmode) {
+		case VC_RAW:
+			uival = K_RAW;
+			break;
+		case VC_MEDIUMRAW:
+			uival = K_MEDIUMRAW;
+			break;
+		case VC_UNICODE:
+			uival = K_UNICODE;
+			break;
+		case VC_OFF:
+			uival = K_OFF;
+			break;
+		default:
+			uival = K_XLATE;
+			break;
+		}
 		goto setint;
 
 	/* this could be folded into KDSKBMODE, but for compatibility
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
hid-examplec-is-borked.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-i2c-busses-i2c-designware-corec-needs-delayh.patch
vfs-avoid-large-kmallocs-for-the-fdtable.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
osst-wrong-index-used-in-inner-loop-checkpatch-fixes.patch
drivers-scsi-osstc-fix-warning.patch
drbd-fix-warning.patch
drivers-usb-misc-usbtestc-fix-warning.patch
mm.patch
mm-nommu-sort-mm-mmap-list-properly-fix.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur-fix.patch
mm-mmu_gather-rework-fix.patch
mm-thp-optimize-memcg-charge-in-khugepaged-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
lib-genpoolc-document-return-values-fix-gen_pool_add_virt-return-value.patch
percpu_counter-change-return-value-and-add-comments-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

