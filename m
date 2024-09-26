Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE79F1411EB
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 20:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727382767; cv=none; b=RFHKqp9Q5QuWV7fTTbGtka7rCR0cBk1LqCumOriJJmn6AXsfz0ZVfzm/P1GqbTT+wm9aNYaQk+k4+xAO0xyL9vUtjIDiiitVH4EJtExrDjl9GsmSm53K2SA9XM3yIOrqYeRmpuQF4UIZrjOth/FxMmFIGVMDQwOGthzwjByepW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727382767; c=relaxed/simple;
	bh=6JuFS4rFZAVeret8QY6UA+O/yWMhAGhKvGlY2LOjAPc=;
	h=Date:To:From:Subject:Message-Id; b=qRkSz0FrxJGMpE8IKBqKi5pqVyCzUC+BiH0T6Dy+4IXVH+tLA1UVDMa2An8hyNv/blJPzR6+95SrHGJwX7RYKUGjidcWCvFcGYO8/0iachdI1yREDIvQZ1hU81peUAz70eKffOly+HZi+giKTREOJ5a4h8DYQXzJiOE3KxMyluk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ON1vNodk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ON1vNodk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824D1C4CEC5;
	Thu, 26 Sep 2024 20:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727382766;
	bh=6JuFS4rFZAVeret8QY6UA+O/yWMhAGhKvGlY2LOjAPc=;
	h=Date:To:From:Subject:From;
	b=ON1vNodkwv0uVNptdltfFSirrU32eN3hKMHIxR/iLrLpwD5fZzsLsr09Rjr+nMGUH
	 qUNg0m4esatReXRBKDl4k9xP2ABpARCEHrgP9wwqpMphp+V7napw8NnhYjZQh4ozeG
	 wg3BuoTqltFHxJ2lIBvlYPOYsnsvIxw1mgpmD5l0=
Date: Thu, 26 Sep 2024 13:32:45 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-walk_pte_range-use-pte_offset_map_rw_nolock.patch added to mm-unstable branch
Message-Id: <20240926203246.824D1C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: multi-gen LRU: walk_pte_range() use pte_offset_map_rw_nolock()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-multi-gen-lru-walk_pte_range-use-pte_offset_map_rw_nolock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-walk_pte_range-use-pte_offset_map_rw_nolock.patch

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
Subject: mm: multi-gen LRU: walk_pte_range() use pte_offset_map_rw_nolock()
Date: Thu, 26 Sep 2024 14:46:25 +0800

In walk_pte_range(), we may modify the pte entry after holding the ptl, so
convert it to using pte_offset_map_rw_nolock().  At this time, the
pte_same() check is not performed after the ptl held, so we should get
pmdval and do pmd_same() check to ensure the stability of pmd entry.

Link: https://lkml.kernel.org/r/7e9c194a5efacc9609cfd31abb9c7df88b53b530.1727332572.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-multi-gen-lru-walk_pte_range-use-pte_offset_map_rw_nolock
+++ a/mm/vmscan.c
@@ -3375,8 +3375,10 @@ static bool walk_pte_range(pmd_t *pmd, u
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
 	DEFINE_MAX_SEQ(walk->lruvec);
 	int old_gen, new_gen = lru_gen_from_seq(max_seq);
+	pmd_t pmdval;
 
-	pte = pte_offset_map_nolock(args->mm, pmd, start & PMD_MASK, &ptl);
+	pte = pte_offset_map_rw_nolock(args->mm, pmd, start & PMD_MASK, &pmdval,
+				       &ptl);
 	if (!pte)
 		return false;
 	if (!spin_trylock(ptl)) {
@@ -3384,6 +3386,11 @@ static bool walk_pte_range(pmd_t *pmd, u
 		return false;
 	}
 
+	if (unlikely(!pmd_same(pmdval, pmdp_get_lockless(pmd)))) {
+		pte_unmap_unlock(pte, ptl);
+		return false;
+	}
+
 	arch_enter_lazy_mmu_mode();
 restart:
 	for (i = pte_index(start), addr = start; addr != end; i++, addr += PAGE_SIZE) {
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

