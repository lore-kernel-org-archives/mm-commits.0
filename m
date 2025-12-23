Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EE534B1AF;
	Tue, 23 Dec 2025 19:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766517841; cv=none; b=Ubiba48CkhOboUgyu0+ApicXBA0rXh/APbZn5HPyZst3nEqE4c1wIJf1PY8fafxCVhp2BVJE3SW5NPTYHgVP6OfSWlxpjK21fGxbssvjXKTnsTi01QLKSCANmxSJVM+shWJW4lV+7vPWoAn0JdAlMBUhGrOSChTBICWLsHd+10Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766517841; c=relaxed/simple;
	bh=MATuAE7jm5VpvnPf1aVQI09tA/GmtIFsQMRDe2K5BoY=;
	h=Date:To:From:Subject:Message-Id; b=huLsbOTHvfJGMJIEeHFn69nUGEVRNNT5Mg57dL+gfUj2+eT54OzgzNu/otTPxC+teO0SWSVTjvyTQH5VTQExhwuHmCa7kAGflW7k7AjsMA3L7SDFeKujuRmwmA9v9v13YIvz/iM0qj2R/scR2avvuGmRD7tkaSZcCDSnkXyYZg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0ubL8Ak7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0ubL8Ak7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30E2C116D0;
	Tue, 23 Dec 2025 19:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766517840;
	bh=MATuAE7jm5VpvnPf1aVQI09tA/GmtIFsQMRDe2K5BoY=;
	h=Date:To:From:Subject:From;
	b=0ubL8Ak7W3d5FvzkINlV/bG490e5TP+oNNQ/zlDkgjMU4vn4jGrqPjKJy81VA4JLe
	 VskbEt/sFHoaC8PteR/knjEYWHS9r6qFIJCW4mmp7zBzWxMoD7XrdnVBdUiyWSvwfc
	 5uDQgJOGhGBrtIR+RhX89Zelv/aiVlVi4zeQ8G6s=
Date: Tue, 23 Dec 2025 11:24:00 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,urezki@gmail.com,stable@vger.kernel.org,ryabinin.a.a@gmail.com,kees@kernel.org,jiayuan.chen@linux.dev,glider@google.com,elver@google.com,dvyukov@google.com,dakr@kernel.org,andreyknvl@gmail.com,maciej.wieczor-retman@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kasan-refactor-pcpu-kasan-vmalloc-unpoison.patch removed from -mm tree
Message-Id: <20251223192400.D30E2C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: refactor pcpu kasan vmalloc unpoison
has been removed from the -mm tree.  Its filename was
     kasan-refactor-pcpu-kasan-vmalloc-unpoison.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: 1d96320f8d53 ("kasan, vmalloc: add vmalloc tagging for SW_TAGS")
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
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
@@ -631,6 +631,16 @@ static __always_inline void kasan_poison
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
@@ -655,6 +665,11 @@ static inline void *kasan_unpoison_vmall
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
@@ -575,3 +576,19 @@ bool __kasan_check_byte(const void *addr
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
@@ -5027,9 +5027,7 @@ retry:
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


