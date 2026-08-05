Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAA862809
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 01:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785892389; cv=none; b=mn8yU4vDshf9AQBBmV3JDIqiGaiZ2tswszDoA44i+s+VEmCVkZ0lc7tb9/JZtw5cdxwPcFhiDIzMGUGtcaBmUxZSHtgsEDYcyS+VLnpNjCGJcw7NaUzGrkERPO7KkByA6pH/QkGak4Bf5u+KXEqn8Q9S2S+4+N9AqWCkgLalX9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785892389; c=relaxed/simple;
	bh=jzdndW5fKCNEYNSNRdtX8R/dMdauDJwY9VROGvtlGcY=;
	h=Date:To:From:Subject:Message-Id; b=HEr7t9dgksjfyk2Jw2YFBCFIm4BFGmSwIuQaXilyjv6l6nINtTHnD36txcJyWQQle5eWq2g3Cb/QUrbkchn4ds/1sj/7g4gGetvtKRGXlWTGWrP06KHw/e+MhOTPeFHAKPNfKJ3K46Gj7FO5gaZ6jPE78hIfGHjyOViaDZ5z7t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E6iWqXgf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E6iWqXgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB1D1F000E9;
	Wed,  5 Aug 2026 01:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785892387;
	bh=w8ThPSL4ZIokcMze6VUCwiGjau0PDlQBrjB03+77mFE=;
	h=Date:To:From:Subject;
	b=E6iWqXgfexgmQMUW9eLYduDhmaDy18cJOgEDLjr36+1ofCNN57hYa956bS1vKDYZV
	 PajYIvAYsmcaRhzG0G6Bk9dXFs3EpB+osV4gPXlMM70aa5Hfl23qZhJO/aTioriMrr
	 7a5hs+NCyTeJQt3GuQ9ud03BRrkVh3Lr97a8Ssvs=
Date: Tue, 04 Aug 2026 18:13:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,urezki@gmail.com,tj@kernel.org,surenb@google.com,sj@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hannes@cmpxchg.org,graf@amazon.com,glider@google.com,elver@google.com,dvyukov@google.com,dennis@kernel.org,david@kernel.org,brendan.jackman@linux.dev,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-split-out-mm_init-and-memblock-declarations-from-internalh-fix.patch removed from -mm tree
Message-Id: <20260805011307.6DB1D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memblock tests: split stubfs from internal.h to mm_init.h
has been removed from the -mm tree.  Its filename was
     mm-split-out-mm_init-and-memblock-declarations-from-internalh-fix.patch

This patch was dropped because it was folded into mm-split-out-mm_init-and-memblock-declarations-from-internalh.patch

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
Cc: Brendan Jackman <brendan.jackman@linux.dev>
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

mm-split-out-mm_init-and-memblock-declarations-from-internalh.patch
mm-split-out-sparse-declarations-from-internalh.patch
mm-split-out-vmalloc-declarations-from-internalh.patch
sh-remove-config_numa-and-realted-configuration-options.patch
sh-mm-remove-numac.patch
sh-mm-drop-allocate_pgdat.patch
sh-remove-setup_bootmem_node-and-plat_mem_setup.patch
sh-drop-dead-code-guarded-by-ifdef-config_numa.patch
sh-drop-include-asm-mmzoneh.patch
init-kconfig-drop-arch_want_numa_variable_locality.patch
sh-init-remove-call-the-memblock_set_node.patch
sh-remove-sparsemem-related-entries-from-kconfig.patch
sh-drop-include-asm-sparsememh.patch

