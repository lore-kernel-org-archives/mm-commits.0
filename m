From: akpm@linux-foundation.org
Subject: - maps2-regroup-task_mmu-by-interface.patch removed from -mm tree
Date: Tue, 16 Oct 2007 14:36:28 -0700
Message-ID: <200710162136.l9GLaSwj018583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38273 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966202AbXJPVsx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:48:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, jeremy@goop.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     maps: regroup task_mmu by interface
has been removed from the -mm tree.  Its filename was
     maps2-regroup-task_mmu-by-interface.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: maps: regroup task_mmu by interface
From: Matt Mackall <mpm@selenic.com>

Reorder source so that all the code and data for each interface is together.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |  379 +++++++++++++++++++++----------------------
 1 file changed, 190 insertions(+), 189 deletions(-)

diff -puN fs/proc/task_mmu.c~maps2-regroup-task_mmu-by-interface fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~maps2-regroup-task_mmu-by-interface
+++ a/fs/proc/task_mmu.c
@@ -114,16 +114,121 @@ static void pad_len_spaces(struct seq_fi
 	seq_printf(m, "%*c", len, ' ');
 }
 
-struct mem_size_stats
+static void vma_stop(struct proc_maps_private *priv, struct vm_area_struct *vma)
 {
-	struct vm_area_struct *vma;
-	unsigned long resident;
-	unsigned long shared_clean;
-	unsigned long shared_dirty;
-	unsigned long private_clean;
-	unsigned long private_dirty;
-	unsigned long referenced;
-};
+	if (vma && vma != priv->tail_vma) {
+		struct mm_struct *mm = vma->vm_mm;
+		up_read(&mm->mmap_sem);
+		mmput(mm);
+	}
+}
+
+static void *m_start(struct seq_file *m, loff_t *pos)
+{
+	struct proc_maps_private *priv = m->private;
+	unsigned long last_addr = m->version;
+	struct mm_struct *mm;
+	struct vm_area_struct *vma, *tail_vma = NULL;
+	loff_t l = *pos;
+
+	/* Clear the per syscall fields in priv */
+	priv->task = NULL;
+	priv->tail_vma = NULL;
+
+	/*
+	 * We remember last_addr rather than next_addr to hit with
+	 * mmap_cache most of the time. We have zero last_addr at
+	 * the beginning and also after lseek. We will have -1 last_addr
+	 * after the end of the vmas.
+	 */
+
+	if (last_addr == -1UL)
+		return NULL;
+
+	priv->task = get_pid_task(priv->pid, PIDTYPE_PID);
+	if (!priv->task)
+		return NULL;
+
+	mm = get_task_mm(priv->task);
+	if (!mm)
+		return NULL;
+
+	priv->tail_vma = tail_vma = get_gate_vma(priv->task);
+	down_read(&mm->mmap_sem);
+
+	/* Start with last addr hint */
+	if (last_addr && (vma = find_vma(mm, last_addr))) {
+		vma = vma->vm_next;
+		goto out;
+	}
+
+	/*
+	 * Check the vma index is within the range and do
+	 * sequential scan until m_index.
+	 */
+	vma = NULL;
+	if ((unsigned long)l < mm->map_count) {
+		vma = mm->mmap;
+		while (l-- && vma)
+			vma = vma->vm_next;
+		goto out;
+	}
+
+	if (l != mm->map_count)
+		tail_vma = NULL; /* After gate vma */
+
+out:
+	if (vma)
+		return vma;
+
+	/* End of vmas has been reached */
+	m->version = (tail_vma != NULL)? 0: -1UL;
+	up_read(&mm->mmap_sem);
+	mmput(mm);
+	return tail_vma;
+}
+
+static void *m_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct proc_maps_private *priv = m->private;
+	struct vm_area_struct *vma = v;
+	struct vm_area_struct *tail_vma = priv->tail_vma;
+
+	(*pos)++;
+	if (vma && (vma != tail_vma) && vma->vm_next)
+		return vma->vm_next;
+	vma_stop(priv, vma);
+	return (vma != tail_vma)? tail_vma: NULL;
+}
+
+static void m_stop(struct seq_file *m, void *v)
+{
+	struct proc_maps_private *priv = m->private;
+	struct vm_area_struct *vma = v;
+
+	vma_stop(priv, vma);
+	if (priv->task)
+		put_task_struct(priv->task);
+}
+
+static int do_maps_open(struct inode *inode, struct file *file,
+			struct seq_operations *ops)
+{
+	struct proc_maps_private *priv;
+	int ret = -ENOMEM;
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (priv) {
+		priv->pid = proc_pid(inode);
+		ret = seq_open(file, ops);
+		if (!ret) {
+			struct seq_file *m = file->private_data;
+			m->private = priv;
+		} else {
+			kfree(priv);
+		}
+	}
+	return ret;
+}
 
 static int show_map(struct seq_file *m, void *v)
 {
@@ -190,6 +295,36 @@ static int show_map(struct seq_file *m, 
 	return 0;
 }
 
+static struct seq_operations proc_pid_maps_op = {
+	.start	= m_start,
+	.next	= m_next,
+	.stop	= m_stop,
+	.show	= show_map
+};
+
+static int maps_open(struct inode *inode, struct file *file)
+{
+	return do_maps_open(inode, file, &proc_pid_maps_op);
+}
+
+const struct file_operations proc_maps_operations = {
+	.open		= maps_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release_private,
+};
+
+struct mem_size_stats
+{
+	struct vm_area_struct *vma;
+	unsigned long resident;
+	unsigned long shared_clean;
+	unsigned long shared_dirty;
+	unsigned long private_clean;
+	unsigned long private_dirty;
+	unsigned long referenced;
+};
+
 static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			   void *private)
 {
@@ -231,33 +366,6 @@ static int smaps_pte_range(pmd_t *pmd, u
 	return 0;
 }
 
-static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
-				unsigned long end, void *private)
-{
-	struct vm_area_struct *vma = private;
-	pte_t *pte, ptent;
-	spinlock_t *ptl;
-	struct page *page;
-
-	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	for (; addr != end; pte++, addr += PAGE_SIZE) {
-		ptent = *pte;
-		if (!pte_present(ptent))
-			continue;
-
-		page = vm_normal_page(vma, addr, ptent);
-		if (!page)
-			continue;
-
-		/* Clear accessed and referenced bits. */
-		ptep_test_and_clear_young(vma, addr, pte);
-		ClearPageReferenced(page);
-	}
-	pte_unmap_unlock(pte - 1, ptl);
-	cond_resched();
-	return 0;
-}
-
 static struct mm_walk smaps_walk = { .pmd_entry = smaps_pte_range };
 
 static int show_smap(struct seq_file *m, void *v)
@@ -295,6 +403,52 @@ static int show_smap(struct seq_file *m,
 	return ret;
 }
 
+static struct seq_operations proc_pid_smaps_op = {
+	.start	= m_start,
+	.next	= m_next,
+	.stop	= m_stop,
+	.show	= show_smap
+};
+
+static int smaps_open(struct inode *inode, struct file *file)
+{
+	return do_maps_open(inode, file, &proc_pid_smaps_op);
+}
+
+const struct file_operations proc_smaps_operations = {
+	.open		= smaps_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release_private,
+};
+
+static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
+				unsigned long end, void *private)
+{
+	struct vm_area_struct *vma = private;
+	pte_t *pte, ptent;
+	spinlock_t *ptl;
+	struct page *page;
+
+	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	for (; addr != end; pte++, addr += PAGE_SIZE) {
+		ptent = *pte;
+		if (!pte_present(ptent))
+			continue;
+
+		page = vm_normal_page(vma, addr, ptent);
+		if (!page)
+			continue;
+
+		/* Clear accessed and referenced bits. */
+		ptep_test_and_clear_young(vma, addr, pte);
+		ClearPageReferenced(page);
+	}
+	pte_unmap_unlock(pte - 1, ptl);
+	cond_resched();
+	return 0;
+}
+
 static struct mm_walk clear_refs_walk = { .pmd_entry = clear_refs_pte_range };
 
 static ssize_t clear_refs_write(struct file *file, const char __user *buf,
@@ -338,148 +492,6 @@ const struct file_operations proc_clear_
 	.write		= clear_refs_write,
 };
 
-static void *m_start(struct seq_file *m, loff_t *pos)
-{
-	struct proc_maps_private *priv = m->private;
-	unsigned long last_addr = m->version;
-	struct mm_struct *mm;
-	struct vm_area_struct *vma, *tail_vma = NULL;
-	loff_t l = *pos;
-
-	/* Clear the per syscall fields in priv */
-	priv->task = NULL;
-	priv->tail_vma = NULL;
-
-	/*
-	 * We remember last_addr rather than next_addr to hit with
-	 * mmap_cache most of the time. We have zero last_addr at
-	 * the beginning and also after lseek. We will have -1 last_addr
-	 * after the end of the vmas.
-	 */
-
-	if (last_addr == -1UL)
-		return NULL;
-
-	priv->task = get_pid_task(priv->pid, PIDTYPE_PID);
-	if (!priv->task)
-		return NULL;
-
-	mm = get_task_mm(priv->task);
-	if (!mm)
-		return NULL;
-
-	priv->tail_vma = tail_vma = get_gate_vma(priv->task);
-	down_read(&mm->mmap_sem);
-
-	/* Start with last addr hint */
-	if (last_addr && (vma = find_vma(mm, last_addr))) {
-		vma = vma->vm_next;
-		goto out;
-	}
-
-	/*
-	 * Check the vma index is within the range and do
-	 * sequential scan until m_index.
-	 */
-	vma = NULL;
-	if ((unsigned long)l < mm->map_count) {
-		vma = mm->mmap;
-		while (l-- && vma)
-			vma = vma->vm_next;
-		goto out;
-	}
-
-	if (l != mm->map_count)
-		tail_vma = NULL; /* After gate vma */
-
-out:
-	if (vma)
-		return vma;
-
-	/* End of vmas has been reached */
-	m->version = (tail_vma != NULL)? 0: -1UL;
-	up_read(&mm->mmap_sem);
-	mmput(mm);
-	return tail_vma;
-}
-
-static void vma_stop(struct proc_maps_private *priv, struct vm_area_struct *vma)
-{
-	if (vma && vma != priv->tail_vma) {
-		struct mm_struct *mm = vma->vm_mm;
-		up_read(&mm->mmap_sem);
-		mmput(mm);
-	}
-}
-
-static void *m_next(struct seq_file *m, void *v, loff_t *pos)
-{
-	struct proc_maps_private *priv = m->private;
-	struct vm_area_struct *vma = v;
-	struct vm_area_struct *tail_vma = priv->tail_vma;
-
-	(*pos)++;
-	if (vma && (vma != tail_vma) && vma->vm_next)
-		return vma->vm_next;
-	vma_stop(priv, vma);
-	return (vma != tail_vma)? tail_vma: NULL;
-}
-
-static void m_stop(struct seq_file *m, void *v)
-{
-	struct proc_maps_private *priv = m->private;
-	struct vm_area_struct *vma = v;
-
-	vma_stop(priv, vma);
-	if (priv->task)
-		put_task_struct(priv->task);
-}
-
-static struct seq_operations proc_pid_maps_op = {
-	.start	= m_start,
-	.next	= m_next,
-	.stop	= m_stop,
-	.show	= show_map
-};
-
-static struct seq_operations proc_pid_smaps_op = {
-	.start	= m_start,
-	.next	= m_next,
-	.stop	= m_stop,
-	.show	= show_smap
-};
-
-static int do_maps_open(struct inode *inode, struct file *file,
-			struct seq_operations *ops)
-{
-	struct proc_maps_private *priv;
-	int ret = -ENOMEM;
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (priv) {
-		priv->pid = proc_pid(inode);
-		ret = seq_open(file, ops);
-		if (!ret) {
-			struct seq_file *m = file->private_data;
-			m->private = priv;
-		} else {
-			kfree(priv);
-		}
-	}
-	return ret;
-}
-
-static int maps_open(struct inode *inode, struct file *file)
-{
-	return do_maps_open(inode, file, &proc_pid_maps_op);
-}
-
-const struct file_operations proc_maps_operations = {
-	.open		= maps_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_private,
-};
-
 #ifdef CONFIG_NUMA
 extern int show_numa_map(struct seq_file *m, void *v);
 
@@ -514,14 +526,3 @@ const struct file_operations proc_numa_m
 };
 #endif
 
-static int smaps_open(struct inode *inode, struct file *file)
-{
-	return do_maps_open(inode, file, &proc_pid_smaps_op);
-}
-
-const struct file_operations proc_smaps_operations = {
-	.open		= smaps_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_private,
-};
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-return-length-calculation.patch
maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-end-address-calculation.patch
maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-header-copy-to-userspace.patch
maps2-add-proc-kpagemap-interface.patch
mmaps2-vma-out-of-mem_size_stats.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
maps-pssproportional-set-size-accounting-in-smaps.patch
lib-sortc-optimization.patch
sparse-pointer-use-of-zero-as-null.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
