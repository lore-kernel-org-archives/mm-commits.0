Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2458F49
	for <mm-commits@vger.kernel.org>; Sat, 15 Jun 2024 01:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718414423; cv=none; b=kwYkrE0hMxODRFGUH4Rw4CVr1zpZ7/mpi6ys/572ClMwJa9LZvlZ2qZHRbHeyL22I5yKT8lIEerLTdVcueqmzyvDb/A/7WrbHQuOgrHyxArxBqVq8LAmZmNrzX1HRq8+tJnp6/+WqpGQZ8SrOoYcHQ0SJY+sP7wu9ONjZEr3z8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718414423; c=relaxed/simple;
	bh=Ou29o+t9hrZ8TrU5pAn+gnnc/GnaILvP9EXWR7+wGl4=;
	h=Date:To:From:Subject:Message-Id; b=tcl9koFAhtBt8lCH0EXBrCxINmMhksRW3wY+seI1ZUv2MtcnhQSN+/TBKzuyx1fwnR/65+A36yAcUeULxSP62cKi1+1qCTNRnZSnBylDRlVhIl8xIaLNPr+BOsjyjcu3jDsHdLD5uDjKFaj5l8Mg0OxztCA1EpnXpDPMwGhXFbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NuxMqaQs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NuxMqaQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2A1C2BD10;
	Sat, 15 Jun 2024 01:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718414422;
	bh=Ou29o+t9hrZ8TrU5pAn+gnnc/GnaILvP9EXWR7+wGl4=;
	h=Date:To:From:Subject:From;
	b=NuxMqaQsttvO0B9Gi+TqSF9NDtBQL2/uXkkrgOZv3jE7W260Fo74f4xB0LT05jWuS
	 XF3duH7G2l3Dpmm5VnIFpHicbeFYLx4YcKS7FYqI8Jr/Rj2+Wl3My95FwWmVuuAjBE
	 mAdAVjyRlfSXbsgPTsGwQYqEwmWjn6fV5QBSbqoU=
Date: Fri, 14 Jun 2024 18:20:22 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,souravpanda@google.com,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,keescook@chromium.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-handle-profiling-for-fake-memory-allocations-during-compaction.patch added to mm-hotfixes-unstable branch
Message-Id: <20240615012022.BE2A1C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: handle profiling for fake memory allocations during compaction
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-handle-profiling-for-fake-memory-allocations-during-compaction.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-handle-profiling-for-fake-memory-allocations-during-compaction.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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

lib-alloc_tag-do-not-register-sysctl-interface-when-config_sysctl=n.patch
lib-alloc_tag-fix-rcu-imbalance-in-pgalloc_tag_get.patch
mm-slab-fix-variable-obj_exts-set-but-not-used-warning.patch
mm-handle-profiling-for-fake-memory-allocations-during-compaction.patch

