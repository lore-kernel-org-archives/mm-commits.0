Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FCB40855
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917821; cv=none; b=olt3PYDqh6BPXX/ywAeVuX55ksW+OPraNc7uW8RKdZfkd9yj8QGeLEvLagitJFvvp0tDCjpe0RPrVvsgXdeY9rHPDMKtiXrrSZdnMKIzWxk33CjbpWQEdjKjfq+YhqPxSDcKOKaMweyRWTQXgqCWgScP0aHAyV753AOIpsxycEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917821; c=relaxed/simple;
	bh=tUnoB5SeQdOf7xyydOYKTeBOS5maK53wVr9jVQXtkrw=;
	h=Date:To:From:Subject:Message-Id; b=DDiXLBAAzCbxEgGIn70ppg3TI2kKny932cZRj+0XxqTzRPP2cXo6K9eE8yC0AtxuIqD2Z9dwZW2QunMXfgkqhwKOi/LryUonBBvlcX0oQMx/9I5SgDwaPu2bnokpxGouDZla28+Aus3WpmOfnFLkJr7M/4HMV2rqyablCfJOi6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=it+4IENZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="it+4IENZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272DAC4CEF7;
	Tue, 31 Mar 2026 00:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917821;
	bh=tUnoB5SeQdOf7xyydOYKTeBOS5maK53wVr9jVQXtkrw=;
	h=Date:To:From:Subject:From;
	b=it+4IENZo+Y5+y9X5bjsIf2kBZ+KWsSTQ+xJpfntJogH/anmRJL2Qh86vRtvwi+d9
	 uTo9GHxI0JoYxX/UBBc98zpTZqlSsFK4HsIDWlgd9duDu+rpzPjVpL5s6YFq20Pudp
	 HlkQHd4HN/IyIE4Ubkb72joWQL3hZKugUnQ4HFk4=
Date: Mon, 30 Mar 2026 17:43:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge-avoid-big-else-branch-in-zap_huge_pmd.patch removed from -mm tree
Message-Id: <20260331004341.272DAC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge: avoid big else branch in zap_huge_pmd()
has been removed from the -mm tree.  Its filename was
     mm-huge-avoid-big-else-branch-in-zap_huge_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm/huge: avoid big else branch in zap_huge_pmd()
Date: Fri, 20 Mar 2026 18:07:19 +0000

We don't need to have an extra level of indentation, we can simply exit
early in the first two branches.

No functional change intended.

Link: https://lkml.kernel.org/r/6b4d5efdbf5554b8fe788f677d0b50f355eec999.1774029655.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   93 +++++++++++++++++++++++----------------------
 1 file changed, 48 insertions(+), 45 deletions(-)

--- a/mm/huge_memory.c~mm-huge-avoid-big-else-branch-in-zap_huge_pmd
+++ a/mm/huge_memory.c
@@ -2405,8 +2405,10 @@ static inline void zap_deposited_table(s
 int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
-	pmd_t orig_pmd;
+	struct folio *folio = NULL;
+	int flush_needed = 1;
 	spinlock_t *ptl;
+	pmd_t orig_pmd;
 
 	tlb_change_page_size(tlb, HPAGE_PMD_SIZE);
 
@@ -2427,59 +2429,60 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
-	} else if (is_huge_zero_pmd(orig_pmd)) {
+		return 1;
+	}
+	if (is_huge_zero_pmd(orig_pmd)) {
 		if (!vma_is_dax(vma) || arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
-	} else {
-		struct folio *folio = NULL;
-		int flush_needed = 1;
+		return 1;
+	}
+
+	if (pmd_present(orig_pmd)) {
+		struct page *page = pmd_page(orig_pmd);
 
-		if (pmd_present(orig_pmd)) {
-			struct page *page = pmd_page(orig_pmd);
+		folio = page_folio(page);
+		folio_remove_rmap_pmd(folio, page, vma);
+		WARN_ON_ONCE(folio_mapcount(folio) < 0);
+		VM_BUG_ON_PAGE(!PageHead(page), page);
+	} else if (pmd_is_valid_softleaf(orig_pmd)) {
+		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
 
-			folio = page_folio(page);
-			folio_remove_rmap_pmd(folio, page, vma);
-			WARN_ON_ONCE(folio_mapcount(folio) < 0);
-			VM_BUG_ON_PAGE(!PageHead(page), page);
-		} else if (pmd_is_valid_softleaf(orig_pmd)) {
-			const softleaf_t entry = softleaf_from_pmd(orig_pmd);
-
-			folio = softleaf_to_folio(entry);
-			flush_needed = 0;
-
-			if (!thp_migration_supported())
-				WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
-		}
+		folio = softleaf_to_folio(entry);
+		flush_needed = 0;
+
+		if (!thp_migration_supported())
+			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
+	}
 
-		if (folio_test_anon(folio)) {
+	if (folio_test_anon(folio)) {
+		zap_deposited_table(tlb->mm, pmd);
+		add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
+	} else {
+		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
-			add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
-		} else {
-			if (arch_needs_pgtable_deposit())
-				zap_deposited_table(tlb->mm, pmd);
-			add_mm_counter(tlb->mm, mm_counter_file(folio),
-				       -HPAGE_PMD_NR);
-
-			/*
-			 * Use flush_needed to indicate whether the PMD entry
-			 * is present, instead of checking pmd_present() again.
-			 */
-			if (flush_needed && pmd_young(orig_pmd) &&
-			    likely(vma_has_recency(vma)))
-				folio_mark_accessed(folio);
-		}
-
-		if (folio_is_device_private(folio)) {
-			folio_remove_rmap_pmd(folio, &folio->page, vma);
-			WARN_ON_ONCE(folio_mapcount(folio) < 0);
-			folio_put(folio);
-		}
+		add_mm_counter(tlb->mm, mm_counter_file(folio),
+			       -HPAGE_PMD_NR);
 
-		spin_unlock(ptl);
-		if (flush_needed)
-			tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
+		/*
+		 * Use flush_needed to indicate whether the PMD entry
+		 * is present, instead of checking pmd_present() again.
+		 */
+		if (flush_needed && pmd_young(orig_pmd) &&
+		    likely(vma_has_recency(vma)))
+			folio_mark_accessed(folio);
 	}
+
+	if (folio_is_device_private(folio)) {
+		folio_remove_rmap_pmd(folio, &folio->page, vma);
+		WARN_ON_ONCE(folio_mapcount(folio) < 0);
+		folio_put(folio);
+	}
+
+	spin_unlock(ptl);
+	if (flush_needed)
+		tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
+
 	return 1;
 }
 
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

