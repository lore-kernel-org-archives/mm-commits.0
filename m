Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC21224FD
	for <mm-commits@vger.kernel.org>; Wed,  7 May 2025 21:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746653125; cv=none; b=aB/TM37FAVSkd3kmAXQS0X4HI2xAYNJzjwDGea6iiRnjxOzHFdHUEsdtBOarZXYYDBNe5h2FX/InaDDmMeF4d7B4+9sAq/2KoxkSle6/ysHjOFUxjxUFmqy06Rvws4wbrYz2E8jYii9oFXljTEjA6u8dEqDxOqzsaYMY7lQgJUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746653125; c=relaxed/simple;
	bh=O699WO+0o9e1hPxt3ldn05vdMZft2kC3C9ohEqAQSpk=;
	h=Date:To:From:Subject:Message-Id; b=AJI3ZfGXzJhmp+O9tHP6L16vGS9QiVZrryBXsQi+/disgA78huai9w3DkVyzdsVDn4RVVf+GH89GJwWzA3SUkiJo+YjfWioP0L51dX5V3jRBL/Sfduo8b1qesTtlllhwjf7vkNpi9HPQ3prv1YwJ+OTdl4hfGUBgjYFkwfzWpeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ciDhXzAH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ciDhXzAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91164C4CEE2;
	Wed,  7 May 2025 21:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746653124;
	bh=O699WO+0o9e1hPxt3ldn05vdMZft2kC3C9ohEqAQSpk=;
	h=Date:To:From:Subject:From;
	b=ciDhXzAHk0x2IKqACc6J6sdTzspNSjApOP0xr26q1XeaE3MaNu3mU5XK72wmdagz6
	 wtwq+vEB9ksU4N22RU/XAXm4NYl+w2nBDKaNLnGSGepQ4seIL+uCkUoEoUn1M1KgyX
	 94jZU0DCeejd9M2Nx78wgiVG4AcoDYrXF5XPp5uM=
Date: Wed, 07 May 2025 14:25:23 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,richardycc@google.com,osalvador@suse.de,mhocko@suse.com,mgorman@techsingularity.net,kirill.shutemov@linux.intel.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate.patch added to mm-new branch
Message-Id: <20250507212524.91164C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_isolation: remove migratetype from move_freepages_block_isolate()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate.patch

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
Subject: mm/page_isolation: remove migratetype from move_freepages_block_isolate()
Date: Wed, 7 May 2025 17:10:57 -0400

Since migratetype is no longer overwritten during pageblock isolation,
moving pageblocks to and from MIGRATE_ISOLATE no longer needs migratetype.

Add MIGRATETYPE_NO_ISO_MASK to allow read before-isolation migratetype
when a pageblock is isolated.  It is used by
move_freepages_block_isolate().

Add pageblock_isolate_and_move_free_pages() and
pageblock_unisolate_and_move_free_pages() to be explicit about the page
isolation operations.  Both share the common code in
__move_freepages_block_isolate(), which is renamed from
move_freepages_block_isolate().

Link: https://lkml.kernel.org/r/20250507211059.2211628-3-ziy@nvidia.com
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

 include/linux/mmzone.h         |    4 +-
 include/linux/page-isolation.h |    4 +-
 mm/page_alloc.c                |   49 +++++++++++++++++++++++++------
 mm/page_isolation.c            |   21 ++++++-------
 4 files changed, 55 insertions(+), 23 deletions(-)

--- a/include/linux/mmzone.h~mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate
+++ a/include/linux/mmzone.h
@@ -107,8 +107,10 @@ static inline bool migratetype_is_mergea
 extern int page_group_by_mobility_disabled;
 
 #ifdef CONFIG_MEMORY_ISOLATION
-#define MIGRATETYPE_MASK ((BIT(PB_migratetype_bits) - 1) | PB_migrate_isolate_bit)
+#define MIGRATETYPE_NO_ISO_MASK (BIT(PB_migratetype_bits) - 1)
+#define MIGRATETYPE_MASK (MIGRATETYPE_NO_ISO_MASK | PB_migrate_isolate_bit)
 #else
+#define MIGRATETYPE_NO_ISO_MASK MIGRATETYPE_MASK
 #define MIGRATETYPE_MASK (BIT(PB_migratetype_bits) - 1)
 #endif
 
--- a/include/linux/page-isolation.h~mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate
+++ a/include/linux/page-isolation.h
@@ -27,8 +27,8 @@ static inline bool is_migrate_isolate(in
 
 void set_pageblock_migratetype(struct page *page, int migratetype);
 
-bool move_freepages_block_isolate(struct zone *zone, struct page *page,
-				  int migratetype);
+bool pageblock_isolate_and_move_free_pages(struct zone *zone, struct page *page);
+bool pageblock_unisolate_and_move_free_pages(struct zone *zone, struct page *page);
 
 int start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
 			     int migratetype, int flags);
--- a/mm/page_alloc.c~mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate
+++ a/mm/page_alloc.c
@@ -1948,11 +1948,17 @@ static unsigned long find_large_buddy(un
 	return start_pfn;
 }
 
+static inline void toggle_pageblock_isolate(struct page *page, bool isolate)
+{
+	set_pfnblock_flags_mask(page, (isolate << PB_migrate_isolate),
+			page_to_pfn(page), PB_migrate_isolate_bit);
+}
+
 /**
- * move_freepages_block_isolate - move free pages in block for page isolation
+ * __move_freepages_block_isolate - move free pages in block for page isolation
  * @zone: the zone
  * @page: the pageblock page
- * @migratetype: migratetype to set on the pageblock
+ * @isolate: to isolate the given pageblock or unisolate it
  *
  * This is similar to move_freepages_block(), but handles the special
  * case encountered in page isolation, where the block of interest
@@ -1967,10 +1973,15 @@ static unsigned long find_large_buddy(un
  *
  * Returns %true if pages could be moved, %false otherwise.
  */
-bool move_freepages_block_isolate(struct zone *zone, struct page *page,
-				  int migratetype)
+static bool __move_freepages_block_isolate(struct zone *zone,
+		struct page *page, bool isolate)
 {
 	unsigned long start_pfn, pfn;
+	int from_mt;
+	int to_mt;
+
+	if (isolate == get_pageblock_isolate(page))
+		return false;
 
 	if (!prep_move_freepages_block(zone, page, &start_pfn, NULL, NULL))
 		return false;
@@ -1987,7 +1998,7 @@ bool move_freepages_block_isolate(struct
 
 		del_page_from_free_list(buddy, zone, order,
 					get_pfnblock_migratetype(buddy, pfn));
-		set_pageblock_migratetype(page, migratetype);
+		toggle_pageblock_isolate(page, isolate);
 		split_large_buddy(zone, buddy, pfn, order, FPI_NONE);
 		return true;
 	}
@@ -1998,16 +2009,36 @@ bool move_freepages_block_isolate(struct
 
 		del_page_from_free_list(page, zone, order,
 					get_pfnblock_migratetype(page, pfn));
-		set_pageblock_migratetype(page, migratetype);
+		toggle_pageblock_isolate(page, isolate);
 		split_large_buddy(zone, page, pfn, order, FPI_NONE);
 		return true;
 	}
 move:
-	__move_freepages_block(zone, start_pfn,
-			       get_pfnblock_migratetype(page, start_pfn),
-			       migratetype);
+	/* use MIGRATETYPE_NO_ISO_MASK to get the non-isolate migratetype */
+	if (isolate) {
+		from_mt = get_pfnblock_flags_mask(page, page_to_pfn(page),
+				MIGRATETYPE_NO_ISO_MASK);
+		to_mt = MIGRATE_ISOLATE;
+	} else {
+		from_mt = MIGRATE_ISOLATE;
+		to_mt = get_pfnblock_flags_mask(page, page_to_pfn(page),
+				MIGRATETYPE_NO_ISO_MASK);
+	}
+
+	__move_freepages_block(zone, start_pfn, from_mt, to_mt);
 	return true;
 }
+
+bool pageblock_isolate_and_move_free_pages(struct zone *zone, struct page *page)
+{
+	return __move_freepages_block_isolate(zone, page, true);
+}
+
+bool pageblock_unisolate_and_move_free_pages(struct zone *zone, struct page *page)
+{
+	return __move_freepages_block_isolate(zone, page, false);
+}
+
 #endif /* CONFIG_MEMORY_ISOLATION */
 
 static void change_pageblock_range(struct page *pageblock_page,
--- a/mm/page_isolation.c~mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate
+++ a/mm/page_isolation.c
@@ -188,7 +188,7 @@ static int set_migratetype_isolate(struc
 	unmovable = has_unmovable_pages(check_unmovable_start, check_unmovable_end,
 			migratetype, isol_flags);
 	if (!unmovable) {
-		if (!move_freepages_block_isolate(zone, page, MIGRATE_ISOLATE)) {
+		if (!pageblock_isolate_and_move_free_pages(zone, page)) {
 			spin_unlock_irqrestore(&zone->lock, flags);
 			return -EBUSY;
 		}
@@ -209,7 +209,7 @@ static int set_migratetype_isolate(struc
 	return -EBUSY;
 }
 
-static void unset_migratetype_isolate(struct page *page, int migratetype)
+static void unset_migratetype_isolate(struct page *page)
 {
 	struct zone *zone;
 	unsigned long flags;
@@ -262,10 +262,10 @@ static void unset_migratetype_isolate(st
 		 * Isolating this block already succeeded, so this
 		 * should not fail on zone boundaries.
 		 */
-		WARN_ON_ONCE(!move_freepages_block_isolate(zone, page, migratetype));
+		WARN_ON_ONCE(!pageblock_unisolate_and_move_free_pages(zone, page));
 	} else {
-		set_pageblock_migratetype(page, migratetype);
-		__putback_isolated_page(page, order, migratetype);
+		clear_pageblock_isolate(page);
+		__putback_isolated_page(page, order, get_pageblock_migratetype(page));
 	}
 	zone->nr_isolate_pageblock--;
 out:
@@ -383,7 +383,7 @@ static int isolate_single_pageblock(unsi
 		if (PageBuddy(page)) {
 			int order = buddy_order(page);
 
-			/* move_freepages_block_isolate() handled this */
+			/* pageblock_isolate_and_move_free_pages() handled this */
 			VM_WARN_ON_ONCE(pfn + (1 << order) > boundary_pfn);
 
 			pfn += 1UL << order;
@@ -433,7 +433,7 @@ static int isolate_single_pageblock(unsi
 failed:
 	/* restore the original migratetype */
 	if (!skip_isolation)
-		unset_migratetype_isolate(pfn_to_page(isolate_pageblock), migratetype);
+		unset_migratetype_isolate(pfn_to_page(isolate_pageblock));
 	return -EBUSY;
 }
 
@@ -504,7 +504,7 @@ int start_isolate_page_range(unsigned lo
 	ret = isolate_single_pageblock(isolate_end, flags, true,
 			skip_isolation, migratetype);
 	if (ret) {
-		unset_migratetype_isolate(pfn_to_page(isolate_start), migratetype);
+		unset_migratetype_isolate(pfn_to_page(isolate_start));
 		return ret;
 	}
 
@@ -517,8 +517,7 @@ int start_isolate_page_range(unsigned lo
 					start_pfn, end_pfn)) {
 			undo_isolate_page_range(isolate_start, pfn, migratetype);
 			unset_migratetype_isolate(
-				pfn_to_page(isolate_end - pageblock_nr_pages),
-				migratetype);
+				pfn_to_page(isolate_end - pageblock_nr_pages));
 			return -EBUSY;
 		}
 	}
@@ -548,7 +547,7 @@ void undo_isolate_page_range(unsigned lo
 		page = __first_valid_page(pfn, pageblock_nr_pages);
 		if (!page || !is_migrate_isolate_page(page))
 			continue;
-		unset_migratetype_isolate(page, migratetype);
+		unset_migratetype_isolate(page);
 	}
 }
 /*
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_isolation-make-page-isolation-a-standalone-bit.patch
mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate.patch
mm-page_isolation-remove-migratetype-from-undo_isolate_page_range.patch
mm-page_isolation-remove-migratetype-parameter-from-more-functions.patch

