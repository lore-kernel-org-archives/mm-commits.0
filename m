From: akpm@linux-foundation.org
Subject: + kernel-trace-trace_events_filterc-use-strreplace.patch added to -mm tree
Date: Tue, 09 Jun 2015 14:02:56 -0700
Message-ID: <55775480.zj3jLsUYFZBg8Ewj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33966 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964811AbbFIVC5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2015 17:02:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/trace/trace_events_filter.c: use strreplace()
has been added to the -mm tree.  Its filename is
     kernel-trace-trace_events_filterc-use-strreplace.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-trace-trace_events_filterc-use-strreplace.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-trace-trace_events_filterc-use-strreplace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: kernel/trace/trace_events_filter.c: use strreplace()

There's no point in starting over every time we see a ','...

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/trace_events_filter.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/trace/trace_events_filter.c~kernel-trace-trace_events_filterc-use-strreplace kernel/trace/trace_events_filter.c
--- a/kernel/trace/trace_events_filter.c~kernel-trace-trace_events_filterc-use-strreplace
+++ a/kernel/trace/trace_events_filter.c
@@ -2075,7 +2075,7 @@ struct function_filter_data {
 static char **
 ftrace_function_filter_re(char *buf, int len, int *count)
 {
-	char *str, *sep, **re;
+	char *str, **re;
 
 	str = kstrndup(buf, len, GFP_KERNEL);
 	if (!str)
@@ -2085,8 +2085,7 @@ ftrace_function_filter_re(char *buf, int
 	 * The argv_split function takes white space
 	 * as a separator, so convert ',' into spaces.
 	 */
-	while ((sep = strchr(str, ',')))
-		*sep = ' ';
+	strreplace(str, ',', ' ');
 
 	re = argv_split(GFP_KERNEL, str, count);
 	kfree(str);
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

linux-slabh-fix-three-off-by-one-typos-in-comment.patch
mm-only-define-hashdist-variable-when-needed.patch
__bitmap_parselist-fix-bug-in-empty-string-handling.patch
lib-sort-add-64-bit-swap-function.patch
lib-sort-add-64-bit-swap-function-v2.patch
lib-sort-add-64-bit-swap-function-v2-fix.patch
lib-string-introduce-strreplace.patch
kernel-trace-trace_events_filterc-use-strreplace.patch
blktrace-use-strreplace-in-do_blk_trace_setup.patch
lib-kobjectc-use-strreplace.patch
drivers-base-corec-use-strreplace.patch
drivers-md-mdc-use-strreplace.patch
fs-jbd2-journalc-use-strreplace.patch
fs-ext4-superc-use-strreplace-in-ext4_fill_super.patch
checkpatch-avoid-not_unified_diff-errors-on-cover-letterpatch-files.patch
linux-next.patch

