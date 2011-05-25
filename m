From: akpm@linux-foundation.org
Subject: [merged] mm-nommu-check-the-vma-list-when-unmapping-file-mapped-vma.patch removed from -mm tree
Date: Wed, 25 May 2011 13:27:26 -0700
Message-ID: <201105252025.p4PKPnSl014430@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755634Ab1EYU0b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:26:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namhyung@gmail.com, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     mm: nommu: check the vma list when unmapping file-mapped vma
has been removed from the -mm tree.  Its filename was
     mm-nommu-check-the-vma-list-when-unmapping-file-mapped-vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: nommu: check the vma list when unmapping file-mapped vma
From: Namhyung Kim <namhyung@gmail.com>

Now we have the sorted vma list, use it in do_munmap() to check that we
have an exact match.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/nommu.c~mm-nommu-check-the-vma-list-when-unmapping-file-mapped-vma mm/nommu.c
--- a/mm/nommu.c~mm-nommu-check-the-vma-list-when-unmapping-file-mapped-vma
+++ a/mm/nommu.c
@@ -1635,7 +1635,6 @@ static int shrink_vma(struct mm_struct *
 int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
 {
 	struct vm_area_struct *vma;
-	struct rb_node *rb;
 	unsigned long end = start + len;
 	int ret;
 
@@ -1668,9 +1667,8 @@ int do_munmap(struct mm_struct *mm, unsi
 			}
 			if (end == vma->vm_end)
 				goto erase_whole_vma;
-			rb = rb_next(&vma->vm_rb);
-			vma = rb_entry(rb, struct vm_area_struct, vm_rb);
-		} while (rb);
+			vma = vma->vm_next;
+		} while (vma);
 		kleave(" = -EINVAL [split file]");
 		return -EINVAL;
 	} else {
_

Patches currently in -mm which might be from namhyung@gmail.com are

origin.patch
memcg-mark-init_section_page_cgroup-properly.patch
memcg-fix-off-by-one-when-calculating-swap-cgroup-map-length.patch
memcg-move-page-freeing-code-out-of-lock.patch
maintainers-add-mm-page_cgroupc-into-memcg-subsystem.patch

