From: akpm@linux-foundation.org
Subject: - m68k-implement-__clear_user.patch removed from -mm tree
Date: Tue, 15 May 2007 11:07:13 -0700
Message-ID: <200705151807.l4FI7Cgw014150@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37692 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755329AbXEOSH0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 14:07:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     m68k: implement __clear_user()
has been removed from the -mm tree.  Its filename was
     m68k-implement-__clear_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-dvb.patch
