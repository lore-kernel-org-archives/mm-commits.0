From: akpm@linux-foundation.org
Subject: + git-x86-fixup.patch added to -mm tree
Date: Tue, 20 Nov 2007 11:57:21 -0800
Message-ID: <200711201957.lAKJvLxC020639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52563 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756595AbXKTT6D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 14:58:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, lenb@kernel.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     git-x86-fixup
has been added to the -mm tree.  Its filename is
     git-x86-fixup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-x86-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Fix rejects in git-x86.  Mainly but not only patches which were also applied
to the acpi tree.

Cc: Len Brown <lenb@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/io_apic_64.c  |   88 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/pci-gart_64.c |   14 ++---
 x86/kernel/acpi/boot.c        |    0 
 3 files changed, 94 insertions(+), 8 deletions(-)

diff -puN arch/x86/kernel/pci-gart_64.c~git-x86-fixup arch/x86/kernel/pci-gart_64.c
--- a/arch/x86/kernel/pci-gart_64.c~git-x86-fixup
+++ a/arch/x86/kernel/pci-gart_64.c
@@ -408,21 +408,19 @@ dma_map_cont(struct scatterlist *start, 
 		
 /*
  * DMA map all entries in a scatterlist.
- * Merge chunks that have page aligned sizes into a continuous mapping. 
+ * Merge chunks that have page aligned sizes into a continuous mapping.
  */
-static int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-			int dir)
+static int
+gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 {
-	int i;
-	int out;
-	int start;
+	struct scatterlist *s, *ps, *start_sg, *sgmap;
+	int need = 0, nextneed, i, out, start;
 	unsigned long pages = 0;
-	int need = 0, nextneed;
 	unsigned int seg_size;
 	unsigned int max_seg_size;
 	struct scatterlist *s, *ps, *start_sg, *sgmap;
 
-	if (nents == 0) 
+	if (nents == 0)
 		return 0;
 
 	if (!dev)
diff -puN arch/x86/pci/acpi.c~git-x86-fixup arch/x86/pci/acpi.c
diff -puN arch/x86/kernel/io_apic_64.c~git-x86-fixup arch/x86/kernel/io_apic_64.c
--- a/arch/x86/kernel/io_apic_64.c~git-x86-fixup
+++ a/arch/x86/kernel/io_apic_64.c
@@ -2284,3 +2284,91 @@ void __init setup_ioapic_dest(void)
 }
 #endif
 
+#define IOAPIC_RESOURCE_NAME_SIZE 11
+
+static struct resource *ioapic_resources;
+
+static struct resource * __init ioapic_setup_resources(void)
+{
+	unsigned long n;
+	struct resource *res;
+	char *mem;
+	int i;
+
+	if (nr_ioapics <= 0)
+		return NULL;
+
+	n = IOAPIC_RESOURCE_NAME_SIZE + sizeof(struct resource);
+	n *= nr_ioapics;
+
+	mem = alloc_bootmem(n);
+	res = (void *)mem;
+
+	if (mem != NULL) {
+		memset(mem, 0, n);
+		mem += sizeof(struct resource) * nr_ioapics;
+
+		for (i = 0; i < nr_ioapics; i++) {
+			res[i].name = mem;
+			res[i].flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+			sprintf(mem,  "IOAPIC %u", i);
+			mem += IOAPIC_RESOURCE_NAME_SIZE;
+		}
+	}
+
+	ioapic_resources = res;
+
+	return res;
+}
+
+void __init ioapic_init_mappings(void)
+{
+	unsigned long ioapic_phys, idx = FIX_IO_APIC_BASE_0;
+	struct resource *ioapic_res;
+	int i;
+
+	ioapic_res = ioapic_setup_resources();
+	for (i = 0; i < nr_ioapics; i++) {
+		if (smp_found_config) {
+			ioapic_phys = mp_ioapics[i].mpc_apicaddr;
+		} else {
+			ioapic_phys = (unsigned long)
+				alloc_bootmem_pages(PAGE_SIZE);
+			ioapic_phys = __pa(ioapic_phys);
+		}
+		set_fixmap_nocache(idx, ioapic_phys);
+		apic_printk(APIC_VERBOSE,
+			    "mapped IOAPIC to %016lx (%016lx)\n",
+			    __fix_to_virt(idx), ioapic_phys);
+		idx++;
+
+		if (ioapic_res != NULL) {
+			ioapic_res->start = ioapic_phys;
+			ioapic_res->end = ioapic_phys + (4 * 1024) - 1;
+			ioapic_res++;
+		}
+	}
+}
+
+static int __init ioapic_insert_resources(void)
+{
+	int i;
+	struct resource *r = ioapic_resources;
+
+	if (!r) {
+		printk(KERN_ERR
+		       "IO APIC resources could be not be allocated.\n");
+		return -1;
+	}
+
+	for (i = 0; i < nr_ioapics; i++) {
+		insert_resource(&iomem_resource, r);
+		r++;
+	}
+
+	return 0;
+}
+
+/* Insert the IO APIC resources after PCI initialization has occured to handle
+ * IO APICS that are mapped in on a BAR in PCI space. */
+late_initcall(ioapic_insert_resources);
diff -puN arch/x86/kernel/acpi/sleep_64.c~git-x86-fixup arch/x86/kernel/acpi/sleep_64.c
diff -puN arch/x86/kernel/acpi/boot.c~git-x86-fixup arch/x86/kernel/acpi/boot.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
file-capabilities-allow-sigcont-within-session-v2.patch
pnp-increase-the-maximum-number-of-resources-fix.patch
revert-keyspan-init-termios-properly.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200-fix.patch
acpi-add-reboot-mechanism.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
agk-dm-dm-ioctl-move-compat-code-fix.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc-fix.patch
git-drm-oops-fix.patch
git-dvb.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
elantech-touchpad-driver-fix.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
ide-arm-hack.patch
git-mips-fixup.patch
git-mmc.patch
git-mtd.patch
git-netdev-all.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
bluetooth-uninlining.patch
git-nfsd-build-fix.patch
quirk_vialatency-omit-reading-pci-revision-id-checkpatch-fixes.patch
drivers-pci-quirksc-coding-style-cleanup.patch
more-sanity-checks-for-dmar-checkpatch-fixes.patch
git-s390.patch
fix-build-breakage-if-sysfs-fix.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
scsi-gdth-kill-unneeded-irq-argument-checkpatch-fixes.patch
scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers-checkpatch-fixes.patch
bidi-support-scsi_data_buffer-broke-qla1280.patch
bidi-support-scsi_data_buffer-broke-lots-of-stuff.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
git-wireless.patch
jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
git-ipwireless_cs.patch
git-x86.patch
git-x86-fixup.patch
git-x86-memory_add_physaddr_to_nid-export-for-acpi-memhotplugko-checkpatch-fixes.patch
git-x86-inlining-borkage.patch
git-cryptodev.patch
git-xtensa.patch
ia64-increase-datapatch-offset.patch
ia64-dont-assume-that-unwcheckpy-is-executable.patch
ia64-export-copy_page-to-modules.patch
ia64-export-copy_page-to-modules-fix.patch
isdn-validate-length-of-isdn_net_ioctl_cfgeaz.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
maps4-rework-task_size-macros-mips-fix.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
alpha-atomic_add_return-should-return-int.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
aout-mark-arches-that-support-aout-format-fix.patch
aout-mark-arches-that-support-aout-format-fix-2.patch
aout-mark-arches-that-support-aout-format-fix-3.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
kernel-printkc-concerns-about-the-console-handover.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
pie-executable-randomization.patch
pie-executable-randomization-uninlining.patch
pie-executable-randomization-checkpatch-fixes.patch
riscom8-fix-smp-brokenness-fix.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
remove-__attribute_used__-checkpatch-fixes.patch
read_current_time-cleanups.patch
read_current_time-cleanups-build-fix-fix.patch
sync_sb_inodes-propagate-errors.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
64-bit-i_version-afs-fixes.patch
kill-filp_open-checkpatch-fixes.patch
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
proc-detect-duplicate-names-on-registration-fix.patch
proc-simplify-remove_proc_entry-wrt-locking-checkpatch-fixes.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
w1-build-fix.patch
