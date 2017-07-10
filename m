From: akpm@linux-foundation.org
Subject: [patch 094/115] lib/rhashtable.c: use kvzalloc() in
 bucket_table_alloc() when possible
Date: Mon, 10 Jul 2017 15:51:55 -0700
Message-ID: <20170710225155.6a0-gj7fS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43492 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754955AbdGJWv4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:51:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, herbert@gondor.apana.org.au, mhocko@suse.com, mm-commits@vger.kernel.org, tgraf@suug.ch, torvalds@linux-foundation.org

From: Michal Hocko <mhocko@suse.com>
Subject: lib/rhashtable.c: use kvzalloc() in bucket_table_alloc() when possible

bucket_table_alloc() can be currently called with GFP_KERNEL or
GFP_ATOMIC.  For the former we basically have an open coded kvzalloc()
while the later only uses kzalloc().  Let's simplify the code a bit by the
dropping the open coded path and replace it with kvzalloc().

Link: http://lkml.kernel.org/r/20170531155145.17111-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Thomas Graf <tgraf@suug.ch>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rhashtable.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN lib/rhashtable.c~lib-rhashtablec-use-kvzalloc-in-bucket_table_alloc-when-possible lib/rhashtable.c
--- a/lib/rhashtable.c~lib-rhashtablec-use-kvzalloc-in-bucket_table_alloc-when-possible
+++ a/lib/rhashtable.c
@@ -211,11 +211,10 @@ static struct bucket_table *bucket_table
 	int i;
 
 	size = sizeof(*tbl) + nbuckets * sizeof(tbl->buckets[0]);
-	if (size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER) ||
-	    gfp != GFP_KERNEL)
+	if (gfp != GFP_KERNEL)
 		tbl = kzalloc(size, gfp | __GFP_NOWARN | __GFP_NORETRY);
-	if (tbl == NULL && gfp == GFP_KERNEL)
-		tbl = vzalloc(size);
+	else
+		tbl = kvzalloc(size, gfp);
 
 	size = nbuckets;
 
_
