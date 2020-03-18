From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-use-ppos-instead-of-m-version.patch added to -mm
 tree
Date: Tue, 17 Mar 2020 19:58:39 -0700
Message-ID: <20200318025839.Xe_B2f9hZ%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726229AbgCRC6l (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 17 Mar 2020 22:58:41 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org, willy@infradead.org


The patch titled
     Subject: proc: use ppos instead of m->version
has been added to the -mm tree.  Its filename is
     proc-use-ppos-instead-of-m-version.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-use-ppos-instead-of-m-version.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-use-ppos-instead-of-m-version.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-improve-dump_page-for-compound-pages.patch
mm-add-pagemaph-to-the-fine-documentation.patch
proc-inline-vma_stop-into-m_stop.patch
proc-remove-m_cache_vma.patch
proc-use-ppos-instead-of-m-version.patch
seq_file-remove-m-version.patch
proc-inline-m_next_vma-into-m_next.patch
