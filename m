From: akpm@linux-foundation.org
Subject: - capifunc-warning-fixes.patch removed from -mm tree
Date: Tue, 29 May 2007 11:53:25 -0700
Message-ID: <200705291853.l4TIrO4U008463@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764753AbXE2Sxw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:53:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     capifunc warning fixes
has been removed from the -mm tree.  Its filename was
     capifunc-warning-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: capifunc warning fixes
From: Andrew Morton <akpm@linux-foundation.org>

squish these:

drivers/isdn/hardware/eicon/capifunc.c: In function 'TransmitBufferSet':
drivers/isdn/hardware/eicon/capifunc.c:192: warning: cast to pointer from integer of different size
drivers/isdn/hardware/eicon/capifunc.c: In function 'TransmitBufferGet':
drivers/isdn/hardware/eicon/capifunc.c:197: warning: cast from pointer to integer of different size
drivers/isdn/hardware/eicon/capifunc.c:198: warning: cast from pointer to integer of different size
drivers/isdn/hardware/eicon/capifunc.c:200: warning: cast from pointer to integer of different size
drivers/isdn/hardware/eicon/capifunc.c: In function 'TransmitBufferFree':
drivers/isdn/hardware/eicon/capifunc.c:205: warning: cast from pointer to integer of different size
drivers/isdn/hardware/eicon/capifunc.c:206: warning: cast from pointer to integer of different size
drivers/isdn/hardware/eicon/capifunc.c: In function 'sendf':
drivers/isdn/hardware/eicon/capifunc.c:304: warning: cast to pointer from integer of different size
drivers/isdn/hardware/eicon/capifunc.c:304: warning: cast to pointer from integer of different size
drivers/isdn/hardware/eicon/capifunc.c:321: warning: cast to pointer from integer of different size

Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/eicon/capifunc.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/isdn/hardware/eicon/capifunc.c~capifunc-warning-fixes drivers/isdn/hardware/eicon/capifunc.c
--- a/drivers/isdn/hardware/eicon/capifunc.c~capifunc-warning-fixes
+++ a/drivers/isdn/hardware/eicon/capifunc.c
@@ -189,21 +189,21 @@ void *TransmitBufferSet(APPL * appl, dwo
 {
 	appl->xbuffer_used[ref] = true;
 	DBG_PRV1(("%d:xbuf_used(%d)", appl->Id, ref + 1))
-	    return (void *) ref;
+	    return (void *)(long)ref;
 }
 
 void *TransmitBufferGet(APPL * appl, void *p)
 {
-	if (appl->xbuffer_internal[(dword) p])
-		return appl->xbuffer_internal[(dword) p];
+	if (appl->xbuffer_internal[(dword)(long)p])
+		return appl->xbuffer_internal[(dword)(long)p];
 
-	return appl->xbuffer_ptr[(dword) p];
+	return appl->xbuffer_ptr[(dword)(long)p];
 }
 
 void TransmitBufferFree(APPL * appl, void *p)
 {
-	appl->xbuffer_used[(dword) p] = false;
-	DBG_PRV1(("%d:xbuf_free(%d)", appl->Id, ((dword) p) + 1))
+	appl->xbuffer_used[(dword)(long)p] = false;
+	DBG_PRV1(("%d:xbuf_free(%d)", appl->Id, ((dword)(long)p) + 1))
 }
 
 void *ReceiveBufferGet(APPL * appl, int Num)
@@ -301,7 +301,7 @@ void sendf(APPL * appl, word command, dw
 	/* if DATA_B3_IND, copy data too */
 	if (command == _DATA_B3_I) {
 		dword data = GET_DWORD(&msg.info.data_b3_ind.Data);
-		memcpy(write + length, (void *) data, dlength);
+		memcpy(write + length, (void *)(long)data, dlength);
 	}
 
 #ifndef DIVA_NO_DEBUGLIB
@@ -318,7 +318,7 @@ void sendf(APPL * appl, word command, dw
 			if (myDriverDebugHandle.dbgMask & DL_BLK) {
 				xlog("\x00\x02", &msg, 0x81, length);
 				for (i = 0; i < dlength; i += 256) {
-				  DBG_BLK((((char *) GET_DWORD(&msg.info.data_b3_ind.Data)) + i,
+				  DBG_BLK((((char *)(long)GET_DWORD(&msg.info.data_b3_ind.Data)) + i,
 				  	((dlength - i) < 256) ? (dlength - i) : 256))
 				  if (!(myDriverDebugHandle.dbgMask & DL_PRV0))
 					  break; /* not more if not explicitely requested */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

slub-more-documentation-fix.patch
ntfs_init_locked_inode-fix-array-indexing.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa-fixup.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm-master.patch
git-cpufreq-fix.patch
8xx-mpc885ads-pcmcia-support.patch
fix-gregkh-driver-dmi-based-module-autoloading.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
driver-core-check-return-code-of-sysfs_create_link.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-input.patch
git-kbuild.patch
git-kvm.patch
git-leds.patch
git-leds-fixup.patch
git-mips-fixup.patch
git-mtd.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
git-ubi.patch
wrong-timeout-value-in-sk_wait_data-v2-fix.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-parisc.patch
pci-x-pci-express-read-control-interfaces-fix.patch
git-pciseg.patch
sh-support-older-gccs.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-unionfs.patch
fix-gregkh-usb-usb-ehci-cpufreq-fix.patch
git-watchdog.patch
git-wireless.patch
x86_64-mm-xen-attempt-to-patch-inline-versions-of-common-operations.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
x86_64-fix-smp_call_function_single-return-value.patch
git-xfs.patch
git-cryptodev.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
change-zonelist-order-v6-zonelist-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
create-the-zone_movable-zone-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-2.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-add-proc-pid-pagemap-interface.patch
fs-introduce-some-page-buffer-invariants-obnoxiousness.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
alpha-support-graphics-on-non-zero-pci-domains-fix-2.patch
freezer-run-show_state-when-freezing-times-out.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
fuse-warning-fix.patch
vxfs-warning-fixes.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty-fix.patch
mpu401-warning-fixes.patch
procfs-directory-entry-cleanup-fix.patch
vdso-print-fatal-signals.patch
reduce-cpusetc-write_lock_irq-to-read_lock-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support-fix.patch
i2o_cfg_passthru-cleanup-fix.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
nfsd-warning-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
lguest-the-host-code-borkages.patch
cfs-scheduler-vs-detach-schedh-from-mmh.patch
cfs-scheduler-warning-fixes.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
reiser4.patch
reiser4-fix.patch
check_dirty_inode_list.patch
w1-build-fix.patch
