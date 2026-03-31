Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F6740855
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917833; cv=none; b=NamfuSeV4pBJOE1H8f2Pa/MTINiRyB/7SBJnkev7kuMbbQtFjrtSi7Fpl71giC5O7WHt+PqnPEBiVqwWtemNJwLvHosj+zLV3PNPO1ZLiFW6ldqwHg1JSwo2/9wi9jjpTMMr71npwPJpKDCb2VJK1vjatbCCs5mn8sVG/KeHhwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917833; c=relaxed/simple;
	bh=rZjeIHO4/swEQPetZRbeFOPHD82Vruf0OccyNlsqYCU=;
	h=Date:To:From:Subject:Message-Id; b=T6OnDuO/0ZFHFTI3/Xtz410ZS9Ju5jassdXVm/SyqyfbD73B8Imagi3ukEykoVS8Dz+ahU2qih3v6sai0UzGJPtfxN2dVhXDmP19gq1Tm4OAoR593QLNIPT92NML5/YUFNTa5I1bloieMxM9KBU6Gx7jaiiE6cQJthXWxYbf/SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BlsqKsck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BlsqKsck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD10DC4CEF7;
	Tue, 31 Mar 2026 00:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917832;
	bh=rZjeIHO4/swEQPetZRbeFOPHD82Vruf0OccyNlsqYCU=;
	h=Date:To:From:Subject:From;
	b=BlsqKsckxooTYA4TJmRZMFu+vqPByD2NeA8JJU6Y6lJDCyMPydqIFQOPsoEINCK8N
	 EQi+CAdL248Sjr8xqdUcBJ3udXG21UrUlTUAVQiV88hClZR/KH0jLYIN0aIP10jQlp
	 KZipJaZH/vIVxoo3cy1urrJTSHEuOnxl132zIqQI=
Date: Mon, 30 Mar 2026 17:43:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-use-mm-instead-of-tlb-mm.patch removed from -mm tree
Message-Id: <20260331004352.BD10DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: use mm instead of tlb->mm
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-use-mm-instead-of-tlb-mm.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm/huge_memory: use mm instead of tlb->mm
Date: Fri, 20 Mar 2026 18:07:26 +0000

Reduce the repetition, and lay the ground for further refactorings by
keeping this variable separate.

Link: https://lkml.kernel.org/r/98104cde87e4b2aabeb16f236b8731591594457f.1774029655.git.ljs@kernel.org
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

 mm/huge_memory.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-mm-instead-of-tlb-mm
+++ a/mm/huge_memory.c
@@ -2415,6 +2415,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb
 		 pmd_t *pmd, unsigned long addr)
 {
 	bool has_deposit = arch_needs_pgtable_deposit();
+	struct mm_struct *mm = tlb->mm;
 	struct folio *folio = NULL;
 	bool flush_needed = false;
 	spinlock_t *ptl;
@@ -2462,9 +2463,9 @@ bool zap_huge_pmd(struct mmu_gather *tlb
 
 	if (folio_test_anon(folio)) {
 		has_deposit = true;
-		add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
+		add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 	} else {
-		add_mm_counter(tlb->mm, mm_counter_file(folio),
+		add_mm_counter(mm, mm_counter_file(folio),
 			       -HPAGE_PMD_NR);
 
 		/*
@@ -2483,7 +2484,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb
 
 out:
 	if (has_deposit)
-		zap_deposited_table(tlb->mm, pmd);
+		zap_deposited_table(mm, pmd);
 
 	spin_unlock(ptl);
 	if (flush_needed)
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

