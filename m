Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F654389116
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 18:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779128088; cv=none; b=coamJnkJx1A2C/peLF8bMGgoOE8+DDJHaZgEpNIo7ZSEiigYBSNUb3aaTTtUJXr3KB//Ct71zbX8B4pe9W/rJZDCMWiJnXoZVPlHRM5N2duNiJsDWmqgiMnXsvFOL8ajRurZ0S1SmYCK/Uk6bh2Ad156B/wS7ss6fhbBCU9CYLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779128088; c=relaxed/simple;
	bh=6VC5m5chpI51Mwap5OJ7pVHrDQeWpCrjwwg9D8Cxwvc=;
	h=Date:To:From:Subject:Message-Id; b=Nt+5LxCEa4yTA1X4DK2dFS1L8mhCNK0K5OSTwhAhp2zqyeuRV2Xix9xpHwdeB8SLtRau/c8QsQe/6Jx1WkjSHZkwYWx4EXWwMGMClApR7a2OpTYTnORTxu1MJaWwyEoS3ZtQFRb1jeQJN2gDILusQKtTbWRf5L85FBhLtCVQ/x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ga5gjKIF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ga5gjKIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0F3C2BCB7;
	Mon, 18 May 2026 18:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779128087;
	bh=6VC5m5chpI51Mwap5OJ7pVHrDQeWpCrjwwg9D8Cxwvc=;
	h=Date:To:From:Subject:From;
	b=ga5gjKIF1dcvUeqHEfR6jsRbMCjU/tWbsuHTtMi3a//A2F9X8UsVHGRtMUl5tehVV
	 1VGI1ODP8V1goAn20nJoMFwDkvALnGmNV7pzTQHPYXB8RGhIzrC53+i3Qf55GX8Q5S
	 Ki8lI20A8HXRVydJdoFa+5Vq7lRCfSgRpQQqn4Lo=
Date: Mon, 18 May 2026 11:14:47 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rafael@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lenb@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rejig-pageblock-mask-definitions.patch added to mm-new branch
Message-Id: <20260518181447.BF0F3C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rejig pageblock mask definitions
has been added to the -mm mm-new branch.  Its filename is
     mm-rejig-pageblock-mask-definitions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rejig-pageblock-mask-definitions.patch

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
@@ -2145,15 +2145,15 @@ static bool __move_freepages_block_isola
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

mm-page_alloc-cleanup-flag-vars-in-alloc_pages_bulk_noprof.patch
drm-managed-use-special-gfp_t-format-specifier.patch
mm-kfence-use-special-gfp_t-format-specifier.patch
net-rds-use-special-gfp_t-format-specifier.patch
mm-introduce-for_each_free_list.patch
mm-page_alloc-dont-overload-migratetype-in-find_suitable_fallback.patch
mm-rejig-pageblock-mask-definitions.patch
mm-page_alloc-remove-ifdefs-from-pindex-helpers.patch

