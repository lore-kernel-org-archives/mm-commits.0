From: akpm@linux-foundation.org
Subject: [patch 08/16] fortify: use WARN instead of BUG for now
Date: Wed, 02 Aug 2017 13:32:06 -0700
Message-ID: <598236c6.5zsRNFUQTD9/7toc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45998 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752986AbdHBUcH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 16:32:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, keescook@chromium.org, danielmicay@gmail.com, jpoimboe@redhat.com

From: Kees Cook <keescook@chromium.org>
Subject: fortify: use WARN instead of BUG for now

While CONFIG_FORTIFY_SOURCE continues to shake out, don't unconditionally
use BUG(), opting instead for WARN().  This also renames fortify_panic()
to fortify_overflow() which better matches what it is being called for.

[akpm@linux-foundation.org: remove fortify_overflow from tools/objtool/check.c:global_noreturns, per Josh]
Link: http://lkml.kernel.org/r/20170726185219.GA57833@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/boot/compressed/misc.c |    2 +-
 include/linux/string.h          |   30 +++++++++++++++---------------
 lib/string.c                    |    7 +++----
 tools/objtool/check.c           |    1 -
 4 files changed, 19 insertions(+), 21 deletions(-)

diff -puN arch/x86/boot/compressed/misc.c~fortify-use-warn-instead-of-bug-for-now arch/x86/boot/compressed/misc.c
--- a/arch/x86/boot/compressed/misc.c~fortify-use-warn-instead-of-bug-for-now
+++ a/arch/x86/boot/compressed/misc.c
@@ -412,7 +412,7 @@ asmlinkage __visible void *extract_kerne
 	return output;
 }
 
-void fortify_panic(const char *name)
+void fortify_overflow(const char *name)
 {
 	error("detected buffer overflow");
 }
diff -puN include/linux/string.h~fortify-use-warn-instead-of-bug-for-now include/linux/string.h
--- a/include/linux/string.h~fortify-use-warn-instead-of-bug-for-now
+++ a/include/linux/string.h
@@ -197,7 +197,7 @@ static inline const char *kbasename(cons
 #define __FORTIFY_INLINE extern __always_inline __attribute__((gnu_inline))
 #define __RENAME(x) __asm__(#x)
 
-void fortify_panic(const char *name) __noreturn __cold;
+void fortify_overflow(const char *name) __cold;
 void __read_overflow(void) __compiletime_error("detected read beyond size of object passed as 1st parameter");
 void __read_overflow2(void) __compiletime_error("detected read beyond size of object passed as 2nd parameter");
 void __write_overflow(void) __compiletime_error("detected write beyond size of object passed as 1st parameter");
@@ -209,7 +209,7 @@ __FORTIFY_INLINE char *strncpy(char *p,
 	if (__builtin_constant_p(size) && p_size < size)
 		__write_overflow();
 	if (p_size < size)
-		fortify_panic(__func__);
+		fortify_overflow(__func__);
 	return __builtin_strncpy(p, q, size);
 }
 
@@ -219,7 +219,7 @@ __FORTIFY_INLINE char *strcat(char *p, c
 	if (p_size == (size_t)-1)
 		return __builtin_strcat(p, q);
 	if (strlcat(p, q, p_size) >= p_size)
-		fortify_panic(__func__);
+		fortify_overflow(__func__);
 	return p;
 }
 
@@ -231,7 +231,7 @@ __FORTIFY_INLINE __kernel_size_t strlen(
 		return __builtin_strlen(p);
 	ret = strnlen(p, p_size);
 	if (p_size <= ret)
-		fortify_panic(__func__);
+		fortify_overflow(__func__);
 	return ret;
 }
 
@@ -241,7 +241,7 @@ __FORTIFY_INLINE __kernel_size_t strnlen
 	size_t p_size = __builtin_object_size(p, 0);
 	__kernel_size_t ret = __real_strnlen(p, maxlen < p_size ? maxlen : p_size);
 	if (p_size <= ret && maxlen != ret)
-		fortify_panic(__func__);
+		fortify_overflow(__func__);
 	return ret;
 }
 
@@ -260,7 +260,7 @@ __FORTIFY_INLINE size_t strlcpy(char *p,
 		if (__builtin_constant_p(len) && len >= p_size)
 			__write_overflow();
 		if (len >= p_size)
-			fortify_panic(__func__);
+			fortify_overflow(__func__);
 		__builtin_memcpy(p, q, len);
 		p[len] = '\0';
 	}
@@ -278,7 +278,7 @@ __FORTIFY_INLINE char *strncat(char *p,
 	p_len = strlen(p);
 	copy_len = strnlen(q, count);
 	if (p_size < p_len + copy_len + 1)
-		fortify_panic(__func__);
+		fortify_overflow(__func__);
 	__builtin_memcpy(p + p_len, q, copy_len);
 	p[p_len + copy_len] = '\0';
 	return p;
@@ -290,7 +290,7 @@ __FORTIFY_INLINE void *memset(void *p, i
 	if (__builtin_constant_p(size) && p_size < size)
 		__write_overflow();
 	if (p_size < size)
-		fortify_panic(__func__);
+		fortify_overflow(__func__);
 	return __builtin_memset(p, c, size);
 }
 
@@ -305,7 +305,7 @@ __FORTIFY_INLINE void *memcpy(void *p, c
 			__read_overflow2();
 	}
 	if (p_size < size || q_size < size)
-		fortify_panic(__func__);
+		fortify_overflow(__func__);
 	return __builtin_memcpy(p, q, size);
 }
 
@@ -320,7 +320,7 @@ __FORTIFY_INLINE void *memmove(void *p,
 			__read_overflow2();
 	}
 	if (p_size < size || q_size < size)
-		fortify_panic(__func__);
+		fortify_overflow(__func__);
 	return __builtin_memmove(p, q, size);
 }
 
@@ -331,7 +331,7 @@ __FORTIFY_INLINE void *memscan(void *p,
 	if (__builtin_constant_p(size) && p_size < size)
 		__read_overflow();
 	if (p_size < size)
-		fortify_panic(__func__);
+		fortify_overflow(__func__);
 	return __real_memscan(p, c, size);
 }
 
@@ -346,7 +346,7 @@ __FORTIFY_INLINE int memcmp(const void *
 			__read_overflow2();
 	}
 	if (p_size < size || q_size < size)
-		fortify_panic(__func__);
+		fortify_overflow(__func__);
 	return __builtin_memcmp(p, q, size);
 }
 
@@ -356,7 +356,7 @@ __FORTIFY_INLINE void *memchr(const void
 	if (__builtin_constant_p(size) && p_size < size)
 		__read_overflow();
 	if (p_size < size)
-		fortify_panic(__func__);
+		fortify_overflow(__func__);
 	return __builtin_memchr(p, c, size);
 }
 
@@ -367,7 +367,7 @@ __FORTIFY_INLINE void *memchr_inv(const
 	if (__builtin_constant_p(size) && p_size < size)
 		__read_overflow();
 	if (p_size < size)
-		fortify_panic(__func__);
+		fortify_overflow(__func__);
 	return __real_memchr_inv(p, c, size);
 }
 
@@ -378,7 +378,7 @@ __FORTIFY_INLINE void *kmemdup(const voi
 	if (__builtin_constant_p(size) && p_size < size)
 		__read_overflow();
 	if (p_size < size)
-		fortify_panic(__func__);
+		fortify_overflow(__func__);
 	return __real_kmemdup(p, size, gfp);
 }
 
diff -puN lib/string.c~fortify-use-warn-instead-of-bug-for-now lib/string.c
--- a/lib/string.c~fortify-use-warn-instead-of-bug-for-now
+++ a/lib/string.c
@@ -979,9 +979,8 @@ char *strreplace(char *s, char old, char
 }
 EXPORT_SYMBOL(strreplace);
 
-void fortify_panic(const char *name)
+void fortify_overflow(const char *name)
 {
-	pr_emerg("detected buffer overflow in %s\n", name);
-	BUG();
+	WARN(1, "detected buffer overflow in %s\n", name);
 }
-EXPORT_SYMBOL(fortify_panic);
+EXPORT_SYMBOL(fortify_overflow);
diff -puN tools/objtool/check.c~fortify-use-warn-instead-of-bug-for-now tools/objtool/check.c
--- a/tools/objtool/check.c~fortify-use-warn-instead-of-bug-for-now
+++ a/tools/objtool/check.c
@@ -156,7 +156,6 @@ static int __dead_end_function(struct ob
 		"kvm_spurious_fault",
 		"__reiserfs_panic",
 		"lbug_with_loc",
-		"fortify_panic",
 	};
 
 	if (func->bind == STB_WEAK)
_
