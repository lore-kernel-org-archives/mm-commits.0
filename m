From: akpm@linux-foundation.org
Subject: + next-fix-rejects.patch added to -mm tree
Date: Fri, 30 May 2008 14:58:10 -0700
Message-ID: <200805302158.m4ULwAjc013298@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752436AbYE3V6N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 17:58:13 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m4ULwApn024199
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 30 May 2008 14:58:11 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     next-fix-rejects
has been added to the -mm tree.  Its filename is
     next-fix-rejects.patch

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
Subject: next-fix-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/init.c                |    3 ---
 drivers/usb/misc/Kconfig           |    3 ---
 drivers/usb/misc/isight_firmware.c |    4 ----
 include/linux/device.h             |    4 ----
 kernel/sched_fair.c                |    5 -----
 5 files changed, 19 deletions(-)

diff -puN arch/s390/mm/init.c~next-fix-rejects arch/s390/mm/init.c
--- a/arch/s390/mm/init.c~next-fix-rejects
+++ a/arch/s390/mm/init.c
@@ -72,8 +72,6 @@ void show_mem(void)
 	printk("%ld reserved pages\n", reserved);
 	printk("%ld pages shared\n", shared);
 	printk("%ld pages swap cached\n", cached);
-<<<<<<< HEAD:arch/s390/mm/init.c
-=======
 	printk("%lu pages dirty\n", global_page_state(NR_FILE_DIRTY));
 	printk("%lu pages writeback\n", global_page_state(NR_WRITEBACK));
 	printk("%lu pages mapped\n", global_page_state(NR_FILE_MAPPED));
@@ -81,7 +79,6 @@ void show_mem(void)
 	       global_page_state(NR_SLAB_RECLAIMABLE) +
 	       global_page_state(NR_SLAB_UNRECLAIMABLE));
 	printk("%lu pages pagetables\n", global_page_state(NR_PAGETABLE));
->>>>>>> FETCH_HEAD:arch/s390/mm/init.c
 }
 
 /*
diff -puN drivers/usb/misc/Kconfig~next-fix-rejects drivers/usb/misc/Kconfig
--- a/drivers/usb/misc/Kconfig~next-fix-rejects
+++ a/drivers/usb/misc/Kconfig
@@ -280,8 +280,6 @@ config USB_ISIGHTFW
 	  The firmware for this driver must be extracted from the MacOS
 	  driver beforehand. Tools for doing so are available at
 	  http://bersace03.free.fr
-<<<<<<< HEAD:drivers/usb/misc/Kconfig
-=======
 
 config USB_GOTEMP
 	tristate "GoTemp USB thermometer driver support"
@@ -292,4 +290,3 @@ config USB_GOTEMP
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called gotemp.
->>>>>>> FETCH_HEAD:drivers/usb/misc/Kconfig
diff -puN drivers/usb/misc/isight_firmware.c~next-fix-rejects drivers/usb/misc/isight_firmware.c
--- a/drivers/usb/misc/isight_firmware.c~next-fix-rejects
+++ a/drivers/usb/misc/isight_firmware.c
@@ -41,11 +41,7 @@ static int isight_firmware_load(struct u
 	const struct firmware *firmware;
 	unsigned char *buf;
 	unsigned char data[4];
-<<<<<<< HEAD:drivers/usb/misc/isight_firmware.c
-	char *ptr;
-=======
 	const u8 *ptr;
->>>>>>> FETCH_HEAD:drivers/usb/misc/isight_firmware.c
 
 	if (request_firmware(&firmware, "isight.fw", &dev->dev) != 0) {
 		printk(KERN_ERR "Unable to load isight firmware\n");
diff -puN include/linux/device.h~next-fix-rejects include/linux/device.h
--- a/include/linux/device.h~next-fix-rejects
+++ a/include/linux/device.h
@@ -420,11 +420,7 @@ static inline const char *dev_name(struc
 }
 
 extern int dev_set_name(struct device *dev, const char *name, ...)
-<<<<<<< HEAD:include/linux/device.h
-			__attribute__((format(printf, 2, 3)));
-=======
 			    __attribute__((format(printf, 2, 3)));
->>>>>>> FETCH_HEAD:include/linux/device.h
 
 #ifdef CONFIG_NUMA
 static inline int dev_to_node(struct device *dev)
diff -puN kernel/sched_fair.c~next-fix-rejects kernel/sched_fair.c
--- a/kernel/sched_fair.c~next-fix-rejects
+++ a/kernel/sched_fair.c
@@ -609,10 +609,6 @@ place_entity(struct cfs_rq *cfs_rq, stru
 
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
-<<<<<<< HEAD:kernel/sched_fair.c
-		if (sched_feat(NEW_FAIR_SLEEPERS))
-			vruntime -= sysctl_sched_latency;
-=======
 		if (sched_feat(NEW_FAIR_SLEEPERS)) {
 			unsigned long thresh = sysctl_sched_latency;
 
@@ -624,7 +620,6 @@ place_entity(struct cfs_rq *cfs_rq, stru
 
 			vruntime -= thresh;
 		}
->>>>>>> FETCH_HEAD:kernel/sched_fair.c
 
 		/* ensure we never gain time by being placed backwards. */
 		vruntime = max_vruntime(se->vruntime, vruntime);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
next-fix-rejects.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
fix-driver-core-add-device_create_vargs-and-device_create_drvdata.patch
kvm-is-busted-on-ia64.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
lguest-use-cpu-capability-accessors.patch
arch-x86-mm-patc-nopat-should-be-__init.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch
arch-powerpc-platforms-pseries-eeh_driverc-fix-warning.patch
arch-powerpc-platforms-pseries-eeh_driverc-fix-warning-checkpatch-fixes.patch
git-dvb.patch
zoran-use-correct-type-for-cpu-flags.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-hid.patch
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
svcrdma-fix-compile-warning-on-32-bit-platforms-checkpatch-fixes.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
sched-delete-dead-stuff.patch
sched-delete-dead-stuff-2.patch
git-scsi-misc-fix-scsi_dh-build-errors.patch
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
git-watchdog-git-rejects.patch
watchdog-pcwd-clean-up-unlocked_ioctl-usage-fix.patch
watchdog-wdt501-pci-clean-up-coding-style-and-switch-to-unlocked_ioctl-fix.patch
git-xtensa.patch
ext4-is-busted-on-m68k.patch
capabilities-remain-source-compatible-with-32-bit-raw-legacy-capability-support.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
kill-generic_file_direct_io-checkpatch-fixes.patch
use-generic_access_phys-for-dev-mem-mappings-fix.patch
spufs-use-the-new-vm_ops-access-fix.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch
mapping_set_error-add-unlikely.patch
huge-page-private-reservation-review-cleanups-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2-checkpatch-fixes.patch
pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2-checkpatch-fixes-cleanup.patch
pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2-checkpatch-fixes-cleanup-fix.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
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
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
jbd2-fix-race-between-jbd2_journal_try_to_free_buffers-and-jbd2-commit-transaction-cleanup.patch
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
linux-next-fixup.patch

