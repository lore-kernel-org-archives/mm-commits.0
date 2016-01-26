From: akpm@linux-foundation.org
Subject: +
 tracepoints-move-trace_print_flags-definitions-to-tracepoint-defsh.patch
 added to -mm tree
Date: Tue, 26 Jan 2016 13:03:57 -0800
Message-ID: <56a7df3d.5+2kodWka770Ggzk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbcAZVD6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 16:03:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, acme@kernel.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, linux@rasmusvillemoes.dk, mgorman@suse.de, mhocko@suse.com, minchan@kernel.org, mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tracepoints: move trace_print_flags definitions to tracepoint-defs.h
has been added to the -mm tree.  Its filename is
     tracepoints-move-trace_print_flags-definitions-to-tracepoint-defsh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tracepoints-move-trace_print_flags-definitions-to-tracepoint-defsh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tracepoints-move-trace_print_flags-definitions-to-tracepoint-defsh.patch

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
Subject: tracepoints: move trace_print_flags definitions to tracepoint-defs.h

The following patch will need to declare array of struct trace_print_flags
in a header.  To prevent this header from pulling in all of RCU through
trace_events.h, move the struct trace_print_flags{_64} definitions to the
new lightweight tracepoint-defs.h header.

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

