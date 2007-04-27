From: akpm@linux-foundation.org
Subject: - smaps-add-clear_refs-file-to-clear-reference-fix.patch removed from -mm tree
Date: Fri, 27 Apr 2007 01:12:37 -0700
Message-ID: <200704270812.l3R8Cba3023000@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755497AbXD0IM5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 04:12:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, clameter@sgi.com, hugh@veritas.com, lethal@linux-sh.org, oleg@tv-sign.ru, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     smaps-add-clear_refs-file-to-clear-reference-fix
has been removed from the -mm tree.  Its filename was
     smaps-add-clear_refs-file-to-clear-reference-fix.patch

This patch was dropped because it was folded into smaps-add-clear_refs-file-to-clear-reference.patch

------------------------------------------------------
Subject: smaps-add-clear_refs-file-to-clear-reference-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Hugh Dickins <hugh@veritas.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c          |    7 ++++++-
 fs/proc/task_mmu.c      |    8 ++++++--
 include/linux/proc_fs.h |    2 +-
 3 files changed, 13 insertions(+), 4 deletions(-)

diff -puN fs/proc/base.c~smaps-add-clear_refs-file-to-clear-reference-fix fs/proc/base.c
--- a/fs/proc/base.c~smaps-add-clear_refs-file-to-clear-reference-fix
+++ a/fs/proc/base.c
@@ -720,6 +720,7 @@ static ssize_t clear_refs_write(struct f
 {
 	struct task_struct *task;
 	char buffer[PROC_NUMBUF], *end;
+	struct mm_struct *mm;
 
 	memset(buffer, 0, sizeof(buffer));
 	if (count > sizeof(buffer) - 1)
@@ -733,7 +734,11 @@ static ssize_t clear_refs_write(struct f
 	task = get_proc_task(file->f_path.dentry->d_inode);
 	if (!task)
 		return -ESRCH;
-	clear_refs_smap(task->mm->mmap);
+	mm = get_task_mm(task);
+	if (mm) {
+		clear_refs_smap(mm);
+		mmput(mm);
+	}
 	put_task_struct(task);
 	if (end - buffer == 0)
 		return -EIO;
diff -puN fs/proc/task_mmu.c~smaps-add-clear_refs-file-to-clear-reference-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~smaps-add-clear_refs-file-to-clear-reference-fix
+++ a/fs/proc/task_mmu.c
@@ -350,11 +350,15 @@ static int show_smap(struct seq_file *m,
 	return show_map_internal(m, v, &mss);
 }
 
-void clear_refs_smap(struct vm_area_struct *vma)
+void clear_refs_smap(struct mm_struct *mm)
 {
-	for (; vma; vma = vma->vm_next)
+	struct vm_area_struct *vma;
+
+	down_read(&mm->mmap_sem);
+	for (vma = mm->mmap; vma; vma = vma->vm_next)
 		if (vma->vm_mm && !is_vm_hugetlb_page(vma))
 			for_each_pmd(vma, clear_refs_one_pmd, NULL);
+	up_read(&mm->mmap_sem);
 }
 
 static void *m_start(struct seq_file *m, loff_t *pos)
diff -puN include/linux/proc_fs.h~smaps-add-clear_refs-file-to-clear-reference-fix include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~smaps-add-clear_refs-file-to-clear-reference-fix
+++ a/include/linux/proc_fs.h
@@ -104,7 +104,7 @@ int proc_pid_readdir(struct file * filp,
 unsigned long task_vsize(struct mm_struct *);
 int task_statm(struct mm_struct *, int *, int *, int *, int *);
 char *task_mem(struct mm_struct *, char *);
-void clear_refs_smap(struct vm_area_struct *);
+void clear_refs_smap(struct mm_struct *mm);
 
 extern struct proc_dir_entry *create_proc_entry(const char *name, mode_t mode,
 						struct proc_dir_entry *parent);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

slab-introduce-krealloc.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-agpgart.patch
git-agp-build-fix.patch
git-cpufreq-borkage-fix.patch
git-powerpc.patch
ppc4xx_sgdma-needs-dma_mappingh.patch
revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed.patch
fix-gregkh-driver-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
define-platform-wakeup-hook-use-in-pci_enable_wake.patch
dev_dbg-check-dev_dbg-arguments.patch
sysfs-binc-printk-fix.patch
git-drm.patch
git-dvb.patch
git-dvb-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
fix-jdelvare-i2c-i2c-del-driver-returns-void-on-powerpc.patch
git-gfs2-nmw.patch
gfs2-printk-warning-fixes.patch
git-ieee1394.patch
sbp2-include-fixes.patch
fw-device-printk-fix.patch
ieee1394-iso-needs-schedh.patch
git-input.patch
git-input-fixup.patch
git-kvm.patch
git-libata-all.patch
ata-printk-warning-fixes.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-build-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-mtd.patch
git-mtd-build-fix.patch
git-ubi.patch
git-ubi-fixup.patch
revert-gitpowerpc-ehea-changes.patch
git-netdev-all.patch
reapply-gitpowerpc-ehea-changes.patch
git-netdev-all-export-ieee80211_debug_level.patch
vioc-warning-fix.patch
vioc-cast-warning-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-net.patch
git-net-fixup.patch
git-net-vs-git-netdev-all.patch
sctp-fix-sctp_getsockopt_local_addrs_old-to-use-local-storage-fix.patch
sctp_getsockopt_local_addrs-type-fix.patch
git-net-fix-yamc.patch
irda_device_dongle_init-fix-kzallocgfp_kernel-in-spinlock.patch
rfcomm_worker-fix-wakeup-race.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio.patch
git-ocfs2.patch
git-parisc.patch
rm9000-serial-driver.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-s390.patch
git-s390-fixup.patch
git-s390-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
s390-net-lcs-convert-to-the-kthread-api.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
fix-x86_64-mm-nmi-watchdog-ops.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
x86_64-unexport-cpu_llc_id.patch
xfs-clean-up-shrinker-games.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-add-proc-pid-pagemap-interface-fix-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
slab-mark-set_up_list3s-__init.patch
extend-print_symbol-capability-fix-fix.patch
slub-core-tidy.patch
slub-core-tidy-2.patch
slub-core-tidy-3.patch
slub-core-tidy-4.patch
slub-core-tidy-5.patch
slub-core-tidy-6.patch
slub-core-tidy-7.patch
slub-core-tidy-8.patch
slub-core-tidy-9.patch
slub-core-add-explanation-for-locking-fix.patch
slub-core-explain-sizing-of-slabs-in-detail-fix.patch
slub-core-more-statics.patch
slub-enable-tracking-of-full-slabs-fix.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
slub-user-documentation-fix.patch
mm-optimize-kill_bdev-fix.patch
lazy-freeing-of-memory-through-madv_free-fix.patch
lazy-freeing-of-memory-through-madv_free-sparc-fix.patch
lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
driver_bfin_serial_core-update.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix-fix.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
enlarge-console-name.patch
move-die-notifier-handling-to-common-code-fixes-2.patch
move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
parport-dev-driver-model-support-powerpc-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix-tidy.patch
add-support-for-deferrable-timers-respun-tidy.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
fix-kevents-childs-priority-greediness-fix.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount-fix.patch
enhance-initcall_debug-measure-latency-fix.patch
expose-range-checking-functions-from-arch-specific-update-fix.patch
pad-irq_desc-to-internode-cacheline-size-fix.patch
dtlk-fix-error-checks-in-module_init-fix.patch
document-spin_lock_unlocked-rw_lock_unlocked-deprecation-fix.patch
upper-32-bits.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
kthread-dont-depend-on-work-queues-take-2-fix.patch
fix-kthread_create-vs-freezer-theoretical-race-dont-be-obnoxious.patch
speedup-divides-by-cpu_power-in-scheduler.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-consolidate-sched_clock-drift-adjustments-fix.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
revert-rtc-add-rtc_merge_alarm.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix-fix-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-i386-optimization-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix-fix.patch
signal-timer-event-fds-v9-timerfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix-fix.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls-x86_64-fix.patch
x86-serial-convert-legacy-com-ports-to-platform-devices-fix.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-build-hack.patch
lguest-build-hack-2.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
reiser4-slab-allocators-remove-slab_debug_initial-flag.patch
fbdev-hecuba-framebuffer-driver.patch
vt-add-color-support-to-the-underline-and-italic-attributes-fix.patch
sm501fb-printk-warning-fixes.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
