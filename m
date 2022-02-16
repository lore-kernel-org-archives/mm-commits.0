Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE3EFC43217
	for <mm-commits@archiver.kernel.org>; Wed, 16 Feb 2022 00:30:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239961AbiBPAax (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 19:30:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245130AbiBPAap (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 19:30:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22EF6F9FA1
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 16:30:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3F8B615E1
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 00:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0317CC340EB;
        Wed, 16 Feb 2022 00:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644971423;
        bh=rGGIVmgI2NR31URw0vVAF39XVInxdRRNeFotvlngxF4=;
        h=Date:To:From:Subject:From;
        b=N2YOTmHJu0Qubaynr8LtopNJlMagxM5t76mkyhkBM2kzmHCkGf3GC997xR5s8dwP+
         +rdt/kXiR3dsRuDseZPUZ3GqBKxlZZa1d1HwqM8HfNhakPXTPewIMiqsBPAja7GmDB
         O6+jaoCVl/qcyC6cdWVDFlh8L9xMaIFzmuiiShjU=
Date:   Tue, 15 Feb 2022 16:30:22 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, surenb@google.com, shakeelb@google.com,
        riel@surriel.com, mhocko@suse.com, kirill@shutemov.name,
        hannes@cmpxchg.org, gthelen@google.com, david@redhat.com,
        apopple@nvidia.com, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-munlock-mlock_pte_range-when-mlocking-or-munlocking.patch added to -mm tree
Message-Id: <20220216003023.0317CC340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/munlock: mlock_pte_range() when mlocking or munlocking
has been added to the -mm tree.  Its filename is
     mm-munlock-mlock_pte_range-when-mlocking-or-munlocking.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-munlock-mlock_pte_range-when-mlocking-or-munlocking.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-munlock-mlock_pte_range-when-mlocking-or-munlocking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/munlock: mlock_pte_range() when mlocking or munlocking

Fill in missing pieces: reimplementation of munlock_vma_pages_range(),
required to lower the mlock_counts when munlocking without munmapping; and
its complement, implementation of mlock_vma_pages_range(), required to
raise the mlock_counts on pages already there when a range is mlocked.

Combine them into just the one function mlock_vma_pages_range(), using
walk_page_range() to run mlock_pte_range().  This approach fixes the "Very
slow unlockall()" of unpopulated PROT_NONE areas, reported in
https://lore.kernel.org/linux-mm/70885d37-62b7-748b-29df-9e94f3291736@gmail.com/

Munlock clears VM_LOCKED at the start, under exclusive mmap_lock; but if a
racing truncate or holepunch (depending on i_mmap_rwsem) gets to the pte
first, it will not try to munlock the page: leaving release_pages() to
correct it when the last reference to the page is gone - that's okay, a
page is not evictable anyway while it is held by an extra reference.

Mlock sets VM_LOCKED at the start, under exclusive mmap_lock; but if a
racing remove_migration_pte() or try_to_unmap_one() (depending on
i_mmap_rwsem) gets to the pte first, it will try to mlock the page, then
mlock_pte_range() mlock it a second time.  This is harder to reproduce,
but a more serious race because it could leave the page unevictable
indefinitely though the area is munlocked afterwards.  Guard against it by
setting the (inappropriate) VM_IO flag, and modifying mlock_vma_page() to
decline such vmas.

Link: https://lkml.kernel.org/r/d39f6e4d-aa4f-731a-68ee-e77cdbf1d7bb@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    3 -
 mm/mlock.c    |  111 ++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 91 insertions(+), 23 deletions(-)

--- a/mm/internal.h~mm-munlock-mlock_pte_range-when-mlocking-or-munlocking
+++ a/mm/internal.h
@@ -412,7 +412,8 @@ void mlock_page(struct page *page);
 static inline void mlock_vma_page(struct page *page,
 			struct vm_area_struct *vma, bool compound)
 {
-	if (unlikely(vma->vm_flags & VM_LOCKED) &&
+	/* VM_IO check prevents migration from double-counting during mlock */
+	if (unlikely((vma->vm_flags & (VM_LOCKED|VM_IO)) == VM_LOCKED) &&
 	    (compound || !PageTransCompound(page)))
 		mlock_page(page);
 }
--- a/mm/mlock.c~mm-munlock-mlock_pte_range-when-mlocking-or-munlocking
+++ a/mm/mlock.c
@@ -14,6 +14,7 @@
 #include <linux/swapops.h>
 #include <linux/pagemap.h>
 #include <linux/pagevec.h>
+#include <linux/pagewalk.h>
 #include <linux/mempolicy.h>
 #include <linux/syscalls.h>
 #include <linux/sched.h>
@@ -127,25 +128,91 @@ out:
 	unlock_page_memcg(page);
 }
 
+static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
+			   unsigned long end, struct mm_walk *walk)
+
+{
+	struct vm_area_struct *vma = walk->vma;
+	spinlock_t *ptl;
+	pte_t *start_pte, *pte;
+	struct page *page;
+
+	ptl = pmd_trans_huge_lock(pmd, vma);
+	if (ptl) {
+		if (!pmd_present(*pmd))
+			goto out;
+		if (is_huge_zero_pmd(*pmd))
+			goto out;
+		page = pmd_page(*pmd);
+		if (vma->vm_flags & VM_LOCKED)
+			mlock_page(page);
+		else
+			munlock_page(page);
+		goto out;
+	}
+
+	start_pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	for (pte = start_pte; addr != end; pte++, addr += PAGE_SIZE) {
+		if (!pte_present(*pte))
+			continue;
+		page = vm_normal_page(vma, addr, *pte);
+		if (!page)
+			continue;
+		if (PageTransCompound(page))
+			continue;
+		if (vma->vm_flags & VM_LOCKED)
+			mlock_page(page);
+		else
+			munlock_page(page);
+	}
+	pte_unmap(start_pte);
+out:
+	spin_unlock(ptl);
+	cond_resched();
+	return 0;
+}
+
 /*
- * munlock_vma_pages_range() - munlock all pages in the vma range.'
- * @vma - vma containing range to be munlock()ed.
+ * mlock_vma_pages_range() - mlock any pages already in the range,
+ *                           or munlock all pages in the range.
+ * @vma - vma containing range to be mlock()ed or munlock()ed
  * @start - start address in @vma of the range
- * @end - end of range in @vma.
- *
- *  For mremap(), munmap() and exit().
+ * @end - end of range in @vma
+ * @newflags - the new set of flags for @vma.
  *
- * Called with @vma VM_LOCKED.
- *
- * Returns with VM_LOCKED cleared.  Callers must be prepared to
- * deal with this.
+ * Called for mlock(), mlock2() and mlockall(), to set @vma VM_LOCKED;
+ * called for munlock() and munlockall(), to clear VM_LOCKED from @vma.
  */
-static void munlock_vma_pages_range(struct vm_area_struct *vma,
-				    unsigned long start, unsigned long end)
+static void mlock_vma_pages_range(struct vm_area_struct *vma,
+	unsigned long start, unsigned long end, vm_flags_t newflags)
 {
-	vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
+	static const struct mm_walk_ops mlock_walk_ops = {
+		.pmd_entry = mlock_pte_range,
+	};
 
-	/* Reimplementation to follow in later commit */
+	/*
+	 * There is a slight chance that concurrent page migration,
+	 * or page reclaim finding a page of this now-VM_LOCKED vma,
+	 * will call mlock_vma_page() and raise page's mlock_count:
+	 * double counting, leaving the page unevictable indefinitely.
+	 * Communicate this danger to mlock_vma_page() with VM_IO,
+	 * which is a VM_SPECIAL flag not allowed on VM_LOCKED vmas.
+	 * mmap_lock is held in write mode here, so this weird
+	 * combination should not be visible to other mmap_lock users;
+	 * but WRITE_ONCE so rmap walkers must see VM_IO if VM_LOCKED.
+	 */
+	if (newflags & VM_LOCKED)
+		newflags |= VM_IO;
+	WRITE_ONCE(vma->vm_flags, newflags);
+
+	lru_add_drain();
+	walk_page_range(vma->vm_mm, start, end, &mlock_walk_ops, NULL);
+	lru_add_drain();
+
+	if (newflags & VM_IO) {
+		newflags &= ~VM_IO;
+		WRITE_ONCE(vma->vm_flags, newflags);
+	}
 }
 
 /*
@@ -164,10 +231,9 @@ static int mlock_fixup(struct vm_area_st
 	pgoff_t pgoff;
 	int nr_pages;
 	int ret = 0;
-	int lock = !!(newflags & VM_LOCKED);
-	vm_flags_t old_flags = vma->vm_flags;
+	vm_flags_t oldflags = vma->vm_flags;
 
-	if (newflags == vma->vm_flags || (vma->vm_flags & VM_SPECIAL) ||
+	if (newflags == oldflags || (oldflags & VM_SPECIAL) ||
 	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm) ||
 	    vma_is_dax(vma) || vma_is_secretmem(vma))
 		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
@@ -199,9 +265,9 @@ success:
 	 * Keep track of amount of locked VM.
 	 */
 	nr_pages = (end - start) >> PAGE_SHIFT;
-	if (!lock)
+	if (!(newflags & VM_LOCKED))
 		nr_pages = -nr_pages;
-	else if (old_flags & VM_LOCKED)
+	else if (oldflags & VM_LOCKED)
 		nr_pages = 0;
 	mm->locked_vm += nr_pages;
 
@@ -211,11 +277,12 @@ success:
 	 * set VM_LOCKED, populate_vma_page_range will bring it back.
 	 */
 
-	if (lock)
+	if ((newflags & VM_LOCKED) && (oldflags & VM_LOCKED)) {
+		/* No work to do, and mlocking twice would be wrong */
 		vma->vm_flags = newflags;
-	else
-		munlock_vma_pages_range(vma, start, end);
-
+	} else {
+		mlock_vma_pages_range(vma, start, end, newflags);
+	}
 out:
 	*prev = vma;
 	return ret;
_

Patches currently in -mm which might be from hughd@google.com are

mm-munlock-delete-page_mlock-and-all-its-works.patch
mm-munlock-delete-foll_mlock-and-foll_populate.patch
mm-munlock-delete-munlock_vma_pages_all-allow-oomreap.patch
mm-munlock-rmap-call-mlock_vma_page-munlock_vma_page.patch
mm-munlock-replace-clear_page_mlock-by-final-clearance.patch
mm-munlock-maintain-page-mlock_count-while-unevictable.patch
mm-munlock-mlock_pte_range-when-mlocking-or-munlocking.patch
mm-migrate-__unmap_and_move-push-good-newpage-to-lru.patch
mm-munlock-delete-smp_mb-from-__pagevec_lru_add_fn.patch
mm-munlock-mlock_page-munlock_page-batch-by-pagevec.patch
mm-munlock-page-migration-needs-mlock-pagevec-drained.patch
mm-thp-collapse_file-do-try_to_unmapttu_batch_flush.patch
mm-thp-shrink_page_list-avoid-splitting-vm_locked-thp.patch

