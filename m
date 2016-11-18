From: akpm@linux-foundation.org
Subject: + writeback-remove-redundant-if-check.patch added to -mm tree
Date: Fri, 18 Nov 2016 15:55:59 -0800
Message-ID: <582f950f.ZD+4i/tnziTlZrvO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44784 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751713AbcKRX4A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2016 18:56:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tahsin@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/fs-writeback.c: remove redundant if check
has been added to the -mm tree.  Its filename is
     writeback-remove-redundant-if-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/writeback-remove-redundant-if-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/writeback-remove-redundant-if-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

writeback-remove-redundant-if-check.patch

