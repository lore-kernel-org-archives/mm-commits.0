From: akpm@linux-foundation.org
Subject: [patch 098/108] mm/zswap.c: delete an error message for a
 failed memory allocation in zswap_pool_create()
Date: Thu, 06 Jul 2017 15:40:34 -0700
Message-ID: <20170706224034.cZkxGGWfe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37056 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752891AbdGFWkg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:40:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ddstreet@ieee.org, elfring@users.sourceforge.net, mm-commits@vger.kernel.org, sjenning@redhat.com, torvalds@linux-foundation.org

From: Markus Elfring <elfring@users.sourceforge.net>
Subject: mm/zswap.c: delete an error message for a failed memory allocation in zswap_pool_create()

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Link: http://events.linuxfoundation.org/sites/events/files/slides/LCJ16-Refactor_Strings-WSang_0.pdf
Link: http://lkml.kernel.org/r/2345aabc-ae98-1d31-afba-40a02c5baf3d@users.sourceforge.net
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/zswap.c~zswap-delete-an-error-message-for-a-failed-memory-allocation-in-zswap_pool_create mm/zswap.c
--- a/mm/zswap.c~zswap-delete-an-error-message-for-a-failed-memory-allocation-in-zswap_pool_create
+++ a/mm/zswap.c
@@ -515,10 +515,8 @@ static struct zswap_pool *zswap_pool_cre
 	}
 
 	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
-	if (!pool) {
-		pr_err("pool alloc failed\n");
+	if (!pool)
 		return NULL;
-	}
 
 	/* unique name for each pool specifically required by zsmalloc */
 	snprintf(name, 38, "zswap%x", atomic_inc_return(&zswap_pools_count));
_
