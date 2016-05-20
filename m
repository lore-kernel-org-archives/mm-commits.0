From: akpm@linux-foundation.org
Subject: [patch 062/162] x86/kasan: instrument user memory access API
Date: Fri, 20 May 2016 16:59:31 -0700
Message-ID: <573fa4e3.ElA7ili7US5xg/VX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbcETX7c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:59:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de

From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: x86/kasan: instrument user memory access API

Exchange between user and kernel memory is coded in assembly language. 
Which means that such accesses won't be spotted by KASAN as a compiler
instruments only C code.

Add explicit KASAN checks to user memory access API to ensure that
userspace writes to (or reads from) a valid kernel memory.

Note: Unlike others strncpy_from_user() is written mostly in C and KASAN
sees memory accesses in it.  However, it makes sense to add explicit check
for all @count bytes that *potentially* could be written to the kernel.

[aryabinin@virtuozzo.com: move kasan check under the condition]
  Link: http://lkml.kernel.org/r/1462869209-21096-1-git-send-email-aryabinin@virtuozzo.com
Link: http://lkml.kernel.org/r/1462538722-1574-4-git-send-email-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/uaccess.h    |    5 +++++
 arch/x86/include/asm/uaccess_64.h |    7 +++++++
 lib/strncpy_from_user.c           |    2 ++
 3 files changed, 14 insertions(+)

diff -puN arch/x86/include/asm/uaccess.h~x86-kasan-instrument-user-memory-access-api arch/x86/include/asm/uaccess.h
--- a/arch/x86/include/asm/uaccess.h~x86-kasan-instrument-user-memory-access-api
+++ a/arch/x86/include/asm/uaccess.h
@@ -5,6 +5,7 @@
  */
 #include <linux/errno.h>
 #include <linux/compiler.h>
+#include <linux/kasan-checks.h>
 #include <linux/thread_info.h>
 #include <linux/string.h>
 #include <asm/asm.h>
@@ -721,6 +722,8 @@ copy_from_user(void *to, const void __us
 
 	might_fault();
 
+	kasan_check_write(to, n);
+
 	/*
 	 * While we would like to have the compiler do the checking for us
 	 * even in the non-constant size case, any false positives there are
@@ -754,6 +757,8 @@ copy_to_user(void __user *to, const void
 {
 	int sz = __compiletime_object_size(from);
 
+	kasan_check_read(from, n);
+
 	might_fault();
 
 	/* See the comment in copy_from_user() above. */
diff -puN arch/x86/include/asm/uaccess_64.h~x86-kasan-instrument-user-memory-access-api arch/x86/include/asm/uaccess_64.h
--- a/arch/x86/include/asm/uaccess_64.h~x86-kasan-instrument-user-memory-access-api
+++ a/arch/x86/include/asm/uaccess_64.h
@@ -7,6 +7,7 @@
 #include <linux/compiler.h>
 #include <linux/errno.h>
 #include <linux/lockdep.h>
+#include <linux/kasan-checks.h>
 #include <asm/alternative.h>
 #include <asm/cpufeatures.h>
 #include <asm/page.h>
@@ -109,6 +110,7 @@ static __always_inline __must_check
 int __copy_from_user(void *dst, const void __user *src, unsigned size)
 {
 	might_fault();
+	kasan_check_write(dst, size);
 	return __copy_from_user_nocheck(dst, src, size);
 }
 
@@ -175,6 +177,7 @@ static __always_inline __must_check
 int __copy_to_user(void __user *dst, const void *src, unsigned size)
 {
 	might_fault();
+	kasan_check_read(src, size);
 	return __copy_to_user_nocheck(dst, src, size);
 }
 
@@ -242,12 +245,14 @@ int __copy_in_user(void __user *dst, con
 static __must_check __always_inline int
 __copy_from_user_inatomic(void *dst, const void __user *src, unsigned size)
 {
+	kasan_check_write(dst, size);
 	return __copy_from_user_nocheck(dst, src, size);
 }
 
 static __must_check __always_inline int
 __copy_to_user_inatomic(void __user *dst, const void *src, unsigned size)
 {
+	kasan_check_read(src, size);
 	return __copy_to_user_nocheck(dst, src, size);
 }
 
@@ -258,6 +263,7 @@ static inline int
 __copy_from_user_nocache(void *dst, const void __user *src, unsigned size)
 {
 	might_fault();
+	kasan_check_write(dst, size);
 	return __copy_user_nocache(dst, src, size, 1);
 }
 
@@ -265,6 +271,7 @@ static inline int
 __copy_from_user_inatomic_nocache(void *dst, const void __user *src,
 				  unsigned size)
 {
+	kasan_check_write(dst, size);
 	return __copy_user_nocache(dst, src, size, 0);
 }
 
diff -puN lib/strncpy_from_user.c~x86-kasan-instrument-user-memory-access-api lib/strncpy_from_user.c
--- a/lib/strncpy_from_user.c~x86-kasan-instrument-user-memory-access-api
+++ a/lib/strncpy_from_user.c
@@ -1,5 +1,6 @@
 #include <linux/compiler.h>
 #include <linux/export.h>
+#include <linux/kasan-checks.h>
 #include <linux/uaccess.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -109,6 +110,7 @@ long strncpy_from_user(char *dst, const
 		unsigned long max = max_addr - src_addr;
 		long retval;
 
+		kasan_check_write(dst, count);
 		user_access_begin();
 		retval = do_strncpy_from_user(dst, src, count, max);
 		user_access_end();
_
