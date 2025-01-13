Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAF74315A;
	Mon, 13 Jan 2025 03:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736737461; cv=none; b=UnGk3QSqqzEtfNNJxpWPxkMoE8DWhnW/kt1dii1JuMCxDuHbKD1yTxy9uMiVwXiamK/cPGaGFcf3dWgOxT2Rknb+FYKldz2N5Z2PgTvHNQb3HhJpimXjjMiqG4gxF9h79/Zhvi2QOG11C6aanHhj9+p/8Y3K6jFjd8xKmr90nTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736737461; c=relaxed/simple;
	bh=BxgjWLLSUQ6CkegO2uMIUnYsy8luOBPmVhLRU7YcL+c=;
	h=Date:To:From:Subject:Message-Id; b=Zx4AeCbXPVYJ9KI4jP9RRjmDKpsUOTwI1yvy6bNMic2oCBSSMyok1SmcYTsMG7eVk+iQNj6ygYQNnscFuWyUgLDWf/GaNBlC+rR4msaBMIjk3yTw20V267ADLMpGZNfHrEZhenvmcRtXW5oGICWzvf0rim6bbmy9CF4aGrkO5ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xGfvVQby; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xGfvVQby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E4DC4CEDF;
	Mon, 13 Jan 2025 03:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736737460;
	bh=BxgjWLLSUQ6CkegO2uMIUnYsy8luOBPmVhLRU7YcL+c=;
	h=Date:To:From:Subject:From;
	b=xGfvVQbycVLJWjJKFMsXersQGAkNs/2LQ6CSVVXHmW13IjCW3n8wJLu3Iy1Of3vYy
	 N013uCKawNHZwfHJAQIkScZccLqntWfoIlNj2jpfRuFIhzzYtT7kT/cLePeuwhwpvg
	 ec4ZSOMY1cIgH3QipIEFUF3p+oXASoYh7bIzd3ww=
Date: Sun, 12 Jan 2025 19:04:20 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,shuah@kernel.org,peterx@redhat.com,muchun.song@linux.dev,miko.lenczewski@arm.com,mark.rutland@arm.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jannh@google.com,david@redhat.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-clear-uffd-wp-pte-pmd-state-on-mremap.patch removed from -mm tree
Message-Id: <20250113030420.B1E4DC4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: clear uffd-wp PTE/PMD state on mremap()
has been removed from the -mm tree.  Its filename was
     mm-clear-uffd-wp-pte-pmd-state-on-mremap.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: clear uffd-wp PTE/PMD state on mremap()
Date: Tue, 7 Jan 2025 14:47:52 +0000

When mremap()ing a memory region previously registered with userfaultfd as
write-protected but without UFFD_FEATURE_EVENT_REMAP, an inconsistency in
flag clearing leads to a mismatch between the vma flags (which have
uffd-wp cleared) and the pte/pmd flags (which do not have uffd-wp
cleared).  This mismatch causes a subsequent mprotect(PROT_WRITE) to
trigger a warning in page_table_check_pte_flags() due to setting the pte
to writable while uffd-wp is still set.

Fix this by always explicitly clearing the uffd-wp pte/pmd flags on any
such mremap() so that the values are consistent with the existing clearing
of VM_UFFD_WP.  Be careful to clear the logical flag regardless of its
physical form; a PTE bit, a swap PTE bit, or a PTE marker.  Cover PTE,
huge PMD and hugetlb paths.

Link: https://lkml.kernel.org/r/20250107144755.1871363-2-ryan.roberts@arm.com
Co-developed-by: Mikołaj Lenczewski <miko.lenczewski@arm.com>
Signed-off-by: Mikołaj Lenczewski <miko.lenczewski@arm.com>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Closes: https://lore.kernel.org/linux-mm/810b44a8-d2ae-4107-b665-5a42eae2d948@arm.com/
Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/userfaultfd_k.h |   12 ++++++++++++
 mm/huge_memory.c              |   12 ++++++++++++
 mm/hugetlb.c                  |   14 +++++++++++++-
 mm/mremap.c                   |   32 +++++++++++++++++++++++++++++++-
 4 files changed, 68 insertions(+), 2 deletions(-)

--- a/include/linux/userfaultfd_k.h~mm-clear-uffd-wp-pte-pmd-state-on-mremap
+++ a/include/linux/userfaultfd_k.h
@@ -247,6 +247,13 @@ static inline bool vma_can_userfault(str
 	    vma_is_shmem(vma);
 }
 
+static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
+{
+	struct userfaultfd_ctx *uffd_ctx = vma->vm_userfaultfd_ctx.ctx;
+
+	return uffd_ctx && (uffd_ctx->features & UFFD_FEATURE_EVENT_REMAP) == 0;
+}
+
 extern int dup_userfaultfd(struct vm_area_struct *, struct list_head *);
 extern void dup_userfaultfd_complete(struct list_head *);
 void dup_userfaultfd_fail(struct list_head *);
@@ -401,6 +408,11 @@ static inline bool userfaultfd_wp_async(
 {
 	return false;
 }
+
+static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
+{
+	return false;
+}
 
 #endif /* CONFIG_USERFAULTFD */
 
--- a/mm/huge_memory.c~mm-clear-uffd-wp-pte-pmd-state-on-mremap
+++ a/mm/huge_memory.c
@@ -2206,6 +2206,16 @@ static pmd_t move_soft_dirty_pmd(pmd_t p
 	return pmd;
 }
 
+static pmd_t clear_uffd_wp_pmd(pmd_t pmd)
+{
+	if (pmd_present(pmd))
+		pmd = pmd_clear_uffd_wp(pmd);
+	else if (is_swap_pmd(pmd))
+		pmd = pmd_swp_clear_uffd_wp(pmd);
+
+	return pmd;
+}
+
 bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 		  unsigned long new_addr, pmd_t *old_pmd, pmd_t *new_pmd)
 {
@@ -2244,6 +2254,8 @@ bool move_huge_pmd(struct vm_area_struct
 			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
 		}
 		pmd = move_soft_dirty_pmd(pmd);
+		if (vma_has_uffd_without_event_remap(vma))
+			pmd = clear_uffd_wp_pmd(pmd);
 		set_pmd_at(mm, new_addr, new_pmd, pmd);
 		if (force_flush)
 			flush_pmd_tlb_range(vma, old_addr, old_addr + PMD_SIZE);
--- a/mm/hugetlb.c~mm-clear-uffd-wp-pte-pmd-state-on-mremap
+++ a/mm/hugetlb.c
@@ -5402,6 +5402,7 @@ static void move_huge_pte(struct vm_area
 			  unsigned long new_addr, pte_t *src_pte, pte_t *dst_pte,
 			  unsigned long sz)
 {
+	bool need_clear_uffd_wp = vma_has_uffd_without_event_remap(vma);
 	struct hstate *h = hstate_vma(vma);
 	struct mm_struct *mm = vma->vm_mm;
 	spinlock_t *src_ptl, *dst_ptl;
@@ -5418,7 +5419,18 @@ static void move_huge_pte(struct vm_area
 		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
 
 	pte = huge_ptep_get_and_clear(mm, old_addr, src_pte);
-	set_huge_pte_at(mm, new_addr, dst_pte, pte, sz);
+
+	if (need_clear_uffd_wp && pte_marker_uffd_wp(pte))
+		huge_pte_clear(mm, new_addr, dst_pte, sz);
+	else {
+		if (need_clear_uffd_wp) {
+			if (pte_present(pte))
+				pte = huge_pte_clear_uffd_wp(pte);
+			else if (is_swap_pte(pte))
+				pte = pte_swp_clear_uffd_wp(pte);
+		}
+		set_huge_pte_at(mm, new_addr, dst_pte, pte, sz);
+	}
 
 	if (src_ptl != dst_ptl)
 		spin_unlock(src_ptl);
--- a/mm/mremap.c~mm-clear-uffd-wp-pte-pmd-state-on-mremap
+++ a/mm/mremap.c
@@ -138,6 +138,7 @@ static int move_ptes(struct vm_area_stru
 		struct vm_area_struct *new_vma, pmd_t *new_pmd,
 		unsigned long new_addr, bool need_rmap_locks)
 {
+	bool need_clear_uffd_wp = vma_has_uffd_without_event_remap(vma);
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *old_pte, *new_pte, pte;
 	pmd_t dummy_pmdval;
@@ -216,7 +217,18 @@ static int move_ptes(struct vm_area_stru
 			force_flush = true;
 		pte = move_pte(pte, old_addr, new_addr);
 		pte = move_soft_dirty_pte(pte);
-		set_pte_at(mm, new_addr, new_pte, pte);
+
+		if (need_clear_uffd_wp && pte_marker_uffd_wp(pte))
+			pte_clear(mm, new_addr, new_pte);
+		else {
+			if (need_clear_uffd_wp) {
+				if (pte_present(pte))
+					pte = pte_clear_uffd_wp(pte);
+				else if (is_swap_pte(pte))
+					pte = pte_swp_clear_uffd_wp(pte);
+			}
+			set_pte_at(mm, new_addr, new_pte, pte);
+		}
 	}
 
 	arch_leave_lazy_mmu_mode();
@@ -278,6 +290,15 @@ static bool move_normal_pmd(struct vm_ar
 	if (WARN_ON_ONCE(!pmd_none(*new_pmd)))
 		return false;
 
+	/* If this pmd belongs to a uffd vma with remap events disabled, we need
+	 * to ensure that the uffd-wp state is cleared from all pgtables. This
+	 * means recursing into lower page tables in move_page_tables(), and we
+	 * can reuse the existing code if we simply treat the entry as "not
+	 * moved".
+	 */
+	if (vma_has_uffd_without_event_remap(vma))
+		return false;
+
 	/*
 	 * We don't have to worry about the ordering of src and dst
 	 * ptlocks because exclusive mmap_lock prevents deadlock.
@@ -333,6 +354,15 @@ static bool move_normal_pud(struct vm_ar
 	if (WARN_ON_ONCE(!pud_none(*new_pud)))
 		return false;
 
+	/* If this pud belongs to a uffd vma with remap events disabled, we need
+	 * to ensure that the uffd-wp state is cleared from all pgtables. This
+	 * means recursing into lower page tables in move_page_tables(), and we
+	 * can reuse the existing code if we simply treat the entry as "not
+	 * moved".
+	 */
+	if (vma_has_uffd_without_event_remap(vma))
+		return false;
+
 	/*
 	 * We don't have to worry about the ordering of src and dst
 	 * ptlocks because exclusive mmap_lock prevents deadlock.
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

selftests-mm-add-fork-cow-guard-page-test-fix.patch
selftests-mm-introduce-uffd-wp-mremap-regression-test.patch

