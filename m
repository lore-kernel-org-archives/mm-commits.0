From: akpm@linux-foundation.org
Subject: - git-block-dupe-definitions.patch removed from -mm tree
Date: Sat, 21 Apr 2007 21:59:31 -0700
Message-ID: <200704220502.l3M527r0019929@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754098AbXDVFCu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Apr 2007 01:02:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: grant_lkml@dodo.com.au, gcoady.lk@gmail.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     git-block: dupe definitions
has been removed from the -mm tree.  Its filename was
     git-block-dupe-definitions.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-block: dupe definitions
From: Grant Coady <grant_lkml@dodo.com.au>

In file included from kernel/sched.c:39:
include/linux/blkdev.h:928: error: redefinition of 'blk_replug_current_nested'
include/linux/blkdev.h:907: error: previous definition of 'blk_replug_current_nested' was here
include/linux/blkdev.h:932: error: redefinition of 'blk_plug_current'
include/linux/blkdev.h:911: error: previous definition of 'blk_plug_current' was here
include/linux/blkdev.h:936: error: redefinition of 'blk_unplug_current'
include/linux/blkdev.h:915: error: previous definition of 'blk_unplug_current' was here
include/linux/blkdev.h:940: error: redefinition of 'blk_unplug_current_nested'
include/linux/blkdev.h:919: error: previous definition of 'blk_unplug_current_nested' was here
include/linux/blkdev.h:945: error: redefinition of 'blk_plug_current_nested'
include/linux/blkdev.h:924: error: previous definition of 'blk_plug_current_nested' was here
make[1]: *** [kernel/sched.o] Error 1
make: *** [kernel] Error 2

Signed-off-by: Grant Coady <gcoady.lk@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/blkdev.h |   21 ---------------------
 1 file changed, 21 deletions(-)

diff -puN include/linux/blkdev.h~git-block-dupe-definitions include/linux/blkdev.h
--- a/include/linux/blkdev.h~git-block-dupe-definitions
+++ a/include/linux/blkdev.h
@@ -902,27 +902,6 @@ static inline void exit_io_context(void)
 {
 }
 
-static inline void blk_replug_current_nested(void)
-{
-}
-
-static inline void blk_plug_current(void)
-{
-}
-
-static inline void blk_unplug_current(void)
-{
-}
-
-static inline int blk_unplug_current_nested(void)
-{
-	return 0;
-}
-
-static inline void blk_plug_current_nested(int depth)
-{
-}
-
 #endif /* CONFIG_BLOCK */
 
 #endif
_

Patches currently in -mm which might be from grant_lkml@dodo.com.au are
