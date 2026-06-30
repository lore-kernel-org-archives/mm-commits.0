Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5314384232
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 19:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782849062; cv=none; b=ocVtUMuFcGyKId2OUwEH9YUq1Rw6Mag7sMWyJizkPnz7QFwmjDM8KCdM/7bYtdq3hxQCf+2X5MMUfhn1SwhgsP/uL+uMB5EKu8PK3nYywEiRZEC3YXuX1+QVB2wwuUy/jwicme9UzhmmimxhIC5FyV1hKiAGTir940t0TInb0q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782849062; c=relaxed/simple;
	bh=GEiyx1a9+owUnmNbyx7hajq+2OJTOgKtihYcB9yPqdg=;
	h=Date:To:From:Subject:Message-Id; b=TcHkyVtRwOTzcJeoDYY6qVSUcPq39TUNrWggJ7fIE3P5Xf4NS3vlHSu4FSp6mrsE6nRa0xiO2lQCl6bNLrGrTzJVf1yomOFOkDGmxpmtIi4+ZXTShqFmSFzP3onp/vF7tX5ggjQu2K4PqGg72bbn9HDwZjBx2JQtNTS0kkTJ1xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YwdYX3RY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YwdYX3RY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5121F000E9;
	Tue, 30 Jun 2026 19:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782849060;
	bh=1q4cXAHc7L+zHGsHhYc1nhRawT0EFRy2EOgoNgPFCb0=;
	h=Date:To:From:Subject;
	b=YwdYX3RY/g3lS+Nw41uZTu2t63y58EMT0pNTetSjGO6qQLhKpGxLC+Q6njOh78i/s
	 pVif7wz/tl3T2djQrseTquhHMCtxHxNLTCdeD/HU7ZPlgbnO19/9vwEitPZafH8/s3
	 t4Rie4BcvKw+QNIDYc7RHVL6ij46MtwY/t4cnNvQ=
Date: Tue, 30 Jun 2026 12:50:59 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-extract-mm_prepare_for_swap_entries-helper.patch added to mm-new branch
Message-Id: <20260630195100.4D5121F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: extract mm_prepare_for_swap_entries() helper
has been added to the -mm mm-new branch.  Its filename is
     mm-extract-mm_prepare_for_swap_entries-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-extract-mm_prepare_for_swap_entries-helper.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: mm: extract mm_prepare_for_swap_entries() helper
Date: Tue, 30 Jun 2026 09:34:39 -0700

When a swap entry is installed in a page table, the mm must be added to
init_mm.mmlist so that swapoff can find and unuse its swap entries.  This
double-checked locking pattern is currently open-coded in
try_to_unmap_one() and copy_nonpresent_pte().

Move it into mm_prepare_for_swap_entries() in mm/internal.h and convert
both callers so it can be reused by upcoming PMD-level swap entry code
paths that also need to register the mm with swapoff.

copy_nonpresent_pte() previously inserted into &src_mm->mmlist rather than
&init_mm.mmlist, but the insertion point is irrelevant, mmlist is a
circular list and swapoff walks it entirely from init_mm.mmlist, so only
membership matters, not position.

Link: https://lore.kernel.org/20260630164143.1595669-3-usama.arif@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   13 +++++++++++++
 mm/memory.c   |    9 +--------
 mm/rmap.c     |    7 +------
 3 files changed, 15 insertions(+), 14 deletions(-)

--- a/mm/internal.h~mm-extract-mm_prepare_for_swap_entries-helper
+++ a/mm/internal.h
@@ -1956,4 +1956,17 @@ static inline int get_sysctl_max_map_cou
 bool may_expand_vm(struct mm_struct *mm, const vma_flags_t *vma_flags,
 		   unsigned long npages);
 
+/*
+ * Ensure @mm is on the init_mm.mmlist so swapoff can find it.
+ */
+static inline void mm_prepare_for_swap_entries(struct mm_struct *mm)
+{
+	if (list_empty(&mm->mmlist)) {
+		spin_lock(&mmlist_lock);
+		if (list_empty(&mm->mmlist))
+			list_add(&mm->mmlist, &init_mm.mmlist);
+		spin_unlock(&mmlist_lock);
+	}
+}
+
 #endif	/* __MM_INTERNAL_H */
--- a/mm/memory.c~mm-extract-mm_prepare_for_swap_entries-helper
+++ a/mm/memory.c
@@ -953,14 +953,7 @@ copy_nonpresent_pte(struct mm_struct *ds
 		if (swap_dup_entry_direct(entry) < 0)
 			return -EIO;
 
-		/* make sure dst_mm is on swapoff's mmlist. */
-		if (unlikely(list_empty(&dst_mm->mmlist))) {
-			spin_lock(&mmlist_lock);
-			if (list_empty(&dst_mm->mmlist))
-				list_add(&dst_mm->mmlist,
-						&src_mm->mmlist);
-			spin_unlock(&mmlist_lock);
-		}
+		mm_prepare_for_swap_entries(dst_mm);
 		/* Mark the swap entry as shared. */
 		if (pte_swp_exclusive(orig_pte)) {
 			pte = pte_swp_clear_exclusive(orig_pte);
--- a/mm/rmap.c~mm-extract-mm_prepare_for_swap_entries-helper
+++ a/mm/rmap.c
@@ -2304,12 +2304,7 @@ static bool try_to_unmap_one(struct foli
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				goto walk_abort;
 			}
-			if (list_empty(&mm->mmlist)) {
-				spin_lock(&mmlist_lock);
-				if (list_empty(&mm->mmlist))
-					list_add(&mm->mmlist, &init_mm.mmlist);
-				spin_unlock(&mmlist_lock);
-			}
+			mm_prepare_for_swap_entries(mm);
 			dec_mm_counter(mm, MM_ANONPAGES);
 			inc_mm_counter(mm, MM_SWAPENTS);
 			swp_pte = swp_entry_to_pte(entry);
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-swap_state-remove-unnecessary-lru_add_drain-from-readahead.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2.patch
mm-vmpressure-split-v1-userspace-eventfd-code-into-vmpressure-v1c.patch
mm-add-softleaf_to_pmd-and-convert-existing-callers.patch
mm-extract-mm_prepare_for_swap_entries-helper.patch
fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker.patch
mm-huge_memory-move-softleaf_to_folio-inside-migration-branch.patch
mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch.patch
mm-rename-arch_enable_thp_migration-to-arch_supports_pmd_softleaf.patch

