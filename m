Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF064AECE
	for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 23:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719270420; cv=none; b=NpwtVagLAZUlRObiPKAK1rlFxAa+HnAoLBJsx50DNMzS/cCATMnKpWFqEhUo4+4Q4DhmhET38xmq4kxgHXHXBWaTV6d+ZNQkk1El9XlKSATziqpDoG4UlFRyHG4NyCbQr9Fuz/ED43HXUn0xrJaqYBcQlQG1cWXu/q/6eoBxFl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719270420; c=relaxed/simple;
	bh=94Ddu5PU9sM/BJUN+K9wfJ67Jr+udQCP9MAxVBuIhSY=;
	h=Date:To:From:Subject:Message-Id; b=cb22Hwcqgu1pV2cBPQ9O2jzhrEKn0ZUqfPL1JAt371f5x0/kZrTsWp4fywzGYPtRUWQY7xgf8IzS9TdRTPcOjEBayUkcPcch5/vcaZnMbPVup2rkHKWmj187nuiI83oSHLBFZO2wtzZGgx3JJoCZxa0d0iEZPrfMNIYh/6En4Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ODxcT/gI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ODxcT/gI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210C1C2BBFC;
	Mon, 24 Jun 2024 23:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719270420;
	bh=94Ddu5PU9sM/BJUN+K9wfJ67Jr+udQCP9MAxVBuIhSY=;
	h=Date:To:From:Subject:From;
	b=ODxcT/gIaB+KM0c5ZhN/EKzvPpxlmCheTVYZMPWg0Le4R8G9hI6e6UkQ6odGq1W7C
	 E4BeTG+nwf77iI04ixf+R0oXTCZ2ngAkDxWlSMQBAefGU8Kls5hdCfuGUe89mQT347
	 CebiI5BpVrRyWuwoHr8bH4IWzlLUt6O0rTVckep4=
Date: Mon, 24 Jun 2024 16:06:59 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,xiehuan09@gmail.com,willy@infradead.org,wangkefeng.wang@huawei.com,songmuchun@bytedance.com,sj@kernel.org,shy828301@gmail.com,ryan.roberts@arm.com,peterx@redhat.com,minchan@kernel.org,mhocko@suse.com,maskray@google.com,libang.li@antgroup.com,fengwei.yin@intel.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list-fix.patch added to mm-unstable branch
Message-Id: <20240624230700.210C1C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list-fix.patch
mm-mlock-implement-folio_mlock_step-using-folio_pte_batch.patch

