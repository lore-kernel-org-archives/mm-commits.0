From: akpm@linux-foundation.org
Subject: [merged] mm-nommu-find-vma-using-the-sorted-vma-list.patch removed from -mm tree
Date: Wed, 25 May 2011 13:27:24 -0700
Message-ID: <201105252025.p4PKPloO014427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932583Ab1EYUtR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:49:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namhyung@gmail.com, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     mm: nommu: find vma using the sorted vma list
has been removed from the -mm tree.  Its filename was
     mm-nommu-find-vma-using-the-sorted-vma-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
memcg-mark-init_section_page_cgroup-properly.patch
memcg-fix-off-by-one-when-calculating-swap-cgroup-map-length.patch
memcg-move-page-freeing-code-out-of-lock.patch
maintainers-add-mm-page_cgroupc-into-memcg-subsystem.patch

