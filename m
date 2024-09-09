Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732C218DF66
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925207; cv=none; b=HAANbdx/JwO1NLRe13CUjRrD9J9lVsOdRctjLi5avIXBbUs+g1XwYu2J2f5/OdfTq49dxuABuP3cjirV6NnmhpBmi6WrxT4pFvoWr/ErCiLc55t2TddaGg5fRS3Z1vBaA6NH9lENM2hiElVSS2XD/lbZTACwdV6D3Wk8AGxQnw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925207; c=relaxed/simple;
	bh=uahGRWynL1lbFl32v2iVJaKjsj7duYUHlKt2C7qwMQU=;
	h=Date:To:From:Subject:Message-Id; b=utEFWEffleLf/2v896UOlZsxioIv6GV1ZwBDk1SoffZkf7P/GynkzRC8b4czuIgGWalwdm/LSTsLWd4wZd4XYYvonAqRN+mHCE0tqJk756O3uMwXv4eHwv2eRO878qOOYGfK/prjYb2q32YBeFishHZRr4ILcl4QjKyj5Cp3BCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Oi8GOuk4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Oi8GOuk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D26C4CEC5;
	Mon,  9 Sep 2024 23:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925206;
	bh=uahGRWynL1lbFl32v2iVJaKjsj7duYUHlKt2C7qwMQU=;
	h=Date:To:From:Subject:From;
	b=Oi8GOuk4jEJ9BXSWq30mJl23fAoMtM7K0chaQmHG8c+f0P/MXICvsqMKXVmMZve/D
	 18FHU5JfaRxOdDTMNOxO86/RsPKDqHVkLqb5Bdggb3eIJmycZHz7cfxRn7eafZ+ySQ
	 8tmgwVMOCI330JkmPLK2i93lBfc1MYCnahy7rKQs=
Date: Mon, 09 Sep 2024 16:40:06 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ioworker0@gmail.com,hughd@google.com,gshan@redhat.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cleanup-count_mthp_stat-definition.patch removed from -mm tree
Message-Id: <20240909234006.C7D26C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: cleanup count_mthp_stat() definition
has been removed from the -mm tree.  Its filename was
     mm-cleanup-count_mthp_stat-definition.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: cleanup count_mthp_stat() definition
Date: Thu, 8 Aug 2024 12:18:46 +0100

Patch series "Shmem mTHP controls and stats improvements", v3.

This is a small series to tidy up the way the shmem controls and stats are
exposed.  These patches were previously part of the series at [2], but I
decided to split them out since they can go in independently.


This patch (of 2):

Let's move count_mthp_stat() so that it's always defined, even when THP is
disabled.  Previously uses of the function in files such as shmem.c, which
are compiled even when THP is disabled, required ugly THP ifdeferry.  With
this cleanup, we can remove those ifdefs and the function resolves to a
nop when THP is disabled.

I shortly plan to call count_mthp_stat() from more THP-invariant source
files.

Link: https://lkml.kernel.org/r/20240808111849.651867-1-ryan.roberts@arm.com
Link: https://lkml.kernel.org/r/20240808111849.651867-2-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <ioworker0@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   70 +++++++++++++++++++-------------------
 mm/memory.c             |    2 -
 mm/shmem.c              |    6 ---
 3 files changed, 35 insertions(+), 43 deletions(-)

--- a/include/linux/huge_mm.h~mm-cleanup-count_mthp_stat-definition
+++ a/include/linux/huge_mm.h
@@ -114,6 +114,41 @@ extern struct kobj_attribute thpsize_shm
 #define HPAGE_PUD_MASK	(~(HPAGE_PUD_SIZE - 1))
 #define HPAGE_PUD_SIZE	((1UL) << HPAGE_PUD_SHIFT)
 
+enum mthp_stat_item {
+	MTHP_STAT_ANON_FAULT_ALLOC,
+	MTHP_STAT_ANON_FAULT_FALLBACK,
+	MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE,
+	MTHP_STAT_SWPOUT,
+	MTHP_STAT_SWPOUT_FALLBACK,
+	MTHP_STAT_SHMEM_ALLOC,
+	MTHP_STAT_SHMEM_FALLBACK,
+	MTHP_STAT_SHMEM_FALLBACK_CHARGE,
+	MTHP_STAT_SPLIT,
+	MTHP_STAT_SPLIT_FAILED,
+	MTHP_STAT_SPLIT_DEFERRED,
+	__MTHP_STAT_COUNT
+};
+
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SYSFS)
+struct mthp_stat {
+	unsigned long stats[ilog2(MAX_PTRS_PER_PTE) + 1][__MTHP_STAT_COUNT];
+};
+
+DECLARE_PER_CPU(struct mthp_stat, mthp_stats);
+
+static inline void count_mthp_stat(int order, enum mthp_stat_item item)
+{
+	if (order <= 0 || order > PMD_ORDER)
+		return;
+
+	this_cpu_inc(mthp_stats.stats[order][item]);
+}
+#else
+static inline void count_mthp_stat(int order, enum mthp_stat_item item)
+{
+}
+#endif
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
 extern unsigned long transparent_hugepage_flags;
@@ -269,41 +304,6 @@ struct thpsize {
 
 #define to_thpsize(kobj) container_of(kobj, struct thpsize, kobj)
 
-enum mthp_stat_item {
-	MTHP_STAT_ANON_FAULT_ALLOC,
-	MTHP_STAT_ANON_FAULT_FALLBACK,
-	MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE,
-	MTHP_STAT_SWPOUT,
-	MTHP_STAT_SWPOUT_FALLBACK,
-	MTHP_STAT_SHMEM_ALLOC,
-	MTHP_STAT_SHMEM_FALLBACK,
-	MTHP_STAT_SHMEM_FALLBACK_CHARGE,
-	MTHP_STAT_SPLIT,
-	MTHP_STAT_SPLIT_FAILED,
-	MTHP_STAT_SPLIT_DEFERRED,
-	__MTHP_STAT_COUNT
-};
-
-struct mthp_stat {
-	unsigned long stats[ilog2(MAX_PTRS_PER_PTE) + 1][__MTHP_STAT_COUNT];
-};
-
-#ifdef CONFIG_SYSFS
-DECLARE_PER_CPU(struct mthp_stat, mthp_stats);
-
-static inline void count_mthp_stat(int order, enum mthp_stat_item item)
-{
-	if (order <= 0 || order > PMD_ORDER)
-		return;
-
-	this_cpu_inc(mthp_stats.stats[order][item]);
-}
-#else
-static inline void count_mthp_stat(int order, enum mthp_stat_item item)
-{
-}
-#endif
-
 #define transparent_hugepage_use_zero_page()				\
 	(transparent_hugepage_flags &					\
 	 (1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG))
--- a/mm/memory.c~mm-cleanup-count_mthp_stat-definition
+++ a/mm/memory.c
@@ -4595,9 +4595,7 @@ static vm_fault_t do_anonymous_page(stru
 
 	folio_ref_add(folio, nr_pages - 1);
 	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_FAULT_ALLOC);
-#endif
 	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
 	folio_add_lru_vma(folio, vma);
 setpte:
--- a/mm/shmem.c~mm-cleanup-count_mthp_stat-definition
+++ a/mm/shmem.c
@@ -1808,9 +1808,7 @@ static struct folio *shmem_alloc_and_add
 
 			if (pages == HPAGE_PMD_NR)
 				count_vm_event(THP_FILE_FALLBACK);
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 			count_mthp_stat(order, MTHP_STAT_SHMEM_FALLBACK);
-#endif
 			order = next_order(&suitable_orders, order);
 		}
 	} else {
@@ -1835,10 +1833,8 @@ allocated:
 				count_vm_event(THP_FILE_FALLBACK);
 				count_vm_event(THP_FILE_FALLBACK_CHARGE);
 			}
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 			count_mthp_stat(folio_order(folio), MTHP_STAT_SHMEM_FALLBACK);
 			count_mthp_stat(folio_order(folio), MTHP_STAT_SHMEM_FALLBACK_CHARGE);
-#endif
 		}
 		goto unlock;
 	}
@@ -2332,9 +2328,7 @@ repeat:
 		if (!IS_ERR(folio)) {
 			if (folio_test_pmd_mappable(folio))
 				count_vm_event(THP_FILE_ALLOC);
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 			count_mthp_stat(folio_order(folio), MTHP_STAT_SHMEM_ALLOC);
-#endif
 			goto alloced;
 		}
 		if (PTR_ERR(folio) == -EEXIST)
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


