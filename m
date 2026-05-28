Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896E035E549
	for <mm-commits@vger.kernel.org>; Thu, 28 May 2026 21:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780004711; cv=none; b=agYd8j95sNrf2Cuxi5lcWkx1GReqypdm5vQUwbsHvMYaBRqerV6FXlz5SC6Au5NIWYIMsaD0dsHhomxLTLdSMoTFltS0jxBu/4vjZIdfHGeHTfTpv+3/pP+kG6UpcpSGukJ0Sw4r4kvOzr/kJERyQ7UCrMeszlNMcAOdq7PUpDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780004711; c=relaxed/simple;
	bh=8yfPC6LUlytNymkfIqd0IjfblxS122PoSm2ZM2G7fQs=;
	h=Date:To:From:Subject:Message-Id; b=hU0vXPrQoeexRIU013oNQtFvMGaqvSPNO8UWKqFiSOQpmn4D+/dqJDOEbxnbMfPcpmBz/RhSwQ2HzCjoFPTlhwbWwD9kPTlVdXrBLvSKulu6B+7wwlrhewbPSDzBUDuiEqzw47As8asynktaYdoJ0co3/F3tK3RNN/GeVGaSsUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bG/W05hg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bG/W05hg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275651F000E9;
	Thu, 28 May 2026 21:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780004710;
	bh=QN2/FHHI4ThwbuLdzHZXWuNxS+oX266hyh7LEzX2O1I=;
	h=Date:To:From:Subject;
	b=bG/W05hgCCaWPCdXozIsSuiH/jMzPEmpaUw6y21hUnuKQ3O4rNqPKpJczd9hab0CA
	 77FZPY3jNNfqJ7NB7/gxuY+UwshXVyhOLbdiyd4+ai2YjvGqVK53ybYXkMjCk/2SIa
	 7/RWHSVaRZFNdHyjT40Bx2IeAAC0f+QeyeERcUlU=
Date: Thu, 28 May 2026 14:45:09 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcgv1-dont-compile-swap-functions-when-config_swap=n.patch added to mm-unstable branch
Message-Id: <20260528214510.275651F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcgv1: don't compile swap functions when CONFIG_SWAP=n
has been added to the -mm mm-unstable branch.  Its filename is
     memcgv1-dont-compile-swap-functions-when-config_swap=n.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcgv1-dont-compile-swap-functions-when-config_swap=n.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcgv1: don't compile swap functions when CONFIG_SWAP=n
Date: Thu May 28 02:35:22 PM PDT 2026

Stub these out to save some dead code and to fix a build error with the
upcoming "mm/memcg, swap: store cgroup id in cluster table directly".

Link: https://lore.kernel.org/202605281711.bSeZlErK-lkp@intel.com
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   15 ++++++++++-----
 mm/memcontrol-v1.c         |    2 ++
 2 files changed, 12 insertions(+), 5 deletions(-)

--- a/include/linux/memcontrol.h~memcgv1-dont-compile-swap-functions-when-config_swap=n
+++ a/include/linux/memcontrol.h
@@ -1900,9 +1900,6 @@ static inline void mem_cgroup_exit_user_
 	current->in_user_fault = 0;
 }
 
-void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci);
-void memcg1_swapin(struct folio *folio);
-
 #else /* CONFIG_MEMCG_V1 */
 static inline
 unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
@@ -1930,6 +1927,15 @@ static inline void mem_cgroup_exit_user_
 {
 }
 
+#endif /* CONFIG_MEMCG_V1 */
+
+#if defined(CONFIG_MEMCG_V1) && defined(CONFIG_SWAP)
+
+void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci);
+void memcg1_swapin(struct folio *folio);
+
+#else
+
 static inline void __memcg1_swapout(struct folio *folio,
 		struct swap_cluster_info *ci)
 {
@@ -1938,7 +1944,6 @@ static inline void __memcg1_swapout(stru
 static inline void memcg1_swapin(struct folio *folio)
 {
 }
-
-#endif /* CONFIG_MEMCG_V1 */
+#endif
 
 #endif /* _LINUX_MEMCONTROL_H */
--- a/mm/memcontrol-v1.c~memcgv1-dont-compile-swap-functions-when-config_swap=n
+++ a/mm/memcontrol-v1.c
@@ -604,6 +604,7 @@ void memcg1_commit_charge(struct folio *
 	local_irq_restore(flags);
 }
 
+#ifdef CONFIG_SWAP
 /**
  * __memcg1_swapout - transfer a memsw charge to swap
  * @folio: folio whose memsw charge to transfer
@@ -723,6 +724,7 @@ void memcg1_swapin(struct folio *folio)
 	swap_cluster_unlock(ci);
 	mem_cgroup_uncharge_swap(id, nr_pages);
 }
+#endif
 
 void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
 			   unsigned long nr_memory, int nid)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison-fix.patch
memcgv1-dont-compile-swap-functions-when-config_swap=n.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch
proc-rewrite-next_tgid-fix.patch
lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix-fix.patch
sparc-add-_mcount-prototype.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

