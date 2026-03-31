Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D410C40855
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917829; cv=none; b=UOfmfWnQfPnY7c8ps3/Olkuht5GiPQ7onw3SJD5GmtttCqyMjHqNzzGIZaXEmDnh7UnlScfvAQlL+7Bm0xerv+f4UisYUPVEpxbHjGdAGiKJgmqDhRiCBoEimChCY/yRRi4RNpyzCvr8r8jaaUkl4tu4SzGHaOB2Hi0zQJ10SRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917829; c=relaxed/simple;
	bh=az160nLGTjFtx/H6KU6zFVC76mFNSpQSw13Iqncmeyg=;
	h=Date:To:From:Subject:Message-Id; b=kBQOLvAghfZIbzJCt+CMrzxr+RDIW2MjQdRs6bwKDcpXgRues1GlsIxSp1zl93jqHF9ISqeYsYPN/4xBeMM0Pcp41gI+dn7BlUtTGxmexLmuriZn1L9fgBnP5mNkOqt7hsHi52qSxovbjO9CipMuCYeVs9nPedFa67d/Aagfyog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iKi+1S4e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iKi+1S4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4EEC4CEF7;
	Tue, 31 Mar 2026 00:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917829;
	bh=az160nLGTjFtx/H6KU6zFVC76mFNSpQSw13Iqncmeyg=;
	h=Date:To:From:Subject:From;
	b=iKi+1S4eLW6Wep9If+AscdCvHVEoS+JzjnWRoJr9A74Bh+wi7Zn7h8g2wKSPAwKEa
	 G/OdCAMMNqXnEit8X3c3UQGg+d99EDHmNblF8tqHqbNbNnCL7r8C3Q2bqEclIMr0EM
	 EYqycxeMJsbwWaV9PLU7+fVSleJKy21qxawJQfqk=
Date: Mon, 30 Mar 2026 17:43:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-deduplicate-zap-deposited-table-call.patch removed from -mm tree
Message-Id: <20260331004349.AE4EEC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: deduplicate zap deposited table call
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-deduplicate-zap-deposited-table-call.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm/huge_memory: deduplicate zap deposited table call
Date: Fri, 20 Mar 2026 18:07:24 +0000

Rather than having separate logic for each case determining whether to zap
the deposited table, simply track this via a boolean.

We default this to whether the architecture requires it, and update it as
required elsewhere.

Link: https://lkml.kernel.org/r/71f576a1fbcd27a86322d12caa937bcdacf75407.1774029655.git.ljs@kernel.org
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
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-deduplicate-zap-deposited-table-call
+++ a/mm/huge_memory.c
@@ -2414,6 +2414,7 @@ static inline void zap_deposited_table(s
 bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
+	bool has_deposit = arch_needs_pgtable_deposit();
 	struct folio *folio = NULL;
 	bool flush_needed = false;
 	spinlock_t *ptl;
@@ -2434,23 +2435,19 @@ bool zap_huge_pmd(struct mmu_gather *tlb
 						tlb->fullmm);
 	arch_check_zapped_pmd(vma, orig_pmd);
 	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
-	if (vma_is_special_huge(vma)) {
-		if (arch_needs_pgtable_deposit())
-			zap_deposited_table(tlb->mm, pmd);
+	if (vma_is_special_huge(vma))
 		goto out;
-	}
 	if (is_huge_zero_pmd(orig_pmd)) {
-		if (!vma_is_dax(vma) || arch_needs_pgtable_deposit())
-			zap_deposited_table(tlb->mm, pmd);
+		if (!vma_is_dax(vma))
+			has_deposit = true;
 		goto out;
 	}
 
 	if (pmd_present(orig_pmd)) {
-		struct page *page = pmd_page(orig_pmd);
+		folio = pmd_folio(orig_pmd);
 
 		flush_needed = true;
-		folio = page_folio(page);
-		folio_remove_rmap_pmd(folio, page, vma);
+		folio_remove_rmap_pmd(folio, &folio->page, vma);
 		WARN_ON_ONCE(folio_mapcount(folio) < 0);
 	} else if (pmd_is_valid_softleaf(orig_pmd)) {
 		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
@@ -2465,11 +2462,9 @@ bool zap_huge_pmd(struct mmu_gather *tlb
 	}
 
 	if (folio_test_anon(folio)) {
-		zap_deposited_table(tlb->mm, pmd);
+		has_deposit = true;
 		add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 	} else {
-		if (arch_needs_pgtable_deposit())
-			zap_deposited_table(tlb->mm, pmd);
 		add_mm_counter(tlb->mm, mm_counter_file(folio),
 			       -HPAGE_PMD_NR);
 
@@ -2489,6 +2484,9 @@ bool zap_huge_pmd(struct mmu_gather *tlb
 	}
 
 out:
+	if (has_deposit)
+		zap_deposited_table(tlb->mm, pmd);
+
 	spin_unlock(ptl);
 	if (flush_needed)
 		tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

