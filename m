From: akpm@linux-foundation.org
Subject: + linux-next-rejects.patch added to -mm tree
Date: Thu, 24 Jul 2008 16:16:06 -0700
Message-ID: <200807242316.m6ONG6X3010132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755852AbYGXXQf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:16:35 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m6ONG6OP030458
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2008 16:16:07 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-rejects
has been added to the -mm tree.  Its filename is
     linux-next-rejects.patch

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
Subject: linux-next-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide-cd.c    |   11 -----------
 drivers/ide/ide-probe.c |   28 ----------------------------
 include/linux/mlx4/qp.h |    6 ------
 3 files changed, 45 deletions(-)

diff -puN drivers/ide/ide-cd.c~linux-next-rejects drivers/ide/ide-cd.c
--- a/drivers/ide/ide-cd.c~linux-next-rejects
+++ a/drivers/ide/ide-cd.c
@@ -1318,28 +1318,17 @@ static int cdrom_read_capacity(ide_drive
 	 * Sanity check the given block size
 	 */
 	switch (capbuf.blocklen) {
-<<<<<<< HEAD:drivers/ide/ide-cd.c
 	case __constant_cpu_to_be32(512):
 	case __constant_cpu_to_be32(1024):
 	case __constant_cpu_to_be32(2048):
 	case __constant_cpu_to_be32(4096):
-=======
-	case 512:
-	case 1024:
-	case 2048:
-	case 4096:
->>>>>>> FETCH_HEAD:drivers/ide/ide-cd.c
 		break;
 	default:
 		printk(KERN_ERR "%s: weird block size %u\n",
 			drive->name, capbuf.blocklen);
 		printk(KERN_ERR "%s: default to 2kb block size\n",
 			drive->name);
-<<<<<<< HEAD:drivers/ide/ide-cd.c
 		capbuf.blocklen = __constant_cpu_to_be32(2048);
-=======
-		capbuf.blocklen = 2048;
->>>>>>> FETCH_HEAD:drivers/ide/ide-cd.c
 		break;
 	}
 
diff -puN drivers/ide/ide-probe.c~linux-next-rejects drivers/ide/ide-probe.c
--- a/drivers/ide/ide-probe.c~linux-next-rejects
+++ a/drivers/ide/ide-probe.c
@@ -153,11 +153,7 @@ static inline void do_identify (ide_driv
 	if (strstr(m, "E X A B Y T E N E S T"))
 		goto err_misc;
 
-<<<<<<< HEAD:drivers/ide/ide-probe.c
-	printk(KERN_INFO "%s: %s, ", drive->name, id->model);
-=======
 	printk(KERN_INFO "%s: %s, ", drive->name, m);
->>>>>>> FETCH_HEAD:drivers/ide/ide-probe.c
 
 	drive->present = 1;
 	drive->dead = 0;
@@ -166,26 +162,15 @@ static inline void do_identify (ide_driv
 	 * Check for an ATAPI device
 	 */
 	if (cmd == WIN_PIDENTIFY) {
-<<<<<<< HEAD:drivers/ide/ide-probe.c
-		u8 type = (id->config >> 8) & 0x1f;
-=======
 		u8 type = (id[ATA_ID_CONFIG] >> 8) & 0x1f;
->>>>>>> FETCH_HEAD:drivers/ide/ide-probe.c
 
 		printk(KERN_CONT "ATAPI ");
 		switch (type) {
 			case ide_floppy:
-<<<<<<< HEAD:drivers/ide/ide-probe.c
-				if (!strstr(id->model, "CD-ROM")) {
-					if (!strstr(id->model, "oppy") &&
-					    !strstr(id->model, "poyp") &&
-					    !strstr(id->model, "ZIP"))
-=======
 				if (!strstr(m, "CD-ROM")) {
 					if (!strstr(m, "oppy") &&
 					    !strstr(m, "poyp") &&
 					    !strstr(m, "ZIP"))
->>>>>>> FETCH_HEAD:drivers/ide/ide-probe.c
 						printk(KERN_CONT "cdrom or floppy?, assuming ");
 					if (drive->media != ide_cdrom) {
 						printk(KERN_CONT "FLOPPY");
@@ -199,12 +184,7 @@ static inline void do_identify (ide_driv
 				drive->removable = 1;
 #ifdef CONFIG_PPC
 				/* kludge for Apple PowerBook internal zip */
-<<<<<<< HEAD:drivers/ide/ide-probe.c
-				if (!strstr(id->model, "CD-ROM") &&
-				    strstr(id->model, "ZIP")) {
-=======
 				if (!strstr(m, "CD-ROM") && strstr(m, "ZIP")) {
->>>>>>> FETCH_HEAD:drivers/ide/ide-probe.c
 					printk(KERN_CONT "FLOPPY");
 					type = ide_floppy;
 					break;
@@ -244,11 +224,7 @@ static inline void do_identify (ide_driv
 	drive->media = ide_disk;
 
 	printk(KERN_CONT "%s DISK drive\n",
-<<<<<<< HEAD:drivers/ide/ide-probe.c
-		(id->config == 0x848a) ? "CFA" : "ATA");
-=======
 		(id[ATA_ID_CONFIG] == 0x848a) ? "CFA" : "ATA");
->>>>>>> FETCH_HEAD:drivers/ide/ide-probe.c
 
 	return;
 
@@ -546,12 +522,8 @@ static void enable_nest (ide_drive_t *dr
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	u8 stat;
 
-<<<<<<< HEAD:drivers/ide/ide-probe.c
-	printk(KERN_INFO "%s: enabling %s -- ", hwif->name, drive->id->model);
-=======
 	printk(KERN_INFO "%s: enabling %s -- ",
 		hwif->name, (char *)&drive->id[ATA_ID_PROD]);
->>>>>>> FETCH_HEAD:drivers/ide/ide-probe.c
 
 	SELECT_DRIVE(drive);
 	msleep(50);
diff -puN fs/pipe.c~linux-next-rejects fs/pipe.c
diff -puN include/linux/mlx4/qp.h~linux-next-rejects include/linux/mlx4/qp.h
--- a/include/linux/mlx4/qp.h~linux-next-rejects
+++ a/include/linux/mlx4/qp.h
@@ -264,13 +264,7 @@ struct mlx4_wqe_fmr_ext_seg {
 
 struct mlx4_wqe_local_inval_seg {
 	__be32			flags;
-<<<<<<< HEAD:include/linux/mlx4/qp.h
-	u32			reserved1;
 	__be32			mem_key;
-	u32			reserved2[2];
-=======
-	__be32			mem_key;
->>>>>>> FETCH_HEAD:include/linux/mlx4/qp.h
 	__be32			guest_id;
 	__be64			pa;
 };
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arm-fix-fls-for-64-bit-arguments.patch
linux-next.patch
linux-next-rejects.patch
next-remove-localversion.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
pci-make-pci_register_driver-a-macro.patch
drivers-mfd-tc6393xbc-doesnt-compile-on-i386.patch
arch-mips-kernel-stacktracec-heiko-cant-type.patch
git-acpi.patch
x86-pci-replace-dbg-with-pr_debug-fix.patch
x86-pci-replace-dbg-with-pr_debug-fix-2.patch
include-asm-generic-pgtable-nopmdh-macros-are-noxious-reason-435.patch
arch-x86-pci-i386c-fix-printk-warnings.patch
git-arm-master.patch
git-cifs.patch
drm-fix-sparc64-build.patch
i2c-renesas-highlander-fpga-smbus-support.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
git-input.patch
git-jg-misc.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
git-kvm.patch
git-mtd.patch
bridge-send-correct-mtu-value-in-pmtu-checkpatch-fixes.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
git-nfsd.patch
git-sh.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
drivers-net-wireless-iwlwifi-iwl-ledc-printk-fix.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
ftrace-disable-function-tracing-bringing-up-new-cpu-fix.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
build-kernel-profileo-only-when-requested-cleanups.patch
seq_file-fix-bug-when-seq_read-reads-nothing-fix.patch
exec-remove-some-includes-fix.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
drivers-misc-hpiloc-needs-config_pci.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support-fix.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support-fix-fix.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support-fix-fix-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
eink_apollofb-new-driver-for-apollo-eink-controller-cleanup.patch
eink_apollofb-new-driver-for-apollo-eink-controller-fix.patch
eink_apollofb-new-driver-for-apollo-eink-controller-fix-fix-2.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup.patch
ext3-handle-corrupted-orphan-list-at-mount-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup-fix.patch
ext3-handle-deleting-corrupted-indirect-blocks-fix.patch
jbd-dont-abort-if-flushing-file-data-failed-fix.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-fix.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-checkpatch-fixes.patch
devcgroup-code-cleanup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-limit-change-shrink-usage-checkpatch-fixes.patch
coredump-format_corename-fix-the-core_uses_pid-logic-checkpatch-fixes.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-s2io.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-pasemi_mac.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sdhci-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-infiniband.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-more-sparc.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-ibmvscsi.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary-checkpatch-fixes.patch
tpm-increase-size-of-internal-tpm-response-buffers-checkpatch-fixes.patch
memstick-allow-set_param-method-to-return-an-error-code-checkpatch-fixes.patch
memstick-use-fully-asynchronous-request-processing-fix.patch
full-conversion-to-early_initcall-interface-remove-old-interface-cleanup.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
gru-driver-v3-hardware-data-structures-fix.patch
gru-driver-v3-hardware-data-structures-fix-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
mm-speculative-page-references-fix-add_to_page_cache-fix.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
define-page_file_cache-function-fix.patch
vmscan-split-lru-lists-into-anon-file-sets-units-fix.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-page-statistics-units-fix.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
introduce-__get_user_pages-fix.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
slb-drop-kmem-cache-argument-from-constructor-ubifs.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
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

