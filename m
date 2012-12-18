From: akpm@linux-foundation.org
Subject: [merged] trace-use-kbasename.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:06:11 -0800
Message-ID: <20121218200611.9A44382004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:49278 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab2LRUGM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:06:12 -0500
Received: by mail-qa0-f73.google.com with SMTP id a19so157630qad.2
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:06:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, fweisbec@gmail.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: trace: use kbasename()
has been removed from the -mm tree.  Its filename was
     trace-use-kbasename.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: trace: use kbasename()

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/trace_uprobe.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/trace/trace_uprobe.c~trace-use-kbasename kernel/trace/trace_uprobe.c
--- a/kernel/trace/trace_uprobe.c~trace-use-kbasename
+++ a/kernel/trace/trace_uprobe.c
@@ -22,6 +22,7 @@
 #include <linux/uaccess.h>
 #include <linux/uprobes.h>
 #include <linux/namei.h>
+#include <linux/string.h>
 
 #include "trace_probe.h"
 
@@ -263,16 +264,15 @@ static int create_trace_uprobe(int argc,
 
 	/* setup a probe */
 	if (!event) {
-		char *tail = strrchr(filename, '/');
+		char *tail;
 		char *ptr;
 
-		ptr = kstrdup((tail ? tail + 1 : filename), GFP_KERNEL);
-		if (!ptr) {
+		tail = kstrdup(kbasename(filename), GFP_KERNEL);
+		if (!tail) {
 			ret = -ENOMEM;
 			goto fail_address_parse;
 		}
 
-		tail = ptr;
 		ptr = strpbrk(tail, ".-_");
 		if (ptr)
 			*ptr = '\0';
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

origin.patch
linux-next.patch

