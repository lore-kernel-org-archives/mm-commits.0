Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EE240855
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917834; cv=none; b=dTc5j6gqgGfpcFPjwuEvyxTjZN8vkj0Sq2Xkealq8BlqfeCmre2GYK2ccB+xaNlQZ1n879EZl5wfXSzo/JjUHJ22lPpVYF5tJQWczvn98BZJFkbemjOIfMma1slmDfBGvdnUI8YwCGu4BEyLLaLa6syX8ffzth6QcVoN8Gl+E+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917834; c=relaxed/simple;
	bh=lgS1C6J6cEPmZs7Bv+Gtex1ZEmX3WoJfjJ8gS4hsN3k=;
	h=Date:To:From:Subject:Message-Id; b=MO3Kw00dd6don9siOA72rAssxTCAqGYG0j4CL5VodKGXeLP/9+wBWbes905lcNXy4A/Bo3z4YiKHh1xG7Xma8XAAzw3exaPIgezLsCnilIe0FpjQNLQi9W+I0tIbuCDCPIbVkwJ/siTkoG1L4NgZLJYbrjUlqyGPY6gqHv6+ZW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GIan+5O2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GIan+5O2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29689C4CEF7;
	Tue, 31 Mar 2026 00:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917834;
	bh=lgS1C6J6cEPmZs7Bv+Gtex1ZEmX3WoJfjJ8gS4hsN3k=;
	h=Date:To:From:Subject:From;
	b=GIan+5O2Wxb+UOjT+vFSXigMgbWL2bUED3i3pXKJZKSLFxgn7+HLhK7xT/GDczdup
	 KvaDVEoPH5QwHLDAHNOkWecm2YKzcNCQ8ves9dPXKDV6i+Z/Q6+zbB1RI4Ta4fw13Y
	 Vg+uVpZnOglr2p83nFY0TkGoeZkmNKyVReDRaiGQ=
Date: Mon, 30 Mar 2026 17:43:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-separate-out-the-folio-part-of-zap_huge_pmd.patch removed from -mm tree
Message-Id: <20260331004354.29689C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: separate out the folio part of zap_huge_pmd()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-separate-out-the-folio-part-of-zap_huge_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm/huge_memory: separate out the folio part of zap_huge_pmd()
Date: Fri, 20 Mar 2026 18:07:27 +0000

Place the part of the logic that manipulates counters and possibly updates
the accessed bit of the folio into its own function to make zap_huge_pmd()
more readable.

Also rename flush_needed to is_present as we only require a flush for
present entries.

Additionally add comments as to why we're doing what we're doing with
respect to softleaf entries.

This also lays the ground for further refactoring.

Link: https://lkml.kernel.org/r/6c4db67952f5529da4db102a6149b9050b5dda4e.1774029655.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
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
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   61 +++++++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 26 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-separate-out-the-folio-part-of-zap_huge_pmd
+++ a/mm/huge_memory.c
@@ -2402,6 +2402,37 @@ static inline void zap_deposited_table(s
 	mm_dec_nr_ptes(mm);
 }
 
+static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
+		pmd_t pmdval, struct folio *folio, bool is_present,
+		bool *has_deposit)
+{
+	const bool is_device_private = folio_is_device_private(folio);
+
+	/* Present and device private folios are rmappable. */
+	if (is_present || is_device_private)
+		folio_remove_rmap_pmd(folio, &folio->page, vma);
+
+	if (folio_test_anon(folio)) {
+		*has_deposit = true;
+		add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
+	} else {
+		add_mm_counter(mm, mm_counter_file(folio),
+			       -HPAGE_PMD_NR);
+
+		/*
+		 * Use flush_needed to indicate whether the PMD entry
+		 * is present, instead of checking pmd_present() again.
+		 */
+		if (is_present && pmd_young(pmdval) &&
+		    likely(vma_has_recency(vma)))
+			folio_mark_accessed(folio);
+	}
+
+	/* Device private folios are pinned. */
+	if (is_device_private)
+		folio_put(folio);
+}
+
 /**
  * zap_huge_pmd - Zap a huge THP which is of PMD size.
  * @tlb: The MMU gather TLB state associated with the operation.
@@ -2417,7 +2448,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb
 	bool has_deposit = arch_needs_pgtable_deposit();
 	struct mm_struct *mm = tlb->mm;
 	struct folio *folio = NULL;
-	bool flush_needed = false;
+	bool is_present = false;
 	spinlock_t *ptl;
 	pmd_t orig_pmd;
 
@@ -2446,14 +2477,11 @@ bool zap_huge_pmd(struct mmu_gather *tlb
 
 	if (pmd_present(orig_pmd)) {
 		folio = pmd_folio(orig_pmd);
-
-		flush_needed = true;
-		folio_remove_rmap_pmd(folio, &folio->page, vma);
+		is_present = true;
 	} else if (pmd_is_valid_softleaf(orig_pmd)) {
 		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
 
 		folio = softleaf_to_folio(entry);
-
 		if (!thp_migration_supported())
 			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
 	} else {
@@ -2461,33 +2489,14 @@ bool zap_huge_pmd(struct mmu_gather *tlb
 		goto out;
 	}
 
-	if (folio_test_anon(folio)) {
-		has_deposit = true;
-		add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
-	} else {
-		add_mm_counter(mm, mm_counter_file(folio),
-			       -HPAGE_PMD_NR);
-
-		/*
-		 * Use flush_needed to indicate whether the PMD entry
-		 * is present, instead of checking pmd_present() again.
-		 */
-		if (flush_needed && pmd_young(orig_pmd) &&
-		    likely(vma_has_recency(vma)))
-			folio_mark_accessed(folio);
-	}
-
-	if (folio_is_device_private(folio)) {
-		folio_remove_rmap_pmd(folio, &folio->page, vma);
-		folio_put(folio);
-	}
+	zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present, &has_deposit);
 
 out:
 	if (has_deposit)
 		zap_deposited_table(mm, pmd);
 
 	spin_unlock(ptl);
-	if (flush_needed)
+	if (is_present)
 		tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
 	return true;
 }
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

