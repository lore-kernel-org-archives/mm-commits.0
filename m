From: akpm@linux-foundation.org
Subject: - deny-partial-write-for-loop-dev-fd.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:32:20 -0700
Message-ID: <200710162032.l9GKWKxm014589@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54351 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966223AbXJPVtb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:49:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@sw.ru, dmonakhov@openvz.org, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     deny partial write for loop dev fd
has been removed from the -mm tree.  Its filename was
     deny-partial-write-for-loop-dev-fd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: deny partial write for loop dev fd
From: Dmitry Monakhov <dmonakhov@sw.ru>

Partial write can be easily supported by LO_CRYPT_NONE mode, but it is not
easy in LO_CRYPT_CRYPTOAPI case, because of its block nature.  I don't know
who still used cryptoapi, but theoretically it is possible.  So let's leave
things as they are.  Loop device doesn't support partial write before
Nick's "write_begin/write_end" patch set, and let's it behave the same way
after.

Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/block/loop.c~deny-partial-write-for-loop-dev-fd drivers/block/loop.c
--- a/drivers/block/loop.c~deny-partial-write-for-loop-dev-fd
+++ a/drivers/block/loop.c
@@ -245,10 +245,8 @@ static int do_lo_send_aops(struct loop_d
 
 		ret = pagecache_write_end(file, mapping, pos, size, copied,
 							page, fsdata);
-		if (ret < 0)
+		if (ret < 0 || ret != copied)
 			goto fail;
-		if (ret < copied)
-			copied = ret;
 
 		if (unlikely(transfer_result))
 			goto fail;
_

Patches currently in -mm which might be from dmonakhov@sw.ru are

origin.patch
