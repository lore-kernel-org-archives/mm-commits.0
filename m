From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 099/118] lib/scatterlist.c: adjust indentation in
 __sg_alloc_table
Date: Thu, 30 Jan 2020 22:16:37 -0800
Message-ID: <20200131061637.JP0DEahQC%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgAaGQj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:16:39 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, natechancellor@gmail.com, torvalds@linux-foundation.org

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
