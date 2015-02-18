From: akpm@linux-foundation.org
Subject: + mm-move-mm_populate-related-code-to-mm-gupc.patch added to -mm
 tree
Date: Wed, 18 Feb 2015 12:55:56 -0800
Message-ID: <54e4fc5c.pivITH6tpBbYSLI6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbbBRUz5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 15:55:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, riel@redhat.com, rientjes@google.com, torvalds@linux-foundation.org, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move mm_populate()-related code to mm/gup.c
has been added to the -mm tree.  Its filename is
     mm-move-mm_populate-related-code-to-mm-gupc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-mm_populate-related-code-to-mm-gupc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-mm_populate-related-code-to-mm-gupc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: move mm_populate()-related code to mm/gup.c

It's odd that we have populate_vma_page_range() and __mm_populate() in
mm/mlock.c.  It's implementation of generic memory population and mlocking
is one of possible side effect, if VM_LOCKED is set.

__get_user_pages() is core of the implementation.  Let's move the code
into mm/gup.c.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c   |  118 +++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/mlock.c |  118 ---------------------------------------------------
 2 files changed, 118 insertions(+), 118 deletions(-)

diff -puN mm/gup.c~mm-move-mm_populate-related-code-to-mm-gupc mm/gup.c
--- a/mm/gup.c~mm-move-mm_populate-related-code-to-mm-gupc
+++ a/mm/gup.c
@@ -819,6 +819,124 @@ long get_user_pages(struct task_struct *
 EXPORT_SYMBOL(get_user_pages);
 
 /**
+ * populate_vma_page_range() -  populate a range of pages in the vma.
+ * @vma:   target vma
+ * @start: start address
+ * @end:   end address
+ * @nonblocking:
+ *
+ * This takes care of mlocking the pages too if VM_LOCKED is set.
+ *
+ * return 0 on success, negative error code on error.
+ *
+ * vma->vm_mm->mmap_sem must be held.
+ *
+ * If @nonblocking is NULL, it may be held for read or write and will
+ * be unperturbed.
+ *
+ * If @nonblocking is non-NULL, it must held for read only and may be
+ * released.  If it's released, *@nonblocking will be set to 0.
+ */
+long populate_vma_page_range(struct vm_area_struct *vma,
+		unsigned long start, unsigned long end, int *nonblocking)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long nr_pages = (end - start) / PAGE_SIZE;
+	int gup_flags;
+
+	VM_BUG_ON(start & ~PAGE_MASK);
+	VM_BUG_ON(end   & ~PAGE_MASK);
+	VM_BUG_ON_VMA(start < vma->vm_start, vma);
+	VM_BUG_ON_VMA(end   > vma->vm_end, vma);
+	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_sem), mm);
+
+	gup_flags = FOLL_TOUCH | FOLL_POPULATE;
+	/*
+	 * We want to touch writable mappings with a write fault in order
+	 * to break COW, except for shared mappings because these don't COW
+	 * and we would not want to dirty them for nothing.
+	 */
+	if ((vma->vm_flags & (VM_WRITE | VM_SHARED)) == VM_WRITE)
+		gup_flags |= FOLL_WRITE;
+
+	/*
+	 * We want mlock to succeed for regions that have any permissions
+	 * other than PROT_NONE.
+	 */
+	if (vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC))
+		gup_flags |= FOLL_FORCE;
+
+	/*
+	 * We made sure addr is within a VMA, so the following will
+	 * not result in a stack expansion that recurses back here.
+	 */
+	return __get_user_pages(current, mm, start, nr_pages, gup_flags,
+				NULL, NULL, nonblocking);
+}
+
+/*
+ * __mm_populate - populate and/or mlock pages within a range of address space.
+ *
+ * This is used to implement mlock() and the MAP_POPULATE / MAP_LOCKED mmap
+ * flags. VMAs must be already marked with the desired vm_flags, and
+ * mmap_sem must not be held.
+ */
+int __mm_populate(unsigned long start, unsigned long len, int ignore_errors)
+{
+	struct mm_struct *mm = current->mm;
+	unsigned long end, nstart, nend;
+	struct vm_area_struct *vma = NULL;
+	int locked = 0;
+	long ret = 0;
+
+	VM_BUG_ON(start & ~PAGE_MASK);
+	VM_BUG_ON(len != PAGE_ALIGN(len));
+	end = start + len;
+
+	for (nstart = start; nstart < end; nstart = nend) {
+		/*
+		 * We want to fault in pages for [nstart; end) address range.
+		 * Find first corresponding VMA.
+		 */
+		if (!locked) {
+			locked = 1;
+			down_read(&mm->mmap_sem);
+			vma = find_vma(mm, nstart);
+		} else if (nstart >= vma->vm_end)
+			vma = vma->vm_next;
+		if (!vma || vma->vm_start >= end)
+			break;
+		/*
+		 * Set [nstart; nend) to intersection of desired address
+		 * range with the first VMA. Also, skip undesirable VMA types.
+		 */
+		nend = min(end, vma->vm_end);
+		if (vma->vm_flags & (VM_IO | VM_PFNMAP))
+			continue;
+		if (nstart < vma->vm_start)
+			nstart = vma->vm_start;
+		/*
+		 * Now fault in a range of pages. populate_vma_page_range()
+		 * double checks the vma flags, so that it won't mlock pages
+		 * if the vma was already munlocked.
+		 */
+		ret = populate_vma_page_range(vma, nstart, nend, &locked);
+		if (ret < 0) {
+			if (ignore_errors) {
+				ret = 0;
+				continue;	/* continue at next VMA */
+			}
+			break;
+		}
+		nend = nstart + ret * PAGE_SIZE;
+		ret = 0;
+	}
+	if (locked)
+		up_read(&mm->mmap_sem);
+	return ret;	/* 0 or negative error code */
+}
+
+/**
  * get_dump_page() - pin user page in memory while writing it to core dump
  * @addr: user address
  *
diff -puN mm/mlock.c~mm-move-mm_populate-related-code-to-mm-gupc mm/mlock.c
--- a/mm/mlock.c~mm-move-mm_populate-related-code-to-mm-gupc
+++ a/mm/mlock.c
@@ -205,62 +205,6 @@ out:
 	return nr_pages - 1;
 }
 
-/**
- * populate_vma_page_range() -  populate a range of pages in the vma.
- * @vma:   target vma
- * @start: start address
- * @end:   end address
- * @nonblocking:
- *
- * This takes care of mlocking the pages too if VM_LOCKED is set.
- *
- * return 0 on success, negative error code on error.
- *
- * vma->vm_mm->mmap_sem must be held.
- *
- * If @nonblocking is NULL, it may be held for read or write and will
- * be unperturbed.
- *
- * If @nonblocking is non-NULL, it must held for read only and may be
- * released.  If it's released, *@nonblocking will be set to 0.
- */
-long populate_vma_page_range(struct vm_area_struct *vma,
-		unsigned long start, unsigned long end, int *nonblocking)
-{
-	struct mm_struct *mm = vma->vm_mm;
-	unsigned long nr_pages = (end - start) / PAGE_SIZE;
-	int gup_flags;
-
-	VM_BUG_ON(start & ~PAGE_MASK);
-	VM_BUG_ON(end   & ~PAGE_MASK);
-	VM_BUG_ON_VMA(start < vma->vm_start, vma);
-	VM_BUG_ON_VMA(end   > vma->vm_end, vma);
-	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_sem), mm);
-
-	gup_flags = FOLL_TOUCH | FOLL_POPULATE;
-	/*
-	 * We want to touch writable mappings with a write fault in order
-	 * to break COW, except for shared mappings because these don't COW
-	 * and we would not want to dirty them for nothing.
-	 */
-	if ((vma->vm_flags & (VM_WRITE | VM_SHARED)) == VM_WRITE)
-		gup_flags |= FOLL_WRITE;
-
-	/*
-	 * We want mlock to succeed for regions that have any permissions
-	 * other than PROT_NONE.
-	 */
-	if (vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC))
-		gup_flags |= FOLL_FORCE;
-
-	/*
-	 * We made sure addr is within a VMA, so the following will
-	 * not result in a stack expansion that recurses back here.
-	 */
-	return __get_user_pages(current, mm, start, nr_pages, gup_flags,
-				NULL, NULL, nonblocking);
-}
-
 /*
  * convert get_user_pages() return value to posix mlock() error
  */
@@ -660,68 +604,6 @@ static int do_mlock(unsigned long start,
 	return error;
 }
 
-/*
- * __mm_populate - populate and/or mlock pages within a range of address space.
- *
- * This is used to implement mlock() and the MAP_POPULATE / MAP_LOCKED mmap
- * flags. VMAs must be already marked with the desired vm_flags, and
- * mmap_sem must not be held.
- */
-int __mm_populate(unsigned long start, unsigned long len, int ignore_errors)
-{
-	struct mm_struct *mm = current->mm;
-	unsigned long end, nstart, nend;
-	struct vm_area_struct *vma = NULL;
-	int locked = 0;
-	long ret = 0;
-
-	VM_BUG_ON(start & ~PAGE_MASK);
-	VM_BUG_ON(len != PAGE_ALIGN(len));
-	end = start + len;
-
-	for (nstart = start; nstart < end; nstart = nend) {
-		/*
-		 * We want to fault in pages for [nstart; end) address range.
-		 * Find first corresponding VMA.
-		 */
-		if (!locked) {
-			locked = 1;
-			down_read(&mm->mmap_sem);
-			vma = find_vma(mm, nstart);
-		} else if (nstart >= vma->vm_end)
-			vma = vma->vm_next;
-		if (!vma || vma->vm_start >= end)
-			break;
-		/*
-		 * Set [nstart; nend) to intersection of desired address
-		 * range with the first VMA. Also, skip undesirable VMA types.
-		 */
-		nend = min(end, vma->vm_end);
-		if (vma->vm_flags & (VM_IO | VM_PFNMAP))
-			continue;
-		if (nstart < vma->vm_start)
-			nstart = vma->vm_start;
-		/*
-		 * Now fault in a range of pages. populate_vma_page_range()
-		 * double checks the vma flags, so that it won't mlock pages
-		 * if the vma was already munlocked.
-		 */
-		ret = populate_vma_page_range(vma, nstart, nend, &locked);
-		if (ret < 0) {
-			if (ignore_errors) {
-				ret = 0;
-				continue;	/* continue at next VMA */
-			}
-			break;
-		}
-		nend = nstart + ret * PAGE_SIZE;
-		ret = 0;
-	}
-	if (locked)
-		up_read(&mm->mmap_sem);
-	return ret;	/* 0 or negative error code */
-}
