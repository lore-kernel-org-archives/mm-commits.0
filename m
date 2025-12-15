Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F94B328241;
	Mon, 15 Dec 2025 21:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765835546; cv=none; b=V+NZE0gAJ2eL0gC4IqrLOV5lfzxbViHvMw3Zp3ewc4ZAr3wX5pI7mFg5lDkHU6Bu/ZoCpI6v7qqwjK2jwbrHj/cTL0JV+i5yoZByn2y53XUWf3azsKUJHcdwivxoHxJxsrv/LiSnJwTFRPwk2sfsaxtzRI/6E1RoyUiv0wXtiA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765835546; c=relaxed/simple;
	bh=An1YpFCCNUZXg4bqnLYwwBHcS5xY+TCIgqVVavDgDP4=;
	h=Date:To:From:Subject:Message-Id; b=WyWTG11c56cC+5UfkI8IANQL7YXaHQWvnLMD9LyrrSWEF13Hkf3127aRM3Ech2/q43AKmDb4zOxpsjM6Ka7awTUM8SNP/fpmNSivt0gPOJqh90kgOJkjC2jDMYZiPg9yOgeoRJb4YMQ0MbR3cnioynnm1TfcGmnCWsanT8SMwdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ofqlG91A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ofqlG91A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6FEC4CEF5;
	Mon, 15 Dec 2025 21:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765835545;
	bh=An1YpFCCNUZXg4bqnLYwwBHcS5xY+TCIgqVVavDgDP4=;
	h=Date:To:From:Subject:From;
	b=ofqlG91AQFbwbtcyiNnF8GGo4lXn32Ikg2mldWJf6eV5/OOoU6rrCXDybHCZkQjxM
	 7UWUYKRKhjxewr7ojQHdXrSNHCnDfCbJ/NuIXos1xDAv3yVP6jShngiYGqgfRFvCGL
	 ThFuk4PU/v9SAzdXkCdUvj8OFknPtJZJxUlYIPWI=
Date: Mon, 15 Dec 2025 13:52:25 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,suschako@amazon.de,stable@vger.kernel.org,riel@surriel.com,prakash.sangappa@oracle.com,peterz@infradead.org,osalvador@suse.de,npiggin@gmail.com,nadav.amit@gmail.com,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,loberman@redhat.com,liushixin2@huawei.com,liam.howlett@oracle.com,lance.yang@linux.dev,jannh@google.com,harry.yoo@oracle.com,arnd@arndb.de,aneesh.kumar@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather.patch added to mm-new branch
Message-Id: <20251215215225.8C6FEC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables using mmu_gather
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables using mmu_gather
Date: Fri, 12 Dec 2025 08:10:19 +0100

As reported, ever since commit 1013af4f585f ("mm/hugetlb: fix
huge_pmd_unshare() vs GUP-fast race") we can end up in some situations
where we perform so many IPI broadcasts when unsharing hugetlb PMD page
tables that it severely regresses some workloads.

In particular, when we fork()+exit(), or when we munmap() a large area
backed by many shared PMD tables, we perform one IPI broadcast per
unshared PMD table.

There are two optimizations to be had:

(1) When we process (unshare) multiple such PMD tables, such as during
    exit(), it is sufficient to send a single IPI broadcast (as long as
    we respect locking rules) instead of one per PMD table.

    Locking prevents that any of these PMD tables could get reuse before
    we drop the lock.

(2) When we are not the last sharer (> 2 users including us), there is
    no need to send the IPI broadcast. The shared PMD tables cannot
    become exclusive (fully unshared) before an IPI will be broadcasted
    by the last sharer.

    Concurrent GUP-fast could walk into a PMD table just before we
    unshared it. It could then succeed in grabbing a page from the
    shared page table even after munmap() etc succeeded (and supressed
    an IPI). But there is not difference compared to GUP-fast just
    sleeping for a while after grabbing the page and re-enabling IRQs.

    Most importantly, GUP-fast will never walk into page tables that are
    no-longer shared, because the last sharer will issue an IPI
    broadcast.

    (if ever required, checking whether the PUD changed in GUP-fast
     after grabbing the page like we do in the PTE case could handle
     this)

So let's rework PMD sharing TLB flushing + IPI sync to use the mmu_gather
infrastructure so we can implement these optimizations and demystify the
code at least a bit.  Extend the mmu_gather infrastructure to be able to
deal with our special hugetlb PMD table sharing implementation.

We'll consolidate the handling for (full) unsharing of PMD tables in
tlb_unshare_pmd_ptdesc() and tlb_flush_unshared_tables(), and track in
"struct mmu_gather" whether we had (full) unsharing of PMD tables.

Because locking is very special (concurrent unsharing+reuse must be
prevented), we disallow deferring flushing to tlb_finish_mmu() and instead
require an explicit earlier call to tlb_flush_unshared_tables().

From hugetlb code, we call huge_pmd_unshare_flush() where we make sure
that the expected lock protecting us from concurrent unsharing+reuse is
still held.

Check with a VM_WARN_ON_ONCE() in tlb_finish_mmu() that
tlb_flush_unshared_tables() was properly called earlier.

Document it all properly.

Notes about tlb_remove_table_sync_one() interaction with unsharing:

There are two fairly tricky things:

(1) tlb_remove_table_sync_one() is a NOP on architectures without
    CONFIG_MMU_GATHER_RCU_TABLE_FREE.

    Here, the assumption is that the previous TLB flush would send an
    IPI to all relevant CPUs. Careful: some architectures like x86 only
    send IPIs to all relevant CPUs when tlb->freed_tables is set.

    The relevant architectures should be selecting
    MMU_GATHER_RCU_TABLE_FREE, but x86 might not do that in stable
    kernels and it might have been problematic before this patch.

    Also, the arch flushing behavior (independent of IPIs) is different
    when tlb->freed_tables is set. Do we have to enlighten them to also
    take care of tlb->unshared_tables? So far we didn't care, so
    hopefully we are fine. Of course, we could be setting
    tlb->freed_tables as well, but that might then unnecessarily flush
    too much, because the semantics of tlb->freed_tables are a bit
    fuzzy.

    This patch changes nothing in this regard.

(2) tlb_remove_table_sync_one() is not a NOP on architectures with
    CONFIG_MMU_GATHER_RCU_TABLE_FREE that actually don't need a sync.

    Take x86 as an example: in the common case (!pv, !X86_FEATURE_INVLPGB)
    we still issue IPIs during TLB flushes and don't actually need the
    second tlb_remove_table_sync_one().

    This optimized can be implemented on top of this, by checking e.g., in
    tlb_remove_table_sync_one() whether we really need IPIs. But as
    described in (1), it really must honor tlb->freed_tables then to
    send IPIs to all relevant CPUs.

Further note that the ptdesc_pmd_pts_dec() in huge_pmd_share() is not a
concern, as we are holding the i_mmap_lock the whole time, preventing
concurrent unsharing.  That ptdesc_pmd_pts_dec() usage will be removed
separately as a cleanup later.

There are plenty more cleanups to be had, but they have to wait until this
is fixed.

Link: https://lkml.kernel.org/r/20251212071019.471146-5-david@kernel.org
Fixes: 1013af4f585f ("mm/hugetlb: fix huge_pmd_unshare() vs GUP-fast race")
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reported-by: Uschakow, Stanislav" <suschako@amazon.de>
Closes: https://lore.kernel.org/all/4d3878531c76479d9f8ca9789dc6485d@amazon.de/
Tested-by: Laurence Oberman <loberman@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Prakash Sangappa <prakash.sangappa@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/tlb.h |   74 +++++++++++++++++++++-
 include/linux/hugetlb.h   |   19 +++--
 mm/hugetlb.c              |  121 ++++++++++++++++++++----------------
 mm/mmu_gather.c           |    7 ++
 mm/mprotect.c             |    2 
 mm/rmap.c                 |   25 +++++--
 6 files changed, 179 insertions(+), 69 deletions(-)

--- a/include/asm-generic/tlb.h~mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather
+++ a/include/asm-generic/tlb.h
@@ -364,6 +364,20 @@ struct mmu_gather {
 	unsigned int		vma_huge : 1;
 	unsigned int		vma_pfn  : 1;
 
+	/*
+	 * Did we unshare (unmap) any shared page tables? For now only
+	 * used for hugetlb PMD table sharing.
+	 */
+	unsigned int		unshared_tables : 1;
+
+	/*
+	 * Did we unshare any page tables such that they are now exclusive
+	 * and could get reused+modified by the new owner? When setting this
+	 * flag, "unshared_tables" will be set as well. For now only used
+	 * for hugetlb PMD table sharing.
+	 */
+	unsigned int		fully_unshared_tables : 1;
+
 	unsigned int		batch_count;
 
 #ifndef CONFIG_MMU_GATHER_NO_GATHER
@@ -400,6 +414,7 @@ static inline void __tlb_reset_range(str
 	tlb->cleared_pmds = 0;
 	tlb->cleared_puds = 0;
 	tlb->cleared_p4ds = 0;
+	tlb->unshared_tables = 0;
 	/*
 	 * Do not reset mmu_gather::vma_* fields here, we do not
 	 * call into tlb_start_vma() again to set them if there is an
@@ -484,7 +499,7 @@ static inline void tlb_flush_mmu_tlbonly
 	 * these bits.
 	 */
 	if (!(tlb->freed_tables || tlb->cleared_ptes || tlb->cleared_pmds ||
-	      tlb->cleared_puds || tlb->cleared_p4ds))
+	      tlb->cleared_puds || tlb->cleared_p4ds || tlb->unshared_tables))
 		return;
 
 	tlb_flush(tlb);
@@ -773,6 +788,63 @@ static inline bool huge_pmd_needs_flush(
 }
 #endif
 
+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
+static inline void tlb_unshare_pmd_ptdesc(struct mmu_gather *tlb, struct ptdesc *pt,
+					  unsigned long addr)
+{
+	/*
+	 * The caller must make sure that concurrent unsharing + exclusive
+	 * reuse is impossible until tlb_flush_unshared_tables() was called.
+	 */
+	VM_WARN_ON_ONCE(!ptdesc_pmd_is_shared(pt));
+	ptdesc_pmd_pts_dec(pt);
+
+	/* Clearing a PUD pointing at a PMD table with PMD leaves. */
+	tlb_flush_pmd_range(tlb, addr & PUD_MASK, PUD_SIZE);
+
+	/*
+	 * If the page table is now exclusively owned, we fully unshared
+	 * a page table.
+	 */
+	if (!ptdesc_pmd_is_shared(pt))
+		tlb->fully_unshared_tables = true;
+	tlb->unshared_tables = true;
+}
+
+static inline void tlb_flush_unshared_tables(struct mmu_gather *tlb)
+{
+	/*
+	 * As soon as the caller drops locks to allow for reuse of
+	 * previously-shared tables, these tables could get modified and
+	 * even reused outside of hugetlb context, so we have to make sure that
+	 * any page table walkers (incl. TLB, GUP-fast) are aware of that
+	 * change.
+	 *
+	 * Even if we are not fully unsharing a PMD table, we must
+	 * flush the TLB for the unsharer now.
+	 */
+	if (tlb->unshared_tables)
+		tlb_flush_mmu_tlbonly(tlb);
+
+	/*
+	 * Similarly, we must make sure that concurrent GUP-fast will not
+	 * walk previously-shared page tables that are getting modified+reused
+	 * elsewhere. So broadcast an IPI to wait for any concurrent GUP-fast.
+	 *
+	 * We only perform this when we are the last sharer of a page table,
+	 * as the IPI will reach all CPUs: any GUP-fast.
+	 *
+	 * Note that on configs where tlb_remove_table_sync_one() is a NOP,
+	 * the expectation is that the tlb_flush_mmu_tlbonly() would have issued
+	 * required IPIs already for us.
+	 */
+	if (tlb->fully_unshared_tables) {
+		tlb_remove_table_sync_one();
+		tlb->fully_unshared_tables = false;
+	}
+}
+#endif /* CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING */
+
 #endif /* CONFIG_MMU */
 
 #endif /* _ASM_GENERIC__TLB_H */
--- a/include/linux/hugetlb.h~mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather
+++ a/include/linux/hugetlb.h
@@ -240,8 +240,9 @@ pte_t *huge_pte_alloc(struct mm_struct *
 pte_t *huge_pte_offset(struct mm_struct *mm,
 		       unsigned long addr, unsigned long sz);
 unsigned long hugetlb_mask_last_page(struct hstate *h);
-int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
-				unsigned long addr, pte_t *ptep);
+int huge_pmd_unshare(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep);
+void huge_pmd_unshare_flush(struct mmu_gather *tlb, struct vm_area_struct *vma);
 void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
 				unsigned long *start, unsigned long *end);
 
@@ -271,7 +272,7 @@ void hugetlb_vma_unlock_write(struct vm_
 int hugetlb_vma_trylock_write(struct vm_area_struct *vma);
 void hugetlb_vma_assert_locked(struct vm_area_struct *vma);
 void hugetlb_vma_lock_release(struct kref *kref);
-long hugetlb_change_protection(struct vm_area_struct *vma,
+long hugetlb_change_protection(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		unsigned long address, unsigned long end, pgprot_t newprot,
 		unsigned long cp_flags);
 void hugetlb_unshare_all_pmds(struct vm_area_struct *vma);
@@ -300,13 +301,17 @@ static inline struct address_space *huge
 	return NULL;
 }
 
-static inline int huge_pmd_unshare(struct mm_struct *mm,
-					struct vm_area_struct *vma,
-					unsigned long addr, pte_t *ptep)
+static inline int huge_pmd_unshare(struct mmu_gather *tlb,
+		struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
 {
 	return 0;
 }
 
+static inline void huge_pmd_unshare_flush(struct mmu_gather *tlb,
+		struct vm_area_struct *vma)
+{
+}
+
 static inline void adjust_range_if_pmd_sharing_possible(
 				struct vm_area_struct *vma,
 				unsigned long *start, unsigned long *end)
@@ -432,7 +437,7 @@ static inline void move_hugetlb_state(st
 {
 }
 
-static inline long hugetlb_change_protection(
+static inline long hugetlb_change_protection(struct mmu_gather *tlb,
 			struct vm_area_struct *vma, unsigned long address,
 			unsigned long end, pgprot_t newprot,
 			unsigned long cp_flags)
--- a/mm/hugetlb.c~mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather
+++ a/mm/hugetlb.c
@@ -5096,8 +5096,9 @@ int move_hugetlb_page_tables(struct vm_a
 	unsigned long last_addr_mask;
 	pte_t *src_pte, *dst_pte;
 	struct mmu_notifier_range range;
-	bool shared_pmd = false;
+	struct mmu_gather tlb;
 
+	tlb_gather_mmu(&tlb, vma->vm_mm);
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, old_addr,
 				old_end);
 	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
@@ -5122,12 +5123,12 @@ int move_hugetlb_page_tables(struct vm_a
 		if (huge_pte_none(huge_ptep_get(mm, old_addr, src_pte)))
 			continue;
 
-		if (huge_pmd_unshare(mm, vma, old_addr, src_pte)) {
-			shared_pmd = true;
+		if (huge_pmd_unshare(&tlb, vma, old_addr, src_pte)) {
 			old_addr |= last_addr_mask;
 			new_addr |= last_addr_mask;
 			continue;
 		}
+		tlb_remove_huge_tlb_entry(h, &tlb, src_pte, old_addr);
 
 		dst_pte = huge_pte_alloc(mm, new_vma, new_addr, sz);
 		if (!dst_pte)
@@ -5136,13 +5137,13 @@ int move_hugetlb_page_tables(struct vm_a
 		move_huge_pte(vma, old_addr, new_addr, src_pte, dst_pte, sz);
 	}
 
-	if (shared_pmd)
-		flush_hugetlb_tlb_range(vma, range.start, range.end);
-	else
-		flush_hugetlb_tlb_range(vma, old_end - len, old_end);
+	tlb_flush_mmu_tlbonly(&tlb);
+	huge_pmd_unshare_flush(&tlb, vma);
+
 	mmu_notifier_invalidate_range_end(&range);
 	i_mmap_unlock_write(mapping);
 	hugetlb_vma_unlock_write(vma);
+	tlb_finish_mmu(&tlb);
 
 	return len + old_addr - old_end;
 }
@@ -5161,7 +5162,6 @@ void __unmap_hugepage_range(struct mmu_g
 	unsigned long sz = huge_page_size(h);
 	bool adjust_reservation;
 	unsigned long last_addr_mask;
-	bool force_flush = false;
 
 	WARN_ON(!is_vm_hugetlb_page(vma));
 	BUG_ON(start & ~huge_page_mask(h));
@@ -5184,10 +5184,8 @@ void __unmap_hugepage_range(struct mmu_g
 		}
 
 		ptl = huge_pte_lock(h, mm, ptep);
-		if (huge_pmd_unshare(mm, vma, address, ptep)) {
+		if (huge_pmd_unshare(tlb, vma, address, ptep)) {
 			spin_unlock(ptl);
-			tlb_flush_pmd_range(tlb, address & PUD_MASK, PUD_SIZE);
-			force_flush = true;
 			address |= last_addr_mask;
 			continue;
 		}
@@ -5303,14 +5301,7 @@ void __unmap_hugepage_range(struct mmu_g
 	}
 	tlb_end_vma(tlb, vma);
 
-	/*
-	 * There is nothing protecting a previously-shared page table that we
-	 * unshared through huge_pmd_unshare() from getting freed after we
-	 * release i_mmap_rwsem, so flush the TLB now. If huge_pmd_unshare()
-	 * succeeded, flush the range corresponding to the pud.
-	 */
-	if (force_flush)
-		tlb_flush_mmu_tlbonly(tlb);
+	huge_pmd_unshare_flush(tlb, vma);
 }
 
 void __hugetlb_zap_begin(struct vm_area_struct *vma,
@@ -6399,7 +6390,7 @@ out_release_nounlock:
 }
 #endif /* CONFIG_USERFAULTFD */
 
-long hugetlb_change_protection(struct vm_area_struct *vma,
+long hugetlb_change_protection(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		unsigned long address, unsigned long end,
 		pgprot_t newprot, unsigned long cp_flags)
 {
@@ -6409,7 +6400,6 @@ long hugetlb_change_protection(struct vm
 	pte_t pte;
 	struct hstate *h = hstate_vma(vma);
 	long pages = 0, psize = huge_page_size(h);
-	bool shared_pmd = false;
 	struct mmu_notifier_range range;
 	unsigned long last_addr_mask;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
@@ -6452,7 +6442,7 @@ long hugetlb_change_protection(struct vm
 			}
 		}
 		ptl = huge_pte_lock(h, mm, ptep);
-		if (huge_pmd_unshare(mm, vma, address, ptep)) {
+		if (huge_pmd_unshare(tlb, vma, address, ptep)) {
 			/*
 			 * When uffd-wp is enabled on the vma, unshare
 			 * shouldn't happen at all.  Warn about it if it
@@ -6461,7 +6451,6 @@ long hugetlb_change_protection(struct vm
 			WARN_ON_ONCE(uffd_wp || uffd_wp_resolve);
 			pages++;
 			spin_unlock(ptl);
-			shared_pmd = true;
 			address |= last_addr_mask;
 			continue;
 		}
@@ -6522,22 +6511,16 @@ long hugetlb_change_protection(struct vm
 				pte = huge_pte_clear_uffd_wp(pte);
 			huge_ptep_modify_prot_commit(vma, address, ptep, old_pte, pte);
 			pages++;
+			tlb_remove_huge_tlb_entry(h, tlb, ptep, address);
 		}
 
 next:
 		spin_unlock(ptl);
 		cond_resched();
 	}
-	/*
-	 * There is nothing protecting a previously-shared page table that we
-	 * unshared through huge_pmd_unshare() from getting freed after we
-	 * release i_mmap_rwsem, so flush the TLB now. If huge_pmd_unshare()
-	 * succeeded, flush the range corresponding to the pud.
-	 */
-	if (shared_pmd)
-		flush_hugetlb_tlb_range(vma, range.start, range.end);
-	else
-		flush_hugetlb_tlb_range(vma, start, end);
+
+	tlb_flush_mmu_tlbonly(tlb);
+	huge_pmd_unshare_flush(tlb, vma);
 	/*
 	 * No need to call mmu_notifier_arch_invalidate_secondary_tlbs() we are
 	 * downgrading page table protection not changing it to point to a new
@@ -6904,18 +6887,27 @@ out:
 	return pte;
 }
 
-/*
- * unmap huge page backed by shared pte.
+/**
+ * huge_pmd_unshare - Unmap a pmd table if it is shared by multiple users
+ * @tlb: the current mmu_gather.
+ * @vma: the vma covering the pmd table.
+ * @addr: the address we are trying to unshare.
+ * @ptep: pointer into the (pmd) page table.
+ *
+ * Called with the page table lock held, the i_mmap_rwsem held in write mode
+ * and the hugetlb vma lock held in write mode.
  *
- * Called with page table lock held.
+ * Note: The caller must call huge_pmd_unshare_flush() before dropping the
+ * i_mmap_rwsem.
  *
- * returns: 1 successfully unmapped a shared pte page
- *	    0 the underlying pte page is not shared, or it is the last user
+ * Returns: 1 if it was a shared PMD table and it got unmapped, or 0 if it
+ *	    was not a shared PMD table.
  */
-int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
-					unsigned long addr, pte_t *ptep)
+int huge_pmd_unshare(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep)
 {
 	unsigned long sz = huge_page_size(hstate_vma(vma));
+	struct mm_struct *mm = vma->vm_mm;
 	pgd_t *pgd = pgd_offset(mm, addr);
 	p4d_t *p4d = p4d_offset(pgd, addr);
 	pud_t *pud = pud_offset(p4d, addr);
@@ -6927,18 +6919,36 @@ int huge_pmd_unshare(struct mm_struct *m
 	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
 	hugetlb_vma_assert_locked(vma);
 	pud_clear(pud);
-	/*
-	 * Once our caller drops the rmap lock, some other process might be
-	 * using this page table as a normal, non-hugetlb page table.
-	 * Wait for pending gup_fast() in other threads to finish before letting
-	 * that happen.
-	 */
-	tlb_remove_table_sync_one();
-	ptdesc_pmd_pts_dec(virt_to_ptdesc(ptep));
+
+	tlb_unshare_pmd_ptdesc(tlb, virt_to_ptdesc(ptep), addr);
+
 	mm_dec_nr_pmds(mm);
 	return 1;
 }
 
+/*
+ * huge_pmd_unshare_flush - Complete a sequence of huge_pmd_unshare() calls
+ * @tlb: the current mmu_gather.
+ * @vma: the vma covering the pmd table.
+ *
+ * Perform necessary TLB flushes or IPI broadcasts to synchronize PMD table
+ * unsharing with concurrent page table walkers.
+ *
+ * This function must be called after a sequence of huge_pmd_unshare()
+ * calls while still holding the i_mmap_rwsem.
+ */
+void huge_pmd_unshare_flush(struct mmu_gather *tlb, struct vm_area_struct *vma)
+{
+	/*
+	 * We must synchronize page table unsharing such that nobody will
+	 * try reusing a previously-shared page table while it might still
+	 * be in use by previous sharers (TLB, GUP_fast).
+	 */
+	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
+
+	tlb_flush_unshared_tables(tlb);
+}
+
 #else /* !CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING */
 
 pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
@@ -6947,12 +6957,16 @@ pte_t *huge_pmd_share(struct mm_struct *
 	return NULL;
 }
 
-int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
-				unsigned long addr, pte_t *ptep)
+int huge_pmd_unshare(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep)
 {
 	return 0;
 }
 
+void huge_pmd_unshare_flush(struct mmu_gather *tlb, struct vm_area_struct *vma)
+{
+}
+
 void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
 				unsigned long *start, unsigned long *end)
 {
@@ -7219,6 +7233,7 @@ static void hugetlb_unshare_pmds(struct
 	unsigned long sz = huge_page_size(h);
 	struct mm_struct *mm = vma->vm_mm;
 	struct mmu_notifier_range range;
+	struct mmu_gather tlb;
 	unsigned long address;
 	spinlock_t *ptl;
 	pte_t *ptep;
@@ -7229,6 +7244,7 @@ static void hugetlb_unshare_pmds(struct
 	if (start >= end)
 		return;
 
+	tlb_gather_mmu(&tlb, mm);
 	flush_cache_range(vma, start, end);
 	/*
 	 * No need to call adjust_range_if_pmd_sharing_possible(), because
@@ -7248,10 +7264,10 @@ static void hugetlb_unshare_pmds(struct
 		if (!ptep)
 			continue;
 		ptl = huge_pte_lock(h, mm, ptep);
-		huge_pmd_unshare(mm, vma, address, ptep);
+		huge_pmd_unshare(&tlb, vma, address, ptep);
 		spin_unlock(ptl);
 	}
-	flush_hugetlb_tlb_range(vma, start, end);
+	huge_pmd_unshare_flush(&tlb, vma);
 	if (take_locks) {
 		i_mmap_unlock_write(vma->vm_file->f_mapping);
 		hugetlb_vma_unlock_write(vma);
@@ -7261,6 +7277,7 @@ static void hugetlb_unshare_pmds(struct
 	 * Documentation/mm/mmu_notifier.rst.
 	 */
 	mmu_notifier_invalidate_range_end(&range);
+	tlb_finish_mmu(&tlb);
 }
 
 /*
--- a/mm/mmu_gather.c~mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather
+++ a/mm/mmu_gather.c
@@ -426,6 +426,7 @@ static void __tlb_gather_mmu(struct mmu_
 #endif
 	tlb->vma_pfn = 0;
 
+	tlb->fully_unshared_tables = 0;
 	__tlb_reset_range(tlb);
 	inc_tlb_flush_pending(tlb->mm);
 }
@@ -469,6 +470,12 @@ void tlb_gather_mmu_fullmm(struct mmu_ga
 void tlb_finish_mmu(struct mmu_gather *tlb)
 {
 	/*
+	 * We expect an earlier huge_pmd_unshare_flush() call to sort this out,
+	 * due to complicated locking requirements with page table unsharing.
+	 */
+	VM_WARN_ON_ONCE(tlb->fully_unshared_tables);
+
+	/*
 	 * If there are parallel threads are doing PTE changes on same range
 	 * under non-exclusive lock (e.g., mmap_lock read-side) but defer TLB
 	 * flush by batching, one thread may end up seeing inconsistent PTEs
--- a/mm/mprotect.c~mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather
+++ a/mm/mprotect.c
@@ -652,7 +652,7 @@ long change_protection(struct mmu_gather
 #endif
 
 	if (is_vm_hugetlb_page(vma))
-		pages = hugetlb_change_protection(vma, start, end, newprot,
+		pages = hugetlb_change_protection(tlb, vma, start, end, newprot,
 						  cp_flags);
 	else
 		pages = change_protection_range(tlb, vma, start, end, newprot,
--- a/mm/rmap.c~mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather
+++ a/mm/rmap.c
@@ -76,7 +76,7 @@
 #include <linux/mm_inline.h>
 #include <linux/oom.h>
 
-#include <asm/tlbflush.h>
+#include <asm/tlb.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/migrate.h>
@@ -2008,13 +2008,17 @@ static bool try_to_unmap_one(struct foli
 			 * if unsuccessful.
 			 */
 			if (!anon) {
+				struct mmu_gather tlb;
+
 				VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
 				if (!hugetlb_vma_trylock_write(vma))
 					goto walk_abort;
-				if (huge_pmd_unshare(mm, vma, address, pvmw.pte)) {
+
+				tlb_gather_mmu(&tlb, mm);
+				if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
 					hugetlb_vma_unlock_write(vma);
-					flush_tlb_range(vma,
-						range.start, range.end);
+					huge_pmd_unshare_flush(&tlb, vma);
+					tlb_finish_mmu(&tlb);
 					/*
 					 * The PMD table was unmapped,
 					 * consequently unmapping the folio.
@@ -2022,6 +2026,7 @@ static bool try_to_unmap_one(struct foli
 					goto walk_done;
 				}
 				hugetlb_vma_unlock_write(vma);
+				tlb_finish_mmu(&tlb);
 			}
 			pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
 			if (pte_dirty(pteval))
@@ -2398,17 +2403,20 @@ static bool try_to_migrate_one(struct fo
 			 * fail if unsuccessful.
 			 */
 			if (!anon) {
+				struct mmu_gather tlb;
+
 				VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
 				if (!hugetlb_vma_trylock_write(vma)) {
 					page_vma_mapped_walk_done(&pvmw);
 					ret = false;
 					break;
 				}
-				if (huge_pmd_unshare(mm, vma, address, pvmw.pte)) {
-					hugetlb_vma_unlock_write(vma);
-					flush_tlb_range(vma,
-						range.start, range.end);
 
+				tlb_gather_mmu(&tlb, mm);
+				if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
+					hugetlb_vma_unlock_write(vma);
+					huge_pmd_unshare_flush(&tlb, vma);
+					tlb_finish_mmu(&tlb);
 					/*
 					 * The PMD table was unmapped,
 					 * consequently unmapping the folio.
@@ -2417,6 +2425,7 @@ static bool try_to_migrate_one(struct fo
 					break;
 				}
 				hugetlb_vma_unlock_write(vma);
+				tlb_finish_mmu(&tlb);
 			}
 			/* Nuke the hugetlb page table entry */
 			pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
_

Patches currently in -mm which might be from david@kernel.org are

mm-hugetlb-fix-hugetlb_pmd_shared.patch
mm-hugetlb-fix-two-comments-related-to-huge_pmd_unshare.patch
mm-rmap-fix-two-comments-related-to-huge_pmd_unshare.patch
mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather.patch

