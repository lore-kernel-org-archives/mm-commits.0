Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560FA2FB607;
	Thu,  4 Dec 2025 22:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764886885; cv=none; b=NN/9Ieo+8L91514XdZRejbHwyFuOL45ONH3YIk2UnebwSVphKwxvNpdETwG8wU9dugv6sYBoq7UU3wfXcUBfoku0FNnGGS2VlwGcqGxNs9EGfb3TKjxqrKVXtVZ0Jq97o5Bx4WfIxNcTLYEx4wvVQtP5p+eK4awg2aUkXaIFWio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764886885; c=relaxed/simple;
	bh=RzJyYzOci/HEGHiLwCpPl+uOqCAbpAZ+Be6sfe1lkQ4=;
	h=Date:To:From:Subject:Message-Id; b=hbKEbgdTSMoYbaKmNq3MJgo25N56AZFaQwpLJw4ebiAULFGNBJWVz4ra+kPxvNMVVw++jKB4BtkCoKpKWM8yvqTGJLtwK4mXEQZ5cWuWJf+SmWWgbJhUeiYGl9CfmDsrwtuVMTlkzUFaUrV8K2IdpJQW+ARrQUBLBAfw+3dGz5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yMkg5/DV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yMkg5/DV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E98BC4CEFB;
	Thu,  4 Dec 2025 22:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764886884;
	bh=RzJyYzOci/HEGHiLwCpPl+uOqCAbpAZ+Be6sfe1lkQ4=;
	h=Date:To:From:Subject:From;
	b=yMkg5/DVT4IuJKxXQvO6emEQZbRgeVpJzQQBDSCuS1SMxw1RApUoAoC1CXNc0AGcw
	 WCBdm3D3g1K9ljur8OaaM9EMPGF1D6WR8InyU9480MtHGr/YO+bmR+CFBHwgOFqQJj
	 POm3pBLVfEoMVBu2hT2Rk9kRNtdxfTC7cZtrxmVw=
Date: Thu, 04 Dec 2025 14:21:23 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,urezki@gmail.com,stable@vger.kernel.org,ryabinin.a.a@gmail.com,kees@kernel.org,jiayuan.chen@linux.dev,glider@google.com,elver@google.com,dvyukov@google.com,dakr@kernel.org,andreyknvl@gmail.com,maciej.wieczor-retman@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-refactor-pcpu-kasan-vmalloc-unpoison.patch added to mm-hotfixes-unstable branch
Message-Id: <20251204222124.5E98BC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: refactor pcpu kasan vmalloc unpoison
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-refactor-pcpu-kasan-vmalloc-unpoison.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-refactor-pcpu-kasan-vmalloc-unpoison.patch

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
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Subject: kasan: refactor pcpu kasan vmalloc unpoison
Date: Thu, 04 Dec 2025 19:00:04 +0000

A KASAN tag mismatch, possibly causing a kernel panic, can be observed
on systems with a tag-based KASAN enabled and with multiple NUMA nodes.
It was reported on arm64 and reproduced on x86. It can be explained in
the following points:

1. There can be more than one virtual memory chunk.
2. Chunk's base address has a tag.
3. The base address points at the first chunk and thus inherits
   the tag of the first chunk.
4. The subsequent chunks will be accessed with the tag from the
   first chunk.
5. Thus, the subsequent chunks need to have their tag set to
   match that of the first chunk.

Refactor code by reusing __kasan_unpoison_vmalloc in a new helper in
preparation for the actual fix.

Link: https://lkml.kernel.org/r/eb61d93b907e262eefcaa130261a08bcb6c5ce51.1764874575.git.m.wieczorretman@pm.me
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Fixes: 1d96320f8d53 ("kasan, vmalloc: add vmalloc tagging for SW_TAGS")
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Kees Cook <kees@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>	[6.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |   15 +++++++++++++++
 mm/kasan/common.c     |   17 +++++++++++++++++
 mm/vmalloc.c          |    4 +---
 3 files changed, 33 insertions(+), 3 deletions(-)

--- a/include/linux/kasan.h~kasan-refactor-pcpu-kasan-vmalloc-unpoison
+++ a/include/linux/kasan.h
@@ -615,6 +615,16 @@ static __always_inline void kasan_poison
 		__kasan_poison_vmalloc(start, size);
 }
 
+void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
+				 kasan_vmalloc_flags_t flags);
+static __always_inline void
+kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
+			  kasan_vmalloc_flags_t flags)
+{
+	if (kasan_enabled())
+		__kasan_unpoison_vmap_areas(vms, nr_vms, flags);
+}
+
 #else /* CONFIG_KASAN_VMALLOC */
 
 static inline void kasan_populate_early_vm_area_shadow(void *start,
@@ -639,6 +649,11 @@ static inline void *kasan_unpoison_vmall
 static inline void kasan_poison_vmalloc(const void *start, unsigned long size)
 { }
 
+static __always_inline void
+kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
+			  kasan_vmalloc_flags_t flags)
+{ }
+
 #endif /* CONFIG_KASAN_VMALLOC */
 
 #if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && \
--- a/mm/kasan/common.c~kasan-refactor-pcpu-kasan-vmalloc-unpoison
+++ a/mm/kasan/common.c
@@ -28,6 +28,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/bug.h>
+#include <linux/vmalloc.h>
 
 #include "kasan.h"
 #include "../slab.h"
@@ -582,3 +583,19 @@ bool __kasan_check_byte(const void *addr
 	}
 	return true;
 }
+
+#ifdef CONFIG_KASAN_VMALLOC
+void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
+				 kasan_vmalloc_flags_t flags)
+{
+	unsigned long size;
+	void *addr;
+	int area;
+
+	for (area = 0 ; area < nr_vms ; area++) {
+		size = vms[area]->size;
+		addr = vms[area]->addr;
+		vms[area]->addr = __kasan_unpoison_vmalloc(addr, size, flags);
+	}
+}
+#endif
--- a/mm/vmalloc.c~kasan-refactor-pcpu-kasan-vmalloc-unpoison
+++ a/mm/vmalloc.c
@@ -4872,9 +4872,7 @@ retry:
 	 * With hardware tag-based KASAN, marking is skipped for
 	 * non-VM_ALLOC mappings, see __kasan_unpoison_vmalloc().
 	 */
-	for (area = 0; area < nr_vms; area++)
-		vms[area]->addr = kasan_unpoison_vmalloc(vms[area]->addr,
-				vms[area]->size, KASAN_VMALLOC_PROT_NORMAL);
+	kasan_unpoison_vmap_areas(vms, nr_vms, KASAN_VMALLOC_PROT_NORMAL);
 
 	kfree(vas);
 	return vms;
_

Patches currently in -mm which might be from maciej.wieczor-retman@intel.com are

kasan-refactor-pcpu-kasan-vmalloc-unpoison.patch
kasan-unpoison-vms-addresses-with-a-common-tag.patch

