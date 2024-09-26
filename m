Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8E31411EB
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 20:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727382756; cv=none; b=rUAyiJJqYaiTzVOXq+4Pffw0PWhh3Kt7oOysqkupuT+VkYFe8BM8k3HCuvGK9RGme+x8ZfTxvlpnEdEHZH8PEVSgX6SobCQ7UIt+7JhRPA0FG9MHvkQnh3e5Tkyq8FBehujUbT9YTCn8nTRkZFHwRnqBb3pao2uKC9bXzxPbGRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727382756; c=relaxed/simple;
	bh=6q7/eQIiC0D6r8J0JpoawdaNp2JncjObsptK229gbTg=;
	h=Date:To:From:Subject:Message-Id; b=hlpizx96t89SIuVNFWS+qNa/+tTsdBVZahaT51E3C7Qw9GvQB+fHN035joTf3XgUhlH66TOmKUDEp+5PDEPNvAICCUnsuyE0FWVg2CqM17z1MT5UL5WzSUeZI+TZO6ImZHKzofX9tUc1sP3Kv3NsHTcBuYILZbZy+GimM12d+xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=toLCYA6B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="toLCYA6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DF4C4CEC5;
	Thu, 26 Sep 2024 20:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727382756;
	bh=6q7/eQIiC0D6r8J0JpoawdaNp2JncjObsptK229gbTg=;
	h=Date:To:From:Subject:From;
	b=toLCYA6Bz5sTNJW24gjqkahM7UP4KgWuZJZ5ckRQIspRgGPMcT51pCUazkIc5Wf3u
	 L02712ImyQojcotPN0DJCLRjVQh7e47QpVvpe4Wqf4MVnuXt5o6lNnl6tLSbXfzPR3
	 2fDy3zir9Uznf97mJ8Ikg0DxOpl+oFDqUv5HcQqA=
Date: Thu, 26 Sep 2024 13:32:35 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-__collapse_huge_page_swapin-use-pte_offset_map_ro_nolock.patch added to mm-unstable branch
Message-Id: <20240926203236.50DF4C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: khugepaged: __collapse_huge_page_swapin() use pte_offset_map_ro_nolock()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-__collapse_huge_page_swapin-use-pte_offset_map_ro_nolock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-__collapse_huge_page_swapin-use-pte_offset_map_ro_nolock.patch

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
Subject: mm: khugepaged: __collapse_huge_page_swapin() use pte_offset_map_ro_nolock()
Date: Thu, 26 Sep 2024 14:46:17 +0800

In __collapse_huge_page_swapin(), we just use the ptl for pte_same() check
in do_swap_page().  In other places, we directly use
pte_offset_map_lock(), so convert it to using pte_offset_map_ro_nolock().

Link: https://lkml.kernel.org/r/dc97a6c3cb9ea80cab30c5626eeea79959d93258.1727332572.git.zhengqi.arch@bytedance.com
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

 mm/khugepaged.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-__collapse_huge_page_swapin-use-pte_offset_map_ro_nolock
+++ a/mm/khugepaged.c
@@ -1014,7 +1014,11 @@ static int __collapse_huge_page_swapin(s
 		};
 
 		if (!pte++) {
-			pte = pte_offset_map_nolock(mm, pmd, address, &ptl);
+			/*
+			 * Here the ptl is only used to check pte_same() in
+			 * do_swap_page(), so readonly version is enough.
+			 */
+			pte = pte_offset_map_ro_nolock(mm, pmd, address, &ptl);
 			if (!pte) {
 				mmap_read_unlock(mm);
 				result = SCAN_PMD_NULL;
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

