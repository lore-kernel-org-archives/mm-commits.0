From: akpm@linux-foundation.org
Subject: + rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix-perf-compilation.patch added to -mm tree
Date: Wed, 15 Aug 2012 16:35:14 -0700
Message-ID: <20120815233514.EADEB1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:46091 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab2HOXfQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Aug 2012 19:35:16 -0400
Received: by obbwc20 with SMTP id wc20so1541755obb.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 16:35:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexander.shishkin@linux.intel.com, walken@google.com


The patch titled
     Subject: rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix-perf-compilation
has been added to the -mm tree.  Its filename is
     rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix-perf-compilation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix-perf-compilation.patch

