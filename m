Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA699224D6
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 23:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782948523; cv=none; b=k/0FLTGRH1oh/ZSwn805//YqgiHZV8iw09I2kMUHJwVgymTOWeXLNFDneSwDHlvnfgptbvN9BU21Z/COvD2rlyfIdkuEt6PPEvzLet9I3+Jd6+spjFTqIXw+gSL+uBqecIGV8Jy6yg9g+/+N/IXRP+aP3+uOsXVo4jwi4pIPwaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782948523; c=relaxed/simple;
	bh=dnTO64ulbT7pSzEYNHu9HX56HA7h5RxqjFMGDIi2sxQ=;
	h=Date:To:From:Subject:Message-Id; b=b9QfsPS2j0TANDSqJ67jSx5bFcPaF6HtdIn741ajhUasw+zLilRGZX/H2PTiD/gaQIcH7vd3s6+YiEoa5tIhWlIymIVbGbgKYUBcJN7GmKB7Oc53ofa4WCc2xxAhYvDrquQkCs/ovIk58cIAlCs0R5cf3XQrphQTEsAj5NCH6rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z/aSiZsl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z/aSiZsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C53E1F000E9;
	Wed,  1 Jul 2026 23:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782948521;
	bh=L3pBFYWVx68iy3B90xcWTNupEClbcsiEwb0xUsvQhU0=;
	h=Date:To:From:Subject;
	b=z/aSiZslcJxz8cUe2t/JKhnxK5dJKCk2O2thifUQGDicrTJPiZM0XnCC8hC6aDJT6
	 Hxd/PDFXK2Yuqyxn1zb1WJ3MybXalyx3urlIx/V+DKJIqDfVpxSkN3R7Hfmf9O4d+u
	 48D0RyoWIehToMFxf4T/UPbzDn4r4XZMvbgxgf48=
Date: Wed, 01 Jul 2026 16:28:40 -0700
To: mm-commits@vger.kernel.org,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-string-extend-memcpy_flushcache-fixed-size-fastpaths.patch added to mm-new branch
Message-Id: <20260701232841.4C53E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/string: extend memcpy_flushcache() fixed-size fastpaths
has been added to the -mm mm-new branch.  Its filename is
     x86-string-extend-memcpy_flushcache-fixed-size-fastpaths.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-string-extend-memcpy_flushcache-fixed-size-fastpaths.patch

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

mm-fix-stale-zone_device-refcount-comment.patch
mm-factor-zone-device-page-init-helpers-out-of-__init_zone_device_page.patch
mm-add-a-set_page_section_from_pfn-helper.patch
mm-add-a-template-based-fast-path-for-zone-device-page-init.patch
mm-extend-the-template-fast-path-to-zone-device-compound-tails.patch
string-introduce-memcpy_nt-helpers.patch
x86-string-extend-memcpy_flushcache-fixed-size-fastpaths.patch
mm-use-memcpy_nt-in-zone-device-template-copies.patch

