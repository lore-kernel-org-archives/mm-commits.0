Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD2113AA2F
	for <mm-commits@vger.kernel.org>; Tue, 17 Jun 2025 02:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750126805; cv=none; b=TV0L9SmLN3OW4iF6/u6Ba9Vyxeo20mIlD7KxZgLLxinIsblK8hVNyNTNuvkh7ypgtNTtLoocDK0vhGD/sVUBJSvY4UNiluxL+9QoYumbcNm1Z+kMewC+5cDlR++e3htnR4/+Hn7/MspxApcEvwSNJryvm0CEYl3aMFYbc/5sRSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750126805; c=relaxed/simple;
	bh=OTdf03lPgm1+rvurR9d2KLl+fN4MFi+/X7hLazjQXLA=;
	h=Date:To:From:Subject:Message-Id; b=PMeP5uDEu0+5EZM9gk8zN6jX0oC363eZ/5EBPrIhRk/VqjfaBXEx2WeWRIf0PVBNolBTUMUDTulA4bvI14J+sJmT5rqkUFKfSxVw71XbdhdHGZUlXRGoQVwxpBQtk6k+ZARJaIZMMCPBcJ2c/H6+HxWfvQf+dSFi6wBCpZYtkEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SJWp7n4z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SJWp7n4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76A6C4CEEA;
	Tue, 17 Jun 2025 02:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750126804;
	bh=OTdf03lPgm1+rvurR9d2KLl+fN4MFi+/X7hLazjQXLA=;
	h=Date:To:From:Subject:From;
	b=SJWp7n4zS4RYJaKR/ZCpz8izdTtZS5Lglwo1qtcbaRD90b6jkxkPIN0TsG4OQ334C
	 z4mY+QoiKCvndk/QKaMk25VPAQrpDZjmD9VZIBjm1etPltSMS1fG8AokLgX1zA22Xm
	 fG5JKjd7xJmKJ59VRtduCugMKpWyEDpbDQgxq/RU=
Date: Mon, 16 Jun 2025 19:20:04 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,richardycc@google.com,osalvador@suse.de,mhocko@suse.com,mgorman@techsingularity.net,kirill.shutemov@linux.intel.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-make-page-isolation-a-standalone-bit.patch added to mm-new branch
Message-Id: <20250617022004.A76A6C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_isolation: make page isolation a standalone bit
has been added to the -mm mm-new branch.  Its filename is
     mm-page_isolation-make-page-isolation-a-standalone-bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_isolation-make-page-isolation-a-standalone-bit.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/page_isolation: make page isolation a standalone bit
Date: Mon, 16 Jun 2025 22:11:10 -0400

During page isolation, the original migratetype is overwritten, since
MIGRATE_* are enums and stored in pageblock bitmaps.  Change
MIGRATE_ISOLATE to be stored a standalone bit, PB_migrate_isolate, like
PB_compact_skip, so that migratetype is not lost during pageblock
isolation.

Link: https://lkml.kernel.org/r/20250617021115.2331563-3-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Richard Chang <richardycc@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h          |    3 +++
 include/linux/page-isolation.h  |   16 ++++++++++++++++
 include/linux/pageblock-flags.h |   14 ++++++++++++++
 mm/page_alloc.c                 |   27 ++++++++++++++++++++++++---
 4 files changed, 57 insertions(+), 3 deletions(-)

--- a/include/linux/mmzone.h~mm-page_isolation-make-page-isolation-a-standalone-bit
+++ a/include/linux/mmzone.h
@@ -79,6 +79,9 @@ enum migratetype {
 	 * __free_pageblock_cma() function.
 	 */
 	MIGRATE_CMA,
+	__MIGRATE_TYPE_END = MIGRATE_CMA,
+#else
+	__MIGRATE_TYPE_END = MIGRATE_HIGHATOMIC,
 #endif
 #ifdef CONFIG_MEMORY_ISOLATION
 	MIGRATE_ISOLATE,	/* can't allocate from here */
--- a/include/linux/pageblock-flags.h~mm-page_isolation-make-page-isolation-a-standalone-bit
+++ a/include/linux/pageblock-flags.h
@@ -21,6 +21,13 @@ enum pageblock_bits {
 			/* 3 bits required for migrate types */
 	PB_compact_skip,/* If set the block is skipped by compaction */
 
+#ifdef CONFIG_MEMORY_ISOLATION
+	/*
+	 * Pageblock isolation is represented with a separate bit, so that
+	 * the migratetype of a block is not overwritten by isolation.
+	 */
+	PB_migrate_isolate, /* If set the block is isolated */
+#endif
 	/*
 	 * Assume the bits will always align on a word. If this assumption
 	 * changes then get/set pageblock needs updating.
@@ -32,6 +39,13 @@ enum pageblock_bits {
 
 #define MIGRATETYPE_MASK ((1UL << (PB_migrate_end + 1)) - 1)
 
+#ifdef CONFIG_MEMORY_ISOLATION
+#define MIGRATETYPE_AND_ISO_MASK \
+	(((1UL << (PB_migrate_end + 1)) - 1) | BIT(PB_migrate_isolate))
+#else
+#define MIGRATETYPE_AND_ISO_MASK MIGRATETYPE_MASK
+#endif
+
 #if defined(CONFIG_HUGETLB_PAGE)
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
--- a/include/linux/page-isolation.h~mm-page_isolation-make-page-isolation-a-standalone-bit
+++ a/include/linux/page-isolation.h
@@ -11,6 +11,12 @@ static inline bool is_migrate_isolate(in
 {
 	return migratetype == MIGRATE_ISOLATE;
 }
+#define get_pageblock_isolate(page) \
+	get_pfnblock_bit(page, page_to_pfn(page), PB_migrate_isolate)
+#define clear_pageblock_isolate(page) \
+	clear_pfnblock_bit(page, page_to_pfn(page), PB_migrate_isolate)
+#define set_pageblock_isolate(page) \
+	set_pfnblock_bit(page, page_to_pfn(page), PB_migrate_isolate)
 #else
 static inline bool is_migrate_isolate_page(struct page *page)
 {
@@ -20,6 +26,16 @@ static inline bool is_migrate_isolate(in
 {
 	return false;
 }
+static inline bool get_pageblock_isolate(struct page *page)
+{
+	return false;
+}
+static inline void clear_pageblock_isolate(struct page *page)
+{
+}
+static inline void set_pageblock_isolate(struct page *page)
+{
+}
 #endif
 
 #define MEMORY_OFFLINE	0x1
--- a/mm/page_alloc.c~mm-page_isolation-make-page-isolation-a-standalone-bit
+++ a/mm/page_alloc.c
@@ -365,8 +365,12 @@ get_pfnblock_bitmap_bitidx(const struct
 	unsigned long *bitmap;
 	unsigned long word_bitidx;
 
+#ifdef CONFIG_MEMORY_ISOLATION
+	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 8);
+#else
 	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
-	BUILD_BUG_ON(MIGRATE_TYPES > (1 << PB_migratetype_bits));
+#endif
+	BUILD_BUG_ON(__MIGRATE_TYPE_END >= (1 << PB_migratetype_bits));
 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
 
 	bitmap = get_pageblock_bitmap(page, pfn);
@@ -439,7 +443,16 @@ bool get_pfnblock_bit(const struct page
 __always_inline enum migratetype
 get_pfnblock_migratetype(const struct page *page, unsigned long pfn)
 {
-	return __get_pfnblock_flags_mask(page, pfn, MIGRATETYPE_MASK);
+	unsigned long mask = MIGRATETYPE_AND_ISO_MASK;
+	unsigned long flags;
+
+	flags = __get_pfnblock_flags_mask(page, pfn, mask);
+
+#ifdef CONFIG_MEMORY_ISOLATION
+	if (flags & BIT(PB_migrate_isolate))
+		return MIGRATE_ISOLATE;
+#endif
+	return flags & MIGRATETYPE_MASK;
 }
 
 /**
@@ -519,8 +532,16 @@ __always_inline void set_pageblock_migra
 		     migratetype < MIGRATE_PCPTYPES))
 		migratetype = MIGRATE_UNMOVABLE;
 
+#ifdef CONFIG_MEMORY_ISOLATION
+	if (migratetype == MIGRATE_ISOLATE) {
+		set_pfnblock_bit(page, page_to_pfn(page), PB_migrate_isolate);
+		return;
+	}
+	/* MIGRATETYPE_AND_ISO_MASK clears PB_migrate_isolate if it is set */
+#endif
 	__set_pfnblock_flags_mask(page, page_to_pfn(page),
-				  (unsigned long)migratetype, MIGRATETYPE_MASK);
+				  (unsigned long)migratetype,
+				  MIGRATETYPE_AND_ISO_MASK);
 }
 
 #ifdef CONFIG_DEBUG_VM
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-rename-config_page_block_order-to-config_page_block_max_order.patch
mm-page_alloc-pageblock-flags-functions-clean-up.patch
mm-page_isolation-make-page-isolation-a-standalone-bit.patch
mm-page_alloc-add-support-for-initializing-pageblock-as-isolated.patch
mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate.patch
mm-page_isolation-remove-migratetype-from-undo_isolate_page_range.patch
mm-page_isolation-remove-migratetype-parameter-from-more-functions.patch

