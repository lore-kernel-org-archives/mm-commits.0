Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C3D73163
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 23:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716161405; cv=none; b=svM9WEbf1tFtfhnUjUfsDqbqF5cnU9Kunk9L7rmoRYbakFBnWmmXF14w9z4YdirJ/8ihPT1Xi/NVQV1YrMA4tYZ86im5AWI1/HDcbr2hKxsjwg5puvjMKssAEH3IBecNSrAbii3mSFzXWSsXCZu4rIiHAYGjMb1G4CawSNYa+gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716161405; c=relaxed/simple;
	bh=cByY+bfwIn3Qp1C95XyZ3txtHtna86S1BMPxF3J1HEo=;
	h=Date:To:From:Subject:Message-Id; b=K9xIzozpxNfKFgKV2NK+qtIrC0RIFzfVoJaqItRDSSatOXjueRCHR9WaEFhJqOmW8yJ+l+mts4iCOY5PyoIplWq7NUdukTRy4ZrYRpu4XHQvjzD6fiWFWcdYudaTnjP9Gk1a+IHcUNsVUarIz5QQ9IUF+jQUs0xP+TMAAlpcXfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zb9i3p4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zb9i3p4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824BCC32781;
	Sun, 19 May 2024 23:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716161404;
	bh=cByY+bfwIn3Qp1C95XyZ3txtHtna86S1BMPxF3J1HEo=;
	h=Date:To:From:Subject:From;
	b=Zb9i3p4xRIN5iUHZr3ATEMuTsIFaeuKbF6CNeK6fbfNSo4hPE46ZzYSsIRtBneywo
	 G07IRz+26FkWO0RpIaMjyder4Qb3k/mCK0WA+yx0ZKqH7i590Z6hO1t2BZQbQTvBuN
	 j7jt3GGfX+ttsXOAV+nfGfYU7RHhJxPwMwtWWb6o=
Date: Sun, 19 May 2024 16:30:03 -0700
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,npache@redhat.com,glider@google.com,erhard_f@mailbox.org,elver@google.com,dvyukov@google.com,dja@axtens.net,andreyknvl@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-fortify-properly-rename-memintrinsics.patch added to mm-hotfixes-unstable branch
Message-Id: <20240519233004.824BCC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan, fortify: properly rename memintrinsics
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-fortify-properly-rename-memintrinsics.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-fortify-properly-rename-memintrinsics.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

kasan-fortify-properly-rename-memintrinsics.patch

