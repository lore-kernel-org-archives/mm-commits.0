Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7CE3FF884
	for <mm-commits@vger.kernel.org>; Mon, 31 Aug 2026 23:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788219977; cv=none; b=T1sIXyYo7far+NEWy+hQgIYFP2ZCBSZbuga6H/f1ZKdJCKfW92sM+ESaUgJUPbBiyutF2HwSgojgu3gfpQswQY0TDR1P4aSTMA4hhtEtwnzdENFNzFyinXNztWh4KiRZVDWRL8WgtvMXtz2A/yLEP+if+SqHXtkpOgvVtfvUF3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788219977; c=relaxed/simple;
	bh=W9DTL5D5ulyKZato0UUZo51P7ybD7vXT43PtASJH80w=;
	h=Date:To:From:Subject:Message-Id; b=EQPvw3qF4asvoDxFJiUmK5I4pBtCcHUykPw89TRYvZhfPPgeJ9Z4PdtiTo7X1TSug82tYVJlZ5BK8xgJFvYGdPApQsDcsSXyiR3vozfagjjzH7L13TZFaWF/3eavnEssQWAgdj4B3crSEiFgFAyFuftM0wrlc9dQhrn8d1EYVmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nTz+DdYG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nTz+DdYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7DF01F00A3E;
	Mon, 31 Aug 2026 23:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788219976;
	bh=HO2jSFTFeDPQ9ZICJpxNhGpzaDY4fV/SwR+HixPQxY4=;
	h=Date:To:From:Subject;
	b=nTz+DdYGYd9KuxXTCPnDG4ut7XcUHkaoqOSysbJAz6DOZWjmJsGiCvjpplSqcHACV
	 +dIgZxNbju72VpH7NRL5FAglD3IfaSKKxbxhBFLvLTyY8SEcvo2b4U2Nh3CilaAEh8
	 1gP7UvWUYg/wwoTWccxVq7BjN0ukUK92O78ee6sM=
Date: Mon, 31 Aug 2026 16:46:15 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,muchun.song@linux.dev,mingo@redhat.com,kees@kernel.org,david@kernel.org,dave.hansen@linux.intel.com,bp@alien8.de,balbirs@nvidia.com,arnd@arndb.de,apopple@nvidia.com,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-string-extend-memcpy_flushcache-fixed-size-fastpaths.patch added to mm-new branch
Message-Id: <20260831234615.E7DF01F00A3E@smtp.kernel.org>
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
Date: Mon, 31 Aug 2026 19:16:38 +0800

The x86 memcpy_nontemporal() helper maps to memcpy_flushcache(), and the
ZONE_DEVICE template-copy path uses it to copy one struct page at a time.

The relevant copy size is sizeof(struct page).  On x86_64, the base struct
page layout is 64 bytes.  Adding either the KMSAN metadata pointers or an
out-of-flags last_cpupid field can make it 80 bytes after alignment, and
enabling both can make it 96 bytes.

memcpy_flushcache() currently only has inline fixed-size cases for 4, 8,
and 16 bytes.  As a result, these constant-sized struct page copies fall
through to __memcpy_flushcache() even though the compiler knows the copy
size at the call site.

Add fixed-size MOVNTI cases up to 96 bytes so the ZONE_DEVICE
template-copy path can keep these struct page copies in the inline
memcpy_flushcache() path.

This matters for ZONE_DEVICE memmap initialization because the copy
happens once per initialized struct page.  For a 100 GB fsdax namespace
with map=dev, this is about 25 million struct page copies during nd_pmem
binding or rebinding.

Tested in a VM with a 100 GB fsdax namespace device configured with
map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
server.

Test procedure:
Rebind the nd_pmem and dax_pmem drivers 30 times and collect the memmap
initialization time from the pr_debug() output of
memmap_init_zone_device().

With memcpy_nontemporal() used by the ZONE_DEVICE template-copy path:
  Average of rebinds for nd_pmem driver: 150.40 ms
  Average of rebinds for dax_pmem driver: 161.83 ms

With this x86 fixed-size fastpath patch applied:
  Average of rebinds for nd_pmem driver: 71.93 ms
  Average of rebinds for dax_pmem driver: 87.37 ms

This further reduces the average memmap initialization time measured
during rebind by about 52.2% for nd_pmem and 46.0% for dax_pmem.

Link: https://lore.kernel.org/20260831111638.76012-8-lizhe.67@bytedance.com
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Suggested-by: Borislav Petkov <bp@alien8.de>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/string_64.h |   71 ++++++++++++++++++++++-------
 1 file changed, 56 insertions(+), 15 deletions(-)

--- a/arch/x86/include/asm/string_64.h~x86-string-extend-memcpy_flushcache-fixed-size-fastpaths
+++ a/arch/x86/include/asm/string_64.h
@@ -82,23 +82,64 @@ int strcmp(const char *cs, const char *c
 #ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
 #define __HAVE_ARCH_MEMCPY_FLUSHCACHE 1
 void __memcpy_flushcache(void *dst, const void *src, size_t cnt);
-static __always_inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
+
+static __always_inline void movnti_4(void *dst, const void *src)
 {
-	if (__builtin_constant_p(cnt)) {
-		switch (cnt) {
-			case 4:
-				asm ("movntil %1, %0" : "=m"(*(u32 *)dst) : "r"(*(u32 *)src));
-				return;
-			case 8:
-				asm ("movntiq %1, %0" : "=m"(*(u64 *)dst) : "r"(*(u64 *)src));
-				return;
-			case 16:
-				asm ("movntiq %1, %0" : "=m"(*(u64 *)dst) : "r"(*(u64 *)src));
-				asm ("movntiq %1, %0" : "=m"(*(u64 *)(dst + 8)) : "r"(*(u64 *)(src + 8)));
-				return;
-		}
+	asm volatile("movntil %1, %0"
+		     : "=m"(*(u32 *)dst)
+		     : "r"(*(const u32 *)src)
+		     : "memory");
+}
+
+static __always_inline void movnti_8(void *dst, const void *src)
+{
+	asm volatile("movntiq %1, %0"
+		     : "=m"(*(u64 *)dst)
+		     : "r"(*(const u64 *)src)
+		     : "memory");
+}
+
+static __always_inline void movnti_16(void *dst, const void *src)
+{
+	movnti_8(dst, src);
+	movnti_8(dst + 8, src + 8);
+}
+
+static __always_inline void movnti_32(void *dst, const void *src)
+{
+	movnti_16(dst, src);
+	movnti_16(dst + 16, src + 16);
+}
+
+static __always_inline void movnti_64(void *dst, const void *src)
+{
+	movnti_32(dst, src);
+	movnti_32(dst + 32, src + 32);
+}
+
+static __always_inline void memcpy_flushcache(void *dst, const void *src,
+					      size_t cnt)
+{
+	if (!__builtin_constant_p(cnt))
+		return __memcpy_flushcache(dst, src, cnt);
+
+	/*
+	 * The relevant fixed-size copies here are the x86_64 struct page sizes:
+	 * 64, 80, and 96 bytes. Keep 32-byte and 48-byte copies inline as well
+	 * instead of sending those nearby fixed-size cases back to
+	 * __memcpy_flushcache().
+	 */
+	switch (cnt) {
+	case 4:  movnti_4(dst, src); break;
+	case 8:  movnti_8(dst, src); break;
+	case 16: movnti_16(dst, src); break;
+	case 32: movnti_32(dst, src); break;
+	case 48: movnti_32(dst, src); movnti_16(dst + 32, src + 32); break;
+	case 64: movnti_64(dst, src); break;
+	case 80: movnti_64(dst, src); movnti_16(dst + 64, src + 64); break;
+	case 96: movnti_64(dst, src); movnti_32(dst + 64, src + 64); break;
+	default: __memcpy_flushcache(dst, src, cnt); break;
 	}
-	__memcpy_flushcache(dst, src, cnt);
 }
 
 #define memcpy_nontemporal memcpy_nontemporal
_

Patches currently in -mm which might be from lizhe.67@bytedance.com are

mm-fix-stale-zone_device-refcount-comment.patch
mm-add-a-set_page_section_from_pfn-helper.patch
mm-add-a-template-based-fast-path-for-zone-device-page-init.patch
mm-extend-the-template-fast-path-to-zone-device-compound-tails.patch
string-introduce-memcpy_nontemporal.patch
mm-use-memcpy_nontemporal-in-zone-device-template-copies.patch
x86-string-extend-memcpy_flushcache-fixed-size-fastpaths.patch

