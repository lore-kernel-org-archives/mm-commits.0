Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733F13BA236
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439068; cv=none; b=nYWV6htxHQdXxcYnl6iyAnxNzs4WsHo+MHyBpyr3AQxARKOUzakEubLALIr8ug0LxuDfmzBy6GowrMi0r63OvFfXEWyWFpzplxt3LN58QbKaY+p9NTm89uRkvAMrgByQUcX2AYQM/+y60EhJTL6fe/emu1X+HiJwY4EOZjXD/tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439068; c=relaxed/simple;
	bh=qkA0i2LeI3nk8j9IQtPbtVpUQekGCLj38TsIe5ip8Sg=;
	h=Date:To:From:Subject:Message-Id; b=fzwvWOJtTnF8Hs8UUR4C1PwIATr1feY7JeedJ2fBry/YIjWxALp0Clwp3UO760VZwcMbp3LHfD9f4RdDNm/CeAct9Ggn6nMEVVXLiyy+2+AopBBkRHWxBdoHvFRZPog/77VEwLNIldoi7tMq5JFewFoIY6BbPy18KIRyCgTVgPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TqWzc5WP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TqWzc5WP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0816F1F00893;
	Tue,  2 Jun 2026 22:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439067;
	bh=2u6+FdoG74A5iLhFD1RmPtql2q/fjZ7p8jHt+MkRMHo=;
	h=Date:To:From:Subject;
	b=TqWzc5WPPvJtDpfh0Hcvwku9A+o9371V4qYeEAGg5d/Z//+BJhJ8zHkvQJwiAnYt9
	 WpWfl9Hy8IAG8j6DTLIqZGDYs/xEjoLcJf6xnepafWirQBgL6zmUYhw/xKMsniyl+3
	 OPm6eoULPrVB38i6KAqTHxIXID5jSpM0FAapo75E=
Date: Tue, 02 Jun 2026 15:24:26 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,youngjun.park@lge.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,ljs@kernel.org,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-move-thp-gfp-limit-helper-into-header.patch removed from -mm tree
Message-Id: <20260602222427.0816F1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: move THP gfp limit helper into header
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-move-thp-gfp-limit-helper-into-header.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/huge_memory: move THP gfp limit helper into header
Date: Sun, 17 May 2026 23:39:42 +0800

Shmem has some special requirements for THP GFP and has to limit it in
certain zones or provide a more lenient fallback.

We'll use this helper for generic swap THP allocation, which needs to
support shmem.  For a typical GFP_HIGHUSER_MOVABLE swap-in, this helper is
basically a no-op.  But it's necessary for certain shmem users, mostly
drivers.

No feature change.

Link: https://lore.kernel.org/20260517-swap-table-p4-v5-3-88ae43e064c7@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   30 ++++++++++++++++++++++++++++++
 mm/shmem.c              |   30 +++---------------------------
 2 files changed, 33 insertions(+), 27 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-move-thp-gfp-limit-helper-into-header
+++ a/include/linux/huge_mm.h
@@ -238,6 +238,31 @@ static inline bool thp_vma_suitable_orde
 }
 
 /*
+ * Make sure huge_gfp is always more limited than limit_gfp.
+ * Some shmem users want THP allocation to be done less aggressively
+ * and only in certain zone.
+ */
+static inline gfp_t thp_shmem_limit_gfp_mask(gfp_t huge_gfp, gfp_t limit_gfp)
+{
+	gfp_t allowflags = __GFP_IO | __GFP_FS | __GFP_RECLAIM;
+	gfp_t denyflags = __GFP_NOWARN | __GFP_NORETRY;
+	gfp_t zoneflags = limit_gfp & GFP_ZONEMASK;
+	gfp_t result = huge_gfp & ~(allowflags | GFP_ZONEMASK);
+
+	/* Allow allocations only from the originally specified zones. */
+	result |= zoneflags;
+
+	/*
+	 * Minimize the result gfp by taking the union with the deny flags,
+	 * and the intersection of the allow flags.
+	 */
+	result |= (limit_gfp & denyflags);
+	result |= (huge_gfp & limit_gfp) & allowflags;
+
+	return result;
+}
+
+/*
  * Filter the bitfield of input orders to the ones suitable for use in the vma.
  * See thp_vma_suitable_order().
  * All orders that pass the checks are returned as a bitfield.
@@ -581,6 +606,11 @@ static inline bool thp_vma_suitable_orde
 	return false;
 }
 
+static inline gfp_t thp_shmem_limit_gfp_mask(gfp_t huge_gfp, gfp_t limit_gfp)
+{
+	return huge_gfp;
+}
+
 static inline unsigned long thp_vma_suitable_orders(struct vm_area_struct *vma,
 		unsigned long addr, unsigned long orders)
 {
--- a/mm/shmem.c~mm-huge_memory-move-thp-gfp-limit-helper-into-header
+++ a/mm/shmem.c
@@ -1791,30 +1791,6 @@ static struct folio *shmem_swapin_cluste
 	return folio;
 }
 
-/*
- * Make sure huge_gfp is always more limited than limit_gfp.
- * Some of the flags set permissions, while others set limitations.
- */
-static gfp_t limit_gfp_mask(gfp_t huge_gfp, gfp_t limit_gfp)
-{
-	gfp_t allowflags = __GFP_IO | __GFP_FS | __GFP_RECLAIM;
-	gfp_t denyflags = __GFP_NOWARN | __GFP_NORETRY;
-	gfp_t zoneflags = limit_gfp & GFP_ZONEMASK;
-	gfp_t result = huge_gfp & ~(allowflags | GFP_ZONEMASK);
-
-	/* Allow allocations only from the originally specified zones. */
-	result |= zoneflags;
-
-	/*
-	 * Minimize the result gfp by taking the union with the deny flags,
-	 * and the intersection of the allow flags.
-	 */
-	result |= (limit_gfp & denyflags);
-	result |= (huge_gfp & limit_gfp) & allowflags;
-
-	return result;
-}
-
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 bool shmem_hpage_pmd_enabled(void)
 {
@@ -2065,7 +2041,7 @@ static struct folio *shmem_swap_alloc_fo
 		     non_swapcache_batch(entry, nr_pages) != nr_pages)
 			goto fallback;
 
-		alloc_gfp = limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
+		alloc_gfp = thp_shmem_limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
 	}
 retry:
 	new = shmem_alloc_folio(alloc_gfp, order, info, index);
@@ -2141,7 +2117,7 @@ static int shmem_replace_folio(struct fo
 	if (nr_pages > 1) {
 		gfp_t huge_gfp = vma_thp_gfp_mask(vma);
 
-		gfp = limit_gfp_mask(huge_gfp, gfp);
+		gfp = thp_shmem_limit_gfp_mask(huge_gfp, gfp);
 	}
 #endif
 
@@ -2548,7 +2524,7 @@ repeat:
 		gfp_t huge_gfp;
 
 		huge_gfp = vma_thp_gfp_mask(vma);
-		huge_gfp = limit_gfp_mask(huge_gfp, gfp);
+		huge_gfp = thp_shmem_limit_gfp_mask(huge_gfp, gfp);
 		folio = shmem_alloc_and_add_folio(vmf, huge_gfp,
 				inode, index, fault_mm, orders);
 		if (!IS_ERR(folio)) {
_

Patches currently in -mm which might be from kasong@tencent.com are


