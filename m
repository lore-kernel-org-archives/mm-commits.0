Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBD513D896
	for <mm-commits@vger.kernel.org>; Thu, 13 Jun 2024 20:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718311597; cv=none; b=RcWip68kytvsKvGNMRolEnKGLcU8176LBzwUByCB086POQ/XYEefeyA49KyrpYHT5mcOBF38vdjlGbeUa7P01xhBgwpA1zkXCaFVBj/bjADC8d+AUvFeGvmZJ1S3SR0J3CGLvKLPIie8/i32UOdwnQyq1O9VV+ppduEN9E5qiCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718311597; c=relaxed/simple;
	bh=Ni11q4rEd+GE+G+i21Oicl45Z2xcdM5KCiwBFpqiDqQ=;
	h=Date:To:From:Subject:Message-Id; b=q/NKKZa6vFD9x8dnEkJ5Or2vzEJPIyjS+6zAtZXjYY+RHG2qjUKkX7FN3uJuGQAP6hveG39v8oTSttlig0VCu9uvlWpjFow09XxhtQWUgk08vlKa2zH4mKXGUwxzGB1ETbj9qGO+4KgdD8DoW14/KIxO+MyOMLYK5XsduEWzekg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a1eN4Luu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a1eN4Luu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E68C2BBFC;
	Thu, 13 Jun 2024 20:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718311597;
	bh=Ni11q4rEd+GE+G+i21Oicl45Z2xcdM5KCiwBFpqiDqQ=;
	h=Date:To:From:Subject:From;
	b=a1eN4LuuSfbCl/GuuYLDfpESBDhAwogdWnDvus7e4hCLE449n7Q4BmcIIM6N+jj5s
	 QPpcOrjle7yQi3NERlu2LPDXalkYcZd+TIzcm8n7oXuEkP1ApAZDlw/iUJRO8MwVII
	 OtPtw90CdzZKzLtQk+Ub+PztZbTEfU/CQGXxJXY0=
Date: Thu, 13 Jun 2024 13:46:36 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-extend-finish_fault-to-support-large-folio-fix.patch added to mm-unstable branch
Message-Id: <20240613204637.17E68C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memory-extend-finish_fault-to-support-large-folio-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-extend-finish_fault-to-support-large-folio-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-extend-finish_fault-to-support-large-folio-fix.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm-memory-extend-finish_fault-to-support-large-folio-fix
Date: Thu, 13 Jun 2024 21:03:36 +0800

avoid going beyond the PMD pagetable size

Link: https://lkml.kernel.org/r/b0e6a8b1-a32c-459e-ae67-fde5d28773e6@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com> 
Reported-by: syzbot+d6e5c328862b5ae6cbfe@syzkaller.appspotmail.com
Fixes: 1c05047ad016 ("mm: memory: extend finish_fault() to support
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-memory-extend-finish_fault-to-support-large-folio-fix
+++ a/mm/memory.c
@@ -4875,13 +4875,17 @@ vm_fault_t finish_fault(struct vm_fault
 		pgoff_t idx = folio_page_idx(folio, page);
 		/* The page offset of vmf->address within the VMA. */
 		pgoff_t vma_off = vmf->pgoff - vmf->vma->vm_pgoff;
+		/* The index of the entry in the pagetable for fault page. */
+		pgoff_t pte_off = pte_index(vmf->address);
 
 		/*
 		 * Fallback to per-page fault in case the folio size in page
-		 * cache beyond the VMA limits.
+		 * cache beyond the VMA limits and PMD pagetable limits.
 		 */
 		if (unlikely(vma_off < idx ||
-			     vma_off + (nr_pages - idx) > vma_pages(vma))) {
+			    vma_off + (nr_pages - idx) > vma_pages(vma) ||
+			    pte_off < idx ||
+			    pte_off + (nr_pages - idx)  > PTRS_PER_PTE - 1)) {
 			nr_pages = 1;
 		} else {
 			/* Now we can set mappings for the whole large folio. */
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-memory-extend-finish_fault-to-support-large-folio.patch
mm-memory-extend-finish_fault-to-support-large-folio-fix.patch
mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix.patch
mm-shmem-add-mthp-support-for-anonymous-shmem.patch
mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem.patch

