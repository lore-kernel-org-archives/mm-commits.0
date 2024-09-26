Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145E61411EB
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 20:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727382755; cv=none; b=nIs8nqC+L4X22N1sPxfcz2Ue/0C6N/h/Cuc5NFPf6Fk6oUDPeZ7YbG7Yvv5FRHyBvBk48pdLHq3yYwKa3WhkTf6zq8jAZYp5Fl8hq6L0RuglUyPbC03jnK3LdTR+J6ZHoUV781uwrbteGyH6jW33J3HuaF0uGZajwa+CL+dGcU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727382755; c=relaxed/simple;
	bh=u8HVc2fi5LoYmrxEyao/sdd1SWuAkjdQJI77YezXE74=;
	h=Date:To:From:Subject:Message-Id; b=AYFzkv5swRcAObk/jPYdhHVbd2eDcirB+/FMEHrpbUZ+SjpuJlhrgXopOP4oNBjUcn6lQS490d9Ib0lNnkOaWCiI48WaMxaNuUKZ0ZfM4qeV55CvYbhzhP8AhdCZhJSEDzCU9NJq5NcqfDq39di0qWYJyJrr7Oe/cdOb+t6CFio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ot7zUY2U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ot7zUY2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F8FC4CEC5;
	Thu, 26 Sep 2024 20:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727382754;
	bh=u8HVc2fi5LoYmrxEyao/sdd1SWuAkjdQJI77YezXE74=;
	h=Date:To:From:Subject:From;
	b=ot7zUY2Umt2TODIhKQw+LcywUbLjQk8bP8HLZx52ve5Fv6p9BGtldn4mgpK99RSAf
	 6SJZTBcwnRRC06uFZXtWdau3eAggdNH50PJF5bG/ItzJ3qr21igeJK5O1a7B2OeZgE
	 Gesh1z5MZebw689idKssODdEZ0x+oinSyq1t42pw=
Date: Thu, 26 Sep 2024 13:32:34 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-filemap_fault_recheck_pte_none-use-pte_offset_map_ro_nolock.patch added to mm-unstable branch
Message-Id: <20240926203234.C8F8FC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: filemap: filemap_fault_recheck_pte_none() use pte_offset_map_ro_nolock()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-filemap-filemap_fault_recheck_pte_none-use-pte_offset_map_ro_nolock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-filemap_fault_recheck_pte_none-use-pte_offset_map_ro_nolock.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: filemap: filemap_fault_recheck_pte_none() use pte_offset_map_ro_nolock()
Date: Thu, 26 Sep 2024 14:46:16 +0800

In filemap_fault_recheck_pte_none(), we just do pte_none() check, so
convert it to using pte_offset_map_ro_nolock().

Link: https://lkml.kernel.org/r/9f7cbbaa772385ced1b8931b67a8b9d246c9b82d.1727332572.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/filemap.c~mm-filemap-filemap_fault_recheck_pte_none-use-pte_offset_map_ro_nolock
+++ a/mm/filemap.c
@@ -3258,8 +3258,8 @@ static vm_fault_t filemap_fault_recheck_
 	if (!(vmf->flags & FAULT_FLAG_ORIG_PTE_VALID))
 		return 0;
 
-	ptep = pte_offset_map_nolock(vma->vm_mm, vmf->pmd, vmf->address,
-				     &vmf->ptl);
+	ptep = pte_offset_map_ro_nolock(vma->vm_mm, vmf->pmd, vmf->address,
+					&vmf->ptl);
 	if (unlikely(!ptep))
 		return VM_FAULT_NOPAGE;
 
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-pgtable-introduce-pte_offset_map_rorw_nolock.patch
powerpc-assert_pte_locked-use-pte_offset_map_ro_nolock.patch
mm-filemap-filemap_fault_recheck_pte_none-use-pte_offset_map_ro_nolock.patch
mm-khugepaged-__collapse_huge_page_swapin-use-pte_offset_map_ro_nolock.patch
arm-adjust_pte-use-pte_offset_map_rw_nolock.patch
mm-handle_pte_fault-use-pte_offset_map_rw_nolock.patch
mm-khugepaged-collapse_pte_mapped_thp-use-pte_offset_map_rw_nolock.patch
mm-copy_pte_range-use-pte_offset_map_rw_nolock.patch
mm-mremap-move_ptes-use-pte_offset_map_rw_nolock.patch
mm-page_vma_mapped_walk-map_pte-use-pte_offset_map_rw_nolock.patch
mm-userfaultfd-move_pages_pte-use-pte_offset_map_rw_nolock.patch
mm-multi-gen-lru-walk_pte_range-use-pte_offset_map_rw_nolock.patch
mm-pgtable-remove-pte_offset_map_nolock.patch

