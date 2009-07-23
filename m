From: akpm@linux-foundation.org
Subject: + ksm-the-mm-interface-to-ksm.patch added to -mm tree
Date: Thu, 23 Jul 2009 14:07:33 -0700
Message-ID: <200907232107.n6NL7X1D027370@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753897AbZGWVIR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 17:08:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, avi@redhat.com, balbir@in.ibm.com, chrisw@redhat.com, fengguang.wu@intel.com, ieidus@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, mtk.manpages@gmail.com, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     ksm: the mm interface to ksm
has been added to the -mm tree.  Its filename is
     ksm-the-mm-interface-to-ksm.patch

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
Subject: ksm: the mm interface to ksm
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

This patch presents the mm interface to a dummy version of ksm.c, for
better scrutiny of that interface: the real ksm.c follows later.

When CONFIG_KSM is not set, madvise(2) reject MADV_MERGEABLE and
MADV_UNMERGEABLE with EINVAL, since that seems more helpful than
pretending that they can be serviced.  But when CONFIG_KSM=y, accept them
even if KSM is not currently running, and even on areas which KSM will not
touch (e.g.  hugetlb or shared file or special driver mappings).

Like other madvices, report ENOMEM despite success if any area in the
range is unmapped, and use EAGAIN to report out of memory.

Define vma flag VM_MERGEABLE to identify an area on which KSM may try
merging pages: leave it to ksm_madvise() to decide whether to set it. 
Define mm flag MMF_VM_MERGEABLE to identify an mm which might contain
VM_MERGEABLE areas, to minimize callouts when forking or exiting.

Based upon earlier patches by Chris Wright and Izik Eidus.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Chris Wright <chrisw@redhat.com>
Signed-off-by: Izik Eidus <ieidus@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
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

 include/linux/ksm.h   |   50 +++++++++++++++++++++++++++++++++++
 include/linux/mm.h    |    1 
 include/linux/sched.h |    7 +++++
 kernel/fork.c         |    8 +++++
 mm/Kconfig            |   11 +++++++
 mm/Makefile           |    1 
 mm/ksm.c              |   56 ++++++++++++++++++++++++++++++++++++++++
 mm/madvise.c          |   14 ++++++++++
 8 files changed, 147 insertions(+), 1 deletion(-)

diff -puN /dev/null include/linux/ksm.h
--- /dev/null
+++ a/include/linux/ksm.h
@@ -0,0 +1,50 @@
+#ifndef __LINUX_KSM_H
+#define __LINUX_KSM_H
+/*
+ * Memory merging support.
+ *
+ * This code enables dynamic sharing of identical pages found in different
+ * memory areas, even if they are not shared by fork().
+ */
+
+#include <linux/bitops.h>
+#include <linux/mm.h>
+#include <linux/sched.h>
+
+#ifdef CONFIG_KSM
+int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
+		unsigned long end, int advice, unsigned long *vm_flags);
+int __ksm_enter(struct mm_struct *mm);
+void __ksm_exit(struct mm_struct *mm);
+
+static inline int ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
+{
+	if (test_bit(MMF_VM_MERGEABLE, &oldmm->flags))
+		return __ksm_enter(mm);
+	return 0;
+}
+
+static inline void ksm_exit(struct mm_struct *mm)
+{
+	if (test_bit(MMF_VM_MERGEABLE, &mm->flags))
+		__ksm_exit(mm);
+}
+#else  /* !CONFIG_KSM */
+
+static inline int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
+		unsigned long end, int advice, unsigned long *vm_flags)
+{
+	return 0;
+}
+
+static inline int ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
+{
+	return 0;
+}
+
+static inline void ksm_exit(struct mm_struct *mm)
+{
+}
+#endif /* !CONFIG_KSM */
+
+#endif
diff -puN include/linux/mm.h~ksm-the-mm-interface-to-ksm include/linux/mm.h
--- a/include/linux/mm.h~ksm-the-mm-interface-to-ksm
+++ a/include/linux/mm.h
@@ -105,6 +105,7 @@ extern unsigned int kobjsize(const void 
 #define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
 #define VM_SAO		0x20000000	/* Strong Access Ordering (powerpc) */
 #define VM_PFN_AT_MMAP	0x40000000	/* PFNMAP vma that is fully mapped at mmap time */
+#define VM_MERGEABLE	0x80000000	/* KSM may merge identical pages */
 
 #ifndef VM_STACK_DEFAULT_FLAGS		/* arch can override this */
 #define VM_STACK_DEFAULT_FLAGS VM_DATA_DEFAULT_FLAGS
diff -puN include/linux/sched.h~ksm-the-mm-interface-to-ksm include/linux/sched.h
--- a/include/linux/sched.h~ksm-the-mm-interface-to-ksm
+++ a/include/linux/sched.h
@@ -433,7 +433,9 @@ extern int get_dumpable(struct mm_struct
 /* dumpable bits */
 #define MMF_DUMPABLE      0  /* core dump is permitted */
 #define MMF_DUMP_SECURELY 1  /* core file is readable only by root */
+
 #define MMF_DUMPABLE_BITS 2
+#define MMF_DUMPABLE_MASK ((1 << MMF_DUMPABLE_BITS) - 1)
 
 /* coredump filter bits */
 #define MMF_DUMP_ANON_PRIVATE	2
@@ -443,6 +445,7 @@ extern int get_dumpable(struct mm_struct
 #define MMF_DUMP_ELF_HEADERS	6
 #define MMF_DUMP_HUGETLB_PRIVATE 7
 #define MMF_DUMP_HUGETLB_SHARED  8
+
 #define MMF_DUMP_FILTER_SHIFT	MMF_DUMPABLE_BITS
 #define MMF_DUMP_FILTER_BITS	7
 #define MMF_DUMP_FILTER_MASK \
@@ -456,6 +459,10 @@ extern int get_dumpable(struct mm_struct
 #else
 # define MMF_DUMP_MASK_DEFAULT_ELF	0
 #endif
+					/* leave room for more dump flags */
+#define MMF_VM_MERGEABLE	16	/* KSM may merge identical pages */
+
+#define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
 
 struct sighand_struct {
 	atomic_t		count;
diff -puN kernel/fork.c~ksm-the-mm-interface-to-ksm kernel/fork.c
--- a/kernel/fork.c~ksm-the-mm-interface-to-ksm
+++ a/kernel/fork.c
@@ -49,6 +49,7 @@
 #include <linux/ftrace.h>
 #include <linux/profile.h>
 #include <linux/rmap.h>
+#include <linux/ksm.h>
 #include <linux/acct.h>
 #include <linux/tsacct_kern.h>
 #include <linux/cn_proc.h>
@@ -300,6 +301,9 @@ static int dup_mmap(struct mm_struct *mm
 	rb_link = &mm->mm_rb.rb_node;
 	rb_parent = NULL;
 	pprev = &mm->mmap;
+	retval = ksm_fork(mm, oldmm);
+	if (retval)
+		goto out;
 
 	for (mpnt = oldmm->mmap; mpnt; mpnt = mpnt->vm_next) {
 		struct file *file;
@@ -436,7 +440,8 @@ static struct mm_struct * mm_init(struct
 	atomic_set(&mm->mm_count, 1);
 	init_rwsem(&mm->mmap_sem);
 	INIT_LIST_HEAD(&mm->mmlist);
-	mm->flags = (current->mm) ? current->mm->flags : default_dump_filter;
+	mm->flags = (current->mm) ?
+		(current->mm->flags & MMF_INIT_MASK) : default_dump_filter;
 	mm->oom_adj = (current->mm) ? current->mm->oom_adj : 0;
 	mm->core_state = NULL;
 	mm->nr_ptes = 0;
@@ -498,6 +503,7 @@ void mmput(struct mm_struct *mm)
 
 	if (atomic_dec_and_test(&mm->mm_users)) {
 		exit_aio(mm);
+		ksm_exit(mm);
 		exit_mmap(mm);
 		set_mm_exe_file(mm, NULL);
 		if (!list_empty(&mm->mmlist)) {
diff -puN mm/Kconfig~ksm-the-mm-interface-to-ksm mm/Kconfig
--- a/mm/Kconfig~ksm-the-mm-interface-to-ksm
+++ a/mm/Kconfig
@@ -214,6 +214,17 @@ config HAVE_MLOCKED_PAGE_BIT
 config MMU_NOTIFIER
 	bool
 
+config KSM
+	bool "Enable KSM for page merging"
+	depends on MMU
+	help
+	  Enable Kernel Samepage Merging: KSM periodically scans those areas
+	  of an application's address space that an app has advised may be
+	  mergeable.  When it finds pages of identical content, it replaces
+	  the many instances by a single resident page with that content, so
+	  saving memory until one or another app needs to modify the content.
+	  Recommended for use with KVM, or with other duplicative applications.
+
 config DEFAULT_MMAP_MIN_ADDR
         int "Low address space to protect from user allocation"
         default 4096
diff -puN mm/Makefile~ksm-the-mm-interface-to-ksm mm/Makefile
--- a/mm/Makefile~ksm-the-mm-interface-to-ksm
+++ a/mm/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_SPARSEMEM_VMEMMAP) += spars
 obj-$(CONFIG_TMPFS_POSIX_ACL) += shmem_acl.o
 obj-$(CONFIG_SLOB) += slob.o
 obj-$(CONFIG_MMU_NOTIFIER) += mmu_notifier.o
+obj-$(CONFIG_KSM) += ksm.o
 obj-$(CONFIG_PAGE_POISONING) += debug-pagealloc.o
 obj-$(CONFIG_SLAB) += slab.o
 obj-$(CONFIG_SLUB) += slub.o
diff -puN /dev/null mm/ksm.c
--- /dev/null
+++ a/mm/ksm.c
@@ -0,0 +1,56 @@
+/*
+ * Initial dummy version just to illustrate KSM's interface to other files.
+ */
+
+#include <linux/errno.h>
+#include <linux/mman.h>
+#include <linux/ksm.h>
+
+int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
+		unsigned long end, int advice, unsigned long *vm_flags)
+{
+	struct mm_struct *mm = vma->vm_mm;
+
+	switch (advice) {
+	case MADV_MERGEABLE:
+		/*
+		 * Be somewhat over-protective for now!
+		 */
+		if (*vm_flags & (VM_MERGEABLE | VM_SHARED  | VM_MAYSHARE   |
+				 VM_PFNMAP    | VM_IO      | VM_DONTEXPAND |
+				 VM_RESERVED  | VM_HUGETLB | VM_INSERTPAGE |
+				 VM_MIXEDMAP  | VM_SAO))
+			return 0;		/* just ignore the advice */
+
+		if (!test_bit(MMF_VM_MERGEABLE, &mm->flags))
+			if (__ksm_enter(mm) < 0)
+				return -EAGAIN;
+
+		*vm_flags |= VM_MERGEABLE;
+		break;
+
+	case MADV_UNMERGEABLE:
+		if (!(*vm_flags & VM_MERGEABLE))
+			return 0;		/* just ignore the advice */
+
+		/* Unmerge any merged pages here */
+
+		*vm_flags &= ~VM_MERGEABLE;
+		break;
+	}
+
+	return 0;
+}
+
+int __ksm_enter(struct mm_struct *mm)
+{
+	/* Allocate a structure to track mm and link it into KSM's list */
+	set_bit(MMF_VM_MERGEABLE, &mm->flags);
+	return 0;
+}
+
+void __ksm_exit(struct mm_struct *mm)
+{
+	/* Unlink and free all KSM's structures which track this mm */
+	clear_bit(MMF_VM_MERGEABLE, &mm->flags);
+}
diff -puN mm/madvise.c~ksm-the-mm-interface-to-ksm mm/madvise.c
--- a/mm/madvise.c~ksm-the-mm-interface-to-ksm
+++ a/mm/madvise.c
@@ -11,6 +11,7 @@
 #include <linux/mempolicy.h>
 #include <linux/hugetlb.h>
 #include <linux/sched.h>
+#include <linux/ksm.h>
 
 /*
  * Any behaviour which results in changes to the vma->vm_flags needs to
@@ -63,6 +64,12 @@ static long madvise_behavior(struct vm_a
 		}
 		new_flags &= ~VM_DONTCOPY;
 		break;
+	case MADV_MERGEABLE:
+	case MADV_UNMERGEABLE:
+		error = ksm_madvise(vma, start, end, behavior, &new_flags);
+		if (error)
+			goto out;
+		break;
 	}
 
 	if (new_flags == vma->vm_flags) {
@@ -239,6 +246,10 @@ madvise_behavior_valid(int behavior)
 	case MADV_REMOVE:
 	case MADV_WILLNEED:
 	case MADV_DONTNEED:
+#ifdef CONFIG_KSM
+	case MADV_MERGEABLE:
+	case MADV_UNMERGEABLE:
+#endif
 		return 1;
 
 	default:
@@ -273,6 +284,9 @@ madvise_behavior_valid(int behavior)
  *  MADV_DONTFORK - omit this area from child's address space when forking:
  *		typically, to avoid COWing pages pinned by get_user_pages().
  *  MADV_DOFORK - cancel MADV_DONTFORK: no longer omit this area when forking.
+ *  MADV_MERGEABLE - the application recommends that KSM try to merge pages in
+ *		this area with pages of identical content from other such areas.
+ *  MADV_UNMERGEABLE- cancel MADV_MERGEABLE: no longer merge pages with others.
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

