From: akpm@linux-foundation.org
Subject: [to-be-updated] writeback-guard-against-jiffies-wraparound-on-inode-dirtied_when-checks-try-2.patch removed from -mm tree
Date: Wed, 01 Apr 2009 12:20:07 -0700
Message-ID: <200904011920.n31JK77G020799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932840AbZDATXZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:23:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, fengguang.wu@intel.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     writeback: guard against jiffies wraparound on inode->dirtied_when checks (try #2)
has been removed from the -mm tree.  Its filename was
     writeback-guard-against-jiffies-wraparound-on-inode-dirtied_when-checks-try-2.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback: guard against jiffies wraparound on inode->dirtied_when checks (try #2)
From: Jeff Layton <jlayton@redhat.com>

This is the second version of this patch. The only difference from the
first version is the addition of some comments.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff -puN fs/fs-writeback.c~writeback-guard-against-jiffies-wraparound-on-inode-dirtied_when-checks-try-2 fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-guard-against-jiffies-wraparound-on-inode-dirtied_when-checks-try-2
+++ a/fs/fs-writeback.c
@@ -196,6 +196,10 @@ static void redirty_tail(struct inode *i
 		struct inode *tail_inode;
 
 		tail_inode = list_entry(sb->s_dirty.next, struct inode, i_list);
+		/*
+		 * must also check whether dirtied_when appears to be in the
+		 * future, in which case it's actually in the distant past.
+		 */
 		if (time_before(inode->dirtied_when,
 				tail_inode->dirtied_when) ||
 		    time_after(inode->dirtied_when, jiffies))
@@ -231,6 +235,10 @@ static void move_expired_inodes(struct l
 	while (!list_empty(delaying_queue)) {
 		struct inode *inode = list_entry(delaying_queue->prev,
 						struct inode, i_list);
+		/*
+		 * must also check whether dirtied_when appears to be in the
+		 * future, in which case it's actually in the distant past.
+		 */
 		if (older_than_this &&
 			time_after(inode->dirtied_when, *older_than_this) &&
 			time_before_eq(inode->dirtied_when, jiffies))
@@ -494,7 +502,18 @@ void generic_sync_sb_inodes(struct super
 			continue;		/* blockdev has wrong queue */
 		}
 
-		/* Was this inode dirtied after sync_sb_inodes was called? */
+		/*
+		 * Was this inode dirtied after sync_sb_inodes was called?
+		 *
+		 * It's not sufficient to just do a time_after() check on
+		 * dirtied_when. That assumes that dirtied_when will always
+		 * change within a period of jiffies that encompasses half the
+		 * machine word size (2^31 jiffies on 32-bit arch). That's not
+		 * necessarily the case if an inode is being constantly
+		 * redirtied. Since dirtied_when can never be in the future,
+		 * we can assume that if it appears to be so then it is
+		 * actually in the distant past.
+		 */
 		if (time_after(inode->dirtied_when, start) &&
 		    time_before_eq(inode->dirtied_when, jiffies))
 			break;
_

Patches currently in -mm which might be from jlayton@redhat.com are

origin.patch
writeback-guard-against-jiffies-wraparound-on-inode-dirtied_when-checks-try-2.patch
linux-next.patch

