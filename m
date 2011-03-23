From: akpm@linux-foundation.org
Subject: [merged] sys_swapon-fix-inode-locking.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:41:24 -0700
Message-ID: <201103232045.p2NKj0mt029145@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933486Ab1CWUpl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:45:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     sys_swapon: fix inode locking
has been removed from the -mm tree.  Its filename was
     sys_swapon-fix-inode-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_swapon: fix inode locking
From: Cesar Eduardo Barros <cesarb@cesarb.net>

A conflict between 52c50567d8ab0a0a87f12cceaa4194967854f0bd (mm: swap:
unlock swapfile inode mutex before closing file on bad swapfiles) and
83ef99befc324803a54cf2a5fab5a322df3a99d6 (sys_swapon: remove did_down
variable) caused a double unlock of the inode mutex (once in bad_swap:
before the filp_close, once at the end just before returning).

The patch which added the extra unlock cleared did_down to avoid unlocking
twice, but the other patch removed the did_down variable.

To fix, set inode to NULL after the first unlock, since it will be used
after that point only for the final unlock.

While checking this patch, I found a path which could unlock without
locking, in case the same inode was added as a swapfile twice.  To fix,
move the setting of the inode variable further down, to just before
claim_swapfile, which will lock the inode before doing anything else.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/swapfile.c~sys_swapon-fix-inode-locking mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-fix-inode-locking
+++ a/mm/swapfile.c
@@ -2088,7 +2088,6 @@ SYSCALL_DEFINE2(swapon, const char __use
 
 	p->swap_file = swap_file;
 	mapping = swap_file->f_mapping;
-	inode = mapping->host;
 
 	for (i = 0; i < nr_swapfiles; i++) {
 		struct swap_info_struct *q = swap_info[i];
@@ -2101,6 +2100,8 @@ SYSCALL_DEFINE2(swapon, const char __use
 		}
 	}
 
+	inode = mapping->host;
+	/* If S_ISREG(inode->i_mode) will do mutex_lock(&inode->i_mutex); */
 	error = claim_swapfile(p, inode);
 	if (unlikely(error))
 		goto bad_swap;
@@ -2187,8 +2188,10 @@ bad_swap:
 	spin_unlock(&swap_lock);
 	vfree(swap_map);
 	if (swap_file) {
-		if (inode && S_ISREG(inode->i_mode))
+		if (inode && S_ISREG(inode->i_mode)) {
 			mutex_unlock(&inode->i_mutex);
+			inode = NULL;
+		}
 		filp_close(swap_file, NULL);
 	}
 out:
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch

