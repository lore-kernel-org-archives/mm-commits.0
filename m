From: akpm@linux-foundation.org
Subject: [folded] mm-make-vb_alloc-more-foolproof-fix.patch removed from -mm tree
Date: Tue, 31 Jul 2012 16:18:29 -0700
Message-ID: <20120731231830.C5C91A018B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:43395 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756136Ab2GaXSd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2012 19:18:33 -0400
Received: by lagr15 with SMTP id r15so298169lag.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 16:18:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-make-vb_alloc-more-foolproof-fix
has been removed from the -mm tree.  Its filename was
     mm-make-vb_alloc-more-foolproof-fix.patch

This patch was dropped because it was folded into mm-make-vb_alloc-more-foolproof.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-make-vb_alloc-more-foolproof-fix

use WARN_ON-return-value feature

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/vmalloc.c~mm-make-vb_alloc-more-foolproof-fix mm/vmalloc.c
--- a/mm/vmalloc.c~mm-make-vb_alloc-more-foolproof-fix
+++ a/mm/vmalloc.c
@@ -904,13 +904,12 @@ static void *vb_alloc(unsigned long size
 
 	BUG_ON(size & ~PAGE_MASK);
 	BUG_ON(size > PAGE_SIZE*VMAP_MAX_ALLOC);
-	if (size == 0) {
+	if (WARN_ON(size == 0)) {
 		/*
 		 * Allocating 0 bytes isn't what caller wants since
 		 * get_order(0) returns funny result. Just warn and terminate
 		 * early.
 		 */
-		WARN_ON(1);
 		return NULL;
 	}
 	order = get_order(size);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-media-video-v4l2-ioctlc-fix-build.patch
mm-make-vb_alloc-more-foolproof.patch
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

