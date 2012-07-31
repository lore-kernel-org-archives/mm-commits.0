From: akpm@linux-foundation.org
Subject: [folded] mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch removed from -mm tree
Date: Tue, 31 Jul 2012 16:21:49 -0700
Message-ID: <20120731232149.E9A68A0114@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:41716 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072Ab2GaXVv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 19:21:51 -0400
Received: by obbwc20 with SMTP id wc20so4815521obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 16:21:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-add-new-hugetlb-cgroup-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch

This patch was dropped because it was folded into mm-hugetlb-add-new-hugetlb-cgroup.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-add-new-hugetlb-cgroup-fix-fix

s/CONFIG_MEMCG_HUGETLB/CONFIG_CGROUP_HUGETLB/g

Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup_subsys.h  |    2 +-
 include/linux/hugetlb_cgroup.h |    2 +-
 init/Kconfig                   |    2 +-
 mm/Makefile                    |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/cgroup_subsys.h~mm-hugetlb-add-new-hugetlb-cgroup-fix-fix include/linux/cgroup_subsys.h
--- a/include/linux/cgroup_subsys.h~mm-hugetlb-add-new-hugetlb-cgroup-fix-fix
+++ a/include/linux/cgroup_subsys.h
@@ -73,7 +73,7 @@ SUBSYS(net_prio)
 
 /* */
 
-#ifdef CONFIG_MEMCG_HUGETLB
+#ifdef CONFIG_CGROUP_HUGETLB
 SUBSYS(hugetlb)
 #endif
 
diff -puN include/linux/hugetlb_cgroup.h~mm-hugetlb-add-new-hugetlb-cgroup-fix-fix include/linux/hugetlb_cgroup.h
--- a/include/linux/hugetlb_cgroup.h~mm-hugetlb-add-new-hugetlb-cgroup-fix-fix
+++ a/include/linux/hugetlb_cgroup.h
@@ -19,7 +19,7 @@
 
 struct hugetlb_cgroup;
 
-#ifdef CONFIG_MEMCG_HUGETLB
+#ifdef CONFIG_CGROUP_HUGETLB
 static inline bool hugetlb_cgroup_disabled(void)
 {
 	if (hugetlb_subsys.disabled)
diff -puN init/Kconfig~mm-hugetlb-add-new-hugetlb-cgroup-fix-fix init/Kconfig
--- a/init/Kconfig~mm-hugetlb-add-new-hugetlb-cgroup-fix-fix
+++ a/init/Kconfig
@@ -751,7 +751,7 @@ config CGROUP_MEM_RES_CTLR_KMEM
 	  the kmem extension can use it to guarantee that no group of processes
 	  will ever exhaust kernel resources alone.
 
-config MEMCG_HUGETLB
+config CGROUP_HUGETLB
 	bool "HugeTLB Resource Controller for Control Groups"
 	depends on RESOURCE_COUNTERS && HUGETLB_PAGE && EXPERIMENTAL
 	default n
diff -puN mm/Makefile~mm-hugetlb-add-new-hugetlb-cgroup-fix-fix mm/Makefile
--- a/mm/Makefile~mm-hugetlb-add-new-hugetlb-cgroup-fix-fix
+++ a/mm/Makefile
@@ -50,7 +50,7 @@ obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
-obj-$(CONFIG_MEMCG_HUGETLB) += hugetlb_cgroup.o
+obj-$(CONFIG_CGROUP_HUGETLB) += hugetlb_cgroup.o
 obj-$(CONFIG_MEMORY_FAILURE) += memory-failure.o
 obj-$(CONFIG_HWPOISON_INJECT) += hwpoison-inject.o
 obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-media-video-v4l2-ioctlc-fix-build.patch
mm-make-vb_alloc-more-foolproof.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
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
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-add-mem_cgroup_from_css-helper-fix.patch
mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables-fix.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm-slab_commonc-fix-warning.patch
mm.patch
rbtree-performance-and-correctness-test-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

