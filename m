From: akpm@linux-foundation.org
Subject: [merged] sys_swapon-remove-nr_good_pages-variable.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:37:52 -0700
Message-ID: <201103232041.p2NKfSqk028647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933527Ab1CWUzd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sys_swapon: remove nr_good_pages variable
has been removed from the -mm tree.  Its filename was
     sys_swapon-remove-nr_good_pages-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_swapon: remove nr_good_pages variable
From: Cesar Eduardo Barros <cesarb@cesarb.net>

It still exists within setup_swap_map_and_extents(), but after it
nr_good_pages == p->pages.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN mm/swapfile.c~sys_swapon-remove-nr_good_pages-variable mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-remove-nr_good_pages-variable
+++ a/mm/swapfile.c
@@ -2039,7 +2039,6 @@ SYSCALL_DEFINE2(swapon, const char __use
 	int i, prev;
 	int error;
 	union swap_header *swap_header;
-	unsigned int nr_good_pages;
 	int nr_extents;
 	sector_t span;
 	unsigned long maxpages;
@@ -2123,7 +2122,6 @@ SYSCALL_DEFINE2(swapon, const char __use
 		error = nr_extents;
 		goto bad_swap;
 	}
-	nr_good_pages = p->pages;
 
 	if (p->bdev) {
 		if (blk_queue_nonrot(bdev_get_queue(p->bdev))) {
@@ -2143,12 +2141,12 @@ SYSCALL_DEFINE2(swapon, const char __use
 		p->prio = --least_priority;
 	p->swap_map = swap_map;
 	p->flags |= SWP_WRITEOK;
-	nr_swap_pages += nr_good_pages;
-	total_swap_pages += nr_good_pages;
+	nr_swap_pages += p->pages;
+	total_swap_pages += p->pages;
 
 	printk(KERN_INFO "Adding %uk swap on %s.  "
 			"Priority:%d extents:%d across:%lluk %s%s\n",
-		nr_good_pages<<(PAGE_SHIFT-10), name, p->prio,
+		p->pages<<(PAGE_SHIFT-10), name, p->prio,
 		nr_extents, (unsigned long long)span<<(PAGE_SHIFT-10),
 		(p->flags & SWP_SOLIDSTATE) ? "SS" : "",
 		(p->flags & SWP_DISCARDABLE) ? "D" : "");
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch

