From: akpm@linux-foundation.org
Subject: + remove-tas.patch added to -mm tree
Date: Wed, 02 May 2007 22:59:34 -0700
Message-ID: <200705030559.l435xYIu005899@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766912AbXECF7k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 01:59:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, linux-arch@vger.kernel.org


The patch titled
     Remove tas()
has been added to the -mm tree.  Its filename is
     remove-tas.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove tas()
From: Jeff Dike <jdike@addtoit.com>

tas() has no users, so get rid of it.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: <linux-arch@vger.kernel.org>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/system.h     |    3 ---
 include/asm-arm/system.h       |    2 --
 include/asm-arm26/system.h     |    2 --
 include/asm-blackfin/system.h  |    1 -
 include/asm-h8300/system.h     |    1 -
 include/asm-i386/system.h      |    2 --
 include/asm-m32r/system.h      |    2 --
 include/asm-m68k/system.h      |    1 -
 include/asm-m68knommu/system.h |    1 -
 include/asm-mips/system.h      |    1 -
 include/asm-powerpc/system.h   |    2 --
 include/asm-ppc/system.h       |    1 -
 include/asm-sh/system.h        |   10 ----------
 include/asm-sh64/system.h      |    2 --
 include/asm-sparc/system.h     |    1 -
 include/asm-sparc64/system.h   |    1 -
 include/asm-v850/system.h      |    1 -
 include/asm-x86_64/system.h    |    2 --
 include/asm-xtensa/system.h    |    2 --
 19 files changed, 38 deletions(-)

diff -puN include/asm-alpha/system.h~remove-tas include/asm-alpha/system.h
--- a/include/asm-alpha/system.h~remove-tas
+++ a/include/asm-alpha/system.h
@@ -548,9 +548,6 @@ __xchg_u64_local(volatile long *m, unsig
      		sizeof(*(ptr))); \
   })
 
-#define tas(ptr) (xchg((ptr),1))
-
-
 /* 
  * Atomic compare and exchange.  Compare OLD with MEM, if identical,
  * store NEW in MEM.  Return the initial value in MEM.  Success is
diff -puN include/asm-arm/system.h~remove-tas include/asm-arm/system.h
--- a/include/asm-arm/system.h~remove-tas
+++ a/include/asm-arm/system.h
@@ -103,8 +103,6 @@ void hook_fault_code(int nr, int (*fn)(u
 #define xchg(ptr,x) \
 	((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
 
-#define tas(ptr) (xchg((ptr),1))
-
 extern asmlinkage void __backtrace(void);
 extern asmlinkage void c_backtrace(unsigned long fp, int pmode);
 
diff -puN include/asm-arm26/system.h~remove-tas include/asm-arm26/system.h
--- a/include/asm-arm26/system.h~remove-tas
+++ a/include/asm-arm26/system.h
@@ -52,8 +52,6 @@ void hook_fault_code(int nr, int (*fn)(u
 #define xchg(ptr,x) \
 	((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
 
-#define tas(ptr) (xchg((ptr),1))
-
 extern asmlinkage void __backtrace(void);
 
 #define set_cr(x)					\
diff -puN include/asm-blackfin/system.h~remove-tas include/asm-blackfin/system.h
--- a/include/asm-blackfin/system.h~remove-tas
+++ a/include/asm-blackfin/system.h
@@ -138,7 +138,6 @@ extern unsigned long irq_flags;
 #endif
 
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
-#define tas(ptr) ((void)xchg((ptr),1))
 
 struct __xchg_dummy {
 	unsigned long a[100];
diff -puN include/asm-h8300/system.h~remove-tas include/asm-h8300/system.h
--- a/include/asm-h8300/system.h~remove-tas
+++ a/include/asm-h8300/system.h
@@ -98,7 +98,6 @@ asmlinkage void resume(void);
 #endif
 
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
-#define tas(ptr) (xchg((ptr),1))
 
 struct __xchg_dummy { unsigned long a[100]; };
 #define __xg(x) ((volatile struct __xchg_dummy *)(x))
diff -puN include/asm-i386/system.h~remove-tas include/asm-i386/system.h
--- a/include/asm-i386/system.h~remove-tas
+++ a/include/asm-i386/system.h
@@ -197,8 +197,6 @@ static inline unsigned long get_limit(un
 
 #define xchg(ptr,v) ((__typeof__(*(ptr)))__xchg((unsigned long)(v),(ptr),sizeof(*(ptr))))
 
-#define tas(ptr) (xchg((ptr),1))
-
 struct __xchg_dummy { unsigned long a[100]; };
 #define __xg(x) ((struct __xchg_dummy *)(x))
 
diff -puN include/asm-m32r/system.h~remove-tas include/asm-m32r/system.h
--- a/include/asm-m32r/system.h~remove-tas
+++ a/include/asm-m32r/system.h
@@ -122,8 +122,6 @@ static inline void local_irq_disable(voi
 #define xchg(ptr,x) \
 	((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
 
-#define tas(ptr)	(xchg((ptr),1))
-
 #ifdef CONFIG_SMP
 extern void  __xchg_called_with_bad_pointer(void);
 #endif
diff -puN include/asm-m68k/system.h~remove-tas include/asm-m68k/system.h
--- a/include/asm-m68k/system.h~remove-tas
+++ a/include/asm-m68k/system.h
@@ -88,7 +88,6 @@ static inline int irqs_disabled(void)
 
 
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
-#define tas(ptr) (xchg((ptr),1))
 
 struct __xchg_dummy { unsigned long a[100]; };
 #define __xg(x) ((volatile struct __xchg_dummy *)(x))
diff -puN include/asm-m68knommu/system.h~remove-tas include/asm-m68knommu/system.h
--- a/include/asm-m68knommu/system.h~remove-tas
+++ a/include/asm-m68knommu/system.h
@@ -120,7 +120,6 @@ asmlinkage void resume(void);
 #endif
 
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
-#define tas(ptr) (xchg((ptr),1))
 
 struct __xchg_dummy { unsigned long a[100]; };
 #define __xg(x) ((volatile struct __xchg_dummy *)(x))
diff -puN include/asm-mips/system.h~remove-tas include/asm-mips/system.h
--- a/include/asm-mips/system.h~remove-tas
+++ a/include/asm-mips/system.h
@@ -201,7 +201,6 @@ static inline unsigned long __xchg(unsig
 }
 
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
-#define tas(ptr) (xchg((ptr),1))
 
 #define __HAVE_ARCH_CMPXCHG 1
 
diff -puN include/asm-powerpc/system.h~remove-tas include/asm-powerpc/system.h
--- a/include/asm-powerpc/system.h~remove-tas
+++ a/include/asm-powerpc/system.h
@@ -335,8 +335,6 @@ __xchg_local(volatile void *ptr, unsigne
      		(unsigned long)_x_, sizeof(*(ptr))); 			     \
   })
 
-#define tas(ptr) (xchg((ptr),1))
-
 /*
  * Compare and exchange - if *p == old, set it to new,
  * and return the old value of *p.
diff -puN include/asm-ppc/system.h~remove-tas include/asm-ppc/system.h
--- a/include/asm-ppc/system.h~remove-tas
+++ a/include/asm-ppc/system.h
@@ -169,7 +169,6 @@ xchg_u32(volatile void *p, unsigned long
 extern void __xchg_called_with_bad_pointer(void);
 
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
-#define tas(ptr) (xchg((ptr),1))
 
 static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size)
 {
diff -puN include/asm-sh/system.h~remove-tas include/asm-sh/system.h
--- a/include/asm-sh/system.h~remove-tas
+++ a/include/asm-sh/system.h
@@ -82,16 +82,6 @@ static inline void sched_cacheflush(void
 }
 #endif
 
-static inline unsigned long tas(volatile int *m)
-{
-	unsigned long retval;
-
-	__asm__ __volatile__ ("tas.b	@%1\n\t"
-			      "movt	%0"
-			      : "=r" (retval): "r" (m): "t", "memory");
-	return retval;
-}
-
 /*
  * A brief note on ctrl_barrier(), the control register write barrier.
  *
diff -puN include/asm-sh64/system.h~remove-tas include/asm-sh64/system.h
--- a/include/asm-sh64/system.h~remove-tas
+++ a/include/asm-sh64/system.h
@@ -43,8 +43,6 @@ extern struct task_struct *sh64_switch_t
 
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
 
-#define tas(ptr) (xchg((ptr), 1))
-
 extern void __xchg_called_with_bad_pointer(void);
 
 #define mb()	__asm__ __volatile__ ("synco": : :"memory")
diff -puN include/asm-sparc/system.h~remove-tas include/asm-sparc/system.h
--- a/include/asm-sparc/system.h~remove-tas
+++ a/include/asm-sparc/system.h
@@ -241,7 +241,6 @@ static inline unsigned long xchg_u32(__v
 }
 
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
-#define tas(ptr) (xchg((ptr),1))
 
 extern void __xchg_called_with_bad_pointer(void);
 
diff -puN include/asm-sparc64/system.h~remove-tas include/asm-sparc64/system.h
--- a/include/asm-sparc64/system.h~remove-tas
+++ a/include/asm-sparc64/system.h
@@ -253,7 +253,6 @@ static inline unsigned long xchg64(__vol
 }
 
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
-#define tas(ptr) (xchg((ptr),1))
 
 extern void __xchg_called_with_bad_pointer(void);
 
diff -puN include/asm-v850/system.h~remove-tas include/asm-v850/system.h
--- a/include/asm-v850/system.h~remove-tas
+++ a/include/asm-v850/system.h
@@ -76,7 +76,6 @@ static inline int irqs_disabled (void)
 
 #define xchg(ptr, with) \
   ((__typeof__ (*(ptr)))__xchg ((unsigned long)(with), (ptr), sizeof (*(ptr))))
-#define tas(ptr) (xchg ((ptr), 1))
 
 static inline unsigned long __xchg (unsigned long with,
 				    __volatile__ void *ptr, int size)
diff -puN include/asm-x86_64/system.h~remove-tas include/asm-x86_64/system.h
--- a/include/asm-x86_64/system.h~remove-tas
+++ a/include/asm-x86_64/system.h
@@ -126,8 +126,6 @@ static inline void sched_cacheflush(void
 
 #define xchg(ptr,v) ((__typeof__(*(ptr)))__xchg((unsigned long)(v),(ptr),sizeof(*(ptr))))
 
-#define tas(ptr) (xchg((ptr),1))
-
 #define __xg(x) ((volatile long *)(x))
 
 static inline void set_64bit(volatile unsigned long *ptr, unsigned long val)
diff -puN include/asm-xtensa/system.h~remove-tas include/asm-xtensa/system.h
--- a/include/asm-xtensa/system.h~remove-tas
+++ a/include/asm-xtensa/system.h
@@ -183,8 +183,6 @@ static inline unsigned long xchg_u32(vol
   return tmp;
 }
 
-#define tas(ptr) (xchg((ptr),1))
-
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
 
 /*
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
array_size-check-for-type.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-speed-up-exec.patch
uml-no-locking-needed-in-tlsc.patch
uml-tidy-processc.patch
uml-remove-page_size.patch
uml-kernel_thread-shouldnt-panic.patch
uml-tidy-fault-code.patch
uml-kernel-segfaults-should-dump-proper-registers.patch
uml-comment-early-boot-locking.patch
uml-irq-locking-commentary.patch
uml-delete-host_frame_size.patch
uml-drivers-get-release-methods.patch
uml-dump-registers-on-ptrace-or-wait-failure.patch
uml-speed-up-page-table-walking.patch
uml-remove-unused-x86_64-code.patch
uml-start-fixing-os_read_file-and-os_write_file.patch
uml-tidy-libc-code.patch
uml-convert-libc-layer-to-call-read-and-write.patch
uml-batch-i-o-requests.patch
uml-send-pointers-instead-of-structures-to-i-o-thread.patch
uml-send-pointers-instead-of-structures-to-i-o-thread-fix.patch
uml-dump-core-on-panic.patch
uml-dont-try-to-handle-signals-on-initial-process-stack.patch
uml-change-remaining-callers-of-os_read_write_file.patch
uml-formatting-fixes-around-os_read_write_file-callers.patch
uml-remove-debugging-remnants.patch
uml-rename-os_read_write_file_k-back-to-os_read_write_file.patch
uml-aio-deadlock-avoidance.patch
uml-speed-page-fault-path.patch
uml-eliminate-a-piece-of-debugging-code.patch
uml-more-page-fault-path-trimming.patch
uml-only-flush-areas-covered-by-vma.patch
uml-out-of-tmpfs-space-error-clarification.patch
uml-virtualized-time-fix.patch
uml-fix-prototypes.patch
remove-tas.patch
create-asm-i386-cmpxchgh.patch
create-asm-x86_64-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
