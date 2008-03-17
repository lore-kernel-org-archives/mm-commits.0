From: akpm@linux-foundation.org
Subject: - h8300-fix-recent-uaccess-breakage.patch removed from -mm tree
Date: Mon, 17 Mar 2008 13:57:24 -0700
Message-ID: <200803172057.m2HKvOGA030622@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59579 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756663AbYCQU6I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 16:58:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ysato@users.sourceforge.jp, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     h8300: fix recent uaccess breakage
has been removed from the -mm tree.  Its filename was
     h8300-fix-recent-uaccess-breakage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: h8300: fix recent uaccess breakage
From: Yoshinori Sato <ysato@users.sourceforge.jp>

Al Viro wrote:
>
> 	After that commit in asm-h8300/uaccess.h we have
>
> #define get_user(x, ptr)                                        \
> ({                                                              \
>     int __gu_err = 0;                                           \
>     uint32_t __gu_val = 0;                              \
>     ^^^^^^^^^^^^^^^^^
>     switch (sizeof(*(ptr))) {                                   \
>     case 1:                                                     \
>     case 2:                                                     \
>     case 4:                                                     \
>         __gu_val = *(ptr);                                      \
>         break;                                                  \
>     case 8:                                                     \
>         memcpy(&__gu_val, ptr, sizeof (*(ptr)));                \
>                                ^^^^^^^^^^^^^^^^
>
> which, of course, is FUBAR whenever we actually hit that case - memcpy of
> 8 bytes into uint32_t is obviously wrong.  Why don't we simply do

Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-h8300/uaccess.h |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN include/asm-h8300/uaccess.h~h8300-fix-recent-uaccess-breakage include/asm-h8300/uaccess.h
--- a/include/asm-h8300/uaccess.h~h8300-fix-recent-uaccess-breakage
+++ a/include/asm-h8300/uaccess.h
@@ -91,22 +91,19 @@ extern int __put_user_bad(void);
 #define get_user(x, ptr)					\
 ({								\
     int __gu_err = 0;						\
-    uint32_t __gu_val = 0;				\
+    typeof(*(ptr)) __gu_val = *ptr;				\
     switch (sizeof(*(ptr))) {					\
     case 1:							\
     case 2:							\
     case 4:							\
-	__gu_val = *(ptr);	                		\
-	break;							\
-    case 8:							\
-	memcpy(&__gu_val, ptr, sizeof (*(ptr))); 		\
+    case 8: 							\
 	break;							\
     default:							\
-	__gu_val = 0;						\
 	__gu_err = __get_user_bad();				\
+	__gu_val = 0;						\
 	break;							\
     }								\
-    (x) = (typeof(*(ptr)))__gu_val;				\
+    (x) = __gu_val;						\
     __gu_err;							\
 })
 #define __get_user(x, ptr) get_user(x, ptr)
_

Patches currently in -mm which might be from ysato@users.sourceforge.jp are

elf-use-elf_core_eflags-for-kcore-elf-header-flags.patch

