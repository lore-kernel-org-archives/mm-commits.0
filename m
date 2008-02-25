From: akpm@linux-foundation.org
Subject: - h8300-uaccessh-update.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:45:30 -0800
Message-ID: <200802250045.m1P0jUb5006264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754016AbYBYAsk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:48:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     h8300: uaccess.h update
has been removed from the -mm tree.  Its filename was
     h8300-uaccessh-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

elf-use-elf_core_eflags-for-kcore-elf-header-flags.patch
