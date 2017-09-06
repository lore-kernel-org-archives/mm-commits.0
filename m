From: akpm@linux-foundation.org
Subject: [patch 088/119] mm: arch: consolidate mmap hugetlb size
 encodings
Date: Wed, 06 Sep 2017 16:23:29 -0700
Message-ID: <20170906232329.2GBpuJXMS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50732 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753150AbdIFXXb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:23:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, ak@linux.intel.com, akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, arnd@arndb.de, dbueso@suse.de, khandual@linux.vnet.ibm.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, mtk.manpages@gmail.com, torvalds@linux-foundation.org, willy@infradead.org

From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm: arch: consolidate mmap hugetlb size encodings

A non-default huge page size can be encoded in the flags argument of the
mmap system call.  The definitions for these encodings are in arch
specific header files.  However, all architectures use the same values.

Consolidate all the definitions in the primary user header file
(uapi/linux/mman.h).  Include definitions for all known huge page sizes. 
Use the generic encoding definitions in hugetlb_encode.h as the basis for
these definitions.

Link: http://lkml.kernel.org/r/1501527386-10736-3-git-send-email-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/uapi/asm/mman.h     |   11 -----------
 arch/mips/include/uapi/asm/mman.h      |   11 -----------
 arch/parisc/include/uapi/asm/mman.h    |   11 -----------
 arch/powerpc/include/uapi/asm/mman.h   |   16 ----------------
 arch/x86/include/uapi/asm/mman.h       |    3 ---
 arch/xtensa/include/uapi/asm/mman.h    |   11 -----------
 include/uapi/asm-generic/mman-common.h |   11 -----------
 include/uapi/linux/mman.h              |   22 ++++++++++++++++++++++
 8 files changed, 22 insertions(+), 74 deletions(-)

diff -puN arch/alpha/include/uapi/asm/mman.h~mm-arch-consolidate-mmap-hugetlb-size-encodings arch/alpha/include/uapi/asm/mman.h
--- a/arch/alpha/include/uapi/asm/mman.h~mm-arch-consolidate-mmap-hugetlb-size-encodings
+++ a/arch/alpha/include/uapi/asm/mman.h
@@ -67,17 +67,6 @@
 /* compatibility flags */
 #define MAP_FILE	0
 
-/*
- * When MAP_HUGETLB is set bits [26:31] encode the log2 of the huge page size.
- * This gives us 6 bits, which is enough until someone invents 128 bit address
- * spaces.
- *
- * Assume these are all power of twos.
- * When 0 use the default page size.
- */
-#define MAP_HUGE_SHIFT	26
-#define MAP_HUGE_MASK	0x3f
-
 #define PKEY_DISABLE_ACCESS	0x1
 #define PKEY_DISABLE_WRITE	0x2
 #define PKEY_ACCESS_MASK	(PKEY_DISABLE_ACCESS |\
diff -puN arch/mips/include/uapi/asm/mman.h~mm-arch-consolidate-mmap-hugetlb-size-encodings arch/mips/include/uapi/asm/mman.h
--- a/arch/mips/include/uapi/asm/mman.h~mm-arch-consolidate-mmap-hugetlb-size-encodings
+++ a/arch/mips/include/uapi/asm/mman.h
@@ -94,17 +94,6 @@
 /* compatibility flags */
 #define MAP_FILE	0
 
-/*
- * When MAP_HUGETLB is set bits [26:31] encode the log2 of the huge page size.
- * This gives us 6 bits, which is enough until someone invents 128 bit address
- * spaces.
- *
- * Assume these are all power of twos.
- * When 0 use the default page size.
- */
-#define MAP_HUGE_SHIFT	26
-#define MAP_HUGE_MASK	0x3f
-
 #define PKEY_DISABLE_ACCESS	0x1
 #define PKEY_DISABLE_WRITE	0x2
 #define PKEY_ACCESS_MASK	(PKEY_DISABLE_ACCESS |\
diff -puN arch/parisc/include/uapi/asm/mman.h~mm-arch-consolidate-mmap-hugetlb-size-encodings arch/parisc/include/uapi/asm/mman.h
--- a/arch/parisc/include/uapi/asm/mman.h~mm-arch-consolidate-mmap-hugetlb-size-encodings
+++ a/arch/parisc/include/uapi/asm/mman.h
@@ -64,17 +64,6 @@
 #define MAP_FILE	0
 #define MAP_VARIABLE	0
 
-/*
- * When MAP_HUGETLB is set bits [26:31] encode the log2 of the huge page size.
- * This gives us 6 bits, which is enough until someone invents 128 bit address
- * spaces.
- *
- * Assume these are all power of twos.
- * When 0 use the default page size.
- */
-#define MAP_HUGE_SHIFT	26
-#define MAP_HUGE_MASK	0x3f
-
 #define PKEY_DISABLE_ACCESS	0x1
 #define PKEY_DISABLE_WRITE	0x2
 #define PKEY_ACCESS_MASK	(PKEY_DISABLE_ACCESS |\
diff -puN arch/powerpc/include/uapi/asm/mman.h~mm-arch-consolidate-mmap-hugetlb-size-encodings arch/powerpc/include/uapi/asm/mman.h
--- a/arch/powerpc/include/uapi/asm/mman.h~mm-arch-consolidate-mmap-hugetlb-size-encodings
+++ a/arch/powerpc/include/uapi/asm/mman.h
@@ -29,20 +29,4 @@
 #define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
-/*
- * When MAP_HUGETLB is set, bits [26:31] of the flags argument to mmap(2),
- * encode the log2 of the huge page size. A value of zero indicates that the
- * default huge page size should be used. To use a non-default huge page size,
- * one of these defines can be used, or the size can be encoded by hand. Note
- * that on most systems only a subset, or possibly none, of these sizes will be
- * available.
- */
-#define MAP_HUGE_512KB	(19 << MAP_HUGE_SHIFT)	/* 512KB HugeTLB Page */
-#define MAP_HUGE_1MB	(20 << MAP_HUGE_SHIFT)	/* 1MB   HugeTLB Page */
-#define MAP_HUGE_2MB	(21 << MAP_HUGE_SHIFT)	/* 2MB   HugeTLB Page */
-#define MAP_HUGE_8MB	(23 << MAP_HUGE_SHIFT)	/* 8MB   HugeTLB Page */
-#define MAP_HUGE_16MB	(24 << MAP_HUGE_SHIFT)	/* 16MB  HugeTLB Page */
-#define MAP_HUGE_1GB	(30 << MAP_HUGE_SHIFT)	/* 1GB   HugeTLB Page */
-#define MAP_HUGE_16GB	(34 << MAP_HUGE_SHIFT)	/* 16GB  HugeTLB Page */
-
 #endif /* _UAPI_ASM_POWERPC_MMAN_H */
diff -puN arch/x86/include/uapi/asm/mman.h~mm-arch-consolidate-mmap-hugetlb-size-encodings arch/x86/include/uapi/asm/mman.h
--- a/arch/x86/include/uapi/asm/mman.h~mm-arch-consolidate-mmap-hugetlb-size-encodings
+++ a/arch/x86/include/uapi/asm/mman.h
@@ -3,9 +3,6 @@
 
 #define MAP_32BIT	0x40		/* only give out 32bit addresses */
 
-#define MAP_HUGE_2MB    (21 << MAP_HUGE_SHIFT)
-#define MAP_HUGE_1GB    (30 << MAP_HUGE_SHIFT)
-
 #ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
 /*
  * Take the 4 protection key bits out of the vma->vm_flags
diff -puN arch/xtensa/include/uapi/asm/mman.h~mm-arch-consolidate-mmap-hugetlb-size-encodings arch/xtensa/include/uapi/asm/mman.h
--- a/arch/xtensa/include/uapi/asm/mman.h~mm-arch-consolidate-mmap-hugetlb-size-encodings
+++ a/arch/xtensa/include/uapi/asm/mman.h
@@ -106,17 +106,6 @@
 /* compatibility flags */
 #define MAP_FILE	0
 
-/*
- * When MAP_HUGETLB is set bits [26:31] encode the log2 of the huge page size.
- * This gives us 6 bits, which is enough until someone invents 128 bit address
- * spaces.
- *
- * Assume these are all power of twos.
- * When 0 use the default page size.
- */
-#define MAP_HUGE_SHIFT	26
-#define MAP_HUGE_MASK	0x3f
-
 #define PKEY_DISABLE_ACCESS	0x1
 #define PKEY_DISABLE_WRITE	0x2
 #define PKEY_ACCESS_MASK	(PKEY_DISABLE_ACCESS |\
diff -puN include/uapi/asm-generic/mman-common.h~mm-arch-consolidate-mmap-hugetlb-size-encodings include/uapi/asm-generic/mman-common.h
--- a/include/uapi/asm-generic/mman-common.h~mm-arch-consolidate-mmap-hugetlb-size-encodings
+++ a/include/uapi/asm-generic/mman-common.h
@@ -61,17 +61,6 @@
 /* compatibility flags */
 #define MAP_FILE	0
 
-/*
- * When MAP_HUGETLB is set bits [26:31] encode the log2 of the huge page size.
- * This gives us 6 bits, which is enough until someone invents 128 bit address
- * spaces.
- *
- * Assume these are all power of twos.
- * When 0 use the default page size.
- */
-#define MAP_HUGE_SHIFT	26
-#define MAP_HUGE_MASK	0x3f
-
 #define PKEY_DISABLE_ACCESS	0x1
 #define PKEY_DISABLE_WRITE	0x2
 #define PKEY_ACCESS_MASK	(PKEY_DISABLE_ACCESS |\
diff -puN include/uapi/linux/mman.h~mm-arch-consolidate-mmap-hugetlb-size-encodings include/uapi/linux/mman.h
--- a/include/uapi/linux/mman.h~mm-arch-consolidate-mmap-hugetlb-size-encodings
+++ a/include/uapi/linux/mman.h
@@ -2,6 +2,7 @@
 #define _UAPI_LINUX_MMAN_H
 
 #include <asm/mman.h>
+#include <asm-generic/hugetlb_encode.h>
 
 #define MREMAP_MAYMOVE	1
 #define MREMAP_FIXED	2
@@ -10,4 +11,25 @@
 #define OVERCOMMIT_ALWAYS		1
 #define OVERCOMMIT_NEVER		2
 
+/*
+ * Huge page size encoding when MAP_HUGETLB is specified, and a huge page
+ * size other than the default is desired.  See hugetlb_encode.h.
+ * All known huge page size encodings are provided here.  It is the
+ * responsibility of the application to know which sizes are supported on
+ * the running system.  See mmap(2) man page for details.
+ */
+#define MAP_HUGE_SHIFT	HUGETLB_FLAG_ENCODE_SHIFT
+#define MAP_HUGE_MASK	HUGETLB_FLAG_ENCODE_MASK
+
+#define MAP_HUGE_64KB	HUGETLB_FLAG_ENCODE_64KB
+#define MAP_HUGE_512KB	HUGETLB_FLAG_ENCODE_512KB
+#define MAP_HUGE_1MB	HUGETLB_FLAG_ENCODE_1MB
+#define MAP_HUGE_2MB	HUGETLB_FLAG_ENCODE_2MB
+#define MAP_HUGE_8MB	HUGETLB_FLAG_ENCODE_8MB
+#define MAP_HUGE_16MB	HUGETLB_FLAG_ENCODE_16MB
+#define MAP_HUGE_256MB	HUGETLB_FLAG_ENCODE_256MB
+#define MAP_HUGE_1GB	HUGETLB_FLAG_ENCODE_1GB
+#define MAP_HUGE_2GB	HUGETLB_FLAG_ENCODE_2GB
+#define MAP_HUGE_16GB	HUGETLB_FLAG_ENCODE_16GB
+
 #endif /* _UAPI_LINUX_MMAN_H */
_
