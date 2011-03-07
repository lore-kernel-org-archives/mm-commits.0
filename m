From: akpm@linux-foundation.org
Subject: + sys_swapon-separate-final-enabling-of-the-swapfile.patch added to -mm tree
Date: Mon, 07 Mar 2011 14:10:34 -0800
Message-ID: <201103072210.p27MAY1q030052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38011 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756517Ab1CGWQh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 17:16:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org


The patch titled
     sys_swapon: separate final enabling of the swapfile
has been added to the -mm tree.  Its filename is
     sys_swapon-separate-final-enabling-of-the-swapfile.patch

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
Subject: sys_swapon: separate final enabling of the swapfile
From: Cesar Eduardo Barros <cesarb@cesarb.net>

The block in sys_swapon which does the final adjustments to the
swap_info_struct and to swap_list is the same as the block which
re-inserts it again at sys_swapoff on failure of try_to_unuse(). Move
this code to a separate function, and use it both in sys_swapon and
sys_swapoff.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   84 ++++++++++++++++++++++++------------------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff -puN mm/swapfile.c~sys_swapon-separate-final-enabling-of-the-swapfile mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-separate-final-enabling-of-the-swapfile
+++ a/mm/swapfile.c
@@ -1550,6 +1550,36 @@ bad_bmap:
 	goto out;
 }
 
+static void enable_swap_info(struct swap_info_struct *p, int prio,
+				unsigned char *swap_map)
+{
+	int i, prev;
+
+	spin_lock(&swap_lock);
+	if (prio >= 0)
+		p->prio = prio;
+	else
+		p->prio = --least_priority;
+	p->swap_map = swap_map;
+	p->flags |= SWP_WRITEOK;
+	nr_swap_pages += p->pages;
+	total_swap_pages += p->pages;
+
+	/* insert swap space into swap_list: */
+	prev = -1;
+	for (i = swap_list.head; i >= 0; i = swap_info[i]->next) {
+		if (p->prio >= swap_info[i]->prio)
+			break;
+		prev = i;
+	}
+	p->next = i;
+	if (prev < 0)
+		swap_list.head = swap_list.next = p->type;
+	else
+		swap_info[prev]->next = p->type;
+	spin_unlock(&swap_lock);
+}
+
 SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
 	struct swap_info_struct *p = NULL;
@@ -1621,26 +1651,14 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	current->flags &= ~PF_OOM_ORIGIN;
 
 	if (err) {
+		/*
+		 * reading p->prio and p->swap_map outside the lock is
+		 * safe here because only sys_swapon and sys_swapoff
+		 * change them, and there can be no other sys_swapon or
+		 * sys_swapoff for this swap_info_struct at this point.
+		 */
 		/* re-insert swap space back into swap_list */
-		spin_lock(&swap_lock);
-		if (p->prio < 0)
-			p->prio = --least_priority;
-		p->flags |= SWP_WRITEOK;
-		nr_swap_pages += p->pages;
-		total_swap_pages += p->pages;
-
-		prev = -1;
-		for (i = swap_list.head; i >= 0; i = swap_info[i]->next) {
-			if (p->prio >= swap_info[i]->prio)
-				break;
-			prev = i;
-		}
-		p->next = i;
-		if (prev < 0)
-			swap_list.head = swap_list.next = type;
-		else
-			swap_info[prev]->next = type;
-		spin_unlock(&swap_lock);
+		enable_swap_info(p, p->prio, p->swap_map);
 		goto out_dput;
 	}
 
@@ -2037,7 +2055,8 @@ SYSCALL_DEFINE2(swapon, const char __use
 	char *name;
 	struct file *swap_file = NULL;
 	struct address_space *mapping;
-	int i, prev;
+	int i;
+	int prio;
 	int error;
 	union swap_header *swap_header;
 	int nr_extents;
@@ -2134,30 +2153,11 @@ SYSCALL_DEFINE2(swapon, const char __use
 	}
 
 	mutex_lock(&swapon_mutex);
-	spin_lock(&swap_lock);
+	prio = -1;
 	if (swap_flags & SWAP_FLAG_PREFER)
-		p->prio =
+		prio =
 		  (swap_flags & SWAP_FLAG_PRIO_MASK) >> SWAP_FLAG_PRIO_SHIFT;
-	else
-		p->prio = --least_priority;
-	p->swap_map = swap_map;
-	p->flags |= SWP_WRITEOK;
-	nr_swap_pages += p->pages;
-	total_swap_pages += p->pages;
-
-	/* insert swap space into swap_list: */
-	prev = -1;
-	for (i = swap_list.head; i >= 0; i = swap_info[i]->next) {
-		if (p->prio >= swap_info[i]->prio)
-			break;
-		prev = i;
-	}
-	p->next = i;
-	if (prev < 0)
-		swap_list.head = swap_list.next = p->type;
-	else
-		swap_info[prev]->next = p->type;
-	spin_unlock(&swap_lock);
+	enable_swap_info(p, prio, swap_map);
 
 	printk(KERN_INFO "Adding %uk swap on %s.  "
 			"Priority:%d extents:%d across:%lluk %s%s\n",
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

