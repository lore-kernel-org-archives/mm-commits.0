Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794768639;
	b=RTXztSPifrNCplgkJminn+EO6WcmfPK7UAuBoHy/RGzIUVUk73jNZSctnTOG5P91eEe3
	 tL6auznOMQ6IVwduWsLm1AnMlmIPJM+U9ZqTqYgnuXjqisvuffFTnx4VDyUoNjpQipp0G
	 ZLwGbW4qCENEn4gbXaHriYwlXUh733NQjOjOZjzwJuTdyNE8d4TZmXoReP3IEHbcjiiC7
	 LfGjxph4UpWMo9lv+6tAGhIbMIMw6yOtysSe3sTSChS6poDjxp5tZ0fXPK9zGpwaBQv4P
	 TKFKa+Ly13IMsXmVK19/EpH5xpdPTGaKA7Mjv2ktAIY7zt7ByE6IW3HjgnonLo8v/RA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794768639;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=3bwM+EdOYWIs+IUPw2hXTSpUq2MbF+ykHKRoOX+kgxk=;
	b=S08z0/yvxVdNVcd6GU05IF276WlB5kEpKdR6mUl5vMU3WIAdY3o3YlX0L1hOxdJVvWMS
	 kcCoVBj+5WHRBfWdD4CKpE3BY8p07G2wITeaiZ4Y4YMNYidCfMPDfW4gds5La8zygbdIl
	 UwhsMVPqxW6mV7CsyxAkMmRTPezU+Km6mPpp2FRRMstjkwlxYKy4Q8qI8OYL7l8F9Z+kN
	 8froYCPTYNLkh5Ig7eqSVTV19I7+KhwfnJcs41YRyWN0E3zQTZ5laXu5r+P2YVtaMXNg9
	 PMMv92XVWxUTiRlETISySjX8G3Ifo+QkkATktNxO27amyhYHKZTe14prGcFkvanOanw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hdUrfFde;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0E2606A31F;
	Sun, 15 Nov 2026 18:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hdUrfFde
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD691F000C4;
	Sun, 15 Nov 2026 18:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794768638;
	bh=3bwM+EdOYWIs+IUPw2hXTSpUq2MbF+ykHKRoOX+kgxk=;
	h=Date:To:From:Subject;
	b=hdUrfFdelIo2K4Utn5TrLFFF3fUTef8tGCkXz7Sspw/Mr9Rj78rGMG1bxB0wsvIiB
	 XNycDTcVY7a2dV6lfCt/CSY7dTTPNqxHtMnK8SSj96NQ+nhuvdDcpcBoMZqXL+G38q
	 wMf6sTZt+x7EyrpcxLXpzCO8yFRfG71i5HwHKJE8=
Date: Sun, 15 Nov 2026 10:50:38 -0800
To: mm-commits@vger.kernel.org,zwisler@kernel.org,ziy@nvidia.com,
	will@kernel.org,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,
	stable@vger.kernel.org,ryan.roberts@arm.com,rppt@kernel.org,
	peterz@infradead.org,npiggin@gmail.com,nico.pache@linux.dev,mhocko@suse.com,
	mason@kernel.org,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,
	kas@kernel.org,jack@suse.cz,dev.jain@arm.com,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,arnd@arndb.de,aneesh.kumar@kernel.org,david@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-flush-dirty-file-pmds-before-removing-rmap.patch added to mm-hotfixes-unstable branch
Message-Id: <20261115185038.7CD691F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/huge_memory: flush dirty file PMDs before removing rmap
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-flush-dirty-file-pmds-before-removing-rmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-flush-dirty-file-pmds-before-removing-rmap.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/huge_memory: flush dirty file PMDs before removing rmap
Date: Fri, 13 Nov 2026 18:15:26 +0100

Unmapping a file PMD can lose concurrent stores when it races with
writeback.  zap_huge_pmd() removes rmap and drops the PMD lock before the
gather flushes the TLB.  Writeback can then clean the folio while another
CPU can still write through a stale writable TLB entry.  Those stores do
not fault and dirty the folio again.  Filesystem DAX has the same problem
with its dirty tags.

Commit 5df397dec7c4 ("mm: delay page_remove_rmap() until after the TLB has
been flushed") fixed the same race for PTEs by adding delayed rmap removal
to the mmu_gather infrastructure.  The PMD path still removes rmap before
flushing.

Flush the TLB under the PMD lock before removing rmap for dirty file PMDs.
Skip the early flush at address-space teardown, when no users remain, and
for mappings without writeback, including shmem and device DAX.

Use tlb_can_delay_rmap() to share the PTE path's architecture checks.  On
s390, clearing the entry already handles TLB synchronization, and
__tlb_remove_page_size() immediately drops the mapping reference, so rmap
must be removed first.  UP cannot have concurrent stores from another CPU
while holding the page table lock.  Make the predicate side-effect-free
and set the gather's delayed_rmap flag when an entry is actually queued
for delayed rmap removal.

Queue the folio before the early flush, while the gather still has a valid
range.  Keep batching references and drain a full batch only after
dropping the PMD lock.  The early flush resets the gather's TLB state, so
draining the batch does not flush that range again.

Although writing to files through mmap is generally discouraged, unmapping
such mappings may become slower: each dirty file PMD now requires a TLB
flush under the PMD lock.  Future work should properly extend the
delayed-rmap machinery to PMDs and hold the PMD spinlock across multiple
entries, so their TLB invalidations and rmap removals can be batched.

Link: https://lore.kernel.org/20261113-dirty_file_pmd-v1-1-8c11f2a2e65f@kernel.org
Fixes: 4b4bb46d00b3 ("dax: clear dirty entry tags on cache flush")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Kiryl Shutsemau <kas@kernel.org>
Closes: https://lore.kernel.org/linux-mm/aoWw_iKEDLjKL2jr@thinkstation/
Reported-by: Chris Mason <mason@kernel.org>
Suggested-by: Lance Yang <lance.yang@linux.dev>
Suggested-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Ross Zwisler <zwisler@kernel.org>
Cc: <stable@vger.kernel.org>

 include/asm-generic/tlb.h |   10 ++-------
 mm/huge_memory.c          |   38 ++++++++++++++++++++++++++++--------
 mm/memory.c               |    2 -
 mm/mmu_gather.c           |    2 +
 4 files changed, 36 insertions(+), 16 deletions(-)

--- a/include/asm-generic/tlb.h~mm-huge_memory-flush-dirty-file-pmds-before-removing-rmap
+++ a/include/asm-generic/tlb.h
@@ -250,11 +250,7 @@ bool __tlb_remove_folio_pages(struct mmu
 		unsigned int nr_pages, bool delay_rmap);
 
 #ifdef CONFIG_SMP
-/*
- * This both sets 'delayed_rmap', and returns true. It would be an inline
- * function, except we define it before the 'struct mmu_gather'.
- */
-#define tlb_delay_rmap(tlb) (((tlb)->delayed_rmap = 1), true)
+#define tlb_can_delay_rmap() (true)
 extern void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma);
 #endif
 
@@ -267,8 +263,8 @@ extern void tlb_flush_rmaps(struct mmu_g
  * remote TLBs to flush and is not preemptible due to this
  * all happening under the page table lock.
  */
-#ifndef tlb_delay_rmap
-#define tlb_delay_rmap(tlb) (false)
+#ifndef tlb_can_delay_rmap
+#define tlb_can_delay_rmap() (false)
 static inline void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma) { }
 #endif
 
--- a/mm/huge_memory.c~mm-huge_memory-flush-dirty-file-pmds-before-removing-rmap
+++ a/mm/huge_memory.c
@@ -2490,10 +2490,12 @@ static inline void zap_deposited_table(s
 	mm_dec_nr_ptes(mm);
 }
 
-static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
-		pmd_t pmdval, struct folio *folio, bool is_present)
+static void zap_huge_pmd_folio(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		pmd_t pmdval, struct folio *folio, bool is_present, bool *force_flush)
 {
 	const bool is_device_private = pmd_is_device_private_entry(pmdval);
+	struct mm_struct *mm = tlb->mm;
+	bool delay_rmap = false;
 
 	if (folio_test_anon(folio)) {
 		add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
@@ -2501,23 +2503,41 @@ static void zap_huge_pmd_folio(struct mm
 		add_mm_counter(mm, mm_counter_file(folio),
 			       -HPAGE_PMD_NR);
 
-		if (is_present && pmd_dirty(pmdval))
+		if (is_present && pmd_dirty(pmdval)) {
 			folio_mark_dirty(folio);
+			/*
+			 * Remove rmap after the TLB flush if other CPUs could
+			 * still write to a mapping that supports writeback.
+			 */
+			if (!tlb->fullmm && vma->vm_file &&
+			    mapping_can_writeback(vma->vm_file->f_mapping))
+				delay_rmap = tlb_can_delay_rmap();
+		}
 		if (is_present && pmd_young(pmdval) &&
 		    likely(vma_has_recency(vma)))
 			folio_mark_accessed(folio);
 	}
 
+	if (!is_present && !is_device_private)
+		return;
+
 	/*
 	 * Present and device private folios are rmappable. Remove the
 	 * rmap after transferring young+dirty to the folio.
 	 */
-	if (is_present || is_device_private)
+	if (!delay_rmap)
 		folio_remove_rmap_pmd(folio, &folio->page, vma);
 
-	/* Device private folios are pinned. */
+	/* Device private folios are pinned and don't need a TLB flush. */
 	if (is_device_private)
 		folio_put(folio);
+	else if (__tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE))
+		*force_flush = true;
+
+	if (delay_rmap) {
+		tlb_flush_mmu_tlbonly(tlb);
+		folio_remove_rmap_pmd(folio, &folio->page, vma);
+	}
 }
 
 static struct folio *normal_or_softleaf_folio_pmd(struct vm_area_struct *vma,
@@ -2555,6 +2575,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb
 	struct mm_struct *mm = tlb->mm;
 	struct folio *folio = NULL;
 	bool is_present = false;
+	bool force_flush = false;
 	bool has_deposit;
 	spinlock_t *ptl;
 	pmd_t orig_pmd;
@@ -2579,13 +2600,14 @@ bool zap_huge_pmd(struct mmu_gather *tlb
 	folio = normal_or_softleaf_folio_pmd(vma, addr, orig_pmd, is_present);
 	has_deposit = vma_has_deposited_pgtable(vma);
 	if (folio)
-		zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present);
+		zap_huge_pmd_folio(tlb, vma, orig_pmd, folio, is_present,
+				   &force_flush);
 	if (has_deposit)
 		zap_deposited_table(mm, pmd);
 
 	spin_unlock(ptl);
-	if (is_present && folio)
-		tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
+	if (force_flush)
+		tlb_flush_mmu(tlb);
 	return true;
 }
 
--- a/mm/memory.c~mm-huge_memory-flush-dirty-file-pmds-before-removing-rmap
+++ a/mm/memory.c
@@ -1740,7 +1740,7 @@ static __always_inline void zap_present_
 		ptent = get_and_clear_full_ptes(mm, addr, pte, nr, tlb->fullmm);
 		if (pte_dirty(ptent)) {
 			folio_mark_dirty(folio);
-			if (tlb_delay_rmap(tlb)) {
+			if (tlb_can_delay_rmap()) {
 				delay_rmap = true;
 				*force_flush = true;
 			}
--- a/mm/mmu_gather.c~mm-huge_memory-flush-dirty-file-pmds-before-removing-rmap
+++ a/mm/mmu_gather.c
@@ -171,6 +171,8 @@ static bool __tlb_remove_folio_pages_siz
 	struct mmu_gather_batch *batch;
 
 	VM_BUG_ON(!tlb->end);
+	if (delay_rmap)
+		tlb->delayed_rmap = 1;
 
 #ifdef CONFIG_MMU_GATHER_PAGE_SIZE
 	VM_WARN_ON(tlb->page_size != page_size);
_

Patches currently in -mm which might be from david@kernel.org are

mm-huge_memory-flush-dirty-file-pmds-before-removing-rmap.patch
maintainers-memory-management-mglru-multi-gen-lru-update.patch
maintainers-remove-myself-from-memory-management-reclaim.patch
mm-mprotect-dont-skip-uffd-marker-install-when-racing-with-pte-table-reclaim.patch
mm-khugepaged-free-unused-page-table-when-setting-a-huge-pmd-fails.patch

