Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442ABC8E1
	for <mm-commits@vger.kernel.org>; Sat,  8 Jun 2024 04:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717820389; cv=none; b=jV6lvcjEbot3aKOubAr1AxoDaCB6JP0C3dGMrxt2B55/eLE7GhiLZwl9kGS3/zl1ORT/vqhJmcEkdLex5wSsFFxmLVZBDcDG/4c7ZpQ2k6HqbvUrT+FD9lxcgil39Yre/hBqV1MwQo4Cx5xTZjLg/V0yjEmkPXBkvFzaibrdAlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717820389; c=relaxed/simple;
	bh=7YGPTuiik9Ex+ihapqdVU61UYpuXTKxLCvxV2nFXYFY=;
	h=Date:To:From:Subject:Message-Id; b=j1sZVtnjmbmmK20nKhKQbgaUcL2+Oh61Ro6fr0yeeziQ8BoWleuv6sxmIBlSTwrT+8iLKxOnNwnXZQt61bfUJrr1XPZweISgCzfwWnh8/57FejUobBxN4K9LEeqGXYKz3BQOIcnCckLUtr1mVY1oXTIu5C2LiJkW7pMqMBRR0iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KY30Ec6d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KY30Ec6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1EFDC2BD11;
	Sat,  8 Jun 2024 04:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717820389;
	bh=7YGPTuiik9Ex+ihapqdVU61UYpuXTKxLCvxV2nFXYFY=;
	h=Date:To:From:Subject:From;
	b=KY30Ec6dcGrDkleOfmQHk9EeIuMuMp6Waqgp9JUrZt3ykQWIx5FC5kIthUZq0UFcC
	 /PkZrQYb2lZlUCEYrdq5BaCELoQ9yKcIxVCjKxPnfHDE/Sb2O1/6uJnRHvki5XzLiO
	 cfzhaPmX9+hwXzqSscPhb6aLztxJ5lsW8aLSOVM8=
Date: Fri, 07 Jun 2024 21:19:48 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,ryan.roberts@arm.com,minchan@kernel.org,kasong@tencent.com,david@redhat.com,chrisl@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-pmdpte_needs_soft_dirty_wp-helpers-for-softdirty-write-protect.patch added to mm-unstable branch
Message-Id: <20240608041948.E1EFDC2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce pmd|pte_needs_soft_dirty_wp helpers for softdirty write-protect
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-pmdpte_needs_soft_dirty_wp-helpers-for-softdirty-write-protect.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-pmdpte_needs_soft_dirty_wp-helpers-for-softdirty-write-protect.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: introduce pmd|pte_needs_soft_dirty_wp helpers for softdirty write-protect
Date: Sat, 8 Jun 2024 09:13:57 +1200

Patch series "mm: introduce pmd|pte_needs_soft_dirty_wp helpers and
utilize them", v2.


This patchset introduces the pte_need_soft_dirty_wp and
pmd_need_soft_dirty_wp helpers to determine if write protection is
required for softdirty tracking.  These helpers enhance code readability
and improve the overall appearance.

They are then utilized in gup, mprotect, swap, and other related
functions.


This patch (of 2): 

This patch introduces the pte_needs_soft_dirty_wp and
pmd_needs_soft_dirty_wp helpers to determine if write protection is
required for softdirty tracking.  This can enhance code readability and
improve its overall appearance.  These new helpers are then utilized in
gup, huge_memory, and mprotect.

Link: https://lkml.kernel.org/r/20240607211358.4660-1-21cnbao@gmail.com
Link: https://lkml.kernel.org/r/20240607211358.4660-2-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c         |    4 ++--
 mm/huge_memory.c |    2 +-
 mm/internal.h    |   10 ++++++++++
 mm/mprotect.c    |    2 +-
 4 files changed, 14 insertions(+), 4 deletions(-)

--- a/mm/gup.c~mm-introduce-pmdpte_needs_soft_dirty_wp-helpers-for-softdirty-write-protect
+++ a/mm/gup.c
@@ -820,7 +820,7 @@ static inline bool can_follow_write_pmd(
 		return false;
 
 	/* ... and a write-fault isn't required for other reasons. */
-	if (vma_soft_dirty_enabled(vma) && !pmd_soft_dirty(pmd))
+	if (pmd_needs_soft_dirty_wp(vma, pmd))
 		return false;
 	return !userfaultfd_huge_pmd_wp(vma, pmd);
 }
@@ -941,7 +941,7 @@ static inline bool can_follow_write_pte(
 		return false;
 
 	/* ... and a write-fault isn't required for other reasons. */
-	if (vma_soft_dirty_enabled(vma) && !pte_soft_dirty(pte))
+	if (pte_needs_soft_dirty_wp(vma, pte))
 		return false;
 	return !userfaultfd_pte_wp(vma, pte);
 }
--- a/mm/huge_memory.c~mm-introduce-pmdpte_needs_soft_dirty_wp-helpers-for-softdirty-write-protect
+++ a/mm/huge_memory.c
@@ -1625,7 +1625,7 @@ static inline bool can_change_pmd_writab
 		return false;
 
 	/* Do we need write faults for softdirty tracking? */
-	if (vma_soft_dirty_enabled(vma) && !pmd_soft_dirty(pmd))
+	if (pmd_needs_soft_dirty_wp(vma, pmd))
 		return false;
 
 	/* Do we need write faults for uffd-wp tracking? */
--- a/mm/internal.h~mm-introduce-pmdpte_needs_soft_dirty_wp-helpers-for-softdirty-write-protect
+++ a/mm/internal.h
@@ -1349,6 +1349,16 @@ static inline bool vma_soft_dirty_enable
 	return !(vma->vm_flags & VM_SOFTDIRTY);
 }
 
+static inline bool pmd_needs_soft_dirty_wp(struct vm_area_struct *vma, pmd_t pmd)
+{
+	return vma_soft_dirty_enabled(vma) && !pmd_soft_dirty(pmd);
+}
+
+static inline bool pte_needs_soft_dirty_wp(struct vm_area_struct *vma, pte_t pte)
+{
+	return vma_soft_dirty_enabled(vma) && !pte_soft_dirty(pte);
+}
+
 static inline void vma_iter_config(struct vma_iterator *vmi,
 		unsigned long index, unsigned long last)
 {
--- a/mm/mprotect.c~mm-introduce-pmdpte_needs_soft_dirty_wp-helpers-for-softdirty-write-protect
+++ a/mm/mprotect.c
@@ -53,7 +53,7 @@ bool can_change_pte_writable(struct vm_a
 		return false;
 
 	/* Do we need write faults for softdirty tracking? */
-	if (vma_soft_dirty_enabled(vma) && !pte_soft_dirty(pte))
+	if (pte_needs_soft_dirty_wp(vma, pte))
 		return false;
 
 	/* Do we need write faults for uffd-wp tracking? */
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-remove-the-implementation-of-swap_free-and-always-use-swap_free_nr.patch
mm-introduce-pte_move_swp_offset-helper-which-can-move-offset-bidirectionally.patch
mm-introduce-arch_do_swap_page_nr-which-allows-restore-metadata-for-nr-pages.patch
mm-swap-reuse-exclusive-folio-directly-instead-of-wp-page-faults.patch
mm-introduce-pmdpte_needs_soft_dirty_wp-helpers-for-softdirty-write-protect.patch
mm-set-pte-writable-while-pte_soft_dirty-is-true-in-do_swap_page.patch

