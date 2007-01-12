From: akpm@osdl.org
Subject: - fd_zero-build-fix.patch removed from -mm tree
Date: Fri, 12 Jan 2007 14:18:23 -0800
Message-ID: <200701122218.l0CMINhf030788@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39130 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161149AbXALWTN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jan 2007 17:19:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, ink@jurassic.park.msu.ru, jsipek@cs.sunysb.edu, paulus@samba.org, rth@twiddle.net, schwidefsky@de.ibm.com, tony.luck@intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     FD_ZERO build fix
has been removed from the -mm tree.  Its filename was
     fd_zero-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: FD_ZERO build fix
From: Andrew Morton <akpm@osdl.org>

unionfs managed to hit this on s390.  Some architectures use __ptr_t in their
FD_ZERO implementation.  We don't have a __ptr_t.  Switch them over to plain
old void*.

Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-alpha/posix_types.h   |    2 +-
 include/asm-ia64/posix_types.h    |    2 +-
 include/asm-powerpc/posix_types.h |    2 +-
 include/asm-s390/posix_types.h    |    2 +-
 include/asm-xtensa/posix_types.h  |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/asm-alpha/posix_types.h~fd_zero-build-fix include/asm-alpha/posix_types.h
--- a/include/asm-alpha/posix_types.h~fd_zero-build-fix
+++ a/include/asm-alpha/posix_types.h
@@ -49,7 +49,7 @@ typedef unsigned int	__kernel_old_dev_t;
 #define	__FD_CLR(d, set)	((set)->fds_bits[__FDELT(d)] &= ~__FDMASK(d))
 #define	__FD_ISSET(d, set)	(((set)->fds_bits[__FDELT(d)] & __FDMASK(d)) != 0)
 #define	__FD_ZERO(set)	\
-  ((void) memset ((__ptr_t) (set), 0, sizeof (__kernel_fd_set)))
+  ((void) memset ((void *) (set), 0, sizeof (__kernel_fd_set)))
 
 #else /* __GNUC__ */
 
diff -puN include/asm-ia64/posix_types.h~fd_zero-build-fix include/asm-ia64/posix_types.h
--- a/include/asm-ia64/posix_types.h~fd_zero-build-fix
+++ a/include/asm-ia64/posix_types.h
@@ -54,7 +54,7 @@ typedef unsigned int	__kernel_old_dev_t;
 #define	__FD_CLR(d, set)	((set)->fds_bits[__FDELT(d)] &= ~__FDMASK(d))
 #define	__FD_ISSET(d, set)	(((set)->fds_bits[__FDELT(d)] & __FDMASK(d)) != 0)
 #define	__FD_ZERO(set)	\
-  ((void) memset ((__ptr_t) (set), 0, sizeof (__kernel_fd_set)))
+  ((void) memset ((void *) (set), 0, sizeof (__kernel_fd_set)))
 
 #  else /* !__GNUC__ */
 
diff -puN include/asm-powerpc/posix_types.h~fd_zero-build-fix include/asm-powerpc/posix_types.h
--- a/include/asm-powerpc/posix_types.h~fd_zero-build-fix
+++ a/include/asm-powerpc/posix_types.h
@@ -60,7 +60,7 @@ typedef struct {
 #define	__FD_CLR(d, set)	((set)->fds_bits[__FDELT(d)] &= ~__FDMASK(d))
 #define	__FD_ISSET(d, set)	(((set)->fds_bits[__FDELT(d)] & __FDMASK(d)) != 0)
 #define	__FD_ZERO(set)	\
-  ((void) memset ((__ptr_t) (set), 0, sizeof (__kernel_fd_set)))
+  ((void) memset ((void *) (set), 0, sizeof (__kernel_fd_set)))
 
 #else /* __GNUC__ */
 
diff -puN include/asm-s390/posix_types.h~fd_zero-build-fix include/asm-s390/posix_types.h
--- a/include/asm-s390/posix_types.h~fd_zero-build-fix
+++ a/include/asm-s390/posix_types.h
@@ -104,7 +104,7 @@ static inline int __FD_ISSET(unsigned lo
 
 #undef  __FD_ZERO
 #define __FD_ZERO(fdsetp) \
-	((void) memset ((__ptr_t) (fdsetp), 0, sizeof (__kernel_fd_set)))
+	((void) memset ((void *) (fdsetp), 0, sizeof (__kernel_fd_set)))
 
 #endif     /* __KERNEL__ */
 
diff -puN include/asm-xtensa/posix_types.h~fd_zero-build-fix include/asm-xtensa/posix_types.h
--- a/include/asm-xtensa/posix_types.h~fd_zero-build-fix
+++ a/include/asm-xtensa/posix_types.h
@@ -60,7 +60,7 @@ typedef struct {
 #define	__FD_CLR(d, set)	((set)->fds_bits[__FDELT(d)] &= ~__FDMASK(d))
 #define	__FD_ISSET(d, set)	((set)->fds_bits[__FDELT(d)] & __FDMASK(d))
 #define	__FD_ZERO(set)	\
-  ((void) memset ((__ptr_t) (set), 0, sizeof (__kernel_fd_set)))
+  ((void) memset ((void *) (set), 0, sizeof (__kernel_fd_set)))
 
 #else /* __GNUC__ */
 
_

Patches currently in -mm which might be from akpm@osdl.org are

kvm-add-vm-exit-profiling-fix.patch
blockdev-direct_io-fix-signedness-bug.patch
submitchecklist-update.patch
tlclk-bug-fix-misc-fixes-tidy.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
exit-acpi-processor-module-gracefully-if-acpi-is-disabled-tidy.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
agpgart-allow-drm-populated-agp-memory-types-tidy.patch
cifs-sprintf-fix.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-2.patch
fix-gregkh-driver-driver-core-fix-race-in-sysfs-between-sysfs_remove_file-and-read-write.patch
git-dvb.patch
git-gfs2-nmw.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-ieee1394.patch
git-input.patch
git-libata-all.patch
libata-piix3-support-warning-fix.patch
git-lxdialog-fixup.patch
git-mmc.patch
git-mtd.patch
git-ubi.patch
ubi-missing-include.patch
ubi-printk-fix.patch
git-netdev-all.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-use-bitrev8.patch
bonding-replace-kmalloc-memset-pairs-with-the-appropriate-kzalloc-calls-fix.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
r8169-warning-fixes.patch
git-scsi-rc-fixes.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-block-fixup.patch
git-block-atomicity-fix.patch
nokia-e70-is-an-unusual-device.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix-fix.patch
touchkit-ps-2-touchscreen-driver.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
avoid-excessive-sorting-of-early_node_map-tidy.patch
proc-zoneinfo-fix-vm-stats-display.patch
swsusp-change-code-ordering-in-userc-sanity.patch
deprecate-smbfs-in-favour-of-cifs.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
ecryptfs-public-key-packet-management-slab-fix.patch
add-retain_initrd-boot-option-tweak.patch
count_vm_events-warning-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
consolidate-line-discipline-number-definitions-v2-sparc-fix.patch
consolidate-line-discipline-number-definitions-v2-fix-2.patch
spi-controller-driver-for-omap-microwire-tidy.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix-2.patch
remove-invalidate_inode_pages.patch
add-an-rcu-version-of-list-splicing-fix.patch
factor-outstanding-i-o-error-handling-tidy.patch
sync_sb_inodes-propagate-errors.patch
block_write_full_page-handle-enospc.patch
sysctl-warning-fix.patch
proc_misc-warning-fix.patch
vmi-versus-hrtimers.patch
gtod-persistent-clock-support-i386.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i386-drivers.patch
debugging-feature-proc-timer_list-warning-fix.patch
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
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix.patch
aio-is-unlikely.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
user-ns-implement-user-ns-unshare-tidy.patch
user-ns-always-on.patch
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
hpt3xx-rework-rate-filtering-tidy.patch
jmicron-warning-fix.patch
cyber2010-framebuffer-on-arm-netwinder-fix-tidy.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
slim-main-include-fix.patch
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
