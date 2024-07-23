Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF6D13665F
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 01:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721698134; cv=none; b=tbca1jrkLhnOhaRvEZ4ZGdFPFhG/7hEmMgYNBvsJhLN+YPXVoT4lpbh3tZdufi1Zdn1tyAEsi2o6nd0xkU3YsqD4pf32nSN0g7/QUYcXDR68kb/1sryWSv/47aLghXZIrb2RkyOAeFY2ysRoO580Wz5GwWxh63/gnw/WE25d8bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721698134; c=relaxed/simple;
	bh=2te0RVHVrenGn7dJ2KjRC3piPgBOlXtuxCCuufRHRuQ=;
	h=Date:To:From:Subject:Message-Id; b=i3CFXpws0ZVqiYEs+XPzF7RmhQFU+1kuH2fQokmMPTFHZY2mlvoEMKJ9lywkiKrBHDbW6MZrBs3tm0B7If/L6Ho8fnFhO00lT58rS8WQ7ir6T3wkkmMpg7xe3m3jozgiRGJ3XiRghmwMai0ndH9DmHy2769E1QQcKFMjJGDUsNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WmKw/LwC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WmKw/LwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AD4C116B1;
	Tue, 23 Jul 2024 01:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721698133;
	bh=2te0RVHVrenGn7dJ2KjRC3piPgBOlXtuxCCuufRHRuQ=;
	h=Date:To:From:Subject:From;
	b=WmKw/LwCNHfDPF2wWBIGkMsnxeKceKGhFCLBc9jEhj6DPwBWPHVwNWRxePLRjLP8U
	 DL2sGVG5j06Sk98JjDQMWtNM6Mrx5D0u0u+6IrySULkM3gmou07oINbUBKr3qzfNvV
	 fm85oGSFddeXSq50dDQbRNUnFmc6Auzg2JVHZ9BA=
Date: Mon, 22 Jul 2024 18:28:53 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,wangkefeng.wang@huawei.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-tiering-introduce-folio_has_cpupid-check.patch added to mm-unstable branch
Message-Id: <20240723012853.97AD4C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memory tiering: introduce folio_has_cpupid() check
has been added to the -mm mm-unstable branch.  Its filename is
     memory-tiering-introduce-folio_has_cpupid-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-tiering-introduce-folio_has_cpupid-check.patch

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
Subject: memory tiering: introduce folio_has_cpupid() check
Date: Mon, 22 Jul 2024 13:29:16 -0400

Instead of open coded check for if memory tiering mode is on and a folio
is in the top tier memory, use a function to encapsulate the check.

Link: https://lkml.kernel.org/r/20240722172917.503370-2-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    6 ++++++
 kernel/sched/fair.c |    3 +--
 mm/huge_memory.c    |    6 ++----
 mm/memory-tiers.c   |   17 +++++++++++++++++
 mm/memory.c         |    3 +--
 mm/mprotect.c       |    3 +--
 6 files changed, 28 insertions(+), 10 deletions(-)

--- a/include/linux/mm.h~memory-tiering-introduce-folio_has_cpupid-check
+++ a/include/linux/mm.h
@@ -1738,6 +1738,8 @@ static inline void vma_set_access_pid_bi
 		__set_bit(pid_bit, &vma->numab_state->pids_active[1]);
 	}
 }
+
+bool folio_has_cpupid(struct folio *folio);
 #else /* !CONFIG_NUMA_BALANCING */
 static inline int folio_xchg_last_cpupid(struct folio *folio, int cpupid)
 {
@@ -1791,6 +1793,10 @@ static inline bool cpupid_match_pid(stru
 static inline void vma_set_access_pid_bit(struct vm_area_struct *vma)
 {
 }
+static inline bool folio_has_cpupid(struct folio *folio)
+{
+	return true;
+}
 #endif /* CONFIG_NUMA_BALANCING */
 
 #if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
--- a/kernel/sched/fair.c~memory-tiering-introduce-folio_has_cpupid-check
+++ a/kernel/sched/fair.c
@@ -1840,8 +1840,7 @@ bool should_numa_migrate_memory(struct t
 	 * The pages in slow memory node should be migrated according
 	 * to hot/cold instead of private/shared.
 	 */
-	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING &&
-	    !node_is_toptier(src_nid)) {
+	if (!folio_has_cpupid(folio)) {
 		struct pglist_data *pgdat;
 		unsigned long rate_limit;
 		unsigned int latency, th, def_th;
--- a/mm/huge_memory.c~memory-tiering-introduce-folio_has_cpupid-check
+++ a/mm/huge_memory.c
@@ -1712,8 +1712,7 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	 * For memory tiering mode, cpupid of slow memory page is used
 	 * to record page access time.  So use default value.
 	 */
-	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) ||
-	    node_is_toptier(nid))
+	if (folio_has_cpupid(folio))
 		last_cpupid = folio_last_cpupid(folio);
 	target_nid = numa_migrate_prep(folio, vmf, haddr, nid, &flags);
 	if (target_nid == NUMA_NO_NODE)
@@ -2066,8 +2065,7 @@ int change_huge_pmd(struct mmu_gather *t
 		    toptier)
 			goto unlock;
 
-		if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING &&
-		    !toptier)
+		if (!folio_has_cpupid(folio))
 			folio_xchg_access_time(folio,
 					       jiffies_to_msecs(jiffies));
 	}
--- a/mm/memory.c~memory-tiering-introduce-folio_has_cpupid-check
+++ a/mm/memory.c
@@ -5337,8 +5337,7 @@ static vm_fault_t do_numa_page(struct vm
 	 * For memory tiering mode, cpupid of slow memory page is used
 	 * to record page access time.  So use default value.
 	 */
-	if ((sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
-	    !node_is_toptier(nid))
+	if (!folio_has_cpupid(folio))
 		last_cpupid = (-1 & LAST_CPUPID_MASK);
 	else
 		last_cpupid = folio_last_cpupid(folio);
--- a/mm/memory-tiers.c~memory-tiering-introduce-folio_has_cpupid-check
+++ a/mm/memory-tiers.c
@@ -6,6 +6,7 @@
 #include <linux/memory.h>
 #include <linux/memory-tiers.h>
 #include <linux/notifier.h>
+#include <linux/sched/sysctl.h>
 
 #include "internal.h"
 
@@ -50,6 +51,22 @@ static const struct bus_type memory_tier
 	.dev_name = "memory_tier",
 };
 
+/**
+ * folio_has_cpupid - check if a folio has cpupid information
+ * @folio: folio to check
+ *
+ * folio's _last_cpupid field is repurposed by memory tiering. In memory
+ * tiering mode, cpupid of slow memory folio (not toptier memory) is used to
+ * record page access time.
+ *
+ * Return: the folio _last_cpupid is used as cpupid
+ */
+bool folio_has_cpupid(struct folio *folio)
+{
+	return !(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) ||
+	       node_is_toptier(folio_nid(folio));
+}
+
 #ifdef CONFIG_MIGRATION
 static int top_tier_adistance;
 /*
--- a/mm/mprotect.c~memory-tiering-introduce-folio_has_cpupid-check
+++ a/mm/mprotect.c
@@ -161,8 +161,7 @@ static long change_pte_range(struct mmu_
 				if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
 				    toptier)
 					continue;
-				if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING &&
-				    !toptier)
+				if (!folio_has_cpupid(folio))
 					folio_xchg_access_time(folio,
 						jiffies_to_msecs(jiffies));
 			}
_

Patches currently in -mm which might be from ziy@nvidia.com are

memory-tiering-read-last_cpupid-correctly-in-do_huge_pmd_numa_page.patch
memory-tiering-introduce-folio_has_cpupid-check.patch
memory-tiering-count-pgpromote_success-when-mem-tiering-is-enabled.patch

