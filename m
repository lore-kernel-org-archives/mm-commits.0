Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A062C7482
	for <mm-commits@vger.kernel.org>; Tue,  3 Jun 2025 02:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748916509; cv=none; b=hlgCVM0QR0PZSC6K4yCalzvBJFcFN8hTP6UF7R0W3dsoTC6t40DLEH9Gf7z5+WtWGJcR4OKEZVnNzLMbfaxEQpNIh4Dfktht0IOIylc3+wNBj49LuosrhymzNfFuPkjHfs/xhEKJG+GBv0uJernKNhPUvdRuYEoQYQaiJt3qdm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748916509; c=relaxed/simple;
	bh=yCN6gEpXHpq80yl/mus3hZ9BXQHG9O1VndyGw1TBe2s=;
	h=Date:To:From:Subject:Message-Id; b=U2RussbmvcrlyIv92aDri9w7yxe2VdmAXfr7iPxv9GvYTXjUAOG59MZ/GqVKE/FLHwJhancXJKd5pexPau/kRS1l0Q8KanqwTUfgy1mndupknqWI3F55Qmf/NfCFpVVltmEH3nDeQ7uxvedjhESvkSlq/38uBpeNdP8NiscDFSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vayw7siu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vayw7siu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74164C4CEEB;
	Tue,  3 Jun 2025 02:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748916509;
	bh=yCN6gEpXHpq80yl/mus3hZ9BXQHG9O1VndyGw1TBe2s=;
	h=Date:To:From:Subject:From;
	b=Vayw7siuqtmgrdzm2Xss4k2KIOHhvey65W4qQ296dQQ/Tz3DqEEmYoTm4E4fGC+NV
	 O59PxYVSKMAflORUmSrWu7q9Q2ouO9UdbvrLZn/jOlJIm/k9G1aLx2myzv5e71uYBI
	 2WFPGktzAzuaoUdVUdNB5ZDAQsaMTD9eV4gl88rM=
Date: Mon, 02 Jun 2025 19:08:28 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,richardycc@google.com,osalvador@suse.de,mhocko@suse.com,mgorman@techsingularity.net,kirill.shutemov@linux.intel.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-remove-migratetype-from-undo_isolate_page_range.patch added to mm-new branch
Message-Id: <20250603020829.74164C4CEEB@smtp.kernel.org>
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
Date: Mon, 2 Jun 2025 19:52:46 -0400

Since migratetype is no longer overwritten during pageblock isolation,
undoing pageblock isolation no longer needs which migratetype to restore.

Link: https://lkml.kernel.org/r/20250602235247.1219983-6-ziy@nvidia.com
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
@@ -1233,7 +1233,7 @@ int online_pages(unsigned long pfn, unsi
 		build_all_zonelists(NULL);
 
 	/* Basic onlining is complete, allow allocation of onlined pages. */
-	undo_isolate_page_range(pfn, pfn + nr_pages, MIGRATE_MOVABLE);
+	undo_isolate_page_range(pfn, pfn + nr_pages);
 
 	/*
 	 * Freshly onlined pages aren't shuffled (e.g., all pages are placed to
@@ -2119,7 +2119,7 @@ int offline_pages(unsigned long start_pf
 
 failed_removal_isolated:
 	/* pushback to free area */
-	undo_isolate_page_range(start_pfn, end_pfn, MIGRATE_MOVABLE);
+	undo_isolate_page_range(start_pfn, end_pfn);
 	memory_notify(MEM_CANCEL_OFFLINE, &arg);
 failed_removal_pcplists_disabled:
 	lru_cache_enable();
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

mm-page_alloc-pageblock-flags-functions-clean-up.patch
mm-page_isolation-make-page-isolation-a-standalone-bit.patch
mm-page_alloc-add-support-for-initializing-pageblock-as-isolated.patch
mm-page_alloc-add-support-for-initializing-pageblock-as-isolated-fix.patch
mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate.patch
mm-page_isolation-remove-migratetype-from-undo_isolate_page_range.patch
mm-page_isolation-remove-migratetype-parameter-from-more-functions.patch

