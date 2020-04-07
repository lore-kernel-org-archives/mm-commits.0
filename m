From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 098/166] proc: use ppos instead of m->version
Date: Mon, 06 Apr 2020 20:09:14 -0700
Message-ID: <20200407030914.n_79Kob4c%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbgDGDJP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:09:15 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, willy@infradead.org

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
