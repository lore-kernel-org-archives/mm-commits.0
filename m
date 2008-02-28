From: akpm@linux-foundation.org
Subject: + cris-correct-usage-of-__user-for-copy-to-and-from-user-space-in-lib-usercopy-and-uaccessh-try-2.patch added to -mm tree
Date: Thu, 28 Feb 2008 12:41:34 -0800
Message-ID: <200802282041.m1SKfY79019431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757826AbYB1UmJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 15:42:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com, mikael.starvik@axis.com


The patch titled
     cris: correct usage of __user for copy to and from user space in lib/usercopy and uaccess.h
has been added to the -mm tree.  Its filename is
     cris-correct-usage-of-__user-for-copy-to-and-from-user-space-in-lib-usercopy-and-uaccessh-try-2.patch

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
Subject: cris: correct usage of __user for copy to and from user space in lib/usercopy and uaccess.h
From: Jesper Nilsson <jesper.nilsson@axis.com>

Function __copy_user_zeroing in arch/lib/usercopy.c had the wrong parameter
set as __user, and in include/asm-cris/uaccess.h, it was not set at all for
some of the calling functions.

This will cut the number of warnings quite dramatically when using sparse.

While we're here, remove useless CVS log and correct confusing typo.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/lib/usercopy.c |    2 -
 arch/cris/arch-v32/lib/usercopy.c |    2 -
 include/asm-cris/uaccess.h        |   53 ++++------------------------
 3 files changed, 11 insertions(+), 46 deletions(-)

diff -puN arch/cris/arch-v10/lib/usercopy.c~cris-correct-usage-of-__user-for-copy-to-and-from-user-space-in-lib-usercopy-and-uaccessh-try-2 arch/cris/arch-v10/lib/usercopy.c
--- a/arch/cris/arch-v10/lib/usercopy.c~cris-correct-usage-of-__user-for-copy-to-and-from-user-space-in-lib-usercopy-and-uaccessh-try-2
+++ a/arch/cris/arch-v10/lib/usercopy.c
@@ -193,7 +193,7 @@ __copy_user (void __user *pdst, const vo
    inaccessible.  */
 
 unsigned long
-__copy_user_zeroing (void __user *pdst, const void *psrc, unsigned long pn)
+__copy_user_zeroing(void *pdst, const void __user *psrc, unsigned long pn)
 {
   /* We want the parameters put in special registers.
      Make sure the compiler is able to make something useful of this.
diff -puN arch/cris/arch-v32/lib/usercopy.c~cris-correct-usage-of-__user-for-copy-to-and-from-user-space-in-lib-usercopy-and-uaccessh-try-2 arch/cris/arch-v32/lib/usercopy.c
--- a/arch/cris/arch-v32/lib/usercopy.c~cris-correct-usage-of-__user-for-copy-to-and-from-user-space-in-lib-usercopy-and-uaccessh-try-2
+++ a/arch/cris/arch-v32/lib/usercopy.c
@@ -161,7 +161,7 @@ __copy_user (void __user *pdst, const vo
    inaccessible.  */
 
 unsigned long
-__copy_user_zeroing (void __user *pdst, const void *psrc, unsigned long pn)
+__copy_user_zeroing(void *pdst, const void __user *psrc, unsigned long pn)
 {
   /* We want the parameters put in special registers.
      Make sure the compiler is able to make something useful of this.
diff -puN include/asm-cris/uaccess.h~cris-correct-usage-of-__user-for-copy-to-and-from-user-space-in-lib-usercopy-and-uaccessh-try-2 include/asm-cris/uaccess.h
--- a/include/asm-cris/uaccess.h~cris-correct-usage-of-__user-for-copy-to-and-from-user-space-in-lib-usercopy-and-uaccessh-try-2
+++ a/include/asm-cris/uaccess.h
@@ -1,43 +1,6 @@
 /* 
  * Authors:    Bjorn Wesen (bjornw@axis.com)
  *	       Hans-Peter Nilsson (hp@axis.com)
- *
- * $Log: uaccess.h,v $
- * Revision 1.8  2001/10/29 13:01:48  bjornw
- * Removed unused variable tmp2 in strnlen_user
- *
- * Revision 1.7  2001/10/02 12:44:52  hp
- * Add support for 64-bit put_user/get_user
- *
- * Revision 1.6  2001/10/01 14:51:17  bjornw
- * Added register prefixes and removed underscores
- *
- * Revision 1.5  2000/10/25 03:33:21  hp
- * - Provide implementation for everything else but get_user and put_user;
- *   copying inline to/from user for constant length 0..16, 20, 24, and
- *   clearing for 0..4, 8, 12, 16, 20, 24, strncpy_from_user and strnlen_user
- *   always inline.
- * - Constraints for destination addr in get_user cannot be memory, only reg.
- * - Correct labels for PC at expected fault points.
- * - Nits with assembly code.
- * - Don't use statement expressions without value; use "do {} while (0)".
- * - Return correct values from __generic_... functions.
- *
- * Revision 1.4  2000/09/12 16:28:25  bjornw
- * * Removed comments from the get/put user asm code
- * * Constrains for destination addr in put_user cannot be memory, only reg
- *
- * Revision 1.3  2000/09/12 14:30:20  bjornw
- * MAX_ADDR_USER does not exist anymore
- *
- * Revision 1.2  2000/07/13 15:52:48  bjornw
- * New user-access functions
- *
- * Revision 1.1.1.1  2000/07/10 16:32:31  bjornw
- * CRIS architecture, working draft
- *
- *
- *
  */
 
 /* Asm:s have been tweaked (within the domain of correctness) to give
@@ -209,9 +172,9 @@ extern long __get_user_bad(void);
 /* More complex functions.  Most are inline, but some call functions that
    live in lib/usercopy.c  */
 
-extern unsigned long __copy_user(void *to, const void *from, unsigned long n);
-extern unsigned long __copy_user_zeroing(void *to, const void *from, unsigned long n);
-extern unsigned long __do_clear_user(void *to, unsigned long n);
+extern unsigned long __copy_user(void __user *to, const void *from, unsigned long n);
+extern unsigned long __copy_user_zeroing(void *to, const void __user *from, unsigned long n);
+extern unsigned long __do_clear_user(void __user *to, unsigned long n);
 
 static inline unsigned long
 __generic_copy_to_user(void __user *to, const void *from, unsigned long n)
@@ -253,7 +216,7 @@ strncpy_from_user(char *dst, const char 
 }
 
 
-/* Note that if these expand awfully if made into switch constructs, so
+/* Note that these expand awfully if made into switch constructs, so
    don't do that.  */
 
 static inline unsigned long
@@ -407,19 +370,21 @@ __constant_clear_user(void __user *to, u
  */
 
 static inline unsigned long
-__generic_copy_from_user_nocheck(void *to, const void *from, unsigned long n)
+__generic_copy_from_user_nocheck(void *to, const void __user *from,
+				 unsigned long n)
 {
 	return __copy_user_zeroing(to,from,n);
 }
 
 static inline unsigned long
-__generic_copy_to_user_nocheck(void *to, const void *from, unsigned long n)
+__generic_copy_to_user_nocheck(void __user *to, const void *from,
+			       unsigned long n)
 {
 	return __copy_user(to,from,n);
 }
 
 static inline unsigned long
-__generic_clear_user_nocheck(void *to, unsigned long n)
+__generic_clear_user_nocheck(void __user *to, unsigned long n)
 {
 	return __do_clear_user(to,n);
 }
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

cris-v10-include-mmh-instead-of-vmstath-in-kernel-timec.patch
cris-import-stringc-memcpy-from-newlib-fixes-compile-error-with-gcc-4.patch
cris-correct-usage-of-__user-for-copy-to-and-from-user-space-in-lib-usercopy-and-uaccessh-try-2.patch

