From: akpm@linux-foundation.org
Subject: - mm-move_page_tables_up.patch removed from -mm tree
Date: Wed, 06 Jun 2007 10:19:47 -0700
Message-ID: <200706061719.l56HJljt002170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36200 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753206AbXFFRUc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 13:20:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, aaw@google.com, clameter@sgi.com, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     mm: move_page_tables{,_up}
has been removed from the -mm tree.  Its filename was
     mm-move_page_tables_up.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: mm: move_page_tables{,_up}
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Provide functions for moving page tables upwards.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ollie Wild <aaw@google.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 ++
 mm/mremap.c        |  105 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 110 insertions(+), 1 deletion(-)

diff -puN include/linux/mm.h~mm-move_page_tables_up include/linux/mm.h
--- a/include/linux/mm.h~mm-move_page_tables_up
+++ a/include/linux/mm.h
@@ -832,6 +832,12 @@ int FASTCALL(set_page_dirty(struct page 
 int set_page_dirty_lock(struct page *page);
 int clear_page_dirty_for_io(struct page *page);
 
+extern unsigned long move_page_tables(struct vm_area_struct *vma,
+		unsigned long old_addr, struct vm_area_struct *new_vma,
+		unsigned long new_addr, unsigned long len);
+extern unsigned long move_page_tables_up(struct vm_area_struct *vma,
+		unsigned long old_addr, struct vm_area_struct *new_vma,
+		unsigned long new_addr, unsigned long len);
 extern unsigned long do_mremap(unsigned long addr,
 			       unsigned long old_len, unsigned long new_len,
 			       unsigned long flags, unsigned long new_addr);
diff -puN mm/mremap.c~mm-move_page_tables_up mm/mremap.c
--- a/mm/mremap.c~mm-move_page_tables_up
+++ a/mm/mremap.c
@@ -118,9 +118,63 @@ static void move_ptes(struct vm_area_str
 		spin_unlock(&mapping->i_mmap_lock);
 }
 
+static void move_ptes_up(struct vm_area_struct *vma, pmd_t *old_pmd,
+		unsigned long old_addr, unsigned long old_end,
+		struct vm_area_struct *new_vma, pmd_t *new_pmd,
+		unsigned long new_addr)
+{
+	struct address_space *mapping = NULL;
+	struct mm_struct *mm = vma->vm_mm;
+	pte_t *old_pte, *new_pte, pte;
+	spinlock_t *old_ptl, *new_ptl;
+	unsigned long new_end = new_addr + (old_end - old_addr);
+
+	if (vma->vm_file) {
+		/*
+		 * Subtle point from Rajesh Venkatasubramanian: before
+		 * moving file-based ptes, we must lock vmtruncate out,
+		 * since it might clean the dst vma before the src vma,
+		 * and we propagate stale pages into the dst afterward.
+		 */
+		mapping = vma->vm_file->f_mapping;
+		spin_lock(&mapping->i_mmap_lock);
+		if (new_vma->vm_truncate_count &&
+		    new_vma->vm_truncate_count != vma->vm_truncate_count)
+			new_vma->vm_truncate_count = 0;
+	}
+
+	/*
+	 * We don't have to worry about the ordering of src and dst
+	 * pte locks because exclusive mmap_sem prevents deadlock.
+	 */
+	old_pte = pte_offset_map_lock(mm, old_pmd, old_end-1, &old_ptl);
+ 	new_pte = pte_offset_map_nested(new_pmd, new_end-1);
+	new_ptl = pte_lockptr(mm, new_pmd);
+	if (new_ptl != old_ptl)
+		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
+	arch_enter_lazy_mmu_mode();
+
+	for (; old_end > old_addr; old_pte--, old_end -= PAGE_SIZE,
+				   new_pte--, new_end -= PAGE_SIZE) {
+		if (pte_none(*old_pte))
+			continue;
+		pte = ptep_clear_flush(vma, old_end-1, old_pte);
+		pte = move_pte(pte, new_vma->vm_page_prot, old_end-1, new_end-1);
+		set_pte_at(mm, new_end-1, new_pte, pte);
+	}
+
+	arch_leave_lazy_mmu_mode();
+	if (new_ptl != old_ptl)
+		spin_unlock(new_ptl);
+	pte_unmap_nested(new_pte - 1);
+	pte_unmap_unlock(old_pte - 1, old_ptl);
+	if (mapping)
+		spin_unlock(&mapping->i_mmap_lock);
+}
+
 #define LATENCY_LIMIT	(64 * PAGE_SIZE)
 
-static unsigned long move_page_tables(struct vm_area_struct *vma,
+unsigned long move_page_tables(struct vm_area_struct *vma,
 		unsigned long old_addr, struct vm_area_struct *new_vma,
 		unsigned long new_addr, unsigned long len)
 {
@@ -132,21 +186,25 @@ static unsigned long move_page_tables(st
 
 	for (; old_addr < old_end; old_addr += extent, new_addr += extent) {
 		cond_resched();
+
 		next = (old_addr + PMD_SIZE) & PMD_MASK;
 		if (next - 1 > old_end)
 			next = old_end;
 		extent = next - old_addr;
+
 		old_pmd = get_old_pmd(vma->vm_mm, old_addr);
 		if (!old_pmd)
 			continue;
 		new_pmd = alloc_new_pmd(vma->vm_mm, new_addr);
 		if (!new_pmd)
 			break;
+
 		next = (new_addr + PMD_SIZE) & PMD_MASK;
 		if (extent > next - new_addr)
 			extent = next - new_addr;
 		if (extent > LATENCY_LIMIT)
 			extent = LATENCY_LIMIT;
+
 		move_ptes(vma, old_pmd, old_addr, old_addr + extent,
 				new_vma, new_pmd, new_addr);
 	}
@@ -154,6 +212,51 @@ static unsigned long move_page_tables(st
 	return len + old_addr - old_end;	/* how much done */
 }
 
+unsigned long move_page_tables_up(struct vm_area_struct *vma,
+		unsigned long old_addr, struct vm_area_struct *new_vma,
+		unsigned long new_addr, unsigned long len)
+{
+	unsigned long extent, prev, old_end, new_end;
+	pmd_t *old_pmd, *new_pmd;
+
+	old_end = old_addr + len;
+	new_end = new_addr + len;
+	flush_cache_range(vma, old_addr, old_end);
+
+	for (; old_end > old_addr; old_end -= extent, new_end -= extent) {
+		cond_resched();
+
+		/*
+		 * calculate how far till prev PMD boundary for old
+		 */
+		prev = (old_end - 1) & PMD_MASK;
+		if (prev < old_addr)
+			prev = old_addr;
+		extent = old_end - prev;
+
+		old_pmd = get_old_pmd(vma->vm_mm, old_end-1);
+		if (!old_pmd)
+			continue;
+		new_pmd = alloc_new_pmd(vma->vm_mm, new_end-1);
+		if (!new_pmd)
+			break;
+
+		/*
+		 * calculate and clip to prev PMD boundary for new
+		 */
+		prev = (new_end - 1) & PMD_MASK;
+		if (extent > new_end - prev)
+			extent = new_end - prev;
+		if (extent > LATENCY_LIMIT)
+			extent = LATENCY_LIMIT;
+
+		move_ptes_up(vma, old_pmd, old_end - extent, old_end,
+				new_vma, new_pmd, new_end - extent);
+	}
+
+	return old_addr + len - old_end;
+}
+
 static unsigned long move_vma(struct vm_area_struct *vma,
 		unsigned long old_addr, unsigned long old_len,
 		unsigned long new_len, unsigned long new_addr)
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

lumpy-reclaim-v4.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
mm-move_page_tables_up.patch
mm-variable-length-argument-support.patch
mm-variable-length-argument-support-fix.patch
fix-raw_spinlock_t-vs-lockdep.patch
lockdep-sanitise-config_prove_locking.patch
lockdep-reduce-the-ifdeffery.patch
lockstat-core-infrastructure.patch
lockstat-core-infrastructure-fix.patch
lockstat-core-infrastructure-fix-fix.patch
lockstat-human-readability-tweaks.patch
lockstat-human-readability-tweaks-fix.patch
lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex.patch
