From: akpm@linux-foundation.org
Subject: + mm-change-trace_mm_vmscan_writepage-proto-type.patch added to
 -mm tree
Date: Tue, 17 Nov 2015 13:42:33 -0800
Message-ID: <564b9f49.zceNq61N2YzYYY32%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45083 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbbKQVmd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 16:42:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yalin.wang2010@gmail.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: change trace_mm_vmscan_writepage() proto type
has been added to the -mm tree.  Its filename is
     mm-change-trace_mm_vmscan_writepage-proto-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-change-trace_mm_vmscan_writepage-proto-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-change-trace_mm_vmscan_writepage-proto-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: yalin wang <yalin.wang2010@gmail.com>
Subject: mm/vmscan.c: change trace_mm_vmscan_writepage() proto type

Move trace_reclaim_flags() into trace function, so that we don't need
caculate these flags if the trace is disabled.

Signed-off-by: yalin wang <yalin.wang2010@gmail.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |    7 +++----
 mm/vmscan.c                   |    2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff -puN include/trace/events/vmscan.h~mm-change-trace_mm_vmscan_writepage-proto-type include/trace/events/vmscan.h
--- a/include/trace/events/vmscan.h~mm-change-trace_mm_vmscan_writepage-proto-type
+++ a/include/trace/events/vmscan.h
@@ -330,10 +330,9 @@ DEFINE_EVENT(mm_vmscan_lru_isolate_templ
 
 TRACE_EVENT(mm_vmscan_writepage,
 
-	TP_PROTO(struct page *page,
-		int reclaim_flags),
+	TP_PROTO(struct page *page),
 
-	TP_ARGS(page, reclaim_flags),
+	TP_ARGS(page),
 
 	TP_STRUCT__entry(
 		__field(unsigned long, pfn)
@@ -342,7 +341,7 @@ TRACE_EVENT(mm_vmscan_writepage,
 
 	TP_fast_assign(
 		__entry->pfn = page_to_pfn(page);
-		__entry->reclaim_flags = reclaim_flags;
+		__entry->reclaim_flags = trace_reclaim_flags(page);
 	),
 
 	TP_printk("page=%p pfn=%lu flags=%s",
diff -puN mm/vmscan.c~mm-change-trace_mm_vmscan_writepage-proto-type mm/vmscan.c
--- a/mm/vmscan.c~mm-change-trace_mm_vmscan_writepage-proto-type
+++ a/mm/vmscan.c
@@ -594,7 +594,7 @@ static pageout_t pageout(struct page *pa
 			/* synchronous write or broken a_ops? */
 			ClearPageReclaim(page);
 		}
-		trace_mm_vmscan_writepage(page, trace_reclaim_flags(page));
+		trace_mm_vmscan_writepage(page);
 		inc_zone_page_state(page, NR_VMSCAN_WRITE);
 		return PAGE_SUCCESS;
 	}
_

Patches currently in -mm which might be from yalin.wang2010@gmail.com are

mm-change-trace_mm_vmscan_writepage-proto-type.patch
mm-fix-kernel-crash-in-khugepaged-thread.patch

