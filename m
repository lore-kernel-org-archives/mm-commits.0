Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4494C39A7F6
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 23:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782948520; cv=none; b=s4hpzYRrhWlupEJ0KabIDJt84zpv1AZo8Dzk+CWHZ9E2EfJkcWJSSbaNme7cIfrRYfd541JtFOQ6k3uqCx4PdM3862Qxyb8AL0e9tShUFI5JOFtKtUwr9aw4LAaFnkdwkLoky953x2jwCfyrLrAHpHMAlJfOD8F4hcteSNgFSSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782948520; c=relaxed/simple;
	bh=aZS3cfPAlxrtFAl0MKDjhwvwv3/n+WcGNdPjvmafL8Q=;
	h=Date:To:From:Subject:Message-Id; b=LSfD3MkxiIMX6ldroAeyYM8rAOINTWtdZ59Ao6NRHD7fwR6wTP4SIw7K76MLLXUr4/AmFKoC5E71jnjDbSVP+0FsKtpPd/Dw/ZwxZJrG8PhdlP0Z/kouU/2rIAIAz/0ZkkpE2nzdflNPbPWxA9IYKd7zu1P1ELjPhApnaOD9FuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1Xp8JajS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1Xp8JajS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDAA51F000E9;
	Wed,  1 Jul 2026 23:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782948518;
	bh=FsbxFkj+eTpaXiBeZct+Y/30Iq4hV8+GFJ04TpqvKIY=;
	h=Date:To:From:Subject;
	b=1Xp8JajS18Ci62XmxAm6XqW9MRUM55k6xRxHITLkvP+gF0WShVCzTMTcSTR5CWuAB
	 eDz0Rio9jHG7tgyeTQYxY07sYfya+v/pS676lfylGt0JAKNxlrp26j13xXCH/q2N1P
	 Xy1XA7yhe4jJjCX6Fro8PAISup9YH/w3RMKFn81I=
Date: Wed, 01 Jul 2026 16:28:38 -0700
To: mm-commits@vger.kernel.org,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + string-introduce-memcpy_nt-helpers.patch added to mm-new branch
Message-Id: <20260701232838.CDAA51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: string: introduce memcpy_nt() helpers
has been added to the -mm mm-new branch.  Its filename is
     string-introduce-memcpy_nt-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/string-introduce-memcpy_nt-helpers.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-fix-stale-zone_device-refcount-comment.patch
mm-factor-zone-device-page-init-helpers-out-of-__init_zone_device_page.patch
mm-add-a-set_page_section_from_pfn-helper.patch
mm-add-a-template-based-fast-path-for-zone-device-page-init.patch
mm-extend-the-template-fast-path-to-zone-device-compound-tails.patch
string-introduce-memcpy_nt-helpers.patch
x86-string-extend-memcpy_flushcache-fixed-size-fastpaths.patch
mm-use-memcpy_nt-in-zone-device-template-copies.patch

