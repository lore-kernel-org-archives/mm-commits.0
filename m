From: akpm@linux-foundation.org
Subject: [merged] sys_swapon-remove-did_down-variable.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:37:26 -0700
Message-ID: <201103232041.p2NKf2ZK028594@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756181Ab1CWUzQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     sys_swapon: remove did_down variable
has been removed from the -mm tree.  Its filename was
     sys_swapon-remove-did_down-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_swapon: remove did_down variable
From: Cesar Eduardo Barros <cesarb@cesarb.net>

Since mutex_lock(&inode->i_mutex) is called just after setting inode,
did_down is always equivalent to (inode && S_ISREG(inode->i_mode)).

Use this fact to remove the did_down variable.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN mm/swapfile.c~sys_swapon-remove-did_down-variable mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-remove-did_down-variable
+++ a/mm/swapfile.c
@@ -1907,7 +1907,6 @@ SYSCALL_DEFINE2(swapon, const char __use
 	unsigned char *swap_map = NULL;
 	struct page *page = NULL;
 	struct inode *inode = NULL;
-	int did_down = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -1962,7 +1961,6 @@ SYSCALL_DEFINE2(swapon, const char __use
 	} else if (S_ISREG(inode->i_mode)) {
 		p->bdev = inode->i_sb->s_bdev;
 		mutex_lock(&inode->i_mutex);
-		did_down = 1;
 		if (IS_SWAPFILE(inode)) {
 			error = -EBUSY;
 			goto bad_swap;
@@ -2154,10 +2152,8 @@ bad_swap_2:
 	spin_unlock(&swap_lock);
 	vfree(swap_map);
 	if (swap_file) {
-		if (did_down) {
+		if (inode && S_ISREG(inode->i_mode))
 			mutex_unlock(&inode->i_mutex);
-			did_down = 0;
-		}
 		filp_close(swap_file, NULL);
 	}
 out:
@@ -2167,7 +2163,7 @@ out:
 	}
 	if (name)
 		putname(name);
-	if (did_down) {
+	if (inode && S_ISREG(inode->i_mode)) {
 		if (!error)
 			inode->i_flags |= S_SWAPFILE;
 		mutex_unlock(&inode->i_mutex);
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch

