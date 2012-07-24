From: akpm@linux-foundation.org
Subject: + memcg-oom-provide-more-info-while-memcg-oom-happening-checkpatch-fixes.patch added to -mm tree
Date: Tue, 24 Jul 2012 13:38:17 -0700
Message-ID: <20120724203818.2B8AC20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:55555 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958Ab2GXUiV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jul 2012 16:38:21 -0400
Received: by bkcjc3 with SMTP id jc3so406468bkc.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Jul 2012 13:38:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, gthelen@google.com, handai.szj@taobao.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: memcg-oom-provide-more-info-while-memcg-oom-happening-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     memcg-oom-provide-more-info-while-memcg-oom-happening-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-oom-provide-more-info-while-memcg-oom-happening-checkpatch-fixes

WARNING: Prefer pr_info(... to printk(KERN_INFO, ...
#48: FILE: mm/memcontrol.c:1389:
+	printk(KERN_INFO "Memory cgroup stat:\n");

WARNING: Prefer pr_cont(... to printk(KERN_CONT, ...
#52: FILE: mm/memcontrol.c:1393:
+		printk(KERN_CONT "%s:%ldKB ", mem_cgroup_stat_names[i],

WARNING: Prefer pr_cont(... to printk(KERN_CONT, ...
#57: FILE: mm/memcontrol.c:1398:
+		printk(KERN_CONT "%s:%lu ", mem_cgroup_events_names[i],

WARNING: Prefer pr_cont(... to printk(KERN_CONT, ...
#61: FILE: mm/memcontrol.c:1402:
+		printk(KERN_CONT "%s:%luKB ", mem_cgroup_lru_names[i],

WARNING: line over 80 characters
#72: FILE: mm/memcontrol.c:1413:
+		printk(KERN_CONT "total_%s:%lldKB ", mem_cgroup_stat_names[i], K(val));

WARNING: Prefer pr_cont(... to printk(KERN_CONT, ...
#72: FILE: mm/memcontrol.c:1413:
+		printk(KERN_CONT "total_%s:%lldKB ", mem_cgroup_stat_names[i], K(val));

WARNING: line over 80 characters
#80: FILE: mm/memcontrol.c:1421:
+		printk(KERN_CONT "total_%s:%llu ", mem_cgroup_events_names[i], val);

WARNING: Prefer pr_cont(... to printk(KERN_CONT, ...
#80: FILE: mm/memcontrol.c:1421:
+		printk(KERN_CONT "total_%s:%llu ", mem_cgroup_events_names[i], val);

WARNING: line over 80 characters
#88: FILE: mm/memcontrol.c:1429:
+		printk(KERN_CONT "total_%s:%lluKB ", mem_cgroup_lru_names[i], K(val));

WARNING: Prefer pr_cont(... to printk(KERN_CONT, ...
#88: FILE: mm/memcontrol.c:1429:
+		printk(KERN_CONT "total_%s:%lluKB ", mem_cgroup_lru_names[i], K(val));

WARNING: Prefer pr_cont(... to printk(KERN_CONT, ...
#91: FILE: mm/memcontrol.c:1432:
+	printk(KERN_CONT "\n");

total: 0 errors, 11 warnings, 95 lines checked

./patches/memcg-oom-provide-more-info-while-memcg-oom-happening.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: David Rientjes <rientjes@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Sha Zhengju <handai.szj@taobao.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN mm/memcontrol.c~memcg-oom-provide-more-info-while-memcg-oom-happening-checkpatch-fixes mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-oom-provide-more-info-while-memcg-oom-happening-checkpatch-fixes
+++ a/mm/memcontrol.c
@@ -1386,20 +1386,20 @@ static void mem_cgroup_print_oom_stat(st
 	int i;
 	struct mem_cgroup *mi;
 
-	printk(KERN_INFO "Memory cgroup stat:\n");
+	pr_info("Memory cgroup stat:\n");
 	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
 		if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
 			continue;
-		printk(KERN_CONT "%s:%ldKB ", mem_cgroup_stat_names[i],
+		pr_cont("%s:%ldKB ", mem_cgroup_stat_names[i],
 			   K(mem_cgroup_read_stat(memcg, i)));
 	}
 
 	for (i = 0; i < MEM_CGROUP_EVENTS_NSTATS; i++)
-		printk(KERN_CONT "%s:%lu ", mem_cgroup_events_names[i],
+		pr_cont("%s:%lu ", mem_cgroup_events_names[i],
 			   mem_cgroup_read_events(memcg, i));
 
 	for (i = 0; i < NR_LRU_LISTS; i++)
-		printk(KERN_CONT "%s:%luKB ", mem_cgroup_lru_names[i],
+		pr_cont("%s:%luKB ", mem_cgroup_lru_names[i],
 			   K(mem_cgroup_nr_lru_pages(memcg, BIT(i))));
 
 	/* Dump the total statistics if hierarchy is enabled. */
@@ -1410,7 +1410,7 @@ static void mem_cgroup_print_oom_stat(st
 			continue;
 		for_each_mem_cgroup_tree(mi, memcg)
 			val += mem_cgroup_read_stat(mi, i);
-		printk(KERN_CONT "total_%s:%lldKB ", mem_cgroup_stat_names[i], K(val));
+		pr_cont("total_%s:%lldKB ", mem_cgroup_stat_names[i], K(val));
 	}
 
 	for (i = 0; i < MEM_CGROUP_EVENTS_NSTATS; i++) {
@@ -1418,7 +1418,7 @@ static void mem_cgroup_print_oom_stat(st
 
 		for_each_mem_cgroup_tree(mi, memcg)
 			val += mem_cgroup_read_events(mi, i);
-		printk(KERN_CONT "total_%s:%llu ", mem_cgroup_events_names[i], val);
+		pr_cont("total_%s:%llu ", mem_cgroup_events_names[i], val);
 	}
 
 	for (i = 0; i < NR_LRU_LISTS; i++) {
@@ -1426,11 +1426,10 @@ static void mem_cgroup_print_oom_stat(st
 
 		for_each_mem_cgroup_tree(mi, memcg)
 			val += mem_cgroup_nr_lru_pages(mi, BIT(i));
-		printk(KERN_CONT "total_%s:%lluKB ", mem_cgroup_lru_names[i], K(val));
+		pr_cont("total_%s:%lluKB ", mem_cgroup_lru_names[i], K(val));
 	}
 
-	printk(KERN_CONT "\n");
-
+	pr_cont("\n");
 }
 
 /**
_
Subject: Subject: memcg-oom-provide-more-info-while-memcg-oom-happening-checkpatch-fixes

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix-fix.patch
mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes.patch
mm-have-order-0-compaction-start-off-where-it-left-v3-typo.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix-fix.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb-fix.patch
mm-memcg-fix-compaction-migration-failing-due-to-memcg-limits-checkpatch-fixes.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-add-mem_cgroup_from_css-helper-fix.patch
memcg-oom-provide-more-info-while-memcg-oom-happening-checkpatch-fixes.patch
memcg-oom-clarify-some-oom-dump-messages-checkpatch-fixes.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kernel-sysc-avoid-argv_freenull.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight-fix.patch
rbtree-performance-and-correctness-test-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
kernel-kmodc-document-call_usermodehelper_fns-a-bit.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
revert-sched-fix-fork-error-path-to-not-crash.patch
ipc-use-kconfig-options-for-__arch_want_ipc_parse_version.patch
include-linux-aioh-cpp-c-conversions.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

