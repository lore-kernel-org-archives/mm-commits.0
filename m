Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD91D3290C9
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 16:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008235; cv=none; b=pCCJk7/gEr9qTecidtKf4IfYGoYgimGreKs0qWk01mrVW0r/2ZWUOL5KRQB8Nj2VeTUoWbb3rd1sGezob4IHNg2fFbD/IaX7CUhuaAHZTqQl5yK5zYOj8pfRixNRywJC05jvJeoQ4pCzOvtqqD5yg3DZkHt8YpGCA/rhINbiKv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008235; c=relaxed/simple;
	bh=3FU93F8izt2h/nV1afuCPEn+Me2vH532Y/KgOGrdn3A=;
	h=Date:To:From:Subject:Message-Id; b=cJhXY0xY9uKgmJ9QRqNFNBrPfStElpGGtUq8v/DB1WVWBaVIDZosEO1mNBPhrmmwMATTyLNsh9jQGB/p1c790kgNonXG7/4df4xQICqFzxfMUsO6hbgeLjzSM+9hXmXAkPeGHbsOz34gWnIzvfUUkUI0AO5BHe6S+u0HrEEwOXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tesGYbb5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tesGYbb5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9BA1F000E9;
	Thu,  2 Jul 2026 16:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783008234;
	bh=LjNDR/nY0GlBjKGaoFzumMpocShORYSOEhZxVifR8+M=;
	h=Date:To:From:Subject;
	b=tesGYbb5zkEdZ2CXv/5tiPe5oz0/50+6czk6+hjjiKQ4a6xF4bQXc/NMlQu8jMj58
	 9tn5eMnuNfmfPbfA9Turiu1YMljRcab5x1R8jkWDkQ7k9Simq2pDtcqUMEmH+4lm8C
	 /iULH9Xpq9/ZAozs58fXA2wRAH0x96/nX5fMH1a0=
Date: Thu, 02 Jul 2026 09:03:54 -0700
To: mm-commits@vger.kernel.org,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] string-introduce-memcpy_nt-helpers.patch removed from -mm tree
Message-Id: <20260702160354.7C9BA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: string: introduce memcpy_nt() helpers
has been removed from the -mm tree.  Its filename was
     string-introduce-memcpy_nt-helpers.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: string: introduce memcpy_nt() helpers
Date: Wed, 1 Jul 2026 17:05:51 +0800

Introduce memcpy_nt() and memcpy_nt_drain() for write-once copy sites that
want a named non-temporal copy primitive plus an explicit ordering point. 
On x86, place the arch-visible wrapper in arch/x86/include/asm/string_64.h
and map it to the existing memcpy_flushcache() backend plus sfence. 
Architectures that do not override the helper fall back to memcpy() and a
no-op drain in include/linux/string.h.

The immediate user is the ZONE_DEVICE template-copy path.  That path
populates struct page descriptors in a write-once pattern, so most
destination cachelines are not expected to be reused immediately after the
copy.  A regular cached memcpy() can therefore incur avoidable
write-allocate traffic and pollute the cache with data that has little
near-term reuse.

This interface lets callers request that non-temporal-copy semantics
directly, while x86 simply reuses the existing memcpy_flushcache() backend
instead of adding another generic memcpy-like wrapper with extra selection
policy above it.

Link: https://lore.kernel.org/20260701090553.62691-7-lizhe.67@bytedance.com
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/string_64.h |   16 ++++++++++++++++
 include/linux/string.h           |   18 ++++++++++++++++++
 2 files changed, 34 insertions(+)

--- a/arch/x86/include/asm/string_64.h~string-introduce-memcpy_nt-helpers
+++ a/arch/x86/include/asm/string_64.h
@@ -100,6 +100,22 @@ static __always_inline void memcpy_flush
 	}
 	__memcpy_flushcache(dst, src, cnt);
 }
+
+#define __HAVE_ARCH_MEMCPY_NT 1
+/*
+ * Reuse the existing x86 flushcache backend as the nt copy primitive.
+ * Callers pair it with memcpy_nt_drain() when later stores must be
+ * ordered after the copy.
+ */
+static __always_inline void memcpy_nt(void *dst, const void *src, size_t cnt)
+{
+	memcpy_flushcache(dst, src, cnt);
+}
+
+static __always_inline void memcpy_nt_drain(void)
+{
+	asm volatile("sfence" : : : "memory");
+}
 #endif
 
 #endif /* __KERNEL__ */
--- a/include/linux/string.h~string-introduce-memcpy_nt-helpers
+++ a/include/linux/string.h
@@ -278,6 +278,24 @@ static inline void memcpy_flushcache(voi
 }
 #endif
 
+#ifndef __HAVE_ARCH_MEMCPY_NT
+/*
+ * memcpy_nt() requests a non-temporal copy when the architecture has a
+ * suitable backend. Callers must follow it with memcpy_nt_drain()
+ * before later normal stores that need to be ordered after the copy.
+ * Architectures that do not override it fall back to memcpy() and a
+ * no-op drain.
+ */
+static inline void memcpy_nt(void *dst, const void *src, size_t cnt)
+{
+	memcpy(dst, src, cnt);
+}
+
+static inline void memcpy_nt_drain(void)
+{
+}
+#endif
+
 void *memchr_inv(const void *s, int c, size_t n);
 char *strreplace(char *str, char old, char new);
 
_

Patches currently in -mm which might be from lizhe.67@bytedance.com are

x86-string-extend-memcpy_flushcache-fixed-size-fastpaths.patch
mm-use-memcpy_nt-in-zone-device-template-copies.patch

