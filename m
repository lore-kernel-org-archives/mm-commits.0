From: akpm@linux-foundation.org
Subject: [merged] lib-dynamic_debug-use-kbasename.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:05:59 -0800
Message-ID: <20121218200600.0B4A420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:40736 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab2LRUGC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:06:02 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so63271bkc.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:06:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, jbaron@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: dynamic_debug: use kbasename()
has been removed from the -mm tree.  Its filename was
     lib-dynamic_debug-use-kbasename.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib: dynamic_debug: use kbasename()

Remove the custom implementation of the functionality similar to kbasename().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jason Baron <jbaron@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dynamic_debug.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff -puN lib/dynamic_debug.c~lib-dynamic_debug-use-kbasename lib/dynamic_debug.c
--- a/lib/dynamic_debug.c~lib-dynamic_debug-use-kbasename
+++ a/lib/dynamic_debug.c
@@ -62,13 +62,6 @@ static LIST_HEAD(ddebug_tables);
 static int verbose = 0;
 module_param(verbose, int, 0644);
 
-/* Return the last part of a pathname */
-static inline const char *basename(const char *path)
-{
-	const char *tail = strrchr(path, '/');
-	return tail ? tail+1 : path;
-}
