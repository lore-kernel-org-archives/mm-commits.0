Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ABF8C32774
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 19:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237823AbiHVTWQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 15:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238772AbiHVTVG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 15:21:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CED98
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 12:21:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F38ECB818A9
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 19:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80AE6C433C1;
        Mon, 22 Aug 2022 19:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661196062;
        bh=eu911QJVEdGvXhcJ1+QYIfZg9B/9uoQa/DQZyMXusVY=;
        h=Date:To:From:Subject:From;
        b=dGg/yS5jlN1MOYfKZ8S1Lh0FmaVAMSOdYEnBJx477tsppB3i0FrDRekCpHpYEq5JY
         lbriGEmS4SB8hJoZ4lMYPu0hMsAtoo03yltqH41p2DQJj4y6Wat3zzcIFqg+tlV11Q
         xwQNJGCK2YE9Bt/U3mIEXEpzgmXOrGe4htOv4PlY=
Date:   Mon, 22 Aug 2022 12:21:01 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, will@kernel.org,
        vbabka@suse.cz, svens@linux.ibm.com, sj@kernel.org,
        Liam.Howlett@Oracle.com, dhowells@redhat.com, david@redhat.com,
        catalin.marinas@arm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch added to mm-unstable branch
Message-Id: <20220822192102.80AE6C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu: stop using linked list and highest_vm_end
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: fs/proc/task_mmu: stop using linked list and highest_vm_end
Date: Mon, 22 Aug 2022 15:06:25 +0000

Remove references to mm_struct linked list and highest_vm_end for when
they are removed

Link: https://lkml.kernel.org/r/20220822150128.1562046-44-Liam.Howlett@oracle.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
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

support-highmem-pages-in-vmap_pages_range_noflush.patch
mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch

