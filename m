From: akpm@linux-foundation.org
Subject: + sys_swapon-move-printk-outside-lock.patch added to -mm tree
Date: Mon, 07 Mar 2011 14:10:30 -0800
Message-ID: <201103072210.p27MAUdG030044@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756471Ab1CGWLG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 17:11:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     sys_swapon: move printk outside lock
has been added to the -mm tree.  Its filename is
     sys_swapon-move-printk-outside-lock.patch

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
Subject: sys_swapon: move printk outside lock
From: Cesar Eduardo Barros <cesarb@cesarb.net>

The block in sys_swapon which does the final adjustments to the
swap_info_struct and to swap_list is the same as the block which
re-inserts it again at sys_swapoff on failure of try_to_unuse(). To be
able to make both share the same code, move the printk() call in the
middle of it to just after it.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN mm/swapfile.c~sys_swapon-move-printk-outside-lock mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-move-printk-outside-lock
+++ a/mm/swapfile.c
@@ -2144,13 +2144,6 @@ SYSCALL_DEFINE2(swapon, const char __use
 	nr_swap_pages += p->pages;
 	total_swap_pages += p->pages;
 
-	printk(KERN_INFO "Adding %uk swap on %s.  "
-			"Priority:%d extents:%d across:%lluk %s%s\n",
-		p->pages<<(PAGE_SHIFT-10), name, p->prio,
-		nr_extents, (unsigned long long)span<<(PAGE_SHIFT-10),
-		(p->flags & SWP_SOLIDSTATE) ? "SS" : "",
-		(p->flags & SWP_DISCARDABLE) ? "D" : "");
-
 	/* insert swap space into swap_list: */
 	prev = -1;
 	for (i = swap_list.head; i >= 0; i = swap_info[i]->next) {
@@ -2164,6 +2157,14 @@ SYSCALL_DEFINE2(swapon, const char __use
 	else
 		swap_info[prev]->next = p->type;
 	spin_unlock(&swap_lock);
+
+	printk(KERN_INFO "Adding %uk swap on %s.  "
+			"Priority:%d extents:%d across:%lluk %s%s\n",
+		p->pages<<(PAGE_SHIFT-10), name, p->prio,
+		nr_extents, (unsigned long long)span<<(PAGE_SHIFT-10),
+		(p->flags & SWP_SOLIDSTATE) ? "SS" : "",
+		(p->flags & SWP_DISCARDABLE) ? "D" : "");
+
 	mutex_unlock(&swapon_mutex);
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
_

Patches currently in -mm which might be from cesarb@cesarb.net are

sys_swapon-use-vzalloc-instead-of-vmalloc-memset.patch
sys_swapon-remove-changelog-from-function-comment.patch
sys_swapon-do-not-depend-on-type-after-allocation.patch
sys_swapon-separate-swap_info-allocation.patch
sys_swapon-simplify-error-return-from-swap_info-allocation.patch
sys_swapon-simplify-error-flow-in-alloc_swap_info.patch
sys_swapon-remove-initial-value-of-name-variable.patch
sys_swapon-move-setting-of-error-nearer-use.patch
sys_swapon-remove-did_down-variable.patch
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

