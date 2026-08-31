Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD23A37AA65
	for <mm-commits@vger.kernel.org>; Mon, 31 Aug 2026 23:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788219973; cv=none; b=dvB1QVm6YUypEUnL6Fg7JSUlRiZfy6Dl5Yclv4EN/xziwUeHLO9o3lKYtsf5fjTeM4QOzqkfB+PNc2OVXMujhrfmZ7DEB2V+JHhw8RY0OxzK7l8EUnfdv7nO4vAZd7WU3rsDsffTrQlOTrlWV5r1SsuY2dWowSAnf5ZpWUNesDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788219973; c=relaxed/simple;
	bh=hekvybnrYXmHlS7hlCs4iE4bquHMf6GZJoBkzaAjtQk=;
	h=Date:To:From:Subject:Message-Id; b=olGHSBVnQg1zXqo9o/bPNidoAKWNtPZbVYwuSTTZcDOeJO0ET8jK5czWV2QQej+URbEWQqKm8BvLoINAcplDfTs4KtBzky9kP4nwS63/ue5vp53Iga1EekmFiF5JyPJDbQsdTUz1JAOfxmiiaAVs6DfJyqjnNbStz+mFet7H7qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nxkyr374; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nxkyr374"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377631F00A3D;
	Mon, 31 Aug 2026 23:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788219971;
	bh=r2LAKeRdAqSrD8C+3X7iHuDJgi9auGcM0oX/lbxOoSg=;
	h=Date:To:From:Subject;
	b=nxkyr3741QlHBfd+9ZCYHs58zO/HFgdSzLkqzl+AYvOs2GI1DZwqEOfmK1rdSV6lj
	 vM+lBOEGn6d62rSpzLD5kUk5t0Knt9ps0iu4z1v6WxpmEZmHzIwGesWAi2Ay1q9k06
	 Ded/jynF1k64siuNfAhNv5eSg6IRaCvudcbsXf9Y=
Date: Mon, 31 Aug 2026 16:46:10 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,muchun.song@linux.dev,mingo@redhat.com,kees@kernel.org,david@kernel.org,dave.hansen@linux.intel.com,bp@alien8.de,balbirs@nvidia.com,arnd@arndb.de,apopple@nvidia.com,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + string-introduce-memcpy_nontemporal.patch added to mm-new branch
Message-Id: <20260831234611.377631F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: string: introduce memcpy_nontemporal()
has been added to the -mm mm-new branch.  Its filename is
     string-introduce-memcpy_nontemporal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/string-introduce-memcpy_nontemporal.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-fix-stale-zone_device-refcount-comment.patch
mm-add-a-set_page_section_from_pfn-helper.patch
mm-add-a-template-based-fast-path-for-zone-device-page-init.patch
mm-extend-the-template-fast-path-to-zone-device-compound-tails.patch
string-introduce-memcpy_nontemporal.patch
mm-use-memcpy_nontemporal-in-zone-device-template-copies.patch
x86-string-extend-memcpy_flushcache-fixed-size-fastpaths.patch

