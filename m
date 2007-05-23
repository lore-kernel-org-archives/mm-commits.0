From: akpm@linux-foundation.org
Subject: + ncr5380-warning-fixes.patch added to -mm tree
Date: Tue, 22 May 2007 17:26:51 -0700
Message-ID: <200705230030.l4N0U76m013582@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44709 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759051AbXEWAaQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 20:30:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@steeleye.com, alan@lxorguk.ukuu.org.uk


The patch titled
     ncr5380 warning fixes
has been added to the -mm tree.  Its filename is
     ncr5380-warning-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ncr5380 warning fixes
From: Andrew Morton <akpm@linux-foundation.org>

squish these:

drivers/scsi/NCR5380.c:360: warning: 'phases' defined but not used
drivers/scsi/NCR5380.c:360: warning: 'phases' defined but not used
drivers/scsi/NCR5380.c:633: warning: 'NCR5380_print_options' defined but not used
drivers/scsi/NCR5380.c:708: warning: 'NCR5380_proc_info' defined but not used
drivers/scsi/NCR5380.c:360: warning: 'phases' defined but not used
drivers/scsi/NCR5380.c:579: warning: 'NCR5380_probe_irq' defined but not used
drivers/scsi/NCR5380.c:360: warning: 'phases' defined but not used
drivers/scsi/NCR5380.c:708: warning: 'notyet_generic_proc_info' defined but not used
drivers/scsi/NCR5380.c:708: warning: 'notyet_generic_proc_info' defined but not used

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/NCR5380.c |   11 ++++++-----
 drivers/scsi/NCR5380.h |    6 +++---
 2 files changed, 9 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/NCR5380.c~ncr5380-warning-fixes drivers/scsi/NCR5380.c
--- a/drivers/scsi/NCR5380.c~ncr5380-warning-fixes
+++ a/drivers/scsi/NCR5380.c
@@ -357,7 +357,7 @@ static int NCR5380_poll_politely(struct 
 static struct {
 	unsigned char value;
 	const char *name;
-} phases[] = {
+} phases[] __used = {
 	{PHASE_DATAOUT, "DATAOUT"}, 
 	{PHASE_DATAIN, "DATAIN"}, 
 	{PHASE_CMDOUT, "CMDOUT"}, 
@@ -575,7 +575,7 @@ static irqreturn_t __init probe_intr(int
  *	Locks: none, irqs must be enabled on entry
  */
 
-static int __init NCR5380_probe_irq(struct Scsi_Host *instance, int possible)
+static int __init __used NCR5380_probe_irq(struct Scsi_Host *instance, int possible)
 {
 	NCR5380_local_declare();
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
@@ -629,7 +629,8 @@ static int __init NCR5380_probe_irq(stru
  *	Locks: none
  */
 
-static void __init NCR5380_print_options(struct Scsi_Host *instance)
+static void __init __maybe_unused
+NCR5380_print_options(struct Scsi_Host *instance)
 {
 	printk(" generic options"
 #ifdef AUTOPROBE_IRQ
@@ -703,8 +704,8 @@ char *lprint_command(unsigned char *cmd,
 static
 char *lprint_opcode(int opcode, char *pos, char *buffer, int length);
 
-static
-int NCR5380_proc_info(struct Scsi_Host *instance, char *buffer, char **start, off_t offset, int length, int inout)
+static int __maybe_unused NCR5380_proc_info(struct Scsi_Host *instance,
+	char *buffer, char **start, off_t offset, int length, int inout)
 {
 	char *pos = buffer;
 	struct NCR5380_hostdata *hostdata;
diff -puN drivers/scsi/NCR5380.h~ncr5380-warning-fixes drivers/scsi/NCR5380.h
--- a/drivers/scsi/NCR5380.h~ncr5380-warning-fixes
+++ a/drivers/scsi/NCR5380.h
@@ -299,7 +299,7 @@ static void NCR5380_information_transfer
 static irqreturn_t NCR5380_intr(int irq, void *dev_id);
 #endif
 static void NCR5380_main(struct work_struct *work);
-static void NCR5380_print_options(struct Scsi_Host *instance);
+static void __maybe_unused NCR5380_print_options(struct Scsi_Host *instance);
 #ifdef NDEBUG
 static void NCR5380_print_phase(struct Scsi_Host *instance);
 static void NCR5380_print(struct Scsi_Host *instance);
@@ -307,8 +307,8 @@ static void NCR5380_print(struct Scsi_Ho
 static int NCR5380_abort(Scsi_Cmnd * cmd);
 static int NCR5380_bus_reset(Scsi_Cmnd * cmd);
 static int NCR5380_queue_command(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *));
-static int NCR5380_proc_info(struct Scsi_Host *instance, char *buffer, char **start,
-off_t offset, int length, int inout);
+static int __maybe_unused NCR5380_proc_info(struct Scsi_Host *instance,
+	char *buffer, char **start, off_t offset, int length, int inout);
 
 static void NCR5380_reselect(struct Scsi_Host *instance);
 static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd * cmd, int tag);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
capabilityh-warning-fix.patch
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
sh-support-older-gccs.patch
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
hardware-eicon-messagec-warning-fixes.patch
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
cfs-scheduler-warning-fixes.patch
reiser4.patch
reiser4-fix.patch
vdso-print-fatal-signals.patch
check_dirty_inode_list.patch
w1-build-fix.patch
ncr5380-warning-fixes.patch
