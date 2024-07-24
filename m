Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCD015EFA5
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 17:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721840437; cv=none; b=iWB99JWP0w8H07dY7o+ryyBGSScJqtlbJ4bJCFGSuYhl2nQfbev2w/luFY1pjCcRl/Lce9/PE9qIkvEzdBNQaiwjIPnCcbWq/TcMNvgqJRsJ2RgsVPdBTwU4Y4/hsPNMJDPo5Ke9AwwY6w+3lIyunZoGV+80PiSAd1/HeIal3lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721840437; c=relaxed/simple;
	bh=v6E5QgV5vreyHXTAnrp2zL6/G2WSModcGhft2VMupcM=;
	h=Date:To:From:Subject:Message-Id; b=ddDJj5rd/rvE1k2CZ0HWU8AVV0WAy0deVapWU8jsTWTwgxszB9v12sp9c4xi7lOCfvNxkAAJLUan9nxLNdvl03kELp3dM+7JJflMN00OmOGOosJGwM+l/JumSgTa97HgfQWYSHRB5flvIN3TkmmNi0rQDRXhYSXbjqT1Uq/UAuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wBuhD7sL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wBuhD7sL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46416C32781;
	Wed, 24 Jul 2024 17:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721840437;
	bh=v6E5QgV5vreyHXTAnrp2zL6/G2WSModcGhft2VMupcM=;
	h=Date:To:From:Subject:From;
	b=wBuhD7sLZAynUwIFCHPJZvx/fnmFrwkGTc4JQzrR1Jsljs0Ad4f/9tRMKK+DrUiLX
	 UotI/wYjIIy1r8rij+iQ0Mug/EreJ6kbSJq7cnEHEl2zdo0W9zb6TTevPMvMqcqQ2N
	 1mIeCdbKKls8+dS9BkdJgnw2+OxK7/NNei+aa2XE=
Date: Wed, 24 Jul 2024 10:00:36 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,wangkefeng.wang@huawei.com,lorenzo.stoakes@oracle.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-tiering-introduce-folio_use_access_time-check.patch added to mm-unstable branch
Message-Id: <20240724170037.46416C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memory tiering: introduce folio_use_access_time() check
has been added to the -mm mm-unstable branch.  Its filename is
     memory-tiering-introduce-folio_use_access_time-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-tiering-introduce-folio_use_access_time-check.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
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
@@ -1717,6 +1717,8 @@ static inline void vma_set_access_pid_bi
 		__set_bit(pid_bit, &vma->numab_state->pids_active[1]);
 	}
 }
+
+bool folio_use_access_time(struct folio *folio);
 #else /* !CONFIG_NUMA_BALANCING */
 static inline int folio_xchg_last_cpupid(struct folio *folio, int cpupid)
 {
@@ -1770,6 +1772,10 @@ static inline bool cpupid_match_pid(stru
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
@@ -2061,8 +2060,7 @@ int change_huge_pmd(struct mmu_gather *t
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

memory-tiering-read-last_cpupid-correctly-in-do_huge_pmd_numa_page.patch
memory-tiering-introduce-folio_use_access_time-check.patch
memory-tiering-count-pgpromote_success-when-mem-tiering-is-enabled.patch

