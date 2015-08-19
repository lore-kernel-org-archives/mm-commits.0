From: akpm@linux-foundation.org
Subject: + schedh-dont-include-mm_typesh.patch added to -mm tree
Date: Wed, 19 Aug 2015 16:13:30 -0700
Message-ID: <55d50d9a.BWcnWb6dDF0HxQOT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbbHSXNb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Aug 2015 19:13:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, mgorman@techsingularity.net, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: sched.h: don't include mm_types.h
has been added to the -mm tree.  Its filename is
     schedh-dont-include-mm_typesh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/schedh-dont-include-mm_typesh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/schedh-dont-include-mm_typesh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sched.h: don't include mm_types.h

An attempt to untangle some of our include file mess.

sched.h presently needs the definition of mm_struct and some other mm
types (page_frag, mm_rss_stat, ...).  This ends up causing various
circular dependencies.

The patch removes the mm_struct requirement from sched.h.  All sched.h
inlines etc which referred to the mm_struct are moved elsewhere, mainly
into mm.h.

This change will break .c files which were depending on sched.h's
inclusion of mm_types.h.  They should include mm_types.h directly.

The overall approach to fixing up the inevitable fallout was to create
small, single-purpose finer grained header files:

include/linux/mm-flags.h: coredump filtering flags
include/linux/page_frag.h: the page_frag infrastructure
include/linux/mm-config.h: magic cpp calculations specific to MM
include/linux/mm-rss.h: RSS structs and defines

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdkfd/kfd_process.c |    1 
 fs/binfmt_elf.c                          |    1 
 fs/binfmt_elf_fdpic.c                    |    1 
 fs/exec.c                                |    1 
 fs/proc/base.c                           |    1 
 include/linux/khugepaged.h               |    2 
 include/linux/ksm.h                      |    1 
 include/linux/mm-config.h                |   18 +++
 include/linux/mm-flags.h                 |   48 ++++++++
 include/linux/mm-rss.h                   |   17 ++
 include/linux/mm.h                       |   67 +++++++++++
 include/linux/mm_types.h                 |   57 ---------
 include/linux/page_frag.h                |   39 ++++++
 include/linux/sched.h                    |  122 ++-------------------
 include/linux/threads.h                  |    4 
 kernel/events/uprobes.c                  |    2 
 kernel/fork.c                            |    1 
 kernel/ptrace.c                          |    1 
 kernel/sys.c                             |    1 
 kernel/user_namespace.c                  |    1 
 lib/is_single_threaded.c                 |    1 
 mm/huge_memory.c                         |    1 
 mm/ksm.c                                 |    1 
 23 files changed, 220 insertions(+), 169 deletions(-)

diff -puN include/linux/sched.h~schedh-dont-include-mm_typesh include/linux/sched.h
--- a/include/linux/sched.h~schedh-dont-include-mm_typesh
+++ a/include/linux/sched.h
@@ -22,10 +22,12 @@ struct sched_param {
 #include <linux/rbtree.h>
 #include <linux/thread_info.h>
 #include <linux/cpumask.h>
+#include <linux/mm-config.h>
+#include <linux/mm-rss.h>
 #include <linux/errno.h>
 #include <linux/nodemask.h>
-#include <linux/mm_types.h>
 #include <linux/preempt.h>
+#include <linux/page_frag.h>
 
 #include <asm/page.h>
 #include <asm/ptrace.h>
@@ -134,6 +136,7 @@ struct perf_event_context;
 struct blk_plug;
 struct filename;
 struct nameidata;
+struct mm_struct;
 
 #define VMACACHE_BITS 2
 #define VMACACHE_SIZE (1U << VMACACHE_BITS)
@@ -435,78 +438,6 @@ static inline void io_schedule(void)
 struct nsproxy;
 struct user_namespace;
 
-#ifdef CONFIG_MMU
-extern void arch_pick_mmap_layout(struct mm_struct *mm);
-extern unsigned long
-arch_get_unmapped_area(struct file *, unsigned long, unsigned long,
-		       unsigned long, unsigned long);
-extern unsigned long
-arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
-			  unsigned long len, unsigned long pgoff,
-			  unsigned long flags);
-#else
-static inline void arch_pick_mmap_layout(struct mm_struct *mm) {}
-#endif
-
-#define SUID_DUMP_DISABLE	0	/* No setuid dumping */
-#define SUID_DUMP_USER		1	/* Dump as user of process */
-#define SUID_DUMP_ROOT		2	/* Dump as root */
-
-/* mm flags */
-
-/* for SUID_DUMP_* above */
-#define MMF_DUMPABLE_BITS 2
-#define MMF_DUMPABLE_MASK ((1 << MMF_DUMPABLE_BITS) - 1)
-
-extern void set_dumpable(struct mm_struct *mm, int value);
-/*
- * This returns the actual value of the suid_dumpable flag. For things
- * that are using this for checking for privilege transitions, it must
- * test against SUID_DUMP_USER rather than treating it as a boolean
- * value.
- */
-static inline int __get_dumpable(unsigned long mm_flags)
-{
-	return mm_flags & MMF_DUMPABLE_MASK;
-}
-
-static inline int get_dumpable(struct mm_struct *mm)
-{
-	return __get_dumpable(mm->flags);
-}
-
-/* coredump filter bits */
-#define MMF_DUMP_ANON_PRIVATE	2
-#define MMF_DUMP_ANON_SHARED	3
-#define MMF_DUMP_MAPPED_PRIVATE	4
-#define MMF_DUMP_MAPPED_SHARED	5
-#define MMF_DUMP_ELF_HEADERS	6
-#define MMF_DUMP_HUGETLB_PRIVATE 7
-#define MMF_DUMP_HUGETLB_SHARED  8
-
-#define MMF_DUMP_FILTER_SHIFT	MMF_DUMPABLE_BITS
-#define MMF_DUMP_FILTER_BITS	7
-#define MMF_DUMP_FILTER_MASK \
-	(((1 << MMF_DUMP_FILTER_BITS) - 1) << MMF_DUMP_FILTER_SHIFT)
-#define MMF_DUMP_FILTER_DEFAULT \
-	((1 << MMF_DUMP_ANON_PRIVATE) |	(1 << MMF_DUMP_ANON_SHARED) |\
-	 (1 << MMF_DUMP_HUGETLB_PRIVATE) | MMF_DUMP_MASK_DEFAULT_ELF)
-
-#ifdef CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS
-# define MMF_DUMP_MASK_DEFAULT_ELF	(1 << MMF_DUMP_ELF_HEADERS)
-#else
-# define MMF_DUMP_MASK_DEFAULT_ELF	0
-#endif
-					/* leave room for more dump flags */
-#define MMF_VM_MERGEABLE	16	/* KSM may merge identical pages */
-#define MMF_VM_HUGEPAGE		17	/* set when VM_HUGEPAGE is set on vma */
-#define MMF_EXE_FILE_CHANGED	18	/* see prctl_set_mm_exe_file() */
-
-#define MMF_HAS_UPROBES		19	/* has uprobes */
-#define MMF_RECALC_UPROBES	20	/* MMF_HAS_UPROBES can be wrong */
-
-#define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
-
 struct sighand_struct {
 	atomic_t		count;
 	struct k_sigaction	action[_NSIG];
@@ -1363,6 +1294,14 @@ struct tlbflush_unmap_batch {
 	bool writable;
 };
 
+#ifdef SPLIT_RSS_COUNTING
+/* per-thread cached information, */
+struct task_rss_stat {
+	int events;	/* for synchronization threshold */
+	int count[NR_MM_COUNTERS];
+};
+#endif /* USE_SPLIT_PTE_PTLOCKS */
+
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	void *stack;
@@ -2402,9 +2341,6 @@ static inline int kstack_end(void *addr)
 
 extern union thread_union init_thread_union;
 extern struct task_struct init_task;
-
-extern struct   mm_struct init_mm;
-
 extern struct pid_namespace init_pid_ns;
 
 /*
@@ -2545,32 +2481,6 @@ static inline unsigned long sigsp(unsign
 	return sp;
 }
 
-/*
- * Routines for handling mm_structs
- */
-extern struct mm_struct * mm_alloc(void);
-
-/* mmdrop drops the mm and the page tables */
-extern void __mmdrop(struct mm_struct *);
-static inline void mmdrop(struct mm_struct * mm)
-{
-	if (unlikely(atomic_dec_and_test(&mm->mm_count)))
-		__mmdrop(mm);
-}
-
-/* mmput gets rid of the mappings and all user-space */
-extern void mmput(struct mm_struct *);
-/* Grab a reference to a task's mm, if it is not already going away */
-extern struct mm_struct *get_task_mm(struct task_struct *task);
-/*
- * Grab a reference to a task's mm, if it is not already going away
- * and ptrace_may_access with the mode parameter passed to it
- * succeeds.
- */
-extern struct mm_struct *mm_access(struct task_struct *task, unsigned int mode);
-/* Remove the current tasks stale references to the old mm_struct */
-extern void mm_release(struct task_struct *, struct mm_struct *);
-
 #ifdef CONFIG_HAVE_COPY_THREAD_TLS
 extern int copy_thread_tls(unsigned long, unsigned long, unsigned long,
 			struct task_struct *, unsigned long);
@@ -3138,14 +3048,6 @@ static inline void inc_syscw(struct task
 #define TASK_SIZE_OF(tsk)	TASK_SIZE
 #endif
 
-#ifdef CONFIG_MEMCG
-extern void mm_update_next_owner(struct mm_struct *mm);
-#else
-static inline void mm_update_next_owner(struct mm_struct *mm)
-{
-}
-#endif /* CONFIG_MEMCG */
-
 static inline unsigned long task_rlimit(const struct task_struct *tsk,
 		unsigned int limit)
 {
diff -puN include/linux/mm.h~schedh-dont-include-mm_typesh include/linux/mm.h
--- a/include/linux/mm.h~schedh-dont-include-mm_typesh
+++ a/include/linux/mm.h
@@ -14,6 +14,7 @@
 #include <linux/atomic.h>
 #include <linux/debug_locks.h>
 #include <linux/mm_types.h>
+#include <linux/mm-flags.h>
 #include <linux/range.h>
 #include <linux/pfn.h>
 #include <linux/bit_spinlock.h>
@@ -2279,5 +2280,71 @@ void __init setup_nr_node_ids(void);
 static inline void setup_nr_node_ids(void) {}
 #endif
 
+#ifdef CONFIG_MMU
+extern void arch_pick_mmap_layout(struct mm_struct *mm);
+extern unsigned long
+arch_get_unmapped_area(struct file *, unsigned long, unsigned long,
+		       unsigned long, unsigned long);
+extern unsigned long
+arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
+			  unsigned long len, unsigned long pgoff,
+			  unsigned long flags);
+#else
+static inline void arch_pick_mmap_layout(struct mm_struct *mm) {}
+#endif
+
+extern struct mm_struct init_mm;
+
+/*
+ * Routines for handling mm_structs
+ */
+extern struct mm_struct * mm_alloc(void);
+
+/* mmdrop drops the mm and the page tables */
+extern void __mmdrop(struct mm_struct *);
+static inline void mmdrop(struct mm_struct * mm)
+{
+	if (unlikely(atomic_dec_and_test(&mm->mm_count)))
+		__mmdrop(mm);
+}
+
+/* mmput gets rid of the mappings and all user-space */
+extern void mmput(struct mm_struct *);
+/* Grab a reference to a task's mm, if it is not already going away */
+extern struct mm_struct *get_task_mm(struct task_struct *task);
+/*
+ * Grab a reference to a task's mm, if it is not already going away
+ * and ptrace_may_access with the mode parameter passed to it
+ * succeeds.
+ */
+extern struct mm_struct *mm_access(struct task_struct *task, unsigned int mode);
+/* Remove the current tasks stale references to the old mm_struct */
+extern void mm_release(struct task_struct *, struct mm_struct *);
+
+#ifdef CONFIG_MEMCG
+extern void mm_update_next_owner(struct mm_struct *mm);
+#else
+static inline void mm_update_next_owner(struct mm_struct *mm)
+{
+}
+#endif /* CONFIG_MEMCG */
+
+extern void set_dumpable(struct mm_struct *mm, int value);
+/*
+ * This returns the actual value of the suid_dumpable flag. For things
+ * that are using this for checking for privilege transitions, it must
+ * test against SUID_DUMP_USER rather than treating it as a boolean
+ * value.
+ */
+static inline int __get_dumpable(unsigned long mm_flags)
+{
+	return mm_flags & MMF_DUMPABLE_MASK;
+}
+
+static inline int get_dumpable(struct mm_struct *mm)
+{
+	return __get_dumpable(mm->flags);
+}
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff -puN include/linux/mm_types.h~schedh-dont-include-mm_typesh include/linux/mm_types.h
--- a/include/linux/mm_types.h~schedh-dont-include-mm_typesh
+++ a/include/linux/mm_types.h
@@ -7,7 +7,10 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/rbtree.h>
+#include <linux/mm-config.h>
+#include <linux/mm-rss.h>
 #include <linux/rwsem.h>
+#include <linux/mm-config.h>
 #include <linux/completion.h>
 #include <linux/cpumask.h>
 #include <linux/uprobes.h>
@@ -23,11 +26,6 @@
 struct address_space;
 struct mem_cgroup;
 
-#define USE_SPLIT_PTE_PTLOCKS	(NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS)
-#define USE_SPLIT_PMD_PTLOCKS	(USE_SPLIT_PTE_PTLOCKS && \
-		IS_ENABLED(CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK))
-#define ALLOC_SPLIT_PTLOCKS	(SPINLOCK_SIZE > BITS_PER_LONG/8)
-
 typedef void compound_page_dtor(struct page *);
 
 /*
@@ -206,35 +204,6 @@ struct page {
 #endif
 ;
 
-struct page_frag {
-	struct page *page;
-#if (BITS_PER_LONG > 32) || (PAGE_SIZE >= 65536)
-	__u32 offset;
-	__u32 size;
-#else
-	__u16 offset;
-	__u16 size;
-#endif
-};
-
-#define PAGE_FRAG_CACHE_MAX_SIZE	__ALIGN_MASK(32768, ~PAGE_MASK)
-#define PAGE_FRAG_CACHE_MAX_ORDER	get_order(PAGE_FRAG_CACHE_MAX_SIZE)
-
-struct page_frag_cache {
-	void * va;
-#if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
-	__u16 offset;
-	__u16 size;
-#else
-	__u32 offset;
-#endif
-	/* we maintain a pagecount bias, so that we dont dirty cache line
-	 * containing page->_count every time we allocate a fragment.
-	 */
-	unsigned int		pagecnt_bias;
-	bool pfmemalloc;
-};
-
 typedef unsigned long vm_flags_t;
 
 /*
@@ -346,26 +315,6 @@ struct core_state {
 	struct completion startup;
 };
 
-enum {
-	MM_FILEPAGES,
-	MM_ANONPAGES,
-	MM_SWAPENTS,
-	NR_MM_COUNTERS
-};
-
-#if USE_SPLIT_PTE_PTLOCKS && defined(CONFIG_MMU)
-#define SPLIT_RSS_COUNTING
-/* per-thread cached information, */
-struct task_rss_stat {
-	int events;	/* for synchronization threshold */
-	int count[NR_MM_COUNTERS];
-};
-#endif /* USE_SPLIT_PTE_PTLOCKS */
-
-struct mm_rss_stat {
-	atomic_long_t count[NR_MM_COUNTERS];
-};
-
 #ifdef CONFIG_HUGETLB_PAGE
 
 #ifndef HUGE_MAX_HSTATE
diff -puN /dev/null include/linux/mm-flags.h
--- /dev/null
+++ a/include/linux/mm-flags.h
@@ -0,0 +1,48 @@
+#ifndef MM_FLAGS_H_INCLUDED
+#define MM_FLAGS_H_INCLUDED
+
+#include <linux/mm_types.h>
+
+/* mm flags */
+
+#define SUID_DUMP_DISABLE	0	/* No setuid dumping */
+#define SUID_DUMP_USER		1	/* Dump as user of process */
+#define SUID_DUMP_ROOT		2	/* Dump as root */
+
+/* for SUID_DUMP_* above */
+#define MMF_DUMPABLE_BITS 2
+#define MMF_DUMPABLE_MASK ((1 << MMF_DUMPABLE_BITS) - 1)
+
+/* coredump filter bits */
+#define MMF_DUMP_ANON_PRIVATE	2
+#define MMF_DUMP_ANON_SHARED	3
+#define MMF_DUMP_MAPPED_PRIVATE	4
+#define MMF_DUMP_MAPPED_SHARED	5
+#define MMF_DUMP_ELF_HEADERS	6
+#define MMF_DUMP_HUGETLB_PRIVATE 7
+#define MMF_DUMP_HUGETLB_SHARED  8
+
+#define MMF_DUMP_FILTER_SHIFT	MMF_DUMPABLE_BITS
+#define MMF_DUMP_FILTER_BITS	7
+#define MMF_DUMP_FILTER_MASK \
+	(((1 << MMF_DUMP_FILTER_BITS) - 1) << MMF_DUMP_FILTER_SHIFT)
+#define MMF_DUMP_FILTER_DEFAULT \
+	((1 << MMF_DUMP_ANON_PRIVATE) |	(1 << MMF_DUMP_ANON_SHARED) |\
+	 (1 << MMF_DUMP_HUGETLB_PRIVATE) | MMF_DUMP_MASK_DEFAULT_ELF)
+
+#ifdef CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS
+# define MMF_DUMP_MASK_DEFAULT_ELF	(1 << MMF_DUMP_ELF_HEADERS)
+#else
+# define MMF_DUMP_MASK_DEFAULT_ELF	0
+#endif
+					/* leave room for more dump flags */
+#define MMF_VM_MERGEABLE	16	/* KSM may merge identical pages */
+#define MMF_VM_HUGEPAGE		17	/* set when VM_HUGEPAGE is set on vma */
+#define MMF_EXE_FILE_CHANGED	18	/* see prctl_set_mm_exe_file() */
+
+#define MMF_HAS_UPROBES		19	/* has uprobes */
+#define MMF_RECALC_UPROBES	20	/* MMF_HAS_UPROBES can be wrong */
+
+#define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
+
+#endif		/* MM_FLAGS_H_INCLUDED */
diff -puN fs/binfmt_elf.c~schedh-dont-include-mm_typesh fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~schedh-dont-include-mm_typesh
+++ a/fs/binfmt_elf.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/mm-flags.h>
 #include <linux/mman.h>
 #include <linux/errno.h>
 #include <linux/signal.h>
diff -puN fs/binfmt_elf_fdpic.c~schedh-dont-include-mm_typesh fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~schedh-dont-include-mm_typesh
+++ a/fs/binfmt_elf_fdpic.c
@@ -16,6 +16,7 @@
 #include <linux/stat.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/mm-flags.h>
 #include <linux/mman.h>
 #include <linux/errno.h>
 #include <linux/signal.h>
diff -puN kernel/fork.c~schedh-dont-include-mm_typesh kernel/fork.c
--- a/kernel/fork.c~schedh-dont-include-mm_typesh
+++ a/kernel/fork.c
@@ -29,6 +29,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/mm-flags.h>
 #include <linux/vmacache.h>
 #include <linux/nsproxy.h>
 #include <linux/capability.h>
diff -puN kernel/sys.c~schedh-dont-include-mm_typesh kernel/sys.c
--- a/kernel/sys.c~schedh-dont-include-mm_typesh
+++ a/kernel/sys.c
@@ -6,6 +6,7 @@
 
 #include <linux/export.h>
 #include <linux/mm.h>
+#include <linux/mm-flags.h>
 #include <linux/utsname.h>
 #include <linux/mman.h>
 #include <linux/reboot.h>
diff -puN mm/huge_memory.c~schedh-dont-include-mm_typesh mm/huge_memory.c
--- a/mm/huge_memory.c~schedh-dont-include-mm_typesh
+++ a/mm/huge_memory.c
@@ -8,6 +8,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/mm.h>
+#include <linux/mm-flags.h>
 #include <linux/sched.h>
 #include <linux/highmem.h>
 #include <linux/hugetlb.h>
diff -puN mm/ksm.c~schedh-dont-include-mm_typesh mm/ksm.c
--- a/mm/ksm.c~schedh-dont-include-mm_typesh
+++ a/mm/ksm.c
@@ -16,6 +16,7 @@
 
 #include <linux/errno.h>
 #include <linux/mm.h>
+#include <linux/mm-flags.h>
 #include <linux/fs.h>
 #include <linux/mman.h>
 #include <linux/sched.h>
diff -puN include/linux/khugepaged.h~schedh-dont-include-mm_typesh include/linux/khugepaged.h
--- a/include/linux/khugepaged.h~schedh-dont-include-mm_typesh
+++ a/include/linux/khugepaged.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_KHUGEPAGED_H
 #define _LINUX_KHUGEPAGED_H
 
-#include <linux/sched.h> /* MMF_VM_HUGEPAGE */
+#include <linux/mm-flags.h> /* MMF_VM_HUGEPAGE */
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern int __khugepaged_enter(struct mm_struct *mm);
diff -puN include/linux/ksm.h~schedh-dont-include-mm_typesh include/linux/ksm.h
--- a/include/linux/ksm.h~schedh-dont-include-mm_typesh
+++ a/include/linux/ksm.h
@@ -9,6 +9,7 @@
 
 #include <linux/bitops.h>
 #include <linux/mm.h>
+#include <linux/mm-flags.h>
 #include <linux/pagemap.h>
 #include <linux/rmap.h>
 #include <linux/sched.h>
diff -puN fs/exec.c~schedh-dont-include-mm_typesh fs/exec.c
--- a/fs/exec.c~schedh-dont-include-mm_typesh
+++ a/fs/exec.c
@@ -26,6 +26,7 @@
 #include <linux/file.h>
 #include <linux/fdtable.h>
 #include <linux/mm.h>
+#include <linux/mm-flags.h>
 #include <linux/vmacache.h>
 #include <linux/stat.h>
 #include <linux/fcntl.h>
diff -puN fs/proc/base.c~schedh-dont-include-mm_typesh fs/proc/base.c
--- a/fs/proc/base.c~schedh-dont-include-mm_typesh
+++ a/fs/proc/base.c
@@ -63,6 +63,7 @@
 #include <linux/namei.h>
 #include <linux/mnt_namespace.h>
 #include <linux/mm.h>
+#include <linux/mm-flags.h>
 #include <linux/swap.h>
 #include <linux/rcupdate.h>
 #include <linux/kallsyms.h>
diff -puN kernel/events/uprobes.c~schedh-dont-include-mm_typesh kernel/events/uprobes.c
--- a/kernel/events/uprobes.c~schedh-dont-include-mm_typesh
+++ a/kernel/events/uprobes.c
@@ -27,6 +27,8 @@
 #include <linux/pagemap.h>	/* read_mapping_page */
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/mm-flags.h>
 #include <linux/export.h>
 #include <linux/rmap.h>		/* anon_vma_prepare */
 #include <linux/mmu_notifier.h>	/* set_pte_at_notify */
diff -puN /dev/null include/linux/page_frag.h
--- /dev/null
+++ a/include/linux/page_frag.h
@@ -0,0 +1,39 @@
+#ifndef PAGE_FRAG_H_INCLUDED
+#define PAGE_FRAG_H_INCLUDED
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <asm-generic/getorder.h>
+
+struct page;
+
+struct page_frag {
+	struct page *page;
+#if (BITS_PER_LONG > 32) || (PAGE_SIZE >= 65536)
+	__u32 offset;
+	__u32 size;
+#else
+	__u16 offset;
+	__u16 size;
+#endif
+};
+
+#define PAGE_FRAG_CACHE_MAX_SIZE	__ALIGN_MASK(32768, ~PAGE_MASK)
+#define PAGE_FRAG_CACHE_MAX_ORDER	get_order(PAGE_FRAG_CACHE_MAX_SIZE)
+
+struct page_frag_cache {
+	void * va;
+#if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
+	__u16 offset;
+	__u16 size;
+#else
+	__u32 offset;
+#endif
+	/* we maintain a pagecount bias, so that we dont dirty cache line
+	 * containing page->_count every time we allocate a fragment.
+	 */
+	unsigned int		pagecnt_bias;
+	bool pfmemalloc;
+};
+
+#endif		/* PAGE_FRAG_H_INCLUDED */
diff -puN /dev/null include/linux/mm-config.h
--- /dev/null
+++ a/include/linux/mm-config.h
@@ -0,0 +1,18 @@
+#ifndef LINUX_MM_CONFIG_H_INCLUDED
+#define LINUX_MM_CONFIG_H_INCLUDED
+
+/*
+ * mm-config.h is the place where new mm-related #defines are calculated from
+ * Kconfig variables.  And related activities, perhaps.
+ */
+
+#define USE_SPLIT_PTE_PTLOCKS	(CONFIG_NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS)
+#define USE_SPLIT_PMD_PTLOCKS	(USE_SPLIT_PTE_PTLOCKS && \
+		IS_ENABLED(CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK))
+#define ALLOC_SPLIT_PTLOCKS	(SPINLOCK_SIZE > BITS_PER_LONG/8)
+
+#if USE_SPLIT_PTE_PTLOCKS && defined(CONFIG_MMU)
+#define SPLIT_RSS_COUNTING
+#endif
+
+#endif		/* LINUX_MM_CONFIG_H_INCLUDED */
diff -puN include/linux/threads.h~schedh-dont-include-mm_typesh include/linux/threads.h
--- a/include/linux/threads.h~schedh-dont-include-mm_typesh
+++ a/include/linux/threads.h
@@ -11,10 +11,6 @@
  * Maximum supported processors.  Setting this smaller saves quite a
  * bit of memory.  Use nr_cpu_ids instead of this except for static bitmaps.
  */
-#ifndef CONFIG_NR_CPUS
-/* FIXME: This should be fixed in the arch's Kconfig */
-#define CONFIG_NR_CPUS	1
-#endif
 
 /* Places which use this should consider cpumask_var_t. */
 #define NR_CPUS		CONFIG_NR_CPUS
diff -puN kernel/ptrace.c~schedh-dont-include-mm_typesh kernel/ptrace.c
--- a/kernel/ptrace.c~schedh-dont-include-mm_typesh
+++ a/kernel/ptrace.c
@@ -12,6 +12,7 @@
 #include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/mm.h>
+#include <linux/mm-flags.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
 #include <linux/ptrace.h>
diff -puN kernel/cred.c~schedh-dont-include-mm_typesh kernel/cred.c
diff -puN /dev/null include/linux/mm-rss.h
--- /dev/null
+++ a/include/linux/mm-rss.h
@@ -0,0 +1,17 @@
+#ifndef MM_RSS_H_INCLUDED
+#define MM_RSS_H_INCLUDED
+
+#include <asm-generic/atomic-long.h>
+
+enum {
+	MM_FILEPAGES,
+	MM_ANONPAGES,
+	MM_SWAPENTS,
+	NR_MM_COUNTERS
+};
+
+struct mm_rss_stat {
+	atomic_long_t count[NR_MM_COUNTERS];
+};
+
+#endif		/* MM_RSS_H_INCLUDED */
diff -puN kernel/user_namespace.c~schedh-dont-include-mm_typesh kernel/user_namespace.c
--- a/kernel/user_namespace.c~schedh-dont-include-mm_typesh
+++ a/kernel/user_namespace.c
@@ -14,6 +14,7 @@
 #include <linux/cred.h>
 #include <linux/securebits.h>
 #include <linux/keyctl.h>
+#include <linux/mm_types.h>
 #include <linux/key-type.h>
 #include <keys/user-type.h>
 #include <linux/seq_file.h>
diff -puN lib/is_single_threaded.c~schedh-dont-include-mm_typesh lib/is_single_threaded.c
--- a/lib/is_single_threaded.c~schedh-dont-include-mm_typesh
+++ a/lib/is_single_threaded.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/sched.h>
+#include <linux/mm_types.h>
 
 /*
  * Returns true if the task does not share ->mm with another thread/process.
diff -puN drivers/gpu/drm/amd/amdkfd/kfd_process.c~schedh-dont-include-mm_typesh drivers/gpu/drm/amd/amdkfd/kfd_process.c
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c~schedh-dont-include-mm_typesh
+++ a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -23,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/log2.h>
 #include <linux/sched.h>
+#include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/amd-iommu.h>
 #include <linux/notifier.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
mm-make-page-pfmemalloc-check-more-robust-fix.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
ocfs2-sysfile-interfaces-for-online-file-check-fix.patch
fs-create-and-use-seq_show_option-for-escaping-fix.patch
watchdog-introduce-watchdog_suspend-and-watchdog_resume-fix.patch
watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix.patch
mm.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
genalloc-add-support-of-multiple-gen_pools-per-device-fix.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
dax-revert-userfaultfd-change.patch
thp-prepare-for-dax-huge-pages-fix.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch
pagemap-update-documentation-fix.patch
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch
mm-srcu-ify-shrinkers-fix-fix.patch
x86-use-generic-early-mem-copy-fix.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-fix-2.patch
mm-mmap-simplify-the-failure-return-working-flow-fix.patch
zswap-dynamic-pool-creation-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
proc-add-kpageidle-file-fix-6-fix.patch
proc-add-kpageidle-file-fix-6-fix-2-fix.patch
proc-export-idle-flag-via-kpageflags-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix-fix.patch
kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch
align-crash_notes-allocation-to-make-it-be-inside-one-physical-page-fix.patch
linux-next.patch
linux-next-rejects.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes.patch
schedh-dont-include-mm_typesh.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

