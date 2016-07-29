From: akpm@linux-foundation.org
Subject: [merged]
 zsmalloc-delete-an-unnecessary-check-before-the-function-call-iput.patch
 removed from -mm tree
Date: Fri, 29 Jul 2016 11:57:14 -0700
Message-ID: <579ba70a.eyHtfxQfsVs9vEe0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbcG2S5P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:57:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: Delete an unnecessary check before the function call "iput"
has been removed from the -mm tree.  Its filename was
     zsmalloc-delete-an-unnecessary-check-before-the-function-call-iput.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Markus Elfring <elfring@users.sourceforge.net>
Subject: zsmalloc: Delete an unnecessary check before the function call "iput"

iput() tests whether its argument is NULL and then returns immediately. 
Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Link: http://lkml.kernel.org/r/559cf499-4a01-25f9-c87f-24d906626a57@users.sourceforge.net
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-delete-an-unnecessary-check-before-the-function-call-iput mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-delete-an-unnecessary-check-before-the-function-call-iput
+++ a/mm/zsmalloc.c
@@ -2174,8 +2174,7 @@ static int zs_register_migration(struct
 static void zs_unregister_migration(struct zs_pool *pool)
 {
 	flush_work(&pool->free_work);
-	if (pool->inode)
-		iput(pool->inode);
+	iput(pool->inode);
 }
 
 /*
_

Patches currently in -mm which might be from elfring@users.sourceforge.net are


