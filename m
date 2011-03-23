From: akpm@linux-foundation.org
Subject: [merged] sys_swapon-use-a-single-error-label.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:37:34 -0700
Message-ID: <201103232041.p2NKfA7t028612@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756133Ab1CWUzQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     sys_swapon: use a single error label
has been removed from the -mm tree.  Its filename was
     sys_swapon-use-a-single-error-label.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_swapon: use a single error label
From: Cesar Eduardo Barros <cesarb@cesarb.net>

sys_swapon currently has two error labels, bad_swap and bad_swap_2.
bad_swap does the same as bad_swap_2 plus destroy_swap_extents() and
swap_cgroup_swapoff(); both are noops in the places where bad_swap_2 is
jumped to. With a single extra test for inode (matching the one in the
S_ISREG case below), all the error paths in the function can go to
bad_swap.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/swapfile.c~sys_swapon-use-a-single-error-label mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-use-a-single-error-label
+++ a/mm/swapfile.c
@@ -1918,13 +1918,13 @@ SYSCALL_DEFINE2(swapon, const char __use
 	if (IS_ERR(name)) {
 		error = PTR_ERR(name);
 		name = NULL;
-		goto bad_swap_2;
+		goto bad_swap;
 	}
 	swap_file = filp_open(name, O_RDWR|O_LARGEFILE, 0);
 	if (IS_ERR(swap_file)) {
 		error = PTR_ERR(swap_file);
 		swap_file = NULL;
-		goto bad_swap_2;
+		goto bad_swap;
 	}
 
 	p->swap_file = swap_file;
@@ -2141,13 +2141,12 @@ SYSCALL_DEFINE2(swapon, const char __use
 	error = 0;
 	goto out;
 bad_swap:
-	if (S_ISBLK(inode->i_mode) && p->bdev) {
+	if (inode && S_ISBLK(inode->i_mode) && p->bdev) {
 		set_blocksize(p->bdev, p->old_block_size);
 		blkdev_put(p->bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 	}
 	destroy_swap_extents(p);
 	swap_cgroup_swapoff(p->type);
-bad_swap_2:
 	spin_lock(&swap_lock);
 	p->swap_file = NULL;
 	p->flags = 0;
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch

