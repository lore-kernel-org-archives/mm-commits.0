From: akpm@linux-foundation.org
Subject: + fs-writeback-check-sync-bit-earlier-in-inode_wait_for_writeback.patch added to -mm tree
Date: Wed, 21 Apr 2010 17:29:03 -0700
Message-ID: <201004220029.o3M0T31t018969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754093Ab0DVAaE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Apr 2010 20:30:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@rsk.demon.co.uk, fengguang.wu@intel.com, jens.axboe@oracle.com, viro@zeniv.linux.org.uk


The patch titled
     fs-writeback: check sync bit earlier in inode_wait_for_writeback
has been added to the -mm tree.  Its filename is
     fs-writeback-check-sync-bit-earlier-in-inode_wait_for_writeback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs-writeback: check sync bit earlier in inode_wait_for_writeback
From: Richard Kennedy <richard@rsk.demon.co.uk>

When wb_writeback() hasn't written anything it will re-acquire the inode
lock before calling inode_wait_for_writeback.

This change tests the sync bit first so that is doesn't need to drop &
re-acquire the lock if the inode became available while wb_writeback() was
waiting to get the lock.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/fs-writeback.c~fs-writeback-check-sync-bit-earlier-in-inode_wait_for_writeback fs/fs-writeback.c
--- a/fs/fs-writeback.c~fs-writeback-check-sync-bit-earlier-in-inode_wait_for_writeback
+++ a/fs/fs-writeback.c
@@ -397,11 +397,11 @@ static void inode_wait_for_writeback(str
 	wait_queue_head_t *wqh;
 
 	wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
-	do {
+	 while (inode->i_state & I_SYNC) {
 		spin_unlock(&inode_lock);
 		__wait_on_bit(wqh, &wq, inode_wait, TASK_UNINTERRUPTIBLE);
 		spin_lock(&inode_lock);
-	} while (inode->i_state & I_SYNC);
+	}
 }
 
 /*
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

linux-next.patch
buffer_head-remove-redundant-test-from-wait_on_buffer.patch
buffer_head-remove-redundant-test-from-wait_on_buffer-fix.patch
wait_on_buffer-remove-the-buffer_locked-test.patch
fs-writeback-check-sync-bit-earlier-in-inode_wait_for_writeback.patch

