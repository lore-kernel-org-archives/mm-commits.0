From: akpm@linux-foundation.org
Subject: + cfs-scheduler-warning-fixes.patch added to -mm tree
Date: Tue, 22 May 2007 16:03:01 -0700
Message-ID: <200705222306.l4MN6GQq011795@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59966 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756625AbXEVXHf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 19:07:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu


The patch titled
     cfs-scheduler-warning-fixes
has been added to the -mm tree.  Its filename is
     cfs-scheduler-warning-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cfs-scheduler-warning-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ia64:

kernel/sched_debug.c: In function `print_task':
kernel/sched_debug.c:40: warning: long long int format, long unsigned int arg (arg 6)
kernel/sched_debug.c:40: warning: long long int format, long unsigned int arg (arg 5)
kernel/sched_debug.c: In function `print_rq_runtime_sum':
kernel/sched_debug.c:96: warning: long long int format, s64 arg (arg 4)
kernel/sched_debug.c:96: warning: long long int format, s64 arg (arg 3)
kernel/sched_debug.c: In function `proc_sched_show_task':
kernel/sched_debug.c:215: warning: long long int format, long unsigned int arg (arg 4)
kernel/sched_debug.c:215: warning: long long int format, long unsigned int arg (arg 3)

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched_debug.c |    7 ++++---
 sysctl.c             |    0 
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN Documentation/kernel-parameters.txt~cfs-scheduler-warning-fixes Documentation/kernel-parameters.txt
diff -puN Documentation/sched-design-CFS.txt~cfs-scheduler-warning-fixes Documentation/sched-design-CFS.txt
diff -puN arch/i386/kernel/smpboot.c~cfs-scheduler-warning-fixes arch/i386/kernel/smpboot.c
diff -puN arch/i386/kernel/syscall_table.S~cfs-scheduler-warning-fixes arch/i386/kernel/syscall_table.S
diff -puN arch/i386/kernel/tsc.c~cfs-scheduler-warning-fixes arch/i386/kernel/tsc.c
diff -puN arch/ia64/kernel/setup.c~cfs-scheduler-warning-fixes arch/ia64/kernel/setup.c
diff -puN arch/mips/kernel/smp.c~cfs-scheduler-warning-fixes arch/mips/kernel/smp.c
diff -puN arch/sparc/kernel/smp.c~cfs-scheduler-warning-fixes arch/sparc/kernel/smp.c
diff -puN arch/sparc64/kernel/smp.c~cfs-scheduler-warning-fixes arch/sparc64/kernel/smp.c
diff -puN drivers/char/drm/radeon_cp.c~cfs-scheduler-warning-fixes drivers/char/drm/radeon_cp.c
diff -puN fs/proc/array.c~cfs-scheduler-warning-fixes fs/proc/array.c
diff -puN fs/proc/base.c~cfs-scheduler-warning-fixes fs/proc/base.c
diff -puN include/asm-generic/bitops/sched.h~cfs-scheduler-warning-fixes include/asm-generic/bitops/sched.h
diff -puN include/asm-i386/unistd.h~cfs-scheduler-warning-fixes include/asm-i386/unistd.h
diff -puN include/asm-x86_64/unistd.h~cfs-scheduler-warning-fixes include/asm-x86_64/unistd.h
diff -puN include/linux/hardirq.h~cfs-scheduler-warning-fixes include/linux/hardirq.h
diff -puN include/linux/sched.h~cfs-scheduler-warning-fixes include/linux/sched.h
diff -puN include/linux/topology.h~cfs-scheduler-warning-fixes include/linux/topology.h
diff -puN init/main.c~cfs-scheduler-warning-fixes init/main.c
diff -puN kernel/exit.c~cfs-scheduler-warning-fixes kernel/exit.c
diff -puN kernel/fork.c~cfs-scheduler-warning-fixes kernel/fork.c
diff -puN kernel/posix-cpu-timers.c~cfs-scheduler-warning-fixes kernel/posix-cpu-timers.c
diff -puN kernel/sched.c~cfs-scheduler-warning-fixes kernel/sched.c
diff -puN kernel/sched_debug.c~cfs-scheduler-warning-fixes kernel/sched_debug.c
--- a/kernel/sched_debug.c~cfs-scheduler-warning-fixes
+++ a/kernel/sched_debug.c
@@ -40,7 +40,8 @@ print_task(struct seq_file *m, struct rq
 	SEQ_printf(m, "%15s %5d %15Ld %13Ld %13Ld %9Ld %5d "
 		      "%15Ld %15Ld %15Ld %15Ld %15Ld\n",
 		p->comm, p->pid,
-		(long long)p->fair_key, (long long)p->fair_key - rq->fair_clock,
+		(long long)p->fair_key,
+		(long long)(p->fair_key - rq->fair_clock),
 		(long long)p->wait_runtime,
 		(long long)p->nr_switches,
 		p->prio,
@@ -94,7 +95,7 @@ static void print_rq_runtime_sum(struct 
 	spin_unlock_irqrestore(&rq->lock, flags);
 
 	SEQ_printf(m, "  .%-22s: %Ld\n", "wait_runtime_rq_sum",
-		wait_runtime_rq_sum);
+		(long long)wait_runtime_rq_sum);
 }
 
 static void print_cpu(struct seq_file *m, int cpu, u64 now)
@@ -212,7 +213,7 @@ void proc_sched_show_task(struct task_st
 
 		t0 = sched_clock();
 		t1 = sched_clock();
-		SEQ_printf(m, "%-25s:%20Ld\n", "clock-delta", (long long)t1-t0);
+		SEQ_printf(m, "%-25s:%20Ld\n", "clock-delta", (long long)(t1-t0));
 	}
 }
 
diff -puN kernel/sched_fair.c~cfs-scheduler-warning-fixes kernel/sched_fair.c
diff -puN kernel/sched_rt.c~cfs-scheduler-warning-fixes kernel/sched_rt.c
diff -puN kernel/sched_stats.h~cfs-scheduler-warning-fixes kernel/sched_stats.h
diff -puN kernel/sysctl.c~cfs-scheduler-warning-fixes kernel/sysctl.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa-fixup.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-cpufreq-fix.patch
8xx-mpc885ads-pcmcia-support-fix.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
driver-core-check-return-code-of-sysfs_create_link-fix.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
git-gfs2-nmw.patch
git-ia64.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-leds.patch
git-leds-fixup.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix-tidy.patch
ide-warning-fixes.patch
git-md-accel-build-fix.patch
git-mips-fixup.patch
git-mtd.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices-fix.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver-build-fix.patch
git-ubi.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-parisc.patch
pci-x-pci-express-read-control-interfaces-fix.patch
git-pciseg.patch
git-scsi-rc-fixes.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-unionfs.patch
fix-gregkh-usb-usb-r8a66597-hcd-host-controller-driver-for-r8a66597.patch
git-wireless.patch
arch-x86_64-vdso-vmac-needs-schedh.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch
x86_64-fix-smp_call_function_single-return-value.patch
xfs-clean-up-shrinker-games.patch
git-cryptodev.patch
x86_64-allocate-sparsemem-memmap-above-4g-fix.patch
simplify-cleanup_workqueue_thread-fix.patch
procfs-directory-entry-cleanup-fix.patch
capifunc-warning-fixes.patch
hardware-eicon-messagec-warning-fixes.patch
change-zonelist-order-v6-zonelist-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
create-the-zone_movable-zone-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-2.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-add-proc-pid-pagemap-interface.patch
fs-introduce-some-page-buffer-invariants-obnoxiousness.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
alpha-support-graphics-on-non-zero-pci-domains-fix-2.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
fuse-warning-fix.patch
vxfs-warning-fixes.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
pie-randomization-fix.patch
rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty-fix.patch
mpu401-warning-fixes.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support-fix.patch
i2o_cfg_passthru-cleanup-fix.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
nfsd-warning-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
lguest-the-host-code-borkages.patch
cfs-scheduler-vs-detach-schedh-from-mmh.patch
cfs-scheduler-warning-fixes.patch
reiser4.patch
reiser4-fix.patch
vdso-print-fatal-signals.patch
check_dirty_inode_list.patch
w1-build-fix.patch
