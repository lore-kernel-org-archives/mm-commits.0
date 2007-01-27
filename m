From: akpm@osdl.org
Subject: + add-a-functions-to-handle-interrupt-affinity-setting-alpha-fix.patch added to -mm tree
Date: Fri, 26 Jan 2007 22:55:39 -0800
Message-ID: <200701270656.l0R6uTnk003990@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42975 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbXA0G5B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Jan 2007 01:57:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org


The patch titled
     add-a-functions-to-handle-interrupt-affinity-setting alpha fix
has been added to the -mm tree.  Its filename is
     add-a-functions-to-handle-interrupt-affinity-setting-alpha-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add-a-functions-to-handle-interrupt-affinity-setting alpha fix
From: Andrew Morton <akpm@osdl.org>

kernel/irq/manage.c: In function 'irq_set_affinity':
kernel/irq/manage.c:75: error: invalid type argument of '->'
kernel/irq/manage.c:76: error: invalid type argument of '->'

nfi why.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/irq/manage.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/irq/manage.c~add-a-functions-to-handle-interrupt-affinity-setting-alpha-fix kernel/irq/manage.c
--- a/kernel/irq/manage.c~add-a-functions-to-handle-interrupt-affinity-setting-alpha-fix
+++ a/kernel/irq/manage.c
@@ -72,8 +72,8 @@ int irq_set_affinity(unsigned int irq, c
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	set_pending_irq(irq, cpumask);
 #else
-	irq_desc[irq]->affinity = cpumask;
-	irq_desc[irq]->chip->set_affinity(irq, cpumask);
+	desc->affinity = cpumask;
+	desc->chip->set_affinity(irq, cpumask);
 #endif
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
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
git-dvb.patch
git-gfs2-nmw.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-ieee1394.patch
git-input.patch
git-libata-all.patch
sata_nv-cleanup-adma-error-handling-v2-cleanup.patch
mm-ide-ide-acpi-support-warning-fix.patch
git-lxdialog-fixup.patch
git-mmc.patch
git-mmc-fixup.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-fixup.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
bonding-replace-kmalloc-memset-pairs-with-the-appropriate-kzalloc-calls-fix.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
nfs-fix-congestion-control-v4-tweaks.patch
r8169-warning-fixes.patch
make-cardbus_mem_size-and-cardbus_io_size-boot-options-fix.patch
git-scsi-misc-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-block-fixup.patch
git-block-borkage.patch
git-block-atomicity-fix.patch
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
return-enoent-from-ext3_link-when-racing-with-unlink-fix.patch
spi-controller-driver-for-omap-microwire-tidy.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
vmi-versus-hrtimers.patch
add-a-functions-to-handle-interrupt-affinity-setting-alpha-fix.patch
i386-use-gtod-persistent-clock-support.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i383-drivers.patch
hrt-dynticks-hotplug-fix-fix.patch
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
kblockd-use-flush_work.patch
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
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine-gfs2-fix.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix.patch
aio-is-unlikely.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
introduce-and-use-get_task_mnt_ns-tweaks.patch
user-ns-implement-user-ns-unshare-tidy.patch
ipc-namespace-remove-config_ipc_ns-linkage-fix.patch
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
mark-struct-file_operations-const-4-fix.patch
scheduled-removal-of-sa_xxx-interrupt-flags-ata-fix.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support-fix.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl-warning-fix.patch
sysctl-reimplement-the-sysctl-proc-support-warning-fix.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-hack.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-ntfs-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64-fix.patch
local_t-alpha-extension-fix.patch
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
