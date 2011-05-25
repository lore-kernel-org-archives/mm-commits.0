From: akpm@linux-foundation.org
Subject: [merged] mm-nommu-dont-scan-the-vma-list-when-deleting.patch removed from -mm tree
Date: Wed, 25 May 2011 13:27:22 -0700
Message-ID: <201105252025.p4PKPjtS014424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755622Ab1EYU00 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:26:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namhyung@gmail.com, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     mm: nommu: don't scan the vma list when deleting
has been removed from the -mm tree.  Its filename was
     mm-nommu-dont-scan-the-vma-list-when-deleting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: nommu: don't scan the vma list when deleting
From: Namhyung Kim <namhyung@gmail.com>

Since commit 297c5eee3724 ("mm: make the vma list be doubly linked") made
it a doubly linked list, we don't need to scan the list when deleting
@vma.

And the original code didn't update the prev pointer. Fix it too.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN mm/nommu.c~mm-nommu-dont-scan-the-vma-list-when-deleting mm/nommu.c
--- a/mm/nommu.c~mm-nommu-dont-scan-the-vma-list-when-deleting
+++ a/mm/nommu.c
@@ -746,7 +746,6 @@ static void add_vma_to_mm(struct mm_stru
  */
 static void delete_vma_from_mm(struct vm_area_struct *vma)
 {
-	struct vm_area_struct **pp;
 	struct address_space *mapping;
 	struct mm_struct *mm = vma->vm_mm;
 
@@ -769,12 +768,14 @@ static void delete_vma_from_mm(struct vm
 
 	/* remove from the MM's tree and list */
 	rb_erase(&vma->vm_rb, &mm->mm_rb);
-	for (pp = &mm->mmap; *pp; pp = &(*pp)->vm_next) {
-		if (*pp == vma) {
-			*pp = vma->vm_next;
-			break;
-		}
-	}
+
+	if (vma->vm_prev)
+		vma->vm_prev->vm_next = vma->vm_next;
+	else
+		mm->mmap = vma->vm_next;
+
+	if (vma->vm_next)
+		vma->vm_next->vm_prev = vma->vm_prev;
 
 	vma->vm_mm = NULL;
 }
_

Patches currently in -mm which might be from namhyung@gmail.com are

origin.patch
memcg-mark-init_section_page_cgroup-properly.patch
memcg-fix-off-by-one-when-calculating-swap-cgroup-map-length.patch
memcg-move-page-freeing-code-out-of-lock.patch
maintainers-add-mm-page_cgroupc-into-memcg-subsystem.patch

