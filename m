From: akpm@linux-foundation.org
Subject: [merged]
 lib-scatterlist-adjust-indentation-in-__sg_alloc_table.patch removed from
 -mm tree
Date: Fri, 31 Jan 2020 15:20:30 -0800
Message-ID: <20200131232030.ugUkQRfv0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXUb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:20:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, natechancellor@gmail.com


The patch titled
     Subject: lib/scatterlist.c: adjust indentation in __sg_alloc_table
has been removed from the -mm tree.  Its filename was
     lib-scatterlist-adjust-indentation-in-__sg_alloc_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nathan Chancellor <natechancellor@gmail.com>
Subject: lib/scatterlist.c: adjust indentation in __sg_alloc_table

Clang warns:

../lib/scatterlist.c:314:5: warning: misleading indentation; statement
is not part of the previous 'if' [-Wmisleading-indentation]
                        return -ENOMEM;
                        ^
../lib/scatterlist.c:311:4: note: previous statement is here
                        if (prv)
                        ^
1 warning generated.

This warning occurs because there is a space before the tab on this line. 
Remove it so that the indentation is consistent with the Linux kernel
coding style and clang no longer warns.

Link: http://lkml.kernel.org/r/20191218033606.11942-1-natechancellor@gmail.com
Link: https://github.com/ClangBuiltLinux/linux/issues/830
Fixes: edce6820a9fd ("scatterlist: prevent invalid free when alloc fails")
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/scatterlist.c~lib-scatterlist-adjust-indentation-in-__sg_alloc_table
+++ a/lib/scatterlist.c
@@ -311,7 +311,7 @@ int __sg_alloc_table(struct sg_table *ta
 			if (prv)
 				table->nents = ++table->orig_nents;
 
- 			return -ENOMEM;
+			return -ENOMEM;
 		}
 
 		sg_init_table(sg, alloc_size);
_

Patches currently in -mm which might be from natechancellor@gmail.com are

ipc-consolidate-all-xxxctl_down-functions-fix.patch
