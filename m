Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0172C12E1D5
	for <mm-commits@vger.kernel.org>; Mon, 26 Feb 2024 17:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708968849; cv=none; b=qVUJeJxYEPU4Hq3gUtbcgzIB6Lo+qIUtXsbGe+F4qdvo7cwv1YJB++qCAy/ATXYC7EoFNqVRPt4u+fbqy8gQNkCxkS7uAyi2DmcKJ8HsDLTA1CNhfOfHb2W4wOoqnJ5y6nD0Ja2J7ZCc20QDJ0qJrv+3YZEoIoHGGQnW6reM1YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708968849; c=relaxed/simple;
	bh=HreTv2KEbXKjqh09NeBEeEL7koesoylgR6nkVgLGEAI=;
	h=Date:To:From:Subject:Message-Id; b=EVfYtdObLLUo7H5FC78azDe64oJFm/1c01n8WeDGt3YLnWqnivdz6LpjnHR9LWRutK6Pgz+MW2/n8B98rhNj+KClma35V0Li/8bnTBtoS+l4bcnaEvEdxlJIEjT9jtJtkZjcB6K1M/RJ86+7OPOhUGaJYGIbXl+4Qladn4Z9Hio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PJlwtj4J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PJlwtj4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB302C433C7;
	Mon, 26 Feb 2024 17:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708968848;
	bh=HreTv2KEbXKjqh09NeBEeEL7koesoylgR6nkVgLGEAI=;
	h=Date:To:From:Subject:From;
	b=PJlwtj4JPKBElYK1qR2OLXpF5PZ9VNy/N3HlC5ZTyA7Hi65XCrfZ3xCLec3arX/W+
	 HD1U4QEcOGCJlcb88FeKDQ4Wle30tC0JIvtqlOYIPM+xAQF071XJ8xd7lCAREoCbvw
	 ICBTduc5xuKXRXnKtBWN4h569xKCuvug9Qw57elI=
Date: Mon, 26 Feb 2024 09:34:07 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,rostedt@goodmis.org,minchan@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,liumartin@google.com,richardycc@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-alloc_contig_migrate_range-allocation-statistics.patch added to mm-unstable branch
Message-Id: <20240226173408.AB302C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add alloc_contig_migrate_range allocation statistics
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-alloc_contig_migrate_range-allocation-statistics.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-alloc_contig_migrate_range-allocation-statistics.patch

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
From: Richard Chang <richardycc@google.com>
Subject: mm: add alloc_contig_migrate_range allocation statistics
Date: Mon, 26 Feb 2024 10:00:15 +0000

alloc_contig_migrate_range() has all the information to be able to
understand big contiguous allocation latency.  For example, how many pages
are migrated, how many times they were needed to unmap from page tables.

This patch adds the trace event to collect the allocation statistics.  In
the field, it was quite useful to understand CMA allocation latency.

Link: https://lkml.kernel.org/r/20240226100045.2083962-1-richardycc@google.com
Signed-off-by: Richard Chang <richardycc@google.com>
Cc: Martin Liu <liumartin@google.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/kmem.h |   39 ++++++++++++++++++++++++++++++++++
 mm/internal.h               |    3 +-
 mm/page_alloc.c             |   30 +++++++++++++++++++++-----
 mm/page_isolation.c         |    2 -
 4 files changed, 67 insertions(+), 7 deletions(-)

--- a/include/trace/events/kmem.h~mm-add-alloc_contig_migrate_range-allocation-statistics
+++ a/include/trace/events/kmem.h
@@ -304,6 +304,45 @@ TRACE_EVENT(mm_page_alloc_extfrag,
 		__entry->change_ownership)
 );
 
+TRACE_EVENT(mm_alloc_contig_migrate_range_info,
+
+	TP_PROTO(unsigned long start,
+		 unsigned long end,
+		 int migratetype,
+		 unsigned long nr_migrated,
+		 unsigned long nr_reclaimed,
+		 unsigned long nr_mapped),
+
+	TP_ARGS(start, end, migratetype,
+		nr_migrated, nr_reclaimed, nr_mapped),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, start)
+		__field(unsigned long, end)
+		__field(int, migratetype)
+		__field(unsigned long, nr_migrated)
+		__field(unsigned long, nr_reclaimed)
+		__field(unsigned long, nr_mapped)
+	),
+
+	TP_fast_assign(
+		__entry->start = start;
+		__entry->end = end;
+		__entry->migratetype = migratetype;
+		__entry->nr_migrated = nr_migrated;
+		__entry->nr_reclaimed = nr_reclaimed;
+		__entry->nr_mapped = nr_mapped;
+	),
+
+	TP_printk("start=0x%lx end=0x%lx migratetype=%d nr_migrated=%lu nr_reclaimed=%lu nr_mapped=%lu",
+		  __entry->start,
+		  __entry->end,
+		  __entry->migratetype,
+		  __entry->nr_migrated,
+		  __entry->nr_reclaimed,
+		  __entry->nr_mapped)
+);
+
 /*
  * Required for uniquely and securely identifying mm in rss_stat tracepoint.
  */
--- a/mm/internal.h~mm-add-alloc_contig_migrate_range-allocation-statistics
+++ a/mm/internal.h
@@ -540,7 +540,8 @@ isolate_migratepages_range(struct compac
 			   unsigned long low_pfn, unsigned long end_pfn);
 
 int __alloc_contig_migrate_range(struct compact_control *cc,
-					unsigned long start, unsigned long end);
+					unsigned long start, unsigned long end,
+					int migratetype);
 
 /* Free whole pageblock and set its migration type to MIGRATE_CMA. */
 void init_cma_reserved_pageblock(struct page *page);
--- a/mm/page_alloc.c~mm-add-alloc_contig_migrate_range-allocation-statistics
+++ a/mm/page_alloc.c
@@ -6218,9 +6218,14 @@ static void alloc_contig_dump_pages(stru
 	}
 }
 
-/* [start, end) must belong to a single zone. */
+/*
+ * [start, end) must belong to a single zone.
+ * @migratetype: using migratetype to filter the type of migration in
+ *		trace_mm_alloc_contig_migrate_range_info.
+ */
 int __alloc_contig_migrate_range(struct compact_control *cc,
-					unsigned long start, unsigned long end)
+					unsigned long start, unsigned long end,
+					int migratetype)
 {
 	/* This function is based on compact_zone() from compaction.c. */
 	unsigned int nr_reclaimed;
@@ -6231,6 +6236,10 @@ int __alloc_contig_migrate_range(struct
 		.nid = zone_to_nid(cc->zone),
 		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
 	};
+	struct page *page;
+	unsigned long total_mapped = 0;
+	unsigned long total_migrated = 0;
+	unsigned long total_reclaimed = 0;
 
 	lru_cache_disable();
 
@@ -6256,9 +6265,16 @@ int __alloc_contig_migrate_range(struct
 							&cc->migratepages);
 		cc->nr_migratepages -= nr_reclaimed;
 
+		total_reclaimed += nr_reclaimed;
+		list_for_each_entry(page, &cc->migratepages, lru)
+			total_mapped += page_mapcount(page);
+
 		ret = migrate_pages(&cc->migratepages, alloc_migration_target,
 			NULL, (unsigned long)&mtc, cc->mode, MR_CONTIG_RANGE, NULL);
 
+		if (!ret)
+			total_migrated += cc->nr_migratepages;
+
 		/*
 		 * On -ENOMEM, migrate_pages() bails out right away. It is pointless
 		 * to retry again over this error, so do the same here.
@@ -6272,9 +6288,13 @@ int __alloc_contig_migrate_range(struct
 		if (!(cc->gfp_mask & __GFP_NOWARN) && ret == -EBUSY)
 			alloc_contig_dump_pages(&cc->migratepages);
 		putback_movable_pages(&cc->migratepages);
-		return ret;
 	}
-	return 0;
+
+	trace_mm_alloc_contig_migrate_range_info(start, end, migratetype,
+						 total_migrated,
+						 total_reclaimed,
+						 total_mapped);
+	return (ret < 0) ? ret : 0;
 }
 
 /**
@@ -6354,7 +6374,7 @@ int alloc_contig_range(unsigned long sta
 	 * allocated.  So, if we fall through be sure to clear ret so that
 	 * -EBUSY is not accidentally used or returned to caller.
 	 */
-	ret = __alloc_contig_migrate_range(&cc, start, end);
+	ret = __alloc_contig_migrate_range(&cc, start, end, migratetype);
 	if (ret && ret != -EBUSY)
 		goto done;
 	ret = 0;
--- a/mm/page_isolation.c~mm-add-alloc_contig_migrate_range-allocation-statistics
+++ a/mm/page_isolation.c
@@ -434,7 +434,7 @@ static int isolate_single_pageblock(unsi
 				}
 
 				ret = __alloc_contig_migrate_range(&cc, head_pfn,
-							head_pfn + nr_pages);
+							head_pfn + nr_pages, page_mt);
 
 				/*
 				 * restore the page's migratetype so that it can
_

Patches currently in -mm which might be from richardycc@google.com are

mm-add-alloc_contig_migrate_range-allocation-statistics.patch

