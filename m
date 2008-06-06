From: akpm@linux-foundation.org
Subject: - pagemap-fix-bug-in-add_to_pagemap-require-aligned-length-reads-of-proc-pid-pagemap-v2-of-series-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 05 Jun 2008 22:44:43 -0700
Message-ID: <200806060544.m565ihat015779@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752739AbYFFFpt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2008 01:45:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mpm@selenic.com, stable@kernel.org, ttuttle@google.com, mm-commits@vger.kernel.org


The patch titled
     pagemap-fix-bug-in-add_to_pagemap-require-aligned-length-reads-of-proc-pid-pagemap-v2-of-series-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     pagemap-fix-bug-in-add_to_pagemap-require-aligned-length-reads-of-proc-pid-pagemap-v2-of-series-checkpatch-fixes.patch

This patch was dropped because it was folded into pagemap-fix-bug-in-add_to_pagemap-require-aligned-length-reads-of-proc-pid-pagemap-v2-of-series.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pagemap-fix-bug-in-add_to_pagemap-require-aligned-length-reads-of-proc-pid-pagemap-v2-of-series-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "(foo*)" should be "(foo *)"
#70: FILE: fs/proc/task_mmu.c:657:
+	pm.out = (u64*)buf;

ERROR: "(foo*)" should be "(foo *)"
#71: FILE: fs/proc/task_mmu.c:658:
+	pm.end = (u64*)(buf + count);

ERROR: "(foo*)" should be "(foo *)"
#80: FILE: fs/proc/task_mmu.c:683:
+		*ppos += (char*)pm.out - buf;

ERROR: "(foo*)" should be "(foo *)"
#83: FILE: fs/proc/task_mmu.c:685:
+			ret = (char*)pm.out - buf;

total: 4 errors, 0 warnings, 61 lines checked

./patches/pagemap-fix-bug-in-add_to_pagemap-require-aligned-length-reads-of-proc-pid-pagemap-v2-of-series.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Matt Mackall <mpm@selenic.com>
Cc: Thomas Tuttle <ttuttle@google.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/proc/task_mmu.c~pagemap-fix-bug-in-add_to_pagemap-require-aligned-length-reads-of-proc-pid-pagemap-v2-of-series-checkpatch-fixes fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-fix-bug-in-add_to_pagemap-require-aligned-length-reads-of-proc-pid-pagemap-v2-of-series-checkpatch-fixes
+++ a/fs/proc/task_mmu.c
@@ -654,8 +654,8 @@ static ssize_t pagemap_read(struct file 
 		goto out_pages;
 	}
 
-	pm.out = (u64*)buf;
-	pm.end = (u64*)(buf + count);
+	pm.out = (u64 *)buf;
+	pm.end = (u64 *)(buf + count);
 
 	if (!ptrace_may_attach(task)) {
 		ret = -EIO;
@@ -680,9 +680,9 @@ static ssize_t pagemap_read(struct file 
 		if (ret == PM_END_OF_BUFFER)
 			ret = 0;
 		/* don't need mmap_sem for these, but this looks cleaner */
-		*ppos += (char*)pm.out - buf;
+		*ppos += (char *)pm.out - buf;
 		if (!ret)
-			ret = (char*)pm.out - buf;
+			ret = (char *)pm.out - buf;
 	}
 
 out_pages:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

pagemap-fix-bug-in-add_to_pagemap-require-aligned-length-reads-of-proc-pid-pagemap-v2-of-series.patch
pagemap-fix-bug-in-add_to_pagemap-require-aligned-length-reads-of-proc-pid-pagemap-v2-of-series-checkpatch-fixes.patch
rtc-class-driver-for-ppc_md-rtc-functions.patch
proc-calculate-the-correct-proc-pid-link-count.patch

