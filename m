From: akpm@linux-foundation.org
Subject: +
 userfaultfd-non-cooperative-add-madvise-event-for-madv_free-request.patch
 added to -mm tree
Date: Mon, 19 Jun 2017 15:35:20 -0700
Message-ID: <594851a8.yHlbJCp8nAvnOQgl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57282 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751882AbdFSWfV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2017 18:35:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, aarcange@redhat.com, hillf.zj@alibaba-inc.com, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: add madvise() event for MADV_FREE request
has been added to the -mm tree.  Its filename is
     userfaultfd-non-cooperative-add-madvise-event-for-madv_free-request.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-non-cooperative-add-madvise-event-for-madv_free-request.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-non-cooperative-add-madvise-event-for-madv_free-request.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: non-cooperative: add madvise() event for MADV_FREE request

MADV_FREE is identical to MADV_DONTNEED from the point of view of uffd
monitor.  The monitor has to stop handling #PF events in the range being
freed.  We are reusing userfaultfd_remove callback along with the logic
required to re-get and re-validate the VMA which may change or disappear
because userfaultfd_remove releases mmap_sem.

Link: http://lkml.kernel.org/r/1497876311-18615-1-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff -puN mm/madvise.c~userfaultfd-non-cooperative-add-madvise-event-for-madv_free-request mm/madvise.c
--- a/mm/madvise.c~userfaultfd-non-cooperative-add-madvise-event-for-madv_free-request
+++ a/mm/madvise.c
@@ -451,9 +451,6 @@ static int madvise_free_single_vma(struc
 	struct mm_struct *mm = vma->vm_mm;
 	struct mmu_gather tlb;
 
-	if (vma->vm_flags & (VM_LOCKED|VM_HUGETLB|VM_PFNMAP))
-		return -EINVAL;
-
 	/* MADV_FREE works for only anon vma at the moment */
 	if (!vma_is_anonymous(vma))
 		return -EINVAL;
@@ -477,14 +474,6 @@ static int madvise_free_single_vma(struc
 	return 0;
 }
 
-static long madvise_free(struct vm_area_struct *vma,
-			     struct vm_area_struct **prev,
-			     unsigned long start, unsigned long end)
-{
-	*prev = vma;
-	return madvise_free_single_vma(vma, start, end);
-}
-
 /*
  * Application no longer needs these pages.  If the pages are dirty,
  * it's OK to just throw them away.  The app will be more careful about
@@ -504,9 +493,17 @@ static long madvise_free(struct vm_area_
  * An interface that causes the system to free clean pages and flush
  * dirty pages is already available as msync(MS_INVALIDATE).
  */
-static long madvise_dontneed(struct vm_area_struct *vma,
-			     struct vm_area_struct **prev,
-			     unsigned long start, unsigned long end)
+static long madvise_dontneed_single_vma(struct vm_area_struct *vma,
+					unsigned long start, unsigned long end)
+{
+	zap_page_range(vma, start, end - start);
+	return 0;
+}
+
+static long madvise_dontneed_free(struct vm_area_struct *vma,
+				  struct vm_area_struct **prev,
+				  unsigned long start, unsigned long end,
+				  int behavior)
 {
 	*prev = vma;
 	if (!can_madv_dontneed_vma(vma))
@@ -526,7 +523,8 @@ static long madvise_dontneed(struct vm_a
 			 * is also < vma->vm_end. If start <
 			 * vma->vm_start it means an hole materialized
 			 * in the user address space within the
-			 * virtual range passed to MADV_DONTNEED.
+			 * virtual range passed to MADV_DONTNEED
+			 * or MADV_FREE.
 			 */
 			return -ENOMEM;
 		}
@@ -537,7 +535,7 @@ static long madvise_dontneed(struct vm_a
 			 * Don't fail if end > vma->vm_end. If the old
 			 * vma was splitted while the mmap_sem was
 			 * released the effect of the concurrent
-			 * operation may not cause MADV_DONTNEED to
+			 * operation may not cause madvise() to
 			 * have an undefined result. There may be an
 			 * adjacent next vma that we'll walk
 			 * next. userfaultfd_remove() will generate an
@@ -549,8 +547,13 @@ static long madvise_dontneed(struct vm_a
 		}
 		VM_WARN_ON(start >= end);
 	}
-	zap_page_range(vma, start, end - start);
-	return 0;
+
+	if (behavior == MADV_DONTNEED)
+		return madvise_dontneed_single_vma(vma, start, end);
+	else if (behavior == MADV_FREE)
+		return madvise_free_single_vma(vma, start, end);
+	else
+		return -EINVAL;
 }
 
 /*
@@ -656,9 +659,8 @@ madvise_vma(struct vm_area_struct *vma,
 	case MADV_WILLNEED:
 		return madvise_willneed(vma, prev, start, end);
 	case MADV_FREE:
-		return madvise_free(vma, prev, start, end);
 	case MADV_DONTNEED:
-		return madvise_dontneed(vma, prev, start, end);
+		return madvise_dontneed_free(vma, prev, start, end, behavior);
 	default:
 		return madvise_behavior(vma, prev, start, end, behavior);
 	}
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are

exit-dont-include-unused-userfaultfd_kh.patch
userfaultfd-drop-dead-code.patch
userfaultfd-non-cooperative-add-madvise-event-for-madv_free-request.patch

