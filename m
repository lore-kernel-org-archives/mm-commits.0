Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CCA38F9A
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 03:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719287558; cv=none; b=S6GYwimoWbbKs57j1YnOJT4nmQdY0RtZnfUG17BfQ2Xbr9Aiy1vC6+RzVr+yNm0ul9Vktd+AdPmB0a0Dn4EfRIkIUbQbvlRtynarEqBGiljBlG4lPSAxzawa87IzOnnGONygowDpo9aLhLZvYMRHMgDY81feGN17HhoVyiUnZ14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719287558; c=relaxed/simple;
	bh=44PcoVdOknP51KYxKwYK3icIBUo/6j4ZyQ6vJkf/XZ0=;
	h=Date:To:From:Subject:Message-Id; b=dx93pv0h5Ep55C/Kznt4ETk+PEocSmj7Ij7v7W145w7v71yyLuETvMYoo6ft1oD4m20AivvVYPCmh2zWcfVWPhkBTNaFc+tzutIH8ZCG+BXb+SNWU3lO06YfnG3cQaj6t+3tWCg6AGan8mB8Hq5VDw87EXMpkCioptC4UmMzZvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1aDIJZuc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1aDIJZuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F13AC32782;
	Tue, 25 Jun 2024 03:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719287557;
	bh=44PcoVdOknP51KYxKwYK3icIBUo/6j4ZyQ6vJkf/XZ0=;
	h=Date:To:From:Subject:From;
	b=1aDIJZuc9f4L/UeqXdpmWu5Yaenh49aRlCXXW5DL8lHo0ZljWSK9EjWyrW0OFIGh4
	 TEybuJGtxHjWvr35ewX/pn2GvmLTHFlOtiBOx9WZmDlvyr0jlAa4+FUjm9zkhQ/YNT
	 MytRuF/sLcltKrZ5Or6t6DiTTYlgZK5cO3oV3YUc=
Date: Mon, 24 Jun 2024 20:52:37 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,souravpanda@google.com,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,keescook@chromium.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-handle-profiling-for-fake-memory-allocations-during-compaction.patch removed from -mm tree
Message-Id: <20240625035237.8F13AC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: handle profiling for fake memory allocations during compaction
has been removed from the -mm tree.  Its filename was
     mm-handle-profiling-for-fake-memory-allocations-during-compaction.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: handle profiling for fake memory allocations during compaction
Date: Fri, 14 Jun 2024 16:05:04 -0700

During compaction isolated free pages are marked allocated so that they
can be split and/or freed.  For that, post_alloc_hook() is used inside
split_map_pages() and release_free_list().  split_map_pages() marks free
pages allocated, splits the pages and then lets
alloc_contig_range_noprof() free those pages.  release_free_list() marks
free pages and immediately frees them.  This usage of post_alloc_hook()
affect memory allocation profiling because these functions might not be
called from an instrumented allocator, therefore current->alloc_tag is
NULL and when debugging is enabled (CONFIG_MEM_ALLOC_PROFILING_DEBUG=y)
that causes warnings.  To avoid that, wrap such post_alloc_hook() calls
into an instrumented function which acts as an allocator which will be
charged for these fake allocations.  Note that these allocations are very
short lived until they are freed, therefore the associated counters should
usually read 0.

Link: https://lkml.kernel.org/r/20240614230504.3849136-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/compaction.c~mm-handle-profiling-for-fake-memory-allocations-during-compaction
+++ a/mm/compaction.c
@@ -79,6 +79,13 @@ static inline bool is_via_compact_memory
 #define COMPACTION_HPAGE_ORDER	(PMD_SHIFT - PAGE_SHIFT)
 #endif
 
+static struct page *mark_allocated_noprof(struct page *page, unsigned int order, gfp_t gfp_flags)
+{
+	post_alloc_hook(page, order, __GFP_MOVABLE);
+	return page;
+}
+#define mark_allocated(...)	alloc_hooks(mark_allocated_noprof(__VA_ARGS__))
+
 static void split_map_pages(struct list_head *freepages)
 {
 	unsigned int i, order;
@@ -93,7 +100,7 @@ static void split_map_pages(struct list_
 
 			nr_pages = 1 << order;
 
-			post_alloc_hook(page, order, __GFP_MOVABLE);
+			mark_allocated(page, order, __GFP_MOVABLE);
 			if (order)
 				split_page(page, order);
 
@@ -122,7 +129,7 @@ static unsigned long release_free_list(s
 			 * Convert free pages into post allocation pages, so
 			 * that we can free them via __free_page.
 			 */
-			post_alloc_hook(page, order, __GFP_MOVABLE);
+			mark_allocated(page, order, __GFP_MOVABLE);
 			__free_pages(page, order);
 			if (pfn > high_pfn)
 				high_pfn = pfn;
_

Patches currently in -mm which might be from surenb@google.com are

lib-dump_stack-report-process-uid-in-dump_stack_print_info.patch

