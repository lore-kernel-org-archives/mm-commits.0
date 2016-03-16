From: akpm@linux-foundation.org
Subject: [merged]
 tracepoints-move-trace_print_flags-definitions-to-tracepoint-defsh.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:55:36 -0700
Message-ID: <56e9ba38.w4jEvRAhIZ5NTFG0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38695 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965027AbcCPTzh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:55:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, acme@kernel.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, linux@rasmusvillemoes.dk, mgorman@suse.de, mhocko@suse.com, minchan@kernel.org, mingo@redhat.com, peterz@infradead.org, rientjes@google.com, rostedt@goodmis.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tracepoints: move trace_print_flags definitions to tracepoint-defs.h
has been removed from the -mm tree.  Its filename was
     tracepoints-move-trace_print_flags-definitions-to-tracepoint-defsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: tracepoints: move trace_print_flags definitions to tracepoint-defs.h

The following patch will need to declare array of struct trace_print_flags
in a header.  To prevent this header from pulling in all of RCU through
trace_events.h, move the struct trace_print_flags{_64} definitions to the
new lightweight tracepoint-defs.h header.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
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

 include/linux/trace_events.h    |   10 ----------
 include/linux/tracepoint-defs.h |   14 ++++++++++++--
 2 files changed, 12 insertions(+), 12 deletions(-)

diff -puN include/linux/trace_events.h~tracepoints-move-trace_print_flags-definitions-to-tracepoint-defsh include/linux/trace_events.h
--- a/include/linux/trace_events.h~tracepoints-move-trace_print_flags-definitions-to-tracepoint-defsh
+++ a/include/linux/trace_events.h
@@ -15,16 +15,6 @@ struct tracer;
 struct dentry;
 struct bpf_prog;
 
-struct trace_print_flags {
-	unsigned long		mask;
-	const char		*name;
-};
-
-struct trace_print_flags_u64 {
-	unsigned long long	mask;
-	const char		*name;
-};
-
 const char *trace_print_flags_seq(struct trace_seq *p, const char *delim,
 				  unsigned long flags,
 				  const struct trace_print_flags *flag_array);
diff -puN include/linux/tracepoint-defs.h~tracepoints-move-trace_print_flags-definitions-to-tracepoint-defsh include/linux/tracepoint-defs.h
--- a/include/linux/tracepoint-defs.h~tracepoints-move-trace_print_flags-definitions-to-tracepoint-defsh
+++ a/include/linux/tracepoint-defs.h
@@ -3,13 +3,23 @@
 
 /*
  * File can be included directly by headers who only want to access
- * tracepoint->key to guard out of line trace calls. Otherwise
- * linux/tracepoint.h should be used.
+ * tracepoint->key to guard out of line trace calls, or the definition of
+ * trace_print_flags{_u64}. Otherwise linux/tracepoint.h should be used.
  */
 
 #include <linux/atomic.h>
 #include <linux/static_key.h>
 
+struct trace_print_flags {
+	unsigned long		mask;
+	const char		*name;
+};
+
+struct trace_print_flags_u64 {
+	unsigned long long	mask;
+	const char		*name;
+};
+
 struct tracepoint_func {
 	void *func;
 	void *data;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-kswapd-remove-bogus-check-of-balance_classzone_idx.patch
mm-compaction-introduce-kcompactd.patch
mm-compaction-introduce-kcompactd-fix-3.patch
mm-compaction-introduce-kcompactd-fix-4.patch
mm-memory-hotplug-small-cleanup-in-online_pages.patch
mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd.patch
mm-tracing-refresh-__def_vmaflag_names-fix.patch
mm-use-radix_tree_iter_retry-fix.patch

