From: akpm@linux-foundation.org
Subject: [merged] nommu-add-page-alignment-to-mmap.patch removed from -mm tree
Date: Wed, 25 May 2011 13:30:39 -0700
Message-ID: <201105252029.p4PKT3Ls014811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932667Ab1EYUtU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:49:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lliubbo@gmail.com, dhowells@redhat.com, geert@linux-m68k.org, gerg@snapgear.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     nommu: add page alignment to mmap
has been removed from the -mm tree.  Its filename was
     nommu-add-page-alignment-to-mmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: add page alignment to mmap
From: Bob Liu <lliubbo@gmail.com>

Currently on nommu arch mmap(),mremap() and munmap() doesn't do
page_align() which isn't consist with mmu arch and cause some issues.

First, some drivers' mmap() function depends on vma->vm_end - vma->start
is page aligned which is true on mmu arch but not on nommu.  eg: uvc
camera driver.

Second munmap() may return -EINVAL[split file] error in cases when end is
not page aligned(passed into from userspace) but vma->vm_end is aligned
dure to split or driver's mmap() ops.

Add page alignment to fix those issues.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff -puN mm/nommu.c~nommu-add-page-alignment-to-mmap mm/nommu.c
--- a/mm/nommu.c~nommu-add-page-alignment-to-mmap
+++ a/mm/nommu.c
@@ -1124,7 +1124,7 @@ static int do_mmap_private(struct vm_are
 			   unsigned long capabilities)
 {
 	struct page *pages;
-	unsigned long total, point, n, rlen;
+	unsigned long total, point, n;
 	void *base;
 	int ret, order;
 
@@ -1148,13 +1148,12 @@ static int do_mmap_private(struct vm_are
 		 * make a private copy of the data and map that instead */
 	}
 
-	rlen = PAGE_ALIGN(len);
 
 	/* allocate some memory to hold the mapping
 	 * - note that this may not return a page-aligned address if the object
 	 *   we're allocating is smaller than a page
 	 */
-	order = get_order(rlen);
+	order = get_order(len);
 	kdebug("alloc order %d for %lx", order, len);
 
 	pages = alloc_pages(GFP_KERNEL, order);
@@ -1164,7 +1163,7 @@ static int do_mmap_private(struct vm_are
 	total = 1 << order;
 	atomic_long_add(total, &mmap_pages_allocated);
 
-	point = rlen >> PAGE_SHIFT;
+	point = len >> PAGE_SHIFT;
 
 	/* we allocated a power-of-2 sized page set, so we may want to trim off
 	 * the excess */
@@ -1186,7 +1185,7 @@ static int do_mmap_private(struct vm_are
 	base = page_address(pages);
 	region->vm_flags = vma->vm_flags |= VM_MAPPED_COPY;
 	region->vm_start = (unsigned long) base;
-	region->vm_end   = region->vm_start + rlen;
+	region->vm_end   = region->vm_start + len;
 	region->vm_top   = region->vm_start + (total << PAGE_SHIFT);
 
 	vma->vm_start = region->vm_start;
@@ -1202,15 +1201,15 @@ static int do_mmap_private(struct vm_are
 
 		old_fs = get_fs();
 		set_fs(KERNEL_DS);
-		ret = vma->vm_file->f_op->read(vma->vm_file, base, rlen, &fpos);
+		ret = vma->vm_file->f_op->read(vma->vm_file, base, len, &fpos);
 		set_fs(old_fs);
 
 		if (ret < 0)
 			goto error_free;
 
 		/* clear the last little bit */
-		if (ret < rlen)
-			memset(base + ret, 0, rlen - ret);
+		if (ret < len)
+			memset(base + ret, 0, len - ret);
 
 	}
 
@@ -1260,6 +1259,7 @@ unsigned long do_mmap_pgoff(struct file 
 
 	/* we ignore the address hint */
 	addr = 0;
+	len = PAGE_ALIGN(len);
 
 	/* we've determined that we can make the mapping, now translate what we
 	 * now know into VMA flags */
@@ -1636,14 +1636,17 @@ static int shrink_vma(struct mm_struct *
 int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
 {
 	struct vm_area_struct *vma;
-	unsigned long end = start + len;
+	unsigned long end;
 	int ret;
 
 	kenter(",%lx,%zx", start, len);
 
+	len = PAGE_ALIGN(len);
 	if (len == 0)
 		return -EINVAL;
 
+	end = start + len;
+
 	/* find the first potentially overlapping VMA */
 	vma = find_vma(mm, start);
 	if (!vma) {
@@ -1763,6 +1766,8 @@ unsigned long do_mremap(unsigned long ad
 	struct vm_area_struct *vma;
 
 	/* insanity checks first */
+	old_len = PAGE_ALIGN(old_len);
+	new_len = PAGE_ALIGN(new_len);
 	if (old_len == 0 || new_len == 0)
 		return (unsigned long) -EINVAL;
 
_

Patches currently in -mm which might be from lliubbo@gmail.com are

origin.patch

