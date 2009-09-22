From: akpm@linux-foundation.org
Subject: [merged] ksm-first-tidy-up-madvise_vma.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:39:07 -0700
Message-ID: <200909222039.n8MKd7Xo002794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752835AbZIVUmW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, avi@redhat.com, balbir@in.ibm.com, chrisw@redhat.com, fengguang.wu@intel.com, ieidus@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, lee.s


The patch titled
     ksm: first tidy up madvise_vma()
has been removed from the -mm tree.  Its filename was
     ksm-first-tidy-up-madvise_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
vfs-optimize-touch_time-too.patch
vfs-seq_file-add-helpers-for-data-filling.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
getrusage-fill-ru_maxrss-value.patch
walk-system-ram-range-fix.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

