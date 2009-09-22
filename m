From: akpm@linux-foundation.org
Subject: [merged] mm-remove-unused-gup-flags.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:42:43 -0700
Message-ID: <200909222042.n8MKghb6010151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753038AbZIVUmx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: remove unused GUP flags
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-gup-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove unused GUP flags
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

GUP_FLAGS_IGNORE_VMA_PERMISSIONS and GUP_FLAGS_IGNORE_SIGKILL were
flags added solely to prevent __get_user_pages() from doing some of
what it usually does, in the munlock case: we can now remove them.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    6 ++----
 mm/memory.c   |   14 ++++----------
 mm/nommu.c    |    6 ++----
 3 files changed, 8 insertions(+), 18 deletions(-)

diff -puN mm/internal.h~mm-remove-unused-gup-flags mm/internal.h
--- a/mm/internal.h~mm-remove-unused-gup-flags
+++ a/mm/internal.h
@@ -250,10 +250,8 @@ static inline void mminit_validate_memmo
 }
 #endif /* CONFIG_SPARSEMEM */
 
-#define GUP_FLAGS_WRITE                  0x1
-#define GUP_FLAGS_FORCE                  0x2
-#define GUP_FLAGS_IGNORE_VMA_PERMISSIONS 0x4
-#define GUP_FLAGS_IGNORE_SIGKILL         0x8
+#define GUP_FLAGS_WRITE		0x01
+#define GUP_FLAGS_FORCE		0x02
 
 int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		     unsigned long start, int len, int flags,
diff -puN mm/memory.c~mm-remove-unused-gup-flags mm/memory.c
--- a/mm/memory.c~mm-remove-unused-gup-flags
+++ a/mm/memory.c
@@ -1217,8 +1217,6 @@ int __get_user_pages(struct task_struct 
 	unsigned int vm_flags = 0;
 	int write = !!(flags & GUP_FLAGS_WRITE);
 	int force = !!(flags & GUP_FLAGS_FORCE);
-	int ignore = !!(flags & GUP_FLAGS_IGNORE_VMA_PERMISSIONS);
-	int ignore_sigkill = !!(flags & GUP_FLAGS_IGNORE_SIGKILL);
 
 	if (nr_pages <= 0)
 		return 0;
@@ -1244,7 +1242,7 @@ int __get_user_pages(struct task_struct 
 			pte_t *pte;
 
 			/* user gate pages are read-only */
-			if (!ignore && write)
+			if (write)
 				return i ? : -EFAULT;
 			if (pg > TASK_SIZE)
 				pgd = pgd_offset_k(pg);
@@ -1278,7 +1276,7 @@ int __get_user_pages(struct task_struct 
 
 		if (!vma ||
 		    (vma->vm_flags & (VM_IO | VM_PFNMAP)) ||
-		    (!ignore && !(vm_flags & vma->vm_flags)))
+		    !(vm_flags & vma->vm_flags))
 			return i ? : -EFAULT;
 
 		if (is_vm_hugetlb_page(vma)) {
@@ -1298,13 +1296,9 @@ int __get_user_pages(struct task_struct 
 
 			/*
 			 * If we have a pending SIGKILL, don't keep faulting
-			 * pages and potentially allocating memory, unless
-			 * current is handling munlock--e.g., on exit. In
-			 * that case, we are not allocating memory.  Rather,
-			 * we're only unlocking already resident/mapped pages.
+			 * pages and potentially allocating memory.
 			 */
-			if (unlikely(!ignore_sigkill &&
-					fatal_signal_pending(current)))
+			if (unlikely(fatal_signal_pending(current)))
 				return i ? i : -ERESTARTSYS;
 
 			if (write)
diff -puN mm/nommu.c~mm-remove-unused-gup-flags mm/nommu.c
--- a/mm/nommu.c~mm-remove-unused-gup-flags
+++ a/mm/nommu.c
@@ -176,7 +176,6 @@ int __get_user_pages(struct task_struct 
 	int i;
 	int write = !!(flags & GUP_FLAGS_WRITE);
 	int force = !!(flags & GUP_FLAGS_FORCE);
-	int ignore = !!(flags & GUP_FLAGS_IGNORE_VMA_PERMISSIONS);
 
 	/* calculate required read or write permissions.
 	 * - if 'force' is set, we only require the "MAY" flags.
@@ -190,8 +189,8 @@ int __get_user_pages(struct task_struct 
 			goto finish_or_fault;
 
 		/* protect what we can, including chardevs */
-		if (vma->vm_flags & (VM_IO | VM_PFNMAP) ||
-		    (!ignore && !(vm_flags & vma->vm_flags)))
+		if ((vma->vm_flags & (VM_IO | VM_PFNMAP)) ||
+		    !(vm_flags & vma->vm_flags))
 			goto finish_or_fault;
 
 		if (pages) {
@@ -210,7 +209,6 @@ finish_or_fault:
 	return i ? : -EFAULT;
 }
 
-
 /*
  * get a list of pages in an address range belonging to the specified process
  * and indicate the VMA that covers each page
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

