From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 28 Feb 2017 12:49:01 -0800
Message-ID: <58b5e23d.1bmvT1tLfY5pWXYh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55810 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751754AbdB1Vay (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 16:30:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |   15 ---------------
 1 file changed, 15 deletions(-)

diff -puN include/linux/compiler-gcc.h~linux-next-git-rejects include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~linux-next-git-rejects
+++ a/include/linux/compiler-gcc.h
@@ -199,24 +199,15 @@
 
 #ifdef CONFIG_STACK_VALIDATION
 #define annotate_unreachable() ({					\
-<<<<<<< HEAD
-	asm("%c0:\t\n"							\
-	    ".pushsection __unreachable, \"a\"\t\n"			\
-	    ".long %c0b\t\n"						\
-	    ".popsection\t\n" : : "i" (__LINE__));			\
-=======
 	asm("1:\t\n"							\
 	    ".pushsection __unreachable, \"a\"\t\n"			\
 	    ".long 1b\t\n"						\
 	    ".popsection\t\n");						\
->>>>>>> linux-next/akpm-base
 })
 #else
 #define annotate_unreachable()
 #endif
 
-<<<<<<< HEAD
-=======
 /*
  * The initify gcc-plugin attempts to identify const arguments that are only
  * used during init (see __init and __exit), so they can be moved to the
@@ -239,7 +230,6 @@
 #define __unverified_nocapture(...) __attribute__((unverified_nocapture(__VA_ARGS__)))
 #endif
 
->>>>>>> linux-next/akpm-base
 /*
  * Mark a position in code as unreachable.  This can be used to
  * suppress control flow warnings after asm blocks that transfer
@@ -249,12 +239,7 @@
  * this in the preprocessor, but we can live with this because they're
  * unreleased.  Really, we need to have autoconf for the kernel.
  */
-<<<<<<< HEAD
-#define unreachable() \
-	do { annotate_unreachable(); __builtin_unreachable(); } while (0)
-=======
 #define unreachable() annotate_unreachable(); __builtin_unreachable()
->>>>>>> linux-next/akpm-base
 
 /* Mark a function definition as prohibited from being cloned. */
 #define __noclone	__attribute__((__noclone__, __optimize__("no-tracer")))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

