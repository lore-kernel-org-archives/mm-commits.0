Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A328C381B07
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 02:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783997021; cv=none; b=gcuqrmUKalRyNsxQNZC2ufy8RGQ3MrzUysXPmxfz0SEwRwCDWSKyXqvb49C0kRzAHK+HobThI9aEMVMVJxa2Xxt9szQP/VToXl1kh7Vng6XPaVg1mMRIQRM5wr+GK6V3Ii+G2P8SeqbYaz8t5PjS0gCdOniSEEYkzH4bl7b+I7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783997021; c=relaxed/simple;
	bh=vxW5dUWHsbtlUgYTMVBrD/DuoxlYwF605BNMfg53Q6M=;
	h=Date:To:From:Subject:Message-Id; b=FX3xRBoQlKehkYZxiQiSPoD8FyS2mIKB+LzTRTj7i41rRTnyyXBAp1OBR+UmfZ64EjLjPt9+jCuIzYa8CkIejLWwrj2O2CEVWPUmR27iSTBPvNx8kT5AawWUvigqXW9Wuw7JWJH0tBnR0kC0fhfZzyqh950vyXJvc0DsA8EKmuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O5p5cM29; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O5p5cM29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA291F000E9;
	Tue, 14 Jul 2026 02:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783997020;
	bh=ooOhE1OtIMPlpdDP8qlqDTzLwLmTBrTuPySgQvczZug=;
	h=Date:To:From:Subject;
	b=O5p5cM29I+lr4S67qRZeuYxYdEWLjcp2c9M+rjDn4nm0EGTKeYa1bmkV+sUS2avzZ
	 tcSBK3Oc+4Mm8NwPyTDKn9sop0oH6uB7k/P4LzAklMUCVrxNgcO1ITrjM/ExPkXE1R
	 pFkAJoNeDK9R9SUO434av3hs8WwnwmV0OBvaCgso=
Date: Mon, 13 Jul 2026 19:43:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,urezki@gmail.com,tj@kernel.org,surenb@google.com,sj@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hannes@cmpxchg.org,graf@amazon.com,glider@google.com,elver@google.com,dvyukov@google.com,dennis@kernel.org,david@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-split-out-mm_init-and-memblock-declarations-from-internalh-fix.patch added to mm-unstable branch
Message-Id: <20260714024339.EFA291F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memblock tests: split stubfs from internal.h to mm_init.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-split-out-mm_init-and-memblock-declarations-from-internalh-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-split-out-mm_init-and-memblock-declarations-from-internalh-fix.patch

This patch will later appear in the mm-unstable branch at
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
Subject: memblock tests: split stubfs from internal.h to mm_init.h
Date: Sat, 11 Jul 2026 18:11:13 +0300

Following the split of declarations from mm/internal.h to mm/mm_init.h
update memblock tests to match the kernel core, otherwise they fail to
build.

Link: https://lore.kernel.org/alJd1BLypyK9Mpaw@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: SJ Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/memblock/internal.h |   20 --------------------
 tools/testing/memblock/mm_init.h  |   24 ++++++++++++++++++++++++
 2 files changed, 24 insertions(+), 20 deletions(-)

--- a/tools/testing/memblock/internal.h~mm-split-out-mm_init-and-memblock-declarations-from-internalh-fix
+++ a/tools/testing/memblock/internal.h
@@ -28,22 +28,6 @@ static inline struct page *virt_to_page(
 	return virt;
 }
 
-void memblock_free_pages(unsigned long pfn, unsigned int order)
-{
-}
-
-static inline void accept_memory(phys_addr_t start, unsigned long size)
-{
-}
-
-unsigned long free_reserved_area(void *start, void *end, int poison, const char *s);
-void free_reserved_page(struct page *page);
-
-static inline bool deferred_pages_enabled(void)
-{
-	return false;
-}
-
 #define for_each_valid_pfn(pfn, start_pfn, end_pfn)			 \
 	for ((pfn) = (start_pfn); (pfn) < (end_pfn); (pfn)++)
 
@@ -60,10 +44,6 @@ static inline bool __is_kernel(unsigned
 #define for_each_valid_pfn(pfn, start_pfn, end_pfn)                     \
        for ((pfn) = (start_pfn); (pfn) < (end_pfn); (pfn)++)
 
-static inline void init_deferred_page(unsigned long pfn, int nid)
-{
-}
-
 #define __SetPageReserved(p)	((void)(p))
 
 #endif
diff --git a/tools/testing/memblock/mm_init.h a/tools/testing/memblock/mm_init.h
new file mode 100644
--- /dev/null
+++ a/tools/testing/memblock/mm_init.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef __MM_MM_INIT_H
+#define __MM_MM_INIT_H
+
+void memblock_free_pages(unsigned long pfn, unsigned int order)
+{
+}
+
+static inline void accept_memory(phys_addr_t start, unsigned long size)
+{
+}
+
+unsigned long free_reserved_area(void *start, void *end, int poison, const char *s);
+void free_reserved_page(struct page *page);
+
+static inline bool deferred_pages_enabled(void)
+{
+	return false;
+}
+
+static inline void init_deferred_page(unsigned long pfn, int nid)
+{
+}
+#endif /* __MM_MM_INIT_H */
_

Patches currently in -mm which might be from rppt@kernel.org are

selftests-mm-uffd-dont-treat-uffdio_copy-enoent-as-a-failure.patch
mm-split-out-mm_init-and-memblock-declarations-from-internalh.patch
mm-split-out-mm_init-and-memblock-declarations-from-internalh-fix.patch
mm-split-out-sparse-declarations-from-internalh.patch
mm-split-out-vmalloc-declarations-from-internalh.patch

