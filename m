From: akpm@linux-foundation.org
Subject: [merged] kernel-trace-trace_events_filterc-use-strreplace.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:48:07 -0700
Message-ID: <5591af07.zQZkw6kjoG0rKhNl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50923 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbbF2UsH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:48:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/trace/trace_events_filter.c: use strreplace()
has been removed from the -mm tree.  Its filename was
     kernel-trace-trace_events_filterc-use-strreplace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2082,7 +2082,7 @@ struct function_filter_data {
 static char **
 ftrace_function_filter_re(char *buf, int len, int *count)
 {
-	char *str, *sep, **re;
+	char *str, **re;
 
 	str = kstrndup(buf, len, GFP_KERNEL);
 	if (!str)
@@ -2092,8 +2092,7 @@ ftrace_function_filter_re(char *buf, int
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

origin.patch
linux-next.patch

