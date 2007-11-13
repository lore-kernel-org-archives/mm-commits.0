From: akpm@linux-foundation.org
Subject: + x86-early_quirks-fix-build.patch added to -mm tree
Date: Mon, 12 Nov 2007 17:29:00 -0800
Message-ID: <200711130129.lAD1T0Jr019932@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36409 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755011AbXKMB3k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 20:29:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@suse.de, ezk@cs.sunysb.edu, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: early_quirks: fix build
has been added to the -mm tree.  Its filename is
     x86-early_quirks-fix-build.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: early_quirks: fix build
From: Andrew Morton <akpm@linux-foundation.org>

With CONFIG_ACPI=n:

arch/x86/kernel/setup_64.c: In function 'setup_arch':
arch/x86/kernel/setup_64.c:420: error: implicit declaration of function 'early_quirks'

because the early_quirks() declaraion is inside an ACPI header file.

Move it out of there and into include/asm-x86/pci.h and clean a few related
things up.

Cc: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/early-quirks.c |    1 +
 arch/x86/kernel/setup_32.c     |    3 +--
 arch/x86/kernel/setup_64.c     |    2 --
 include/asm-x86/acpi_32.h      |    2 --
 include/asm-x86/acpi_64.h      |    2 --
 include/asm-x86/pci.h          |    4 ++++
 6 files changed, 6 insertions(+), 8 deletions(-)

diff -puN include/asm-x86/acpi_32.h~x86-early_quirks-fix-build include/asm-x86/acpi_32.h
--- a/include/asm-x86/acpi_32.h~x86-early_quirks-fix-build
+++ a/include/asm-x86/acpi_32.h
@@ -79,8 +79,6 @@ int __acpi_release_global_lock(unsigned 
         :"=r"(n_hi), "=r"(n_lo)     \
         :"0"(n_hi), "1"(n_lo))
 
-extern void early_quirks(void);
-
 #ifdef CONFIG_ACPI
 extern int acpi_lapic;
 extern int acpi_ioapic;
diff -puN include/asm-x86/acpi_64.h~x86-early_quirks-fix-build include/asm-x86/acpi_64.h
--- a/include/asm-x86/acpi_64.h~x86-early_quirks-fix-build
+++ a/include/asm-x86/acpi_64.h
@@ -78,8 +78,6 @@ int __acpi_release_global_lock(unsigned 
         :"=r"(n_hi), "=r"(n_lo)     \
         :"0"(n_hi), "1"(n_lo))
 
-extern void early_quirks(void);
-
 #ifdef CONFIG_ACPI
 extern int acpi_lapic;
 extern int acpi_ioapic;
diff -puN include/asm-x86/pci.h~x86-early_quirks-fix-build include/asm-x86/pci.h
--- a/include/asm-x86/pci.h~x86-early_quirks-fix-build
+++ a/include/asm-x86/pci.h
@@ -40,8 +40,12 @@ static inline int pci_proc_domain(struct
 
 #ifdef CONFIG_PCI
 extern unsigned int pcibios_assign_all_busses(void);
+extern void early_quirks(void);
 #else
 #define pcibios_assign_all_busses()	0
+static inline void early_quirks(void)
+{
+}
 #endif
 #define pcibios_scan_all_fns(a, b)	0
 
diff -puN arch/x86/kernel/setup_32.c~x86-early_quirks-fix-build arch/x86/kernel/setup_32.c
--- a/arch/x86/kernel/setup_32.c~x86-early_quirks-fix-build
+++ a/arch/x86/kernel/setup_32.c
@@ -41,6 +41,7 @@
 #include <linux/edd.h>
 #include <linux/nodemask.h>
 #include <linux/kexec.h>
+#include <linux/pci.h>
 #include <linux/crash_dump.h>
 #include <linux/dmi.h>
 #include <linux/pfn.h>
@@ -732,9 +733,7 @@ void __init setup_arch(char **cmdline_p)
 	acpi_boot_table_init();
 #endif
 
-#ifdef CONFIG_PCI
 	early_quirks();
-#endif
 
 #ifdef CONFIG_ACPI
 	acpi_boot_init();
diff -puN arch/x86/kernel/setup_64.c~x86-early_quirks-fix-build arch/x86/kernel/setup_64.c
--- a/arch/x86/kernel/setup_64.c~x86-early_quirks-fix-build
+++ a/arch/x86/kernel/setup_64.c
@@ -408,9 +408,7 @@ void __init setup_arch(char **cmdline_p)
 	reserve_crashkernel();
 	paging_init();
 
-#ifdef CONFIG_PCI
 	early_quirks();
-#endif
 
 	/*
 	 * set this early, so we dont allocate cpu0
diff -puN arch/x86/kernel/early-quirks.c~x86-early_quirks-fix-build arch/x86/kernel/early-quirks.c
--- a/arch/x86/kernel/early-quirks.c~x86-early_quirks-fix-build
+++ a/arch/x86/kernel/early-quirks.c
@@ -12,6 +12,7 @@
 #include <linux/pci.h>
 #include <linux/acpi.h>
 #include <linux/pci_ids.h>
+
 #include <asm/pci-direct.h>
 #include <asm/dma.h>
 #include <asm/io_apic.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

uml-update-address-space-affected-by-pud_clear-checkpatch-fixes.patch
improve-cgroup-printks-fix.patch
proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks-checkpatch-fixes.patch
acpi-make-acpi_procfs-default-to-y.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200-fix.patch
acpi-add-reboot-mechanism.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
git-arm-fixup.patch
agk-dm-dm-ioctl-move-compat-code-fix.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc-fix.patch
git-dvb.patch
git-hwmon.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
elantech-touchpad-driver-fix.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
ide-arm-hack.patch
git-mtd.patch
lmc_ioctl-dont-return-with-locks-held-fix.patch
git-netdev-all.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
bluetooth-uninlining.patch
nfs-stop-sillyname-renames-and-unmounts-from-racing-checkpatch-fixes.patch
git-nfsd-fixup.patch
quirk_vialatency-omit-reading-pci-revision-id-checkpatch-fixes.patch
fix-build-breakage-if-sysfs-fix.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
scsi-gdth-kill-unneeded-irq-argument-checkpatch-fixes.patch
scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers-checkpatch-fixes.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
git-wireless.patch
jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
git-ipwireless_cs.patch
git-x86.patch
git-x86-fix-up.patch
git-x86-inlining-borkage.patch
oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes.patch
i386-and-x86_64-randomize-brk-fix.patch
x86-arch_register_cpu-section-fix.patch
mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
fix-64kb-blocksize-in-ext3-directories-checkpatch-fixes.patch
file-capabilities-allow-sigcont-within-session-v2-checkpatch-fixes.patch
x86-disable-preemption-in-delay_tsc.patch
tty-fix-network-driver-interactions-with-tcget-set-checkpatch-fixes.patch
x86-early_quirks-fix-build.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
cris-build-fixes-atomich-needs-compilerh-fix.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec-checkpatch-fixes.patch
cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two-checkpatch-fixes.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
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
sync_sb_inodes-propagate-errors.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
64-bit-i_version-afs-fixes.patch
ridiculous-ext3-costs-was-re-page-fault-costs.patch
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
suppress-aout-library-support-if-config_binfmt_aout-checkpatch-fixes.patch
usb-net2280-cant-have-a-function-called-checkpatch-fixes.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
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
