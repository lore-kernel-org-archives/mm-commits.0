Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF211224FD
	for <mm-commits@vger.kernel.org>; Wed,  7 May 2025 21:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746653126; cv=none; b=XLFdGVK2bNyzKZC9mymjanG0zP4HM3rxrM3YLNsMuzcDy5t1l4Xxqy2ZQy8H2kwfTXY1KHiKwp03GRU6DR3JNR50YEfuQf55isakieWlHlCybye6YZ33TGgukGJmKjaf26e1RBS1P47/OAZ8D01TD+ub+yiv+fpDiQNn5IIn2sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746653126; c=relaxed/simple;
	bh=WziHCmAkzgRUGkbVjOm6RcnGetja2bSwQ38sELoWu6s=;
	h=Date:To:From:Subject:Message-Id; b=tSwc8QGzGe9a6ruK5FUJvRoJHH04K40AXbXDM8+Iwb5FUY0JrBCcHNfV+krxfuL4OWq81h7A87FEtCMSpxeVFhdc2xNhDRI8EdbNFujeDLAg7AZyAXllPdL9qDEMOLNPuWXWI/ayoeiR4q2c53qISEfAdDW54/1Fh8kAgOQbiVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CkSXliX4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CkSXliX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A59C4CEE2;
	Wed,  7 May 2025 21:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746653126;
	bh=WziHCmAkzgRUGkbVjOm6RcnGetja2bSwQ38sELoWu6s=;
	h=Date:To:From:Subject:From;
	b=CkSXliX4PQHn7VjGVKLtgMjZrY7hUDE9EmRGbJjpj3fZ5JQzntiJDXpgq3scd84/g
	 SANlgxrMN9aFyS1XUs76JI4FaS2+1KVZKLV/fMNjtffAs54OrJfoFD0xr15Wz0DbtY
	 /EXvzGOvJ6beHL5AzBDH8ruYHj3tc8eTicWx/cY8=
Date: Wed, 07 May 2025 14:25:25 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,richardycc@google.com,osalvador@suse.de,mhocko@suse.com,mgorman@techsingularity.net,kirill.shutemov@linux.intel.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-remove-migratetype-from-undo_isolate_page_range.patch added to mm-new branch
Message-Id: <20250507212526.60A59C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_isolation: remove migratetype from undo_isolate_page_range()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_isolation-remove-migratetype-from-undo_isolate_page_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_isolation-remove-migratetype-from-undo_isolate_page_range.patch

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
Subject: mm/page_isolation: remove migratetype from undo_isolate_page_range()
Date: Wed, 7 May 2025 17:10:58 -0400

Since migratetype is no longer overwritten during pageblock isolation,
undoing pageblock isolation no longer needs which migratetype to restore.

Link: https://lkml.kernel.org/r/20250507211059.2211628-4-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-isolation.h |    3 +--
 mm/memory_hotplug.c            |    4 ++--
 mm/page_alloc.c                |    2 +-
 mm/page_isolation.c            |    9 +++------
 4 files changed, 7 insertions(+), 11 deletions(-)

--- a/include/linux/page-isolation.h~mm-page_isolation-remove-migratetype-from-undo_isolate_page_range
+++ a/include/linux/page-isolation.h
@@ -33,8 +33,7 @@ bool pageblock_unisolate_and_move_free_p
 int start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
 			     int migratetype, int flags);
 
-void undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
-			     int migratetype);
+void undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn);
 
 int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn,
 			int isol_flags);
--- a/mm/memory_hotplug.c~mm-page_isolation-remove-migratetype-from-undo_isolate_page_range
+++ a/mm/memory_hotplug.c
@@ -1229,7 +1229,7 @@ int online_pages(unsigned long pfn, unsi
 		build_all_zonelists(NULL);
 
 	/* Basic onlining is complete, allow allocation of onlined pages. */
-	undo_isolate_page_range(pfn, pfn + nr_pages, MIGRATE_MOVABLE);
+	undo_isolate_page_range(pfn, pfn + nr_pages);
 
 	/*
 	 * Freshly onlined pages aren't shuffled (e.g., all pages are placed to
@@ -2115,7 +2115,7 @@ int offline_pages(unsigned long start_pf
 
 failed_removal_isolated:
 	/* pushback to free area */
-	undo_isolate_page_range(start_pfn, end_pfn, MIGRATE_MOVABLE);
+	undo_isolate_page_range(start_pfn, end_pfn);
 	memory_notify(MEM_CANCEL_OFFLINE, &arg);
 failed_removal_pcplists_disabled:
 	lru_cache_enable();
--- a/mm/page_alloc.c~mm-page_isolation-remove-migratetype-from-undo_isolate_page_range
+++ a/mm/page_alloc.c
@@ -6888,7 +6888,7 @@ int alloc_contig_range_noprof(unsigned l
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

mm-page_isolation-make-page-isolation-a-standalone-bit.patch
mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate.patch
mm-page_isolation-remove-migratetype-from-undo_isolate_page_range.patch
mm-page_isolation-remove-migratetype-parameter-from-more-functions.patch

