From: akpm@linux-foundation.org
Subject: + lib-swiotlbc-cleanups.patch added to -mm tree
Date: Thu, 13 Mar 2008 11:19:43 -0700
Message-ID: <200803131819.m2DIJhH6026522@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753639AbYCMSUY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 14:20:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@suse.de, fujita.tomonori@lab.ntt.co.jp, jbeulich@novell.com, tony.luck@intel.com


The patch titled
     lib/swiotlb.c: cleanups
has been added to the -mm tree.  Its filename is
     lib-swiotlbc-cleanups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -332,56 +332,53 @@ map_single(struct device *hwdev, char *b
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
lib-swiotlbc-avoid-endless-loops-fix.patch
git-x86.patch
arch-x86-kernel-ptracec-fix-defined-but-unused-warnings.patch
revert-x86-enhance-debug_rodata-support-for-hotplug-and-kprobes.patch
git-kgdb-light.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-tiwai.patch
git-arm-master.patch
cifs-suppress-warning.patch
git-powerpc-fix-git-rejects.patch
revert-gregkh-driver-video-add-the-go7007-driver.patch
fix-gregkh-driver-net-convert-the-phy_device-file-to-use-bus_find_device_by_name.patch
driver-core-debug-for-bad-dev_attr_show-return-value.patch
pm-make-wakeup-flags-available-whenever-config_pm-is-set-checkpatch-fixes.patch
git-drm.patch
git-dvb.patch
drivers-media-video-pvrusb2-pvrusb2-sysfsc-fix-printk-warnings.patch
drivers-media-video-soc_camerac-reads-return-size_t.patch
git-hwmon.patch
fs-gfs2-recoveryc-suppress-warnings.patch
git-hrt.patch
git-ieee1394.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
maple-add-driver-for-sega-dreamcast-controller.patch
git-kvm.patch
git-leds.patch
devres-implement-pcim_iomap_regions_request_all-fix.patch
devres-implement-pcim_iomap_regions_request_all-fix-fix.patch
git-net.patch
git-net-fix-build-with-config_net=n.patch
drivers-atm-firestreamc-suppress-uninitialized-var-warning.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
net-sunrpc-svcc-suppress-unintialized-var-warning.patch
git-nfsd.patch
git-ocfs2.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
git-selinux.patch
git-sh.patch
scsi-aic94xx-cleanups.patch
scsi-fix-section-mismatch-in-aic94xx-fix.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
ipsc-fix-build-warning.patch
drivers-scsi-initioc-suppress-compile-warning.patch
drivers-scsi-hptiopc-fix-build-warning.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
git-block-git-rejects.patch
git-unionfs.patch
fix-gregkh-usb-usb-add-usb-serial-spcp8x5-driver.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
drivers-usb-core-devioc-suppress-warning-with-64k-page_size.patch
git-v9fs.patch
git-watchdog.patch
git-semaphore-git-rejects.patch
revert-acpi-thermal-fixup.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
mm-make-mem_map-allocation-continuous-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.patch
codafs-fix-build-warning.patch
lib-swiotlbc-cleanups.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-rcu_assign_index-if-ever-needed-fix.patch
add-warn_on_secs-macro-fix-fix.patch
uart_get_baud_rate-stop-mangling-termios-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
fat_valid_media-remove-pointless-test.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ext4-is-broken.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
procfs-task-exe-symlink-fix.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch

