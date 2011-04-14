From: akpm@linux-foundation.org
Subject: [folded] fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 14 Apr 2011 15:19:56 -0700
Message-ID: <201104142219.p3EMJugX009796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753932Ab1DNWUI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Apr 2011 18:20:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Warns@pre-sense.de, eugeneteo@kernel.sg, harvey.harrison@gmail.com, rich@flatcap.org, warns@pre-sense.de, mm-commits@vger.kernel.org


The patch titled
     fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table-checkpatch-fixes.patch

This patch was dropped because it was folded into fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: space prohibited between function name and open parenthesis '('
#29: FILE: fs/partitions/ldm.c:1303:
+		ldm_error ("Value of size is to small.");

WARNING: space prohibited between function name and open parenthesis '('
#41: FILE: fs/partitions/ldm.c:1315:
+		ldm_error ("REC value (%d) exceeds NUM value (%d)", rec, num);

total: 0 errors, 2 warnings, 34 lines checked

./patches/fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Eugene Teo <eugeneteo@kernel.sg>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Richard Russon <rich@flatcap.org>
Cc: Timo Warns <Warns@pre-sense.de>
Cc: Timo Warns <warns@pre-sense.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/ldm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/partitions/ldm.c~fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table-checkpatch-fixes fs/partitions/ldm.c
--- a/fs/partitions/ldm.c~fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table-checkpatch-fixes
+++ a/fs/partitions/ldm.c
@@ -1299,8 +1299,8 @@ static bool ldm_frag_add (const u8 *data
 
 	BUG_ON (!data || !frags);
 
-	if (size < 2*VBLK_SIZE_HEAD) {
-		ldm_error ("Value of size is to small.");
+	if (size < 2 * VBLK_SIZE_HEAD) {
+		ldm_error("Value of size is to small.");
 		return false;
 	}
 
@@ -1312,7 +1312,7 @@ static bool ldm_frag_add (const u8 *data
 		return false;
 	}
 	if (rec >= num) {
-		ldm_error ("REC value (%d) exceeds NUM value (%d)", rec, num);
+		ldm_error("REC value (%d) exceeds NUM value (%d)", rec, num);
 		return false;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table.patch
mm-add-vm-counters-for-transparent-hugepages.patch
mm-thp-use-conventional-format-for-boolean-attributes.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
hid-examplec-is-borked.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-i2c-busses-i2c-designware-corec-needs-delayh.patch
vfs-avoid-large-kmallocs-for-the-fdtable.patch
drivers-scsi-mpt2sas-mpt2sas_ctlc-fix-unbounded-copy_to_user.patch
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
drivers-tty-vt-vt_ioctlc-repair-insane-expression.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
dev-kmsg-properly-support-writev-to-avoid-interleaved-printk-lines-fix.patch
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

