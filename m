From: akpm@osdl.org
Subject: + git-block-dupe-definitions.patch added to -mm tree
Date: Tue, 30 Jan 2007 14:02:44 -0800
Message-ID: <200701302202.l0UM2iYg030646@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53336 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbXA3WCv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 17:02:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: grant_lkml@dodo.com.au, gcoady.lk@gmail.com, jens.axboe@oracle.com


The patch titled
     git-block: dupe definitions
has been added to the -mm tree.  Its filename is
     git-block-dupe-definitions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/blkdev.h |   21 ---------------------
 1 files changed, 21 deletions(-)

diff -puN include/linux/blkdev.h~git-block-dupe-definitions include/linux/blkdev.h
--- a/include/linux/blkdev.h~git-block-dupe-definitions
+++ a/include/linux/blkdev.h
@@ -924,27 +924,6 @@ static inline void blk_plug_current_nest
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

git-block-dupe-definitions.patch
