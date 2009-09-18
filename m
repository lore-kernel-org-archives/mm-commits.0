From: akpm@linux-foundation.org
Subject: + mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch added to -mm tree
Date: Fri, 18 Sep 2009 14:18:47 -0700
Message-ID: <200909182118.n8ILIlH4001426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752253AbZIRVTf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Sep 2009 17:19:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnd@arndb.de, ebmunson@us.ibm.com, hugh.dickins@tiscali.co.uk, linux-arch@vger.kernel.org, rientjes@google.com


The patch titled
     mm: add MAP_HUGETLB for mmaping pseudo-anonymous huge page regions
has been added to the -mm tree.  Its filename is
     mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch

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
Subject: mm: add MAP_HUGETLB for mmaping pseudo-anonymous huge page regions
From: Arnd Bergmann <arnd@arndb.de>

Add a flag for mmap that will be used to request a huge page region that
will look like anonymous memory to user space.  This is accomplished by
using a file on the internal vfsmount.  MAP_HUGETLB is a modifier of
MAP_ANONYMOUS and so must be specified with it.  The region will behave
the same as a MAP_ANONYMOUS region using small pages.

The patch also adds the MAP_STACK flag, which was previously defined only
on some architectures but not on others.  Since MAP_STACK is meant to be a
hint only, architectures can define it without assigning a specific
meaning to it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Eric B Munson <ebmunson@us.ibm.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: David Rientjes <rientjes@google.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/mman.h   |    2 ++
 arch/arm/include/asm/mman.h     |    2 ++
 arch/avr32/include/asm/mman.h   |    2 ++
 arch/cris/include/asm/mman.h    |    2 ++
 arch/frv/include/asm/mman.h     |    2 ++
 arch/h8300/include/asm/mman.h   |    2 ++
 arch/ia64/include/asm/mman.h    |    2 ++
 arch/m32r/include/asm/mman.h    |    2 ++
 arch/m68k/include/asm/mman.h    |    2 ++
 arch/mips/include/asm/mman.h    |    2 ++
 arch/mn10300/include/asm/mman.h |    2 ++
 arch/parisc/include/asm/mman.h  |    2 ++
 arch/powerpc/include/asm/mman.h |    2 ++
 arch/s390/include/asm/mman.h    |    2 ++
 arch/sparc/include/asm/mman.h   |    2 ++
 arch/xtensa/include/asm/mman.h  |    2 ++
 include/asm-generic/mman.h      |    1 +
 17 files changed, 33 insertions(+)

diff -puN arch/alpha/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions arch/alpha/include/asm/mman.h
--- a/arch/alpha/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions
+++ a/arch/alpha/include/asm/mman.h
@@ -28,6 +28,8 @@
 #define MAP_NORESERVE	0x10000		/* don't check for reservations */
 #define MAP_POPULATE	0x20000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x40000		/* do not block on IO */
+#define MAP_STACK	0x80000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x100000	/* create a huge page mapping */
 
 #define MS_ASYNC	1		/* sync memory asynchronously */
 #define MS_SYNC		2		/* synchronous memory sync */
diff -puN arch/arm/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions arch/arm/include/asm/mman.h
--- a/arch/arm/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions
+++ a/arch/arm/include/asm/mman.h
@@ -10,6 +10,8 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) page tables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff -puN arch/avr32/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions arch/avr32/include/asm/mman.h
--- a/arch/avr32/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions
+++ a/arch/avr32/include/asm/mman.h
@@ -10,6 +10,8 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) page tables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff -puN arch/cris/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions arch/cris/include/asm/mman.h
--- a/arch/cris/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions
+++ a/arch/cris/include/asm/mman.h
@@ -12,6 +12,8 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff -puN arch/frv/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions arch/frv/include/asm/mman.h
--- a/arch/frv/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions
+++ a/arch/frv/include/asm/mman.h
@@ -10,6 +10,8 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff -puN arch/h8300/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions arch/h8300/include/asm/mman.h
--- a/arch/h8300/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions
+++ a/arch/h8300/include/asm/mman.h
@@ -10,6 +10,8 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff -puN arch/ia64/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions arch/ia64/include/asm/mman.h
--- a/arch/ia64/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions
+++ a/arch/ia64/include/asm/mman.h
@@ -18,6 +18,8 @@
 #define MAP_NORESERVE	0x04000		/* don't check for reservations */
 #define MAP_POPULATE	0x08000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff -puN arch/m32r/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions arch/m32r/include/asm/mman.h
--- a/arch/m32r/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions
+++ a/arch/m32r/include/asm/mman.h
@@ -10,6 +10,8 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff -puN arch/m68k/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions arch/m68k/include/asm/mman.h
--- a/arch/m68k/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions
+++ a/arch/m68k/include/asm/mman.h
@@ -10,6 +10,8 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff -puN arch/mips/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions arch/mips/include/asm/mman.h
--- a/arch/mips/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions
+++ a/arch/mips/include/asm/mman.h
@@ -46,6 +46,8 @@
 #define MAP_LOCKED	0x8000		/* pages are locked */
 #define MAP_POPULATE	0x10000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x20000		/* do not block on IO */
+#define MAP_STACK	0x40000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x80000		/* create a huge page mapping */
 
 /*
  * Flags for msync
diff -puN arch/mn10300/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions arch/mn10300/include/asm/mman.h
--- a/arch/mn10300/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions
+++ a/arch/mn10300/include/asm/mman.h
@@ -21,6 +21,8 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff -puN arch/parisc/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions arch/parisc/include/asm/mman.h
--- a/arch/parisc/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions
+++ a/arch/parisc/include/asm/mman.h
@@ -22,6 +22,8 @@
 #define MAP_GROWSDOWN	0x8000		/* stack-like segment */
 #define MAP_POPULATE	0x10000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x20000		/* do not block on IO */
+#define MAP_STACK	0x40000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x80000		/* create a huge page mapping */
 
 #define MS_SYNC		1		/* synchronous memory sync */
 #define MS_ASYNC	2		/* sync memory asynchronously */
diff -puN arch/powerpc/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions arch/powerpc/include/asm/mman.h
--- a/arch/powerpc/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions
+++ a/arch/powerpc/include/asm/mman.h
@@ -25,6 +25,8 @@
 
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 #ifdef __KERNEL__
 #ifdef CONFIG_PPC64
diff -puN arch/s390/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions arch/s390/include/asm/mman.h
--- a/arch/s390/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions
+++ a/arch/s390/include/asm/mman.h
@@ -18,6 +18,8 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff -puN arch/sparc/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions arch/sparc/include/asm/mman.h
--- a/arch/sparc/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions
+++ a/arch/sparc/include/asm/mman.h
@@ -20,6 +20,8 @@
 
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
diff -puN arch/x86/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions arch/x86/include/asm/mman.h
diff -puN arch/xtensa/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions arch/xtensa/include/asm/mman.h
--- a/arch/xtensa/include/asm/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions
+++ a/arch/xtensa/include/asm/mman.h
@@ -53,6 +53,8 @@
 #define MAP_LOCKED	0x8000		/* pages are locked */
 #define MAP_POPULATE	0x10000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x20000		/* do not block on IO */
+#define MAP_STACK	0x40000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x80000		/* create a huge page mapping */
 
 /*
  * Flags for msync
diff -puN include/asm-generic/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions include/asm-generic/mman.h
--- a/include/asm-generic/mman.h~mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions
+++ a/include/asm-generic/mman.h
@@ -11,6 +11,7 @@
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
 #define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
_

Patches currently in -mm which might be from arnd@arndb.de are

origin.patch
linux-next.patch
mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions-fix.patch
asm-sections-add-text-data-checking-functions-for-arches-to-override.patch
kallsyms-use-new-arch_is_kernel_text.patch
lockdep-use-new-arch_is_kernel_data.patch
blackfin-override-text-data-checking-functions.patch

