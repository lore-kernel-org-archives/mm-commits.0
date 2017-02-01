From: akpm@linux-foundation.org
Subject: +
 mm-madvise-fail-with-enomem-when-splitting-vma-will-hit-max_map_count.patch added to -mm tree
Date: Tue, 31 Jan 2017 17:02:44 -0800
Message-ID: <589133b4.IfXfk+yjevlBykVQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42758 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750828AbdBABCp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 20:02:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, corbet@lwn.net, hannes@cmpxchg.org, jmarchan@redhat.com, kirill.shutemov@linux.intel.com, mtk.manpages@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, madvise: fail with ENOMEM when splitting vma will hit max_map_count
has been added to the -mm tree.  Its filename is
     mm-madvise-fail-with-enomem-when-splitting-vma-will-hit-max_map_count.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-fail-with-enomem-when-splitting-vma-will-hit-max_map_count.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-fail-with-enomem-when-splitting-vma-will-hit-max_map_count.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, madvise: fail with ENOMEM when splitting vma will hit max_map_count

If madvise(2) advice will result in the underlying vma being split and the
number of areas mapped by the process will exceed
/proc/sys/vm/max_map_count as a result, return ENOMEM instead of EAGAIN.

EAGAIN is returned by madvise(2) when a kernel resource, such as slab, is
temporarily unavailable.  It indicates that userspace should retry the
advice in the near future.  This is important for advice such as
MADV_DONTNEED which is often used by malloc implementations to free memory
back to the system: we really do want to free memory back when madvise(2)
returns EAGAIN because slab allocations (for vmas, anon_vmas, or
mempolicies) cannot be allocated.

Encountering /proc/sys/vm/max_map_count is not a temporary failure,
however, so return ENOMEM to indicate this is a more serious issue.  A
followup patch to the man page will specify this behavior.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1701241431120.42507@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    4 +-
 Documentation/vm/ksm.txt    |    4 ++
 include/linux/mm.h          |    6 ++--
 mm/madvise.c                |   51 ++++++++++++++++++++++++++++------
 mm/mmap.c                   |    8 ++---
 5 files changed, 56 insertions(+), 17 deletions(-)

diff -puN Documentation/sysctl/vm.txt~mm-madvise-fail-with-enomem-when-splitting-vma-will-hit-max_map_count Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-madvise-fail-with-enomem-when-splitting-vma-will-hit-max_map_count
+++ a/Documentation/sysctl/vm.txt
@@ -376,8 +376,8 @@ max_map_count:
 
 This file contains the maximum number of memory map areas a process
 may have. Memory map areas are used as a side-effect of calling
-malloc, directly by mmap and mprotect, and also when loading shared
-libraries.
+malloc, directly by mmap, mprotect, and madvise, and also when loading
+shared libraries.
 
 While most applications need less than a thousand maps, certain
 programs, particularly malloc debuggers, may consume lots of them,
diff -puN Documentation/vm/ksm.txt~mm-madvise-fail-with-enomem-when-splitting-vma-will-hit-max_map_count Documentation/vm/ksm.txt
--- a/Documentation/vm/ksm.txt~mm-madvise-fail-with-enomem-when-splitting-vma-will-hit-max_map_count
+++ a/Documentation/vm/ksm.txt
@@ -38,6 +38,10 @@ the range for whenever the KSM daemon is
 cannot contain any pages which KSM could actually merge; even if
 MADV_UNMERGEABLE is applied to a range which was never MADV_MERGEABLE.
 
+If a region of memory must be split into at least one new MADV_MERGEABLE
+or MADV_UNMERGEABLE region, the madvise may return ENOMEM if the process
+will exceed vm.max_map_count (see Documentation/sysctl/vm.txt).
+
 Like other madvise calls, they are intended for use on mapped areas of
 the user address space: they will report ENOMEM if the specified range
 includes unmapped gaps (though working on the intervening mapped areas),
diff -puN include/linux/mm.h~mm-madvise-fail-with-enomem-when-splitting-vma-will-hit-max_map_count include/linux/mm.h
--- a/include/linux/mm.h~mm-madvise-fail-with-enomem-when-splitting-vma-will-hit-max_map_count
+++ a/include/linux/mm.h
@@ -2035,8 +2035,10 @@ extern struct vm_area_struct *vma_merge(
 	unsigned long vm_flags, struct anon_vma *, struct file *, pgoff_t,
 	struct mempolicy *, struct vm_userfaultfd_ctx);
 extern struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *);
-extern int split_vma(struct mm_struct *,
-	struct vm_area_struct *, unsigned long addr, int new_below);
+extern int __split_vma(struct mm_struct *, struct vm_area_struct *,
+	unsigned long addr, int new_below);
+extern int split_vma(struct mm_struct *, struct vm_area_struct *,
+	unsigned long addr, int new_below);
 extern int insert_vm_struct(struct mm_struct *, struct vm_area_struct *);
 extern void __vma_link_rb(struct mm_struct *, struct vm_area_struct *,
 	struct rb_node **, struct rb_node *);
diff -puN mm/madvise.c~mm-madvise-fail-with-enomem-when-splitting-vma-will-hit-max_map_count mm/madvise.c
--- a/mm/madvise.c~mm-madvise-fail-with-enomem-when-splitting-vma-will-hit-max_map_count
+++ a/mm/madvise.c
@@ -92,14 +92,28 @@ static long madvise_behavior(struct vm_a
 	case MADV_MERGEABLE:
 	case MADV_UNMERGEABLE:
 		error = ksm_madvise(vma, start, end, behavior, &new_flags);
-		if (error)
+		if (error) {
+			/*
+			 * madvise() returns EAGAIN if kernel resources, such as
+			 * slab, are temporarily unavailable.
+			 */
+			if (error == -ENOMEM)
+				error = -EAGAIN;
 			goto out;
+		}
 		break;
 	case MADV_HUGEPAGE:
 	case MADV_NOHUGEPAGE:
 		error = hugepage_madvise(vma, &new_flags, behavior);
-		if (error)
+		if (error) {
+			/*
+			 * madvise() returns EAGAIN if kernel resources, such as
+			 * slab, are temporarily unavailable.
+			 */
+			if (error == -ENOMEM)
+				error = -EAGAIN;
 			goto out;
+		}
 		break;
 	}
 
@@ -120,15 +134,37 @@ static long madvise_behavior(struct vm_a
 	*prev = vma;
 
 	if (start != vma->vm_start) {
-		error = split_vma(mm, vma, start, 1);
-		if (error)
+		if (unlikely(mm->map_count >= sysctl_max_map_count)) {
+			error = -ENOMEM;
 			goto out;
+		}
+		error = __split_vma(mm, vma, start, 1);
+		if (error) {
+			/*
+			 * madvise() returns EAGAIN if kernel resources, such as
+			 * slab, are temporarily unavailable.
+			 */
+			if (error == -ENOMEM)
+				error = -EAGAIN;
+			goto out;
+		}
 	}
 
 	if (end != vma->vm_end) {
-		error = split_vma(mm, vma, end, 0);
-		if (error)
+		if (unlikely(mm->map_count >= sysctl_max_map_count)) {
+			error = -ENOMEM;
+			goto out;
+		}
+		error = __split_vma(mm, vma, end, 0);
+		if (error) {
+			/*
+			 * madvise() returns EAGAIN if kernel resources, such as
+			 * slab, are temporarily unavailable.
+			 */
+			if (error == -ENOMEM)
+				error = -EAGAIN;
 			goto out;
+		}
 	}
 
 success:
@@ -136,10 +172,7 @@ success:
 	 * vm_flags is protected by the mmap_sem held in write mode.
 	 */
 	vma->vm_flags = new_flags;
-
 out:
-	if (error == -ENOMEM)
-		error = -EAGAIN;
 	return error;
 }
 
diff -puN mm/mmap.c~mm-madvise-fail-with-enomem-when-splitting-vma-will-hit-max_map_count mm/mmap.c
--- a/mm/mmap.c~mm-madvise-fail-with-enomem-when-splitting-vma-will-hit-max_map_count
+++ a/mm/mmap.c
@@ -2499,11 +2499,11 @@ detach_vmas_to_be_unmapped(struct mm_str
 }
 
 /*
- * __split_vma() bypasses sysctl_max_map_count checking.  We use this on the
- * munmap path where it doesn't make sense to fail.
+ * __split_vma() bypasses sysctl_max_map_count checking.  We use this where it
+ * has already been checked or doesn't make sense to fail.
  */
-static int __split_vma(struct mm_struct *mm, struct vm_area_struct *vma,
-	      unsigned long addr, int new_below)
+int __split_vma(struct mm_struct *mm, struct vm_area_struct *vma,
+		unsigned long addr, int new_below)
 {
 	struct vm_area_struct *new;
 	int err;
_

Patches currently in -mm which might be from rientjes@google.com are

mm-compaction-add-vmstats-for-kcompactd-work.patch
mm-thp-add-new-defermadvise-defrag-option.patch
mm-page_alloc-warn_alloc-nodemask-is-null-when-cpusets-are-disabled.patch
mm-oom-header-nodemask-is-null-when-cpusets-are-disabled.patch
mm-oom-header-nodemask-is-null-when-cpusets-are-disabled-fix.patch
mm-madvise-fail-with-enomem-when-splitting-vma-will-hit-max_map_count.patch

