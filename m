Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 161E4C32789
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 19:21:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238426AbiHVTVa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 15:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238658AbiHVTUx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 15:20:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10296B7F
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 12:20:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7A25FCE16D9
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 19:19:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB745C433C1;
        Mon, 22 Aug 2022 19:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661195996;
        bh=YvIEu6ZBFpI3lxy1t5G++fGiq0FAlBP7dtzs91/C77o=;
        h=Date:To:From:Subject:From;
        b=IOlTt4KJO/xWeqaidVdJ4w8wU9rx2Y6jBghneorRZVdT+h4DBKKcIeWZ/3a+DXNNH
         4fuFQSgn3xdpzGjxNq06+so7MosJSaiGukYyna5AWFkCMa0tYm35DH26ZYt5RI3Bt2
         TRUN6A+hj916FLAYT3qbWuysN3VuOFG+5a6MMWas=
Date:   Mon, 22 Aug 2022 12:19:56 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, will@kernel.org,
        vbabka@suse.cz, svens@linux.ibm.com, sj@kernel.org,
        Liam.Howlett@Oracle.com, dhowells@redhat.com, david@redhat.com,
        catalin.marinas@arm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-remove-vma-rbtree-use-from-nommu.patch added to mm-unstable branch
Message-Id: <20220822191956.BB745C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: remove VMA rbtree use from nommu
has been added to the -mm mm-unstable branch.  Its filename is
     proc-remove-vma-rbtree-use-from-nommu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-remove-vma-rbtree-use-from-nommu.patch

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
Subject: proc: remove VMA rbtree use from nommu
Date: Mon, 22 Aug 2022 15:03:19 +0000

These users of the rbtree should probably have been walks of the linked
list, but convert them to use walks of the maple tree.

Link: https://lkml.kernel.org/r/20220822150128.1562046-17-Liam.Howlett@oracle.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
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

