From: akpm@linux-foundation.org
Subject: +
 swap-discard-while-swapping-only-if-swap_flag_discard_pages.patch added to
 -mm tree
Date: Thu, 30 May 2013 14:45:54 -0700
Message-ID: <51a7c892.1ql98y5eHZ4vlDmm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60129 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757923Ab3E3Vp4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 May 2013 17:45:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shli@kernel.org, riel@redhat.com, mel@csn.ul.ie, lwoodman@redhat.com, kzak@redhat.com, kosaki.motohiro@jp.fujitsu.com, jmoyer@redhat.com, hughd@google.com, aquini@redhat.com

Subject: + swap-discard-while-swapping-only-if-swap_flag_discard_pages.patch added to -mm tree
To: aquini@redhat.com,hughd@google.com,jmoyer@redhat.com,kosaki.motohiro@jp.fujitsu.com,kzak@redhat.com,lwoodman@redhat.com,mel@csn.ul.ie,riel@redhat.com,shli@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 30 May 2013 14:45:54 -0700


The patch titled
     Subject: swap: discard while swapping only if SWAP_FLAG_DISCARD_PAGES
has been added to the -mm tree.  Its filename is
     swap-discard-while-swapping-only-if-swap_flag_discard_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: swap: discard while swapping only if SWAP_FLAG_DISCARD_PAGES

Considering the use cases where the swap device supports discard:
a) and can do it quickly;
b) but it's slow to do in small granularities (or concurrent with other
   I/O);
c) but the implementation is so horrendous that you don't even want to
   send one down;

And assuming that the sysadmin considers it useful to send the discards down
at all, we would (probably) want the following solutions:

  i. do the fine-grained discards for freed swap pages, if device is 
     capable of doing so optimally;
 ii. do single-time (batched) swap area discards, either at swapon 
     or via something like fstrim (not implemented yet);
iii. allow doing both single-time and fine-grained discards; or
 iv. turn it off completely (default behavior)


As implemented today, one can only enable/disable discards for swap, but
one cannot select, for instance, solution (ii) on a swap device like (b)
even though the single-time discard is regarded to be interesting, or
necessary to the workload because it would imply (1), and the device is
not capable of performing it optimally.

This patch addresses the scenario depicted above by introducing a way to
ensure the (probably) wanted solutions (i, ii, iii and iv) can be flexibly
flagged through swapon(8) to allow a sysadmin to select the best suitable
swap discard policy accordingly to system constraints.



This patch introduces SWAP_FLAG_DISCARD_PAGES and SWAP_FLAG_DISCARD_ONCE
new flags to allow more flexibe swap discard policies being flagged
through swapon(8).  The default behavior is to keep both single-time, or
batched, area discards (SWAP_FLAG_DISCARD_ONCE) and fine-grained discards
for page-clusters (SWAP_FLAG_DISCARD_PAGES) enabled, in order to keep
consistentcy with older kernel behavior, as well as maintain compatibility
with older swapon(8).  However, through the new introduced flags the best
suitable discard policy can be selected accordingly to any given swap
device constraint.

Signed-off-by: Rafael Aquini <aquini@redhat.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Karel Zak <kzak@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   13 ++++++---
 mm/swapfile.c        |   55 +++++++++++++++++++++++++++++++++++++----
 2 files changed, 59 insertions(+), 9 deletions(-)

diff -puN include/linux/swap.h~swap-discard-while-swapping-only-if-swap_flag_discard_pages include/linux/swap.h
--- a/include/linux/swap.h~swap-discard-while-swapping-only-if-swap_flag_discard_pages
+++ a/include/linux/swap.h
@@ -20,10 +20,13 @@ struct bio;
 #define SWAP_FLAG_PREFER	0x8000	/* set if swap priority specified */
 #define SWAP_FLAG_PRIO_MASK	0x7fff
 #define SWAP_FLAG_PRIO_SHIFT	0
-#define SWAP_FLAG_DISCARD	0x10000 /* discard swap cluster after use */
+#define SWAP_FLAG_DISCARD	0x10000 /* enable discard for swap */
+#define SWAP_FLAG_DISCARD_ONCE	0x20000 /* discard swap area at swapon-time */
+#define SWAP_FLAG_DISCARD_PAGES 0x40000 /* discard page-clusters after use */
 
 #define SWAP_FLAGS_VALID	(SWAP_FLAG_PRIO_MASK | SWAP_FLAG_PREFER | \
-				 SWAP_FLAG_DISCARD)
+				 SWAP_FLAG_DISCARD | SWAP_FLAG_DISCARD_ONCE | \
+				 SWAP_FLAG_DISCARD_PAGES)
 
 static inline int current_is_kswapd(void)
 {
@@ -147,14 +150,16 @@ struct swap_extent {
 enum {
 	SWP_USED	= (1 << 0),	/* is slot in swap_info[] used? */
 	SWP_WRITEOK	= (1 << 1),	/* ok to write to this swap?	*/
-	SWP_DISCARDABLE = (1 << 2),	/* swapon+blkdev support discard */
+	SWP_DISCARDABLE = (1 << 2),	/* blkdev support discard */
 	SWP_DISCARDING	= (1 << 3),	/* now discarding a free cluster */
 	SWP_SOLIDSTATE	= (1 << 4),	/* blkdev seeks are cheap */
 	SWP_CONTINUED	= (1 << 5),	/* swap_map has count continuation */
 	SWP_BLKDEV	= (1 << 6),	/* its a block device */
 	SWP_FILE	= (1 << 7),	/* set after swap_activate success */
+	SWP_AREA_DISCARD = (1 << 8),	/* single-time swap area discards */
+	SWP_PAGE_DISCARD = (1 << 9),	/* freed swap page-cluster discards */
 					/* add others here before... */
-	SWP_SCANNING	= (1 << 8),	/* refcount in scan_swap_map */
+	SWP_SCANNING	= (1 << 10),	/* refcount in scan_swap_map */
 };
 
 #define SWAP_CLUSTER_MAX 32UL
diff -puN mm/swapfile.c~swap-discard-while-swapping-only-if-swap_flag_discard_pages mm/swapfile.c
--- a/mm/swapfile.c~swap-discard-while-swapping-only-if-swap_flag_discard_pages
+++ a/mm/swapfile.c
@@ -212,7 +212,7 @@ static unsigned long scan_swap_map(struc
 			si->cluster_nr = SWAPFILE_CLUSTER - 1;
 			goto checks;
 		}
-		if (si->flags & SWP_DISCARDABLE) {
+		if (si->flags & SWP_PAGE_DISCARD) {
 			/*
 			 * Start range check on racing allocations, in case
 			 * they overlap the cluster we eventually decide on
@@ -322,7 +322,7 @@ checks:
 
 	if (si->lowest_alloc) {
 		/*
-		 * Only set when SWP_DISCARDABLE, and there's a scan
+		 * Only set when SWP_PAGE_DISCARD, and there's a scan
 		 * for a free cluster in progress or just completed.
 		 */
 		if (found_free_cluster) {
@@ -2016,6 +2016,20 @@ static int setup_swap_map_and_extents(st
 	return nr_extents;
 }
 
+/*
+ * Helper to sys_swapon determining if a given swap
+ * backing device queue supports DISCARD operations.
+ */
+static bool swap_discardable(struct swap_info_struct *si)
+{
+	struct request_queue *q = bdev_get_queue(si->bdev);
+
+	if (!q || !blk_queue_discard(q))
+		return false;
+
+	return true;
+}
+
 SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 {
 	struct swap_info_struct *p;
@@ -2123,8 +2137,37 @@ SYSCALL_DEFINE2(swapon, const char __use
 			p->flags |= SWP_SOLIDSTATE;
 			p->cluster_next = 1 + (prandom_u32() % p->highest_bit);
 		}
-		if ((swap_flags & SWAP_FLAG_DISCARD) && discard_swap(p) == 0)
-			p->flags |= SWP_DISCARDABLE;
+
+		if ((swap_flags & SWAP_FLAG_DISCARD) && swap_discardable(p)) {
+			/*
+			 * When discard is enabled for swap, with no particular
+			 * policy flagged, we set all swap discard flags here
+			 * in order to sustain backward compatibility with
+			 * older swapon(8) releases.
+			 */
+			p->flags |= (SWP_DISCARDABLE | SWP_AREA_DISCARD |
+				     SWP_PAGE_DISCARD);
+
+			/*
+			 * By flagging sys_swapon, a sysadmin can tell us to
+			 * either do sinle-time area discards only, or to just
+			 * perform discards for released swap page-clusters.
+			 * Now it's time to adjust the p->flags accordingly.
+			 */
+			if (swap_flags & SWAP_FLAG_DISCARD_ONCE)
+				p->flags &= ~SWP_PAGE_DISCARD;
+			else if (swap_flags & SWAP_FLAG_DISCARD_PAGES)
+				p->flags &= ~SWP_AREA_DISCARD;
+
+			/* issue a swapon-time discard if it's still required */
+			if (p->flags & SWP_AREA_DISCARD) {
+				int err = discard_swap(p);
+				if (unlikely(err))
+					printk(KERN_ERR
+					       "swapon: discard_swap(%p): %d\n",
+						p, err);
+			}
+		}
 	}
 
 	mutex_lock(&swapon_mutex);
@@ -2135,11 +2178,13 @@ SYSCALL_DEFINE2(swapon, const char __use
 	enable_swap_info(p, prio, swap_map, frontswap_map);
 
 	printk(KERN_INFO "Adding %uk swap on %s.  "
-			"Priority:%d extents:%d across:%lluk %s%s%s\n",
+			"Priority:%d extents:%d across:%lluk %s%s%s%s%s\n",
 		p->pages<<(PAGE_SHIFT-10), name->name, p->prio,
 		nr_extents, (unsigned long long)span<<(PAGE_SHIFT-10),
 		(p->flags & SWP_SOLIDSTATE) ? "SS" : "",
 		(p->flags & SWP_DISCARDABLE) ? "D" : "",
+		(p->flags & SWP_AREA_DISCARD) ? "s" : "",
+		(p->flags & SWP_PAGE_DISCARD) ? "c" : "",
 		(frontswap_map) ? "FS" : "");
 
 	mutex_unlock(&swapon_mutex);
_

Patches currently in -mm which might be from aquini@redhat.com are

swap-discard-while-swapping-only-if-swap_flag_discard_pages.patch
swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch

