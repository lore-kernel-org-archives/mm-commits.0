Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4139540861
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 18:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716576945; cv=none; b=gaurPS/mpzhXzvbGDulDgHrycJVRcIDtCiauUf7XkSItPhi27p2ha+nj6NM4wOAtfIWaKU0pi/kmkguX7XMmDLYK7O5aHnwgkyzuJJ8Unia1Qm/piotzC9ZCnZGAMCi9VsmUtoFkvR96Mds6gW42B7c+HLcC5qVtZV3kBJ4CgrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716576945; c=relaxed/simple;
	bh=L4xpNh6QKJojmnun5vYPDBW8p2xtL41WI2Kf6KIdrSE=;
	h=Date:To:From:Subject:Message-Id; b=tBKHQOTmI3qoDcw/AntmRqp84NShhkMnxucpZrbEUT/VHpBUR8H/JQxKdeI/JpRbz1yN5LD2JnTmQSiXPrX6V0WMKUH9ugfFoame+iTjs9at0FL4Ds5JLD32Wm96pctgo+K5yLjMQ95c7AknN7NbPDmPPHnDBLxoSAez1a0zoto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZA25WXCZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZA25WXCZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5511C2BBFC;
	Fri, 24 May 2024 18:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716576945;
	bh=L4xpNh6QKJojmnun5vYPDBW8p2xtL41WI2Kf6KIdrSE=;
	h=Date:To:From:Subject:From;
	b=ZA25WXCZrqGz+3JqQDhSWgStZzApIwYBB/1TuYskbjELzoDkk5BxGVsXgH9DZ9Bak
	 OdVIOSUvAM1YPd5jztVMlTdsBSiJkNcM7Ayxcj1xF0TY7PMwN7bWobr1aSc5xLvfua
	 UKWktOUbLHQUrHLN3ZW7fYtWA2drILXqSi8Nbk+U=
Date: Fri, 24 May 2024 11:55:44 -0700
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,npache@redhat.com,glider@google.com,erhard_f@mailbox.org,elver@google.com,dvyukov@google.com,dja@axtens.net,andreyknvl@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kasan-fortify-properly-rename-memintrinsics.patch removed from -mm tree
Message-Id: <20240524185544.E5511C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan, fortify: properly rename memintrinsics
has been removed from the -mm tree.  Its filename was
     kasan-fortify-properly-rename-memintrinsics.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@gmail.com>
Subject: kasan, fortify: properly rename memintrinsics
Date: Fri, 17 May 2024 15:01:18 +0200

After commit 69d4c0d32186 ("entry, kasan, x86: Disallow overriding mem*()
functions") and the follow-up fixes, with CONFIG_FORTIFY_SOURCE enabled,
even though the compiler instruments meminstrinsics by generating calls to
__asan/__hwasan_ prefixed functions, FORTIFY_SOURCE still uses
uninstrumented memset/memmove/memcpy as the underlying functions.

As a result, KASAN cannot detect bad accesses in memset/memmove/memcpy. 
This also makes KASAN tests corrupt kernel memory and cause crashes.

To fix this, use __asan_/__hwasan_memset/memmove/memcpy as the underlying
functions whenever appropriate.  Do this only for the instrumented code
(as indicated by __SANITIZE_ADDRESS__).

Link: https://lkml.kernel.org/r/20240517130118.759301-1-andrey.konovalov@linux.dev
Fixes: 69d4c0d32186 ("entry, kasan, x86: Disallow overriding mem*() functions")
Fixes: 51287dcb00cc ("kasan: emit different calls for instrumentable memintrinsics")
Fixes: 36be5cba99f6 ("kasan: treat meminstrinsic as builtins in uninstrumented files")
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Reported-by: Nico Pache <npache@redhat.com>
Closes: https://lore.kernel.org/all/20240501144156.17e65021@outsider.home/
Reviewed-by: Marco Elver <elver@google.com>
Tested-by: Nico Pache <npache@redhat.com>
Acked-by: Nico Pache <npache@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fortify-string.h |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/include/linux/fortify-string.h~kasan-fortify-properly-rename-memintrinsics
+++ a/include/linux/fortify-string.h
@@ -75,17 +75,30 @@ void __write_overflow_field(size_t avail
 	__ret;							\
 })
 
-#if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
+#if defined(__SANITIZE_ADDRESS__)
+
+#if !defined(CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX) && !defined(CONFIG_GENERIC_ENTRY)
+extern void *__underlying_memset(void *p, int c, __kernel_size_t size) __RENAME(memset);
+extern void *__underlying_memmove(void *p, const void *q, __kernel_size_t size) __RENAME(memmove);
+extern void *__underlying_memcpy(void *p, const void *q, __kernel_size_t size) __RENAME(memcpy);
+#elif defined(CONFIG_KASAN_GENERIC)
+extern void *__underlying_memset(void *p, int c, __kernel_size_t size) __RENAME(__asan_memset);
+extern void *__underlying_memmove(void *p, const void *q, __kernel_size_t size) __RENAME(__asan_memmove);
+extern void *__underlying_memcpy(void *p, const void *q, __kernel_size_t size) __RENAME(__asan_memcpy);
+#else /* CONFIG_KASAN_SW_TAGS */
+extern void *__underlying_memset(void *p, int c, __kernel_size_t size) __RENAME(__hwasan_memset);
+extern void *__underlying_memmove(void *p, const void *q, __kernel_size_t size) __RENAME(__hwasan_memmove);
+extern void *__underlying_memcpy(void *p, const void *q, __kernel_size_t size) __RENAME(__hwasan_memcpy);
+#endif
+
 extern void *__underlying_memchr(const void *p, int c, __kernel_size_t size) __RENAME(memchr);
 extern int __underlying_memcmp(const void *p, const void *q, __kernel_size_t size) __RENAME(memcmp);
-extern void *__underlying_memcpy(void *p, const void *q, __kernel_size_t size) __RENAME(memcpy);
-extern void *__underlying_memmove(void *p, const void *q, __kernel_size_t size) __RENAME(memmove);
-extern void *__underlying_memset(void *p, int c, __kernel_size_t size) __RENAME(memset);
 extern char *__underlying_strcat(char *p, const char *q) __RENAME(strcat);
 extern char *__underlying_strcpy(char *p, const char *q) __RENAME(strcpy);
 extern __kernel_size_t __underlying_strlen(const char *p) __RENAME(strlen);
 extern char *__underlying_strncat(char *p, const char *q, __kernel_size_t count) __RENAME(strncat);
 extern char *__underlying_strncpy(char *p, const char *q, __kernel_size_t size) __RENAME(strncpy);
+
 #else
 
 #if defined(__SANITIZE_MEMORY__)
@@ -110,6 +123,7 @@ extern char *__underlying_strncpy(char *
 #define __underlying_strlen	__builtin_strlen
 #define __underlying_strncat	__builtin_strncat
 #define __underlying_strncpy	__builtin_strncpy
+
 #endif
 
 /**
_

Patches currently in -mm which might be from andreyknvl@gmail.com are


