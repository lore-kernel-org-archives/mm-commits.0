From: akpm@linux-foundation.org
Subject: + restore-madv_dontneed-to-its-original-linux-behaviour.patch added to -mm tree
Date: Fri, 20 Apr 2007 14:03:25 -0700
Message-ID: <200704202103.l3KL3PRm023801@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35095 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767271AbXDTVDp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 17:03:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, a.p.zijlstra@chello.nl, drepper@redhat.com, hugh@veritas.com, mtk-manpages@gmx.net, nickpiggin@yahoo.com.au


The patch titled
     Restore MADV_DONTNEED to its original Linux behaviour
has been added to the -mm tree.  Its filename is
     restore-madv_dontneed-to-its-original-linux-behaviour.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Restore MADV_DONTNEED to its original Linux behaviour
From: Rik van Riel <riel@redhat.com>

Restore MADV_DONTNEED to its original Linux behaviour.  This is still not
the same behaviour as POSIX, but applications may be depending on the Linux
behaviour already.  Besides, glibc catches POSIX_MADV_DONTNEED and makes
sure nothing is done...

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff -puN mm/madvise.c~restore-madv_dontneed-to-its-original-linux-behaviour mm/madvise.c
--- a/mm/madvise.c~restore-madv_dontneed-to-its-original-linux-behaviour
+++ a/mm/madvise.c
@@ -149,7 +149,8 @@ static long madvise_willneed(struct vm_a
  */
 static long madvise_dontneed(struct vm_area_struct * vma,
 			     struct vm_area_struct ** prev,
-			     unsigned long start, unsigned long end)
+			     unsigned long start, unsigned long end,
+			     int behavior)
 {
 	*prev = vma;
 	if (vma->vm_flags & (VM_LOCKED|VM_HUGETLB|VM_PFNMAP))
@@ -161,12 +162,14 @@ static long madvise_dontneed(struct vm_a
 			.last_index = ULONG_MAX,
 		};
 		zap_page_range(vma, start, end - start, &details);
-	} else {
+	} else if (behavior == MADV_FREE) {
 		struct zap_details details = {
 			.madv_free = 1,
 		};
 		zap_page_range(vma, start, end - start, &details);
-	}
+	} else /* behavior == MADV_DONTNEED */
+		zap_page_range(vma, start, end - start, NULL);
+
 	return 0;
 }
 
@@ -238,10 +241,9 @@ madvise_vma(struct vm_area_struct *vma, 
 		error = madvise_willneed(vma, prev, start, end);
 		break;
 
-	/* FIXME: POSIX says that MADV_DONTNEED cannot throw away data. */
 	case MADV_DONTNEED:
 	case MADV_FREE:
-		error = madvise_dontneed(vma, prev, start, end);
+		error = madvise_dontneed(vma, prev, start, end, behavior);
 		break;
 
 	default:
_

Patches currently in -mm which might be from riel@redhat.com are

mm-madvise-avoid-exclusive-mmap_sem.patch
lazy-freeing-of-memory-through-madv_free.patch
lazy-freeing-of-memory-through-madv_free-fix.patch
lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
