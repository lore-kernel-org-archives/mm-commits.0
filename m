From: akpm@linux-foundation.org
Subject: [merged] writeback-guard-against-jiffies-wraparound-on-inode-dirtied_when-checks-try-3.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:32:25 -0700
Message-ID: <200904061932.n36JWPDX010723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755507AbZDFTgE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:36:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, fengguang.wu@intel.com, jens.axboe@oracle.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     writeback: guard against jiffies wraparound on inode->dirtied_when checks (try #3)
has been removed from the -mm tree.  Its filename was
     writeback-guard-against-jiffies-wraparound-on-inode-dirtied_when-checks-try-3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback: guard against jiffies wraparound on inode->dirtied_when checks (try #3)
From: Jeff Layton <jlayton@redhat.com>

The dirtied_when value on an inode is supposed to represent the first time
that an inode has one of its pages dirtied.  This value is in units of
jiffies.  It's used in several places in the writeback code to determine
when to write out an inode.

The problem is that these checks assume that dirtied_when is updated
periodically.  If an inode is continuously being used for I/O it can be
persistently marked as dirty and will continue to age.  Once the time
compared to is greater than or equal to half the maximum of the jiffies
type, the logic of the time_*() macros inverts and the opposite of what is
needed is returned.  On 32-bit architectures that's just under 25 days
(assuming HZ == 1000).

As the least-recently dirtied inode, it'll end up being the first one that
pdflush will try to write out.  sync_sb_inodes does this check:

	/* Was this inode dirtied after sync_sb_inodes was called? */
 	if (time_after(inode->dirtied_when, start))
 		break;

...but now dirtied_when appears to be in the future.  sync_sb_inodes bails
out without attempting to write any dirty inodes.  When this occurs,
pdflush will stop writing out inodes for this superblock.  Nothing can
unwedge it until jiffies moves out of the problematic window.

This patch fixes this problem by changing the checks against dirtied_when
to also check whether it appears to be in the future.  If it does, then we
consider the value to be far in the past.

This should shrink the problematic window of time to such a small period
(30s) as not to matter.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Ian Kent <raven@themaw.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff -puN fs/fs-writeback.c~writeback-guard-against-jiffies-wraparound-on-inode-dirtied_when-checks-try-3 fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-guard-against-jiffies-wraparound-on-inode-dirtied_when-checks-try-3
+++ a/fs/fs-writeback.c
@@ -196,7 +196,7 @@ static void redirty_tail(struct inode *i
 		struct inode *tail_inode;
 
 		tail_inode = list_entry(sb->s_dirty.next, struct inode, i_list);
-		if (!time_after_eq(inode->dirtied_when,
+		if (time_before(inode->dirtied_when,
 				tail_inode->dirtied_when))
 			inode->dirtied_when = jiffies;
 	}
@@ -220,6 +220,21 @@ static void inode_sync_complete(struct i
 	wake_up_bit(&inode->i_state, __I_SYNC);
 }
 
+static bool inode_dirtied_after(struct inode *inode, unsigned long t)
+{
+	bool ret = time_after(inode->dirtied_when, t);
+#ifndef CONFIG_64BIT
+	/*
+	 * For inodes being constantly redirtied, dirtied_when can get stuck.
+	 * It _appears_ to be in the future, but is actually in distant past.
+	 * This test is necessary to prevent such wrapped-around relative times
+	 * from permanently stopping the whole pdflush writeback.
+	 */
+	ret = ret && time_before_eq(inode->dirtied_when, jiffies);
+#endif
+	return ret;
+}
+
 /*
  * Move expired dirty inodes from @delaying_queue to @dispatch_queue.
  */
@@ -231,7 +246,7 @@ static void move_expired_inodes(struct l
 		struct inode *inode = list_entry(delaying_queue->prev,
 						struct inode, i_list);
 		if (older_than_this &&
-			time_after(inode->dirtied_when, *older_than_this))
+		    inode_dirtied_after(inode, *older_than_this))
 			break;
 		list_move(&inode->i_list, dispatch_queue);
 	}
@@ -492,8 +507,11 @@ void generic_sync_sb_inodes(struct super
 			continue;		/* blockdev has wrong queue */
 		}
 
-		/* Was this inode dirtied after sync_sb_inodes was called? */
-		if (time_after(inode->dirtied_when, start))
+		/*
+		 * Was this inode dirtied after sync_sb_inodes was called?
+		 * This keeps sync from extra jobs and livelock.
+		 */
+		if (inode_dirtied_after(inode, start))
 			break;
 
 		/* Is another pdflush already flushing this queue? */
_

Patches currently in -mm which might be from jlayton@redhat.com are

origin.patch
linux-next.patch

