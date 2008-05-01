From: akpm@linux-foundation.org
Subject: - remove-__kernel__-tests-of-unexported-headers-under-asm-generic.patch removed from -mm tree
Date: Thu, 01 May 2008 02:33:24 -0700
Message-ID: <200805010933.m419XOHb031139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755136AbYEAJd3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:33:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     remove __KERNEL__ tests of unexported headers under asm-generic/
has been removed from the -mm tree.  Its filename was
     remove-__kernel__-tests-of-unexported-headers-under-asm-generic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove __KERNEL__ tests of unexported headers under asm-generic/
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bitops.h       |    4 ----
 include/asm-generic/futex.h        |    3 ---
 include/asm-generic/memory_model.h |    2 --
 include/asm-generic/page.h         |    2 --
 include/asm-generic/rtc.h          |    3 ---
 5 files changed, 14 deletions(-)

diff -puN include/asm-generic/bitops.h~remove-__kernel__-tests-of-unexported-headers-under-asm-generic include/asm-generic/bitops.h
--- a/include/asm-generic/bitops.h~remove-__kernel__-tests-of-unexported-headers-under-asm-generic
+++ a/include/asm-generic/bitops.h
@@ -17,8 +17,6 @@
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/find.h>
 
-#ifdef __KERNEL__
-
 #ifndef _LINUX_BITOPS_H
 #error only <linux/bitops.h> can be included directly
 #endif
@@ -32,6 +30,4 @@
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
 
-#endif /* __KERNEL__ */
-
 #endif /* _ASM_GENERIC_BITOPS_H */
diff -puN include/asm-generic/futex.h~remove-__kernel__-tests-of-unexported-headers-under-asm-generic include/asm-generic/futex.h
--- a/include/asm-generic/futex.h~remove-__kernel__-tests-of-unexported-headers-under-asm-generic
+++ a/include/asm-generic/futex.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_GENERIC_FUTEX_H
 #define _ASM_GENERIC_FUTEX_H
 
-#ifdef __KERNEL__
-
 #include <linux/futex.h>
 #include <linux/uaccess.h>
 #include <asm/errno.h>
@@ -56,4 +54,3 @@ futex_atomic_cmpxchg_inatomic(int __user
 }
 
 #endif
-#endif
diff -puN include/asm-generic/memory_model.h~remove-__kernel__-tests-of-unexported-headers-under-asm-generic include/asm-generic/memory_model.h
--- a/include/asm-generic/memory_model.h~remove-__kernel__-tests-of-unexported-headers-under-asm-generic
+++ a/include/asm-generic/memory_model.h
@@ -1,7 +1,6 @@
 #ifndef __ASM_MEMORY_MODEL_H
 #define __ASM_MEMORY_MODEL_H
 
-#ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
 #if defined(CONFIG_FLATMEM)
@@ -81,6 +80,5 @@ extern unsigned long page_to_pfn(struct 
 #endif /* CONFIG_OUT_OF_LINE_PFN_TO_PAGE */
 
 #endif /* __ASSEMBLY__ */
-#endif /* __KERNEL__ */
 
 #endif
diff -puN include/asm-generic/page.h~remove-__kernel__-tests-of-unexported-headers-under-asm-generic include/asm-generic/page.h
--- a/include/asm-generic/page.h~remove-__kernel__-tests-of-unexported-headers-under-asm-generic
+++ a/include/asm-generic/page.h
@@ -1,7 +1,6 @@
 #ifndef _ASM_GENERIC_PAGE_H
 #define _ASM_GENERIC_PAGE_H
 
-#ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
 #include <linux/compiler.h>
@@ -21,6 +20,5 @@ static __inline__ __attribute_const__ in
 }
 
 #endif	/* __ASSEMBLY__ */
-#endif	/* __KERNEL__ */
 
 #endif	/* _ASM_GENERIC_PAGE_H */
diff -puN include/asm-generic/rtc.h~remove-__kernel__-tests-of-unexported-headers-under-asm-generic include/asm-generic/rtc.h
--- a/include/asm-generic/rtc.h~remove-__kernel__-tests-of-unexported-headers-under-asm-generic
+++ a/include/asm-generic/rtc.h
@@ -12,8 +12,6 @@
 #ifndef __ASM_RTC_H__
 #define __ASM_RTC_H__
 
-#ifdef __KERNEL__
