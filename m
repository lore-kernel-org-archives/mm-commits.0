From: akpm@linux-foundation.org
Subject: + writeback-guard-against-jiffies-wraparound-on-inode-dirtied_when-checks.patch added to -mm tree
Date: Tue, 31 Mar 2009 16:32:29 -0700
Message-ID: <200903312332.n2VNWTWv009483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762125AbZCaXfh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 19:35:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, fengguang.wu@intel.com, raven@themaw.net


The patch titled
     writeback: guard against jiffies wraparound on inode->dirtied_when checks
has been added to the -mm tree.  Its filename is
     writeback-guard-against-jiffies-wraparound-on-inode-dirtied_when-checks.patch

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
Subject: writeback: guard against jiffies wraparound on inode->dirtied_when checks
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
as not to matter.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN fs/fs-writeback.c~writeback-guard-against-jiffies-wraparound-on-inode-dirtied_when-checks fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-guard-against-jiffies-wraparound-on-inode-dirtied_when-checks
+++ a/fs/fs-writeback.c
@@ -196,8 +196,9 @@ static void redirty_tail(struct inode *i
 		struct inode *tail_inode;
 
 		tail_inode = list_entry(sb->s_dirty.next, struct inode, i_list);
-		if (!time_after_eq(inode->dirtied_when,
-				tail_inode->dirtied_when))
+		if (time_before(inode->dirtied_when,
+				tail_inode->dirtied_when) ||
+		    time_after(inode->dirtied_when, jiffies))
 			inode->dirtied_when = jiffies;
 	}
 	list_move(&inode->i_list, &sb->s_dirty);
@@ -231,7 +232,8 @@ static void move_expired_inodes(struct l
 		struct inode *inode = list_entry(delaying_queue->prev,
 						struct inode, i_list);
 		if (older_than_this &&
-			time_after(inode->dirtied_when, *older_than_this))
+			time_after(inode->dirtied_when, *older_than_this) &&
+			time_before_eq(inode->dirtied_when, jiffies))
 			break;
 		list_move(&inode->i_list, dispatch_queue);
 	}
@@ -493,7 +495,8 @@ void generic_sync_sb_inodes(struct super
 		}
 
 		/* Was this inode dirtied after sync_sb_inodes was called? */
-		if (time_after(inode->dirtied_when, start))
+		if (time_after(inode->dirtied_when, start) &&
+		    time_before_eq(inode->dirtied_when, jiffies))
 			break;
 
 		/* Is another pdflush already flushing this queue? */
_

Patches currently in -mm which might be from jlayton@redhat.com are

origin.patch
writeback-guard-against-jiffies-wraparound-on-inode-dirtied_when-checks.patch
linux-next.patch

