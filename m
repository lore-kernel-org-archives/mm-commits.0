From: akpm@linux-foundation.org
Subject: + sys_swapon-fix-inode-locking.patch added to -mm tree
Date: Tue, 22 Mar 2011 21:36:38 -0700
Message-ID: <201103230440.p2N4e8Xj015779@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751861Ab1CWEky (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 00:40:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de


The patch titled
     sys_swapon: fix inode locking
has been added to the -mm tree.  Its filename is
     sys_swapon-fix-inode-locking.patch

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

sys_swapon-use-vzalloc-instead-of-vmalloc-memset.patch
sys_swapon-remove-changelog-from-function-comment.patch
sys_swapon-do-not-depend-on-type-after-allocation.patch
sys_swapon-separate-swap_info-allocation.patch
sys_swapon-simplify-error-return-from-swap_info-allocation.patch
sys_swapon-simplify-error-flow-in-alloc_swap_info.patch
sys_swapon-remove-initial-value-of-name-variable.patch
sys_swapon-remove-did_down-variable.patch
sys_swapon-move-setting-of-error-nearer-use.patch
sys_swapon-remove-bdev-variable.patch
sys_swapon-do-only-cleanup-in-the-cleanup-blocks.patch
sys_swapon-use-a-single-error-label.patch
sys_swapon-separate-bdev-claim-and-inode-lock.patch
sys_swapon-simplify-error-flow-in-claim_swapfile.patch
sys_swapon-move-setting-of-swapfilepages-near-use.patch
sys_swapon-separate-parsing-of-swapfile-header.patch
sys_swapon-simplify-error-flow-in-read_swap_header.patch
sys_swapon-call-swap_cgroup_swapon-earlier.patch
sys_swapon-separate-parsing-of-bad-blocks-and-extents.patch
sys_swapon-simplify-error-flow-in-setup_swap_map_and_extents.patch
sys_swapon-remove-nr_good_pages-variable.patch
sys_swapon-move-printk-outside-lock.patch
sys_swapoff-change-order-to-match-sys_swapon.patch
sys_swapon-separate-final-enabling-of-the-swapfile.patch
mm-remove-inline-from-scan_swap_map.patch
sys_swapon-fix-inode-locking.patch

