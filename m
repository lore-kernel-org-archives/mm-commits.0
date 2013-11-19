From: akpm@linux-foundation.org
Subject: +
 dynamic_debug-add-wildcard-support-to-filter-files-functions-modules.patch
 added to -mm tree
Date: Tue, 19 Nov 2013 15:34:20 -0800
Message-ID: <528bf57c.HsqDP6iNtBNjntoP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42608 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab3KSXeV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Nov 2013 18:34:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, jbaron@akamai.com, changbin.du@gmail.com

Subject: + dynamic_debug-add-wildcard-support-to-filter-files-functions-modules.patch added to -mm tree
To: changbin.du@gmail.com,jbaron@akamai.com,joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 19 Nov 2013 15:34:20 -0800


The patch titled
     Subject: dynamic_debug: add wildcard support to filter files/functions/modules
has been added to the -mm tree.  Its filename is
     dynamic_debug-add-wildcard-support-to-filter-files-functions-modules.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dynamic_debug-add-wildcard-support-to-filter-files-functions-modules.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dynamic_debug-add-wildcard-support-to-filter-files-functions-modules.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Du, Changbin" <changbin.du@gmail.com>
Subject: dynamic_debug: add wildcard support to filter files/functions/modules

Add wildcard '*'(matches zero or more characters) and '?' (matches one
character) support when qurying debug flags.

Now we can open debug messages using keywords. eg:
1. open debug logs in all usb drivers
    echo "file drivers/usb/* +p" > <debugfs>/dynamic_debug/control
2.  open debug logs for usb xhci code
    echo "file *xhci* +p" > <debugfs>/dynamic_debug/control

Signed-off-by: Du, Changbin <changbin.du@gmail.com>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dynamic_debug.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN lib/dynamic_debug.c~dynamic_debug-add-wildcard-support-to-filter-files-functions-modules lib/dynamic_debug.c
--- a/lib/dynamic_debug.c~dynamic_debug-add-wildcard-support-to-filter-files-functions-modules
+++ a/lib/dynamic_debug.c
@@ -8,6 +8,7 @@
  * By Greg Banks <gnb@melbourne.sgi.com>
  * Copyright (c) 2008 Silicon Graphics Inc.  All Rights Reserved.
  * Copyright (C) 2011 Bart Van Assche.  All Rights Reserved.
+ * Copyright (C) 2013 Du, Changbin <changbin.du@gmail.com>
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
@@ -24,6 +25,7 @@
 #include <linux/sysctl.h>
 #include <linux/ctype.h>
 #include <linux/string.h>
+#include <linux/parser.h>
 #include <linux/string_helpers.h>
 #include <linux/uaccess.h>
 #include <linux/dynamic_debug.h>
@@ -147,7 +149,8 @@ static int ddebug_change(const struct dd
 	list_for_each_entry(dt, &ddebug_tables, link) {
 
 		/* match against the module name */
-		if (query->module && strcmp(query->module, dt->mod_name))
+		if (query->module &&
+		    !match_wildcard(query->module, dt->mod_name))
 			continue;
 
 		for (i = 0; i < dt->num_ddebugs; i++) {
@@ -155,14 +158,16 @@ static int ddebug_change(const struct dd
 
 			/* match against the source filename */
 			if (query->filename &&
-			    strcmp(query->filename, dp->filename) &&
-			    strcmp(query->filename, kbasename(dp->filename)) &&
-			    strcmp(query->filename, trim_prefix(dp->filename)))
+			    !match_wildcard(query->filename, dp->filename) &&
+			    !match_wildcard(query->filename,
+					   kbasename(dp->filename)) &&
+			    !match_wildcard(query->filename,
+					   trim_prefix(dp->filename)))
 				continue;
 
 			/* match against the function */
 			if (query->function &&
-			    strcmp(query->function, dp->function))
+			    !match_wildcard(query->function, dp->function))
 				continue;
 
 			/* match against the format */
_

Patches currently in -mm which might be from changbin.du@gmail.com are

lib-parserc-add-match_wildcard-function.patch
dynamic_debug-add-wildcard-support-to-filter-files-functions-modules.patch
dynamic-debug-howtotxt-update-since-new-wildcard-support.patch

