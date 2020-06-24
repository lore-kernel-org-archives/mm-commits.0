From: akpm@linux-foundation.org
Subject: + mm-filemap-clear-idle-flag-for-writes.patch added to -mm
 tree
Date: Wed, 24 Jun 2020 13:15:05 -0700
Message-ID: <20200624201505.vMV99%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406318AbgFXUPH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 16:15:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shakeelb@google.com, riel@surriel.com, hannes@cmpxchg.org, gavin.dg@linux.alibaba.com, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm: filemap: clear idle flag for writes
has been added to the -mm tree.  Its filename is
     mm-filemap-clear-idle-flag-for-writes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-clear-idle-flag-for-writes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-clear-idle-flag-for-writes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: filemap: clear idle flag for writes

Since commit bbddabe2e436aa ("mm: filemap: only do access activations on
reads"), mark_page_accessed() is called for reads only.  But the idle flag
is cleared by mark_page_accessed() so the idle flag won't get cleared if
the page is write accessed only.

Basically idle page tracking is used to estimate workingset size of
workload, noticeable size of workingset might be missed if the idle flag
is not maintained correctly.

It seems good enough to just clear idle flag for write operations.

Link: http://lkml.kernel.org/r/1593020612-13051-1-git-send-email-yang.shi@linux.alibaba.com
Fixes: bbddabe2e436 ("mm: filemap: only do access activations on reads")
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Reported-by: Gang Deng <gavin.dg@linux.alibaba.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/filemap.c~mm-filemap-clear-idle-flag-for-writes
+++ a/mm/filemap.c
@@ -41,6 +41,7 @@
 #include <linux/delayacct.h>
 #include <linux/psi.h>
 #include <linux/ramfs.h>
+#include <linux/page_idle.h>
 #include "internal.h"
 
 #define CREATE_TRACE_POINTS
@@ -1630,6 +1631,11 @@ repeat:
 
 	if (fgp_flags & FGP_ACCESSED)
 		mark_page_accessed(page);
+	else if (fgp_flags & FGP_WRITE) {
+		/* Clear idle flag for buffer write */
+		if (page_is_idle(page))
+			clear_page_idle(page);
+	}
 
 no_page:
 	if (!page && (fgp_flags & FGP_CREAT)) {
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

doc-thp-cow-fault-no-longer-allocate-thp.patch
mm-filemap-clear-idle-flag-for-writes.patch
mm-thp-remove-debug_cow-switch.patch
