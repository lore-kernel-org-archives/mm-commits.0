From: akpm@linux-foundation.org
Subject: - lib-swiotlbc-cleanups.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:41:15 -0700
Message-ID: <200804300541.m3U5fFSB029041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755208AbYD3FmN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:42:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andi@firstfloor.org, fujita.tomonori@lab.ntt.co.jp, jbeulich@novell.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     lib/swiotlb.c: cleanups
has been removed from the -mm tree.  Its filename was
     lib-swiotlbc-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/swiotlb.c: cleanups
From: Andrew Morton <akpm@linux-foundation.org>

There's a pointlessly braced block of code in there.  Remove the braces and
save a tabstop.

Cc: Andi Kleen <ak@suse.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/swiotlb.c |   85 +++++++++++++++++++++++-------------------------
 1 file changed, 41 insertions(+), 44 deletions(-)

diff -puN lib/swiotlb.c~lib-swiotlbc-cleanups lib/swiotlb.c
--- a/lib/swiotlb.c~lib-swiotlbc-cleanups
+++ a/lib/swiotlb.c
@@ -331,56 +331,53 @@ map_single(struct device *hwdev, char *b
 	 * request and allocate a buffer from that IO TLB pool.
 	 */
 	spin_lock_irqsave(&io_tlb_lock, flags);
-	{
-		index = ALIGN(io_tlb_index, stride);
-		if (index >= io_tlb_nslabs)
-			index = 0;
-		wrap = index;
+	index = ALIGN(io_tlb_index, stride);
+	if (index >= io_tlb_nslabs)
+		index = 0;
+	wrap = index;
+
+	do {
+		while (is_span_boundary(index, nslots, offset_slots,
+				max_slots)) {
+			index += stride;
+			if (index >= io_tlb_nslabs)
+				index = 0;
+			if (index == wrap)
+				goto not_found;
+		}
 
-		do {
-			while (is_span_boundary(index, nslots, offset_slots,
-						max_slots)) {
-				index += stride;
-				if (index >= io_tlb_nslabs)
-					index = 0;
-				if (index == wrap)
-					goto not_found;
-			}
+		/*
+		 * If we find a slot that indicates we have 'nslots' number of
+		 * contiguous buffers, we allocate the buffers from that slot
+		 * and mark the entries as '0' indicating unavailable.
+		 */
+		if (io_tlb_list[index] >= nslots) {
+			int count = 0;
+
+			for (i = index; i < (int) (index + nslots); i++)
+				io_tlb_list[i] = 0;
+			for (i = index - 1; (OFFSET(i, IO_TLB_SEGSIZE) != IO_TLB_SEGSIZE - 1) && io_tlb_list[i]; i--)
+				io_tlb_list[i] = ++count;
+			dma_addr = io_tlb_start + (index << IO_TLB_SHIFT);
 
 			/*
-			 * If we find a slot that indicates we have 'nslots'
-			 * number of contiguous buffers, we allocate the
-			 * buffers from that slot and mark the entries as '0'
-			 * indicating unavailable.
+			 * Update the indices to avoid searching in the next
+			 * round.
 			 */
-			if (io_tlb_list[index] >= nslots) {
-				int count = 0;
+			io_tlb_index = ((index + nslots) < io_tlb_nslabs
+					? (index + nslots) : 0);
 
-				for (i = index; i < (int) (index + nslots); i++)
-					io_tlb_list[i] = 0;
-				for (i = index - 1; (OFFSET(i, IO_TLB_SEGSIZE) != IO_TLB_SEGSIZE -1) && io_tlb_list[i]; i--)
-					io_tlb_list[i] = ++count;
-				dma_addr = io_tlb_start + (index << IO_TLB_SHIFT);
-
-				/*
-				 * Update the indices to avoid searching in
-				 * the next round.
-				 */
-				io_tlb_index = ((index + nslots) < io_tlb_nslabs
-						? (index + nslots) : 0);
-
-				goto found;
-			}
-			index += stride;
-			if (index >= io_tlb_nslabs)
-				index = 0;
-		} while (index != wrap);
+			goto found;
+		}
+		index += stride;
+		if (index >= io_tlb_nslabs)
+			index = 0;
+	} while (index != wrap);
 
-  not_found:
-		spin_unlock_irqrestore(&io_tlb_lock, flags);
-		return NULL;
-	}
-  found:
+not_found:
+	spin_unlock_irqrestore(&io_tlb_lock, flags);
+	return NULL;
+found:
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
 
 	/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart-fix.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
disable-the-memory-controller-by-default-v3.patch
git-acpi.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
x86-ptrace-pebs-support-warning-fix.patch
rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline-cleanup.patch
cifs-suppress-warning.patch
devres-support-addresses-greater-than-an-unsigned-long-via-dev_ioremap-checkpatch-fixes.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-hwmon.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-kvm.patch
pata_atiixp-simplex-clear.patch
git-m32r.patch
git-mips.patch
git-mips-git-rejects.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
sched-add-debug-checks-to-idle-functions.patch
drivers-base-topologyc-add-conditionals-around-show_cpumap.patch
add-rcu_assign_index-if-ever-needed.patch
git-scsi-misc.patch
scsi-fix-section-mismatch-in-aic94xx.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
aic79xx_core-remove-ascii-art.patch
sparc32-export-empty_zero_page.patch
git-unionfs.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
revert-rusty-misc-timer-typesafe.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
ext4-is-busted-on-m68k.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
utimensat-non-conformances-and-fixes-checkpatch-fixes.patch
add-warn_on_secs-macro.patch
rtc-class-driver-for-ppc_md-rtc-functions-fix.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
sxc-fix-printk-warnings-on-sparc32.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
isicom-bring-into-coding-style-fix.patch
tty-the-big-operations-rework-fix-2.patch
tty-the-big-operations-rework-isicom-fix.patch
tty-the-big-operations-rework-simserial-fix.patch
tty-the-big-operations-rework-vs-git-kgdb-light.patch
tty-the-big-operations-rework-vs-kgdb-2.patch
devpts-factor-out-pty-index-allocation-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
fuse-fix-race-in-llseek-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
rename-div64_64-to-div64_u64-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
x86-ioremap-add-checks-for-virtual-addresses-fix.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

