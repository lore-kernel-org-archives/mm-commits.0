From: akpm@linux-foundation.org
Subject: - git-mips-git-rejects.patch removed from -mm tree
Date: Tue, 13 May 2008 14:23:55 -0700
Message-ID: <200805132123.m4DLNtcI000377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751747AbYEMVYI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:24:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     git-mips-git-rejects
has been removed from the -mm tree.  Its filename was
     git-mips-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-mips-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Probably wrong...

Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/au1000/common/dbg_io.c |    3 ---
 arch/mips/kernel/Makefile        |    6 ------
 arch/mips/kernel/traps.c         |   13 -------------
 arch/mips/mm/c-r4k.c             |    6 ------
 4 files changed, 28 deletions(-)

diff -puN arch/mips/kernel/Makefile~git-mips-git-rejects arch/mips/kernel/Makefile
--- a/arch/mips/kernel/Makefile~git-mips-git-rejects
+++ a/arch/mips/kernel/Makefile
@@ -4,15 +4,9 @@
 
 extra-y		:= head.o init_task.o vmlinux.lds
 
-<<<<<<< HEAD:arch/mips/kernel/Makefile
-obj-y		+= cpu-probe.o branch.o entry.o genex.o irq.o process.o \
-		   ptrace.o reset.o setup.o signal.o syscall.o \
-		   time.o topology.o traps.o unaligned.o
-=======
 obj-y		+= cpu-probe.o branch.o entry.o genex.o irq.o irq-gic.o \
 		   process.o ptrace.o reset.o semaphore.o setup.o signal.o \
 		   syscall.o time.o topology.o traps.o unaligned.o
->>>>>>> FETCH_HEAD:arch/mips/kernel/Makefile
 
 obj-$(CONFIG_CEVT_BCM1480)	+= cevt-bcm1480.o
 obj-$(CONFIG_CEVT_R4K)		+= cevt-r4k.o
diff -puN arch/mips/au1000/common/dbg_io.c~git-mips-git-rejects arch/mips/au1000/common/dbg_io.c
--- a/arch/mips/au1000/common/dbg_io.c~git-mips-git-rejects
+++ a/arch/mips/au1000/common/dbg_io.c
@@ -54,10 +54,7 @@ typedef         unsigned int  uint32;
 #define UART16550_READ(y)    (au_readl(DEBUG_BASE + y) & 0xff)
 #define UART16550_WRITE(y, z) (au_writel(z&0xff, DEBUG_BASE + y))
 
-<<<<<<< HEAD:arch/mips/au1000/common/dbg_io.c
-=======
 extern unsigned long get_au1x00_uart_baud_base(void);
->>>>>>> FETCH_HEAD:arch/mips/au1000/common/dbg_io.c
 extern unsigned long calc_clock(void);
 
 void debugInit(uint32 baud, uint8 data, uint8 parity, uint8 stop)
diff -puN arch/mips/kernel/traps.c~git-mips-git-rejects arch/mips/kernel/traps.c
--- a/arch/mips/kernel/traps.c~git-mips-git-rejects
+++ a/arch/mips/kernel/traps.c
@@ -196,21 +196,12 @@ EXPORT_SYMBOL(dump_stack);
 static void show_code(unsigned int __user *pc)
 {
 	long i;
-<<<<<<< HEAD:arch/mips/kernel/traps.c
-	unsigned short __user *pc16 = NULL;
-
-	printk("\nCode:");
-
-	if ((unsigned long)pc & 1)
-		pc16 = (unsigned short __user *)((unsigned long)pc & ~1);
-=======
 	unsigned short *pc16 = NULL;
 
 	printk("\nCode:");
 
 	if ((unsigned int)pc & 1)
 		pc16 = (unsigned short *)((unsigned int)pc & ~1);
->>>>>>> FETCH_HEAD:arch/mips/kernel/traps.c
 	for(i = -3 ; i < 6 ; i++) {
 		unsigned int insn;
 		if (pc16 ? __get_user(insn, pc16 + i) : __get_user(insn, pc + i)) {
@@ -1389,11 +1380,7 @@ int cp0_compare_irq;
 int cp0_perfcount_irq;
 EXPORT_SYMBOL_GPL(cp0_perfcount_irq);
 
-<<<<<<< HEAD:arch/mips/kernel/traps.c
-static int __cpuinitdata noulri;
-=======
 static int __initdata noulri;
->>>>>>> FETCH_HEAD:arch/mips/kernel/traps.c
 
 static int __init ulri_disable(char *s)
 {
diff -puN arch/mips/mm/c-r4k.c~git-mips-git-rejects arch/mips/mm/c-r4k.c
--- a/arch/mips/mm/c-r4k.c~git-mips-git-rejects
+++ a/arch/mips/mm/c-r4k.c
@@ -1227,11 +1227,8 @@ void au1x00_fixup_config_od(void)
 }
 
 static int __cpuinitdata cca = -1;
-<<<<<<< HEAD:arch/mips/mm/c-r4k.c
-=======
 unsigned long _page_cachable_default;
 EXPORT_SYMBOL_GPL(_page_cachable_default);
->>>>>>> FETCH_HEAD:arch/mips/mm/c-r4k.c
 
 static int __init cca_setup(char *str)
 {
@@ -1249,8 +1246,6 @@ static void __cpuinit coherency_setup(vo
 	_page_cachable_default = cca << _CACHE_SHIFT;
 
 	pr_debug("Using cache attribute %d\n", cca);
-<<<<<<< HEAD:arch/mips/mm/c-r4k.c
-=======
 
 	protection_map[0] = PAGE_NONE;
 	protection_map[1] = PAGE_READONLY;
@@ -1269,7 +1264,6 @@ static void __cpuinit coherency_setup(vo
 	protection_map[14] = PAGE_SHARED;
 	protection_map[15] = PAGE_SHARED;
 
->>>>>>> FETCH_HEAD:arch/mips/mm/c-r4k.c
 	change_c0_config(CONF_CM_CMASK, cca);
 
 	/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
revert-9p-convert-from-semaphore-to-spinlock.patch
ia64-kvm-dont-delete-files-which-we-need.patch
revert-acpica-fixes-for-unload-and-ddbhandles.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
arch-x86-mm-patc-use-boot_cpu_has.patch
x86-setup_force_cpu_cap-dont-do-clear_bitnon-unsigned-long.patch
lguest-use-cpu-capability-accessors.patch
x86-set_restore_sigmask-avoid-bitop-on-a-u32.patch
x86-early_init_centaur-use-set_cpu_cap.patch
x86-bitops-take-an-unsigned-long.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch
audit_send_reply-fix-error-path-memory-leak.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
zoran-use-correct-type-for-cpu-flags.patch
i2c-renesas-highlander-fpga-smbus-support.patch
ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware-ia64-warnings.patch
drivers-infiniband-hw-mlx4-qpc-fix-uninitialised-var-warning.patch
git-input.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
git-mips-git-rejects.patch
git-mmc.patch
mmc-sd-host-driver-for-ricoh-bay1controllers-fix.patch
mmc-sd-host-driver-for-ricoh-bay1controllers-fix-2.patch
git-ubifs.patch
git-net.patch
git-net-git-rejects.patch
hysdn-no-longer-broken-on-smp.patch
sundance-set-carrier-status-on-link-change-events.patch
dm9000-use-delayed-work-to-update-mii-phy-state-fix.patch
pcnet32-fix-warning.patch
drivers-net-tokenring-3c359c-squish-a-warning.patch
drivers-net-tokenring-olympicc-fix-warning.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
selinux-dopey-hack.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
revert-git-block.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch
git-unionfs.patch
git-unionfs-fixup.patch
unionfs-broke.patch
git-logfs-fixup.patch
drivers-uwb-nehc-processor-flags-have-type-unsigned-long.patch
drivers-usb-host-isp1760-hcdc-procesxor-flags-have-type-unsigned-long.patch
uwb-fix-scscanf-warning.patch
drivers-uwb-wlp-sysfsc-dead-code.patch
drivers-uwb-i1480-dfu-macc-fix-min-warning.patch
drivers-uwb-i1480-dfu-usbc-fix-size_t-confusion.patch
drivers-uwb-whcic-needs-dma-mappingh.patch
rndis-switch-to-seq_files-checkpatch-fixes.patch
git-v9fs.patch
revert-git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
git-orion-git-rejects.patch
ext4-is-busted-on-m68k.patch
common-implementation-of-iterative-div-mod-fix.patch
common-implementation-of-iterative-div-mod-checkpatch-fixes.patch
common-implementation-of-iterative-div-mod-fix-2.patch
mprotect-prevent-alteration-of-the-pat-bits-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
colibri-fix-support-for-dm9000-ethernet-device-fix.patch
mm-verify-the-page-links-and-memory-model-fix.patch
mm-verify-the-page-links-and-memory-model-fix-fix.patch
mspec-convert-nopfn-to-fault-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
kill-generic_file_direct_io-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha-hack.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
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

