From: akpm@linux-foundation.org
Subject: [patch 093/142] mm, vmscan: show LRU name in
 mm_vmscan_lru_isolate tracepoint
Date: Wed, 22 Feb 2017 15:44:24 -0800
Message-ID: <58ae2258.aCfipPxek8qOpz6q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49042 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933134AbdBVXo0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:44:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, hillf.zj@alibaba-inc.com, mgorman@suse.de, minchan@kernel.org, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: mm, vmscan: show LRU name in mm_vmscan_lru_isolate tracepoint

mm_vmscan_lru_isolate currently prints only whether the LRU we isolate
from is file or anonymous but we do not know which LRU this is.

It is useful to know whether the list is active or inactive, since we are
using the same function to isolate pages from both of them and it's hard
to distinguish otherwise.

Link: http://lkml.kernel.org/r/20170104101942.4860-5-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/mmflags.h |    8 ++++++++
 include/trace/events/vmscan.h  |   12 ++++++------
 mm/vmscan.c                    |    3 +--
 3 files changed, 15 insertions(+), 8 deletions(-)

diff -puN include/trace/events/mmflags.h~mm-vmscan-show-lru-name-in-mm_vmscan_lru_isolate-tracepoint include/trace/events/mmflags.h
--- a/include/trace/events/mmflags.h~mm-vmscan-show-lru-name-in-mm_vmscan_lru_isolate-tracepoint
+++ a/include/trace/events/mmflags.h
@@ -239,6 +239,13 @@ IF_HAVE_VM_SOFTDIRTY(VM_SOFTDIRTY,	"soft
 	IFDEF_ZONE_HIGHMEM(	EM (ZONE_HIGHMEM,"HighMem"))	\
 				EMe(ZONE_MOVABLE,"Movable")
 
+#define LRU_NAMES		\
+		EM (LRU_INACTIVE_ANON, "inactive_anon") \
+		EM (LRU_ACTIVE_ANON, "active_anon") \
+		EM (LRU_INACTIVE_FILE, "inactive_file") \
+		EM (LRU_ACTIVE_FILE, "active_file") \
+		EMe(LRU_UNEVICTABLE, "unevictable")
+
 /*
  * First define the enums in the above macros to be exported to userspace
  * via TRACE_DEFINE_ENUM().
@@ -252,6 +259,7 @@ COMPACTION_STATUS
 COMPACTION_PRIORITY
 COMPACTION_FEEDBACK
 ZONE_TYPE
+LRU_NAMES
 
 /*
  * Now redefine the EM() and EMe() macros to map the enums to the strings
diff -puN include/trace/events/vmscan.h~mm-vmscan-show-lru-name-in-mm_vmscan_lru_isolate-tracepoint include/trace/events/vmscan.h
--- a/include/trace/events/vmscan.h~mm-vmscan-show-lru-name-in-mm_vmscan_lru_isolate-tracepoint
+++ a/include/trace/events/vmscan.h
@@ -277,9 +277,9 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		unsigned long nr_skipped,
 		unsigned long nr_taken,
 		isolate_mode_t isolate_mode,
-		int file),
+		int lru),
 
-	TP_ARGS(classzone_idx, order, nr_requested, nr_scanned, nr_skipped, nr_taken, isolate_mode, file),
+	TP_ARGS(classzone_idx, order, nr_requested, nr_scanned, nr_skipped, nr_taken, isolate_mode, lru),
 
 	TP_STRUCT__entry(
 		__field(int, classzone_idx)
@@ -289,7 +289,7 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		__field(unsigned long, nr_skipped)
 		__field(unsigned long, nr_taken)
 		__field(isolate_mode_t, isolate_mode)
-		__field(int, file)
+		__field(int, lru)
 	),
 
 	TP_fast_assign(
@@ -300,10 +300,10 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		__entry->nr_skipped = nr_skipped;
 		__entry->nr_taken = nr_taken;
 		__entry->isolate_mode = isolate_mode;
-		__entry->file = file;
+		__entry->lru = lru;
 	),
 
-	TP_printk("isolate_mode=%d classzone=%d order=%d nr_requested=%lu nr_scanned=%lu nr_skipped=%lu nr_taken=%lu file=%d",
+	TP_printk("isolate_mode=%d classzone=%d order=%d nr_requested=%lu nr_scanned=%lu nr_skipped=%lu nr_taken=%lu lru=%s",
 		__entry->isolate_mode,
 		__entry->classzone_idx,
 		__entry->order,
@@ -311,7 +311,7 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		__entry->nr_scanned,
 		__entry->nr_skipped,
 		__entry->nr_taken,
-		__entry->file)
+		__print_symbolic(__entry->lru, LRU_NAMES))
 );
 
 TRACE_EVENT(mm_vmscan_writepage,
diff -puN mm/vmscan.c~mm-vmscan-show-lru-name-in-mm_vmscan_lru_isolate-tracepoint mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-show-lru-name-in-mm_vmscan_lru_isolate-tracepoint
+++ a/mm/vmscan.c
@@ -1509,8 +1509,7 @@ static unsigned long isolate_lru_pages(u
 	}
 	*nr_scanned = scan + total_skipped;
 	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
-				    scan, skipped, nr_taken, mode,
-				    is_file_lru(lru));
+				    scan, skipped, nr_taken, mode, lru);
 	update_lru_sizes(lruvec, lru, nr_zone_taken);
 	return nr_taken;
 }
_
