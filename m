From: akpm@linux-foundation.org
Subject: + lib-dynamic_debug-use-kbasename.patch added to -mm tree
Date: Tue, 16 Oct 2012 14:35:18 -0700
Message-ID: <20121016213519.7636F5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:41540 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab2JPVfW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Oct 2012 17:35:22 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so420561eek.1
        for <mm-commits@vger.kernel.org>; Tue, 16 Oct 2012 14:35:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andriy.shevchenko@linux.intel.com, jbaron@redhat.com


The patch titled
     Subject: lib: dynamic_debug: use kbasename()
has been added to the -mm tree.  Its filename is
     lib-dynamic_debug-use-kbasename.patch

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
