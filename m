Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6044B3C6A25
	for <mm-commits@vger.kernel.org>; Wed,  4 Mar 2026 17:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772646306; cv=none; b=lKcZTpULZDvWIPOarHCoj+fEvW5fAUkf7osj4ciHEUTdvKGhZnzjm0rUYjoi2DcjFirthUkfa4D5PxtDipctfVPr/rpFAb87/bwyySDvIaCdF2jzbSHQyMylqehNmixNm4rgPUrcrU7Sjt6n+OKQrVvAUoOt5qjI9XCCeKAFDqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772646306; c=relaxed/simple;
	bh=UypaPrwty7TYlJoxmiuLq9BSgvhgk7WA0AoUXTof9/s=;
	h=Date:To:From:Subject:Message-Id; b=HrUh61rcoqA94OzTQN/iFZe1gOg4rGCqeiV3UbuK/UghBGh76rDUiVqJzLujqvq45J1JR5LV5LPRGv0QlKuPl+3CO2h21d1r5fuNbzWoGchPOjFyG5Nr3S96t5aM/6YzTCes8LAI27n9eDxTCwQpIJEITn2R+5u13ei29/8lgd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zguR5c4l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zguR5c4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A16C2BC86;
	Wed,  4 Mar 2026 17:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772646306;
	bh=UypaPrwty7TYlJoxmiuLq9BSgvhgk7WA0AoUXTof9/s=;
	h=Date:To:From:Subject:From;
	b=zguR5c4lIMFAMIDiK22CYPPogy6kOylvejpknmImonyGYMgF4fNBwcK0jyOB2erih
	 aWfSN5/oCX7FhX8qFYDjEhkecLmA0zF+e5U+XiyIUijC4mB3IaQVkwO1ALIbMJBloC
	 lvdDs6MWyFde8yLuE+6/yqJQdvxHpI4HoJMJypPU=
Date: Wed, 04 Mar 2026 09:45:05 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,sj@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kees@kernel.org,david@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] tools-testing-fix-testing-vma-and-testing-radix-tree-build.patch removed from -mm tree
Message-Id: <20260304174505.F0A16C2BC86@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/testing: fix testing/vma and testing/radix-tree build
has been removed from the -mm tree.  Its filename was
     tools-testing-fix-testing-vma-and-testing-radix-tree-build.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Tested-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
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

mm-dont-special-case-mmu-for-is_zero_pfn-and-my_zero_pfn.patch
mm-rename-my_zero_pfn-to-zero_pfn.patch
arch-mm-consolidate-empty_zero_page.patch
mm-cache-struct-page-for-empty_zero_page-and-return-it-from-zero_page.patch

