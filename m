Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795403070;
	b=ibvVd3jLz/Dh2VeeDEapXvNaTySyBiDmP4lvIFC5A2wF691sapY1RMQYFA2ruEkXf9ub
	 XFIYn1cBrQA7U9mpUwpgYk47iEhVlslIywfa7SrM6w5sfaVtAl6DEMaJ8d5rjp1nU+N3v
	 4RpO8rUsX0yWLtekdSf/Uz7I2HsQ4ixcTnuq+y8R/Jv4u3351oFGRgut3utqdddkkfNrC
	 KL4JhUUz8oiHYRUzNHvHqlQAuJmhJ6T6J/+06ajqNNIDZFHcuPXUK5LJzFL0ggtHUwAYR
	 WbeQra5qL0sehsBBCG0QwO0/0my9utgZYOnlNgGLVv1xzNye7OolpNoZcNoj29+ZdKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795403070;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=YRDl6TR4TIYdqbvcfdGfasa314v9bpIsOPryaoAZLNQ=;
	b=aE9gRIKWkaAvJs+UksOpc1zdXPBBlKqpghaIKkpYJ+tLje8IFyrB2JQvjFQEu+WMdT0l
	 ewS7JkEYKoN2vuTZH32hrDsiBhduZ5HiCy8p/s0h9RO+fA/Nbgb6R10Xg85SZt7gwRSpK
	 qJOSlbNt0xWWhxxFMHvfWJNYuBdPvdJSBlfrxqpikp9gU3QJm/xUVYebpsgwPGlj9YeY2
	 Xa6qoZOeKZkAXQwK641T2rKuhl/mfCiuLaNnrdsFvL2W7vkt37Iksq+TaadFlOQTUSXQ/
	 nQUY2Uoivdk64kqxlAPijgwztxi0XQft80oyQVRXVU+yGQnJMoBEXmJ70vAnWRuf99A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WIiCG4KM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EC7606A327
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 03:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WIiCG4KM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451581F000C0;
	Mon, 23 Nov 2026 03:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795403070;
	bh=YRDl6TR4TIYdqbvcfdGfasa314v9bpIsOPryaoAZLNQ=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=WIiCG4KMSPu7Ui2F+scsQs5+WgihiHxpsGsjG9wMb7qPs7i/Odn+x6wwsU63isGh7
	 CvIgLpum/00PEmLTZIZJ6lZcmXAgHt51LK3lOfQ7u6H4iqpcY7YiPLc8EYu/dClMcc
	 OrUpqZSMyhaLTTO0voGfqQ+aZ3SHmmWo+m3AqC+M=
Date: Sun, 22 Nov 2026 19:04:29 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	rppt@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,
	ljs@kernel.org,lizhe.67@bytedance.com,liam@infradead.org,
	lance.yang@linux.dev,jthoughton@google.com,david@kernel.org,
	balbirs@nvidia.com,apopple@nvidia.com,songmuchun@bytedance.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261120100856.16929-11-songmuchun@bytedance.com>
References: <20261120100856.16929-11-songmuchun@bytedance.com>
Subject: + mm-cma-localize-init_cma_pageblock-to-cmac.patch added to mm-new branch
Message-Id: <20261123030430.451581F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/cma: localize init_cma_pageblock() to cma.c
has been added to the -mm mm-new branch.  Its filename is
     mm-cma-localize-init_cma_pageblock-to-cmac.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-localize-init_cma_pageblock-to-cmac.patch

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/cma: localize init_cma_pageblock() to cma.c
Date: Fri, 20 Nov 2026 18:08:55 +0800

Move init_cma_pageblock() from mm_init.c into cma.c so it lives
alongside the CMA code that uses it.

No functional change intended.

Link: https://patch.msgid.link/20261120100856.16929-11-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>

 mm/cma.c     |    8 ++++++++
 mm/mm_init.c |    9 ---------
 mm/mm_init.h |    8 --------
 3 files changed, 8 insertions(+), 17 deletions(-)

--- a/mm/cma.c~mm-cma-localize-init_cma_pageblock-to-cmac
+++ a/mm/cma.c
@@ -31,6 +31,7 @@
 #include <linux/kmemleak.h>
 #include <linux/hugetlb.h>
 #include <trace/events/cma.h>
+#include <linux/page-isolation.h>
 
 #include "internal.h"
 #include "cma.h"
@@ -149,6 +150,13 @@ bool cma_validate_zones(struct cma *cma)
 	return true;
 }
 
+static void __init init_cma_pageblock(struct page *page)
+{
+	init_pageblock_migratetype(page, MIGRATE_CMA, false);
+	adjust_managed_page_count(page, pageblock_nr_pages);
+	page_zone(page)->cma_pages += pageblock_nr_pages;
+}
+
 static void __init cma_activate_area(struct cma *cma)
 {
 	unsigned long pfn, end_pfn, early_pfn[CMA_MAX_RANGES];
--- a/mm/mm_init.c~mm-cma-localize-init_cma_pageblock-to-cmac
+++ a/mm/mm_init.c
@@ -2202,15 +2202,6 @@ void __init init_cma_reserved_pageblock(
 	adjust_managed_page_count(page, pageblock_nr_pages);
 	page_zone(page)->cma_pages += pageblock_nr_pages;
 }
-/*
- * Similar to above, but only set the migrate type and stats.
- */
-void __init init_cma_pageblock(struct page *page)
-{
-	init_pageblock_migratetype(page, MIGRATE_CMA, false);
-	adjust_managed_page_count(page, pageblock_nr_pages);
-	page_zone(page)->cma_pages += pageblock_nr_pages;
-}
 #endif
 
 /*
--- a/mm/mm_init.h~mm-cma-localize-init_cma_pageblock-to-cmac
+++ a/mm/mm_init.h
@@ -40,14 +40,6 @@ struct zone *pfn_to_zone(unsigned long p
 void init_cma_reserved_pageblock(struct page *page);
 #endif
 
-#ifdef CONFIG_CMA
-void init_cma_pageblock(struct page *page);
-#else
-static inline void init_cma_pageblock(struct page *page)
-{
-}
-#endif
-
 /* Memory initialisation debug and verification */
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 DECLARE_STATIC_KEY_TRUE(deferred_pages);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

powerpc-mm-make-vmemmap_populate_compound_pages-static.patch
powerpc-mm-drop-powerpc-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis.patch
mm-hugetlb_vmemmap-fix-hwpoison-state-races-during-optimization.patch
mm-hugetlb_vmemmap-fix-pmd-split-tlb-flush-race.patch
mm-hugetlb_vmemmap-fix-deadlock-during-pmd-split.patch
mm-list_lru-fix-potential-infinite-loop-on-xa-node-allocation-failure.patch
mm-mm_init-verify-zones-for-template-initialized-pages.patch
mm-mm_init-factor-out-common-struct-page-initialization.patch
mm-mm_init-simplify-zone-device-page-initialization.patch
mm-mm_init-factor-out-compound-page-initialization.patch
mm-hugetlb-drop-boot-time-hvo-handling-for-gigantic-folios.patch
mm-hugetlb-initialize-all-struct-pages-for-bootmem-hugepages.patch
mm-hugetlb-use-common-compound-page-initialization-helper.patch
mm-mm_init-make-__init_single_page-static.patch
mm-cma-centralize-cma-pageblock-initialization.patch
mm-cma-localize-init_cma_pageblock-to-cmac.patch
mm-mm_init-move-pageblock-migratetype-init-to-memmap-helpers.patch

