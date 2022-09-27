Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34A05C07E9D
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:51:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiI0Cvx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbiI0Ctl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:49:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADBDB5165
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:48:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 991DE6157F
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B11C433B5;
        Tue, 27 Sep 2022 02:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246933;
        bh=At5osLuAtKxr/oTWuxwI75x2Fgd2cxTLhZQXdsCCmLY=;
        h=Date:To:From:Subject:From;
        b=zO+U3nMcVMGMJdDPBXy78TESqY7ghzqg+UDBYel2Ez8M4yi7Pii+IR9sY4KSJnmQ0
         3BjQJPcFLBOsfK89uRMUSlYLekzsocQEMWTbN+kIwFDq0Lga3MCDkdwb4vSmkSoB/K
         AbKeya3S59oKoWGPXC60r4ZuD1G+7e40sN6I4ucU=
Date:   Mon, 26 Sep 2022 19:48:52 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, will@kernel.org,
        vbabka@suse.cz, svens@linux.ibm.com, sj@kernel.org,
        Liam.Howlett@Oracle.com, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] proc-remove-vma-rbtree-use-from-nommu.patch removed from -mm tree
Message-Id: <20220927024852.F2B11C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc: remove VMA rbtree use from nommu
has been removed from the -mm tree.  Its filename was
     proc-remove-vma-rbtree-use-from-nommu.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: proc: remove VMA rbtree use from nommu
Date: Tue, 6 Sep 2022 19:48:48 +0000

These users of the rbtree should probably have been walks of the linked
list, but convert them to use walks of the maple tree.

Link: https://lkml.kernel.org/r/20220906194824.2110408-17-Liam.Howlett@oracle.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_nommu.c |   45 +++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 24 deletions(-)

--- a/fs/proc/task_nommu.c~proc-remove-vma-rbtree-use-from-nommu
+++ a/fs/proc/task_nommu.c
@@ -20,15 +20,13 @@
  */
 void task_mem(struct seq_file *m, struct mm_struct *mm)
 {
+	VMA_ITERATOR(vmi, mm, 0);
 	struct vm_area_struct *vma;
 	struct vm_region *region;
-	struct rb_node *p;
 	unsigned long bytes = 0, sbytes = 0, slack = 0, size;
-        
-	mmap_read_lock(mm);
-	for (p = rb_first(&mm->mm_rb); p; p = rb_next(p)) {
-		vma = rb_entry(p, struct vm_area_struct, vm_rb);
 
+	mmap_read_lock(mm);
+	for_each_vma(vmi, vma) {
 		bytes += kobjsize(vma);
 
 		region = vma->vm_region;
@@ -82,15 +80,13 @@ void task_mem(struct seq_file *m, struct
 
 unsigned long task_vsize(struct mm_struct *mm)
 {
+	VMA_ITERATOR(vmi, mm, 0);
 	struct vm_area_struct *vma;
-	struct rb_node *p;
 	unsigned long vsize = 0;
 
 	mmap_read_lock(mm);
-	for (p = rb_first(&mm->mm_rb); p; p = rb_next(p)) {
-		vma = rb_entry(p, struct vm_area_struct, vm_rb);
+	for_each_vma(vmi, vma)
 		vsize += vma->vm_end - vma->vm_start;
-	}
 	mmap_read_unlock(mm);
 	return vsize;
 }
@@ -99,14 +95,13 @@ unsigned long task_statm(struct mm_struc
 			 unsigned long *shared, unsigned long *text,
 			 unsigned long *data, unsigned long *resident)
 {
+	VMA_ITERATOR(vmi, mm, 0);
 	struct vm_area_struct *vma;
 	struct vm_region *region;
-	struct rb_node *p;
 	unsigned long size = kobjsize(mm);
 
 	mmap_read_lock(mm);
-	for (p = rb_first(&mm->mm_rb); p; p = rb_next(p)) {
-		vma = rb_entry(p, struct vm_area_struct, vm_rb);
+	for_each_vma(vmi, vma) {
 		size += kobjsize(vma);
 		region = vma->vm_region;
 		if (region) {
@@ -190,17 +185,19 @@ static int nommu_vma_show(struct seq_fil
  */
 static int show_map(struct seq_file *m, void *_p)
 {
-	struct rb_node *p = _p;
-
-	return nommu_vma_show(m, rb_entry(p, struct vm_area_struct, vm_rb));
+	return nommu_vma_show(m, _p);
 }
 
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
 	struct proc_maps_private *priv = m->private;
 	struct mm_struct *mm;
-	struct rb_node *p;
-	loff_t n = *pos;
+	struct vm_area_struct *vma;
+	unsigned long addr = *pos;
+
+	/* See m_next(). Zero at the start or after lseek. */
+	if (addr == -1UL)
+		return NULL;
 
 	/* pin the task and mm whilst we play with them */
 	priv->task = get_proc_task(priv->inode);
@@ -216,10 +213,10 @@ static void *m_start(struct seq_file *m,
 		return ERR_PTR(-EINTR);
 	}
 
-	/* start from the Nth VMA */
-	for (p = rb_first(&mm->mm_rb); p; p = rb_next(p))
-		if (n-- == 0)
-			return p;
+	/* start the next element from addr */
+	vma = find_vma(mm, addr);
+	if (vma)
+		return vma;
 
 	mmap_read_unlock(mm);
 	mmput(mm);
@@ -242,10 +239,10 @@ static void m_stop(struct seq_file *m, v
 
 static void *m_next(struct seq_file *m, void *_p, loff_t *pos)
 {
-	struct rb_node *p = _p;
+	struct vm_area_struct *vma = _p;
 
-	(*pos)++;
-	return p ? rb_next(p) : NULL;
+	*pos = vma->vm_end;
+	return find_vma(vma->vm_mm, vma->vm_end);
 }
 
 static const struct seq_operations proc_pid_maps_ops = {
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

