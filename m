From: akpm@linux-foundation.org
Subject: + ksm-first-tidy-up-madvise_vma.patch added to -mm tree
Date: Thu, 23 Jul 2009 14:07:24 -0700
Message-ID: <200907232107.n6NL7PXO027188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753753AbZGWVIJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 17:08:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, avi@redhat.com, balbir@in.ibm.com, chrisw@redhat.com, fengguang.wu@intel.com, ieidus@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     ksm: first tidy up madvise_vma()
has been added to the -mm tree.  Its filename is
     ksm-first-tidy-up-madvise_vma.patch

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
Subject: ksm: first tidy up madvise_vma()
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

madvise.c has several levels of switch statements, what to do in which? 
Move MADV_DOFORK code down from madvise_vma() to madvise_behavior(), so
madvise_vma() can be a simple router, to madvise_behavior() by default.

vma->vm_flags is an unsigned long so use the same type for new_flags.  Add
missing comment lines to describe MADV_DONTFORK and MADV_DOFORK.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Chris Wright <chrisw@redhat.com>
Signed-off-by: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   39 +++++++++++++--------------------------
 1 file changed, 13 insertions(+), 26 deletions(-)

diff -puN mm/madvise.c~ksm-first-tidy-up-madvise_vma mm/madvise.c
--- a/mm/madvise.c~ksm-first-tidy-up-madvise_vma
+++ a/mm/madvise.c
@@ -41,7 +41,7 @@ static long madvise_behavior(struct vm_a
 	struct mm_struct * mm = vma->vm_mm;
 	int error = 0;
 	pgoff_t pgoff;
-	int new_flags = vma->vm_flags;
+	unsigned long new_flags = vma->vm_flags;
 
 	switch (behavior) {
 	case MADV_NORMAL:
@@ -57,6 +57,10 @@ static long madvise_behavior(struct vm_a
 		new_flags |= VM_DONTCOPY;
 		break;
 	case MADV_DOFORK:
+		if (vma->vm_flags & VM_IO) {
+			error = -EINVAL;
+			goto out;
+		}
 		new_flags &= ~VM_DONTCOPY;
 		break;
 	}
@@ -211,37 +215,16 @@ static long
 madvise_vma(struct vm_area_struct *vma, struct vm_area_struct **prev,
 		unsigned long start, unsigned long end, int behavior)
 {
-	long error;
-
 	switch (behavior) {
-	case MADV_DOFORK:
-		if (vma->vm_flags & VM_IO) {
-			error = -EINVAL;
-			break;
-		}
-	case MADV_DONTFORK:
-	case MADV_NORMAL:
-	case MADV_SEQUENTIAL:
-	case MADV_RANDOM:
-		error = madvise_behavior(vma, prev, start, end, behavior);
-		break;
 	case MADV_REMOVE:
-		error = madvise_remove(vma, prev, start, end);
-		break;
-
+		return madvise_remove(vma, prev, start, end);
 	case MADV_WILLNEED:
-		error = madvise_willneed(vma, prev, start, end);
-		break;
-
+		return madvise_willneed(vma, prev, start, end);
 	case MADV_DONTNEED:
-		error = madvise_dontneed(vma, prev, start, end);
-		break;
-
+		return madvise_dontneed(vma, prev, start, end);
 	default:
-		BUG();
-		break;
+		return madvise_behavior(vma, prev, start, end, behavior);
 	}
-	return error;
 }
 
 static int
@@ -262,6 +245,7 @@ madvise_behavior_valid(int behavior)
 		return 0;
 	}
 }
+
 /*
  * The madvise(2) system call.
  *
@@ -286,6 +270,9 @@ madvise_behavior_valid(int behavior)
  *		so the kernel can free resources associated with it.
  *  MADV_REMOVE - the application wants to free up the given range of
  *		pages and associated backing store.
+ *  MADV_DONTFORK - omit this area from child's address space when forking:
+ *		typically, to avoid COWing pages pinned by get_user_pages().
+ *  MADV_DOFORK - cancel MADV_DONTFORK: no longer omit this area when forking.
  *
  * return values:
  *  zero    - success
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

mm-avoid-endless-looping-for-oom-killed-tasks.patch
mm-oom-analysis-add-shmem-vmstat.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
prio_tree-debugging-patch.patch

