From: akpm@linux-foundation.org
Subject: [merged]
 zsmalloc-dont-test-shrinker_enabled-in-zs_shrinker_count.patch removed from -mm tree
Date: Mon, 09 Nov 2015 11:45:12 -0800
Message-ID: <5640f7c8.4Hs1xYpkRBEs+Tx1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57184 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbbKITpM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:45:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky.work@gmail.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: don't test shrinker_enabled in zs_shrinker_count()
has been removed from the -mm tree.  Its filename was
     zsmalloc-dont-test-shrinker_enabled-in-zs_shrinker_count.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: zsmalloc: don't test shrinker_enabled in zs_shrinker_count()

We don't let user to disable shrinker in zsmalloc (once it's been
enabled), so no need to check ->shrinker_enabled in zs_shrinker_count(),
at the moment at least.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-dont-test-shrinker_enabled-in-zs_shrinker_count mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-dont-test-shrinker_enabled-in-zs_shrinker_count
+++ a/mm/zsmalloc.c
@@ -1823,9 +1823,6 @@ static unsigned long zs_shrinker_count(s
 	struct zs_pool *pool = container_of(shrinker, struct zs_pool,
 			shrinker);
 
-	if (!pool->shrinker_enabled)
-		return 0;
