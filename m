From: akpm@linux-foundation.org
Subject: + mm-compaction-export-tracepoints-zone-names-to-userspace.patch
 added to -mm tree
Date: Tue, 22 Sep 2015 12:57:54 -0700
Message-ID: <5601b2c2.lvF9HXdXtuxXRDfz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53936 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933576AbbIVT5z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Sep 2015 15:57:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mgorman@suse.de, mingo@redhat.com, rientjes@google.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: export tracepoints zone names to userspace
has been added to the -mm tree.  Its filename is
     mm-compaction-export-tracepoints-zone-names-to-userspace.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-export-tracepoints-zone-names-to-userspace.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-export-tracepoints-zone-names-to-userspace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: export tracepoints zone names to userspace

Some compaction tracepoints use zone->name to print which zone is being
compacted.  This works for in-kernel printing, but not userspace trace
printing of raw captured trace such as via trace-cmd report.

This patch uses zone_idx() instead of zone->name as the raw value, and
when printing, converts the zone_type to string using the appropriate EM()
macros and some ugly tricks to overcome the problem that half the values
depend on CONFIG_ options and one does not simply use #ifdef inside of
#define.

trace-cmd output before:
transhuge-stres-4235  [000]   453.149280: mm_compaction_finished: node=0
zone=ffffffff81815d7a order=9 ret=partial

after:
transhuge-stres-4235  [000]   453.149280: mm_compaction_finished: node=0
zone=Normal   order=9 ret=partial

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/compaction.h |   38 +++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 6 deletions(-)

diff -puN include/trace/events/compaction.h~mm-compaction-export-tracepoints-zone-names-to-userspace include/trace/events/compaction.h
--- a/include/trace/events/compaction.h~mm-compaction-export-tracepoints-zone-names-to-userspace
+++ a/include/trace/events/compaction.h
@@ -18,6 +18,31 @@
 	EM( COMPACT_NO_SUITABLE_PAGE,	"no_suitable_page")	\
 	EMe(COMPACT_NOT_SUITABLE_ZONE,	"not_suitable_zone")
 
+#ifdef CONFIG_ZONE_DMA
+#define IFDEF_ZONE_DMA(X) X
+#else
+#define IFDEF_ZONE_DMA(X)
+#endif
+
+#ifdef CONFIG_ZONE_DMA32
+#define IFDEF_ZONE_DMA32(X) X
+#else
+#define IFDEF_ZONE_DMA32(X)
+#endif
+
+#ifdef CONFIG_ZONE_HIGHMEM_
+#define IFDEF_ZONE_HIGHMEM(X) X
+#else
+#define IFDEF_ZONE_HIGHMEM(X)
+#endif
+
+#define ZONE_TYPE						\
+	IFDEF_ZONE_DMA(		EM (ZONE_DMA,	 "DMA"))	\
+	IFDEF_ZONE_DMA32(	EM (ZONE_DMA32,	 "DMA32"))	\
+				EM (ZONE_NORMAL, "Normal")	\
+	IFDEF_ZONE_HIGHMEM(	EM (ZONE_HIGHMEM,"HighMem"))	\
+				EMe(ZONE_MOVABLE,"Movable")
+
 /*
  * First define the enums in the above macros to be exported to userspace
  * via TRACE_DEFINE_ENUM().
@@ -28,6 +53,7 @@
 #define EMe(a, b)	TRACE_DEFINE_ENUM(a);
 
 COMPACTION_STATUS
+ZONE_TYPE
 
 /*
  * Now redefine the EM() and EMe() macros to map the enums to the strings
@@ -230,21 +256,21 @@ DECLARE_EVENT_CLASS(mm_compaction_suitab
 
 	TP_STRUCT__entry(
 		__field(int, nid)
-		__field(char *, name)
+		__field(enum zone_type, idx)
 		__field(int, order)
 		__field(int, ret)
 	),
 
 	TP_fast_assign(
 		__entry->nid = zone_to_nid(zone);
-		__entry->name = (char *)zone->name;
+		__entry->idx = zone_idx(zone);
 		__entry->order = order;
 		__entry->ret = ret;
 	),
 
 	TP_printk("node=%d zone=%-8s order=%d ret=%s",
 		__entry->nid,
-		__entry->name,
+		__print_symbolic(__entry->idx, ZONE_TYPE),
 		__entry->order,
 		__print_symbolic(__entry->ret, COMPACTION_STATUS))
 );
@@ -276,7 +302,7 @@ DECLARE_EVENT_CLASS(mm_compaction_defer_
 
 	TP_STRUCT__entry(
 		__field(int, nid)
-		__field(char *, name)
+		__field(enum zone_type, idx)
 		__field(int, order)
 		__field(unsigned int, considered)
 		__field(unsigned int, defer_shift)
@@ -285,7 +311,7 @@ DECLARE_EVENT_CLASS(mm_compaction_defer_
 
 	TP_fast_assign(
 		__entry->nid = zone_to_nid(zone);
-		__entry->name = (char *)zone->name;
+		__entry->idx = zone_idx(zone);
 		__entry->order = order;
 		__entry->considered = zone->compact_considered;
 		__entry->defer_shift = zone->compact_defer_shift;
@@ -294,7 +320,7 @@ DECLARE_EVENT_CLASS(mm_compaction_defer_
 
 	TP_printk("node=%d zone=%-8s order=%d order_failed=%d consider=%u limit=%lu",
 		__entry->nid,
-		__entry->name,
+		__print_symbolic(__entry->idx, ZONE_TYPE),
 		__entry->order,
 		__entry->order_failed,
 		__entry->considered,
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-migrate-count-pages-failing-all-retries-in-vmstat-and-tracepoint.patch
mm-compaction-export-tracepoints-status-strings-to-userspace.patch
mm-compaction-export-tracepoints-zone-names-to-userspace.patch
mm-compaction-disginguish-contended-status-in-tracepoints.patch

