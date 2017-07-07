From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?zswap-delete-an-error-message-for-a-failed-memory-allocatio?=
 =?US-ASCII?Q?n-in-zswap=5Fpool=5Fcreate.patch?= removed from -mm tree
Date: Fri, 07 Jul 2017 12:11:21 -0700
Message-ID: <20170707191121.3KH7phN9v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34662 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751089AbdGGTLW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:11:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, elfring@users.sourceforge.net, mm-commits@vger.kernel.org, sjenning@redhat.com


The patch titled
     Subject: mm/zswap.c: delete an error message for a failed memory allocation in zswap_pool_create()
has been removed from the -mm tree.  Its filename was
     zswap-delete-an-error-message-for-a-failed-memory-allocation-in-zswap_pool_create.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from elfring@users.sourceforge.net are


