From: akpm@linux-foundation.org
Subject: + move-mm_struct-and-vm_area_struct.patch added to -mm tree
Date: Thu, 09 Aug 2007 14:54:06 -0700
Message-ID: <200708092154.l79Ls6am021501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57163 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753735AbXHIVyR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 17:54:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: schwidefsky@de.ibm.com


The patch titled
     move mm_struct and vm_area_struct
has been added to the -mm tree.  Its filename is
     move-mm_struct-and-vm_area_struct.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: move mm_struct and vm_area_struct
From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Move the definitions of struct mm_struct and struct vma_area_struct to
include/mm_types.h.  This allows to define more function in asm/pgtable.h
and friends with inline assemblies instead of macros.  Compile tested on
i386, powerpc, powerpc64, s390-32, s390-64 and x86_64.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |   63 ----------------
 include/linux/mm_types.h |  143 +++++++++++++++++++++++++++++++++++++
 include/linux/sched.h    |   74 -------------------
 3 files changed, 144 insertions(+), 136 deletions(-)

diff -puN include/linux/mm.h~move-mm_struct-and-vm_area_struct include/linux/mm.h
--- a/include/linux/mm.h~move-mm_struct-and-vm_area_struct
+++ a/include/linux/mm.h
@@ -51,69 +51,6 @@ extern int sysctl_legacy_va_layout;
  * mmap() functions).
  */
 
-/*
- * This struct defines a memory VMM memory area. There is one of these
- * per VM-area/task.  A VM area is any part of the process virtual memory
- * space that has a special rule for the page-fault handlers (ie a shared
- * library, the executable area etc).
- */
-struct vm_area_struct {
-	struct mm_struct * vm_mm;	/* The address space we belong to. */
-	unsigned long vm_start;		/* Our start address within vm_mm. */
-	unsigned long vm_end;		/* The first byte after our end address
-					   within vm_mm. */
-
-	/* linked list of VM areas per task, sorted by address */
-	struct vm_area_struct *vm_next;
-
-	pgprot_t vm_page_prot;		/* Access permissions of this VMA. */
-	unsigned long vm_flags;		/* Flags, listed below. */
-
-	struct rb_node vm_rb;
-
-	/*
-	 * For areas with an address space and backing store,
-	 * linkage into the address_space->i_mmap prio tree, or
-	 * linkage to the list of like vmas hanging off its node, or
-	 * linkage of vma in the address_space->i_mmap_nonlinear list.
-	 */
-	union {
-		struct {
-			struct list_head list;
-			void *parent;	/* aligns with prio_tree_node parent */
-			struct vm_area_struct *head;
-		} vm_set;
-
-		struct raw_prio_tree_node prio_tree_node;
-	} shared;
-
-	/*
-	 * A file's MAP_PRIVATE vma can be in both i_mmap tree and anon_vma
-	 * list, after a COW of one of the file pages.  A MAP_SHARED vma
-	 * can only be in the i_mmap tree.  An anonymous MAP_PRIVATE, stack
-	 * or brk vma (with NULL file) can only be in an anon_vma list.
-	 */
-	struct list_head anon_vma_node;	/* Serialized by anon_vma->lock */
-	struct anon_vma *anon_vma;	/* Serialized by page_table_lock */
-
-	/* Function pointers to deal with this struct. */
-	struct vm_operations_struct * vm_ops;
-
-	/* Information about our backing store: */
-	unsigned long vm_pgoff;		/* Offset (within vm_file) in PAGE_SIZE
-					   units, *not* PAGE_CACHE_SIZE */
-	struct file * vm_file;		/* File we map to (can be NULL). */
-	void * vm_private_data;		/* was vm_pte (shared mem) */
-	unsigned long vm_truncate_count;/* truncate_count or restart_addr */
-
-#ifndef CONFIG_MMU
-	atomic_t vm_usage;		/* refcount (VMAs shared if !MMU) */
-#endif
-#ifdef CONFIG_NUMA
-	struct mempolicy *vm_policy;	/* NUMA policy for the VMA */
-#endif
-};
-
 extern struct kmem_cache *vm_area_cachep;
 
 /*
diff -puN include/linux/mm_types.h~move-mm_struct-and-vm_area_struct include/linux/mm_types.h
--- a/include/linux/mm_types.h~move-mm_struct-and-vm_area_struct
+++ a/include/linux/mm_types.h
@@ -1,13 +1,25 @@
 #ifndef _LINUX_MM_TYPES_H
 #define _LINUX_MM_TYPES_H
 
+#include <linux/auxvec.h>	/* For AT_VECTOR_SIZE */
 #include <linux/types.h>
 #include <linux/threads.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
+#include <linux/prio_tree.h>
+#include <linux/rbtree.h>
+#include <linux/rwsem.h>
+#include <linux/completion.h>
+#include <asm/mmu.h>
 
 struct address_space;
 
+#if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS
+typedef atomic_long_t mm_counter_t;
+#else  /* NR_CPUS < CONFIG_SPLIT_PTLOCK_CPUS */
+typedef unsigned long mm_counter_t;
+#endif /* NR_CPUS < CONFIG_SPLIT_PTLOCK_CPUS */
+
 /*
  * Each physical page in the system has a struct page associated with
  * it to keep track of whatever it is we are using the page for at the
@@ -80,4 +92,135 @@ struct page {
 #endif /* WANT_PAGE_VIRTUAL */
 };
 
+/*
+ * This struct defines a memory VMM memory area. There is one of these
+ * per VM-area/task.  A VM area is any part of the process virtual memory
+ * space that has a special rule for the page-fault handlers (ie a shared
+ * library, the executable area etc).
+ */
+struct vm_area_struct {
+	struct mm_struct * vm_mm;	/* The address space we belong to. */
+	unsigned long vm_start;		/* Our start address within vm_mm. */
+	unsigned long vm_end;		/* The first byte after our end address
+					   within vm_mm. */
+
+	/* linked list of VM areas per task, sorted by address */
+	struct vm_area_struct *vm_next;
+
+	pgprot_t vm_page_prot;		/* Access permissions of this VMA. */
+	unsigned long vm_flags;		/* Flags, listed below. */
+
+	struct rb_node vm_rb;
+
+	/*
+	 * For areas with an address space and backing store,
+	 * linkage into the address_space->i_mmap prio tree, or
+	 * linkage to the list of like vmas hanging off its node, or
+	 * linkage of vma in the address_space->i_mmap_nonlinear list.
+	 */
+	union {
+		struct {
+			struct list_head list;
+			void *parent;	/* aligns with prio_tree_node parent */
+			struct vm_area_struct *head;
+		} vm_set;
+
+		struct raw_prio_tree_node prio_tree_node;
+	} shared;
+
+	/*
+	 * A file's MAP_PRIVATE vma can be in both i_mmap tree and anon_vma
+	 * list, after a COW of one of the file pages.	A MAP_SHARED vma
+	 * can only be in the i_mmap tree.  An anonymous MAP_PRIVATE, stack
+	 * or brk vma (with NULL file) can only be in an anon_vma list.
+	 */
+	struct list_head anon_vma_node;	/* Serialized by anon_vma->lock */
+	struct anon_vma *anon_vma;	/* Serialized by page_table_lock */
+
+	/* Function pointers to deal with this struct. */
+	struct vm_operations_struct * vm_ops;
+
+	/* Information about our backing store: */
+	unsigned long vm_pgoff;		/* Offset (within vm_file) in PAGE_SIZE
+					   units, *not* PAGE_CACHE_SIZE */
+	struct file * vm_file;		/* File we map to (can be NULL). */
+	void * vm_private_data;		/* was vm_pte (shared mem) */
+	unsigned long vm_truncate_count;/* truncate_count or restart_addr */
+
+#ifndef CONFIG_MMU
+	atomic_t vm_usage;		/* refcount (VMAs shared if !MMU) */
+#endif
+#ifdef CONFIG_NUMA
+	struct mempolicy *vm_policy;	/* NUMA policy for the VMA */
+#endif
+};
+
+struct mm_struct {
+	struct vm_area_struct * mmap;		/* list of VMAs */
+	struct rb_root mm_rb;
+	struct vm_area_struct * mmap_cache;	/* last find_vma result */
+	unsigned long (*get_unmapped_area) (struct file *filp,
+				unsigned long addr, unsigned long len,
+				unsigned long pgoff, unsigned long flags);
+	void (*unmap_area) (struct mm_struct *mm, unsigned long addr);
+	unsigned long mmap_base;		/* base of mmap area */
+	unsigned long task_size;		/* size of task vm space */
+	unsigned long cached_hole_size; 	/* if non-zero, the largest hole below free_area_cache */
+	unsigned long free_area_cache;		/* first hole of size cached_hole_size or larger */
+	pgd_t * pgd;
+	atomic_t mm_users;			/* How many users with user space? */
+	atomic_t mm_count;			/* How many references to "struct mm_struct" (users count as 1) */
+	int map_count;				/* number of VMAs */
+	struct rw_semaphore mmap_sem;
+	spinlock_t page_table_lock;		/* Protects page tables and some counters */
+
+	struct list_head mmlist;		/* List of maybe swapped mm's.	These are globally strung
+						 * together off init_mm.mmlist, and are protected
+						 * by mmlist_lock
+						 */
+
+	/* Special counters, in some configurations protected by the
+	 * page_table_lock, in other configurations by being atomic.
+	 */
+	mm_counter_t _file_rss;
+	mm_counter_t _anon_rss;
+
+	unsigned long hiwater_rss;	/* High-watermark of RSS usage */
+	unsigned long hiwater_vm;	/* High-water virtual memory usage */
+
+	unsigned long total_vm, locked_vm, shared_vm, exec_vm;
+	unsigned long stack_vm, reserved_vm, def_flags, nr_ptes;
+	unsigned long start_code, end_code, start_data, end_data;
+	unsigned long start_brk, brk, start_stack;
+	unsigned long arg_start, arg_end, env_start, env_end;
+
+	unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
+
+	cpumask_t cpu_vm_mask;
+
+	/* Architecture-specific MM context */
+	mm_context_t context;
+
+	/* Swap token stuff */
+	/*
+	 * Last value of global fault stamp as seen by this process.
+	 * In other words, this value gives an indication of how long
+	 * it has been since this task got the token.
+	 * Look at mm/thrash.c
+	 */
+	unsigned int faultstamp;
+	unsigned int token_priority;
+	unsigned int last_interval;
+
+	unsigned long flags; /* Must use atomic bitops to access the bits */
+
+	/* coredumping support */
+	int core_waiters;
+	struct completion *core_startup_done, core_done;
+
+	/* aio bits */
+	rwlock_t		ioctx_list_lock;
+	struct kioctx		*ioctx_list;
+};
+
 #endif /* _LINUX_MM_TYPES_H */
diff -puN include/linux/sched.h~move-mm_struct-and-vm_area_struct include/linux/sched.h
--- a/include/linux/sched.h~move-mm_struct-and-vm_area_struct
+++ a/include/linux/sched.h
@@ -1,8 +1,6 @@
 #ifndef _LINUX_SCHED_H
 #define _LINUX_SCHED_H
 
-#include <linux/auxvec.h>	/* For AT_VECTOR_SIZE */
-
 /*
  * cloning flags:
  */
@@ -57,12 +55,12 @@ struct sched_param {
 #include <linux/cpumask.h>
 #include <linux/errno.h>
 #include <linux/nodemask.h>
+#include <linux/mm_types.h>
 
 #include <asm/system.h>
 #include <asm/semaphore.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
-#include <asm/mmu.h>
 #include <asm/cputime.h>
 
 #include <linux/smp.h>
@@ -317,7 +315,6 @@ extern void arch_unmap_area_topdown(stru
 #define add_mm_counter(mm, member, value) atomic_long_add(value, &(mm)->_##member)
 #define inc_mm_counter(mm, member) atomic_long_inc(&(mm)->_##member)
 #define dec_mm_counter(mm, member) atomic_long_dec(&(mm)->_##member)
-typedef atomic_long_t mm_counter_t;
 
 #else  /* NR_CPUS < CONFIG_SPLIT_PTLOCK_CPUS */
 /*
@@ -329,7 +326,6 @@ typedef atomic_long_t mm_counter_t;
 #define add_mm_counter(mm, member, value) (mm)->_##member += (value)
 #define inc_mm_counter(mm, member) (mm)->_##member++
 #define dec_mm_counter(mm, member) (mm)->_##member--
-typedef unsigned long mm_counter_t;
 
 #endif /* NR_CPUS < CONFIG_SPLIT_PTLOCK_CPUS */
 
@@ -366,74 +362,6 @@ extern int get_dumpable(struct mm_struct
 #define MMF_DUMP_FILTER_DEFAULT \
 	((1 << MMF_DUMP_ANON_PRIVATE) |	(1 << MMF_DUMP_ANON_SHARED))
 
-struct mm_struct {
-	struct vm_area_struct * mmap;		/* list of VMAs */
-	struct rb_root mm_rb;
-	struct vm_area_struct * mmap_cache;	/* last find_vma result */
-	unsigned long (*get_unmapped_area) (struct file *filp,
-				unsigned long addr, unsigned long len,
-				unsigned long pgoff, unsigned long flags);
-	void (*unmap_area) (struct mm_struct *mm, unsigned long addr);
-	unsigned long mmap_base;		/* base of mmap area */
-	unsigned long task_size;		/* size of task vm space */
-	unsigned long cached_hole_size;         /* if non-zero, the largest hole below free_area_cache */
-	unsigned long free_area_cache;		/* first hole of size cached_hole_size or larger */
-	pgd_t * pgd;
-	atomic_t mm_users;			/* How many users with user space? */
-	atomic_t mm_count;			/* How many references to "struct mm_struct" (users count as 1) */
-	int map_count;				/* number of VMAs */
-	struct rw_semaphore mmap_sem;
-	spinlock_t page_table_lock;		/* Protects page tables and some counters */
-
-	struct list_head mmlist;		/* List of maybe swapped mm's.  These are globally strung
-						 * together off init_mm.mmlist, and are protected
-						 * by mmlist_lock
-						 */
-
-	/* Special counters, in some configurations protected by the
-	 * page_table_lock, in other configurations by being atomic.
-	 */
-	mm_counter_t _file_rss;
-	mm_counter_t _anon_rss;
-
-	unsigned long hiwater_rss;	/* High-watermark of RSS usage */
-	unsigned long hiwater_vm;	/* High-water virtual memory usage */
-
-	unsigned long total_vm, locked_vm, shared_vm, exec_vm;
-	unsigned long stack_vm, reserved_vm, def_flags, nr_ptes;
-	unsigned long start_code, end_code, start_data, end_data;
-	unsigned long start_brk, brk, start_stack;
-	unsigned long arg_start, arg_end, env_start, env_end;
-
-	unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
-
-	cpumask_t cpu_vm_mask;
-
-	/* Architecture-specific MM context */
-	mm_context_t context;
-
-	/* Swap token stuff */
-	/*
-	 * Last value of global fault stamp as seen by this process.
-	 * In other words, this value gives an indication of how long
-	 * it has been since this task got the token.
-	 * Look at mm/thrash.c
-	 */
-	unsigned int faultstamp;
-	unsigned int token_priority;
-	unsigned int last_interval;
-
-	unsigned long flags; /* Must use atomic bitops to access the bits */
-
-	/* coredumping support */
-	int core_waiters;
-	struct completion *core_startup_done, core_done;
-
-	/* aio bits */
-	rwlock_t		ioctx_list_lock;
-	struct kioctx		*ioctx_list;
-};
-
 struct sighand_struct {
 	atomic_t		count;
 	struct k_sigaction	action[_NSIG];
_

Patches currently in -mm which might be from schwidefsky@de.ibm.com are

slow-down-printk-during-boot-fix-4.patch
git-s390.patch
git-wireless.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
move-mm_struct-and-vm_area_struct.patch
