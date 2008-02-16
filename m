From: akpm@linux-foundation.org
Subject: + h8300-uaccessh-update.patch added to -mm tree
Date: Fri, 15 Feb 2008 22:44:11 -0800
Message-ID: <200802160644.m1G6iB87012836@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44056 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752314AbYBPGo0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 16 Feb 2008 01:44:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ysato@users.sourceforge.jp


The patch titled
     h8300: uaccess.h update
has been added to the -mm tree.  Its filename is
     h8300-uaccessh-update.patch

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
Subject: h8300: uaccess.h update
From: Yoshinori Sato <ysato@users.sourceforge.jp>

get_user const *ptr access fix.

Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-h8300/uaccess.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/asm-h8300/uaccess.h~h8300-uaccessh-update include/asm-h8300/uaccess.h
--- a/include/asm-h8300/uaccess.h~h8300-uaccessh-update
+++ a/include/asm-h8300/uaccess.h
@@ -91,7 +91,7 @@ extern int __put_user_bad(void);
 #define get_user(x, ptr)					\
 ({								\
     int __gu_err = 0;						\
-    typeof(*(ptr)) __gu_val = 0;				\
+    uint32_t __gu_val = 0;				\
     switch (sizeof(*(ptr))) {					\
     case 1:							\
     case 2:							\
@@ -106,7 +106,7 @@ extern int __put_user_bad(void);
 	__gu_err = __get_user_bad();				\
 	break;							\
     }								\
-    (x) = __gu_val;						\
+    (x) = (typeof(*(ptr)))__gu_val;				\
     __gu_err;							\
 })
 #define __get_user(x, ptr) get_user(x, ptr)
_

Patches currently in -mm which might be from ysato@users.sourceforge.jp are

h8300-signalc-typo-fix.patch
h8300-uaccessh-update.patch
h8300-config_kallsyms-fix.patch
h8300-irq-handling-update.patch
h8300-defconfig-update.patch
inflate-refactor-inflate-malloc-code.patch
elf-use-elf_core_eflags-for-kcore-elf-header-flags.patch
