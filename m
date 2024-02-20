Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFA478B77
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 17:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708450717; cv=none; b=Qk5R53Be2H0t108ApTjyDquPoDr71G9A5smBoL20L5XU3VTGu6p9eK4sDQ1yAnFv6nq/eLkp6zsOnkfOtzl4k50FeukBT4ZNHZKv8mpdi9yX+fJT0Bux6hkuVpnUx1elkEdvm9nYWJJiSaMKOOrd5v3NX+s38HpjPBni2s0ga54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708450717; c=relaxed/simple;
	bh=RgdOQ+cRnCNT4HuPXhI/sFcvidsmQv2dkx6/b8b5wps=;
	h=Date:To:From:Subject:Message-Id; b=XUgBCUTW1CetjbhnR8Qpbm5bnJZwntp9EtyAXicQMtyRlRDKTmLRTOYtf8PRyQNqJ6BUSMdnGtJiyYYi6etclFhHrowzVH4L/+xoOzEyFwGgf2AVtuqmEVSfnBpV9AGL7xTvpi1BTAUCCqzOZ2NPyjXGPRo/4btY1jZJaRBUJDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2GTiecyx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2GTiecyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64207C433A6;
	Tue, 20 Feb 2024 17:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708450716;
	bh=RgdOQ+cRnCNT4HuPXhI/sFcvidsmQv2dkx6/b8b5wps=;
	h=Date:To:From:Subject:From;
	b=2GTiecyxUQAN4rV+0jQZlZzWPU3VVHCIX+zd/WmVKIxrKvw3isCoCkhvR+xY/iD0X
	 lWw5QULuRyRofseppdjy+fIEOMiW3fCDoYFwPVM5DVR3DutK22wn5bBFx9SYWrZMD0
	 9QDdlzTkthddBjgVuZ7DdCG5g6j5neEPnse/zbbo=
Date: Tue, 20 Feb 2024 09:38:35 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,rostedt@goodmis.org,mhiramat@kernel.org,mgorman@techsingularity.net,mathieu.desnoyers@efficios.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages.patch added to mm-unstable branch
Message-Id: <20240220173836.64207C433A6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: compaction: update the cc->nr_migratepages when allocating or freeing the freepages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: compaction: update the cc->nr_migratepages when allocating or freeing the freepages
Date: Tue, 20 Feb 2024 14:16:31 +0800

Currently we will use 'cc->nr_freepages >= cc->nr_migratepages' comparison
to ensure that enough freepages are isolated in isolate_freepages(),
however it just decreases the cc->nr_freepages without updating
cc->nr_migratepages in compaction_alloc(), which will waste more CPU
cycles and cause too many freepages to be isolated.

So we should also update the cc->nr_migratepages when allocating or
freeing the freepages to avoid isolating excess freepages.  And I can see
fewer free pages are scanned and isolated when running thpcompact on my
Arm64 server:

                                       k6.7         k6.7_patched
Ops Compaction pages isolated      120692036.00   118160797.00
Ops Compaction migrate scanned     131210329.00   154093268.00
Ops Compaction free scanned       1090587971.00  1080632536.00
Ops Compact scan efficiency               12.03          14.26

Moreover, I did not see an obvious latency improvements, this is likely
because isolating freepages is not the bottleneck in the thpcompact test
case.

                              k6.7                  k6.7_patched
Amean     fault-both-1      1089.76 (   0.00%)     1080.16 *   0.88%*
Amean     fault-both-3      1616.48 (   0.00%)     1636.65 *  -1.25%*
Amean     fault-both-5      2266.66 (   0.00%)     2219.20 *   2.09%*
Amean     fault-both-7      2909.84 (   0.00%)     2801.90 *   3.71%*
Amean     fault-both-12     4861.26 (   0.00%)     4733.25 *   2.63%*
Amean     fault-both-18     7351.11 (   0.00%)     6950.51 *   5.45%*
Amean     fault-both-24     9059.30 (   0.00%)     9159.99 *  -1.11%*
Amean     fault-both-30    10685.68 (   0.00%)    11399.02 *  -6.68%*

Link: https://lkml.kernel.org/r/6440493f18da82298152b6305d6b41c2962a3ce6.1708409245.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/compaction.h |    6 +++---
 mm/compaction.c                   |   12 ++++++++++--
 2 files changed, 13 insertions(+), 5 deletions(-)

--- a/include/trace/events/compaction.h~mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages
+++ a/include/trace/events/compaction.h
@@ -78,10 +78,10 @@ DEFINE_EVENT(mm_compaction_isolate_templ
 #ifdef CONFIG_COMPACTION
 TRACE_EVENT(mm_compaction_migratepages,
 
-	TP_PROTO(struct compact_control *cc,
+	TP_PROTO(unsigned int nr_migratepages,
 		unsigned int nr_succeeded),
 
-	TP_ARGS(cc, nr_succeeded),
+	TP_ARGS(nr_migratepages, nr_succeeded),
 
 	TP_STRUCT__entry(
 		__field(unsigned long, nr_migrated)
@@ -90,7 +90,7 @@ TRACE_EVENT(mm_compaction_migratepages,
 
 	TP_fast_assign(
 		__entry->nr_migrated = nr_succeeded;
-		__entry->nr_failed = cc->nr_migratepages - nr_succeeded;
+		__entry->nr_failed = nr_migratepages - nr_succeeded;
 	),
 
 	TP_printk("nr_migrated=%lu nr_failed=%lu",
--- a/mm/compaction.c~mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages
+++ a/mm/compaction.c
@@ -1798,6 +1798,7 @@ static struct folio *compaction_alloc(st
 	dst = list_entry(cc->freepages.next, struct folio, lru);
 	list_del(&dst->lru);
 	cc->nr_freepages--;
+	cc->nr_migratepages--;
 
 	return dst;
 }
@@ -1813,6 +1814,7 @@ static void compaction_free(struct folio
 
 	list_add(&dst->lru, &cc->freepages);
 	cc->nr_freepages++;
+	cc->nr_migratepages++;
 }
 
 /* possible outcome of isolate_migratepages */
@@ -2435,7 +2437,7 @@ compact_zone(struct compact_control *cc,
 	unsigned long last_migrated_pfn;
 	const bool sync = cc->mode != MIGRATE_ASYNC;
 	bool update_cached;
-	unsigned int nr_succeeded = 0;
+	unsigned int nr_succeeded = 0, nr_migratepages;
 
 	/*
 	 * These counters track activities during zone compaction.  Initialize
@@ -2553,11 +2555,17 @@ rescan:
 				pageblock_start_pfn(cc->migrate_pfn - 1));
 		}
 
+		/*
+		 * Record the number of pages to migrate since the
+		 * compaction_alloc/free() will update cc->nr_migratepages
+		 * properly.
+		 */
+		nr_migratepages = cc->nr_migratepages;
 		err = migrate_pages(&cc->migratepages, compaction_alloc,
 				compaction_free, (unsigned long)cc, cc->mode,
 				MR_COMPACTION, &nr_succeeded);
 
-		trace_mm_compaction_migratepages(cc, nr_succeeded);
+		trace_mm_compaction_migratepages(nr_migratepages, nr_succeeded);
 
 		/* All pages were either migrated or will be released */
 		cc->nr_migratepages = 0;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-compaction-limit-the-suitable-target-page-order-to-be-less-than-cc-order.patch
mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages.patch
mm-hugetlb-improve-the-handling-of-hugetlb-allocation-failure-for-freed-or-in-use-hugetlb.patch

