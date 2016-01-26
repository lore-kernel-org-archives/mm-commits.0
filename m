From: akpm@linux-foundation.org
Subject: + tools-perf-make-gfp_compact_table-up-to-date.patch added to -mm tree
Date: Tue, 26 Jan 2016 13:04:01 -0800
Message-ID: <56a7df41.6Wsvh1/hG3N3DnPL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50862 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbcAZVEC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 16:04:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, acme@kernel.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, linux@rasmusvillemoes.dk, mgorman@suse.de, mhocko@suse.com, minchan@kernel.org, mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools, perf: make gfp_compact_table up to date
has been added to the -mm tree.  Its filename is
     tools-perf-make-gfp_compact_table-up-to-date.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-perf-make-gfp_compact_table-up-to-date.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-perf-make-gfp_compact_table-up-to-date.patch

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
Subject: tools, perf: make gfp_compact_table up to date

When updating tracing's show_gfp_flags() I have noticed that perf's
gfp_compact_table is also outdated.  Fill in the missing flags and place a
note in gfp.h to increase chance that future updates are synced.  Convert
the __GFP_X flags from "GFP_X" to "__GFP_X" strings in line with the
previous patch.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h       |    2 -
 tools/perf/builtin-kmem.c |   47 +++++++++++++++++++++---------------
 2 files changed, 29 insertions(+), 20 deletions(-)

diff -puN include/linux/gfp.h~tools-perf-make-gfp_compact_table-up-to-date include/linux/gfp.h
--- a/include/linux/gfp.h~tools-perf-make-gfp_compact_table-up-to-date
+++ a/include/linux/gfp.h
@@ -11,7 +11,7 @@ struct vm_area_struct;
 
 /*
  * In case of changes, please don't forget to update
- * include/trace/events/gfpflags.h
+ * include/trace/events/gfpflags.h and tools/perf/builtin-kmem.c
  */
 
 /* Plain integer GFP bitmasks. Do not use this directly. */
diff -puN tools/perf/builtin-kmem.c~tools-perf-make-gfp_compact_table-up-to-date tools/perf/builtin-kmem.c
--- a/tools/perf/builtin-kmem.c~tools-perf-make-gfp_compact_table-up-to-date
+++ a/tools/perf/builtin-kmem.c
@@ -612,30 +612,39 @@ static const struct {
 	{ "GFP_HIGHUSER",		"HU" },
 	{ "GFP_USER",			"U" },
 	{ "GFP_TEMPORARY",		"TMP" },
+	{ "GFP_KERNEL_ACCOUNT",		"KAC" },
 	{ "GFP_KERNEL",			"K" },
 	{ "GFP_NOFS",			"NF" },
 	{ "GFP_ATOMIC",			"A" },
 	{ "GFP_NOIO",			"NI" },
-	{ "GFP_HIGH",			"H" },
-	{ "GFP_WAIT",			"W" },
-	{ "GFP_IO",			"I" },
-	{ "GFP_COLD",			"CO" },
-	{ "GFP_NOWARN",			"NWR" },
-	{ "GFP_REPEAT",			"R" },
-	{ "GFP_NOFAIL",			"NF" },
-	{ "GFP_NORETRY",		"NR" },
-	{ "GFP_COMP",			"C" },
-	{ "GFP_ZERO",			"Z" },
-	{ "GFP_NOMEMALLOC",		"NMA" },
-	{ "GFP_MEMALLOC",		"MA" },
-	{ "GFP_HARDWALL",		"HW" },
-	{ "GFP_THISNODE",		"TN" },
-	{ "GFP_RECLAIMABLE",		"RC" },
-	{ "GFP_MOVABLE",		"M" },
-	{ "GFP_NOTRACK",		"NT" },
-	{ "GFP_NO_KSWAPD",		"NK" },
-	{ "GFP_OTHER_NODE",		"ON" },
 	{ "GFP_NOWAIT",			"NW" },
+	{ "GFP_DMA",			"D" },
+	{ "__GFP_HIGHMEM",		"HM" },
+	{ "GFP_DMA32",			"D32" },
+	{ "__GFP_HIGH",			"H" },
+	{ "__GFP_ATOMIC",		"_A" },
+	{ "__GFP_IO",			"I" },
+	{ "__GFP_FS",			"F" },
+	{ "__GFP_COLD",			"CO" },
+	{ "__GFP_NOWARN",		"NWR" },
+	{ "__GFP_REPEAT",		"R" },
+	{ "__GFP_NOFAIL",		"NF" },
+	{ "__GFP_NORETRY",		"NR" },
+	{ "__GFP_COMP",			"C" },
+	{ "__GFP_ZERO",			"Z" },
+	{ "__GFP_NOMEMALLOC",		"NMA" },
+	{ "__GFP_MEMALLOC",		"MA" },
+	{ "__GFP_HARDWALL",		"HW" },
+	{ "__GFP_THISNODE",		"TN" },
+	{ "__GFP_RECLAIMABLE",		"RC" },
+	{ "__GFP_MOVABLE",		"M" },
+	{ "__GFP_ACCOUNT",		"AC" },
+	{ "__GFP_NOTRACK",		"NT" },
+	{ "__GFP_WRITE",		"WR" },
+	{ "__GFP_RECLAIM",		"R" },
+	{ "__GFP_DIRECT_RECLAIM",	"DR" },
+	{ "__GFP_KSWAPD_RECLAIM",	"KR" },
+	{ "__GFP_OTHER_NODE",		"ON" },
 };
 
 static size_t max_gfp_len;
_

Patches currently in -mm which might be from vbabka@suse.cz are

tracepoints-move-trace_print_flags-definitions-to-tracepoint-defsh.patch
mm-tracing-make-show_gfp_flags-up-to-date.patch
tools-perf-make-gfp_compact_table-up-to-date.patch
mm-tracing-unify-mm-flags-handling-in-tracepoints-and-printk.patch
mm-printk-introduce-new-format-string-for-flags.patch
mm-debug-replace-dump_flags-with-the-new-printk-formats.patch
mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch
mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch
mm-page_owner-print-migratetype-of-page-and-pageblock-symbolic-flags.patch
mm-page_owner-convert-page_owner_inited-to-static-key.patch
mm-page_owner-copy-page-owner-info-during-migration.patch
mm-page_owner-track-and-print-last-migrate-reason.patch
mm-page_owner-dump-page-owner-info-from-dump_page.patch
mm-debug-move-bad-flags-printing-to-bad_page.patch

