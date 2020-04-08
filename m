From: akpm@linux-foundation.org
Subject: [merged] proc-use-ppos-instead-of-m-version.patch removed
 from -mm tree
Date: Tue, 07 Apr 2020 19:00:19 -0700
Message-ID: <20200408020019.u6jUPQzRc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726549AbgDHCAU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:00:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org, willy@infradead.org


The patch titled
     Subject: proc: use ppos instead of m->version
has been removed from the -mm tree.  Its filename was
     proc-use-ppos-instead-of-m-version.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: proc: use ppos instead of m->version

The ppos is a private cursor, just like m->version.  Use the canonical
cursor, not a special one.

Link: http://lkml.kernel.org/r/20200317193201.9924-3-adobriyan@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/proc/task_mmu.c~proc-use-ppos-instead-of-m-version
+++ a/fs/proc/task_mmu.c
@@ -134,7 +134,7 @@ m_next_vma(struct proc_maps_private *pri
 static void *m_start(struct seq_file *m, loff_t *ppos)
 {
 	struct proc_maps_private *priv = m->private;
-	unsigned long last_addr = m->version;
+	unsigned long last_addr = *ppos;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 
@@ -170,14 +170,13 @@ static void *m_start(struct seq_file *m,
 	return priv->tail_vma;
 }
 
-static void *m_next(struct seq_file *m, void *v, loff_t *pos)
+static void *m_next(struct seq_file *m, void *v, loff_t *ppos)
 {
 	struct proc_maps_private *priv = m->private;
 	struct vm_area_struct *next;
 
-	(*pos)++;
 	next = m_next_vma(priv, v);
-	m->version = next ? next->vm_start : -1UL;
+	*ppos = next ? next->vm_start : -1UL;
 
 	return next;
 }
_

Patches currently in -mm which might be from willy@infradead.org are
