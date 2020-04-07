From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 097/166] proc: remove m_cache_vma
Date: Mon, 06 Apr 2020 20:09:11 -0700
Message-ID: <20200407030911.tCsV7JUV0%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbgDGDJM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:09:12 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, willy@infradead.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: proc: remove m_cache_vma

Instead of setting m->version in the show method, set it in m_next(),
where it should be.  Also remove the fallback code for failing to find a
vma, or version being zero.

Link: http://lkml.kernel.org/r/20200317193201.9924-2-adobriyan@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   38 ++++++--------------------------------
 1 file changed, 6 insertions(+), 32 deletions(-)

--- a/fs/proc/task_mmu.c~proc-remove-m_cache_vma
+++ a/fs/proc/task_mmu.c
@@ -131,21 +131,14 @@ m_next_vma(struct proc_maps_private *pri
 	return vma->vm_next ?: priv->tail_vma;
 }
 
-static void m_cache_vma(struct seq_file *m, struct vm_area_struct *vma)
-{
-	if (m->count < m->size)	/* vma is copied successfully */
-		m->version = m_next_vma(m->private, vma) ? vma->vm_end : -1UL;
-}
-
 static void *m_start(struct seq_file *m, loff_t *ppos)
 {
 	struct proc_maps_private *priv = m->private;
 	unsigned long last_addr = m->version;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
-	unsigned int pos = *ppos;
 
-	/* See m_cache_vma(). Zero at the start or after lseek. */
+	/* See m_next(). Zero at the start or after lseek. */
 	if (last_addr == -1UL)
 		return NULL;
 
@@ -170,28 +163,11 @@ static void *m_start(struct seq_file *m,
 	hold_task_mempolicy(priv);
 	priv->tail_vma = get_gate_vma(mm);
 
-	if (last_addr) {
-		vma = find_vma(mm, last_addr - 1);
-		if (vma && vma->vm_start <= last_addr)
-			vma = m_next_vma(priv, vma);
-		if (vma)
-			return vma;
-	}
-
-	m->version = 0;
-	if (pos < mm->map_count) {
-		for (vma = mm->mmap; pos; pos--) {
-			m->version = vma->vm_start;
-			vma = vma->vm_next;
-		}
+	vma = find_vma(mm, last_addr);
+	if (vma)
 		return vma;
-	}
-
-	/* we do not bother to update m->version in this case */
-	if (pos == mm->map_count && priv->tail_vma)
-		return priv->tail_vma;
 
-	return NULL;
+	return priv->tail_vma;
 }
 
 static void *m_next(struct seq_file *m, void *v, loff_t *pos)
@@ -201,6 +177,8 @@ static void *m_next(struct seq_file *m,
 
 	(*pos)++;
 	next = m_next_vma(priv, v);
+	m->version = next ? next->vm_start : -1UL;
+
 	return next;
 }
 
@@ -359,7 +337,6 @@ done:
 static int show_map(struct seq_file *m, void *v)
 {
 	show_map_vma(m, v);
-	m_cache_vma(m, v);
 	return 0;
 }
 
@@ -843,8 +820,6 @@ static int show_smap(struct seq_file *m,
 		seq_printf(m, "ProtectionKey:  %8u\n", vma_pkey(vma));
 	show_smap_vma_flags(m, vma);
 
-	m_cache_vma(m, vma);
