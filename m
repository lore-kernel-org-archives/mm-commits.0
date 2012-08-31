From: akpm@linux-foundation.org
Subject: [to-be-updated] rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix-perf-compilation.patch removed from -mm tree
Date: Fri, 31 Aug 2012 12:42:41 -0700
Message-ID: <20120831194242.59D0620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:32913 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab2HaTmo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Aug 2012 15:42:44 -0400
Received: by weyr1 with SMTP id r1so171900wey.1
        for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2012 12:42:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.shishkin@linux.intel.com, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix-perf-compilation
has been removed from the -mm tree.  Its filename was
     rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix-perf-compilation.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix-perf-compilation

Commit 2cfaf9cc68190c24fdd05e4d104099b3f27c7a44 (rbtree: adjust root color
in rb_insert_color() only when necessary) introduces bool type and constants
to the rbtree.c, and breaks compilation of tools/perf:

../../lib/rbtree.c: In function `rb_insert_color':
../../lib/rbtree.c:95:9: error: `true' undeclared (first use in this function)
../../lib/rbtree.c:95:9: note: each undeclared identifier is reported only once
or each function it appears in
../../lib/rbtree.c: In function `__rb_erase_color':
../../lib/rbtree.c:216:9: error: `true' undeclared (first use in this function)
../../lib/rbtree.c: In function `rb_erase':
../../lib/rbtree.c:368:2: error: unknown type name `bool'
make: *** [util/rbtree.o] Error 1

This patch is the easiest solution I can think of.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Acked-by: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/perf/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/perf/Makefile~rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix-perf-compilation tools/perf/Makefile
--- a/tools/perf/Makefile~rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix-perf-compilation
+++ a/tools/perf/Makefile
@@ -806,7 +806,7 @@ $(OUTPUT)ui/browsers/map.o: ui/browsers/
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
 $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' -include stdbool.h $<
 
 $(OUTPUT)util/parse-events.o: util/parse-events.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Wno-redundant-decls $<
_

Patches currently in -mm which might be from alexander.shishkin@linux.intel.com are


