Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA035C07E9D
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiI0Cx7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiI0Cvn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:51:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF56FAD90
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:49:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EC3E615B5
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:49:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0908C433D6;
        Tue, 27 Sep 2022 02:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246969;
        bh=eC6y2dBj6phyNmxjE7HV749IKtCxWibSwB7D6A0H8P8=;
        h=Date:To:From:Subject:From;
        b=ADf/lBxI3k1V23190vfdsFtG29HwJNzCVNFCV3tQVG8V24BZ/dWvvEiORW6OB3URz
         ZrxLBNwwOtvYJ03RLu6URRUwifAZF/jFAW9zHPb1rLH6tciBD2+n47qvMlHH4yfl9+
         WjSAFZzYMuEj35UzwokUCfhiGoVJ9awcGOcwLYOU=
Date:   Mon, 26 Sep 2022 19:49:28 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, will@kernel.org,
        vbabka@suse.cz, svens@linux.ibm.com, sj@kernel.org,
        Liam.Howlett@Oracle.com, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch removed from -mm tree
Message-Id: <20220927024928.F0908C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/proc/task_mmu: stop using linked list and highest_vm_end
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: fs/proc/task_mmu: stop using linked list and highest_vm_end
Date: Tue, 6 Sep 2022 19:48:57 +0000

Remove references to mm_struct linked list and highest_vm_end for when
they are removed

Link: https://lkml.kernel.org/r/20220906194824.2110408-44-Liam.Howlett@oracle.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/internal.h |    2 -
 fs/proc/task_mmu.c |   73 ++++++++++++++++++++++++-------------------
 2 files changed, 42 insertions(+), 33 deletions(-)

--- a/fs/proc/internal.h~fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end
+++ a/fs/proc/internal.h
@@ -285,7 +285,7 @@ struct proc_maps_private {
 	struct task_struct *task;
 	struct mm_struct *mm;
 #ifdef CONFIG_MMU
-	struct vm_area_struct *tail_vma;
+	struct vma_iterator iter;
 #endif
 #ifdef CONFIG_NUMA
 	struct mempolicy *task_mempolicy;
--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end
+++ a/fs/proc/task_mmu.c
@@ -123,12 +123,26 @@ static void release_task_mempolicy(struc
 }
 #endif
 
+static struct vm_area_struct *proc_get_vma(struct proc_maps_private *priv,
+						loff_t *ppos)
+{
+	struct vm_area_struct *vma = vma_next(&priv->iter);
+
+	if (vma) {
+		*ppos = vma->vm_start;
+	} else {
+		*ppos = -2UL;
+		vma = get_gate_vma(priv->mm);
+	}
+
+	return vma;
+}
+
 static void *m_start(struct seq_file *m, loff_t *ppos)
 {
 	struct proc_maps_private *priv = m->private;
 	unsigned long last_addr = *ppos;
 	struct mm_struct *mm;
-	struct vm_area_struct *vma;
 
 	/* See m_next(). Zero at the start or after lseek. */
 	if (last_addr == -1UL)
@@ -152,31 +166,21 @@ static void *m_start(struct seq_file *m,
 		return ERR_PTR(-EINTR);
 	}
 
+	vma_iter_init(&priv->iter, mm, last_addr);
 	hold_task_mempolicy(priv);
-	priv->tail_vma = get_gate_vma(mm);
-
-	vma = find_vma(mm, last_addr);
-	if (vma)
-		return vma;
+	if (last_addr == -2UL)
+		return get_gate_vma(mm);
 
-	return priv->tail_vma;
+	return proc_get_vma(priv, ppos);
 }
 
 static void *m_next(struct seq_file *m, void *v, loff_t *ppos)
 {
-	struct proc_maps_private *priv = m->private;
-	struct vm_area_struct *next, *vma = v;
-
-	if (vma == priv->tail_vma)
-		next = NULL;
-	else if (vma->vm_next)
-		next = vma->vm_next;
-	else
-		next = priv->tail_vma;
-
-	*ppos = next ? next->vm_start : -1UL;
-
-	return next;
+	if (*ppos == -2UL) {
+		*ppos = -1UL;
+		return NULL;
+	}
+	return proc_get_vma(m->private, ppos);
 }
 
 static void m_stop(struct seq_file *m, void *v)
@@ -876,16 +880,16 @@ static int show_smaps_rollup(struct seq_
 {
 	struct proc_maps_private *priv = m->private;
 	struct mem_size_stats mss;
-	struct mm_struct *mm;
+	struct mm_struct *mm = priv->mm;
 	struct vm_area_struct *vma;
-	unsigned long last_vma_end = 0;
+	unsigned long vma_start = 0, last_vma_end = 0;
 	int ret = 0;
+	MA_STATE(mas, &mm->mm_mt, 0, 0);
 
 	priv->task = get_proc_task(priv->inode);
 	if (!priv->task)
 		return -ESRCH;
 
-	mm = priv->mm;
 	if (!mm || !mmget_not_zero(mm)) {
 		ret = -ESRCH;
 		goto out_put_task;
@@ -898,8 +902,13 @@ static int show_smaps_rollup(struct seq_
 		goto out_put_mm;
 
 	hold_task_mempolicy(priv);
+	vma = mas_find(&mas, 0);
 
-	for (vma = priv->mm->mmap; vma;) {
+	if (unlikely(!vma))
+		goto empty_set;
+
+	vma_start = vma->vm_start;
+	do {
 		smap_gather_stats(vma, &mss, 0);
 		last_vma_end = vma->vm_end;
 
@@ -908,6 +917,7 @@ static int show_smaps_rollup(struct seq_
 		 * access it for write request.
 		 */
 		if (mmap_lock_is_contended(mm)) {
+			mas_pause(&mas);
 			mmap_read_unlock(mm);
 			ret = mmap_read_lock_killable(mm);
 			if (ret) {
@@ -951,7 +961,7 @@ static int show_smaps_rollup(struct seq_
 			 *    contains last_vma_end.
 			 *    Iterate VMA' from last_vma_end.
 			 */
-			vma = find_vma(mm, last_vma_end - 1);
+			vma = mas_find(&mas, ULONG_MAX);
 			/* Case 3 above */
 			if (!vma)
 				break;
@@ -965,11 +975,10 @@ static int show_smaps_rollup(struct seq_
 				smap_gather_stats(vma, &mss, last_vma_end);
 		}
 		/* Case 2 above */
-		vma = vma->vm_next;
-	}
+	} while ((vma = mas_find(&mas, ULONG_MAX)) != NULL);
 
-	show_vma_header_prefix(m, priv->mm->mmap->vm_start,
-			       last_vma_end, 0, 0, 0, 0);
+empty_set:
+	show_vma_header_prefix(m, vma_start, last_vma_end, 0, 0, 0, 0);
 	seq_pad(m, ' ');
 	seq_puts(m, "[rollup]\n");
 
@@ -1262,6 +1271,7 @@ static ssize_t clear_refs_write(struct f
 		return -ESRCH;
 	mm = get_task_mm(task);
 	if (mm) {
+		MA_STATE(mas, &mm->mm_mt, 0, 0);
 		struct mmu_notifier_range range;
 		struct clear_refs_private cp = {
 			.type = type,
@@ -1281,7 +1291,7 @@ static ssize_t clear_refs_write(struct f
 		}
 
 		if (type == CLEAR_REFS_SOFT_DIRTY) {
-			for (vma = mm->mmap; vma; vma = vma->vm_next) {
+			mas_for_each(&mas, vma, ULONG_MAX) {
 				if (!(vma->vm_flags & VM_SOFTDIRTY))
 					continue;
 				vma->vm_flags &= ~VM_SOFTDIRTY;
@@ -1293,8 +1303,7 @@ static ssize_t clear_refs_write(struct f
 						0, NULL, mm, 0, -1UL);
 			mmu_notifier_invalidate_range_start(&range);
 		}
-		walk_page_range(mm, 0, mm->highest_vm_end, &clear_refs_walk_ops,
-				&cp);
+		walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp);
 		if (type == CLEAR_REFS_SOFT_DIRTY) {
 			mmu_notifier_invalidate_range_end(&range);
 			flush_tlb_mm(mm);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-vmscan-fix-a-lot-of-comments.patch
mm-add-the-first-tail-page-to-struct-folio.patch
mm-reimplement-folio_order-and-folio_nr_pages.patch
mm-add-split_folio.patch
mm-add-folio_add_lru_vma.patch
shmem-convert-shmem_writepage-to-use-a-folio-throughout.patch
shmem-convert-shmem_delete_from_page_cache-to-take-a-folio.patch
shmem-convert-shmem_replace_page-to-use-folios-throughout.patch
mm-swapfile-remove-page_swapcount.patch
mm-swapfile-convert-try_to_free_swap-to-folio_free_swap.patch
mm-swap-convert-__read_swap_cache_async-to-use-a-folio.patch
mm-swap-convert-add_to_swap_cache-to-take-a-folio.patch
mm-swap-convert-put_swap_page-to-put_swap_folio.patch
mm-convert-do_swap_page-to-use-a-folio.patch
mm-convert-do_swap_pages-swapcache-variable-to-a-folio.patch
memcg-convert-mem_cgroup_swapin_charge_page-to-mem_cgroup_swapin_charge_folio.patch
shmem-convert-shmem_mfill_atomic_pte-to-use-a-folio.patch
shmem-convert-shmem_replace_page-to-shmem_replace_folio.patch
swap-add-swap_cache_get_folio.patch
shmem-eliminate-struct-page-from-shmem_swapin_folio.patch
shmem-convert-shmem_getpage_gfp-to-shmem_get_folio_gfp.patch
shmem-convert-shmem_fault-to-use-shmem_get_folio_gfp.patch
shmem-convert-shmem_read_mapping_page_gfp-to-use-shmem_get_folio_gfp.patch
shmem-add-shmem_get_folio.patch
shmem-convert-shmem_get_partial_folio-to-use-shmem_get_folio.patch
shmem-convert-shmem_write_begin-to-use-shmem_get_folio.patch
shmem-convert-shmem_file_read_iter-to-use-shmem_get_folio.patch
shmem-convert-shmem_fallocate-to-use-a-folio.patch
shmem-convert-shmem_symlink-to-use-a-folio.patch
shmem-convert-shmem_get_link-to-use-a-folio.patch
khugepaged-call-shmem_get_folio.patch
userfaultfd-convert-mcontinue_atomic_pte-to-use-a-folio.patch
shmem-remove-shmem_getpage.patch
swapfile-convert-try_to_unuse-to-use-a-folio.patch
swapfile-convert-__try_to_reclaim_swap-to-use-a-folio.patch
swapfile-convert-unuse_pte_range-to-use-a-folio.patch
mm-convert-do_swap_page-to-use-swap_cache_get_folio.patch
mm-remove-lookup_swap_cache.patch
swap_state-convert-free_swap_cache-to-use-a-folio.patch
swap-convert-swap_writepage-to-use-a-folio.patch
mm-convert-do_wp_page-to-use-a-folio.patch
huge_memory-convert-do_huge_pmd_wp_page-to-use-a-folio.patch
madvise-convert-madvise_free_pte_range-to-use-a-folio.patch
uprobes-use-folios-more-widely-in-__replace_page.patch
ksm-use-a-folio-in-replace_page.patch
mm-convert-do_swap_page-to-use-folio_free_swap.patch
memcg-convert-mem_cgroup_swap_full-to-take-a-folio.patch
mm-remove-try_to_free_swap.patch
rmap-convert-page_move_anon_rmap-to-use-a-folio.patch
migrate-convert-__unmap_and_move-to-use-folios.patch
migrate-convert-unmap_and_move_huge_page-to-use-folios.patch
huge_memory-convert-split_huge_page_to_list-to-use-a-folio.patch
huge_memory-convert-unmap_page-to-unmap_folio.patch
mm-convert-page_get_anon_vma-to-folio_get_anon_vma.patch
rmap-remove-page_unlock_anon_vma_read.patch
uprobes-use-new_folio-in-__replace_page.patch
mm-convert-lock_page_or_retry-to-folio_lock_or_retry.patch

