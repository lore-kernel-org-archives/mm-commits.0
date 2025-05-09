Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41768469D
	for <mm-commits@vger.kernel.org>; Fri,  9 May 2025 22:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746829058; cv=none; b=l8TB6/Lp1881G4cjm9iGSMKakGQgC3rwiRXwTD7bKv2jci1AhsF4b4DCLme2ifExTHbdybXG2e3au5Injx1ap9kha9ol2qQP5FdBNK+MTneSbZ3C+FT0BIZ0tZgwCUKIfCFUXDJJqeBwrNoI+TLYFZaPbA4lLOKR81RvJCwzdt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746829058; c=relaxed/simple;
	bh=OMvca+HQYW1aqQ8hGKfd6jSAx8nv6hBMGAQqddig970=;
	h=Date:To:From:Subject:Message-Id; b=TYCHRvsytJt0f41zag3QtOo8etYC2+mWPzvBc0t5z709HCfCxe+2tkLprJRuI6940ZPNC6wLIx1P91X9QEtM8vopzcevb1cGD+OI4YuUoRr/EhTv3vr5oc226C4EQ4P5HuhOZPgMG/oAOgCyaPVaoBi/LSSQ4A8/nJB643eqw+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M+XdUh7v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M+XdUh7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B1BC4CEE4;
	Fri,  9 May 2025 22:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746829058;
	bh=OMvca+HQYW1aqQ8hGKfd6jSAx8nv6hBMGAQqddig970=;
	h=Date:To:From:Subject:From;
	b=M+XdUh7vt/4l9HScopJC5T/FZhoKjW8xtuDjEGA9Viw6f8yanauW7wA37oALX/iqi
	 4C8h9BJ20xO+FQYne3vnzMJFhNCj/k6YtTtBBbW1HdZswWTi9Y9odmtzVngaOgmy/R
	 fs2ERsaCu9sHNHkEz5RHytuZkb/i1josabPOJ024=
Date: Fri, 09 May 2025 15:17:37 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,richardycc@google.com,osalvador@suse.de,mhocko@suse.com,mgorman@techsingularity.net,kirill.shutemov@linux.intel.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-make-page-isolation-a-standalone-bit.patch added to mm-new branch
Message-Id: <20250509221737.E4B1BC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_isolation: make page isolation a standalone bit.
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
Subject: mm/page_isolation: make page isolation a standalone bit.
Date: Fri, 9 May 2025 16:01:08 -0400

Patch series "Make MIGRATE_ISOLATE a standalone bit", v4.

This patchset moves MIGRATE_ISOLATE to a standalone bit to avoid being
overwritten during pageblock isolation process.  Currently,
MIGRATE_ISOLATE is part of enum migratetype (in include/linux/mmzone.h),
thus, setting a pageblock to MIGRATE_ISOLATE overwrites its original
migratetype.  This causes pageblock migratetype loss during
alloc_contig_range() and memory offline, especially when the process fails
due to a failed pageblock isolation and the code tries to undo the
finished pageblock isolations.

In terms of performance for changing pageblock types, no performance
change is observed:

1. I used perf to collect stats of offlining and onlining all memory
   of a 40GB VM 10 times and see that get_pfnblock_flags_mask() and
   set_pfnblock_flags_mask() take about 0.12% and 0.02% of the whole
   process respectively with and without this patchset across 3 runs.

2. I used perf to collect stats of dd from /dev/random to a 40GB tmpfs
   file and find get_pfnblock_flags_mask() takes about 0.05% of the
   process with and without this patchset across 3 runs.


Design
======

Pageblock flags are read in words to achieve good performance and existing
pageblock flags take 4 bits per pageblock.  To avoid a substantial change
to the pageblock flag code, pageblock flag bits are expanded to use 8 and
MIGRATE_ISOLATE is moved to use the last bit (bit 7).

It might look like the pageblock flags have doubled the overhead, but in
reality, the overhead is only 1 byte per 2MB/4MB (based on pageblock
config), or 0.0000476 %.


This patch (of 4):

During page isolation, the original migratetype is overwritten, since
MIGRATE_* are enums and stored in pageblock bitmaps.  Change
MIGRATE_ISOLATE to be stored a standalone bit, PB_migrate_isolate, like
PB_migrate_skip, so that migratetype is not lost during pageblock
isolation.  pageblock bits needs to be word aligned, so expand the number
of pageblock bits from 4 to 8 and make PB_migrate_isolate bit 7.

Link: https://lkml.kernel.org/r/20250509200111.3372279-1-ziy@nvidia.com
Link: https://lkml.kernel.org/r/20250509200111.3372279-2-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Richard Chang <richardycc@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h          |   15 +++++++-----
 include/linux/pageblock-flags.h |    9 ++++++-
 mm/page_alloc.c                 |   36 +++++++++++++++++++++++++++++-
 mm/page_isolation.c             |   11 +++++++++
 4 files changed, 63 insertions(+), 8 deletions(-)

--- a/include/linux/mmzone.h~mm-page_isolation-make-page-isolation-a-standalone-bit
+++ a/include/linux/mmzone.h
@@ -106,14 +106,17 @@ static inline bool migratetype_is_mergea
 
 extern int page_group_by_mobility_disabled;
 
-#define MIGRATETYPE_MASK ((1UL << PB_migratetype_bits) - 1)
+#ifdef CONFIG_MEMORY_ISOLATION
+#define MIGRATETYPE_MASK ((BIT(PB_migratetype_bits) - 1) | PB_migrate_isolate_bit)
+#else
+#define MIGRATETYPE_MASK (BIT(PB_migratetype_bits) - 1)
+#endif
 
-#define get_pageblock_migratetype(page)					\
-	get_pfnblock_flags_mask(page, page_to_pfn(page), MIGRATETYPE_MASK)
+unsigned long get_pageblock_migratetype(const struct page *page);
+
+#define folio_migratetype(folio)					\
+	get_pageblock_migratetype(&folio->page)
 
-#define folio_migratetype(folio)				\
-	get_pfnblock_flags_mask(&folio->page, folio_pfn(folio),		\
-			MIGRATETYPE_MASK)
 struct free_area {
 	struct list_head	free_list[MIGRATE_TYPES];
 	unsigned long		nr_free;
--- a/include/linux/pageblock-flags.h~mm-page_isolation-make-page-isolation-a-standalone-bit
+++ a/include/linux/pageblock-flags.h
@@ -20,7 +20,10 @@ enum pageblock_bits {
 	PB_migrate_end = PB_migrate + PB_migratetype_bits - 1,
 			/* 3 bits required for migrate types */
 	PB_migrate_skip,/* If set the block is skipped by compaction */
-
+#ifdef CONFIG_MEMORY_ISOLATION
+	PB_migrate_isolate = 7, /* If set the block is isolated */
+			/* set it to 7 to make pageblock bit word aligned */
+#endif
 	/*
 	 * Assume the bits will always align on a word. If this assumption
 	 * changes then get/set pageblock needs updating.
@@ -28,6 +31,10 @@ enum pageblock_bits {
 	NR_PAGEBLOCK_BITS
 };
 
+#ifdef CONFIG_MEMORY_ISOLATION
+#define PB_migrate_isolate_bit BIT(PB_migrate_isolate)
+#endif
+
 #if defined(CONFIG_HUGETLB_PAGE)
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
--- a/mm/page_alloc.c~mm-page_isolation-make-page-isolation-a-standalone-bit
+++ a/mm/page_alloc.c
@@ -381,10 +381,31 @@ unsigned long get_pfnblock_flags_mask(co
 	return (word >> bitidx) & mask;
 }
 
+unsigned long get_pageblock_migratetype(const struct page *page)
+{
+	unsigned long flags;
+
+	flags = get_pfnblock_flags_mask(page, page_to_pfn(page),
+			MIGRATETYPE_MASK);
+#ifdef CONFIG_MEMORY_ISOLATION
+	if (flags & PB_migrate_isolate_bit)
+		return MIGRATE_ISOLATE;
+#endif
+	return flags;
+}
+
 static __always_inline int get_pfnblock_migratetype(const struct page *page,
 					unsigned long pfn)
 {
-	return get_pfnblock_flags_mask(page, pfn, MIGRATETYPE_MASK);
+	unsigned long flags;
+
+	flags = get_pfnblock_flags_mask(page, pfn,
+			MIGRATETYPE_MASK);
+#ifdef CONFIG_MEMORY_ISOLATION
+	if (flags & PB_migrate_isolate_bit)
+		return MIGRATE_ISOLATE;
+#endif
+	return flags;
 }
 
 /**
@@ -402,8 +423,14 @@ void set_pfnblock_flags_mask(struct page
 	unsigned long bitidx, word_bitidx;
 	unsigned long word;
 
+#ifdef CONFIG_MEMORY_ISOLATION
+	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 8);
+	/* extra one for MIGRATE_ISOLATE */
+	BUILD_BUG_ON(MIGRATE_TYPES > (1 << PB_migratetype_bits) + 1);
+#else
 	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
 	BUILD_BUG_ON(MIGRATE_TYPES > (1 << PB_migratetype_bits));
+#endif
 
 	bitmap = get_pageblock_bitmap(page, pfn);
 	bitidx = pfn_to_bitidx(page, pfn);
@@ -426,6 +453,13 @@ void set_pageblock_migratetype(struct pa
 		     migratetype < MIGRATE_PCPTYPES))
 		migratetype = MIGRATE_UNMOVABLE;
 
+#ifdef CONFIG_MEMORY_ISOLATION
+	if (migratetype == MIGRATE_ISOLATE) {
+		set_pfnblock_flags_mask(page, PB_migrate_isolate_bit,
+				page_to_pfn(page), PB_migrate_isolate_bit);
+		return;
+	}
+#endif
 	set_pfnblock_flags_mask(page, (unsigned long)migratetype,
 				page_to_pfn(page), MIGRATETYPE_MASK);
 }
--- a/mm/page_isolation.c~mm-page_isolation-make-page-isolation-a-standalone-bit
+++ a/mm/page_isolation.c
@@ -15,6 +15,17 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/page_isolation.h>
 
+static inline bool __maybe_unused get_pageblock_isolate(struct page *page)
+{
+	return get_pfnblock_flags_mask(page, page_to_pfn(page),
+			PB_migrate_isolate_bit);
+}
+static inline void clear_pageblock_isolate(struct page *page)
+{
+	set_pfnblock_flags_mask(page, 0, page_to_pfn(page),
+			PB_migrate_isolate_bit);
+}
+
 /*
  * This function checks whether the range [start_pfn, end_pfn) includes
  * unmovable pages or not. The range must fall into a single pageblock and
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_isolation-make-page-isolation-a-standalone-bit.patch
mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate.patch
mm-page_isolation-remove-migratetype-from-undo_isolate_page_range.patch
mm-page_isolation-remove-migratetype-parameter-from-more-functions.patch

