From: akpm@linux-foundation.org
Subject: +
 zsmalloc-delete-an-unnecessary-check-before-the-function-call-iput.patch
 added to -mm tree
Date: Mon, 25 Jul 2016 16:33:51 -0700
Message-ID: <5796a1df.6GaaL9tmK2PmJaVE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbcGYXdw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2016 19:33:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: Delete an unnecessary check before the function call "iput"
has been added to the -mm tree.  Its filename is
     zsmalloc-delete-an-unnecessary-check-before-the-function-call-iput.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-delete-an-unnecessary-check-before-the-function-call-iput.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-delete-an-unnecessary-check-before-the-function-call-iput.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2181,8 +2181,7 @@ static int zs_register_migration(struct
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

zsmalloc-delete-an-unnecessary-check-before-the-function-call-iput.patch

