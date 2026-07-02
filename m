Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74FF317173
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 16:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008237; cv=none; b=fM+0aj5BM9v9cJBwQo70xMczPN0RPjC94LluHhRu24+6WN+mmytB4WTR8tbUJkp0u5rFem358GNihA5GH1n+tsA98Y+APE2JxekJVEYaNVy3XCvPVMboTBM9O2CX6u0ViI5ShhSiEdb/ucEnOi/IYjZORwgkHhluDvmrQ3bXPaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008237; c=relaxed/simple;
	bh=tjHobsEKA/VU2GFY+Qtr8sRFi2uRy14buTjqMrWK8q8=;
	h=Date:To:From:Subject:Message-Id; b=BJT8whtOFEJDv5KLWJtQuYc/5/6Q74hM6h50lPVr2griJ3bpnWEHbRzlsFZlFUPBBetxB8bY+b2NvgS4D2i7E5DVALOt1+fCoAoerL4gOBoUunDydBojFlf9OMZVW0RBFh48y0y21k2Dk2vznDK4h9PLMLA3ytYnQHp3eF/0q18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BQt4SpBd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BQt4SpBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A498F1F00A3E;
	Thu,  2 Jul 2026 16:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783008235;
	bh=rAVV4MACiVpfrt+zmh2QBfWYzfq/wKjS6sYSsw0DnQo=;
	h=Date:To:From:Subject;
	b=BQt4SpBdhL1Ex4Ziclj+ZlvAUsheBH0dDdPIuuZBUvWITkUmsZuiiK+lhQZv8Rdl9
	 6SHbRg3Uc+Emo7HQRiOyWeUYJT7fhn58XVV+jIU5o/dwPs4s6DEPtBH/xA+EfInh/C
	 HxC9qPG+svKv6kEOMQ95XiJ2h5W2EQMianSCS2g4=
Date: Thu, 02 Jul 2026 09:03:55 -0700
To: mm-commits@vger.kernel.org,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] x86-string-extend-memcpy_flushcache-fixed-size-fastpaths.patch removed from -mm tree
Message-Id: <20260702160355.A498F1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/string: extend memcpy_flushcache() fixed-size fastpaths
has been removed from the -mm tree.  Its filename was
     x86-string-extend-memcpy_flushcache-fixed-size-fastpaths.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: x86/string: extend memcpy_flushcache() fixed-size fastpaths
Date: Wed, 1 Jul 2026 17:05:52 +0800

The new x86 memcpy_nt() helper in this series maps to memcpy_flushcache(),
and the ZONE_DEVICE fast path uses that primitive for constant-sized
struct page template copies.

memcpy_flushcache() currently inlines only the 4, 8, and 16-byte cases. 
Larger constant-sized copies fall back to __memcpy_flushcache() even when
the destination is naturally aligned.  Extend the inline movnti coverage
to 32, 48, 64, 80, and 96 bytes so the struct page-sized copies used by
that path can stay on the inline non-temporal store path instead of
dropping into the out-of-line helper.

Factor the store sequences into 8/16/32/64-byte helpers, keep the existing
4/8/16-byte cases handled directly in memcpy_flushcache(), issue the
stores in ascending address order, and leave all other sizes on
__memcpy_flushcache().

Link: https://lore.kernel.org/20260701090553.62691-8-lizhe.67@bytedance.com
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

 arch/x86/include/asm/string_64.h |   80 ++++++++++++++++++++++++++++-
 1 file changed, 79 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/string_64.h~x86-string-extend-memcpy_flushcache-fixed-size-fastpaths
+++ a/arch/x86/include/asm/string_64.h
@@ -4,6 +4,7 @@
 
 #ifdef __KERNEL__
 #include <linux/jump_label.h>
+#include <linux/align.h>
 
 /* Written 2002 by Andi Kleen */
 
@@ -82,8 +83,81 @@ int strcmp(const char *cs, const char *c
 #ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
 #define __HAVE_ARCH_MEMCPY_FLUSHCACHE 1
 void __memcpy_flushcache(void *dst, const void *src, size_t cnt);
-static __always_inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
+
+static __always_inline void memcpy_flushcache_8(void *dst, const void *src)
+{
+	asm volatile("movntiq %1, %0"
+		     : "=m"(*(u64 *)dst)
+		     : "r"(*(const u64 *)src)
+		     : "memory");
+}
+
+static __always_inline void memcpy_flushcache_16(void *dst,
+						 const void *src)
+{
+	memcpy_flushcache_8(dst, src);
+	memcpy_flushcache_8(dst + 8, src + 8);
+}
+
+static __always_inline void memcpy_flushcache_32(void *dst,
+						 const void *src)
 {
+	memcpy_flushcache_16(dst, src);
+	memcpy_flushcache_16(dst + 16, src + 16);
+}
+
+static __always_inline void memcpy_flushcache_64(void *dst,
+						 const void *src)
+{
+	memcpy_flushcache_32(dst, src);
+	memcpy_flushcache_32(dst + 32, src + 32);
+}
+
+/*
+ * Keep the additional aligned fixed-size cases on the inline movnti path.
+ * Leave the existing 4/8/16-byte cases handled directly in
+ * memcpy_flushcache() so their code generation stays unchanged.
+ */
+static __always_inline int memcpy_flushcache_large(void *dst,
+						   const void *src,
+						   size_t cnt)
+{
+	char *dptr = dst;
+	const char *sptr = src;
+
+	if (!IS_ALIGNED((unsigned long)dst, 8))
+		return 0;
+
+	switch (cnt) {
+	case 32:
+		memcpy_flushcache_32(dptr, sptr);
+		return 1;
+	case 48:
+		memcpy_flushcache_32(dptr, sptr);
+		memcpy_flushcache_16(dptr + 32, sptr + 32);
+		return 1;
+	case 64:
+		memcpy_flushcache_64(dptr, sptr);
+		return 1;
+	case 80:
+		memcpy_flushcache_64(dptr, sptr);
+		memcpy_flushcache_16(dptr + 64, sptr + 64);
+		return 1;
+	case 96:
+		memcpy_flushcache_64(dptr, sptr);
+		memcpy_flushcache_32(dptr + 64, sptr + 64);
+		return 1;
+	}
+
+	return 0;
+}
+
+static __always_inline void memcpy_flushcache(void *dst, const void *src,
+					      size_t cnt)
+{
+	if (!cnt)
+		return;
+
 	if (__builtin_constant_p(cnt)) {
 		switch (cnt) {
 			case 4:
@@ -97,7 +171,11 @@ static __always_inline void memcpy_flush
 				asm ("movntiq %1, %0" : "=m"(*(u64 *)(dst + 8)) : "r"(*(u64 *)(src + 8)));
 				return;
 		}
+
+		if (memcpy_flushcache_large(dst, src, cnt))
+			return;
 	}
+
 	__memcpy_flushcache(dst, src, cnt);
 }
 
_

Patches currently in -mm which might be from lizhe.67@bytedance.com are

mm-use-memcpy_nt-in-zone-device-template-copies.patch

