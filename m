From: akpm@linux-foundation.org
Subject: [patch 090/101] zsmalloc: Delete an unnecessary check before the
 function call "iput"
Date: Thu, 28 Jul 2016 15:48:59 -0700
Message-ID: <579a8bdb.cFR3bRCALTK5fcFc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57255 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbcG1WtA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:49:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, elfring@users.sourceforge.net, minchan@kernel.org, sergey.senozhatsky@gmail.com

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
