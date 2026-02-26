Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA9315A864
	for <mm-commits@vger.kernel.org>; Thu, 26 Feb 2026 00:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772066126; cv=none; b=dG8Q3ARyxLoe77bKI00uLHMwaI0BYIeube0tHgkV6HYQwq7XcuOdPRMt2E0954y9T28/r+aRZCHIeLQijdc/aBUhg2JE1qvIvcu4mFk5mSy6so4mmzTTdH5525w0VBSX7jQt+qO9zGsOkeE8ielf/K7LDrJfRl1jte0r4/w1MZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772066126; c=relaxed/simple;
	bh=H/6dr7ZYybS6UB5HTv3982CKOzXkdqbaokJQZD7eKcE=;
	h=Date:To:From:Subject:Message-Id; b=RR3okXnxJqrtiGaDX1EHLu4bGKOCN4vlUxgr81ztBZXhQ6aEKusU/QH57EsBYKtNVEmqK/xDCH2AUXEEOJLjysYnKLJX0w5u5jqXQdkILhkNxNg+gZexT3SMNl2BxX8950O4+snLJwBBEDemOKIXID+/ydKeaulmamiIembPwOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=12DlJLmV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="12DlJLmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B541AC116D0;
	Thu, 26 Feb 2026 00:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772066125;
	bh=H/6dr7ZYybS6UB5HTv3982CKOzXkdqbaokJQZD7eKcE=;
	h=Date:To:From:Subject:From;
	b=12DlJLmVcSFPv+lZ+hp8f4lR3pW9L1qkaxipcmLph2zyux8+8qbMUsLwosvw1O2KR
	 5NwdBdU/fEmBUFe00yi4S+jLdOCM5hk2DrxOx1K7Gy/N6L+U7pFI0LFPwOPj1/hkbF
	 4iuii8CwAtGcnIrK9jLI/1HljpzORrvyXTSe/OBI=
Date: Wed, 25 Feb 2026 16:35:25 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kees@kernel.org,david@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-fix-testing-vma-and-testing-radix-tree-build.patch added to mm-hotfixes-unstable branch
Message-Id: <20260226003525.B541AC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing: fix testing/vma and testing/radix-tree build
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tools-testing-fix-testing-vma-and-testing-radix-tree-build.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-fix-testing-vma-and-testing-radix-tree-build.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: tools/testing: fix testing/vma and testing/radix-tree build
Date: Thu, 26 Feb 2026 01:31:11 +0200

Build of VMA and radix-tree tests is unhappy after the conversion of
kzalloc() to kzalloc_obj() in lib/idr.c:

  cc -I../shared -I. -I../../include -I../../arch/x86/include -I../../../lib -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined  -DNUM_VMA_FLAG_BITS=128 -DNUM_MM_FLAG_BITS=128   -c -o idr.o idr.c
  idr.c: In function `ida_alloc_range':
  idr.c:420:34: error: implicit declaration of function `kzalloc_obj'; did you mean `kzalloc_node'? [-Wimplicit-function-declaration]
    420 |                         bitmap = kzalloc_obj(*bitmap, GFP_NOWAIT);
        |                                  ^~~~~~~~~~~
        |                                  kzalloc_node
  idr.c:420:32: error: assignment to `struct ida_bitmap *' from `int' makes pointer from integer without a cast [-Wint-conversion]
    420 |                         bitmap = kzalloc_obj(*bitmap, GFP_NOWAIT);
        |                                ^
  idr.c:447:40: error: assignment to `struct ida_bitmap *' from `int' makes pointer from integer without a cast [-Wint-conversion]
    447 |                                 bitmap = kzalloc_obj(*bitmap, GFP_NOWAIT);
        |                                        ^
  idr.c:468:15: error: assignment to `struct ida_bitmap *' from `int' makes pointer from integer without a cast [-Wint-conversion]
    468 |         alloc = kzalloc_obj(*bitmap, gfp);
        |               ^
  make: *** [<builtin>: idr.o] Error 1

Import necessary macros from include/linux to tools/include/linux to fix
the compilation.

Link: https://lkml.kernel.org/r/20260225233111.2760752-1-rppt@kernel.org
Fixes: 69050f8d6d07 ("treewide: Replace kmalloc with kmalloc_obj for non-scalar types")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/linux/gfp.h      |    4 ++++
 tools/include/linux/overflow.h |   19 +++++++++++++++++++
 tools/include/linux/slab.h     |    9 +++++++++
 3 files changed, 32 insertions(+)

--- a/tools/include/linux/gfp.h~tools-testing-fix-testing-vma-and-testing-radix-tree-build
+++ a/tools/include/linux/gfp.h
@@ -5,6 +5,10 @@
 #include <linux/types.h>
 #include <linux/gfp_types.h>
 
+/* Helper macro to avoid gfp flags if they are the default one */
+#define __default_gfp(a,...) a
+#define default_gfp(...) __default_gfp(__VA_ARGS__ __VA_OPT__(,) GFP_KERNEL)
+
 static inline bool gfpflags_allow_blocking(const gfp_t gfp_flags)
 {
 	return !!(gfp_flags & __GFP_DIRECT_RECLAIM);
--- a/tools/include/linux/overflow.h~tools-testing-fix-testing-vma-and-testing-radix-tree-build
+++ a/tools/include/linux/overflow.h
@@ -69,6 +69,25 @@
 })
 
 /**
+ * size_mul() - Calculate size_t multiplication with saturation at SIZE_MAX
+ * @factor1: first factor
+ * @factor2: second factor
+ *
+ * Returns: calculate @factor1 * @factor2, both promoted to size_t,
+ * with any overflow causing the return value to be SIZE_MAX. The
+ * lvalue must be size_t to avoid implicit type conversion.
+ */
+static inline size_t __must_check size_mul(size_t factor1, size_t factor2)
+{
+	size_t bytes;
+
+	if (check_mul_overflow(factor1, factor2, &bytes))
+		return SIZE_MAX;
+
+	return bytes;
+}
+
+/**
  * array_size() - Calculate size of 2-dimensional array.
  *
  * @a: dimension one
--- a/tools/include/linux/slab.h~tools-testing-fix-testing-vma-and-testing-radix-tree-build
+++ a/tools/include/linux/slab.h
@@ -202,4 +202,13 @@ static inline unsigned int kmem_cache_sh
 	return sheaf->size;
 }
 
+#define __alloc_objs(KMALLOC, GFP, TYPE, COUNT)				\
+({									\
+	const size_t __obj_size = size_mul(sizeof(TYPE), COUNT);	\
+	(TYPE *)KMALLOC(__obj_size, GFP);				\
+})
+
+#define kzalloc_obj(P, ...) \
+	__alloc_objs(kzalloc, default_gfp(__VA_ARGS__), typeof(P), 1)
+
 #endif		/* _TOOLS_SLAB_H */
_

Patches currently in -mm which might be from rppt@kernel.org are

tools-testing-fix-testing-vma-and-testing-radix-tree-build.patch
mm-dont-special-case-mmu-for-is_zero_pfn-and-my_zero_pfn.patch
mm-rename-my_zero_pfn-to-zero_pfn.patch
arch-mm-consolidate-empty_zero_page.patch
mm-cache-struct-page-for-empty_zero_page-and-return-it-from-zero_page.patch

