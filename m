From: akpm@linux-foundation.org
Subject: [merged] sys_swapon-separate-final-enabling-of-the-swapfile.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:37:58 -0700
Message-ID: <201103232041.p2NKfYrt028660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933529Ab1CWUzg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sys_swapon: separate final enabling of the swapfile
has been removed from the -mm tree.  Its filename was
     sys_swapon-separate-final-enabling-of-the-swapfile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
