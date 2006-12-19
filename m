From: akpm@osdl.org
Subject: + mm-more-rmap-debugging.patch added to -mm tree
Date: Tue, 19 Dec 2006 12:17:01 -0800
Message-ID: <200612192017.kBJKH1S5009202@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59808 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932942AbWLSURG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Dec 2006 15:17:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nickpiggin@yahoo.com.au, hugh@veritas.com


The patch titled
     mm: more rmpa debugging
has been added to the -mm tree.  Its filename is
     mm-more-rmap-debugging.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: more rmpa debugging
From: Nick Piggin <nickpiggin@yahoo.com.au>

Add more debugging in the rmap code in an attempt to locate to source of
the occasional "mapcount went negative" assertions.

Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/rmap.h |    2 +-
 mm/filemap_xip.c     |    2 +-
 mm/fremap.c          |    2 +-
 mm/memory.c          |    4 ++--
 mm/rmap.c            |   13 ++++++++++---
 5 files changed, 15 insertions(+), 8 deletions(-)

diff -puN include/linux/rmap.h~mm-more-rmap-debugging include/linux/rmap.h
--- a/include/linux/rmap.h~mm-more-rmap-debugging
+++ a/include/linux/rmap.h
@@ -72,7 +72,7 @@ void __anon_vma_link(struct vm_area_stru
 void page_add_anon_rmap(struct page *, struct vm_area_struct *, unsigned long);
 void page_add_new_anon_rmap(struct page *, struct vm_area_struct *, unsigned long);
 void page_add_file_rmap(struct page *);
-void page_remove_rmap(struct page *);
+void page_remove_rmap(struct page *, struct vm_area_struct *);
 
 /**
  * page_dup_rmap - duplicate pte mapping to a page
diff -puN mm/filemap_xip.c~mm-more-rmap-debugging mm/filemap_xip.c
--- a/mm/filemap_xip.c~mm-more-rmap-debugging
+++ a/mm/filemap_xip.c
@@ -189,7 +189,7 @@ __xip_unmap (struct address_space * mapp
 			/* Nuke the page table entry. */
 			flush_cache_page(vma, address, pte_pfn(*pte));
 			pteval = ptep_clear_flush(vma, address, pte);
-			page_remove_rmap(page);
+			page_remove_rmap(page, vma);
 			dec_mm_counter(mm, file_rss);
 			BUG_ON(pte_dirty(pteval));
 			pte_unmap_unlock(pte, ptl);
diff -puN mm/fremap.c~mm-more-rmap-debugging mm/fremap.c
--- a/mm/fremap.c~mm-more-rmap-debugging
+++ a/mm/fremap.c
@@ -33,7 +33,7 @@ static int zap_pte(struct mm_struct *mm,
 		if (page) {
 			if (pte_dirty(pte))
 				set_page_dirty(page);
-			page_remove_rmap(page);
+			page_remove_rmap(page, vma);
 			page_cache_release(page);
 		}
 	} else {
diff -puN mm/memory.c~mm-more-rmap-debugging mm/memory.c
--- a/mm/memory.c~mm-more-rmap-debugging
+++ a/mm/memory.c
@@ -681,7 +681,7 @@ static unsigned long zap_pte_range(struc
 					mark_page_accessed(page);
 				file_rss--;
 			}
-			page_remove_rmap(page);
+			page_remove_rmap(page, vma);
 			tlb_remove_page(tlb, page);
 			continue;
 		}
@@ -1586,7 +1586,7 @@ gotten:
 	page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
 	if (likely(pte_same(*page_table, orig_pte))) {
 		if (old_page) {
-			page_remove_rmap(old_page);
+			page_remove_rmap(old_page, vma);
 			if (!PageAnon(old_page)) {
 				dec_mm_counter(mm, file_rss);
 				inc_mm_counter(mm, anon_rss);
diff -puN mm/rmap.c~mm-more-rmap-debugging mm/rmap.c
--- a/mm/rmap.c~mm-more-rmap-debugging
+++ a/mm/rmap.c
@@ -47,6 +47,7 @@
 #include <linux/rmap.h>
 #include <linux/rcupdate.h>
 #include <linux/module.h>
+#include <linux/kallsyms.h>
 
 #include <asm/tlbflush.h>
 
@@ -567,14 +568,20 @@ void page_add_file_rmap(struct page *pag
  *
  * The caller needs to hold the pte lock.
  */
-void page_remove_rmap(struct page *page)
+void page_remove_rmap(struct page *page, struct vm_area_struct *vma)
 {
 	if (atomic_add_negative(-1, &page->_mapcount)) {
 		if (unlikely(page_mapcount(page) < 0)) {
 			printk (KERN_EMERG "Eeek! page_mapcount(page) went negative! (%d)\n", page_mapcount(page));
+			printk (KERN_EMERG "  page pfn = %lx\n", page_to_pfn(page));
 			printk (KERN_EMERG "  page->flags = %lx\n", page->flags);
 			printk (KERN_EMERG "  page->count = %x\n", page_count(page));
 			printk (KERN_EMERG "  page->mapping = %p\n", page->mapping);
+			print_symbol (KERN_EMERG "  vma->vm_ops = %s\n", (unsigned long)vma->vm_ops);
+			if (vma->vm_ops)
+				print_symbol (KERN_EMERG "  vma->vm_ops->nopage = %s\n", (unsigned long)vma->vm_ops->nopage);
+			if (vma->vm_file && vma->vm_file->f_op)
+				print_symbol (KERN_EMERG "  vma->vm_file->f_op->mmap = %s\n", (unsigned long)vma->vm_file->f_op->mmap);
 			BUG();
 		}
 
@@ -679,7 +686,7 @@ static int try_to_unmap_one(struct page 
 		dec_mm_counter(mm, file_rss);
 
 
-	page_remove_rmap(page);
+	page_remove_rmap(page, vma);
 	page_cache_release(page);
 
 out_unmap:
@@ -769,7 +776,7 @@ static void try_to_unmap_cluster(unsigne
 		if (pte_dirty(pteval))
 			set_page_dirty(page);
 
-		page_remove_rmap(page);
+		page_remove_rmap(page, vma);
 		page_cache_release(page);
 		dec_mm_counter(mm, file_rss);
 		(*mapcount)--;
_

Patches currently in -mm which might be from nickpiggin@yahoo.com.au are

mm-more-rmap-debugging.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
sched2-sched-domain-sysctl.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch

