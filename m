Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A337F30D419
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334298; cv=none; b=gJgHR/NZO6PnqP3nxnvqrveqqw67lSb7y3lpUTiPOBoG0CjjFGJDz9A8TgXqDO/RB+8Pr0IV4BJdFG3k9JBXFe0t4nOssUnkQFUmp+QQJVGEPjMdo46N9LpKFPFbEvlFGMwUJT+KfgBjZ3gIsZ3zUojPyRdru5EquZ3liMN/brs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334298; c=relaxed/simple;
	bh=bTP39xXzcelv3/sY2lc5Fq6cj7gv/IO1d/pnp83UR5Q=;
	h=Date:To:From:Subject:Message-Id; b=UWnFkJJY2WwN4OrkhzW69DyXx46U9kMe6LSeBtSpFHhoSRC4Mrv3Jvb3PRQ1gYahznLeHNMfkBWVsRcqDPpekNSlktJo3PZilmkZSOthK/6U5gpk2LzpQjzEy5uFdJiPKRwfih0ww/YofCL5sGVQnQAIWd0qLhwrbzmk2WmPeJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=McPKu1qW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="McPKu1qW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B031F0089C;
	Wed,  7 Oct 2026 00:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334297;
	bh=qncVPKAKrjSDRR7jaCRzj5FNjvJc/VC5GXlO5F9wC1Y=;
	h=Date:To:From:Subject;
	b=McPKu1qWfXdyDb3l8XQKzeh5NXOqm6uQDb0ttmgn6q5YZp9YDDy+0ADd0Q40+iXsM
	 mZlN08Z8JmGRGNXM9Z9bRZCsvWCNmeEwFF9oUnI5lvmxOOoq0Rv5EIm8pdIQNitFG0
	 Qq/4zCWJQ7ZSaXTwFUypcd3NuSGFxZDbdVMquNN4=
Date: Tue, 06 Oct 2026 17:51:36 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,muchun.song@linux.dev,mingo@redhat.com,kees@kernel.org,david@kernel.org,dave.hansen@linux.intel.com,bp@alien8.de,balbirs@nvidia.com,arnd@arndb.de,apopple@nvidia.com,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] string-introduce-memcpy_nontemporal.patch removed from -mm tree
Message-Id: <20261007005137.50B031F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: string: introduce memcpy_nontemporal()
has been removed from the -mm tree.  Its filename was
     string-introduce-memcpy_nontemporal.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: string: introduce memcpy_nontemporal()
Date: Mon, 31 Aug 2026 19:16:36 +0800

Introduce memcpy_nontemporal() for write-once copy sites that want a named
non-temporal copy primitive.

On x86_64, override the helper in arch/x86/include/asm/string_64.h using
the usual self-macro pattern, next to the existing memcpy_flushcache()
backend that memcpy_nontemporal() wraps.

include/linux/string.h provides the generic memcpy_nontemporal() fallback
as

  #define memcpy_nontemporal(dst, src, len) \
	((void)memcpy(dst, src, len))

instead of an inline wrapper, so architectures without a specialized
backend keep the usual memcpy() FORTIFY coverage when the compiler can
still see object sizes at the original call site.  It also makes the
memcpy_nontemporal() API uniformly void, matching memcpy_flushcache() and
the x86 backend, so callers cannot accidentally depend on a return value
on fallback architectures.

memcpy_nontemporal() is only a copy primitive.  It does not imply a drain
or a publication barrier.  Callers that use it before a producer-consumer
or device-visible handoff must provide the required ordering at that
handoff point.

The immediate user is the ZONE_DEVICE template-copy path.  It populates
struct page descriptors in a write-once pattern, so a regular cached
memcpy() can incur avoidable write-allocate traffic and cache pollution
for data with little near-term reuse.

Link: https://lore.kernel.org/20260831111638.76012-6-lizhe.67@bytedance.com
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
---

 arch/x86/include/asm/string_64.h |   12 ++++++++++++
 include/linux/string.h           |   13 +++++++++++++
 2 files changed, 25 insertions(+)

--- a/arch/x86/include/asm/string_64.h~string-introduce-memcpy_nontemporal
+++ a/arch/x86/include/asm/string_64.h
@@ -100,6 +100,18 @@ static __always_inline void memcpy_flush
 	}
 	__memcpy_flushcache(dst, src, cnt);
 }
+
+#define memcpy_nontemporal memcpy_nontemporal
+/*
+ * Reuse the existing x86 flushcache backend as the non-temporal copy
+ * primitive.
+ */
+static __always_inline void memcpy_nontemporal(void *dst, const void *src,
+		size_t cnt)
+{
+	memcpy_flushcache(dst, src, cnt);
+}
+
 #endif
 
 #endif /* __KERNEL__ */
--- a/include/linux/string.h~string-introduce-memcpy_nontemporal
+++ a/include/linux/string.h
@@ -278,6 +278,19 @@ static inline void memcpy_flushcache(voi
 }
 #endif
 
+#ifndef memcpy_nontemporal
+/*
+ * memcpy_nontemporal() requests a non-temporal copy when the
+ * architecture has a suitable backend. Architectures without a
+ * specialized backend fall back to memcpy(). Keep this as a
+ * function-like macro so the compiler can still see the original
+ * memcpy() call site and preserve the usual FORTIFY coverage when
+ * object sizes remain visible there, while keeping the API void.
+ */
+#define memcpy_nontemporal(dst, src, len) \
+	((void)memcpy(dst, src, len))
+#endif
+
 void *memchr_inv(const void *s, int c, size_t n);
 char *strreplace(char *str, char old, char new);
 
_

Patches currently in -mm which might be from lizhe.67@bytedance.com are

mm-hugetlb-fix-overbroad-mmu-notifiers-for-unshared-pmds.patch

