From: akpm@linux-foundation.org
Subject: [merged] writeback-remove-redundant-if-check.patch removed from
 -mm tree
Date: Wed, 14 Dec 2016 11:25:08 -0800
Message-ID: <58519c94.8RsEmPq+uuHV/6H1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44416 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752210AbcLNTZJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:25:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tahsin@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/fs-writeback.c: remove redundant if check
has been removed from the -mm tree.  Its filename was
     writeback-remove-redundant-if-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tahsin Erdogan <tahsin@google.com>
Subject: fs/fs-writeback.c: remove redundant if check

b_more_io non-empty check is already preceded by an opposite check.

Link: http://lkml.kernel.org/r/1478591249-30641-1-git-send-email-tahsin@google.com
Signed-off-by: Tahsin Erdogan <tahsin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN fs/fs-writeback.c~writeback-remove-redundant-if-check fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-remove-redundant-if-check
+++ a/fs/fs-writeback.c
@@ -1769,15 +1769,13 @@ static long wb_writeback(struct bdi_writ
 		 * become available for writeback. Otherwise
 		 * we'll just busyloop.
 		 */
-		if (!list_empty(&wb->b_more_io))  {
-			trace_writeback_wait(wb, work);
-			inode = wb_inode(wb->b_more_io.prev);
-			spin_lock(&inode->i_lock);
-			spin_unlock(&wb->list_lock);
-			/* This function drops i_lock... */
-			inode_sleep_on_writeback(inode);
-			spin_lock(&wb->list_lock);
-		}
+		trace_writeback_wait(wb, work);
+		inode = wb_inode(wb->b_more_io.prev);
+		spin_lock(&inode->i_lock);
+		spin_unlock(&wb->list_lock);
+		/* This function drops i_lock... */
+		inode_sleep_on_writeback(inode);
+		spin_lock(&wb->list_lock);
 	}
 	spin_unlock(&wb->list_lock);
 	blk_finish_plug(&plug);
_

Patches currently in -mm which might be from tahsin@google.com are


