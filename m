From: akpm@linux-foundation.org
Subject: + procfs-use-kbasename.patch added to -mm tree
Date: Tue, 16 Oct 2012 14:35:27 -0700
Message-ID: <20121016213528.11B27100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:50254 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab2JPVf3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Oct 2012 17:35:29 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so841478qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 16 Oct 2012 14:35:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andriy.shevchenko@linux.intel.com


The patch titled
     Subject: procfs: use kbasename()
has been added to the -mm tree.  Its filename is
     procfs-use-kbasename.patch

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
Subject: procfs: use kbasename()

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_devtree.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN fs/proc/proc_devtree.c~procfs-use-kbasename fs/proc/proc_devtree.c
--- a/fs/proc/proc_devtree.c~procfs-use-kbasename
+++ a/fs/proc/proc_devtree.c
@@ -13,6 +13,7 @@
 #include <linux/of.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <asm/prom.h>
 #include <asm/uaccess.h>
 #include "internal.h"
@@ -195,11 +196,7 @@ void proc_device_tree_add_node(struct de
 	set_node_proc_entry(np, de);
 	for (child = NULL; (child = of_get_next_child(np, child));) {
 		/* Use everything after the last slash, or the full name */
-		p = strrchr(child->full_name, '/');
-		if (!p)
-			p = child->full_name;
-		else
-			++p;
+		p = kbasename(child->full_name);
 
 		if (duplicate_name(de, p))
 			p = fixup_name(np, de, p);
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

linux-next.patch
string-introduce-helper-to-get-base-file-name-from-given-path.patch
lib-dynamic_debug-use-kbasename.patch
staging-rts_pstor-use-kbasename.patch
mm-use-kbasename.patch
procfs-use-kbasename.patch
trace-use-kbasename.patch

