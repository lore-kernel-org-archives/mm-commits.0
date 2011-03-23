From: akpm@linux-foundation.org
Subject: [merged] sys_swapon-do-only-cleanup-in-the-cleanup-blocks.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:37:32 -0700
Message-ID: <201103232041.p2NKf8K2028606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933396Ab1CWUls (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:41:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     sys_swapon: do only cleanup in the cleanup blocks
has been removed from the -mm tree.  Its filename was
     sys_swapon-do-only-cleanup-in-the-cleanup-blocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_swapon: do only cleanup in the cleanup blocks
From: Cesar Eduardo Barros <cesarb@cesarb.net>

The only way error is 0 in the cleanup blocks is when the function is
returning successfully. In this case, the cleanup blocks were setting
S_SWAPFILE in the S_ISREG case. But this is not a cleanup.

Move the setting of S_SWAPFILE to just before the "goto out;" to make
this more clear. At this point, we do not need to test for inode because
it will never be NULL.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/swapfile.c~sys_swapon-do-only-cleanup-in-the-cleanup-blocks mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-do-only-cleanup-in-the-cleanup-blocks
+++ a/mm/swapfile.c
@@ -2136,6 +2136,8 @@ SYSCALL_DEFINE2(swapon, const char __use
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
 
+	if (S_ISREG(inode->i_mode))
+		inode->i_flags |= S_SWAPFILE;
 	error = 0;
 	goto out;
 bad_swap:
@@ -2163,11 +2165,8 @@ out:
 	}
 	if (name)
 		putname(name);
-	if (inode && S_ISREG(inode->i_mode)) {
-		if (!error)
-			inode->i_flags |= S_SWAPFILE;
+	if (inode && S_ISREG(inode->i_mode))
 		mutex_unlock(&inode->i_mutex);
-	}
 	return error;
 }
 
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch

