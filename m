From: akpm@osdl.org
Subject: - x86-fix-vdso-mapping-for-aout-executables-doh.patch removed from -mm tree
Date: Mon, 29 Jan 2007 00:56:36 -0800
Message-ID: <200701290856.l0T8uatE016144@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54467 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933283AbXA2I4w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 03:56:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, ak@suse.de, benh@kernel.crashing.org, joerg@hydrops.han.de, lethal@linux-sh.org, parag.warudkar@gmail.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     x86-fix-vdso-mapping-for-aout-executables-doh
has been removed from the -mm tree.  Its filename was
     x86-fix-vdso-mapping-for-aout-executables-doh.patch

This patch was dropped because it was folded into x86-fix-vdso-mapping-for-aout-executables.patch

------------------------------------------------------
Subject: x86-fix-vdso-mapping-for-aout-executables-doh
From: Andrew Morton <akpm@osdl.org>

Cc: Parag Warudkar <parag.warudkar@gmail.com>
Cc: Joerg Ahrens <joerg@hydrops.han.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/ia32/syscall32.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/ia32/syscall32.c~x86-fix-vdso-mapping-for-aout-executables-doh arch/x86_64/ia32/syscall32.c
--- a/arch/x86_64/ia32/syscall32.c~x86-fix-vdso-mapping-for-aout-executables-doh
+++ a/arch/x86_64/ia32/syscall32.c
@@ -11,6 +11,8 @@
 #include <linux/stringify.h>
 #include <linux/security.h>
 #include <linux/interp.h>
+#include <linux/module.h>
+
 #include <asm/proto.h>
 #include <asm/tlbflush.h>
 #include <asm/ia32_unistd.h>
@@ -59,7 +61,7 @@ const char *arch_vma_name(struct vm_area
 
 int arch_setup_additional_pages(struct linux_binprm *bprm, int exstack)
 {
-	return syscall32_setup_pages(bprm, int exstack);
+	return syscall32_setup_pages(bprm, exstack);
 }
 EXPORT_SYMBOL(arch_setup_additional_pages);
 
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
m68k-uaccessh-needs-schedh.patch
x86-fix-vdso-mapping-for-aout-executables.patch
x86-fix-vdso-mapping-for-aout-executables-doh.patch
x86-fix-vdso-mapping-for-aout-executables-sh-fix.patch
mm-show-bounce-pages-in-oom-killer-output.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
exit-acpi-processor-module-gracefully-if-acpi-is-disabled-tidy.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
agpgart-allow-drm-populated-agp-memory-types-tidy.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-2.patch
powerpc-make-it-compile.patch
git-dvb.patch
dvb-video_buf-depends-on-pci.patch
git-gfs2-nmw.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-ieee1394.patch
git-ieee1494-build-fix.patch
git-input.patch
git-libata-all.patch
pata_platform-set_mode-fix.patch
sata_nv-cleanup-adma-error-handling-v2-cleanup.patch
mm-ide-ide-acpi-support-warning-fix.patch
git-lxdialog-fixup.patch
git-mips-kconfig-fix.patch
git-mips-prom_free_prom_memory-borkage.patch
git-mmc.patch
git-mmc-fixup.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-fixup.patch
git-netdev-all-atl1-build-fix.patch
git-netdev-all-atl1-pm-fix.patch
82596-warning-fix.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
bonding-replace-kmalloc-memset-pairs-with-the-appropriate-kzalloc-calls-fix.patch
dccp-warning-fixes.patch
netfilter-warning-fix.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
nfs-fix-congestion-control-v4-tweaks.patch
r8169-warning-fixes.patch
make-cardbus_mem_size-and-cardbus_io_size-boot-options-fix.patch
sh-add-kconfig-default.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
fix-gregkh-usb-usbcore-remove-unused-bandwith-related-code.patch
nokia-e70-is-an-unusual-device.patch
revert-x86_64-mm-msr-on-cpu.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix-fix.patch
arch-i386-kernel-alternativec-dont-include-bugsh.patch
touchkit-ps-2-touchscreen-driver.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
avoid-excessive-sorting-of-early_node_map-tidy.patch
proc-zoneinfo-fix-vm-stats-display.patch
use-zvc-for-inactive-and-active-counts-up-fix.patch
drop-free_pages-fix.patch
drop-free_pages-sparc64-fix.patch
get_dirty_limits-accurately-calculate-the-available-memory-that-can-be-dirtied-fix.patch
optional-zone_dma-in-the-vm-tidy.patch
swsusp-change-code-ordering-in-userc-sanity.patch
deprecate-smbfs-in-favour-of-cifs.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
add-retain_initrd-boot-option-tweak.patch
count_vm_events-warning-fix.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
consolidate-line-discipline-number-definitions-v2-sparc-fix.patch
consolidate-line-discipline-number-definitions-v2-fix-2.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix-2.patch
remove-invalidate_inode_pages.patch
add-an-rcu-version-of-list-splicing-fix.patch
factor-outstanding-i-o-error-handling-tidy.patch
sync_sb_inodes-propagate-errors.patch
block_write_full_page-handle-enospc.patch
sysctl-warning-fix.patch
proc_misc-warning-fix.patch
rtc-framework-driver-for-cmos-rtcs-fix.patch
rtc-framework-driver-for-cmos-rtcs-fix-2.patch
return-enoent-from-ext3_link-when-racing-with-unlink-fix.patch
spi-controller-driver-for-omap-microwire-tidy.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
vmi-versus-hrtimers.patch
add-a-functions-to-handle-interrupt-affinity-setting-alpha-fix.patch
i386-use-gtod-persistent-clock-support.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i383-drivers.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
aio-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
omap-gpio-wrappers-tidy.patch
at91-gpio-wrappers-tidy.patch
ecryptfs-public-key-packet-management-slab-fix.patch
ecryptfs-generalize-metadata-read-write-fix.patch
aio-is-unlikely.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
introduce-and-use-get_task_mnt_ns-tweaks.patch
user-ns-implement-user-ns-unshare-tidy.patch
ipc-namespace-remove-config_ipc_ns-linkage-fix.patch
ipc-namespace-remove-config_ipc_ns-linkage-fix-fix.patch
dynamic-kernel-command-line-ia64-fix.patch
rcu-preemptible-rcu-fix.patch
readahead-kconfig-options-fix.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-nfsd-case-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-temp-fix.patch
reiser4-kmem_cache_t-removal.patch
reiser4-test_clear_page_dirty.patch
reiser4-vs-git-block.patch
reiser4-vs-git-block-2.patch
cyber2010-framebuffer-on-arm-netwinder-fix-tidy.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
slim-main-include-fix.patch
mark-struct-file_operations-const-2-fix.patch
mark-struct-file_operations-const-4-fix.patch
scheduled-removal-of-sa_xxx-interrupt-flags-ata-fix.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support-fix.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry-warning-fix.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl-warning-fix.patch
sysctl-reimplement-the-sysctl-proc-support-warning-fix.patch
sysctl-reimplement-the-sysctl-proc-support-fix-2.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-ntfs-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch
