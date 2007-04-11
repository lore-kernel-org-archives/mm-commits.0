From: akpm@linux-foundation.org
Subject: + maps2-add-proc-pid-pagemap-interface-fix.patch added to -mm tree
Date: Tue, 10 Apr 2007 17:29:38 -0700
Message-ID: <200704110029.l3B0TcIC024146@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53708 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932255AbXDKAa0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 20:30:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com, adobriyan@sw.ru


The patch titled
     maps2-add-proc-pid-pagemap-interface fix
has been added to the -mm tree.  Its filename is
     maps2-add-proc-pid-pagemap-interface-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: maps2-add-proc-pid-pagemap-interface fix
From: Matt Mackall <mpm@selenic.com>

When CONFIG_HIGHPTE is enabled, use double-buffering in pagemap to
avoid calling copy_to_user while preemption is disabled.

Tested on x86 with HIGHPTE with DEBUG_SPINLOCK_SLEEP and
PROVE_LOCKING.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   28 ++++++++++++++++++++++++++--
 1 files changed, 26 insertions(+), 2 deletions(-)

diff -puN fs/proc/task_mmu.c~maps2-add-proc-pid-pagemap-interface-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~maps2-add-proc-pid-pagemap-interface-fix
+++ a/fs/proc/task_mmu.c
@@ -520,6 +520,7 @@ struct pagemapread {
 	struct mm_struct *mm;
 	unsigned long next;
 	unsigned long *buf;
+	pte_t *ptebuf;
 	unsigned long pos;
 	size_t count;
 	int index;
@@ -558,6 +559,14 @@ static int pagemap_pte_range(pmd_t *pmd,
 	int err;
 
 	pte = pte_offset_map(pmd, addr);
+
+#ifdef CONFIG_HIGHPTE
+	/* copy PTE directory to temporary buffer and unmap it */
+	memcpy(pm->ptebuf, pte, PAGE_ALIGN((unsigned long)pte) - (unsigned long)pte);
+	pte_unmap(pte);
+	pte = pm->ptebuf;
+#endif
+
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
 		if (addr < pm->next)
 			continue;
@@ -568,7 +577,11 @@ static int pagemap_pte_range(pmd_t *pmd,
 		if (err)
 			return err;
 	}
+
+#ifndef CONFIG_HIGHPTE
 	pte_unmap(pte - 1);
+#endif
+
 	return 0;
 }
 
@@ -640,10 +653,16 @@ static ssize_t pagemap_read(struct file 
 	if (!page)
 		goto out;
 
+#ifdef CONFIG_HIGHPTE
+	pm.ptebuf = kzalloc(PAGE_SIZE, GFP_USER);
+	if (!pm.ptebuf)
+		goto out_free;
+#endif
+
 	ret = 0;
 	mm = get_task_mm(task);
 	if (!mm)
-		goto out_free;
+		goto out_freepte;
 
 	pm.mm = mm;
 	pm.next = addr;
@@ -666,7 +685,7 @@ static ssize_t pagemap_read(struct file 
 	while (pm.count > 0 && vma) {
 		if (!ptrace_may_attach(task)) {
 			ret = -EIO;
-			goto out;
+			goto out_mm;
 		}
 		vend = min(vma->vm_start - 1, end - 1) + 1;
 		ret = pagemap_fill(&pm, vend);
@@ -685,8 +704,13 @@ static ssize_t pagemap_read(struct file 
 	if (!ret)
 		ret = pm.pos - src;
 
+out_mm:
 	mmput(mm);
+out_freepte:
+#ifdef CONFIG_HIGHPTE
+	kfree(pm.ptebuf);
 out_free:
+#endif
 	kfree(page);
 out:
 	put_task_struct(task);
_

Patches currently in -mm which might be from mpm@selenic.com are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
smaps-add-clear_refs-file-to-clear-reference-cleanup.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-pid-pagemap-interface-fix.patch
maps2-add-proc-kpagemap-interface.patch
slob-handle-slab_panic-flag.patch
