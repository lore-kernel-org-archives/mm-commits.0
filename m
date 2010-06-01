From: akpm@linux-foundation.org
Subject: + mm-rename-anon_vma_lock-to-vma_lock_anon_vma.patch added to -mm tree
Date: Tue, 01 Jun 2010 15:10:18 -0700
Message-ID: <201006012210.o51MAI3f021796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753689Ab0FAWKh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jun 2010 18:10:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, lwoodman@redhat.com, mel@csn.ul.ie, minchan.kim@gmail.com, torvalds@linux-foundation.org


The patch titled
     mm: rename anon_vma_lock to vma_lock_anon_vma
has been added to the -mm tree.  Its filename is
     mm-rename-anon_vma_lock-to-vma_lock_anon_vma.patch

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
Subject: mm: rename anon_vma_lock to vma_lock_anon_vma
From: Rik van Riel <riel@redhat.com>

Rename anon_vma_lock to vma_lock_anon_vma.  This matches the naming style
used in page_lock_anon_vma and will come in really handy further down in
this patch series.

Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Tested-by: Larry Woodman <lwoodman@redhat.com>
Acked-by: Larry Woodman <lwoodman@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    4 ++--
 mm/mmap.c            |   14 +++++++-------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN include/linux/rmap.h~mm-rename-anon_vma_lock-to-vma_lock_anon_vma include/linux/rmap.h
--- a/include/linux/rmap.h~mm-rename-anon_vma_lock-to-vma_lock_anon_vma
+++ a/include/linux/rmap.h
@@ -99,14 +99,14 @@ static inline struct anon_vma *page_anon
 	return page_rmapping(page);
 }
 
-static inline void anon_vma_lock(struct vm_area_struct *vma)
+static inline void vma_lock_anon_vma(struct vm_area_struct *vma)
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
 	if (anon_vma)
 		spin_lock(&anon_vma->lock);
 }
 
-static inline void anon_vma_unlock(struct vm_area_struct *vma)
+static inline void vma_unlock_anon_vma(struct vm_area_struct *vma)
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
 	if (anon_vma)
diff -puN mm/mmap.c~mm-rename-anon_vma_lock-to-vma_lock_anon_vma mm/mmap.c
--- a/mm/mmap.c~mm-rename-anon_vma_lock-to-vma_lock_anon_vma
+++ a/mm/mmap.c
@@ -452,12 +452,12 @@ static void vma_link(struct mm_struct *m
 		spin_lock(&mapping->i_mmap_lock);
 		vma->vm_truncate_count = mapping->truncate_count;
 	}
-	anon_vma_lock(vma);
+	vma_lock_anon_vma(vma);
 
 	__vma_link(mm, vma, prev, rb_link, rb_parent);
 	__vma_link_file(vma);
 
-	anon_vma_unlock(vma);
+	vma_unlock_anon_vma(vma);
 	if (mapping)
 		spin_unlock(&mapping->i_mmap_lock);
 
@@ -1710,7 +1710,7 @@ int expand_upwards(struct vm_area_struct
 	 */
 	if (unlikely(anon_vma_prepare(vma)))
 		return -ENOMEM;
-	anon_vma_lock(vma);
+	vma_lock_anon_vma(vma);
 
 	/*
 	 * vma->vm_start/vm_end cannot change under us because the caller
@@ -1721,7 +1721,7 @@ int expand_upwards(struct vm_area_struct
 	if (address < PAGE_ALIGN(address+4))
 		address = PAGE_ALIGN(address+4);
 	else {
-		anon_vma_unlock(vma);
+		vma_unlock_anon_vma(vma);
 		return -ENOMEM;
 	}
 	error = 0;
@@ -1737,7 +1737,7 @@ int expand_upwards(struct vm_area_struct
 		if (!error)
 			vma->vm_end = address;
 	}
-	anon_vma_unlock(vma);
+	vma_unlock_anon_vma(vma);
 	return error;
 }
 #endif /* CONFIG_STACK_GROWSUP || CONFIG_IA64 */
@@ -1762,7 +1762,7 @@ static int expand_downwards(struct vm_ar
 	if (error)
 		return error;
 
-	anon_vma_lock(vma);
+	vma_lock_anon_vma(vma);
 
 	/*
 	 * vma->vm_start/vm_end cannot change under us because the caller
@@ -1783,7 +1783,7 @@ static int expand_downwards(struct vm_ar
 			vma->vm_pgoff -= grow;
 		}
 	}
-	anon_vma_unlock(vma);
+	vma_unlock_anon_vma(vma);
 	return error;
 }
 
_

Patches currently in -mm which might be from riel@redhat.com are

mm-revalidate-anon_vma-in-page_lock_anon_vma.patch
mm-rename-anon_vma_lock-to-vma_lock_anon_vma.patch
mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function.patch
mm-track-the-root-oldest-anon_vma.patch
mm-track-the-root-oldest-anon_vma-fix.patch
mm-always-lock-the-root-oldest-anon_vma.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root.patch

