Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD7D3D3B8
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247674; cv=none; b=nVz04ekstmfu0giBE1sCuPHxI4G9kG5bOZvc7SNtdKhZjwYdYo4ksToPLKIqN2nmESlLG8+p4LlgQfFVahUCBNBqIsv5pCc1KmkbeQgiIS4vAV9FjUfZF9VGyVWM520tfvywxX8d1Mou+l6mHk3GZYpm76s2ooc70+34uT+LyyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247674; c=relaxed/simple;
	bh=IqyoDI6ON5zGUlfvPJyPhxrMvcJHVSPzVhkJYpQqVR8=;
	h=Date:To:From:Subject:Message-Id; b=RICsRvIr/ZTC0nqBR+cmQ4CEtGUVNb+ic6QmqrpVsibGPWjgQBoiJWECD45IvxfjxMC6dMpVKU5rP9e8SaU8Xtvc9dYvqiI7PqACocv6VbDm5r1oRT5tiyL7/nsteD9pNbawg7N+gB6DaJl4QG7C4ep8r8VAcc9jOEfkmUoowgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QGU/aCmW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QGU/aCmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34657C4CEC2;
	Mon,  2 Sep 2024 03:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247674;
	bh=IqyoDI6ON5zGUlfvPJyPhxrMvcJHVSPzVhkJYpQqVR8=;
	h=Date:To:From:Subject:From;
	b=QGU/aCmWFBGJW49Ia+zuLqOFzl7yH26Q1CGM+R7kdOzdG5HqSRaXfj5BaLz6DRSMe
	 MdtdMD8P0Ra1Mlzjeq2WvD+XWRWAK2AuL+2ICHiBG6ti7FSWNU+kDOh7IerYRQLplS
	 99NW4OOSWojmoD0PDar8PQeWdRr9mTbWKb6yvXCw=
Date: Sun, 01 Sep 2024 20:27:53 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,wangkefeng.wang@huawei.com,lorenzo.stoakes@oracle.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memory-tiering-introduce-folio_use_access_time-check.patch removed from -mm tree
Message-Id: <20240902032754.34657C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memory tiering: introduce folio_use_access_time() check
has been removed from the -mm tree.  Its filename was
     memory-tiering-introduce-folio_use_access_time-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: memory tiering: introduce folio_use_access_time() check
Date: Wed, 24 Jul 2024 09:01:14 -0400

If memory tiering mode is on and a folio is not in the top tier memory,
folio's cpupid field is repurposed to store page access time.  Instead of
an open coded check, use a function to encapsulate the check.

Link: https://lkml.kernel.org/r/20240724130115.793641-3-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    6 ++++++
 kernel/sched/fair.c |    3 +--
 mm/huge_memory.c    |    6 ++----
 mm/memory-tiers.c   |   19 +++++++++++++++++++
 mm/memory.c         |    3 +--
 mm/mprotect.c       |    3 +--
 6 files changed, 30 insertions(+), 10 deletions(-)

--- a/include/linux/mm.h~memory-tiering-introduce-folio_use_access_time-check
+++ a/include/linux/mm.h
@@ -1745,6 +1745,8 @@ static inline void vma_set_access_pid_bi
 		__set_bit(pid_bit, &vma->numab_state->pids_active[1]);
 	}
 }
+
+bool folio_use_access_time(struct folio *folio);
 #else /* !CONFIG_NUMA_BALANCING */
 static inline int folio_xchg_last_cpupid(struct folio *folio, int cpupid)
 {
@@ -1798,6 +1800,10 @@ static inline bool cpupid_match_pid(stru
 static inline void vma_set_access_pid_bit(struct vm_area_struct *vma)
 {
 }
+static inline bool folio_use_access_time(struct folio *folio)
+{
+	return false;
+}
 #endif /* CONFIG_NUMA_BALANCING */
 
 #if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
--- a/kernel/sched/fair.c~memory-tiering-introduce-folio_use_access_time-check
+++ a/kernel/sched/fair.c
@@ -1840,8 +1840,7 @@ bool should_numa_migrate_memory(struct t
 	 * The pages in slow memory node should be migrated according
 	 * to hot/cold instead of private/shared.
 	 */
-	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING &&
-	    !node_is_toptier(src_nid)) {
+	if (folio_use_access_time(folio)) {
 		struct pglist_data *pgdat;
 		unsigned long rate_limit;
 		unsigned int latency, th, def_th;
--- a/mm/huge_memory.c~memory-tiering-introduce-folio_use_access_time-check
+++ a/mm/huge_memory.c
@@ -1707,8 +1707,7 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	 * For memory tiering mode, cpupid of slow memory page is used
 	 * to record page access time.  So use default value.
 	 */
-	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) ||
-	    node_is_toptier(nid))
+	if (!folio_use_access_time(folio))
 		last_cpupid = folio_last_cpupid(folio);
 	target_nid = numa_migrate_prep(folio, vmf, haddr, nid, &flags);
 	if (target_nid == NUMA_NO_NODE)
@@ -2058,8 +2057,7 @@ int change_huge_pmd(struct mmu_gather *t
 		    toptier)
 			goto unlock;
 
-		if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING &&
-		    !toptier)
+		if (folio_use_access_time(folio))
 			folio_xchg_access_time(folio,
 					       jiffies_to_msecs(jiffies));
 	}
--- a/mm/memory.c~memory-tiering-introduce-folio_use_access_time-check
+++ a/mm/memory.c
@@ -5337,8 +5337,7 @@ static vm_fault_t do_numa_page(struct vm
 	 * For memory tiering mode, cpupid of slow memory page is used
 	 * to record page access time.  So use default value.
 	 */
-	if ((sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
-	    !node_is_toptier(nid))
+	if (folio_use_access_time(folio))
 		last_cpupid = (-1 & LAST_CPUPID_MASK);
 	else
 		last_cpupid = folio_last_cpupid(folio);
--- a/mm/memory-tiers.c~memory-tiering-introduce-folio_use_access_time-check
+++ a/mm/memory-tiers.c
@@ -6,6 +6,7 @@
 #include <linux/memory.h>
 #include <linux/memory-tiers.h>
 #include <linux/notifier.h>
+#include <linux/sched/sysctl.h>
 
 #include "internal.h"
 
@@ -50,6 +51,24 @@ static const struct bus_type memory_tier
 	.dev_name = "memory_tier",
 };
 
+#ifdef CONFIG_NUMA_BALANCING
+/**
+ * folio_use_access_time - check if a folio reuses cpupid for page access time
+ * @folio: folio to check
+ *
+ * folio's _last_cpupid field is repurposed by memory tiering. In memory
+ * tiering mode, cpupid of slow memory folio (not toptier memory) is used to
+ * record page access time.
+ *
+ * Return: the folio _last_cpupid is used to record page access time
+ */
+bool folio_use_access_time(struct folio *folio)
+{
+	return (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
+	       !node_is_toptier(folio_nid(folio));
+}
+#endif
+
 #ifdef CONFIG_MIGRATION
 static int top_tier_adistance;
 /*
--- a/mm/mprotect.c~memory-tiering-introduce-folio_use_access_time-check
+++ a/mm/mprotect.c
@@ -161,8 +161,7 @@ static long change_pte_range(struct mmu_
 				if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
 				    toptier)
 					continue;
-				if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING &&
-				    !toptier)
+				if (folio_use_access_time(folio))
 					folio_xchg_access_time(folio,
 						jiffies_to_msecs(jiffies));
 			}
_

Patches currently in -mm which might be from ziy@nvidia.com are


