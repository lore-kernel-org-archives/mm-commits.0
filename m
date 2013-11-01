From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-lockdep-annotation-for-memcg-oom-lock.patch
 removed from -mm tree
Date: Fri, 01 Nov 2013 12:11:17 -0700
Message-ID: <5273fcd5.+jQDOUA1rxdELNuH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab3KATLS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Nov 2013 15:11:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org

Subject: [merged] mm-memcg-lockdep-annotation-for-memcg-oom-lock.patch removed from -mm tree
To: hannes@cmpxchg.org,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 01 Nov 2013 12:11:17 -0700


The patch titled
     Subject: mm: memcg: lockdep annotation for memcg OOM lock
has been removed from the -mm tree.  Its filename was
     mm-memcg-lockdep-annotation-for-memcg-oom-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: lockdep annotation for memcg OOM lock

The memcg OOM lock is a mutex-type lock that is open-coded due to memcg's
special needs.  Add annotations for lockdep coverage.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcg-lockdep-annotation-for-memcg-oom-lock mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-lockdep-annotation-for-memcg-oom-lock
+++ a/mm/memcontrol.c
@@ -54,6 +54,7 @@
 #include <linux/page_cgroup.h>
 #include <linux/cpu.h>
 #include <linux/oom.h>
+#include <linux/lockdep.h>
 #include "internal.h"
 #include <net/sock.h>
 #include <net/ip.h>
@@ -2046,6 +2047,12 @@ static int mem_cgroup_soft_reclaim(struc
 	return total;
 }
 
+#ifdef CONFIG_LOCKDEP
+static struct lockdep_map memcg_oom_lock_dep_map = {
+	.name = "memcg_oom_lock",
+};
+#endif
+
 static DEFINE_SPINLOCK(memcg_oom_lock);
 
 /*
@@ -2083,7 +2090,8 @@ static bool mem_cgroup_oom_trylock(struc
 			}
 			iter->oom_lock = false;
 		}
-	}
+	} else
+		mutex_acquire(&memcg_oom_lock_dep_map, 0, 1, _RET_IP_);
 
 	spin_unlock(&memcg_oom_lock);
 
@@ -2095,6 +2103,7 @@ static void mem_cgroup_oom_unlock(struct
 	struct mem_cgroup *iter;
 
 	spin_lock(&memcg_oom_lock);
+	mutex_release(&memcg_oom_lock_dep_map, 1, _RET_IP_);
 	for_each_mem_cgroup_tree(iter, memcg)
 		iter->oom_lock = false;
 	spin_unlock(&memcg_oom_lock);
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

