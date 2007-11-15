From: akpm@linux-foundation.org
Subject: - revert-task-control-groups-example-cpu-accounting-subsystem.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:09:52 -0800
Message-ID: <200711152109.lAFL9qx5015495@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58264 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759507AbXKOVQz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:16:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, menage@google.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     revert "Task Control Groups: example CPU accounting subsystem"
has been removed from the -mm tree.  Its filename was
     revert-task-control-groups-example-cpu-accounting-subsystem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: revert "Task Control Groups: example CPU accounting subsystem"
From: Andrew Morton <akpm@linux-foundation.org>

Revert 62d0df64065e7c135d0002f069444fbdfc64768f. 

This was originally intended as a simple initial example of how to create a
control groups subsystem; it wasn't intended for mainline, but I didn't make
this clear enough to Andrew.

The CFS cgroup subsystem now has better functionality for the per-cgroup usage
accounting (based directly on CFS stats) than the "usage" status file in this
patch, and the "load" status file is rather simplistic - although having a
per-cgroup load average report would be a useful feature, I don't believe this
patch actually provides it.  If it gets into the final 2.6.24 we'd probably
have to support this interface for ever.

Cc: Paul Menage <menage@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup_subsys.h |    6 -
 include/linux/cpu_acct.h      |   14 --
 init/Kconfig                  |    7 -
 kernel/Makefile               |    1 
 kernel/cpu_acct.c             |  186 --------------------------------
 kernel/sched.c                |   14 --
 6 files changed, 3 insertions(+), 225 deletions(-)

diff -puN include/linux/cgroup_subsys.h~revert-task-control-groups-example-cpu-accounting-subsystem include/linux/cgroup_subsys.h
--- a/include/linux/cgroup_subsys.h~revert-task-control-groups-example-cpu-accounting-subsystem
+++ a/include/linux/cgroup_subsys.h
@@ -13,12 +13,6 @@ SUBSYS(cpuset)
 
 /* */
 
-#ifdef CONFIG_CGROUP_CPUACCT
-SUBSYS(cpuacct)
-#endif
-
-/* */
-
 #ifdef CONFIG_CGROUP_DEBUG
 SUBSYS(debug)
 #endif
diff -puN include/linux/cpu_acct.h~revert-task-control-groups-example-cpu-accounting-subsystem /dev/null
--- a/include/linux/cpu_acct.h
+++ /dev/null
@@ -1,14 +0,0 @@
-
-#ifndef _LINUX_CPU_ACCT_H
-#define _LINUX_CPU_ACCT_H
-
-#include <linux/cgroup.h>
-#include <asm/cputime.h>
-
-#ifdef CONFIG_CGROUP_CPUACCT
-extern void cpuacct_charge(struct task_struct *, cputime_t cputime);
-#else
-static void inline cpuacct_charge(struct task_struct *p, cputime_t cputime) {}
-#endif
-
-#endif
diff -puN init/Kconfig~revert-task-control-groups-example-cpu-accounting-subsystem init/Kconfig
--- a/init/Kconfig~revert-task-control-groups-example-cpu-accounting-subsystem
+++ a/init/Kconfig
@@ -301,13 +301,6 @@ config CGROUP_NS
           for instance virtual servers and checkpoint/restart
           jobs.
 
-config CGROUP_CPUACCT
-	bool "Simple CPU accounting cgroup subsystem"
-	depends on CGROUPS
-	help
-	  Provides a simple Resource Controller for monitoring the
-	  total CPU consumed by the tasks in a cgroup
-
 config CPUSETS
 	bool "Cpuset support"
 	depends on SMP && CGROUPS
diff -puN kernel/Makefile~revert-task-control-groups-example-cpu-accounting-subsystem kernel/Makefile
--- a/kernel/Makefile~revert-task-control-groups-example-cpu-accounting-subsystem
+++ a/kernel/Makefile
@@ -40,7 +40,6 @@ obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup.o
 obj-$(CONFIG_CGROUP_DEBUG) += cgroup_debug.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
-obj-$(CONFIG_CGROUP_CPUACCT) += cpu_acct.o
 obj-$(CONFIG_CGROUP_NS) += ns_cgroup.o
 obj-$(CONFIG_IKCONFIG) += configs.o
 obj-$(CONFIG_STOP_MACHINE) += stop_machine.o
diff -puN kernel/cpu_acct.c~revert-task-control-groups-example-cpu-accounting-subsystem /dev/null
--- a/kernel/cpu_acct.c
+++ /dev/null
@@ -1,186 +0,0 @@
-/*
- * kernel/cpu_acct.c - CPU accounting cgroup subsystem
- *
- * Copyright (C) Google Inc, 2006
- *
- * Developed by Paul Menage (menage@google.com) and Balbir Singh
- * (balbir@in.ibm.com)
- *
- */
-
-/*
- * Example cgroup subsystem for reporting total CPU usage of tasks in a
- * cgroup, along with percentage load over a time interval
- */
-
-#include <linux/module.h>
-#include <linux/cgroup.h>
-#include <linux/fs.h>
-#include <linux/rcupdate.h>
-
-#include <asm/div64.h>
-
-struct cpuacct {
-	struct cgroup_subsys_state css;
-	spinlock_t lock;
-	/* total time used by this class */
-	cputime64_t time;
-
-	/* time when next load calculation occurs */
-	u64 next_interval_check;
-
-	/* time used in current period */
-	cputime64_t current_interval_time;
-
-	/* time used in last period */
-	cputime64_t last_interval_time;
-};
-
-struct cgroup_subsys cpuacct_subsys;
-
-static inline struct cpuacct *cgroup_ca(struct cgroup *cont)
-{
-	return container_of(cgroup_subsys_state(cont, cpuacct_subsys_id),
-			    struct cpuacct, css);
-}
-
-static inline struct cpuacct *task_ca(struct task_struct *task)
-{
-	return container_of(task_subsys_state(task, cpuacct_subsys_id),
-			    struct cpuacct, css);
-}
-
-#define INTERVAL (HZ * 10)
-
-static inline u64 next_interval_boundary(u64 now)
-{
-	/* calculate the next interval boundary beyond the
-	 * current time */
-	do_div(now, INTERVAL);
-	return (now + 1) * INTERVAL;
-}
-
-static struct cgroup_subsys_state *cpuacct_create(
-	struct cgroup_subsys *ss, struct cgroup *cont)
-{
-	struct cpuacct *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
-
-	if (!ca)
-		return ERR_PTR(-ENOMEM);
-	spin_lock_init(&ca->lock);
-	ca->next_interval_check = next_interval_boundary(get_jiffies_64());
-	return &ca->css;
-}
-
-static void cpuacct_destroy(struct cgroup_subsys *ss,
-			    struct cgroup *cont)
-{
-	kfree(cgroup_ca(cont));
-}
-
-/* Lazily update the load calculation if necessary. Called with ca locked */
-static void cpuusage_update(struct cpuacct *ca)
-{
-	u64 now = get_jiffies_64();
-
-	/* If we're not due for an update, return */
-	if (ca->next_interval_check > now)
-		return;
-
-	if (ca->next_interval_check <= (now - INTERVAL)) {
-		/* If it's been more than an interval since the last
-		 * check, then catch up - the last interval must have
-		 * been zero load */
-		ca->last_interval_time = 0;
-		ca->next_interval_check = next_interval_boundary(now);
-	} else {
-		/* If a steal takes the last interval time negative,
-		 * then we just ignore it */
-		if ((s64)ca->current_interval_time > 0)
-			ca->last_interval_time = ca->current_interval_time;
-		else
-			ca->last_interval_time = 0;
-		ca->next_interval_check += INTERVAL;
-	}
-	ca->current_interval_time = 0;
-}
-
-static u64 cpuusage_read(struct cgroup *cont, struct cftype *cft)
-{
-	struct cpuacct *ca = cgroup_ca(cont);
-	u64 time;
-
-	spin_lock_irq(&ca->lock);
-	cpuusage_update(ca);
-	time = cputime64_to_jiffies64(ca->time);
-	spin_unlock_irq(&ca->lock);
-
-	/* Convert 64-bit jiffies to seconds */
-	time *= 1000;
-	do_div(time, HZ);
-	return time;
-}
-
-static u64 load_read(struct cgroup *cont, struct cftype *cft)
-{
-	struct cpuacct *ca = cgroup_ca(cont);
-	u64 time;
-
-	/* Find the time used in the previous interval */
-	spin_lock_irq(&ca->lock);
-	cpuusage_update(ca);
-	time = cputime64_to_jiffies64(ca->last_interval_time);
-	spin_unlock_irq(&ca->lock);
-
-	/* Convert time to a percentage, to give the load in the
-	 * previous period */
-	time *= 100;
-	do_div(time, INTERVAL);
-
-	return time;
-}
-
-static struct cftype files[] = {
-	{
-		.name = "usage",
-		.read_uint = cpuusage_read,
-	},
-	{
-		.name = "load",
-		.read_uint = load_read,
-	}
-};
-
-static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cont)
-{
-	return cgroup_add_files(cont, ss, files, ARRAY_SIZE(files));
-}
-
-void cpuacct_charge(struct task_struct *task, cputime_t cputime)
-{
-
-	struct cpuacct *ca;
-	unsigned long flags;
-
-	if (!cpuacct_subsys.active)
-		return;
-	rcu_read_lock();
-	ca = task_ca(task);
-	if (ca) {
-		spin_lock_irqsave(&ca->lock, flags);
-		cpuusage_update(ca);
-		ca->time = cputime64_add(ca->time, cputime);
-		ca->current_interval_time =
-			cputime64_add(ca->current_interval_time, cputime);
-		spin_unlock_irqrestore(&ca->lock, flags);
-	}
-	rcu_read_unlock();
-}
-
-struct cgroup_subsys cpuacct_subsys = {
-	.name = "cpuacct",
-	.create = cpuacct_create,
-	.destroy = cpuacct_destroy,
-	.populate = cpuacct_populate,
-	.subsys_id = cpuacct_subsys_id,
-};
diff -puN kernel/sched.c~revert-task-control-groups-example-cpu-accounting-subsystem kernel/sched.c
--- a/kernel/sched.c~revert-task-control-groups-example-cpu-accounting-subsystem
+++ a/kernel/sched.c
@@ -52,7 +52,6 @@
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
 #include <linux/percpu.h>
-#include <linux/cpu_acct.h>
 #include <linux/kthread.h>
 #include <linux/seq_file.h>
 #include <linux/sysctl.h>
@@ -3338,13 +3337,9 @@ void account_user_time(struct task_struc
 {
 	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
 	cputime64_t tmp;
-	struct rq *rq = this_rq();
 
 	p->utime = cputime_add(p->utime, cputime);
 
-	if (p != rq->idle)
-		cpuacct_charge(p, cputime);
-
 	/* Add user time to cpustat. */
 	tmp = cputime_to_cputime64(cputime);
 	if (TASK_NICE(p) > 0)
@@ -3408,10 +3403,9 @@ void account_system_time(struct task_str
 		cpustat->irq = cputime64_add(cpustat->irq, tmp);
 	else if (softirq_count())
 		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
-	else if (p != rq->idle) {
+	else if (p != rq->idle)
 		cpustat->system = cputime64_add(cpustat->system, tmp);
-		cpuacct_charge(p, cputime);
-	} else if (atomic_read(&rq->nr_iowait) > 0)
+	else if (atomic_read(&rq->nr_iowait) > 0)
 		cpustat->iowait = cputime64_add(cpustat->iowait, tmp);
 	else
 		cpustat->idle = cputime64_add(cpustat->idle, tmp);
@@ -3447,10 +3441,8 @@ void account_steal_time(struct task_stru
 			cpustat->iowait = cputime64_add(cpustat->iowait, tmp);
 		else
 			cpustat->idle = cputime64_add(cpustat->idle, tmp);
-	} else {
+	} else
 		cpustat->steal = cputime64_add(cpustat->steal, tmp);
-		cpuacct_charge(p, -tmp);
-	}
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
file-capabilities-allow-sigcont-within-session-v2.patch
fix-boot-problem-with-iseries-lacking-hugepage-support-fix.patch
revert-keyspan-init-termios-properly.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200-fix.patch
acpi-add-reboot-mechanism.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
agk-dm-dm-ioctl-move-compat-code-fix.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc-fix.patch
git-drm-oops-fix.patch
git-dvb.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
elantech-touchpad-driver-fix.patch
cscope-build-warning.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
ide-arm-hack.patch
git-mmc.patch
git-mtd.patch
git-netdev-all.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
bluetooth-uninlining.patch
nfs-stop-sillyname-renames-and-unmounts-from-racing.patch
nfs-stop-sillyname-renames-and-unmounts-from-racing-fix.patch
nfs-stop-sillyname-renames-and-unmounts-from-racing-fix-fix.patch
git-nfsd-fixup.patch
quirk_vialatency-omit-reading-pci-revision-id-checkpatch-fixes.patch
git-s390.patch
fix-build-breakage-if-sysfs-fix.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
scsi-gdth-kill-unneeded-irq-argument-checkpatch-fixes.patch
scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers-checkpatch-fixes.patch
bidi-support-scsi_data_buffer-broke-qla1280.patch
bidi-support-scsi_data_buffer-broke-lots-of-stuff.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
git-wireless.patch
jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
git-ipwireless_cs.patch
git-x86.patch
git-x86-broke-lguest.patch
git-x86-broke-xen-too.patch
git-x86-inlining-borkage.patch
oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes.patch
i386-and-x86_64-randomize-brk-fix.patch
x86-arch_register_cpu-section-fix.patch
x86_64-configure-stack-size-fix.patch
git-cryptodev.patch
x86-early_quirks-cleanup.patch
ia64-increase-datapatch-offset.patch
ia64-dont-assume-that-unwcheckpy-is-executable.patch
ia64-export-copy_page-to-modules.patch
ia64-export-copy_page-to-modules-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
maps4-rework-task_size-macros-mips-fix.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
alpha-atomic_add_return-should-return-int.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
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
read_current_time-cleanups-build-fix-fix.patch
sync_sb_inodes-propagate-errors.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
64-bit-i_version-afs-fixes.patch
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
memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
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
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-ia64-fix.patch
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
