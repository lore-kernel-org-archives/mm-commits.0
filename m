Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F012527E7F0
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 20:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753214662; cv=none; b=ZjBjGmroMfhAtZMLwHe6G4cDQZtAvQyvXi5dz5E1sigoEAOtF5NlY+sqMt+9cZiZqFJR42lnGgbMGtK7oqWNCyi9mzXL5Z+rHekBEb+pPKCSubtwQjLuUuR8OK91WF5dKcL5KvhAZy9wI6l3gyd0EYYvkEinjhwvDCobFKyWjBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753214662; c=relaxed/simple;
	bh=nGf4CAwwOQn03/jPmsiyCxezj+HYghs6bUKWmEZWd+0=;
	h=Date:To:From:Subject:Message-Id; b=LRPQlbcbe/szZhWubByxjUo9aanm0PhmG7LvL7EPTatCVMrmThZNxCxi2FzCsQVEhFQjh21W49N4SSfg7cgwcmaCVtZCEgXOVDa3mLT5HxbNxVN8Fcuz0gdFQK1AGj+KHDNlHajRUpL+ZH2rmKhDBUaFefgf282mq2+UgaZvuJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WIa6YVL3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WIa6YVL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821AFC4CEEB;
	Tue, 22 Jul 2025 20:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753214661;
	bh=nGf4CAwwOQn03/jPmsiyCxezj+HYghs6bUKWmEZWd+0=;
	h=Date:To:From:Subject:From;
	b=WIa6YVL3akOUZ5Ma22irCOPNYcS5jb97yXbK5mOHJP9BFJgtCS8EFZIhHJXSS/DKH
	 VNAU14qOkn/SUw7F/0g7Hda5OPwF3N2bGXvnYgFNAzlHOUB7GQDC9tWv9+FIyH9AJ1
	 4sx5HoZTcByBexHzQM2pQK8a59WG/G/V3n/GZ26M=
Date: Tue, 22 Jul 2025 13:04:20 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rostedt@goodmis.org,rientjes@google.com,richardycc@google.com,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lkp@intel.com,liumartin@google.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-trace_mm_alloc_contig_migrate_range_info.patch added to mm-unstable branch
Message-Id: <20250722200421.821AFC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: remove trace_mm_alloc_contig_migrate_range_info()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-remove-trace_mm_alloc_contig_migrate_range_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-trace_mm_alloc_contig_migrate_range_info.patch

This patch will later appear in the mm-unstable branch at
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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/page_alloc: remove trace_mm_alloc_contig_migrate_range_info()
Date: Tue, 22 Jul 2025 15:46:49 -0400

The trace event has not recorded the right data since it was introduced at
commit c8b360031218 ("mm: add alloc_contig_migrate_range allocation
statistics").  Remove it.

Link: https://lkml.kernel.org/r/20250722194649.4135191-1-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202507220742.P3SaKlI6-lkp@intel.com/
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Martin Liu <liumartin@google.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/kmem.h |   40 ----------------------------------
 mm/page_alloc.c             |   32 ++-------------------------
 2 files changed, 3 insertions(+), 69 deletions(-)

--- a/include/trace/events/kmem.h~mm-page_alloc-remove-trace_mm_alloc_contig_migrate_range_info
+++ a/include/trace/events/kmem.h
@@ -304,46 +304,6 @@ TRACE_EVENT(mm_page_alloc_extfrag,
 		__entry->change_ownership)
 );
 
-#ifdef CONFIG_CONTIG_ALLOC
-TRACE_EVENT(mm_alloc_contig_migrate_range_info,
-
-	TP_PROTO(unsigned long start,
-		 unsigned long end,
-		 unsigned long nr_migrated,
-		 unsigned long nr_reclaimed,
-		 unsigned long nr_mapped,
-		 acr_flags_t alloc_flags),
-
-	TP_ARGS(start, end, nr_migrated, nr_reclaimed, nr_mapped, alloc_flags),
-
-	TP_STRUCT__entry(
-		__field(unsigned long, start)
-		__field(unsigned long, end)
-		__field(unsigned long, nr_migrated)
-		__field(unsigned long, nr_reclaimed)
-		__field(unsigned long, nr_mapped)
-		__field(acr_flags_t, alloc_flags)
-	),
-
-	TP_fast_assign(
-		__entry->start = start;
-		__entry->end = end;
-		__entry->nr_migrated = nr_migrated;
-		__entry->nr_reclaimed = nr_reclaimed;
-		__entry->nr_mapped = nr_mapped;
-		__entry->alloc_flags = alloc_flags;
-	),
-
-	TP_printk("start=0x%lx end=0x%lx alloc_flags=%d nr_migrated=%lu nr_reclaimed=%lu nr_mapped=%lu",
-		  __entry->start,
-		  __entry->end,
-		  __entry->alloc_flags,
-		  __entry->nr_migrated,
-		  __entry->nr_reclaimed,
-		  __entry->nr_mapped)
-);
-#endif
-
 TRACE_EVENT(mm_setup_per_zone_wmarks,
 
 	TP_PROTO(struct zone *zone),
--- a/mm/page_alloc.c~mm-page_alloc-remove-trace_mm_alloc_contig_migrate_range_info
+++ a/mm/page_alloc.c
@@ -6694,14 +6694,9 @@ static void alloc_contig_dump_pages(stru
 	}
 }
 
-/*
- * [start, end) must belong to a single zone.
- * @alloc_flags: using acr_flags_t to filter the type of migration in
- *		trace_mm_alloc_contig_migrate_range_info.
- */
+/* [start, end) must belong to a single zone. */
 static int __alloc_contig_migrate_range(struct compact_control *cc,
-					unsigned long start, unsigned long end,
-					acr_flags_t alloc_flags)
+					unsigned long start, unsigned long end)
 {
 	/* This function is based on compact_zone() from compaction.c. */
 	unsigned int nr_reclaimed;
@@ -6713,10 +6708,6 @@ static int __alloc_contig_migrate_range(
 		.gfp_mask = cc->gfp_mask,
 		.reason = MR_CONTIG_RANGE,
 	};
-	struct page *page;
-	unsigned long total_mapped = 0;
-	unsigned long total_migrated = 0;
-	unsigned long total_reclaimed = 0;
 
 	lru_cache_disable();
 
@@ -6742,22 +6733,9 @@ static int __alloc_contig_migrate_range(
 							&cc->migratepages);
 		cc->nr_migratepages -= nr_reclaimed;
 
-		if (trace_mm_alloc_contig_migrate_range_info_enabled()) {
-			total_reclaimed += nr_reclaimed;
-			list_for_each_entry(page, &cc->migratepages, lru) {
-				struct folio *folio = page_folio(page);
-
-				total_mapped += folio_mapped(folio) *
-						folio_nr_pages(folio);
-			}
-		}
-
 		ret = migrate_pages(&cc->migratepages, alloc_migration_target,
 			NULL, (unsigned long)&mtc, cc->mode, MR_CONTIG_RANGE, NULL);
 
-		if (trace_mm_alloc_contig_migrate_range_info_enabled() && !ret)
-			total_migrated += cc->nr_migratepages;
-
 		/*
 		 * On -ENOMEM, migrate_pages() bails out right away. It is pointless
 		 * to retry again over this error, so do the same here.
@@ -6773,10 +6751,6 @@ static int __alloc_contig_migrate_range(
 		putback_movable_pages(&cc->migratepages);
 	}
 
-	trace_mm_alloc_contig_migrate_range_info(start, end, alloc_flags,
-						 total_migrated,
-						 total_reclaimed,
-						 total_mapped);
 	return (ret < 0) ? ret : 0;
 }
 
@@ -6921,7 +6895,7 @@ int alloc_contig_range_noprof(unsigned l
 	 * allocated.  So, if we fall through be sure to clear ret so that
 	 * -EBUSY is not accidentally used or returned to caller.
 	 */
-	ret = __alloc_contig_migrate_range(&cc, start, end, alloc_flags);
+	ret = __alloc_contig_migrate_range(&cc, start, end);
 	if (ret && ret != -EBUSY)
 		goto done;
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-move-unrelated-code-out-of-__split_unmapped_folio.patch
mm-huge_memory-remove-after_split-label-in-__split_unmapped_folio.patch
mm-huge_memory-deduplicate-code-in-__folio_split.patch
mm-huge_memory-convert-vm_bug-to-vm_warn-in-__folio_split.patch
mm-huge_memory-get-frozen-folio-refcount-with-folio_expected_ref_count.patch
mm-huge_memory-refactor-after-split-page-cache-code.patch
mm-page_alloc-remove-trace_mm_alloc_contig_migrate_range_info.patch

