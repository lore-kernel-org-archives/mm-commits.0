From: akpm@linux-foundation.org
Subject: + hardware-eicon-messagec-warning-fixes.patch added to -mm tree
Date: Tue, 22 May 2007 15:27:46 -0700
Message-ID: <200705222231.l4MMV1Q6011235@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46425 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756714AbXEVWcR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 18:32:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, kkeil@suse.de


The patch titled
     drivers/isdn/hardware/eicon/message.c warning fixes
has been added to the -mm tree.  Its filename is
     hardware-eicon-messagec-warning-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/isdn/hardware/eicon/message.c warning fixes
From: Andrew Morton <akpm@linux-foundation.org>

Squash these:

drivers/isdn/hardware/eicon/message.c: In function 'api_put':
drivers/isdn/hardware/eicon/message.c:536: warning: cast from pointer to integer of different size
drivers/isdn/hardware/eicon/message.c: In function 'plci_free_msg_in_queue':
drivers/isdn/hardware/eicon/message.c:1035: warning: cast to pointer from integer of different size
drivers/isdn/hardware/eicon/message.c: In function 'data_b3_req':
drivers/isdn/hardware/eicon/message.c:3121: warning: cast to pointer from integer of different size
drivers/isdn/hardware/eicon/message.c:3154: warning: cast to pointer from integer of different size
drivers/isdn/hardware/eicon/message.c: In function 'callback':
drivers/isdn/hardware/eicon/message.c:4060: warning: cast to pointer from integer of different size
drivers/isdn/hardware/eicon/message.c: In function 'nl_ind':
drivers/isdn/hardware/eicon/message.c:7137: warning: cast from pointer to integer of different size

Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/eicon/message.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN drivers/isdn/hardware/eicon/message.c~hardware-eicon-messagec-warning-fixes drivers/isdn/hardware/eicon/message.c
--- a/drivers/isdn/hardware/eicon/message.c~hardware-eicon-messagec-warning-fixes
+++ a/drivers/isdn/hardware/eicon/message.c
@@ -1,4 +1,3 @@
-
 /*
  *
   Copyright (c) Eicon Networks, 2002.
@@ -533,7 +532,7 @@ word api_put(APPL   * appl, CAPI_MSG   *
         if (m->header.command == _DATA_B3_R)
         {
 
-          m->info.data_b3_req.Data = (dword)(TransmitBufferSet (appl, m->info.data_b3_req.Data));
+          m->info.data_b3_req.Data = (dword)(long)(TransmitBufferSet (appl, m->info.data_b3_req.Data));
 
         }
 
@@ -1032,7 +1031,7 @@ static void plci_free_msg_in_queue (PLCI
       {
 
         TransmitBufferFree (plci->appl,
-          (byte   *)(((CAPI_MSG   *)(&((byte   *)(plci->msg_in_queue))[i]))->info.data_b3_req.Data));
+          (byte *)(long)(((CAPI_MSG *)(&((byte *)(plci->msg_in_queue))[i]))->info.data_b3_req.Data));
 
       }
 
@@ -3118,7 +3117,7 @@ byte data_b3_req(dword Id, word Number, 
        && (((byte   *)(parms[0].info)) < ((byte   *)(plci->msg_in_queue)) + sizeof(plci->msg_in_queue)))
       {
 
-        data->P = (byte   *)(*((dword   *)(parms[0].info)));
+        data->P = (byte *)(long)(*((dword *)(parms[0].info)));
 
       }
       else
@@ -3151,7 +3150,7 @@ byte data_b3_req(dword Id, word Number, 
        && (((byte   *)(parms[0].info)) < ((byte   *)(plci->msg_in_queue)) + sizeof(plci->msg_in_queue)))
       {
 
-        TransmitBufferFree (appl, (byte   *)(*((dword   *)(parms[0].info))));
+        TransmitBufferFree (appl, (byte *)(long)(*((dword *)(parms[0].info))));
 
       }
     }
@@ -4057,7 +4056,7 @@ capi_callback_suffix:
     {
       if (m->header.command == _DATA_B3_R)
 
-        TransmitBufferFree (appl, (byte   *)(m->info.data_b3_req.Data));
+        TransmitBufferFree (appl, (byte *)(long)(m->info.data_b3_req.Data));
 
       dbug(1,dprintf("Error 0x%04x from msg(0x%04x)", i, m->header.command));
       break;
@@ -7134,7 +7133,7 @@ void nl_ind(PLCI   * plci)
   case N_UDATA:
     if (!(udata_forwarding_table[plci->NL.RBuffer->P[0] >> 5] & (1L << (plci->NL.RBuffer->P[0] & 0x1f))))
     {
-      plci->RData[0].P = plci->internal_ind_buffer + (-((int)(plci->internal_ind_buffer)) & 3);
+      plci->RData[0].P = plci->internal_ind_buffer + (-((int)(long)(plci->internal_ind_buffer)) & 3);
       plci->RData[0].PLength = INTERNAL_IND_BUFFER_SIZE;
       plci->NL.R = plci->RData;
       plci->NL.RNum = 1;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa-fixup.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-cpufreq-fix.patch
8xx-mpc885ads-pcmcia-support-fix.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
driver-core-check-return-code-of-sysfs_create_link-fix.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
git-gfs2-nmw.patch
git-ia64.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-leds.patch
git-leds-fixup.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix-tidy.patch
ide-warning-fixes.patch
git-md-accel-build-fix.patch
git-mips-fixup.patch
git-mtd.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices-fix.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver-build-fix.patch
git-ubi.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-parisc.patch
pci-x-pci-express-read-control-interfaces-fix.patch
git-pciseg.patch
git-scsi-rc-fixes.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-unionfs.patch
fix-gregkh-usb-usb-r8a66597-hcd-host-controller-driver-for-r8a66597.patch
git-wireless.patch
arch-x86_64-vdso-vmac-needs-schedh.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch
x86_64-fix-smp_call_function_single-return-value.patch
xfs-clean-up-shrinker-games.patch
git-cryptodev.patch
x86_64-allocate-sparsemem-memmap-above-4g-fix.patch
simplify-cleanup_workqueue_thread-fix.patch
procfs-directory-entry-cleanup-fix.patch
capifunc-warning-fixes.patch
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
pie-randomization-fix.patch
rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty-fix.patch
mpu401-warning-fixes.patch
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
reiser4.patch
reiser4-fix.patch
vdso-print-fatal-signals.patch
check_dirty_inode_list.patch
w1-build-fix.patch
