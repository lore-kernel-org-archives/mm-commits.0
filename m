From: akpm@linux-foundation.org
Subject: + clean-up-duplicated-alloc-free_thread_info.patch added to -mm tree
Date: Wed, 04 Jun 2008 01:03:48 -0700
Message-ID: <200806040803.m5483mx5011418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750868AbYFDIEY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 04:04:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-arch@vger.kernel.org, penberg@cs.helsinki.fi, rmk+kernel@arm.linux.org.uk


The patch titled
     clean up duplicated alloc/free_thread_info
has been added to the -mm tree.  Its filename is
     clean-up-duplicated-alloc-free_thread_info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: clean up duplicated alloc/free_thread_info
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

We duplicate alloc/free_thread_info defines on many platforms (the
majority uses __get_free_pages/free_pages).  This patch defines common
defines and removes these duplicated defines. 
__HAVE_ARCH_THREAD_INFO_ALLOCATOR is introduced for platforms that do
something different.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/thread_info.h     |    4 +---
 include/asm-arm/thread_info.h       |   13 -------------
 include/asm-avr32/thread_info.h     |    4 ----
 include/asm-blackfin/thread_info.h  |    5 +----
 include/asm-cris/thread_info.h      |    2 ++
 include/asm-frv/thread_info.h       |    2 ++
 include/asm-h8300/thread_info.h     |    5 +----
 include/asm-ia64/thread_info.h      |    2 ++
 include/asm-m32r/thread_info.h      |    2 ++
 include/asm-m68k/thread_info.h      |    8 +-------
 include/asm-m68knommu/thread_info.h |    4 ----
 include/asm-mips/thread_info.h      |    2 ++
 include/asm-mn10300/thread_info.h   |    2 ++
 include/asm-parisc/thread_info.h    |   10 +++-------
 include/asm-powerpc/thread_info.h   |   14 +++-----------
 include/asm-s390/thread_info.h      |    5 +----
 include/asm-sh/thread_info.h        |    2 ++
 include/asm-sparc/thread_info.h     |    2 ++
 include/asm-sparc64/thread_info.h   |   23 ++---------------------
 include/asm-um/thread_info.h        |   16 +---------------
 include/asm-x86/thread_info.h       |    2 ++
 include/asm-xtensa/thread_info.h    |    5 +----
 kernel/fork.c                       |   17 +++++++++++++++++
 23 files changed, 50 insertions(+), 101 deletions(-)

diff -puN include/asm-alpha/thread_info.h~clean-up-duplicated-alloc-free_thread_info include/asm-alpha/thread_info.h
--- a/include/asm-alpha/thread_info.h~clean-up-duplicated-alloc-free_thread_info
+++ a/include/asm-alpha/thread_info.h
@@ -50,10 +50,8 @@ register struct thread_info *__current_t
 #define current_thread_info()  __current_thread_info
 
 /* Thread information allocation.  */
+#define THREAD_SIZE_ORDER 1
 #define THREAD_SIZE (2*PAGE_SIZE)
-#define alloc_thread_info(tsk) \
-  ((struct thread_info *) __get_free_pages(GFP_KERNEL,1))
-#define free_thread_info(ti) free_pages((unsigned long) (ti), 1)
 
 #endif /* __ASSEMBLY__ */
 
diff -puN include/asm-arm/thread_info.h~clean-up-duplicated-alloc-free_thread_info include/asm-arm/thread_info.h
--- a/include/asm-arm/thread_info.h~clean-up-duplicated-alloc-free_thread_info
+++ a/include/asm-arm/thread_info.h
@@ -97,19 +97,6 @@ static inline struct thread_info *curren
 	return (struct thread_info *)(sp & ~(THREAD_SIZE - 1));
 }
 
-/* thread information allocation */
-#ifdef CONFIG_DEBUG_STACK_USAGE
-#define alloc_thread_info(tsk) \
-	((struct thread_info *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, \
-		THREAD_SIZE_ORDER))
-#else
-#define alloc_thread_info(tsk) \
-	((struct thread_info *)__get_free_pages(GFP_KERNEL, THREAD_SIZE_ORDER))
-#endif
-
-#define free_thread_info(info) \
-	free_pages((unsigned long)info, THREAD_SIZE_ORDER);
-
 #define thread_saved_pc(tsk)	\
 	((unsigned long)(pc_pointer(task_thread_info(tsk)->cpu_context.pc)))
 #define thread_saved_fp(tsk)	\
diff -puN include/asm-avr32/thread_info.h~clean-up-duplicated-alloc-free_thread_info include/asm-avr32/thread_info.h
--- a/include/asm-avr32/thread_info.h~clean-up-duplicated-alloc-free_thread_info
+++ a/include/asm-avr32/thread_info.h
@@ -61,10 +61,6 @@ static inline struct thread_info *curren
 	return (struct thread_info *)addr;
 }
 
-/* thread information allocation */
-#define alloc_thread_info(ti) \
-	((struct thread_info *) __get_free_pages(GFP_KERNEL, THREAD_SIZE_ORDER))
-#define free_thread_info(ti) free_pages((unsigned long)(ti), 1)
 #define get_thread_info(ti) get_task_struct((ti)->task)
 #define put_thread_info(ti) put_task_struct((ti)->task)
 
diff -puN include/asm-blackfin/thread_info.h~clean-up-duplicated-alloc-free_thread_info include/asm-blackfin/thread_info.h
--- a/include/asm-blackfin/thread_info.h~clean-up-duplicated-alloc-free_thread_info
+++ a/include/asm-blackfin/thread_info.h
@@ -42,6 +42,7 @@
 /*
  * Size of kernel stack for each process. This must be a power of 2...
  */
+#define THREAD_SIZE_ORDER	1
 #define THREAD_SIZE		8192	/* 2 pages */
 
 #ifndef __ASSEMBLY__
@@ -94,10 +95,6 @@ static inline struct thread_info *curren
 	return (struct thread_info *)((long)ti & ~((long)THREAD_SIZE-1));
 }
 
-/* thread information allocation */
-#define alloc_thread_info(tsk) ((struct thread_info *) \
-				__get_free_pages(GFP_KERNEL, 1))
-#define free_thread_info(ti)	free_pages((unsigned long) (ti), 1)
 #endif				/* __ASSEMBLY__ */
 
 /*
diff -puN include/asm-cris/thread_info.h~clean-up-duplicated-alloc-free_thread_info include/asm-cris/thread_info.h
--- a/include/asm-cris/thread_info.h~clean-up-duplicated-alloc-free_thread_info
+++ a/include/asm-cris/thread_info.h
@@ -11,6 +11,8 @@
 
 #ifdef __KERNEL__
 
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
 #ifndef __ASSEMBLY__
 #include <asm/types.h>
 #include <asm/processor.h>
diff -puN include/asm-frv/thread_info.h~clean-up-duplicated-alloc-free_thread_info include/asm-frv/thread_info.h
--- a/include/asm-frv/thread_info.h~clean-up-duplicated-alloc-free_thread_info
+++ a/include/asm-frv/thread_info.h
@@ -82,6 +82,8 @@ register struct thread_info *__current_t
 
 #define current_thread_info() ({ __current_thread_info; })
 
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
 /* thread information allocation */
 #ifdef CONFIG_DEBUG_STACK_USAGE
 #define alloc_thread_info(tsk)					\
diff -puN include/asm-h8300/thread_info.h~clean-up-duplicated-alloc-free_thread_info include/asm-h8300/thread_info.h
--- a/include/asm-h8300/thread_info.h~clean-up-duplicated-alloc-free_thread_info
+++ a/include/asm-h8300/thread_info.h
@@ -49,6 +49,7 @@ struct thread_info {
 /*
  * Size of kernel stack for each process. This must be a power of 2...
  */
+#define THREAD_SIZE_ORDER	1
 #define THREAD_SIZE		8192	/* 2 pages */
 
 
@@ -65,10 +66,6 @@ static inline struct thread_info *curren
 	return ti;
 }
 
-/* thread information allocation */
-#define alloc_thread_info(tsk) ((struct thread_info *) \
-				__get_free_pages(GFP_KERNEL, 1))
-#define free_thread_info(ti)	free_pages((unsigned long) (ti), 1)
 #endif /* __ASSEMBLY__ */
 
 /*
diff -puN include/asm-ia64/thread_info.h~clean-up-duplicated-alloc-free_thread_info include/asm-ia64/thread_info.h
--- a/include/asm-ia64/thread_info.h~clean-up-duplicated-alloc-free_thread_info
+++ a/include/asm-ia64/thread_info.h
@@ -54,6 +54,8 @@ struct thread_info {
 	},					\
 }
 
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
 #ifndef ASM_OFFSETS_C
 /* how to get the thread information struct from C */
 #define current_thread_info()	((struct thread_info *) ((char *) current + IA64_TASK_SIZE))
diff -puN include/asm-m32r/thread_info.h~clean-up-duplicated-alloc-free_thread_info include/asm-m32r/thread_info.h
--- a/include/asm-m32r/thread_info.h~clean-up-duplicated-alloc-free_thread_info
+++ a/include/asm-m32r/thread_info.h
@@ -94,6 +94,8 @@ static inline struct thread_info *curren
 	return ti;
 }
 
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
 /* thread information allocation */
 #ifdef CONFIG_DEBUG_STACK_USAGE
 #define alloc_thread_info(tsk)					\
diff -puN include/asm-m68k/thread_info.h~clean-up-duplicated-alloc-free_thread_info include/asm-m68k/thread_info.h
--- a/include/asm-m68k/thread_info.h~clean-up-duplicated-alloc-free_thread_info
+++ a/include/asm-m68k/thread_info.h
@@ -25,13 +25,7 @@ struct thread_info {
 }
 
 /* THREAD_SIZE should be 8k, so handle differently for 4k and 8k machines */
-#if PAGE_SHIFT == 13 /* 8k machines */
-#define alloc_thread_info(tsk)   ((struct thread_info *)__get_free_pages(GFP_KERNEL,0))
-#define free_thread_info(ti)  free_pages((unsigned long)(ti),0)
-#else /* otherwise assume 4k pages */
-#define alloc_thread_info(tsk)   ((struct thread_info *)__get_free_pages(GFP_KERNEL,1))
-#define free_thread_info(ti)  free_pages((unsigned long)(ti),1)
-#endif /* PAGE_SHIFT == 13 */
+#define THREAD_SIZE_ORDER (13 - PAGE_SHIFT)
 
 #define init_thread_info	(init_task.thread.info)
 #define init_stack		(init_thread_union.stack)
diff -puN include/asm-m68knommu/thread_info.h~clean-up-duplicated-alloc-free_thread_info include/asm-m68knommu/thread_info.h
--- a/include/asm-m68knommu/thread_info.h~clean-up-duplicated-alloc-free_thread_info
+++ a/include/asm-m68knommu/thread_info.h
@@ -71,10 +71,6 @@ static inline struct thread_info *curren
 	return ti;
 }
 
-/* thread information allocation */
-#define alloc_thread_info(tsk) ((struct thread_info *) \
-				__get_free_pages(GFP_KERNEL, THREAD_SIZE_ORDER))
-#define free_thread_info(ti)	free_pages((unsigned long) (ti), THREAD_SIZE_ORDER)
 #endif /* __ASSEMBLY__ */
 
 #define	PREEMPT_ACTIVE	0x4000000
diff -puN include/asm-mips/thread_info.h~clean-up-duplicated-alloc-free_thread_info include/asm-mips/thread_info.h
--- a/include/asm-mips/thread_info.h~clean-up-duplicated-alloc-free_thread_info
+++ a/include/asm-mips/thread_info.h
@@ -82,6 +82,8 @@ register struct thread_info *__current_t
 #define THREAD_SIZE (PAGE_SIZE << THREAD_SIZE_ORDER)
 #define THREAD_MASK (THREAD_SIZE - 1UL)
 
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
 #ifdef CONFIG_DEBUG_STACK_USAGE
 #define alloc_thread_info(tsk)					\
 ({								\
diff -puN include/asm-mn10300/thread_info.h~clean-up-duplicated-alloc-free_thread_info include/asm-mn10300/thread_info.h
--- a/include/asm-mn10300/thread_info.h~clean-up-duplicated-alloc-free_thread_info
+++ a/include/asm-mn10300/thread_info.h
@@ -112,6 +112,8 @@ static inline unsigned long current_stac
 	return sp;
 }
 
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
 /* thread information allocation */
 #ifdef CONFIG_DEBUG_STACK_USAGE
 #define alloc_thread_info(tsk) kzalloc(THREAD_SIZE, GFP_KERNEL)
diff -puN include/asm-parisc/thread_info.h~clean-up-duplicated-alloc-free_thread_info include/asm-parisc/thread_info.h
--- a/include/asm-parisc/thread_info.h~clean-up-duplicated-alloc-free_thread_info
+++ a/include/asm-parisc/thread_info.h
@@ -34,15 +34,11 @@ struct thread_info {
 
 /* thread information allocation */
 
-#define THREAD_ORDER            2
+#define THREAD_SIZE_ORDER            2
 /* Be sure to hunt all references to this down when you change the size of
  * the kernel stack */
-#define THREAD_SIZE             (PAGE_SIZE << THREAD_ORDER)
-#define THREAD_SHIFT            (PAGE_SHIFT + THREAD_ORDER)
-
-#define alloc_thread_info(tsk) ((struct thread_info *) \
-			__get_free_pages(GFP_KERNEL, THREAD_ORDER))
-#define free_thread_info(ti)    free_pages((unsigned long) (ti), THREAD_ORDER)
+#define THREAD_SIZE             (PAGE_SIZE << THREAD_SIZE_ORDER)
+#define THREAD_SHIFT            (PAGE_SHIFT + THREAD_SIZE_ORDER)
 
 /* how to get the thread information struct from C */
 #define current_thread_info()	((struct thread_info *)mfctl(30))
diff -puN include/asm-powerpc/thread_info.h~clean-up-duplicated-alloc-free_thread_info include/asm-powerpc/thread_info.h
--- a/include/asm-powerpc/thread_info.h~clean-up-duplicated-alloc-free_thread_info
+++ a/include/asm-powerpc/thread_info.h
@@ -66,20 +66,12 @@ struct thread_info {
 
 #if THREAD_SHIFT >= PAGE_SHIFT
 
-#define THREAD_ORDER	(THREAD_SHIFT - PAGE_SHIFT)
-
-#ifdef CONFIG_DEBUG_STACK_USAGE
-#define alloc_thread_info(tsk)	\
-	((struct thread_info *)__get_free_pages(GFP_KERNEL | \
-		__GFP_ZERO, THREAD_ORDER))
-#else
-#define alloc_thread_info(tsk)	\
-	((struct thread_info *)__get_free_pages(GFP_KERNEL, THREAD_ORDER))
-#endif
-#define free_thread_info(ti)	free_pages((unsigned long)ti, THREAD_ORDER)
+#define THREAD_SIZE_ORDER	(THREAD_SHIFT - PAGE_SHIFT)
 
 #else /* THREAD_SHIFT < PAGE_SHIFT */
 
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
 extern struct thread_info *alloc_thread_info(struct task_struct *tsk);
 extern void free_thread_info(struct thread_info *ti);
 
diff -puN include/asm-s390/thread_info.h~clean-up-duplicated-alloc-free_thread_info include/asm-s390/thread_info.h
--- a/include/asm-s390/thread_info.h~clean-up-duplicated-alloc-free_thread_info
+++ a/include/asm-s390/thread_info.h
@@ -78,10 +78,7 @@ static inline struct thread_info *curren
 	return (struct thread_info *)((*(unsigned long *) __LC_KERNEL_STACK)-THREAD_SIZE);
 }
 
-/* thread information allocation */
-#define alloc_thread_info(tsk) ((struct thread_info *) \
-	__get_free_pages(GFP_KERNEL,THREAD_ORDER))
-#define free_thread_info(ti) free_pages((unsigned long) (ti),THREAD_ORDER)
+#define THREAD_SIZE_ORDER THREAD_ORDER
 
 #endif
 
diff -puN include/asm-sh/thread_info.h~clean-up-duplicated-alloc-free_thread_info include/asm-sh/thread_info.h
--- a/include/asm-sh/thread_info.h~clean-up-duplicated-alloc-free_thread_info
+++ a/include/asm-sh/thread_info.h
@@ -92,6 +92,8 @@ static inline struct thread_info *curren
 	return ti;
 }
 
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
 /* thread information allocation */
 #ifdef CONFIG_DEBUG_STACK_USAGE
 #define alloc_thread_info(ti)	kzalloc(THREAD_SIZE, GFP_KERNEL)
diff -puN include/asm-sparc/thread_info.h~clean-up-duplicated-alloc-free_thread_info include/asm-sparc/thread_info.h
--- a/include/asm-sparc/thread_info.h~clean-up-duplicated-alloc-free_thread_info
+++ a/include/asm-sparc/thread_info.h
@@ -86,6 +86,8 @@ register struct thread_info *current_thr
 #define THREAD_INFO_ORDER  1
 #endif
 
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
 BTFIXUPDEF_CALL(struct thread_info *, alloc_thread_info, void)
 #define alloc_thread_info(tsk) BTFIXUP_CALL(alloc_thread_info)()
 
diff -puN include/asm-sparc64/thread_info.h~clean-up-duplicated-alloc-free_thread_info include/asm-sparc64/thread_info.h
--- a/include/asm-sparc64/thread_info.h~clean-up-duplicated-alloc-free_thread_info
+++ a/include/asm-sparc64/thread_info.h
@@ -150,30 +150,11 @@ register struct thread_info *current_thr
 
 /* thread information allocation */
 #if PAGE_SHIFT == 13
-#define __THREAD_INFO_ORDER	1
+#define THREAD_SIZE_ORDER	1
 #else /* PAGE_SHIFT == 13 */
-#define __THREAD_INFO_ORDER	0
+#define THREAD_SIZE_ORDER	0
 #endif /* PAGE_SHIFT == 13 */
 
-#ifdef CONFIG_DEBUG_STACK_USAGE
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
-#else
-#define alloc_thread_info(tsk) \
-	((struct thread_info *)__get_free_pages(GFP_KERNEL, __THREAD_INFO_ORDER))
-#endif
-
-#define free_thread_info(ti) \
-	free_pages((unsigned long)(ti),__THREAD_INFO_ORDER)
-
 #define __thread_flag_byte_ptr(ti)	\
 	((unsigned char *)(&((ti)->flags)))
 #define __cur_thread_flag_byte_ptr	__thread_flag_byte_ptr(current_thread_info())
diff -puN include/asm-um/thread_info.h~clean-up-duplicated-alloc-free_thread_info include/asm-um/thread_info.h
--- a/include/asm-um/thread_info.h~clean-up-duplicated-alloc-free_thread_info
+++ a/include/asm-um/thread_info.h
@@ -53,21 +53,7 @@ static inline struct thread_info *curren
 	return ti;
 }
 
-#ifdef CONFIG_DEBUG_STACK_USAGE
-
-#define alloc_thread_info(tsk) \
-	((struct thread_info *) __get_free_pages(GFP_KERNEL | __GFP_ZERO, \
-						 CONFIG_KERNEL_STACK_ORDER))
-#else
-
-/* thread information allocation */
-#define alloc_thread_info(tsk) \
-	((struct thread_info *) __get_free_pages(GFP_KERNEL, \
-						 CONFIG_KERNEL_STACK_ORDER))
-#endif
-
-#define free_thread_info(ti) \
-	free_pages((unsigned long)(ti),CONFIG_KERNEL_STACK_ORDER)
+#define THREAD_SIZE_ORDER CONFIG_KERNEL_STACK_ORDER
 
 #endif
 
diff -puN include/asm-x86/thread_info.h~clean-up-duplicated-alloc-free_thread_info include/asm-x86/thread_info.h
--- a/include/asm-x86/thread_info.h~clean-up-duplicated-alloc-free_thread_info
+++ a/include/asm-x86/thread_info.h
@@ -151,6 +151,8 @@ struct thread_info {
 #define THREAD_FLAGS GFP_KERNEL
 #endif
 
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
 #define alloc_thread_info(tsk)						\
 	((struct thread_info *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER))
 
diff -puN include/asm-xtensa/thread_info.h~clean-up-duplicated-alloc-free_thread_info include/asm-xtensa/thread_info.h
--- a/include/asm-xtensa/thread_info.h~clean-up-duplicated-alloc-free_thread_info
+++ a/include/asm-xtensa/thread_info.h
@@ -111,10 +111,6 @@ static inline struct thread_info *curren
 	return ti;
 }
 
-/* thread information allocation */
-#define alloc_thread_info(tsk) ((struct thread_info *) __get_free_pages(GFP_KERNEL,1))
-#define free_thread_info(ti) free_pages((unsigned long) (ti), 1)
-
 #else /* !__ASSEMBLY__ */
 
 /* how to get the thread information struct from ASM */
@@ -160,6 +156,7 @@ static inline struct thread_info *curren
 #define TS_USEDFPU		0x0001	/* FPU was used by this task this quantum (SMP) */
 
 #define THREAD_SIZE 8192	//(2*PAGE_SIZE)
+#define THREAD_SIZE_ORDER 1
 
 #endif	/* __KERNEL__ */
 #endif	/* _XTENSA_THREAD_INFO */
diff -puN kernel/fork.c~clean-up-duplicated-alloc-free_thread_info kernel/fork.c
--- a/kernel/fork.c~clean-up-duplicated-alloc-free_thread_info
+++ a/kernel/fork.c
@@ -93,6 +93,23 @@ int nr_processes(void)
 static struct kmem_cache *task_struct_cachep;
 #endif
 
+#ifndef __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+static inline struct thread_info *alloc_thread_info(struct task_struct *tsk)
+{
+#ifdef CONFIG_DEBUG_STACK_USAGE
+	gfp_t mask = GFP_KERNEL | __GFP_ZERO;
+#else
+	gfp_t mask = GFP_KERNEL;
+#endif
+	return (struct thread_info *)__get_free_pages(mask, THREAD_SIZE_ORDER);
+}
+
+static inline void free_thread_info(struct thread_info *ti)
+{
+	free_pages((unsigned long)ti, THREAD_SIZE_ORDER);
+}
+#endif
+
 /* SLAB cache for signal_struct structures (tsk->signal) */
 static struct kmem_cache *signal_cachep;
 
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
block-add-blk_queue_update_dma_pad.patch
ide-use-the-dma-safe-check-for-req_type_ata_pc.patch
block-blk_rq_map_kern-uses-the-bounce-buffers-for-stack-buffers.patch
ide-avoid-dma-on-the-stack-for-req_type_ata_pc.patch
scsi-sr-avoids-useless-buffer-allocation.patch
cdrom-revert-commit-22a9189-cdrom-use-kmalloced-buffers-instead-of-buffers-on-stack.patch
clean-up-duplicated-alloc-free_thread_info.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sparc32.patch
dma-mapping-x86-per-device-dma_mapping_ops-support.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch

