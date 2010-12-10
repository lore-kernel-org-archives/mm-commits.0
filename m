From: akpm@linux-foundation.org
Subject: + mm-numa-aware-alloc_thread_info_node.patch added to -mm tree
Date: Thu, 09 Dec 2010 16:44:54 -0800
Message-ID: <201012100044.oBA0isSK016987__6984.48715634203$1291941931$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757636Ab0LJApL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2010 19:45:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.dumazet@gmail.com, ak@linux.intel.com, davem@davemloft.net, dhowells@redhat.com, fenghua.yu@intel.com, linux-arch@vger.kernel.org, rusty@rustcorp.com.au, tj@kernel.org, tony.luck@intel.com


The patch titled
     mm: NUMA aware alloc_thread_info_node()
has been added to the -mm tree.  Its filename is
     mm-numa-aware-alloc_thread_info_node.patch

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
Subject: mm: NUMA aware alloc_thread_info_node()
From: Eric Dumazet <eric.dumazet@gmail.com>

Add a node parameter to alloc_thread_info(), and change its name to
alloc_thread_info_node()

This change is needed to allow NUMA aware kthread_create_on_cpu()

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: David Howells <dhowells@redhat.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/include/asm/thread_info.h     |    2 -
 arch/frv/include/asm/thread_info.h      |   13 +++--------
 arch/ia64/include/asm/thread_info.h     |    5 ++--
 arch/m32r/include/asm/thread_info.h     |   13 +++--------
 arch/mips/include/asm/thread_info.h     |    6 +++--
 arch/mn10300/include/asm/thread_info.h  |    6 +++--
 arch/powerpc/include/asm/thread_info.h  |    2 -
 arch/powerpc/kernel/process.c           |    4 +--
 arch/score/include/asm/thread_info.h    |    2 -
 arch/sh/include/asm/thread_info.h       |    2 -
 arch/sh/kernel/process.c                |   16 ++++++++------
 arch/sparc/include/asm/thread_info_32.h |    6 ++---
 arch/sparc/include/asm/thread_info_64.h |   24 +++++++++++-----------
 arch/sparc/mm/srmmu.c                   |    4 +--
 arch/sparc/mm/sun4c.c                   |    4 +--
 arch/tile/include/asm/thread_info.h     |    2 -
 arch/tile/kernel/process.c              |    4 +--
 arch/x86/include/asm/thread_info.h      |   10 +++++++--
 kernel/fork.c                           |    9 +++++---
 19 files changed, 70 insertions(+), 64 deletions(-)

diff -puN arch/cris/include/asm/thread_info.h~mm-numa-aware-alloc_thread_info_node arch/cris/include/asm/thread_info.h
--- a/arch/cris/include/asm/thread_info.h~mm-numa-aware-alloc_thread_info_node
+++ a/arch/cris/include/asm/thread_info.h
@@ -68,7 +68,7 @@ struct thread_info {
 #define init_thread_info	(init_thread_union.thread_info)
 
 /* thread information allocation */
-#define alloc_thread_info(tsk) ((struct thread_info *) __get_free_pages(GFP_KERNEL,1))
+#define alloc_thread_info(tsk, node) ((struct thread_info *) __get_free_pages(GFP_KERNEL,1))
 #define free_thread_info(ti) free_pages((unsigned long) (ti), 1)
 
 #endif /* !__ASSEMBLY__ */
diff -puN arch/frv/include/asm/thread_info.h~mm-numa-aware-alloc_thread_info_node arch/frv/include/asm/thread_info.h
--- a/arch/frv/include/asm/thread_info.h~mm-numa-aware-alloc_thread_info_node
+++ a/arch/frv/include/asm/thread_info.h
@@ -84,16 +84,11 @@ register struct thread_info *__current_t
 
 /* thread information allocation */
 #ifdef CONFIG_DEBUG_STACK_USAGE
-#define alloc_thread_info(tsk)					\
-	({							\
-		struct thread_info *ret;			\
-								\
-		ret = kzalloc(THREAD_SIZE, GFP_KERNEL);		\
-								\
-		ret;						\
-	})
+#define alloc_thread_info_node(tsk, node)			\
+		kzalloc_node(THREAD_SIZE, GFP_KERNEL, node)
 #else
-#define alloc_thread_info(tsk)	kmalloc(THREAD_SIZE, GFP_KERNEL)
+#define alloc_thread_info_node(tsk)				\
+		kmalloc_node(THREAD_SIZE, GFP_KERNEL, node)
 #endif
 
 #define free_thread_info(info)	kfree(info)
diff -puN arch/ia64/include/asm/thread_info.h~mm-numa-aware-alloc_thread_info_node arch/ia64/include/asm/thread_info.h
--- a/arch/ia64/include/asm/thread_info.h~mm-numa-aware-alloc_thread_info_node
+++ a/arch/ia64/include/asm/thread_info.h
@@ -59,11 +59,12 @@ struct thread_info {
 #ifndef ASM_OFFSETS_C
 /* how to get the thread information struct from C */
 #define current_thread_info()	((struct thread_info *) ((char *) current + IA64_TASK_SIZE))
-#define alloc_thread_info(tsk)	((struct thread_info *) ((char *) (tsk) + IA64_TASK_SIZE))
+#define alloc_thread_info_node(tsk, node)	\
+		((struct thread_info *) ((char *) (tsk) + IA64_TASK_SIZE))
 #define task_thread_info(tsk)	((struct thread_info *) ((char *) (tsk) + IA64_TASK_SIZE))
 #else
 #define current_thread_info()	((struct thread_info *) 0)
-#define alloc_thread_info(tsk)	((struct thread_info *) 0)
+#define alloc_thread_info_node(tsk, node)	((struct thread_info *) 0)
 #define task_thread_info(tsk)	((struct thread_info *) 0)
 #endif
 #define free_thread_info(ti)	/* nothing */
diff -puN arch/m32r/include/asm/thread_info.h~mm-numa-aware-alloc_thread_info_node arch/m32r/include/asm/thread_info.h
--- a/arch/m32r/include/asm/thread_info.h~mm-numa-aware-alloc_thread_info_node
+++ a/arch/m32r/include/asm/thread_info.h
@@ -96,16 +96,11 @@ static inline struct thread_info *curren
 
 /* thread information allocation */
 #ifdef CONFIG_DEBUG_STACK_USAGE
-#define alloc_thread_info(tsk)					\
-	({							\
-		struct thread_info *ret;			\
-	 							\
-	 	ret = kzalloc(THREAD_SIZE, GFP_KERNEL);		\
-								\
-	 	ret;						\
-	 })
+#define alloc_thread_info_node(tsk, node)			\
+		kzalloc_node(THREAD_SIZE, GFP_KERNEL, node)
 #else
-#define alloc_thread_info(tsk) kmalloc(THREAD_SIZE, GFP_KERNEL)
+#define alloc_thread_info_node(tsk, node)			\
+		kmalloc_node(THREAD_SIZE, GFP_KERNEL, node)
 #endif
 
 #define free_thread_info(info) kfree(info)
diff -puN arch/mips/include/asm/thread_info.h~mm-numa-aware-alloc_thread_info_node arch/mips/include/asm/thread_info.h
--- a/arch/mips/include/asm/thread_info.h~mm-numa-aware-alloc_thread_info_node
+++ a/arch/mips/include/asm/thread_info.h
@@ -88,9 +88,11 @@ register struct thread_info *__current_t
 #define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
 
 #ifdef CONFIG_DEBUG_STACK_USAGE
-#define alloc_thread_info(tsk) kzalloc(THREAD_SIZE, GFP_KERNEL)
+#define alloc_thread_info_node(tsk, node) \
+		kzalloc_node(THREAD_SIZE, GFP_KERNEL, node)
 #else
-#define alloc_thread_info(tsk) kmalloc(THREAD_SIZE, GFP_KERNEL)
+#define alloc_thread_info_node(tsk, node) \
+		kmalloc_node(THREAD_SIZE, GFP_KERNEL, node)
 #endif
 
 #define free_thread_info(info) kfree(info)
diff -puN arch/mn10300/include/asm/thread_info.h~mm-numa-aware-alloc_thread_info_node arch/mn10300/include/asm/thread_info.h
--- a/arch/mn10300/include/asm/thread_info.h~mm-numa-aware-alloc_thread_info_node
+++ a/arch/mn10300/include/asm/thread_info.h
@@ -124,9 +124,11 @@ static inline unsigned long current_stac
 
 /* thread information allocation */
 #ifdef CONFIG_DEBUG_STACK_USAGE
-#define alloc_thread_info(tsk) kzalloc(THREAD_SIZE, GFP_KERNEL)
+#define alloc_thread_info_node(tsk, node)			\
+		kzalloc_node(THREAD_SIZE, GFP_KERNEL, node)
 #else
-#define alloc_thread_info(tsk) kmalloc(THREAD_SIZE, GFP_KERNEL)
+#define alloc_thread_info_node(tsk, node)			\
+		kmalloc_node(THREAD_SIZE, GFP_KERNEL, node)
 #endif
 
 #define free_thread_info(ti)	kfree((ti))
diff -puN arch/powerpc/include/asm/thread_info.h~mm-numa-aware-alloc_thread_info_node arch/powerpc/include/asm/thread_info.h
--- a/arch/powerpc/include/asm/thread_info.h~mm-numa-aware-alloc_thread_info_node
+++ a/arch/powerpc/include/asm/thread_info.h
@@ -72,7 +72,7 @@ struct thread_info {
 
 #define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
 
-extern struct thread_info *alloc_thread_info(struct task_struct *tsk);
+extern struct thread_info *alloc_thread_info_node(struct task_struct *tsk, int node);
 extern void free_thread_info(struct thread_info *ti);
 
 #endif /* THREAD_SHIFT < PAGE_SHIFT */
diff -puN arch/powerpc/kernel/process.c~mm-numa-aware-alloc_thread_info_node arch/powerpc/kernel/process.c
--- a/arch/powerpc/kernel/process.c~mm-numa-aware-alloc_thread_info_node
+++ a/arch/powerpc/kernel/process.c
@@ -1216,11 +1216,11 @@ void __ppc64_runlatch_off(void)
 
 static struct kmem_cache *thread_info_cache;
 
-struct thread_info *alloc_thread_info(struct task_struct *tsk)
+struct thread_info *alloc_thread_info_node(struct task_struct *tsk, int node)
 {
 	struct thread_info *ti;
 
-	ti = kmem_cache_alloc(thread_info_cache, GFP_KERNEL);
+	ti = kmem_cache_alloc_node(thread_info_cache, GFP_KERNEL, node);
 	if (unlikely(ti == NULL))
 		return NULL;
 #ifdef CONFIG_DEBUG_STACK_USAGE
diff -puN arch/score/include/asm/thread_info.h~mm-numa-aware-alloc_thread_info_node arch/score/include/asm/thread_info.h
--- a/arch/score/include/asm/thread_info.h~mm-numa-aware-alloc_thread_info_node
+++ a/arch/score/include/asm/thread_info.h
@@ -71,7 +71,7 @@ struct thread_info {
 register struct thread_info *__current_thread_info __asm__("r28");
 #define current_thread_info()	__current_thread_info
 
-#define alloc_thread_info(tsk) kmalloc(THREAD_SIZE, GFP_KERNEL)
+#define alloc_thread_info_node(tsk, node) kmalloc_node(THREAD_SIZE, GFP_KERNEL, node)
 #define free_thread_info(info) kfree(info)
 
 #endif /* !__ASSEMBLY__ */
diff -puN arch/sh/include/asm/thread_info.h~mm-numa-aware-alloc_thread_info_node arch/sh/include/asm/thread_info.h
--- a/arch/sh/include/asm/thread_info.h~mm-numa-aware-alloc_thread_info_node
+++ a/arch/sh/include/asm/thread_info.h
@@ -95,7 +95,7 @@ static inline struct thread_info *curren
 
 #endif
 
-extern struct thread_info *alloc_thread_info(struct task_struct *tsk);
+extern struct thread_info *alloc_thread_info_node(struct task_struct *tsk, int node);
 extern void free_thread_info(struct thread_info *ti);
 extern void arch_task_cache_init(void);
 #define arch_task_cache_init arch_task_cache_init
diff -puN arch/sh/kernel/process.c~mm-numa-aware-alloc_thread_info_node arch/sh/kernel/process.c
--- a/arch/sh/kernel/process.c~mm-numa-aware-alloc_thread_info_node
+++ a/arch/sh/kernel/process.c
@@ -32,16 +32,16 @@ void free_thread_xstate(struct task_stru
 #if THREAD_SHIFT < PAGE_SHIFT
 static struct kmem_cache *thread_info_cache;
 
-struct thread_info *alloc_thread_info(struct task_struct *tsk)
+struct thread_info *alloc_thread_info(struct task_struct *tsk, int node)
 {
 	struct thread_info *ti;
-
-	ti = kmem_cache_alloc(thread_info_cache, GFP_KERNEL);
-	if (unlikely(ti == NULL))
-		return NULL;
 #ifdef CONFIG_DEBUG_STACK_USAGE
-	memset(ti, 0, THREAD_SIZE);
+	gfp_t mask = GFP_KERNEL | __GFP_ZERO;
+#else
+	gfp_t mask = GFP_KERNEL;
 #endif
+
+	ti = kmem_cache_alloc_node(thread_info_cache, mask, node);
 	return ti;
 }
 
@@ -64,7 +64,9 @@ struct thread_info *alloc_thread_info(st
 #else
 	gfp_t mask = GFP_KERNEL;
 #endif
-	return (struct thread_info *)__get_free_pages(mask, THREAD_SIZE_ORDER);
+	struct page *page = alloc_pages_node(node, mask, THREAD_SIZE_ORDER);
+
+	return page ? page_address(page) : NULL;
 }
 
 void free_thread_info(struct thread_info *ti)
diff -puN arch/sparc/include/asm/thread_info_32.h~mm-numa-aware-alloc_thread_info_node arch/sparc/include/asm/thread_info_32.h
--- a/arch/sparc/include/asm/thread_info_32.h~mm-numa-aware-alloc_thread_info_node
+++ a/arch/sparc/include/asm/thread_info_32.h
@@ -82,8 +82,8 @@ register struct thread_info *current_thr
 
 #define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
 
-BTFIXUPDEF_CALL(struct thread_info *, alloc_thread_info, void)
-#define alloc_thread_info(tsk) BTFIXUP_CALL(alloc_thread_info)()
+BTFIXUPDEF_CALL(struct thread_info *, alloc_thread_info_node, int)
+#define alloc_thread_info_node(tsk, node) BTFIXUP_CALL(alloc_thread_info_node)(node)
 
 BTFIXUPDEF_CALL(void, free_thread_info, struct thread_info *)
 #define free_thread_info(ti) BTFIXUP_CALL(free_thread_info)(ti)
@@ -92,7 +92,7 @@ BTFIXUPDEF_CALL(void, free_thread_info, 
 
 /*
  * Size of kernel stack for each process.
- * Observe the order of get_free_pages() in alloc_thread_info().
+ * Observe the order of get_free_pages() in alloc_thread_info_node().
  * The sun4 has 8K stack too, because it's short on memory, and 16K is a waste.
  */
 #define THREAD_SIZE		8192
diff -puN arch/sparc/include/asm/thread_info_64.h~mm-numa-aware-alloc_thread_info_node arch/sparc/include/asm/thread_info_64.h
--- a/arch/sparc/include/asm/thread_info_64.h~mm-numa-aware-alloc_thread_info_node
+++ a/arch/sparc/include/asm/thread_info_64.h
@@ -146,21 +146,21 @@ register struct thread_info *current_thr
 #define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
 
 #ifdef CONFIG_DEBUG_STACK_USAGE
-#define alloc_thread_info(tsk)					\
-({								\
-	struct thread_info *ret;				\
-								\
-	ret = (struct thread_info *)				\
-	  __get_free_pages(GFP_KERNEL, __THREAD_INFO_ORDER);	\
-	if (ret)						\
-		memset(ret, 0, PAGE_SIZE<<__THREAD_INFO_ORDER);	\
-	ret;							\
-})
+#define THREAD_FLAGS (GFP_KERNEL | __GFP_ZERO)
 #else
-#define alloc_thread_info(tsk) \
-	((struct thread_info *)__get_free_pages(GFP_KERNEL, __THREAD_INFO_ORDER))
+#define THREAD_FLAGS (GFP_KERNEL)
 #endif
 
+#define alloc_thread_info_node(tsk, node)				\
+({									\
+	struct page *page = alloc_pages_node(node, THREAD_FLAGS,	\
+					     __THREAD_INFO_ORDER);	\
+	struct thread_info *ret;					\
+									\
+	ret = page ? page_address(page) : NULL;				\
+	ret;								\
+})
+
 #define free_thread_info(ti) \
 	free_pages((unsigned long)(ti),__THREAD_INFO_ORDER)
 
diff -puN arch/sparc/mm/srmmu.c~mm-numa-aware-alloc_thread_info_node arch/sparc/mm/srmmu.c
--- a/arch/sparc/mm/srmmu.c~mm-numa-aware-alloc_thread_info_node
+++ a/arch/sparc/mm/srmmu.c
@@ -650,7 +650,7 @@ static void srmmu_unmapiorange(unsigned 
  * mappings on the kernel stack without any special code as we did
  * need on the sun4c.
  */
-static struct thread_info *srmmu_alloc_thread_info(void)
+static struct thread_info *srmmu_alloc_thread_info_node(int node)
 {
 	struct thread_info *ret;
 
@@ -2271,7 +2271,7 @@ void __init ld_mmu_srmmu(void)
 
 	BTFIXUPSET_CALL(mmu_info, srmmu_mmu_info, BTFIXUPCALL_NORM);
 
-	BTFIXUPSET_CALL(alloc_thread_info, srmmu_alloc_thread_info, BTFIXUPCALL_NORM);
+	BTFIXUPSET_CALL(alloc_thread_info_node, srmmu_alloc_thread_info_node, BTFIXUPCALL_NORM);
 	BTFIXUPSET_CALL(free_thread_info, srmmu_free_thread_info, BTFIXUPCALL_NORM);
 
 	BTFIXUPSET_CALL(pte_to_pgoff, srmmu_pte_to_pgoff, BTFIXUPCALL_NORM);
diff -puN arch/sparc/mm/sun4c.c~mm-numa-aware-alloc_thread_info_node arch/sparc/mm/sun4c.c
--- a/arch/sparc/mm/sun4c.c~mm-numa-aware-alloc_thread_info_node
+++ a/arch/sparc/mm/sun4c.c
@@ -924,7 +924,7 @@ static inline void garbage_collect(int e
 	free_locked_segment(BUCKET_ADDR(entry));
 }
 
-static struct thread_info *sun4c_alloc_thread_info(void)
+static struct thread_info *sun4c_alloc_thread_info_node(int node)
 {
 	unsigned long addr, pages;
 	int entry;
@@ -2157,7 +2157,7 @@ void __init ld_mmu_sun4c(void)
 	BTFIXUPSET_CALL(__swp_offset, sun4c_swp_offset, BTFIXUPCALL_NORM);
 	BTFIXUPSET_CALL(__swp_entry, sun4c_swp_entry, BTFIXUPCALL_NORM);
 
-	BTFIXUPSET_CALL(alloc_thread_info, sun4c_alloc_thread_info, BTFIXUPCALL_NORM);
+	BTFIXUPSET_CALL(alloc_thread_info_node, sun4c_alloc_thread_info_node, BTFIXUPCALL_NORM);
 	BTFIXUPSET_CALL(free_thread_info, sun4c_free_thread_info, BTFIXUPCALL_NORM);
 
 	BTFIXUPSET_CALL(mmu_info, sun4c_mmu_info, BTFIXUPCALL_NORM);
diff -puN arch/tile/include/asm/thread_info.h~mm-numa-aware-alloc_thread_info_node arch/tile/include/asm/thread_info.h
--- a/arch/tile/include/asm/thread_info.h~mm-numa-aware-alloc_thread_info_node
+++ a/arch/tile/include/asm/thread_info.h
@@ -83,7 +83,7 @@ register unsigned long stack_pointer __a
   ((struct thread_info *)(stack_pointer & -THREAD_SIZE))
 
 #define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-extern struct thread_info *alloc_thread_info(struct task_struct *task);
+extern struct thread_info *alloc_thread_info_node(struct task_struct *task, int node);
 extern void free_thread_info(struct thread_info *info);
 
 /* Sit on a nap instruction until interrupted. */
diff -puN arch/tile/kernel/process.c~mm-numa-aware-alloc_thread_info_node arch/tile/kernel/process.c
--- a/arch/tile/kernel/process.c~mm-numa-aware-alloc_thread_info_node
+++ a/arch/tile/kernel/process.c
@@ -109,7 +109,7 @@ void cpu_idle(void)
 	}
 }
 
-struct thread_info *alloc_thread_info(struct task_struct *task)
+struct thread_info *alloc_thread_info_node(struct task_struct *task, int node)
 {
 	struct page *page;
 	gfp_t flags = GFP_KERNEL;
@@ -118,7 +118,7 @@ struct thread_info *alloc_thread_info(st
 	flags |= __GFP_ZERO;
 #endif
 
-	page = alloc_pages(flags, THREAD_SIZE_ORDER);
+	page = alloc_pages_node(node, flags, THREAD_SIZE_ORDER);
 	if (!page)
 		return NULL;
 
diff -puN arch/x86/include/asm/thread_info.h~mm-numa-aware-alloc_thread_info_node arch/x86/include/asm/thread_info.h
--- a/arch/x86/include/asm/thread_info.h~mm-numa-aware-alloc_thread_info_node
+++ a/arch/x86/include/asm/thread_info.h
@@ -161,8 +161,14 @@ struct thread_info {
 
 #define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
 
-#define alloc_thread_info(tsk)						\
-	((struct thread_info *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER))
+#define alloc_thread_info_node(tsk, node)				\
+({									\
+	struct page *page = alloc_pages_node(node, THREAD_FLAGS,	\
+					     THREAD_ORDER);		\
+	struct thread_info *ret = page ? page_address(page) : NULL;	\
+									\
+	ret;								\
+})
 
 #ifdef CONFIG_X86_32
 
diff -puN kernel/fork.c~mm-numa-aware-alloc_thread_info_node kernel/fork.c
--- a/kernel/fork.c~mm-numa-aware-alloc_thread_info_node
+++ a/kernel/fork.c
@@ -116,14 +116,17 @@ static struct kmem_cache *task_struct_ca
 #endif
 
 #ifndef __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-static inline struct thread_info *alloc_thread_info(struct task_struct *tsk)
+static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
+						  int node)
 {
 #ifdef CONFIG_DEBUG_STACK_USAGE
 	gfp_t mask = GFP_KERNEL | __GFP_ZERO;
 #else
 	gfp_t mask = GFP_KERNEL;
 #endif
-	return (struct thread_info *)__get_free_pages(mask, THREAD_SIZE_ORDER);
+	struct page *page = alloc_pages_node(node, mask, THREAD_SIZE_ORDER);
+
+	return page ? page_address(page) : NULL;
 }
 
 static inline void free_thread_info(struct thread_info *ti)
@@ -259,7 +262,7 @@ static struct task_struct *dup_task_stru
 	if (!tsk)
 		return NULL;
 
-	ti = alloc_thread_info(tsk);
+	ti = alloc_thread_info_node(tsk, node);
 	if (!ti) {
 		free_task_struct(tsk);
 		return NULL;
_

Patches currently in -mm which might be from eric.dumazet@gmail.com are

origin.patch
linux-next.patch
irq-use-per_cpu-kstat_irqs.patch
timers-use-this_cpu_read.patch
mm-numa-aware-alloc_task_struct_node.patch
mm-numa-aware-alloc_thread_info_node.patch
kthread-numa-aware-kthread_create_on_cpu.patch
kthread-use-kthread_create_on_cpu.patch
include-asm-generic-vmlinuxldsh-make-readmostly-section-correctly-align.patch
percpu-add-new-macros-to-make-percpu-readmostly-section-correctly-align.patch
percpu-use-new-macros-for-x86-percpu-readmostly-section.patch

