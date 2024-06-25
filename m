Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9FA21A0C
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719289863; cv=none; b=MQvjbWmZq7vQE1TMsPXYsiXerNiSManY1lhH+Ycx4F1wmn8tAjoNVRAuFyVXXpPrH302u7fJBMBFopAe44wyLuakZ8qmrVkDsh2qOj6bihdXiJ9aZbhSTcR1qZplEWgnbnfWb6Oc7TpBYg9OsFS1Zu4tgoTdBkmiKqx3FlU1j8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719289863; c=relaxed/simple;
	bh=KvlDxc9JPwlPtCZfcb60DoQih2JpQHjKk40YTlh4Lbc=;
	h=Date:To:From:Subject:Message-Id; b=qfVQ+5fK0ll8Yo84nZ2vz+l+VM3S3WZj2+0yA6oNCElKF2maIygUBqSN6PlohsfiFC05TOKaRi4DzlSqV8kO761bepNu8CGlI/XF5C9gyhRGjN4434dtcOtBDRj+5kn2RpCZIM3Eha8n7/rCNfkQzr0uvki5/FBeLTeKNkNUXIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DXUvQaLZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DXUvQaLZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64E8C32782;
	Tue, 25 Jun 2024 04:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719289863;
	bh=KvlDxc9JPwlPtCZfcb60DoQih2JpQHjKk40YTlh4Lbc=;
	h=Date:To:From:Subject:From;
	b=DXUvQaLZAw5Av5hKhqMmz87C7vwcFJs9UcfudjVUdMNeOsdXUc27ylIWs43bHAHq8
	 gyozmfjZqgs6LqJ6iTYO+yTwh3elfYV60TlXyF/y7TESM2zML+1krBu9pUwps2sL/B
	 ylw2wpsak0fJ9CxqkiLTYx43h5I0USbyh2rMNL+M=
Date: Mon, 24 Jun 2024 21:31:02 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,xiehuan09@gmail.com,willy@infradead.org,wangkefeng.wang@huawei.com,songmuchun@bytedance.com,sj@kernel.org,shy828301@gmail.com,ryan.roberts@arm.com,peterx@redhat.com,minchan@kernel.org,mhocko@suse.com,maskray@google.com,libang.li@antgroup.com,fengwei.yin@intel.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list-fix.patch removed from -mm tree
Message-Id: <20240625043102.E64E8C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list-fix
has been removed from the -mm tree.  Its filename was
     mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list-fix.patch

This patch was dropped because it was folded into mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list.patch

------------------------------------------------------
From: Lance Yang <ioworker0@gmail.com>
Subject: mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list-fix
Date: Sat, 22 Jun 2024 18:00:57 +0800

minor changes suggested by David (https://lore.kernel.org/linux-mm/e7c0aff1-b690-4926-9a34-4e32c9f3faaa@redhat.com/)
Lance

Link: https://lkml.kernel.org/r/20240622100057.3352-1-ioworker0@gmail.com
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Cc: Bang Li <libang.li@antgroup.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Jeff Xie <xiehuan09@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   10 ----------
 mm/rmap.c        |    5 ++---
 2 files changed, 2 insertions(+), 13 deletions(-)

--- a/mm/huge_memory.c~mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list-fix
+++ a/mm/huge_memory.c
@@ -2693,21 +2693,11 @@ static bool __discard_anon_folio_pmd_loc
 					    unsigned long addr, pmd_t *pmdp,
 					    struct folio *folio)
 {
-	VM_WARN_ON_FOLIO(folio_test_swapbacked(folio), folio);
-	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
-
 	struct mm_struct *mm = vma->vm_mm;
 	int ref_count, map_count;
 	pmd_t orig_pmd = *pmdp;
 	struct page *page;
 
-	if (unlikely(!pmd_present(orig_pmd) || !pmd_trans_huge(orig_pmd)))
-		return false;
-
-	page = pmd_page(orig_pmd);
-	if (unlikely(page_folio(page) != folio))
-		return false;
-
 	if (folio_test_dirty(folio) || pmd_dirty(orig_pmd))
 		return false;
 
--- a/mm/rmap.c~mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list-fix
+++ a/mm/rmap.c
@@ -1685,9 +1685,8 @@ static bool try_to_unmap_one(struct foli
 
 			if (flags & TTU_SPLIT_HUGE_PMD) {
 				/*
-				 * We temporarily have to drop the PTL and start
-				 * once again from that now-PTE-mapped page
-				 * table.
+				 * We temporarily have to drop the PTL and
+				 * restart so we can process the PTE-mapped THP.
 				 */
 				split_huge_pmd_locked(vma, pvmw.address,
 						      pvmw.pmd, false, folio);
_

Patches currently in -mm which might be from ioworker0@gmail.com are

mm-rmap-remove-duplicated-exit-code-in-pagewalk-loop.patch
mm-rmap-integrate-pmd-mapped-folio-splitting-into-pagewalk-loop.patch
mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list.patch
mm-mlock-implement-folio_mlock_step-using-folio_pte_batch.patch

