From: akpm@linux-foundation.org
Subject: + mm-fix-some-typos-in-mm-zsmallocc.patch added to -mm tree
Date: Mon, 09 Jan 2017 15:00:15 -0800
Message-ID: <587415ff.oMC19APAXgXXqnJc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44592 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764272AbdAIW6s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2017 17:58:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix some typos in mm/zsmalloc.c
has been added to the -mm tree.  Its filename is
     mm-fix-some-typos-in-mm-zsmallocc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-some-typos-in-mm-zsmallocc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-some-typos-in-mm-zsmallocc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm: fix some typos in mm/zsmalloc.c

Delete extra semicolon, and fix some typos.

Link: http://lkml.kernel.org/r/586F1823.4050107@huawei.com
Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/zsmalloc.c~mm-fix-some-typos-in-mm-zsmallocc mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-fix-some-typos-in-mm-zsmallocc
+++ a/mm/zsmalloc.c
@@ -25,7 +25,7 @@
  * Usage of struct page flags:
  *	PG_private: identifies the first component page
  *	PG_private2: identifies the last component page
- *	PG_owner_priv_1: indentifies the huge component page
+ *	PG_owner_priv_1: identifies the huge component page
  *
  */
 
@@ -364,7 +364,7 @@ static struct zspage *cache_alloc_zspage
 {
 	return kmem_cache_alloc(pool->zspage_cachep,
 			flags & ~(__GFP_HIGHMEM|__GFP_MOVABLE));
-};
+}
 
 static void cache_free_zspage(struct zs_pool *pool, struct zspage *zspage)
 {
@@ -2383,7 +2383,7 @@ struct zs_pool *zs_create_pool(const cha
 		goto err;
 
 	/*
-	 * Iterate reversly, because, size of size_class that we want to use
+	 * Iterate reversely, because, size of size_class that we want to use
 	 * for merging should be larger or equal to current size.
 	 */
 	for (i = zs_size_classes - 1; i >= 0; i--) {
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

mm-fix-some-typos-in-mm-zsmallocc.patch

