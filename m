From: akpm@linux-foundation.org
Subject: + memcg-add-mem_cgroup_from_css-helper-fix.patch added to -mm tree
Date: Thu, 19 Jul 2012 14:40:55 -0700
Message-ID: <20120719222743.3532E20008A@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:45432 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2GSW1q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jul 2012 18:27:46 -0400
Received: by eaao13 with SMTP id o13so165239eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 19 Jul 2012 15:27:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, liwanp@linux.vnet.ibm.com, mhocko@suse.cz, shangw@linux.vnet.ibm.com


The patch titled
     Subject: memcg-add-mem_cgroup_from_css-helper-fix
has been added to the -mm tree.  Its filename is
     memcg-add-mem_cgroup_from_css-helper-fix.patch

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
Subject: memcg-add-mem_cgroup_from_css-helper-fix

that patch was very broken

Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~memcg-add-mem_cgroup_from_css-helper-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-mem_cgroup_from_css-helper-fix
+++ a/mm/memcontrol.c
@@ -868,9 +868,8 @@ static void memcg_check_events(struct me
 
 struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)
 {
-	return mem_cgroup_from_css(cgroup_subsys_state(cont,
-				mem_cgroup_subsys_id), struct mem_cgroup,
-				css);
+	return mem_cgroup_from_css(
+		cgroup_subsys_state(cont, mem_cgroup_subsys_id));
 }
 
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
@@ -883,8 +882,7 @@ struct mem_cgroup *mem_cgroup_from_task(
 	if (unlikely(!p))
 		return NULL;
 
-	return mem_cgroup_from_css(task_subsys_state(p, mem_cgroup_subsys_id),
-				struct mem_cgroup, css);
+	return mem_cgroup_from_css(task_subsys_state(p, mem_cgroup_subsys_id));
 }
 
 struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
@@ -970,8 +968,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		css = css_get_next(&mem_cgroup_subsys, id + 1, &root->css, &id);
 		if (css) {
 			if (css == &root->css || css_tryget(css))
-				memcg = mem_cgroup_from_css(css,
-						     struct mem_cgroup, css);
+				memcg = mem_cgroup_from_css(css);
 		} else
 			id = 0;
 		rcu_read_unlock();
@@ -2500,7 +2497,7 @@ static struct mem_cgroup *mem_cgroup_loo
 	css = css_lookup(&mem_cgroup_subsys, id);
 	if (!css)
 		return NULL;
-	return mem_cgroup_from_css(css, struct mem_cgroup, css);
+	return mem_cgroup_from_css(css);
 }
 
 struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
_
Subject: Subject: memcg-add-mem_cgroup_from_css-helper-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-base-ddc-debork.patch
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
hugetlb-cgroup-simplify-pre_destroy-callback-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix-fix.patch
mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes.patch
mm-have-order-0-compaction-start-off-where-it-left-v3-typo.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix-fix.patch
mm-memcg-fix-compaction-migration-failing-due-to-memcg-limits-checkpatch-fixes.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-add-mem_cgroup_from_css-helper-fix.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kernel-sysc-avoid-argv_freenull.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
kernel-kmodc-document-call_usermodehelper_fns-a-bit.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
revert-sched-fix-fork-error-path-to-not-crash.patch
ipc-use-kconfig-options-for-__arch_want_ipc_parse_version.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
include-linux-aioh-cpp-c-conversions.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

