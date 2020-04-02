From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 104/155] mmap: remove inline of vm_unmapped_area
Date: Wed, 01 Apr 2020 21:09:10 -0700
Message-ID: <20200402040910.zv04K2rzV%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:32960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726201AbgDBEJN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:09:13 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bp@suse.de, jaewon31.kim@samsung.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz, walken@google.com, willy@infradead.org

From: Jaewon Kim <jaewon31.kim@samsung.com>
Subject: mmap: remove inline of vm_unmapped_area

Patch series "mm: mmap: add mmap trace point", v3.

Create mmap trace file and add trace point of vm_unmapped_area().


This patch (of 2):

In preparation for next patch remove inline of vm_unmapped_area and move
code to mmap.c.  There is no logical change.

Also remove unmapped_area[_topdown] out of mm.h, there is no code
calling to them.

Link: http://lkml.kernel.org/r/20200320055823.27089-2-jaewon31.kim@samsung.com
Signed-off-by: Jaewon Kim <jaewon31.kim@samsung.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   21 +--------------------
 mm/mmap.c          |   20 ++++++++++++++++++--
 2 files changed, 19 insertions(+), 22 deletions(-)

--- a/include/linux/mm.h~mmap-remove-inline-of-vm_unmapped_area
+++ a/include/linux/mm.h
@@ -2530,26 +2530,7 @@ struct vm_unmapped_area_info {
 	unsigned long align_offset;
 };
 
-extern unsigned long unmapped_area(struct vm_unmapped_area_info *info);
-extern unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info);
-
-/*
- * Search for an unmapped address range.
- *
- * We are looking for a range that:
- * - does not intersect with any VMA;
- * - is contained within the [low_limit, high_limit) interval;
- * - is at least the desired size.
- * - satisfies (begin_addr & align_mask) == (align_offset & align_mask)
- */
-static inline unsigned long
-vm_unmapped_area(struct vm_unmapped_area_info *info)
-{
-	if (info->flags & VM_UNMAPPED_AREA_TOPDOWN)
-		return unmapped_area_topdown(info);
-	else
-		return unmapped_area(info);
-}
+extern unsigned long vm_unmapped_area(struct vm_unmapped_area_info *info);
 
 /* truncate.c */
 extern void truncate_inode_pages(struct address_space *, loff_t);
--- a/mm/mmap.c~mmap-remove-inline-of-vm_unmapped_area
+++ a/mm/mmap.c
@@ -1848,7 +1848,7 @@ unacct_error:
 	return error;
 }
 
-unsigned long unmapped_area(struct vm_unmapped_area_info *info)
+static unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 {
 	/*
 	 * We implement the search by looking for an rbtree node that
@@ -1951,7 +1951,7 @@ found:
 	return gap_start;
 }
 
-unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
+static unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
@@ -2050,6 +2050,22 @@ found_highest:
 	return gap_end;
 }
 
+/*
+ * Search for an unmapped address range.
+ *
+ * We are looking for a range that:
+ * - does not intersect with any VMA;
+ * - is contained within the [low_limit, high_limit) interval;
+ * - is at least the desired size.
+ * - satisfies (begin_addr & align_mask) == (align_offset & align_mask)
+ */
+unsigned long vm_unmapped_area(struct vm_unmapped_area_info *info)
+{
+	if (info->flags & VM_UNMAPPED_AREA_TOPDOWN)
+		return unmapped_area_topdown(info);
+	else
+		return unmapped_area(info);
+}
 
 #ifndef arch_get_mmap_end
 #define arch_get_mmap_end(addr)	(TASK_SIZE)
_
