Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A17221545
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 23:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746745615; cv=none; b=prr0VGmYi0vR1Bq23D1OGfdcPMgFqvG1GJYNZ76CNLoYjGy6obKymA+7JTAjehgf/3lPed4V1X64/qts3NpFyvl/SklOarY7nhJajbPdGbcviCp1YMs6IMgdwDnFjmFxPbb5w4fqvfuas6OElIHMV9hdw4G9aMmPraR4cuw1OpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746745615; c=relaxed/simple;
	bh=F97MHTqMef77PvCexsuHuszDNORQrpvkJ+KtSNov7XM=;
	h=Date:To:From:Subject:Message-Id; b=AQunny6mcWLIyWrg5hh4ITLS9HutZPWbcpeMQpO5dAXAsYKK/uMCLmId9KlPM4FpMzbqwrtLZz0YWkrNPZkyrZvA2gRHMa1AlKBG3yr/jYYxtBUbDw88U4vfIMVF8batXJXZjHbYxBBGZu3Qv1usGWyLTrv4O7WWHby9ZEPOoqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WnV+9aLe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WnV+9aLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25FFCC4CEE7;
	Thu,  8 May 2025 23:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746745615;
	bh=F97MHTqMef77PvCexsuHuszDNORQrpvkJ+KtSNov7XM=;
	h=Date:To:From:Subject:From;
	b=WnV+9aLe1/bnPohcxbaQZrgD+92x0+TLzEWfNYbsf401bbStbQuvD7Mlj1MitZr3v
	 CYm/PR4bfgnMTDS7QxQBhltnxeKaNy1Nao68db8vkUFlzGi2/Jo5iT2N1XqVqblcJ9
	 Vf40PCWj1evFNCExgjlnTq5ob6gyxFXKsv+fEquE=
Date: Thu, 08 May 2025 16:06:54 -0700
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-make-page-isolation-a-standalone-bit-fix.patch added to mm-new branch
Message-Id: <20250508230655.25FFCC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_isolation-make-page-isolation-a-standalone-bit-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-page_isolation-make-page-isolation-a-standalone-bit-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_isolation-make-page-isolation-a-standalone-bit-fix.patch

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
Subject: mm-page_isolation-make-page-isolation-a-standalone-bit-fix
Date: Thu, 8 May 2025 12:05:59 -0400

address Johannes comments

1. keep the original is_migrate_isolate_page()
2. move {get,set,clear}_pageblock_isolate() to mm/page_isolation.c
3. use a single version for get_pageblock_migratetype() and
   get_pfnblock_migratetype().

Link: https://lkml.kernel.org/r/50BB00FF-746E-4623-8F48-F74209EDBD0A@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h          |    6 ------
 include/linux/page-isolation.h  |    2 +-
 include/linux/pageblock-flags.h |   24 ------------------------
 mm/page_alloc.c                 |   25 ++++++++++---------------
 mm/page_isolation.c             |   17 +++++++++++++++++
 5 files changed, 28 insertions(+), 46 deletions(-)

--- a/include/linux/mmzone.h~mm-page_isolation-make-page-isolation-a-standalone-bit-fix
+++ a/include/linux/mmzone.h
@@ -112,13 +112,7 @@ extern int page_group_by_mobility_disabl
 #define MIGRATETYPE_MASK (BIT(PB_migratetype_bits) - 1)
 #endif
 
-#ifdef CONFIG_MEMORY_ISOLATION
 unsigned long get_pageblock_migratetype(const struct page *page);
-#else
-#define get_pageblock_migratetype(page)					\
-	get_pfnblock_flags_mask(page, page_to_pfn(page), MIGRATETYPE_MASK)
-
-#endif
 
 #define folio_migratetype(folio)					\
 	get_pageblock_migratetype(&folio->page)
--- a/include/linux/pageblock-flags.h~mm-page_isolation-make-page-isolation-a-standalone-bit-fix
+++ a/include/linux/pageblock-flags.h
@@ -112,28 +112,4 @@ static inline void set_pageblock_skip(st
 }
 #endif /* CONFIG_COMPACTION */
 
-#ifdef CONFIG_MEMORY_ISOLATION
-#define get_pageblock_isolate(page) \
-	get_pfnblock_flags_mask(page, page_to_pfn(page),	\
-			PB_migrate_isolate_bit)
-#define clear_pageblock_isolate(page) \
-	set_pfnblock_flags_mask(page, 0, page_to_pfn(page),	\
-			PB_migrate_isolate_bit)
-#define set_pageblock_isolate(page) \
-	set_pfnblock_flags_mask(page, PB_migrate_isolate_bit,	\
-			page_to_pfn(page),			\
-			PB_migrate_isolate_bit)
-#else
-static inline bool get_pageblock_isolate(struct page *page)
-{
-	return false;
-}
-static inline void clear_pageblock_isolate(struct page *page)
-{
-}
-static inline void set_pageblock_isolate(struct page *page)
-{
-}
-#endif /* CONFIG_MEMORY_ISOLATION */
-
 #endif	/* PAGEBLOCK_FLAGS_H */
--- a/include/linux/page-isolation.h~mm-page_isolation-make-page-isolation-a-standalone-bit-fix
+++ a/include/linux/page-isolation.h
@@ -5,7 +5,7 @@
 #ifdef CONFIG_MEMORY_ISOLATION
 static inline bool is_migrate_isolate_page(struct page *page)
 {
-	return get_pageblock_isolate(page);
+	return get_pageblock_migratetype(page) == MIGRATE_ISOLATE;
 }
 static inline bool is_migrate_isolate(int migratetype)
 {
--- a/mm/page_alloc.c~mm-page_isolation-make-page-isolation-a-standalone-bit-fix
+++ a/mm/page_alloc.c
@@ -381,16 +381,16 @@ unsigned long get_pfnblock_flags_mask(co
 	return (word >> bitidx) & mask;
 }
 
-#ifdef CONFIG_MEMORY_ISOLATION
 unsigned long get_pageblock_migratetype(const struct page *page)
 {
 	unsigned long flags;
 
 	flags = get_pfnblock_flags_mask(page, page_to_pfn(page),
 			MIGRATETYPE_MASK);
+#ifdef CONFIG_MEMORY_ISOLATION
 	if (flags & PB_migrate_isolate_bit)
 		return MIGRATE_ISOLATE;
-
+#endif
 	return flags;
 }
 
@@ -401,19 +401,12 @@ static __always_inline int get_pfnblock_
 
 	flags = get_pfnblock_flags_mask(page, pfn,
 			MIGRATETYPE_MASK);
+#ifdef CONFIG_MEMORY_ISOLATION
 	if (flags & PB_migrate_isolate_bit)
 		return MIGRATE_ISOLATE;
-
+#endif
 	return flags;
 }
-#else
-static __always_inline int get_pfnblock_migratetype(const struct page *page,
-					unsigned long pfn)
-{
-	return get_pfnblock_flags_mask(page, pfn, MIGRATETYPE_MASK);
-}
-
-#endif
 
 /**
  * set_pfnblock_flags_mask - Set the requested group of flags for a pageblock_nr_pages block of pages
@@ -461,11 +454,13 @@ void set_pageblock_migratetype(struct pa
 		migratetype = MIGRATE_UNMOVABLE;
 
 #ifdef CONFIG_MEMORY_ISOLATION
-	if (migratetype == MIGRATE_ISOLATE)
-		set_pageblock_isolate(page);
-	else
+	if (migratetype == MIGRATE_ISOLATE) {
+		set_pfnblock_flags_mask(page, PB_migrate_isolate_bit,
+				page_to_pfn(page), PB_migrate_isolate_bit);
+		return;
+	}
 #endif
-		set_pfnblock_flags_mask(page, (unsigned long)migratetype,
+	set_pfnblock_flags_mask(page, (unsigned long)migratetype,
 				page_to_pfn(page), MIGRATETYPE_MASK);
 }
 
--- a/mm/page_isolation.c~mm-page_isolation-make-page-isolation-a-standalone-bit-fix
+++ a/mm/page_isolation.c
@@ -15,6 +15,23 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/page_isolation.h>
 
+static inline bool get_pageblock_isolate(struct page *page)
+{
+	return get_pfnblock_flags_mask(page, page_to_pfn(page),
+			PB_migrate_isolate_bit);
+}
+static inline void clear_pageblock_isolate(struct page *page)
+{
+	set_pfnblock_flags_mask(page, 0, page_to_pfn(page),
+			PB_migrate_isolate_bit);
+}
+static inline void set_pageblock_isolate(struct page *page)
+{
+	set_pfnblock_flags_mask(page, PB_migrate_isolate_bit,
+			page_to_pfn(page),
+			PB_migrate_isolate_bit);
+}
+
 /*
  * This function checks whether the range [start_pfn, end_pfn) includes
  * unmovable pages or not. The range must fall into a single pageblock and
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_isolation-make-page-isolation-a-standalone-bit.patch
mm-page_isolation-make-page-isolation-a-standalone-bit-fix.patch
mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate.patch
mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate-fix.patch
mm-page_isolation-remove-migratetype-from-undo_isolate_page_range.patch
mm-page_isolation-remove-migratetype-parameter-from-more-functions.patch
mm-page_isolation-remove-migratetype-parameter-from-more-functions-fix.patch

