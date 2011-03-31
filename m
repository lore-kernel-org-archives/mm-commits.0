From: akpm@linux-foundation.org
Subject: + mm-nommu-check-the-vma-list-when-unmapping-file-mapped-vma.patch added to -mm tree
Date: Thu, 31 Mar 2011 11:52:28 -0700
Message-ID: <201103311852.p2VIqTKO021903@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759135Ab1CaSwp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Mar 2011 14:52:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, lethal@linux-sh.org


The patch titled
     mm: nommu: check the vma list when unmapping file-mapped vma
has been added to the -mm tree.  Its filename is
     mm-nommu-check-the-vma-list-when-unmapping-file-mapped-vma.patch

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

mm-nommu-sort-mm-mmap-list-properly.patch
mm-nommu-sort-mm-mmap-list-properly-fix.patch
mm-nommu-dont-scan-the-vma-list-when-deleting.patch
mm-nommu-find-vma-using-the-sorted-vma-list.patch
mm-nommu-check-the-vma-list-when-unmapping-file-mapped-vma.patch
mm-nommu-fix-a-potential-memory-leak-in-do_mmap_private.patch
mm-nommu-fix-a-compile-warning-in-do_mmap_pgoff.patch

