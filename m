From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 04 Feb 2009 12:50:51 -0800
Message-ID: <200902042050.n14Kopd1025509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754327AbZBDUux (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Feb 2009 15:50:53 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n14Kopk7020263
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 4 Feb 2009 12:50:52 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide-acpi.c  |   28 ----------------------------
 drivers/ide/via82cxxx.c |    3 ---
 2 files changed, 31 deletions(-)

diff -puN drivers/ide/ide-acpi.c~linux-next-git-rejects drivers/ide/ide-acpi.c
--- a/drivers/ide/ide-acpi.c~linux-next-git-rejects
+++ a/drivers/ide/ide-acpi.c
@@ -222,34 +222,6 @@ static int do_drive_get_GTF(ide_drive_t 
 	*gtf_address = 0UL;
 	*obj_loc = 0UL;
 
-<<<<<<< HEAD:drivers/ide/ide-acpi.c
-	if (ide_noacpi)
-		return 0;
-
-	if (!dev) {
-		DEBPRINT("no PCI device for %s\n", hwif->name);
-		goto out;
-	}
-
-	if (!hwif->acpidata) {
-		DEBPRINT("no ACPI data for %s\n", hwif->name);
-		goto out;
-	}
-
-	port = hwif->channel ? drive->dn - 2: drive->dn;
-
-	DEBPRINT("ENTER: %s at %s, port#: %d, hard_port#: %d\n",
-		 hwif->name, dev_name(dev), port, hwif->channel);
-
-	if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0) {
-		DEBPRINT("%s drive %d:%d not present\n",
-			 hwif->name, hwif->channel, port);
-		goto out;
-	}
-
-	/* Get this drive's _ADR info. if not already known. */
-=======
->>>>>>> FETCH_HEAD:drivers/ide/ide-acpi.c
 	if (!drive->acpidata->obj_handle) {
 		DEBPRINT("No ACPI object found for %s\n", drive->name);
 		goto out;
diff -puN drivers/ide/via82cxxx.c~linux-next-git-rejects drivers/ide/via82cxxx.c
--- a/drivers/ide/via82cxxx.c~linux-next-git-rejects
+++ a/drivers/ide/via82cxxx.c
@@ -443,7 +443,6 @@ static int __devinit via_init_one(struct
 	if ((via_config->flags & VIA_NO_UNMASK) == 0)
 		d.host_flags |= IDE_HFLAG_UNMASK_IRQS;
 
-<<<<<<< HEAD:drivers/ide/via82cxxx.c
 #ifdef CONFIG_PPC_CHRP
 	if (machine_is(chrp) && _chrp_type == _CHRP_Pegasos)
 		d.host_flags |= IDE_HFLAG_FORCE_LEGACY_IRQS;
@@ -454,8 +453,6 @@ static int __devinit via_init_one(struct
 		d.host_flags |= IDE_HFLAG_FORCE_LEGACY_IRQS;
 #endif
 
-=======
->>>>>>> FETCH_HEAD:drivers/ide/via82cxxx.c
 	d.udma_mask = via_config->udma_mask;
 
 	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kernel-asyncc-fix-printk-warnings.patch
revert-rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch
hp-wmi-fix-error-path-in-hp_wmi_bios_setup.patch
wait-prevent-exclusive-waiter-starvation-checkpatch-fixes.patch
sxc-fix-missed-unlock_kernel-on-error-path-in-sx_fw_ioctl-fix.patch
i-need-old-gcc.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
kvm-unbork.patch
fix-sparseirq-use-kstat_irqs_cpu-on-non-x86-architectures-too.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
x86-define-arch_want_frame_pointers-fix.patch
kernel-auditscc-fix-warning.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
sysfs-reference-sysfs_dirent-from-sysfs-inodes-fix.patch
early-platform-driver-v3-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage-checkpatch-fixes.patch
mtd-rbtx4939-add-mtd-support-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
pci-constify-pci_bus_assign_resources.patch
pci-constify-pci_bus_add_devices.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-ata-sata_silc-needs-dmih.patch
net-dont-use-in_atomic-in-gfp_any.patch
documentation-connector-cn_testc-dont-use-gfp_any.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
do_pipe-drop-its-last-user-in-arch-alpha-checkpatch-fixes.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
drivers-video-uvesafbc-dont-use-gfp_any.patch
cirrusfb-convert-printks-to-dev_foo-fix.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
nbd-add-locking-to-nbd_ioctl-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-mcheck-mce_amd_64c-avoid-using-work_on_cpu.patch
work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

