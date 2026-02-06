Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46DD30F534
	for <mm-commits@vger.kernel.org>; Fri,  6 Feb 2026 23:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770421714; cv=none; b=LLrkSLZ6nJ8bDB5A0f7h/E3/4nSAA50gcIGC3Bl0pc5MQSq+aLPNsZEv2PO+bTDiO9P5PZDCA77QGd293FgwiMJjVTTrOivNlPkPByFdmR2GzQ6D+RFzDUBSKU3WaLMkjJfN2xZ4CPpTuNZIWzq450TjD5djuHoTKHgWgx0zSA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770421714; c=relaxed/simple;
	bh=Cj22cDhLt/8nr+rcWff3RvojxESOHO/DdHhPn8JE9J4=;
	h=Date:To:From:Subject:Message-Id; b=M+y20ukp4yPIRsPKK9EypBuoLaXsv9aQ+FWRdjQXVkB7MAnhR/Tp0Qmvuw8nmI/VHKoT+dv9ivyWNaZM5OMWU+y1PkRmRqhI1IlTUkPEU3a97VEjEVUOIHECRuxN8XjWdWJZLW+CptqmNCwcjGPowkINFf6k8bXyyn0aLzXyv/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TEzhZ+0D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TEzhZ+0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C98EC116C6;
	Fri,  6 Feb 2026 23:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770421714;
	bh=Cj22cDhLt/8nr+rcWff3RvojxESOHO/DdHhPn8JE9J4=;
	h=Date:To:From:Subject:From;
	b=TEzhZ+0DGl7ydXbBza3RIWXK8J8js/VQmtKDOg2IZnvHHN+ycKxHxlacjAukoI+sR
	 PorxKSw+prmWdc1tV3IrGlik9jX2+e5jm+UI8q5TDFsKs+dLMelTu0w+WoYX9L96FU
	 I7VRv2NGcun7s+dLZFddE6u9I3CECutgLJ6Qa2Tg=
Date: Fri, 06 Feb 2026 15:48:34 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-handle-non-split-locks-correctly-in-zap_empty_pte_table.patch removed from -mm tree
Message-Id: <20260206234834.9C98EC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: handle non-split locks correctly in zap_empty_pte_table()
has been removed from the -mm tree.  Its filename was
     mm-memory-handle-non-split-locks-correctly-in-zap_empty_pte_table.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: mm/memory: handle non-split locks correctly in zap_empty_pte_table()
Date: Mon, 19 Jan 2026 23:07:08 +0100

While we handle pte_lockptr() == pmd_lockptr() correctly in
zap_pte_table_if_empty(), we don't handle it in zap_empty_pte_table(),
making the spin_trylock() always fail and forcing us onto the slow path.

So let's handle the scenario where pte_lockptr() == pmd_lockptr() better,
which can only happen if CONFIG_SPLIT_PTE_PTLOCKS is not set.

This is only relevant once we unlock CONFIG_PT_RECLAIM on architectures
that are not x86-64.

Link: https://lkml.kernel.org/r/20260119220708.3438514-3-david@kernel.org
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-memory-handle-non-split-locks-correctly-in-zap_empty_pte_table
+++ a/mm/memory.c
@@ -1830,16 +1830,18 @@ static bool pte_table_reclaim_possible(u
 	return details && details->reclaim_pt && (end - start >= PMD_SIZE);
 }
 
-static bool zap_empty_pte_table(struct mm_struct *mm, pmd_t *pmd, pmd_t *pmdval)
+static bool zap_empty_pte_table(struct mm_struct *mm, pmd_t *pmd,
+		spinlock_t *ptl, pmd_t *pmdval)
 {
 	spinlock_t *pml = pmd_lockptr(mm, pmd);
 
-	if (!spin_trylock(pml))
+	if (ptl != pml && !spin_trylock(pml))
 		return false;
 
 	*pmdval = pmdp_get(pmd);
 	pmd_clear(pmd);
-	spin_unlock(pml);
+	if (ptl != pml)
+		spin_unlock(pml);
 	return true;
 }
 
@@ -1931,7 +1933,7 @@ retry:
 	 * from being repopulated by another thread.
 	 */
 	if (can_reclaim_pt && direct_reclaim && addr == end)
-		direct_reclaim = zap_empty_pte_table(mm, pmd, &pmdval);
+		direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, &pmdval);
 
 	add_mm_rss_vec(mm, rss);
 	lazy_mmu_mode_disable();
_

Patches currently in -mm which might be from david@kernel.org are


