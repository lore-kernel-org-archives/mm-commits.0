From: akpm@linux-foundation.org
Subject: + mm-nommu-find-vma-using-the-sorted-vma-list.patch added to -mm tree
Date: Thu, 31 Mar 2011 11:52:26 -0700
Message-ID: <201103311852.p2VIqRjq021899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759114Ab1CaSwo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Mar 2011 14:52:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, lethal@linux-sh.org


The patch titled
     mm: nommu: find vma using the sorted vma list
has been added to the -mm tree.  Its filename is
     mm-nommu-find-vma-using-the-sorted-vma-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: nommu: find vma using the sorted vma list
From: Namhyung Kim <namhyung@gmail.com>

Now we have the sorted vma list, use it in the find_vma[_exact]() rather
than doing linear search on the rb-tree.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN mm/nommu.c~mm-nommu-find-vma-using-the-sorted-vma-list mm/nommu.c
--- a/mm/nommu.c~mm-nommu-find-vma-using-the-sorted-vma-list
+++ a/mm/nommu.c
@@ -804,17 +804,15 @@ static void delete_vma(struct mm_struct 
 struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
 {
 	struct vm_area_struct *vma;
-	struct rb_node *n = mm->mm_rb.rb_node;
 
 	/* check the cache first */
 	vma = mm->mmap_cache;
 	if (vma && vma->vm_start <= addr && vma->vm_end > addr)
 		return vma;
 
-	/* trawl the tree (there may be multiple mappings in which addr
+	/* trawl the list (there may be multiple mappings in which addr
 	 * resides) */
-	for (n = rb_first(&mm->mm_rb); n; n = rb_next(n)) {
-		vma = rb_entry(n, struct vm_area_struct, vm_rb);
+	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		if (vma->vm_start > addr)
 			return NULL;
 		if (vma->vm_end > addr) {
@@ -854,7 +852,6 @@ static struct vm_area_struct *find_vma_e
 					     unsigned long len)
 {
 	struct vm_area_struct *vma;
-	struct rb_node *n = mm->mm_rb.rb_node;
 	unsigned long end = addr + len;
 
 	/* check the cache first */
@@ -862,10 +859,9 @@ static struct vm_area_struct *find_vma_e
 	if (vma && vma->vm_start == addr && vma->vm_end == end)
 		return vma;
 
-	/* trawl the tree (there may be multiple mappings in which addr
+	/* trawl the list (there may be multiple mappings in which addr
 	 * resides) */
-	for (n = rb_first(&mm->mm_rb); n; n = rb_next(n)) {
-		vma = rb_entry(n, struct vm_area_struct, vm_rb);
+	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		if (vma->vm_start < addr)
 			continue;
 		if (vma->vm_start > addr)
_

Patches currently in -mm which might be from namhyung@gmail.com are

mm-nommu-sort-mm-mmap-list-properly.patch
mm-nommu-sort-mm-mmap-list-properly-fix.patch
mm-nommu-dont-scan-the-vma-list-when-deleting.patch
mm-nommu-find-vma-using-the-sorted-vma-list.patch
mm-nommu-check-the-vma-list-when-unmapping-file-mapped-vma.patch
mm-nommu-fix-a-potential-memory-leak-in-do_mmap_private.patch
mm-nommu-fix-a-compile-warning-in-do_mmap_pgoff.patch

