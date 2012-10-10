From: akpm@linux-foundation.org
Subject: + perf-fix-duplicate-header-inclusion.patch added to -mm tree
Date: Wed, 10 Oct 2012 14:10:04 -0700
Message-ID: <20121010211005.04EB9200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:42624 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab2JJVKH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Oct 2012 17:10:07 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so69428fae.1
        for <mm-commits@vger.kernel.org>; Wed, 10 Oct 2012 14:10:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, adrian.hunter@intel.com


The patch titled
     Subject: perf: fix duplicate header inclusion
has been added to the -mm tree.  Its filename is
     perf-fix-duplicate-header-inclusion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: perf: fix duplicate header inclusion

#include <stdbool.h> somehow got duplicated on its way to linus's tree
(probably as a conflict resolution as things got sent through multiple trees)

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/perf/util/include/linux/rbtree.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN tools/perf/util/include/linux/rbtree.h~perf-fix-duplicate-header-inclusion tools/perf/util/include/linux/rbtree.h
--- a/tools/perf/util/include/linux/rbtree.h~perf-fix-duplicate-header-inclusion
+++ a/tools/perf/util/include/linux/rbtree.h
@@ -1,3 +1,2 @@
 #include <stdbool.h>
-#include <stdbool.h>
 #include "../../../../include/linux/rbtree.h"
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
perf-fix-duplicate-header-inclusion.patch

