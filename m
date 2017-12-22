From: akpm@linux-foundation.org
Subject: + mm-introduce-map_fixed_safe-fix.patch added to -mm tree
Date: Thu, 21 Dec 2017 16:27:25 -0800
Message-ID: <5a3c516d.Txqoz18rNA/JdE7Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43208 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755826AbdLVA10 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Dec 2017 19:27:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-introduce-map_fixed_safe-fix
has been added to the -mm tree.  Its filename is
     mm-introduce-map_fixed_safe-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-map_fixed_safe-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-map_fixed_safe-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: mm-introduce-map_fixed_safe-fix

There's also a couple of stray whitespace changes in the version in
linux-next, and some inconsistent whitespace between the various mman.h
changes. Patch below to fix them up.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/uapi/asm/mman.h   |    3 +--
 arch/parisc/include/uapi/asm/mman.h |    3 +--
 arch/sparc/include/uapi/asm/mman.h  |    1 +
 arch/xtensa/include/uapi/asm/mman.h |    3 +--
 4 files changed, 4 insertions(+), 6 deletions(-)

diff -puN arch/mips/include/uapi/asm/mman.h~mm-introduce-map_fixed_safe-fix arch/mips/include/uapi/asm/mman.h
--- a/arch/mips/include/uapi/asm/mman.h~mm-introduce-map_fixed_safe-fix
+++ a/arch/mips/include/uapi/asm/mman.h
@@ -50,8 +50,7 @@
 #define MAP_NONBLOCK	0x20000		/* do not block on IO */
 #define MAP_STACK	0x40000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x80000		/* create a huge page mapping */
-
-#define MAP_FIXED_NOREPLACE	0x100000/* MAP_FIXED which doesn't unmap underlying mapping */
+#define MAP_FIXED_NOREPLACE 0x100000	/* MAP_FIXED which doesn't unmap underlying mapping */
 
 /*
  * Flags for msync
diff -puN arch/parisc/include/uapi/asm/mman.h~mm-introduce-map_fixed_safe-fix arch/parisc/include/uapi/asm/mman.h
--- a/arch/parisc/include/uapi/asm/mman.h~mm-introduce-map_fixed_safe-fix
+++ a/arch/parisc/include/uapi/asm/mman.h
@@ -26,8 +26,7 @@
 #define MAP_NONBLOCK	0x20000		/* do not block on IO */
 #define MAP_STACK	0x40000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x80000		/* create a huge page mapping */
-
-#define MAP_FIXED_NOREPLACE	0x100000/* MAP_FIXED which doesn't unmap underlying mapping */
+#define MAP_FIXED_NOREPLACE 0x100000	/* MAP_FIXED which doesn't unmap underlying mapping */
 
 #define MS_SYNC		1		/* synchronous memory sync */
 #define MS_ASYNC	2		/* sync memory asynchronously */
diff -puN arch/sparc/include/uapi/asm/mman.h~mm-introduce-map_fixed_safe-fix arch/sparc/include/uapi/asm/mman.h
--- a/arch/sparc/include/uapi/asm/mman.h~mm-introduce-map_fixed_safe-fix
+++ a/arch/sparc/include/uapi/asm/mman.h
@@ -25,4 +25,5 @@
 #define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
+
 #endif /* _UAPI__SPARC_MMAN_H__ */
diff -puN arch/xtensa/include/uapi/asm/mman.h~mm-introduce-map_fixed_safe-fix arch/xtensa/include/uapi/asm/mman.h
--- a/arch/xtensa/include/uapi/asm/mman.h~mm-introduce-map_fixed_safe-fix
+++ a/arch/xtensa/include/uapi/asm/mman.h
@@ -57,7 +57,7 @@
 #define MAP_NONBLOCK	0x20000		/* do not block on IO */
 #define MAP_STACK	0x40000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x80000		/* create a huge page mapping */
-#define MAP_FIXED_NOREPLACE	0x100000/* MAP_FIXED which doesn't unmap underlying mapping */
+#define MAP_FIXED_NOREPLACE 0x100000	/* MAP_FIXED which doesn't unmap underlying mapping */
 #ifdef CONFIG_MMAP_ALLOW_UNINITIALIZED
 # define MAP_UNINITIALIZED 0x4000000	/* For anonymous mmap, memory could be
 					 * uninitialized */
@@ -65,7 +65,6 @@
 # define MAP_UNINITIALIZED 0x0		/* Don't support this flag */
 #endif
 
