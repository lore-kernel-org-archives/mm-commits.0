Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873062EB859
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917838; cv=none; b=jpScCR4L1lT7wF/gSFfMYCBlnsXbga/Fog8Z27gxpWaTEvfCAzmg1eBkdb2jMVjmRDa5zKbE2TZlllgqfE2TF9cH04GHX0hsBNJKY6R80taSqPC5P0f/wNhlf/Qe5YgLYbYmQ0Oe1F7PZloHTm0YxpnEgRhjy+JoqYlOINhaS6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917838; c=relaxed/simple;
	bh=ny4xLew24aWb9vstcS2drZD/PfP184o0vzyRr8gNxPo=;
	h=Date:To:From:Subject:Message-Id; b=OFBfi9SMYtmAiGX88vWj83pIXeHUbJdiowyNg27dnav4BMvCJ4rlwS9SPdyZAOx1ONKGyofSe7+6Zd7C0gFMvw+GXgwVs9SEPwumWWUfoSbjlOocaYgW3HN+pBm5h+n7sEYVdzHkiz4N1k2IXagimKhauBUfKMscJaZkZePeMsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NGQDU2O+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NGQDU2O+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0D3C4CEF7;
	Tue, 31 Mar 2026 00:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917838;
	bh=ny4xLew24aWb9vstcS2drZD/PfP184o0vzyRr8gNxPo=;
	h=Date:To:From:Subject:From;
	b=NGQDU2O+3owwP/lkuG79GkNpVVdtDc9eocl6dSquAtL0k8nk9JjogBW2BcD642X1y
	 YjjBpu3so+TwBotzFY6BkZnEOtSpkDELigX1IsXYvB5GeHWtMjXzVUj7QxO0D4541P
	 2q1Aklmn/yfDL8b+h8kIEyOtGGsH9xWQbypmeo14=
Date: Mon, 30 Mar 2026 17:43:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-add-and-use-has_deposited_pgtable.patch removed from -mm tree
Message-Id: <20260331004358.5F0D3C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: add and use has_deposited_pgtable()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-add-and-use-has_deposited_pgtable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm/huge_memory: add and use has_deposited_pgtable()
Date: Fri, 20 Mar 2026 18:07:30 +0000

Rather than thread has_deposited through zap_huge_pmd(), make things
clearer by adding has_deposited_pgtable() with comments describing why in
each case.

[ljs@kernel.org: fix folio_put()-before-recheck issue, per Sashiko]
  Link: https://lkml.kernel.org/r/0a917f80-902f-49b0-a75f-1bbaf23d7f94@lucifer.local
Link: https://lkml.kernel.org/r/f9db59ca90937e39913d50ecb4f662e2bad17bbb.1774029655.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-add-and-use-has_deposited_pgtable
+++ a/mm/huge_memory.c
@@ -2403,8 +2403,7 @@ static inline void zap_deposited_table(s
 }
 
 static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
-		pmd_t pmdval, struct folio *folio, bool is_present,
-		bool *has_deposit)
+		pmd_t pmdval, struct folio *folio, bool is_present)
 {
 	const bool is_device_private = folio_is_device_private(folio);
 
@@ -2413,7 +2412,6 @@ static void zap_huge_pmd_folio(struct mm
 		folio_remove_rmap_pmd(folio, &folio->page, vma);
 
 	if (folio_test_anon(folio)) {
-		*has_deposit = true;
 		add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 	} else {
 		add_mm_counter(mm, mm_counter_file(folio),
@@ -2440,6 +2438,27 @@ static struct folio *normal_or_softleaf_
 	return pmd_to_softleaf_folio(pmdval);
 }
 
+static bool has_deposited_pgtable(struct vm_area_struct *vma, pmd_t pmdval,
+		struct folio *folio)
+{
+	/* Some architectures require unconditional depositing. */
+	if (arch_needs_pgtable_deposit())
+		return true;
+
+	/*
+	 * Huge zero always deposited except for DAX which handles itself, see
+	 * set_huge_zero_folio().
+	 */
+	if (is_huge_zero_pmd(pmdval))
+		return !vma_is_dax(vma);
+
+	/*
+	 * Otherwise, only anonymous folios are deposited, see
+	 * __do_huge_pmd_anonymous_page().
+	 */
+	return folio && folio_test_anon(folio);
+}
+
 /**
  * zap_huge_pmd - Zap a huge THP which is of PMD size.
  * @tlb: The MMU gather TLB state associated with the operation.
@@ -2452,10 +2471,10 @@ static struct folio *normal_or_softleaf_
 bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
-	bool has_deposit = arch_needs_pgtable_deposit();
 	struct mm_struct *mm = tlb->mm;
 	struct folio *folio = NULL;
 	bool is_present = false;
+	bool has_deposit;
 	spinlock_t *ptl;
 	pmd_t orig_pmd;
 
@@ -2477,12 +2496,9 @@ bool zap_huge_pmd(struct mmu_gather *tlb
 
 	is_present = pmd_present(orig_pmd);
 	folio = normal_or_softleaf_folio_pmd(vma, addr, orig_pmd, is_present);
+	has_deposit = has_deposited_pgtable(vma, orig_pmd, folio);
 	if (folio)
-		zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present,
-				   &has_deposit);
-	else if (is_huge_zero_pmd(orig_pmd))
-		has_deposit = has_deposit || !vma_is_dax(vma);
-
+		zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present);
 	if (has_deposit)
 		zap_deposited_table(mm, pmd);
 
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

