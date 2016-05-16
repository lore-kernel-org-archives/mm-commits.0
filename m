From: akpm@linux-foundation.org
Subject: + mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix-2.patch
 added to -mm tree
Date: Mon, 16 May 2016 15:33:03 -0700
Message-ID: <573a4a9f.JqCxXjWGvdTAbYAH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59060 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbcEPWdE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 May 2016 18:33:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, arnd@arndb.de, cl@linux.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix-2
has been added to the -mm tree.  Its filename is
     mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix-2

Arnd has reported:
In randconfig builds with sysfs, procfs and numa all disabled,
but SMP enabled, we now get a link error in the newly introduced
vmstat_refresh function:

mm/built-in.o: In function `vmstat_refresh':
:(.text+0x15c78): undefined reference to `vmstat_text'

vmstat_refresh is proc_fs specific so there is no reason to define it
when !CONFIG_PROC_FS.

Link: http://lkml.kernel.org/r/20160516142332.GL23146@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/vmstat.c~mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix-2 mm/vmstat.c
--- a/mm/vmstat.c~mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix-2
+++ a/mm/vmstat.c
@@ -1383,6 +1383,7 @@ static void refresh_vm_stats(struct work
 	refresh_cpu_vm_stats(true);
 }
 
+#ifdef CONFIG_PROC_FS
 int vmstat_refresh(struct ctl_table *table, int write,
 		   void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -1466,6 +1467,7 @@ static void vmstat_update(struct work_st
 		cpumask_set_cpu(smp_processor_id(), cpu_stat_off);
 	}
 }
+#endif
 
 /*
  * Switch off vmstat processing and then fold all the remaining differentials
_

Patches currently in -mm which might be from mhocko@suse.com are

include-linux-nodemaskh-create-next_node_in-helper-fix.patch
mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix-2.patch
mm-oom-move-gfp_nofs-check-to-out_of_memory.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path.patch
mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper.patch
mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper-clear-oom_reaper_list-before-clearing-tif_memdie.patch
vmscan-consider-classzone_idx-in-compaction_ready.patch
mm-compaction-change-compact_-constants-into-enum.patch
mm-compaction-cover-all-compaction-mode-in-compact_zone.patch
mm-compaction-distinguish-compact_deferred-from-compact_skipped.patch
mm-compaction-distinguish-between-full-and-partial-compact_complete.patch
mm-compaction-update-compaction_result-ordering.patch
mm-compaction-simplify-__alloc_pages_direct_compact-feedback-interface.patch
mm-compaction-abstract-compaction-feedback-to-helpers.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages-fix.patch
mm-oom-protect-costly-allocations-some-more.patch
mm-oom-protect-costly-allocations-some-more-fix.patch
mm-consider-compaction-feedback-also-for-costly-allocation.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders.patch
mm-oom-protect-costly-allocations-some-more-for-config_compaction.patch
mm-oom_reaper-hide-oom-reaped-tasks-from-oom-killer-more-carefully.patch
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context.patch
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix.patch
mm-make-mmap_sem-for-write-waits-killable-for-mm-syscalls.patch
mm-make-vm_mmap-killable.patch
mm-make-vm_munmap-killable.patch
mm-aout-handle-vm_brk-failures.patch
mm-elf-handle-vm_brk-error.patch
mm-make-vm_brk-killable.patch
mm-proc-make-clear_refs-killable.patch
mm-fork-make-dup_mmap-wait-for-mmap_sem-for-write-killable.patch
ipc-shm-make-shmem-attach-detach-wait-for-mmap_sem-killable.patch
vdso-make-arch_setup_additional_pages-wait-for-mmap_sem-for-write-killable.patch
coredump-make-coredump_wait-wait-for-mmap_sem-for-write-killable.patch
aio-make-aio_setup_ring-killable.patch
exec-make-exec-path-waiting-for-mmap_sem-killable.patch
prctl-make-pr_set_thp_disable-wait-for-mmap_sem-killable.patch
uprobes-wait-for-mmap_sem-for-write-killable.patch
drm-i915-make-i915_gem_mmap_ioctl-wait-for-mmap_sem-killable.patch
drm-radeon-make-radeon_mn_get-wait-for-mmap_sem-killable.patch
drm-amdgpu-make-amdgpu_mn_get-wait-for-mmap_sem-killable.patch

