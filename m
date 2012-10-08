From: akpm@linux-foundation.org
Subject: [folded-dropped] rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix.patch removed from -mm tree
Date: Mon, 08 Oct 2012 16:06:45 -0700
Message-ID: <20121008230646.47D9620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:60018 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab2JHXGs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 19:06:48 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so295168wey.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 16:06:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrian.hunter@intel.com, alexander.shishkin@intel.com, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: perf tools: fix build for another rbtree.c change
has been removed from the -mm tree.  Its filename was
     rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix.patch

This patch was dropped because it was folded into rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch

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
@@ -1,2 +1,3 @@
 #include <stdbool.h>
+#include <stdbool.h>
 #include "../../../../include/linux/rbtree.h"
_

Patches currently in -mm which might be from adrian.hunter@intel.com are

origin.patch
rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch

