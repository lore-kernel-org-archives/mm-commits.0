Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC59E3B961A
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439059; cv=none; b=hBRcExH1JjTI4+3T6oZEHMf+ZfOI3301u62wgVSUcqGysFNWsk2wCMqwp5M+QLoA8YcfeqwR3rtJYUlvzbDjJNQxSSiNrQ6VAZWz+tAW8j4/Kkfc/f0vxXmkmacA9wGUm+ugz2AnoHjdh4uFWw+hYbOy7ECinvdZkGDCZmezLQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439059; c=relaxed/simple;
	bh=aenvcTFX9serCLQWdOcGEfbzjsiE+a4NoaelppCUOhs=;
	h=Date:To:From:Subject:Message-Id; b=af81epLWC3wo72SdncYp9D06bk40o1i0tlflpiFTk6FGIob76jA5NRGm6ou8kbgXV9uLj88R8ol/dKjXYY2EgyKeVGBJee1n+Jg2EwPDXKFyIEkD5HyQu4ZwUR0n303KQgs1ak+6Nlu7dJA6o3zXLRRl36UCmdcEASzeXAnEfx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mt0+qZmd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mt0+qZmd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9458C1F00898;
	Tue,  2 Jun 2026 22:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439057;
	bh=zZMQyBEREJYuqAIMhTOTw1BiF/BCtCuKW5y3QtYlk/c=;
	h=Date:To:From:Subject;
	b=mt0+qZmdkpFSng3Z7lht4xrxZmJvG/OAbGGYlyTv5fdnognvQoWq+8cAF1KpKTh0a
	 7ZQXrURdUx/qiAOBsthvSNDsu39Xtm1WUrw8rfeig34nWUYkgZbFRUDd/2W8ktyFf4
	 E2ZOuh5NUu/9qk53bZ0GT4mrAPharXbw1pYcGUG0=
Date: Tue, 02 Jun 2026 15:24:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rafael@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lenb@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rejig-pageblock-mask-definitions.patch removed from -mm tree
Message-Id: <20260602222417.9458C1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rejig pageblock mask definitions
has been removed from the -mm tree.  Its filename was
     mm-rejig-pageblock-mask-definitions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm: rejig pageblock mask definitions
Date: Wed, 13 May 2026 12:35:15 +0000

- Add a PAGEBLOCK_ prefix to the names to avoid polluting the "global
  namespace" too much.

- This new prefix makes MIGRATETYPE_AND_ISO_MASK look pretty long. Well,
  that global mask only exists for quite a specific purpose, and is
  quite a weird thing to have a name for anyway. So drop it and take
  advantage of the newly-defined PAGEBLOCK_ISO_MASK.

Link: https://lore.kernel.org/20260513-page_alloc-unmapped-prep-v1-3-dacdf5402be8@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pageblock-flags.h |    6 +++---
 mm/page_alloc.c                 |   18 +++++++++---------
 2 files changed, 12 insertions(+), 12 deletions(-)

--- a/include/linux/pageblock-flags.h~mm-rejig-pageblock-mask-definitions
+++ a/include/linux/pageblock-flags.h
@@ -36,12 +36,12 @@ enum pageblock_bits {
 
 #define NR_PAGEBLOCK_BITS (roundup_pow_of_two(__NR_PAGEBLOCK_BITS))
 
-#define MIGRATETYPE_MASK (BIT(PB_migrate_0)|BIT(PB_migrate_1)|BIT(PB_migrate_2))
+#define PAGEBLOCK_MIGRATETYPE_MASK (BIT(PB_migrate_0)|BIT(PB_migrate_1)|BIT(PB_migrate_2))
 
 #ifdef CONFIG_MEMORY_ISOLATION
-#define MIGRATETYPE_AND_ISO_MASK (MIGRATETYPE_MASK | BIT(PB_migrate_isolate))
+#define PAGEBLOCK_ISO_MASK	BIT(PB_migrate_isolate)
 #else
-#define MIGRATETYPE_AND_ISO_MASK MIGRATETYPE_MASK
+#define PAGEBLOCK_ISO_MASK	0
 #endif
 
 #if defined(CONFIG_HUGETLB_PAGE)
--- a/mm/page_alloc.c~mm-rejig-pageblock-mask-definitions
+++ a/mm/page_alloc.c
@@ -364,7 +364,7 @@ get_pfnblock_bitmap_bitidx(const struct
 #else
 	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
 #endif
-	BUILD_BUG_ON(__MIGRATE_TYPE_END > MIGRATETYPE_MASK);
+	BUILD_BUG_ON(__MIGRATE_TYPE_END > PAGEBLOCK_MIGRATETYPE_MASK);
 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
 
 	bitmap = get_pageblock_bitmap(page, pfn);
@@ -437,7 +437,7 @@ bool get_pfnblock_bit(const struct page
 __always_inline enum migratetype
 get_pfnblock_migratetype(const struct page *page, unsigned long pfn)
 {
-	unsigned long mask = MIGRATETYPE_AND_ISO_MASK;
+	unsigned long mask = PAGEBLOCK_MIGRATETYPE_MASK | PAGEBLOCK_ISO_MASK;
 	unsigned long flags;
 
 	flags = __get_pfnblock_flags_mask(page, pfn, mask);
@@ -446,7 +446,7 @@ get_pfnblock_migratetype(const struct pa
 	if (flags & BIT(PB_migrate_isolate))
 		return MIGRATE_ISOLATE;
 #endif
-	return flags & MIGRATETYPE_MASK;
+	return flags & PAGEBLOCK_MIGRATETYPE_MASK;
 }
 
 /**
@@ -534,11 +534,11 @@ static void set_pageblock_migratetype(st
 	}
 	VM_WARN_ONCE(get_pageblock_isolate(page),
 		     "Use clear_pageblock_isolate() to unisolate pageblock");
-	/* MIGRATETYPE_AND_ISO_MASK clears PB_migrate_isolate if it is set */
+	/* PAGEBLOCK_ISO_MASK clears PB_migrate_isolate if it is set */
 #endif
 	__set_pfnblock_flags_mask(page, page_to_pfn(page),
 				  (unsigned long)migratetype,
-				  MIGRATETYPE_AND_ISO_MASK);
+				  PAGEBLOCK_MIGRATETYPE_MASK | PAGEBLOCK_ISO_MASK);
 }
 
 void __meminit init_pageblock_migratetype(struct page *page,
@@ -564,7 +564,7 @@ void __meminit init_pageblock_migratetyp
 		flags |= BIT(PB_migrate_isolate);
 #endif
 	__set_pfnblock_flags_mask(page, page_to_pfn(page), flags,
-				  MIGRATETYPE_AND_ISO_MASK);
+				  PAGEBLOCK_MIGRATETYPE_MASK | PAGEBLOCK_ISO_MASK);
 }
 
 #ifdef CONFIG_DEBUG_VM
@@ -2140,15 +2140,15 @@ static bool __move_freepages_block_isola
 	}
 
 move:
-	/* Use MIGRATETYPE_MASK to get non-isolate migratetype */
+	/* Use PAGEBLOCK_MIGRATETYPE_MASK to get non-isolate migratetype */
 	if (isolate) {
 		from_mt = __get_pfnblock_flags_mask(page, page_to_pfn(page),
-						    MIGRATETYPE_MASK);
+						    PAGEBLOCK_MIGRATETYPE_MASK);
 		to_mt = MIGRATE_ISOLATE;
 	} else {
 		from_mt = MIGRATE_ISOLATE;
 		to_mt = __get_pfnblock_flags_mask(page, page_to_pfn(page),
-						  MIGRATETYPE_MASK);
+						  PAGEBLOCK_MIGRATETYPE_MASK);
 	}
 
 	__move_freepages_block(zone, start_pfn, from_mt, to_mt);
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-delete-stale-comment-about-cachelines.patch

