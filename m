Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB72E13CABC
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 20:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727382761; cv=none; b=Fq8MsM2OLaU83Yv7T1BGF/fUMqEdm7eqDCylXBrN4fcy4s/jj0hoJ1vFwI23lEkNGQvRKYH9zVzbJr/HYjm/9YTygtQfoVZtztBcDbpsIFB+pXDYjtsb8jSfb2ALAEXASpl/q2sxWQWKb2MaRTT4oSD4ISHftOgpKYgtgycDC/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727382761; c=relaxed/simple;
	bh=tjmgk/KBKEFEWZuu2qiarwUYtZlgEjioY2lMjd35D6s=;
	h=Date:To:From:Subject:Message-Id; b=fcVuwV+ulMh2YAj9X9a2B5/VkmmJhzv+7M3eugOfif3tlQ+YTShjn1EdmeZ43HYI8PV80daabusqF1G+iTrZzIlhMMlXhxbla2IV/kK6Hbj2EMLIv+Vx2DypXiLstGKPSzNMEzslGrAeQT6B4a1mf2R2bw8y1kknt7S36uqjN1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J/QpAO7n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J/QpAO7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD12C4CEC7;
	Thu, 26 Sep 2024 20:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727382761;
	bh=tjmgk/KBKEFEWZuu2qiarwUYtZlgEjioY2lMjd35D6s=;
	h=Date:To:From:Subject:From;
	b=J/QpAO7np82vBQbsslUazRzeh/GezIaSPRu+62AVxbHNCISF9+Jps+UrpSjBg8qDp
	 Uu6TFd6iV1EvhxZ+oOG4cBx2kEL+vSzE1ueu5EvfXBbxwP+Kukscm1HH34UX3eTAqH
	 uu+Fc5MRf3dQ1KQWTmJ6ehvuMmCbND0XurIRnkz0=
Date: Thu, 26 Sep 2024 13:32:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-copy_pte_range-use-pte_offset_map_rw_nolock.patch added to mm-unstable branch
Message-Id: <20240926203241.7CD12C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: copy_pte_range() use pte_offset_map_rw_nolock()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-copy_pte_range-use-pte_offset_map_rw_nolock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-copy_pte_range-use-pte_offset_map_rw_nolock.patch

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
Subject: mm: copy_pte_range() use pte_offset_map_rw_nolock()
Date: Thu, 26 Sep 2024 14:46:21 +0800

In copy_pte_range(), we may modify the src_pte entry after holding the
src_ptl, so convert it to using pte_offset_map_rw_nolock().  Since we
already hold the exclusive mmap_lock, and the copy_pte_range() and
retract_page_tables() are using vma->anon_vma to be exclusive, so the PTE
page is stable, there is no need to get pmdval and do pmd_same() check.

Link: https://lkml.kernel.org/r/9166f6fad806efbca72e318ab6f0f8af458056a9.1727332572.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-copy_pte_range-use-pte_offset_map_rw_nolock
+++ a/mm/memory.c
@@ -1084,6 +1084,7 @@ copy_pte_range(struct vm_area_struct *ds
 	struct mm_struct *src_mm = src_vma->vm_mm;
 	pte_t *orig_src_pte, *orig_dst_pte;
 	pte_t *src_pte, *dst_pte;
+	pmd_t dummy_pmdval;
 	pte_t ptent;
 	spinlock_t *src_ptl, *dst_ptl;
 	int progress, max_nr, ret = 0;
@@ -1109,7 +1110,15 @@ again:
 		ret = -ENOMEM;
 		goto out;
 	}
-	src_pte = pte_offset_map_nolock(src_mm, src_pmd, addr, &src_ptl);
+
+	/*
+	 * We already hold the exclusive mmap_lock, the copy_pte_range() and
+	 * retract_page_tables() are using vma->anon_vma to be exclusive, so
+	 * the PTE page is stable, and there is no need to get pmdval and do
+	 * pmd_same() check.
+	 */
+	src_pte = pte_offset_map_rw_nolock(src_mm, src_pmd, addr, &dummy_pmdval,
+					   &src_ptl);
 	if (!src_pte) {
 		pte_unmap_unlock(dst_pte, dst_ptl);
 		/* ret == 0 */
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

