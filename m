From: akpm@linux-foundation.org
Subject: + sysctl-clean-up-vm-related-variable-declarations.patch added to -mm tree
Date: Wed, 03 Feb 2010 14:36:45 -0800
Message-ID: <201002032236.o13Maj2l023406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756539Ab0BCWhf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 17:37:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com


The patch titled
     sysctl: clean up vm related variable declarations
has been added to the -mm tree.  Its filename is
     sysctl-clean-up-vm-related-variable-declarations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1433,6 +1433,7 @@ int in_gate_area_no_task(unsigned long a
 #define in_gate_area(task, addr) ({(void)task; in_gate_area_no_task(addr);})
 #endif	/* __HAVE_ARCH_GATE_AREA */
 
+extern int sysctl_drop_caches;
 int drop_caches_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
 unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
@@ -1477,5 +1478,9 @@ extern int soft_offline_page(struct page
 
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
@@ -747,6 +747,7 @@ int min_free_kbytes_sysctl_handler(struc
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
@@ -68,11 +70,6 @@
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
@@ -81,14 +78,9 @@ extern unsigned int core_pipe_limit;
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
@@ -199,10 +191,6 @@ extern struct ctl_table inotify_table[];
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

origin.patch
mm-clean-up-mm_counter.patch
mm-avoid-false-sharing-of-mm_counter.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
vmscan-get_scan_ratio-cleanup.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
mm-migratec-kill-anon-local-variable-from-migrate_page_copy.patch
nodemaskh-remove-macro-any_online_node.patch
resources-introduce-generic-page_is_ram.patch
x86-remove-bios-data-range-from-e820.patch
x86-use-the-generic-page_is_ram.patch
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
memcg-improve-performance-in-moving-swap-charge.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-fixes.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
memcg-implement-memory-thresholds-checkpatch-fixes-fix.patch
memcg-typo-in-comment-to-mem_cgroup_print_oom_info.patch
sysctl-clean-up-vm-related-variable-declarations.patch

