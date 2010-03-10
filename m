From: akpm@linux-foundation.org
Subject: [to-be-updated] sysctl-clean-up-vm-related-variable-declarations.patch removed from -mm tree
Date: Wed, 10 Mar 2010 12:30:12 -0800
Message-ID: <201003102030.o2AKUCpI001960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757031Ab0CJUaX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 15:30:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: clean up vm related variable declarations
has been removed from the -mm tree.  Its filename was
     sysctl-clean-up-vm-related-variable-declarations.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: clean up vm related variable declarations
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Presently there are many "extern" declaration in kernel/sysctl.c. 
"extern" declaration in *.c file is not appreciated in general.  And
Hmm...it seems there are a few redundant declarations.

Because most of sysctl variables are defined in its own header file, they
should be declared in the same style, be done in its own *.h file.

This patch removes some VM(memory management) related sysctl's variable
declaration from kernel/sysctl.c and move them to proper places.

[rientjes@google.com: #ifdef fixlet]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h     |    5 +++++
 include/linux/mmzone.h |    1 +
 include/linux/oom.h    |    5 +++++
 kernel/sysctl.c        |   16 ++--------------
 mm/mmap.c              |    5 +++++
 5 files changed, 18 insertions(+), 14 deletions(-)

diff -puN include/linux/mm.h~sysctl-clean-up-vm-related-variable-declarations include/linux/mm.h
--- a/include/linux/mm.h~sysctl-clean-up-vm-related-variable-declarations
+++ a/include/linux/mm.h
@@ -1412,6 +1412,7 @@ int in_gate_area_no_task(unsigned long a
 #define in_gate_area(task, addr) ({(void)task; in_gate_area_no_task(addr);})
 #endif	/* __HAVE_ARCH_GATE_AREA */
 
+extern int sysctl_drop_caches;
 int drop_caches_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
 unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
@@ -1463,5 +1464,9 @@ extern int soft_offline_page(struct page
 
 extern void dump_page(struct page *page);
 
+#ifndef CONFIG_MMU
+extern int sysctl_nr_trim_pages;
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff -puN include/linux/mmzone.h~sysctl-clean-up-vm-related-variable-declarations include/linux/mmzone.h
--- a/include/linux/mmzone.h~sysctl-clean-up-vm-related-variable-declarations
+++ a/include/linux/mmzone.h
@@ -749,6 +749,7 @@ int min_free_kbytes_sysctl_handler(struc
 extern int sysctl_lowmem_reserve_ratio[MAX_NR_ZONES-1];
 int lowmem_reserve_ratio_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
+extern int percpu_pagelist_fraction; /* for sysctl */
 int percpu_pagelist_fraction_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
 int sysctl_min_unmapped_ratio_sysctl_handler(struct ctl_table *, int,
diff -puN include/linux/oom.h~sysctl-clean-up-vm-related-variable-declarations include/linux/oom.h
--- a/include/linux/oom.h~sysctl-clean-up-vm-related-variable-declarations
+++ a/include/linux/oom.h
@@ -43,5 +43,10 @@ static inline void oom_killer_enable(voi
 {
 	oom_killer_disabled = false;
 }
+/* for sysctl */
+extern int sysctl_panic_on_oom;
+extern int sysctl_oom_kill_allocating_task;
+extern int sysctl_oom_dump_tasks;
+
 #endif /* __KERNEL__*/
 #endif /* _INCLUDE_LINUX_OOM_H */
diff -puN kernel/sysctl.c~sysctl-clean-up-vm-related-variable-declarations kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-clean-up-vm-related-variable-declarations
+++ a/kernel/sysctl.c
@@ -39,6 +39,8 @@
 #include <linux/hugetlb.h>
 #include <linux/initrd.h>
 #include <linux/key.h>
+#include <linux/mman.h>
+#include <linux/oom.h>
 #include <linux/times.h>
 #include <linux/limits.h>
 #include <linux/dcache.h>
@@ -73,11 +75,6 @@
 /* External variables not in a header file. */
 extern int C_A_D;
 extern int print_fatal_signals;
-extern int sysctl_overcommit_memory;
-extern int sysctl_overcommit_ratio;
-extern int sysctl_panic_on_oom;
-extern int sysctl_oom_kill_allocating_task;
-extern int sysctl_oom_dump_tasks;
 extern int max_threads;
 extern int core_uses_pid;
 extern int suid_dumpable;
@@ -86,14 +83,9 @@ extern unsigned int core_pipe_limit;
 extern int pid_max;
 extern int min_free_kbytes;
 extern int pid_max_min, pid_max_max;
-extern int sysctl_drop_caches;
-extern int percpu_pagelist_fraction;
 extern int compat_log;
 extern int latencytop_enabled;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
-#ifndef CONFIG_MMU
-extern int sysctl_nr_trim_pages;
-#endif
 #ifdef CONFIG_RCU_TORTURE_TEST
 extern int rcutorture_runnable;
 #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
@@ -204,10 +196,6 @@ extern struct ctl_table inotify_table[];
 extern struct ctl_table epoll_table[];
 #endif
 
-#ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
-int sysctl_legacy_va_layout;
-#endif
-
 extern int prove_locking;
 extern int lock_stat;
 
diff -puN mm/mmap.c~sysctl-clean-up-vm-related-variable-declarations mm/mmap.c
--- a/mm/mmap.c~sysctl-clean-up-vm-related-variable-declarations
+++ a/mm/mmap.c
@@ -87,6 +87,11 @@ int sysctl_overcommit_ratio = 50;	/* def
 int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
 struct percpu_counter vm_committed_as;
 
+#ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
+/* Used by each architecture's private code and sysctl. */
+int sysctl_legacy_va_layout;
+#endif
+
 /*
  * Check that a process has enough memory to allocate a new virtual
  * mapping. 0 means there is enough memory for the allocation to
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

nommu-fix-build-breakage.patch
devmem-dont-allow-seek-to-last-page.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
drivers-char-memc-cleanups-fix-fix.patch
cgroup-introduce-cancel_attach.patch
cgroup-introduce-coalesce-css_get-and-css_put.patch
cgroups-revamp-subsys-array.patch
cgroups-subsystem-module-loading-interface.patch
cgroups-subsystem-module-loading-interface-fix.patch
cgroups-subsystem-module-unloading.patch
cgroups-net_cls-as-module.patch
cgroups-blkio-subsystem-as-module.patch
cgroups-clean-up-cgroup_pidlist_find-a-bit.patch
memcg-add-interface-to-move-charge-at-task-migration.patch
memcg-move-charges-of-anonymous-page.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-improve-performance-in-moving-charge.patch
memcg-avoid-oom-during-moving-charge.patch
memcg-move-charges-of-anonymous-swap.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-move-charges-of-anonymous-swap-fix-3.patch
memcg-move-charges-of-anonymous-swap-fix-3-fix.patch
memcg-improve-performance-in-moving-swap-charge.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-fixes.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-fixes-fix.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
memcg-implement-memory-thresholds-checkpatch-fixes-fix.patch
memcg-implement-memory-thresholds-check-if-first-threshold-crossed.patch
memcg-typo-in-comment-to-mem_cgroup_print_oom_info.patch
memcg-use-generic-percpu-instead-of-private-implementation.patch
memcg-update-threshold-and-softlimit-at-commit-v2.patch
memcg-share-event-counter-rather-than-duplicate-v2.patch
memcg-update-memcg_testtxt.patch
memcg-handle-panic_on_oom=always-case-v2.patch
cgroups-fix-race-between-userspace-and-kernelspace.patch
cgroups-add-simple-listener-of-cgroup-events-to-documentation.patch
cgroups-add-simple-listener-of-cgroup-events-to-documentation-fix.patch
memcg-update-memcg_testtxt-to-describe-memory-thresholds.patch
memcg-fix-oom-kill-behavior-v3.patch
memcg-fix-oom-kill-behavior-v4.patch
memcg-update-maintainer-list.patch
linux-next.patch
memory-hotplug-allow-setting-of-phys_device.patch
memory-hotplug-s390-set-phys_device.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
sysctl-clean-up-vm-related-variable-declarations.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch

