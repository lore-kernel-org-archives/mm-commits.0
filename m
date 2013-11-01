From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-use-proper-memcg-in-limit-bypass.patch removed
 from -mm tree
Date: Fri, 01 Nov 2013 12:11:15 -0700
Message-ID: <5273fcd3.4qlfvKFiOlW5jN2r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab3KATLQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Nov 2013 15:11:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org

Subject: [merged] mm-memcg-use-proper-memcg-in-limit-bypass.patch removed from -mm tree
To: hannes@cmpxchg.org,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 01 Nov 2013 12:11:15 -0700


The patch titled
     Subject: mm: memcg: use proper memcg in limit bypass
has been removed from the -mm tree.  Its filename was
     mm-memcg-use-proper-memcg-in-limit-bypass.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: use proper memcg in limit bypass

84235de ("fs: buffer: move allocation failure loop into the allocator")
allowed __GFP_NOFAIL allocations to bypass the limit if they fail to
reclaim enough memory for the charge.  Because the main test case was on a
3.2-based system, this patch missed the fact that on newer kernels the
charge function needs to return root_mem_cgroup when bypassing the limit,
and not NULL.  This will corrupt whatever memory is at NULL + percpu
pointer offset.  Fix this quickly before problems are reported.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-use-proper-memcg-in-limit-bypass mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-use-proper-memcg-in-limit-bypass
+++ a/mm/memcontrol.c
@@ -2765,10 +2765,10 @@ done:
 	*ptr = memcg;
 	return 0;
 nomem:
-	*ptr = NULL;
-	if (gfp_mask & __GFP_NOFAIL)
-		return 0;
-	return -ENOMEM;
+	if (!(gfp_mask & __GFP_NOFAIL)) {
+		*ptr = NULL;
+		return -ENOMEM;
+	}
 bypass:
 	*ptr = root_mem_cgroup;
 	return -EINTR;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-nobootmemc-have-__free_pages_memory-free-in-larger-chunks.patch
memcg-refactor-mem_control_numa_stat_show.patch
memcg-support-hierarchical-memorynuma_stats.patch
memblock-factor-out-of-top-down-allocation.patch
memblock-introduce-bottom-up-allocation-mode.patch
x86-mm-factor-out-of-top-down-direct-mapping-setup.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up.patch
x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch
mem-hotplug-introduce-movable_node-boot-option.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
percpu-add-test-module-for-various-percpu-operations.patch
linux-next.patch
mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

