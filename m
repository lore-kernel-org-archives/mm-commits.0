From: akpm@linux-foundation.org
Subject: - next-fix-rejects.patch removed from -mm tree
Date: Tue, 27 May 2008 00:21:34 -0700
Message-ID: <200805270721.m4R7LYP3014526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60577 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754079AbYE0HVh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:21:37 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m4R7LZ8m009604
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 27 May 2008 00:21:36 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     next-fix-rejects
has been removed from the -mm tree.  Its filename was
     next-fix-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: next-fix-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/stop_machine.c |   21 ---------------------
 1 file changed, 21 deletions(-)

diff -puN kernel/stop_machine.c~next-fix-rejects kernel/stop_machine.c
--- a/kernel/stop_machine.c~next-fix-rejects
+++ a/kernel/stop_machine.c
@@ -85,20 +85,7 @@ static int stop_cpu(struct stop_machine_
 			}
 			ack_state();
 		}
-<<<<<<< HEAD:kernel/stop_machine.c
-		/* Yield in first stage: migration threads need to
-		 * help our sisters onto their CPUs. */
-		if (!prepared && !irqs_disabled)
-			yield();
-		cpu_relax();
-	}
-
-	/* Ack: we are exiting. */
-	smp_mb(); /* Must read state first. */
-	atomic_inc(&stopmachine_thread_ack);
-=======
 	} while (curstate < STOPMACHINE_EXIT);
->>>>>>> FETCH_HEAD:kernel/stop_machine.c
 
 	local_irq_enable();
 	do_exit(0);
@@ -116,19 +103,11 @@ int __stop_machine_run(int (*fn)(void *)
 	struct stop_machine_data active, idle;
 	struct task_struct **threads;
 
-<<<<<<< HEAD:kernel/stop_machine.c
-	/* Wait for them all to come to life. */
-	while (atomic_read(&stopmachine_thread_ack) != stopmachine_num_threads) {
-		yield();
-		cpu_relax();
-	}
-=======
 	active.fn = fn;
 	active.data = data;
 	active.fnret = 0;
 	idle.fn = chill;
 	idle.data = NULL;
->>>>>>> FETCH_HEAD:kernel/stop_machine.c
 
 	/* If they don't care which cpu fn runs on, just pick one. */
 	if (cpu == NR_CPUS)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-fix-rejects.patch
next-remove-localversion.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
fix-driver-core-add-device_create_vargs-and-device_create_drvdata.patch
kvm-is-busted-on-ia64.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
lguest-use-cpu-capability-accessors.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch
arch-powerpc-platforms-pseries-eeh_driverc-fix-warning.patch
arch-powerpc-platforms-pseries-eeh_driverc-fix-warning-checkpatch-fixes.patch
git-dvb.patch
zoran-use-correct-type-for-cpu-flags.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-hid.patch
drivers-infiniband-hw-mlx4-qpc-fix-uninitialised-var-warning.patch
git-input.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
git-kvm.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch
git-mmc.patch
mmc-sd-host-driver-for-ricoh-bay1controllers.patch
git-ubifs.patch
git-net-next.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
sched-delete-dead-stuff.patch
sched-delete-dead-stuff-2.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch
pktcdvd-push-bkl-down-into-driver-fix.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-logfs-fixup.patch
drivers-uwb-nehc-processor-flags-have-type-unsigned-long.patch
drivers-usb-host-isp1760-hcdc-procesxor-flags-have-type-unsigned-long.patch
drivers-uwb-wlp-sysfsc-dead-code.patch
drivers-uwb-whcic-needs-dma-mappingh.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues-fix.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues-fix-2.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
watchdog-pcwd-clean-up-unlocked_ioctl-usage-fix.patch
watchdog-wdt501-pci-clean-up-coding-style-and-switch-to-unlocked_ioctl-fix.patch
wireless-airo-waitbusy-wont-delay-checkpatch-fixes.patch
git-xtensa.patch
ext4-is-busted-on-m68k.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl-fix.patch
ata-acpi-hotplug-handle-bay-devices-in-dock-stations-cleanup.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
kill-generic_file_direct_io-checkpatch-fixes.patch
use-generic_access_phys-for-dev-mem-mappings-fix.patch
spufs-use-the-new-vm_ops-access-fix.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2-checkpatch-fixes.patch
pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2-checkpatch-fixes-cleanup.patch
pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2-checkpatch-fixes-cleanup-fix.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
build-kernel-profileo-only-when-requested-cleanups.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sparc32.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
reiser4.patch
reiser4-semaphore-fix.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

