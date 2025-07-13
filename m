Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13214219A9B
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450017; cv=none; b=Ay6JIEyiUn8eEGJ8DmJOmW7W16qUy66Ho9h4MomzGm53XnMvycBm/fuqpC10s6I/IZxWfRBynwipJN4fVrj/holjvm9848/B1ytShYIV7jl0yAa8zJU6m6w3YbUOU63oARe78unMyxLKFTS32Wvqu0/vzN6q5shYpO7Yku2kMtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450017; c=relaxed/simple;
	bh=ox8vppKdrtt7VY/tCtQ2n6RjYf+LB7z4KmH3OMetP50=;
	h=Date:To:From:Subject:Message-Id; b=kP/tzEeNzKZfKB9ICPq6+ieXNUxnnMjWUHnlCxE7+zrHUjwp4DhBtP2lpISfPebFctkXmG1iyFH1rKNZeEbVGVJ9r8GAbtyIYYpgyUvBL+GhpKsMM2q2hFq3tTZB539Q+x9jJ0F7UD3ijnx97BgsOlfNU3CPrCKsAa7MuJ3WeyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tp1pvbsE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tp1pvbsE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB185C4CEE3;
	Sun, 13 Jul 2025 23:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450016;
	bh=ox8vppKdrtt7VY/tCtQ2n6RjYf+LB7z4KmH3OMetP50=;
	h=Date:To:From:Subject:From;
	b=Tp1pvbsE7rrwhCMTZ9As6HP5PUMDOWaQXNGUPuoCyb4KxaKu2Djn38NQSu7J3X+1c
	 cZWzz52lbFhm952a94bY/SX14yaGEgNTiTtNTQZtG7QL75AaXgc4l4tGCG0T8C9ajr
	 E+U0uTIBq8ceuReFOv+TJlqNeK1IWxuRQHG+SijA=
Date: Sun, 13 Jul 2025 16:40:16 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,richardycc@google.com,osalvador@suse.de,mhocko@suse.com,mgorman@techsingularity.net,kirill.shutemov@linux.intel.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_isolation-remove-migratetype-from-undo_isolate_page_range.patch removed from -mm tree
Message-Id: <20250713234016.DB185C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_isolation: remove migratetype from undo_isolate_page_range()
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-remove-migratetype-from-undo_isolate_page_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/page_isolation: remove migratetype from undo_isolate_page_range()
Date: Mon, 16 Jun 2025 22:11:13 -0400

Since migratetype is no longer overwritten during pageblock isolation,
undoing pageblock isolation no longer needs which migratetype to restore.

Link: https://lkml.kernel.org/r/20250617021115.2331563-6-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
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

 include/linux/page-isolation.h |    3 +--
 mm/memory_hotplug.c            |    4 ++--
 mm/page_alloc.c                |    2 +-
 mm/page_isolation.c            |    9 +++------
 4 files changed, 7 insertions(+), 11 deletions(-)

--- a/include/linux/page-isolation.h~mm-page_isolation-remove-migratetype-from-undo_isolate_page_range
+++ a/include/linux/page-isolation.h
@@ -51,8 +51,7 @@ bool pageblock_unisolate_and_move_free_p
 int start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
 			     int migratetype, int flags);
 
-void undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
-			     int migratetype);
+void undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn);
 
 int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn,
 			int isol_flags);
--- a/mm/memory_hotplug.c~mm-page_isolation-remove-migratetype-from-undo_isolate_page_range
+++ a/mm/memory_hotplug.c
@@ -1222,7 +1222,7 @@ int online_pages(unsigned long pfn, unsi
 		build_all_zonelists(NULL);
 
 	/* Basic onlining is complete, allow allocation of onlined pages. */
-	undo_isolate_page_range(pfn, pfn + nr_pages, MIGRATE_MOVABLE);
+	undo_isolate_page_range(pfn, pfn + nr_pages);
 
 	/*
 	 * Freshly onlined pages aren't shuffled (e.g., all pages are placed to
@@ -2086,7 +2086,7 @@ int offline_pages(unsigned long start_pf
 
 failed_removal_isolated:
 	/* pushback to free area */
-	undo_isolate_page_range(start_pfn, end_pfn, MIGRATE_MOVABLE);
+	undo_isolate_page_range(start_pfn, end_pfn);
 	memory_notify(MEM_CANCEL_OFFLINE, &mem_arg);
 	if (node_arg.nid != NUMA_NO_NODE)
 		node_notify(NODE_CANCEL_REMOVING_LAST_MEMORY, &node_arg);
--- a/mm/page_alloc.c~mm-page_isolation-remove-migratetype-from-undo_isolate_page_range
+++ a/mm/page_alloc.c
@@ -6984,7 +6984,7 @@ int alloc_contig_range_noprof(unsigned l
 		     start, end, outer_start, outer_end);
 	}
 done:
-	undo_isolate_page_range(start, end, migratetype);
+	undo_isolate_page_range(start, end);
 	return ret;
 }
 EXPORT_SYMBOL(alloc_contig_range_noprof);
--- a/mm/page_isolation.c~mm-page_isolation-remove-migratetype-from-undo_isolate_page_range
+++ a/mm/page_isolation.c
@@ -515,7 +515,7 @@ int start_isolate_page_range(unsigned lo
 		page = __first_valid_page(pfn, pageblock_nr_pages);
 		if (page && set_migratetype_isolate(page, migratetype, flags,
 					start_pfn, end_pfn)) {
-			undo_isolate_page_range(isolate_start, pfn, migratetype);
+			undo_isolate_page_range(isolate_start, pfn);
 			unset_migratetype_isolate(
 				pfn_to_page(isolate_end - pageblock_nr_pages));
 			return -EBUSY;
@@ -528,13 +528,10 @@ int start_isolate_page_range(unsigned lo
  * undo_isolate_page_range - undo effects of start_isolate_page_range()
  * @start_pfn:		The first PFN of the isolated range
  * @end_pfn:		The last PFN of the isolated range
- * @migratetype:	New migrate type to set on the range
  *
- * This finds every MIGRATE_ISOLATE page block in the given range
- * and switches it to @migratetype.
+ * This finds and unsets every MIGRATE_ISOLATE page block in the given range
  */
-void undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
-			    int migratetype)
+void undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn)
 {
 	unsigned long pfn;
 	struct page *page;
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-fix-split_huge_page_test-for-folio_split-tests.patch
mm-huge_memory-move-unrelated-code-out-of-__split_unmapped_folio.patch
mm-huge_memory-use-folio_expected_ref_count-to-calculate-ref_count.patch

