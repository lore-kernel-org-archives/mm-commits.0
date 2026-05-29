Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDB6371867
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028759; cv=none; b=k6AxIOPqYSRZxgQKuMEgCTf39PSEAV8cF34X9ineS/4gYaHu/ZRQsTwbC1FTryXsw8IUQkU3XOYc6ORayHO5nH3dY8+by9kc15/wxytPl9fj4WlJQt4qmcRpiXaXgiSJPklsEtBuGU1nbQLtTjtDMGh44kU74IU4EPb5mzL6v58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028759; c=relaxed/simple;
	bh=+m0tmuSUI28p8o5+si9x3wE/b4VCnPXdOPJUNNbzEkM=;
	h=Date:To:From:Subject:Message-Id; b=oGvd5RQdms+W2zg5YjbY62DcRQGIPGAjypNVVo5C8P22Ge3vhRQUnXJv9wXQB6Mbt46sbgbDIr5nfEHdWXzU3AerdBySBOnAAOPkQwghh1M5ddpmqUGgbzCERkEoHMxeawTqB9DF59zK5J+oVj1qiaudwVvKE231ZyEMsTuc2YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d65yztpy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d65yztpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27011F00898;
	Fri, 29 May 2026 04:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028758;
	bh=1aKKlxxKfS6di6WqskfuN3U4u8tfUU8u+lPE5Rgsll8=;
	h=Date:To:From:Subject;
	b=d65yztpyKhU9JT/7nxZ471FC/lhx5X4XN0LFMmRjscpLZIg4c8m/OQ6F61rD9kWVb
	 P3DVRTohh4Cyn5x6o1UNcc4IL2udV35tqi2EDt3lPjBa8SDEBX+HavAgLggSnEkkeB
	 kwnHNXWI1sALQulDK+6INWSBJ6ydl4wU+LCH2bgI=
Date: Thu, 28 May 2026 21:25:57 -0700
To: mm-commits@vger.kernel.org,vmalik@redhat.com,rdunlap@infradead.org,peterz@infradead.org,mathieu.desnoyers@efficios.com,chleroy@kernel.org,arnd@arndb.de,aliceryhl@google.com,ynorov@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] uaccess-unify-inline-vs-outline-copy_fromto_user-selection.patch removed from -mm tree
Message-Id: <20260529042557.E27011F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: uaccess: unify inline vs outline copy_{from,to}_user() selection
has been removed from the -mm tree.  Its filename was
     uaccess-unify-inline-vs-outline-copy_fromto_user-selection.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yury Norov <ynorov@nvidia.com>
Subject: uaccess: unify inline vs outline copy_{from,to}_user() selection
Date: Fri, 24 Apr 2026 22:08:56 -0400

The kernel allows arches to select between inline and outline
implementations of the copy_{from,to}_user() by defining individual
INLINE_COPY_FROM_USER and INLINE_COPY_TO_USER, correspondingly.  However,
all arches enable or disable them always together.

Without the real use-case for one helper being inlined while the other
outlined, having independent controls is excessive and error prone.

Switch the codebase to the single unified INLINE_COPY_USER control.

Link: https://lore.kernel.org/20260425020857.356850-3-ynorov@nvidia.com
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Tested-by: Alice Ryhl <aliceryhl@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Viktor Malik <vmalik@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/uaccess.h        |    3 +--
 arch/arm/include/asm/uaccess.h        |    3 +--
 arch/arm64/include/asm/uaccess.h      |    3 +--
 arch/hexagon/include/asm/uaccess.h    |    3 +--
 arch/loongarch/include/asm/uaccess.h  |    3 +--
 arch/m68k/include/asm/uaccess.h       |    3 +--
 arch/microblaze/include/asm/uaccess.h |    3 +--
 arch/mips/include/asm/uaccess.h       |    3 +--
 arch/nios2/include/asm/uaccess.h      |    3 +--
 arch/openrisc/include/asm/uaccess.h   |    3 +--
 arch/parisc/include/asm/uaccess.h     |    3 +--
 arch/s390/include/asm/uaccess.h       |    3 +--
 arch/sh/include/asm/uaccess.h         |    3 +--
 arch/sparc/include/asm/uaccess_32.h   |    3 +--
 arch/sparc/include/asm/uaccess_64.h   |    3 +--
 arch/um/include/asm/uaccess.h         |    3 +--
 arch/xtensa/include/asm/uaccess.h     |    3 +--
 include/asm-generic/uaccess.h         |    3 +--
 include/linux/uaccess.h               |   12 ++++++------
 lib/usercopy.c                        |    4 +---
 rust/helpers/uaccess.c                |    4 +---
 21 files changed, 26 insertions(+), 48 deletions(-)

--- a/arch/arc/include/asm/uaccess.h~uaccess-unify-inline-vs-outline-copy_fromto_user-selection
+++ a/arch/arc/include/asm/uaccess.h
@@ -628,8 +628,7 @@ static inline unsigned long __clear_user
 	return res;
 }
 
-#define INLINE_COPY_TO_USER
-#define INLINE_COPY_FROM_USER
+#define INLINE_COPY_USER
 
 #define __clear_user			__clear_user
 
--- a/arch/arm64/include/asm/uaccess.h~uaccess-unify-inline-vs-outline-copy_fromto_user-selection
+++ a/arch/arm64/include/asm/uaccess.h
@@ -456,8 +456,7 @@ do {									\
 	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u8, label);	\
 } while (0)
 
-#define INLINE_COPY_TO_USER
-#define INLINE_COPY_FROM_USER
+#define INLINE_COPY_USER
 
 extern unsigned long __must_check __arch_clear_user(void __user *to, unsigned long n);
 static inline unsigned long __must_check __clear_user(void __user *to, unsigned long n)
--- a/arch/arm/include/asm/uaccess.h~uaccess-unify-inline-vs-outline-copy_fromto_user-selection
+++ a/arch/arm/include/asm/uaccess.h
@@ -616,8 +616,7 @@ raw_copy_to_user(void __user *to, const
 }
 #define __clear_user(addr, n)		(memset((void __force *)addr, 0, n), 0)
 #endif
-#define INLINE_COPY_TO_USER
-#define INLINE_COPY_FROM_USER
+#define INLINE_COPY_USER
 
 static inline unsigned long __must_check clear_user(void __user *to, unsigned long n)
 {
--- a/arch/hexagon/include/asm/uaccess.h~uaccess-unify-inline-vs-outline-copy_fromto_user-selection
+++ a/arch/hexagon/include/asm/uaccess.h
@@ -26,8 +26,7 @@ unsigned long raw_copy_from_user(void *t
 				     unsigned long n);
 unsigned long raw_copy_to_user(void __user *to, const void *from,
 				   unsigned long n);
-#define INLINE_COPY_FROM_USER
-#define INLINE_COPY_TO_USER
+#define INLINE_COPY_USER
 
 __kernel_size_t __clear_user_hexagon(void __user *dest, unsigned long count);
 #define __clear_user(a, s) __clear_user_hexagon((a), (s))
--- a/arch/loongarch/include/asm/uaccess.h~uaccess-unify-inline-vs-outline-copy_fromto_user-selection
+++ a/arch/loongarch/include/asm/uaccess.h
@@ -292,8 +292,7 @@ raw_copy_to_user(void __user *to, const
 	return __copy_user((__force void *)to, from, n);
 }
 
-#define INLINE_COPY_FROM_USER
-#define INLINE_COPY_TO_USER
+#define INLINE_COPY_USER
 
 /*
  * __clear_user: - Zero a block of memory in user space, with less checking.
--- a/arch/m68k/include/asm/uaccess.h~uaccess-unify-inline-vs-outline-copy_fromto_user-selection
+++ a/arch/m68k/include/asm/uaccess.h
@@ -377,8 +377,7 @@ raw_copy_to_user(void __user *to, const
 		return __constant_copy_to_user(to, from, n);
 	return __generic_copy_to_user(to, from, n);
 }
-#define INLINE_COPY_FROM_USER
-#define INLINE_COPY_TO_USER
+#define INLINE_COPY_USER
 
 #define __get_kernel_nofault(dst, src, type, err_label)			\
 do {									\
--- a/arch/microblaze/include/asm/uaccess.h~uaccess-unify-inline-vs-outline-copy_fromto_user-selection
+++ a/arch/microblaze/include/asm/uaccess.h
@@ -250,8 +250,7 @@ raw_copy_to_user(void __user *to, const
 {
 	return __copy_tofrom_user(to, (__force const void __user *)from, n);
 }
-#define INLINE_COPY_FROM_USER
-#define INLINE_COPY_TO_USER
+#define INLINE_COPY_USER
 
 /*
  * Copy a null terminated string from userspace.
--- a/arch/mips/include/asm/uaccess.h~uaccess-unify-inline-vs-outline-copy_fromto_user-selection
+++ a/arch/mips/include/asm/uaccess.h
@@ -433,8 +433,7 @@ raw_copy_to_user(void __user *to, const
 	return __cu_len_r;
 }
 
-#define INLINE_COPY_FROM_USER
-#define INLINE_COPY_TO_USER
+#define INLINE_COPY_USER
 
 extern __kernel_size_t __bzero(void __user *addr, __kernel_size_t size);
 
--- a/arch/nios2/include/asm/uaccess.h~uaccess-unify-inline-vs-outline-copy_fromto_user-selection
+++ a/arch/nios2/include/asm/uaccess.h
@@ -57,8 +57,7 @@ extern unsigned long
 raw_copy_from_user(void *to, const void __user *from, unsigned long n);
 extern unsigned long
 raw_copy_to_user(void __user *to, const void *from, unsigned long n);
-#define INLINE_COPY_FROM_USER
-#define INLINE_COPY_TO_USER
+#define INLINE_COPY_USER
 
 extern long strncpy_from_user(char *__to, const char __user *__from,
 			      long __len);
--- a/arch/openrisc/include/asm/uaccess.h~uaccess-unify-inline-vs-outline-copy_fromto_user-selection
+++ a/arch/openrisc/include/asm/uaccess.h
@@ -218,8 +218,7 @@ raw_copy_to_user(void __user *to, const
 {
 	return __copy_tofrom_user((__force void *)to, from, size);
 }
-#define INLINE_COPY_FROM_USER
-#define INLINE_COPY_TO_USER
+#define INLINE_COPY_USER
 
 extern unsigned long __clear_user(void __user *addr, unsigned long size);
 
--- a/arch/parisc/include/asm/uaccess.h~uaccess-unify-inline-vs-outline-copy_fromto_user-selection
+++ a/arch/parisc/include/asm/uaccess.h
@@ -197,7 +197,6 @@ unsigned long __must_check raw_copy_to_u
 					    unsigned long len);
 unsigned long __must_check raw_copy_from_user(void *dst, const void __user *src,
 					    unsigned long len);
-#define INLINE_COPY_TO_USER
-#define INLINE_COPY_FROM_USER
+#define INLINE_COPY_USER
 
 #endif /* __PARISC_UACCESS_H */
--- a/arch/s390/include/asm/uaccess.h~uaccess-unify-inline-vs-outline-copy_fromto_user-selection
+++ a/arch/s390/include/asm/uaccess.h
@@ -30,8 +30,7 @@ void debug_user_asce(int exit);
 #define uaccess_kmsan_or_inline __always_inline
 #endif
 
-#define INLINE_COPY_FROM_USER
-#define INLINE_COPY_TO_USER
+#define INLINE_COPY_USER
 
 static uaccess_kmsan_or_inline __must_check unsigned long
 raw_copy_from_user(void *to, const void __user *from, unsigned long size)
--- a/arch/sh/include/asm/uaccess.h~uaccess-unify-inline-vs-outline-copy_fromto_user-selection
+++ a/arch/sh/include/asm/uaccess.h
@@ -95,8 +95,7 @@ raw_copy_to_user(void __user *to, const
 {
 	return __copy_user((__force void *)to, from, n);
 }
-#define INLINE_COPY_FROM_USER
-#define INLINE_COPY_TO_USER
+#define INLINE_COPY_USER
 
 /*
  * Clear the area and return remaining number of bytes
--- a/arch/sparc/include/asm/uaccess_32.h~uaccess-unify-inline-vs-outline-copy_fromto_user-selection
+++ a/arch/sparc/include/asm/uaccess_32.h
@@ -190,8 +190,7 @@ static inline unsigned long raw_copy_fro
 	return __copy_user((__force void __user *) to, from, n);
 }
 
-#define INLINE_COPY_FROM_USER
-#define INLINE_COPY_TO_USER
+#define INLINE_COPY_USER
 
 static inline unsigned long __clear_user(void __user *addr, unsigned long size)
 {
--- a/arch/sparc/include/asm/uaccess_64.h~uaccess-unify-inline-vs-outline-copy_fromto_user-selection
+++ a/arch/sparc/include/asm/uaccess_64.h
@@ -231,8 +231,7 @@ unsigned long __must_check raw_copy_from
 unsigned long __must_check raw_copy_to_user(void __user *to,
 					   const void *from,
 					   unsigned long size);
-#define INLINE_COPY_FROM_USER
-#define INLINE_COPY_TO_USER
+#define INLINE_COPY_USER
 
 unsigned long __must_check raw_copy_in_user(void __user *to,
 					   const void __user *from,
--- a/arch/um/include/asm/uaccess.h~uaccess-unify-inline-vs-outline-copy_fromto_user-selection
+++ a/arch/um/include/asm/uaccess.h
@@ -27,8 +27,7 @@ static inline int __access_ok(const void
 #define __access_ok __access_ok
 #define __clear_user __clear_user
 
-#define INLINE_COPY_FROM_USER
-#define INLINE_COPY_TO_USER
+#define INLINE_COPY_USER
 
 #include <asm-generic/uaccess.h>
 
--- a/arch/xtensa/include/asm/uaccess.h~uaccess-unify-inline-vs-outline-copy_fromto_user-selection
+++ a/arch/xtensa/include/asm/uaccess.h
@@ -237,8 +237,7 @@ raw_copy_to_user(void __user *to, const
 	prefetch(from);
 	return __xtensa_copy_user((__force void *)to, from, n);
 }
-#define INLINE_COPY_FROM_USER
-#define INLINE_COPY_TO_USER
+#define INLINE_COPY_USER
 
 /*
  * We need to return the number of bytes not cleared.  Our memset()
--- a/include/asm-generic/uaccess.h~uaccess-unify-inline-vs-outline-copy_fromto_user-selection
+++ a/include/asm-generic/uaccess.h
@@ -91,8 +91,7 @@ raw_copy_to_user(void __user *to, const
 	memcpy((void __force *)to, from, n);
 	return 0;
 }
-#define INLINE_COPY_FROM_USER
-#define INLINE_COPY_TO_USER
+#define INLINE_COPY_USER
 #endif /* CONFIG_UACCESS_MEMCPY */
 
 /*
--- a/include/linux/uaccess.h~uaccess-unify-inline-vs-outline-copy_fromto_user-selection
+++ a/include/linux/uaccess.h
@@ -84,7 +84,7 @@
  * the 6 functions (copy_{to,from}_user(), __copy_{to,from}_user_inatomic())
  * that are used instead.  Out of those, __... ones are inlined.  Plain
  * copy_{to,from}_user() might or might not be inlined.  If you want them
- * inlined, have asm/uaccess.h define INLINE_COPY_{TO,FROM}_USER.
+ * inlined, have asm/uaccess.h define INLINE_COPY_USER.
  *
  * NOTE: only copy_from_user() zero-pads the destination in case of short copy.
  * Neither __copy_from_user() nor __copy_from_user_inatomic() zero anything
@@ -157,7 +157,7 @@ __copy_to_user(void __user *to, const vo
 }
 
 /*
- * Architectures that #define INLINE_COPY_TO_USER use this function
+ * Architectures that #define INLINE_COPY_USER use this function
  * directly in the normal copy_to/from_user(), the other ones go
  * through an extern _copy_to/from_user(), which expands the same code
  * here.
@@ -190,7 +190,7 @@ fail:
 	memset(to + (n - res), 0, res);
 	return res;
 }
-#ifndef INLINE_COPY_FROM_USER
+#ifndef INLINE_COPY_USER
 extern __must_check unsigned long
 _copy_from_user(void *, const void __user *, unsigned long);
 #endif
@@ -207,7 +207,7 @@ _inline_copy_to_user(void __user *to, co
 	}
 	return n;
 }
-#ifndef INLINE_COPY_TO_USER
+#ifndef INLINE_COPY_USER
 extern __must_check unsigned long
 _copy_to_user(void __user *, const void *, unsigned long);
 #endif
@@ -217,7 +217,7 @@ copy_from_user(void *to, const void __us
 {
 	if (!check_copy_size(to, n, false))
 		return n;
-#ifdef INLINE_COPY_FROM_USER
+#ifdef INLINE_COPY_USER
 	return _inline_copy_from_user(to, from, n);
 #else
 	return _copy_from_user(to, from, n);
@@ -230,7 +230,7 @@ copy_to_user(void __user *to, const void
 	if (!check_copy_size(from, n, true))
 		return n;
 
-#ifdef INLINE_COPY_TO_USER
+#ifdef INLINE_COPY_USER
 	return _inline_copy_to_user(to, from, n);
 #else
 	return _copy_to_user(to, from, n);
--- a/lib/usercopy.c~uaccess-unify-inline-vs-outline-copy_fromto_user-selection
+++ a/lib/usercopy.c
@@ -12,15 +12,13 @@
 
 /* out-of-line parts */
 
-#if !defined(INLINE_COPY_FROM_USER)
+#if !defined(INLINE_COPY_USER)
 unsigned long _copy_from_user(void *to, const void __user *from, unsigned long n)
 {
 	return _inline_copy_from_user(to, from, n);
 }
 EXPORT_SYMBOL(_copy_from_user);
-#endif
 
-#if !defined(INLINE_COPY_TO_USER)
 unsigned long _copy_to_user(void __user *to, const void *from, unsigned long n)
 {
 	return _inline_copy_to_user(to, from, n);
--- a/rust/helpers/uaccess.c~uaccess-unify-inline-vs-outline-copy_fromto_user-selection
+++ a/rust/helpers/uaccess.c
@@ -14,15 +14,13 @@ rust_helper_copy_to_user(void __user *to
 	return copy_to_user(to, from, n);
 }
 
-#ifdef INLINE_COPY_FROM_USER
+#ifdef INLINE_COPY_USER
 __rust_helper
 unsigned long rust_helper__copy_from_user(void *to, const void __user *from, unsigned long n)
 {
 	return _inline_copy_from_user(to, from, n);
 }
-#endif
 
-#ifdef INLINE_COPY_TO_USER
 __rust_helper
 unsigned long rust_helper__copy_to_user(void __user *to, const void *from, unsigned long n)
 {
_

Patches currently in -mm which might be from ynorov@nvidia.com are


