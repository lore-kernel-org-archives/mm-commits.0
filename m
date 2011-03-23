From: akpm@linux-foundation.org
Subject: [merged] sys_swapon-simplify-error-flow-in-alloc_swap_info.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:37:22 -0700
Message-ID: <201103232040.p2NKewsv028577@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933342Ab1CWUzb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sys_swapon: simplify error flow in alloc_swap_info()
has been removed from the -mm tree.  Its filename was
     sys_swapon-simplify-error-flow-in-alloc_swap_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_swapon: simplify error flow in alloc_swap_info()
From: Cesar Eduardo Barros <cesarb@cesarb.net>

Since there is no cleanup to do, there is no reason to jump to a label.
Return directly instead.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN mm/swapfile.c~sys_swapon-simplify-error-flow-in-alloc_swap_info mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-simplify-error-flow-in-alloc_swap_info
+++ a/mm/swapfile.c
@@ -1848,7 +1848,6 @@ static struct swap_info_struct *alloc_sw
 {
 	struct swap_info_struct *p;
 	unsigned int type;
-	int error;
 
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
@@ -1859,11 +1858,10 @@ static struct swap_info_struct *alloc_sw
 		if (!(swap_info[type]->flags & SWP_USED))
 			break;
 	}
-	error = -EPERM;
 	if (type >= MAX_SWAPFILES) {
 		spin_unlock(&swap_lock);
 		kfree(p);
-		goto out;
+		return ERR_PTR(-EPERM);
 	}
 	if (type >= nr_swapfiles) {
 		p->type = type;
@@ -1889,9 +1887,6 @@ static struct swap_info_struct *alloc_sw
 	spin_unlock(&swap_lock);
 
 	return p;
