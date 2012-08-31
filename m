From: akpm@linux-foundation.org
Subject: + rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix.patch added to -mm tree
Date: Fri, 31 Aug 2012 12:44:17 -0700
Message-ID: <20120831194417.EEF591E0049@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:52557 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab2HaToT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Aug 2012 15:44:19 -0400
Received: by qcqs25 with SMTP id s25so380644qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2012 12:44:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adrian.hunter@intel.com, alexander.shishkin@intel.com, walken@google.com


The patch titled
     Subject: perf tools: fix build for another rbtree.c change
has been added to the -mm tree.  Its filename is
     rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Adrian Hunter <adrian.hunter@intel.com>
Subject: perf tools: fix build for another rbtree.c change

Fixes:

../../lib/rbtree.c: In function 'rb_insert_color':
../../lib/rbtree.c:95:9: error: 'true' undeclared (first use in this function)
../../lib/rbtree.c:95:9: note: each undeclared identifier is reported only once for each function it appears in
../../lib/rbtree.c: In function '__rb_erase_color':
../../lib/rbtree.c:216:9: error: 'true' undeclared (first use in this function)
../../lib/rbtree.c: In function 'rb_erase':
../../lib/rbtree.c:368:2: error: unknown type name 'bool'
make: *** [util/rbtree.o] Error 1

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Michel Lespinasse <walken@google.com>
Reported-by: Alexander Shishkin <alexander.shishkin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/perf/util/include/linux/rbtree.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN tools/perf/util/include/linux/rbtree.h~rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix tools/perf/util/include/linux/rbtree.h
--- a/tools/perf/util/include/linux/rbtree.h~rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix
+++ a/tools/perf/util/include/linux/rbtree.h
@@ -1 +1,2 @@
+#include <stdbool.h>
 #include "../../../../include/linux/rbtree.h"
_

Patches currently in -mm which might be from adrian.hunter@intel.com are

rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix.patch

