From: akpm@linux-foundation.org
Subject: + nommu-dont-need-get_unmapped_area-for-nommu.patch added to -mm tree
Date: Thu, 14 Jan 2010 15:34:42 -0800
Message-ID: <201001142334.o0ENYgqx006405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757441Ab0ANXfJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jan 2010 18:35:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, gerg@snapgear.com, viro@zeniv.linux.org.uk


The patch titled
     nommu: don't need get_unmapped_area() for NOMMU
has been added to the -mm tree.  Its filename is
     nommu-dont-need-get_unmapped_area-for-nommu.patch

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
Subject: nommu: don't need get_unmapped_area() for NOMMU
From: David Howells <dhowells@redhat.com>

get_unmapped_area() is unnecessary for NOMMU as no-one calls it.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    2 ++
 include/linux/sched.h    |    7 +++++--
 mm/nommu.c               |   21 ---------------------
 mm/util.c                |    2 +-
 4 files changed, 8 insertions(+), 24 deletions(-)

diff -puN include/linux/mm_types.h~nommu-dont-need-get_unmapped_area-for-nommu include/linux/mm_types.h
--- a/include/linux/mm_types.h~nommu-dont-need-get_unmapped_area-for-nommu
+++ a/include/linux/mm_types.h
@@ -205,10 +205,12 @@ struct mm_struct {
 	struct vm_area_struct * mmap;		/* list of VMAs */
 	struct rb_root mm_rb;
 	struct vm_area_struct * mmap_cache;	/* last find_vma result */
+#ifdef CONFIG_MMU
 	unsigned long (*get_unmapped_area) (struct file *filp,
 				unsigned long addr, unsigned long len,
 				unsigned long pgoff, unsigned long flags);
 	void (*unmap_area) (struct mm_struct *mm, unsigned long addr);
+#endif
 	unsigned long mmap_base;		/* base of mmap area */
 	unsigned long task_size;		/* size of task vm space */
 	unsigned long cached_hole_size; 	/* if non-zero, the largest hole below free_area_cache */
diff -puN include/linux/sched.h~nommu-dont-need-get_unmapped_area-for-nommu include/linux/sched.h
--- a/include/linux/sched.h~nommu-dont-need-get_unmapped_area-for-nommu
+++ a/include/linux/sched.h
@@ -381,6 +381,8 @@ extern int sysctl_max_map_count;
 
 #include <linux/aio.h>
 
+#ifdef CONFIG_MMU
+extern void arch_pick_mmap_layout(struct mm_struct *mm);
 extern unsigned long
 arch_get_unmapped_area(struct file *, unsigned long, unsigned long,
 		       unsigned long, unsigned long);
@@ -390,6 +392,9 @@ arch_get_unmapped_area_topdown(struct fi
 			  unsigned long flags);
 extern void arch_unmap_area(struct mm_struct *, unsigned long);
 extern void arch_unmap_area_topdown(struct mm_struct *, unsigned long);
+#else
+static inline void arch_pick_mmap_layout(struct mm_struct *mm) {}
+#endif
 
 #if USE_SPLIT_PTLOCKS
 /*
@@ -2495,8 +2500,6 @@ static inline void set_task_cpu(struct t
 
 #endif /* CONFIG_SMP */
 
-extern void arch_pick_mmap_layout(struct mm_struct *mm);
-
 #ifdef CONFIG_TRACING
 extern void
 __trace_special(void *__tr, void *__data,
diff -puN mm/nommu.c~nommu-dont-need-get_unmapped_area-for-nommu mm/nommu.c
--- a/mm/nommu.c~nommu-dont-need-get_unmapped_area-for-nommu
+++ a/mm/nommu.c
@@ -1761,27 +1761,6 @@ void unmap_mapping_range(struct address_
 EXPORT_SYMBOL(unmap_mapping_range);
 
 /*
- * ask for an unmapped area at which to create a mapping on a file
- */
-unsigned long get_unmapped_area(struct file *file, unsigned long addr,
-				unsigned long len, unsigned long pgoff,
-				unsigned long flags)
-{
-	unsigned long (*get_area)(struct file *, unsigned long, unsigned long,
-				  unsigned long, unsigned long);
-
-	get_area = current->mm->get_unmapped_area;
-	if (file && file->f_op && file->f_op->get_unmapped_area)
-		get_area = file->f_op->get_unmapped_area;
-
-	if (!get_area)
-		return -ENOSYS;
-
-	return get_area(file, addr, len, pgoff, flags);
-}
-EXPORT_SYMBOL(get_unmapped_area);
-
-/*
  * Check that a process has enough memory to allocate a new virtual
  * mapping. 0 means there is enough memory for the allocation to
  * succeed and -ENOMEM implies there is not.
diff -puN mm/util.c~nommu-dont-need-get_unmapped_area-for-nommu mm/util.c
--- a/mm/util.c~nommu-dont-need-get_unmapped_area-for-nommu
+++ a/mm/util.c
@@ -220,7 +220,7 @@ char *strndup_user(const char __user *s,
 }
 EXPORT_SYMBOL(strndup_user);
 
-#ifndef HAVE_ARCH_PICK_MMAP_LAYOUT
+#if defined(CONFIG_MMU) && !defined(HAVE_ARCH_PICK_MMAP_LAYOUT)
 void arch_pick_mmap_layout(struct mm_struct *mm)
 {
 	mm->mmap_base = TASK_UNMAPPED_BASE;
_

Patches currently in -mm which might be from dhowells@redhat.com are

nommu-fix-sysv-shm-for-nommu.patch
nommu-struct-vm_regions-vm_usage-count-need-not-be-atomic.patch
nommu-remove-a-superfluous-check-of-vm_region-vm_usage.patch
nommu-dont-need-get_unmapped_area-for-nommu.patch
nommu-fix-race-between-ramfs-truncation-and-shared-mmap.patch
nommu-fix-shared-mmap-after-truncate-shrinkage-problems.patch
kernel-credc-use-kmem_cache_free.patch
nfs-avoid-warnings-when-config_nfs_v4=n.patch
frv-duplicate-output_buffer-of-e03.patch
coredump-unify-dump_seek-implementations-for-each-binfmt_c.patch
coredump-move-dump_write-and-dump_seek-into-a-header-file.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions.patch
elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch
elf-coredump-add-extended-numbering-support.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

