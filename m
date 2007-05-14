From: akpm@linux-foundation.org
Subject: + m68k-implement-__clear_user.patch added to -mm tree
Date: Mon, 14 May 2007 13:48:30 -0700
Message-ID: <200705142048.l4EKmUdc025905@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755805AbXENUsk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 16:48:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, davidel@xmailserver.org


The patch titled
     m68k: implement __clear_user()
has been added to the -mm tree.  Its filename is
     m68k-implement-__clear_user.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m68k: implement __clear_user()
From: Geert Uytterhoeven <geert@linux-m68k.org>

m68k: implement __clear_user(), which is needed by fs/signalfd.c

Since we always let the MMU do all checking, clear_user() and __clear_user()
are identical. The old clear_user() is renamed to __clear_user() for
consistency.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/lib/uaccess.c    |    4 ++--
 include/asm-m68k/uaccess.h |    4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN arch/m68k/lib/uaccess.c~m68k-implement-__clear_user arch/m68k/lib/uaccess.c
--- a/arch/m68k/lib/uaccess.c~m68k-implement-__clear_user
+++ a/arch/m68k/lib/uaccess.c
@@ -181,7 +181,7 @@ EXPORT_SYMBOL(strnlen_user);
  * Zero Userspace
  */
 
-unsigned long clear_user(void __user *to, unsigned long n)
+unsigned long __clear_user(void __user *to, unsigned long n)
 {
 	unsigned long res;
 
@@ -219,4 +219,4 @@ unsigned long clear_user(void __user *to
 
     return res;
 }
-EXPORT_SYMBOL(clear_user);
+EXPORT_SYMBOL(__clear_user);
diff -puN include/asm-m68k/uaccess.h~m68k-implement-__clear_user include/asm-m68k/uaccess.h
--- a/include/asm-m68k/uaccess.h~m68k-implement-__clear_user
+++ a/include/asm-m68k/uaccess.h
@@ -361,7 +361,9 @@ __constant_copy_to_user(void __user *to,
 
 long strncpy_from_user(char *dst, const char __user *src, long count);
 long strnlen_user(const char __user *src, long n);
-unsigned long clear_user(void __user *to, unsigned long n);
+unsigned long __clear_user(void __user *to, unsigned long n);
+
+#define clear_user	__clear_user
 
 #define strlen_user(str) strnlen_user(str, 32767)
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

m68k-implement-__clear_user.patch
git-dvb.patch
