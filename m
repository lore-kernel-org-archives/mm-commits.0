From: akpm@linux-foundation.org
Subject: [merged] mm-mmap-check-for-rlimit_as-before-unmapping.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:49:32 -0700
Message-ID: <20130430184932.885FA5A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:56533 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434Ab3D3Std (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:49:33 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so85059ggc.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:49:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chrubis@suse.cz, liwanp@linux.vnet.ibm.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: check for RLIMIT_AS before unmapping
has been removed from the -mm tree.  Its filename was
     mm-mmap-check-for-rlimit_as-before-unmapping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyril Hrubis <chrubis@suse.cz>
Subject: mm/mmap: check for RLIMIT_AS before unmapping

Fix a corner case for MAP_FIXED when requested mapping length is larger
than rlimit for virtual memory.  In such case any overlapping mappings are
unmapped before we check for the limit and return ENOMEM.

The check is moved before the loop that unmaps overlapping parts of
existing mappings.  When we are about to hit the limit (currently mapped
pages + len > limit) we scan for overlapping pages and check again
accounting for them.

This fixes situation when userspace program expects that the previous
mappings are preserved after the mmap() syscall has returned with error. 
(POSIX clearly states that successfull mapping shall replace any previous
mappings.)

This corner case was found and can be tested with LTP testcase:

testcases/open_posix_testsuite/conformance/interfaces/mmap/24-2.c

In this case the mmap, which is clearly over current limit, unmaps dynamic
libraries and the testcase segfaults right after returning into userspace.

I've also looked at the second instance of the unmapping loop in the
do_brk().  The do_brk() is called from brk() syscall and from vm_brk(). 
The brk() syscall checks for overlapping mappings and bails out when there
are any (so it can't be triggered from the brk syscall).  The vm_brk() is
called only from binmft handlers so it shouldn't be triggered unless
binmft handler created overlapping mappings.

Signed-off-by: Cyril Hrubis <chrubis@suse.cz>
Reviewed-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 4 deletions(-)

diff -puN mm/mmap.c~mm-mmap-check-for-rlimit_as-before-unmapping mm/mmap.c
--- a/mm/mmap.c~mm-mmap-check-for-rlimit_as-before-unmapping
+++ a/mm/mmap.c
@@ -6,6 +6,7 @@
  * Address space accounting code	<alan@lxorguk.ukuu.org.uk>
  */
 
+#include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/backing-dev.h>
 #include <linux/mm.h>
@@ -550,6 +551,34 @@ static int find_vma_links(struct mm_stru
 	return 0;
 }
 
+static unsigned long count_vma_pages_range(struct mm_struct *mm,
+		unsigned long addr, unsigned long end)
+{
+	unsigned long nr_pages = 0;
+	struct vm_area_struct *vma;
+
+	/* Find first overlaping mapping */
+	vma = find_vma_intersection(mm, addr, end);
+	if (!vma)
+		return 0;
+
+	nr_pages = (min(end, vma->vm_end) -
+		max(addr, vma->vm_start)) >> PAGE_SHIFT;
+
+	/* Iterate over the rest of the overlaps */
+	for (vma = vma->vm_next; vma; vma = vma->vm_next) {
+		unsigned long overlap_len;
+
+		if (vma->vm_start > end)
+			break;
+
+		overlap_len = min(end, vma->vm_end) - vma->vm_start;
+		nr_pages += overlap_len >> PAGE_SHIFT;
+	}
+
+	return nr_pages;
+}
+
 void __vma_link_rb(struct mm_struct *mm, struct vm_area_struct *vma,
 		struct rb_node **rb_link, struct rb_node *rb_parent)
 {
@@ -1442,6 +1471,23 @@ unsigned long mmap_region(struct file *f
 	unsigned long charged = 0;
 	struct inode *inode =  file ? file_inode(file) : NULL;
 
+	/* Check against address space limit. */
+	if (!may_expand_vm(mm, len >> PAGE_SHIFT)) {
+		unsigned long nr_pages;
+
+		/*
+		 * MAP_FIXED may remove pages of mappings that intersects with
+		 * requested mapping. Account for the pages it would unmap.
+		 */
+		if (!(vm_flags & MAP_FIXED))
+			return -ENOMEM;
+
+		nr_pages = count_vma_pages_range(mm, addr, addr + len);
+
+		if (!may_expand_vm(mm, (len >> PAGE_SHIFT) - nr_pages))
+			return -ENOMEM;
+	}
+
 	/* Clear old maps */
 	error = -ENOMEM;
 munmap_back:
@@ -1451,10 +1497,6 @@ munmap_back:
 		goto munmap_back;
 	}
 
-	/* Check against address space limit. */
-	if (!may_expand_vm(mm, len >> PAGE_SHIFT))
-		return -ENOMEM;
