Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8EA40855
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917837; cv=none; b=Z5aAAKTDAq8mt2sqXCSUdmsnbEhwPSRsLeqx9KCG+qRk0jrGqcZCWU6Lq+/ae1CpfB3N3a8FKaMkANnOHwA3kfjB/dOWgq2rVOIziM3qCG1DEzYKPsEMIiYNz4YY+KLxftTZEQgeT796hXsKGcaTuX5xWC5+mBl+5v0MbtnPl9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917837; c=relaxed/simple;
	bh=o5K5KkVZOAKo+heW9ZE9EdJWrsVSh1hWW8BzJLLX7O8=;
	h=Date:To:From:Subject:Message-Id; b=EYNqGYpk00wkOJXVG2xTNeqQ0huAx7ZXbXMokSfFSy2IQ4CCcgTuabvyVm1m7E8YdsjiNWU9DbkH5TgfvDc9ze5Sxj+yqM/1vXE3Km6XPvtLyzD0xld2vCxXPlPvxTGa5aBaTvAZYZ7bcGCXzxyUeuQH1JM3suUixOpU1dCL9iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qtFVS4H/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qtFVS4H/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074CDC4CEF7;
	Tue, 31 Mar 2026 00:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917837;
	bh=o5K5KkVZOAKo+heW9ZE9EdJWrsVSh1hWW8BzJLLX7O8=;
	h=Date:To:From:Subject:From;
	b=qtFVS4H/hWazRN7vfevCaHeJIBbjd0WnBlM0WSpcqZM09f1/uMvw4MhzFp9NE21F1
	 R27hxEBDeaGAnd/Ln2DikTSnKdgiwloYnVvLZ+kjfz7iTDYB3Jbb0VcXpu8coWrKCP
	 hDNffjEWth5MKqmeidVrkVLBTr128qjbK5v4J/u8=
Date: Mon, 30 Mar 2026 17:43:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-add-and-use-normal_or_softleaf_folio_pmd.patch removed from -mm tree
Message-Id: <20260331004357.074CDC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: add and use normal_or_softleaf_folio_pmd()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-add-and-use-normal_or_softleaf_folio_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm/huge_memory: add and use normal_or_softleaf_folio_pmd()
Date: Fri, 20 Mar 2026 18:07:29 +0000

Now we have pmd_to_softleaf_folio() available to us which also raises a
CONFIG_DEBUG_VM warning if unexpectedly an invalid softleaf entry, we can
now abstract folio handling altogether.

vm_normal_folio() deals with the huge zero page (which is present), as well
as PFN map/mixed map mappings in both cases returning NULL.

Otherwise, we try to obtain the softleaf folio.

This makes the logic far easier to comprehend and has it use the standard
vm_normal_folio_pmd() path for decoding of present entries.

Finally, we have to update the flushing logic to only do so if a folio is
established.

This patch also makes the 'is_present' value more accurate - because PFN
map, mixed map and zero huge pages are present, just not present and
'normal'.

[ljs@kernel.org: avoid bisection hazard]
  Link: https://lkml.kernel.org/r/d0cc6161-77a4-42ba-a411-96c23c78df1b@lucifer.local
Link: https://lkml.kernel.org/r/c2be872d64ef9573b80727d9ab5446cf002f17b5.1774029655.git.ljs@kernel.org
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

 mm/huge_memory.c |   47 ++++++++++++++++++---------------------------
 1 file changed, 19 insertions(+), 28 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-add-and-use-normal_or_softleaf_folio_pmd
+++ a/mm/huge_memory.c
@@ -2419,10 +2419,6 @@ static void zap_huge_pmd_folio(struct mm
 		add_mm_counter(mm, mm_counter_file(folio),
 			       -HPAGE_PMD_NR);
 
-		/*
-		 * Use flush_needed to indicate whether the PMD entry
-		 * is present, instead of checking pmd_present() again.
-		 */
 		if (is_present && pmd_young(pmdval) &&
 		    likely(vma_has_recency(vma)))
 			folio_mark_accessed(folio);
@@ -2433,6 +2429,17 @@ static void zap_huge_pmd_folio(struct mm
 		folio_put(folio);
 }
 
+static struct folio *normal_or_softleaf_folio_pmd(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t pmdval, bool is_present)
+{
+	if (is_present)
+		return vm_normal_folio_pmd(vma, addr, pmdval);
+
+	if (!thp_migration_supported())
+		WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
+	return pmd_to_softleaf_folio(pmdval);
+}
+
 /**
  * zap_huge_pmd - Zap a huge THP which is of PMD size.
  * @tlb: The MMU gather TLB state associated with the operation.
@@ -2467,36 +2474,20 @@ bool zap_huge_pmd(struct mmu_gather *tlb
 						tlb->fullmm);
 	arch_check_zapped_pmd(vma, orig_pmd);
 	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
-	if (vma_is_special_huge(vma))
-		goto out;
-	if (is_huge_zero_pmd(orig_pmd)) {
-		if (!vma_is_dax(vma))
-			has_deposit = true;
-		goto out;
-	}
-
-	if (pmd_present(orig_pmd)) {
-		folio = pmd_folio(orig_pmd);
-		is_present = true;
-	} else if (pmd_is_valid_softleaf(orig_pmd)) {
-		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
-
-		folio = softleaf_to_folio(entry);
-		if (!thp_migration_supported())
-			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
-	} else {
-		WARN_ON_ONCE(true);
-		goto out;
-	}
 
-	zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present, &has_deposit);
+	is_present = pmd_present(orig_pmd);
+	folio = normal_or_softleaf_folio_pmd(vma, addr, orig_pmd, is_present);
+	if (folio)
+		zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present,
+				   &has_deposit);
+	else if (is_huge_zero_pmd(orig_pmd))
+		has_deposit = has_deposit || !vma_is_dax(vma);
 
-out:
 	if (has_deposit)
 		zap_deposited_table(mm, pmd);
 
 	spin_unlock(ptl);
-	if (is_present)
+	if (is_present && folio)
 		tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
 	return true;
 }
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

