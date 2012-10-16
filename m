From: akpm@linux-foundation.org
Subject: + trace-use-kbasename.patch added to -mm tree
Date: Tue, 16 Oct 2012 14:35:30 -0700
Message-ID: <20121016213531.152D2100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:37627 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab2JPVfc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Oct 2012 17:35:32 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so61814qae.1
        for <mm-commits@vger.kernel.org>; Tue, 16 Oct 2012 14:35:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andriy.shevchenko@linux.intel.com, fweisbec@gmail.com, rostedt@goodmis.org


The patch titled
     Subject: trace: use kbasename()
has been added to the -mm tree.  Its filename is
     trace-use-kbasename.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
string-introduce-helper-to-get-base-file-name-from-given-path.patch
lib-dynamic_debug-use-kbasename.patch
staging-rts_pstor-use-kbasename.patch
mm-use-kbasename.patch
procfs-use-kbasename.patch
trace-use-kbasename.patch

