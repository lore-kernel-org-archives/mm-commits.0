From: akpm@linux-foundation.org
Subject: + remove-__kernel__-tests-of-unexported-headers-under-asm-generic.patch added to -mm tree
Date: Thu, 03 Apr 2008 12:41:22 -0700
Message-ID: <200804031941.m33JfMTU019134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763665AbYDCTl0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2008 15:41:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca


The patch titled
     remove __KERNEL__ tests of unexported headers under asm-generic/
has been added to the -mm tree.  Its filename is
     remove-__kernel__-tests-of-unexported-headers-under-asm-generic.patch

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
-
 #include <linux/mc146818rtc.h>
 #include <linux/rtc.h>
 #include <linux/bcd.h>
@@ -213,5 +211,4 @@ static inline int set_rtc_pll(struct rtc
 	return -EINVAL;
 }
 
-#endif /* __KERNEL__ */
 #endif /* __ASM_RTC_H__ */
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
efs-update-error-msg-to-not-refer-to-deleted-read_inode.patch
git-powerpc.patch
git-ieee1394.patch
git-infiniband.patch
mmc-use-shorter-equivalent-set_current_state.patch
git-net.patch
git-nfsd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
kernel-explicitly-include-required-header-files-under-kernel.patch
remove-superfluous-include-of-stringh-from-percpuh.patch
kbuild-remove-duplicate-conflicting-entry-for-oomh.patch
kbuild-move-files-that-dont-check-__kernel__.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
mfd-use-shorter-set_current_state.patch
isdn-fix-obvious-cut-and-paste-error-in-st5481_usbc.patch
keys-explicitly-include-required-slabh-header-file.patch
nbd-delete-superfluous-test-for-__gnuc__.patch
generalize-asm-generic-ioctlh-to-allow-overriding-values.patch
edac-use-the-shorter-list_head-for-brevity.patch
afs-use-the-shorter-list_head-for-brevity.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch
remove-__kernel__-tests-of-unexported-headers-under-asm-generic.patch

