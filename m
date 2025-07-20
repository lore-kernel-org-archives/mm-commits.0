Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4583B661
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 00:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752970702; cv=none; b=J2mIlWNmNeAWz16SuBpDSGEk6Y6tx8ew+Mo8ON2ga/ctEpMbYWmdj66h9DYO9+XApgGdFRJt6Qt7wav/7kxCrlkzRYEnlDjtNu0oJGbXCJqg81MVHFXcXOC4EL3NaBcYp8A+ymHivdor+vqZvQFTCqJjFyqtMypglzQntw7JZ88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752970702; c=relaxed/simple;
	bh=5wjBKqFmlk9pmZhn8de8nk7S3RJjPuLAW0yGtc647aU=;
	h=Date:To:From:Subject:Message-Id; b=Fw1x5KYK/MhXn7KaCl3Dezw3U+XL1vtfy3sDVMD/KWqpZUF7VSM8OWbG6Fm6mrnhVtiWmhBIEsPLCcFIPttGeWXpCB7TBoDMh1SulXQUc9xaipDLXfw33xigKUzPfi/IO3xVPPrzMNOZe5+QHZm2CtMWhrMXWIBP9/HuVl89fvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=juD4RxQ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="juD4RxQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36EA8C4CEE3;
	Sun, 20 Jul 2025 00:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752970702;
	bh=5wjBKqFmlk9pmZhn8de8nk7S3RJjPuLAW0yGtc647aU=;
	h=Date:To:From:Subject:From;
	b=juD4RxQ3ZwCWOIAX0u/sfkwcA90umI8GXUlCRxlPaGxma2ryIFscJnWEP3X9Y4BSu
	 JJQ6m8Edj5thkDztfV5hq5H2foVnAOzI5ebgq2OdsMeLYvkkx7PIhbHVIAzu/OL1Od
	 hW2kQEJC4uqlP6BpJyVMTsqUggnKJcDAkfe71a08=
Date: Sat, 19 Jul 2025 17:18:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yangyicong@hisilicon.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,vbabka@suse.cz,ryan.roberts@arm.com,quic_zhenhuah@quicinc.com,peterx@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.brodsky@arm.com,joey.gouly@arm.com,jannh@google.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-optimize-mprotect-for-mm_cp_prot_numa-by-batch-skipping-ptes.patch added to mm-new branch
Message-Id: <20250720001822.36EA8C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: optimize mprotect() for MM_CP_PROT_NUMA by batch-skipping PTEs
has been added to the -mm mm-new branch.  Its filename is
     mm-optimize-mprotect-for-mm_cp_prot_numa-by-batch-skipping-ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-optimize-mprotect-for-mm_cp_prot_numa-by-batch-skipping-ptes.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: Zhenhua Huang <quic_zhenhuah@quicinc.com>
Cc: Zi Yan <ziy@nvidia.com>
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

mm-refactor-mm_cp_prot_numa-skipping-case-into-new-function.patch
mm-optimize-mprotect-for-mm_cp_prot_numa-by-batch-skipping-ptes.patch
mm-add-batched-versions-of-ptep_modify_prot_start-commit.patch
mm-introduce-fpb_respect_write-for-pte-batching-infrastructure.patch
mm-split-can_change_pte_writable-into-private-and-shared-parts.patch
mm-optimize-mprotect-by-pte-batching.patch
arm64-add-batched-versions-of-ptep_modify_prot_start-commit.patch

