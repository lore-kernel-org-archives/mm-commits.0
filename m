Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0099E21ABD7
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409731; cv=none; b=CA0ExW2mlfDS3KjjXGTzbs9MprAeLUZ83+eMlb9p/uPvcwgzXgRy2GMJkN+IpRXiwiOueDra6QBxPZRmvWSWgyKdcBrrsnkAUZYuTCxC74qlFArcKBH19awtZ/uf3s9eQCPPbUl7fsaI+1zety167O97NineyM0xwkFlbIX8Se4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409731; c=relaxed/simple;
	bh=hpac3NkX3v6ynffetZ0P6tOO+g6ULBkKeAyVNQyqews=;
	h=Date:To:From:Subject:Message-Id; b=gt98+ORYF7mkfkAvskOxqx64r27kp2ET8guhXnzxgpN9iDQXmQB5gwjj57KQq29B4xQp9LOInXyLrdehD5QB3TwAfbEDx1ZoBKCN2ljDh8kBVjm021e8i9RSdjVsjSk6pjJV9uwf6kySKQw08oFyVvyzGukpUV2gxN89/+F9spY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eQg9axGs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eQg9axGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D0EC4CEED;
	Fri, 25 Jul 2025 02:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409730;
	bh=hpac3NkX3v6ynffetZ0P6tOO+g6ULBkKeAyVNQyqews=;
	h=Date:To:From:Subject:From;
	b=eQg9axGs8EjoRS51b8/wVuWb9dxBZFsa3sDrhN0aDflUmtTXd4LTzVrlFMq/mq9BE
	 v0UGnYBrF1AJhxoK7Ks8BGFCI6w/xyZRR0HiLuTlU7vzqteojJHjMwQfcYsbJg5+X9
	 omwU0MW5H/m5luVFGmZ73Aa1NVE1fh3DZI1TcpH8=
Date: Thu, 24 Jul 2025 19:15:30 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yangyicong@hisilicon.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,vbabka@suse.cz,ryan.roberts@arm.com,quic_zhenhuah@quicinc.com,peterx@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.brodsky@arm.com,joey.gouly@arm.com,jannh@google.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-optimize-mprotect-for-mm_cp_prot_numa-by-batch-skipping-ptes.patch removed from -mm tree
Message-Id: <20250725021530.C8D0EC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: optimize mprotect() for MM_CP_PROT_NUMA by batch-skipping PTEs
has been removed from the -mm tree.  Its filename was
     mm-optimize-mprotect-for-mm_cp_prot_numa-by-batch-skipping-ptes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm: optimize mprotect() for MM_CP_PROT_NUMA by batch-skipping PTEs
Date: Fri, 18 Jul 2025 14:32:39 +0530

For the MM_CP_PROT_NUMA skipping case, observe that, if we skip an
iteration due to the underlying folio satisfying any of the skip
conditions, then for all subsequent ptes which map the same folio, the
iteration will be skipped for them too.  Therefore, we can optimize by
using folio_pte_batch() to batch skip the iterations.

Use prot_numa_skip() introduced in the previous patch to determine whether
we need to skip the iteration.  Change its signature to have a double
pointer to a folio, which will be used by mprotect_folio_pte_batch() to
determine the number of iterations we can safely skip.

Link: https://lkml.kernel.org/r/20250718090244.21092-3-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: Zhenhua Huang <quic_zhenhuah@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   55 ++++++++++++++++++++++++++++++++++++------------
 1 file changed, 42 insertions(+), 13 deletions(-)

--- a/mm/mprotect.c~mm-optimize-mprotect-for-mm_cp_prot_numa-by-batch-skipping-ptes
+++ a/mm/mprotect.c
@@ -83,28 +83,43 @@ bool can_change_pte_writable(struct vm_a
 	return pte_dirty(pte);
 }
 
+static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
+				    pte_t pte, int max_nr_ptes)
+{
+	/* No underlying folio, so cannot batch */
+	if (!folio)
+		return 1;
+
+	if (!folio_test_large(folio))
+		return 1;
+
+	return folio_pte_batch(folio, ptep, pte, max_nr_ptes);
+}
+
 static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
-			   pte_t oldpte, pte_t *pte, int target_node)
+			   pte_t oldpte, pte_t *pte, int target_node,
+			   struct folio **foliop)
 {
-	struct folio *folio;
+	struct folio *folio = NULL;
+	bool ret = true;
 	bool toptier;
 	int nid;
 
 	/* Avoid TLB flush if possible */
 	if (pte_protnone(oldpte))
-		return true;
+		goto skip;
 
 	folio = vm_normal_folio(vma, addr, oldpte);
 	if (!folio)
-		return true;
+		goto skip;
 
 	if (folio_is_zone_device(folio) || folio_test_ksm(folio))
-		return true;
+		goto skip;
 
 	/* Also skip shared copy-on-write pages */
 	if (is_cow_mapping(vma->vm_flags) &&
 	    (folio_maybe_dma_pinned(folio) || folio_maybe_mapped_shared(folio)))
-		return true;
+		goto skip;
 
 	/*
 	 * While migration can move some dirty pages,
@@ -112,7 +127,7 @@ static bool prot_numa_skip(struct vm_are
 	 * context.
 	 */
 	if (folio_is_file_lru(folio) && folio_test_dirty(folio))
-		return true;
+		goto skip;
 
 	/*
 	 * Don't mess with PTEs if page is already on the node
@@ -120,7 +135,7 @@ static bool prot_numa_skip(struct vm_are
 	 */
 	nid = folio_nid(folio);
 	if (target_node == nid)
-		return true;
+		goto skip;
 
 	toptier = node_is_toptier(nid);
 
@@ -129,11 +144,15 @@ static bool prot_numa_skip(struct vm_are
 	 * balancing is disabled
 	 */
 	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) && toptier)
-		return true;
+		goto skip;
 
+	ret = false;
 	if (folio_use_access_time(folio))
 		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
-	return false;
+
+skip:
+	*foliop = folio;
+	return ret;
 }
 
 static long change_pte_range(struct mmu_gather *tlb,
@@ -147,6 +166,7 @@ static long change_pte_range(struct mmu_
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
+	int nr_ptes;
 
 	tlb_change_page_size(tlb, PAGE_SIZE);
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
@@ -161,8 +181,11 @@ static long change_pte_range(struct mmu_
 	flush_tlb_batched_pending(vma->vm_mm);
 	arch_enter_lazy_mmu_mode();
 	do {
+		nr_ptes = 1;
 		oldpte = ptep_get(pte);
 		if (pte_present(oldpte)) {
+			int max_nr_ptes = (end - addr) >> PAGE_SHIFT;
+			struct folio *folio;
 			pte_t ptent;
 
 			/*
@@ -170,9 +193,15 @@ static long change_pte_range(struct mmu_
 			 * pages. See similar comment in change_huge_pmd.
 			 */
 			if (prot_numa) {
-				if (prot_numa_skip(vma, addr, oldpte, pte,
-						   target_node))
+				int ret = prot_numa_skip(vma, addr, oldpte, pte,
+							 target_node, &folio);
+				if (ret) {
+
+					/* determine batch to skip */
+					nr_ptes = mprotect_folio_pte_batch(folio,
+						  pte, oldpte, max_nr_ptes);
 					continue;
+				}
 			}
 
 			oldpte = ptep_modify_prot_start(vma, addr, pte);
@@ -289,7 +318,7 @@ static long change_pte_range(struct mmu_
 				pages++;
 			}
 		}
-	} while (pte++, addr += PAGE_SIZE, addr != end);
+	} while (pte += nr_ptes, addr += nr_ptes * PAGE_SIZE, addr != end);
 	arch_leave_lazy_mmu_mode();
 	pte_unmap_unlock(pte - 1, ptl);
 
_

Patches currently in -mm which might be from dev.jain@arm.com are

khugepaged-optimize-__collapse_huge_page_copy_succeeded-by-pte-batching.patch
khugepaged-optimize-collapse_pte_mapped_thp-by-pte-batching.patch

