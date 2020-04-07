From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 096/166] proc: inline vma_stop into m_stop
Date: Mon, 06 Apr 2020 20:09:08 -0700
Message-ID: <20200407030908.mNE2D_8Qz%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbgDGDJK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:09:10 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, willy@infradead.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: proc: inline vma_stop into m_stop

Instead of calling vma_stop() from m_start() and m_next(), do its work
in m_stop().

Link: http://lkml.kernel.org/r/20200317193201.9924-1-adobriyan@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

--- a/fs/proc/task_mmu.c~proc-inline-vma_stop-into-m_stop
+++ a/fs/proc/task_mmu.c
@@ -123,15 +123,6 @@ static void release_task_mempolicy(struc
 }
 #endif
 
-static void vma_stop(struct proc_maps_private *priv)
-{
-	struct mm_struct *mm = priv->mm;
-
-	release_task_mempolicy(priv);
-	up_read(&mm->mmap_sem);
-	mmput(mm);
-}
-
 static struct vm_area_struct *
 m_next_vma(struct proc_maps_private *priv, struct vm_area_struct *vma)
 {
@@ -163,11 +154,16 @@ static void *m_start(struct seq_file *m,
 		return ERR_PTR(-ESRCH);
 
 	mm = priv->mm;
-	if (!mm || !mmget_not_zero(mm))
+	if (!mm || !mmget_not_zero(mm)) {
+		put_task_struct(priv->task);
+		priv->task = NULL;
 		return NULL;
+	}
 
 	if (down_read_killable(&mm->mmap_sem)) {
 		mmput(mm);
+		put_task_struct(priv->task);
+		priv->task = NULL;
 		return ERR_PTR(-EINTR);
 	}
 
@@ -195,7 +191,6 @@ static void *m_start(struct seq_file *m,
 	if (pos == mm->map_count && priv->tail_vma)
 		return priv->tail_vma;
 
-	vma_stop(priv);
 	return NULL;
 }
 
@@ -206,21 +201,22 @@ static void *m_next(struct seq_file *m,
 
 	(*pos)++;
 	next = m_next_vma(priv, v);
-	if (!next)
-		vma_stop(priv);
 	return next;
 }
 
 static void m_stop(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
+	struct mm_struct *mm = priv->mm;
 
-	if (!IS_ERR_OR_NULL(v))
-		vma_stop(priv);
-	if (priv->task) {
-		put_task_struct(priv->task);
-		priv->task = NULL;
-	}
+	if (!priv->task)
+		return;
+
+	release_task_mempolicy(priv);
+	up_read(&mm->mmap_sem);
+	mmput(mm);
+	put_task_struct(priv->task);
+	priv->task = NULL;
 }
 
 static int proc_maps_open(struct inode *inode, struct file *file,
_
