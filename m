From: akpm@linux-foundation.org
Subject: + mm-swap-add-cluster-lock-v5-fix.patch added to -mm tree
Date: Tue, 07 Feb 2017 14:52:26 -0800
Message-ID: <589a4faa.DkzQOQc8plfGV0Fp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35902 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753026AbdBGWw1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Feb 2017 17:52:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hughd@google.com, tim.c.chen@linux.intel.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: swapfile: initialize spinlock for swap_cluster_info
has been added to the -mm tree.  Its filename is
     mm-swap-add-cluster-lock-v5-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-add-cluster-lock-v5-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-add-cluster-lock-v5-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: swapfile: initialize spinlock for swap_cluster_info

We changed swap_cluster_info lock from bit_spin_lock to spinlock so we
need to initialize the spinlock before the using.  Otherwise, lockdep is
broken.

Link: http://lkml.kernel.org/r/1486434945-29753-1-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN mm/swapfile.c~mm-swap-add-cluster-lock-v5-fix mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-add-cluster-lock-v5-fix
+++ a/mm/swapfile.c
@@ -2591,6 +2591,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 
 	if (p->bdev && blk_queue_nonrot(bdev_get_queue(p->bdev))) {
 		int cpu;
+		unsigned long ci, nr_cluster;
 
 		p->flags |= SWP_SOLIDSTATE;
 		/*
@@ -2598,13 +2599,17 @@ SYSCALL_DEFINE2(swapon, const char __use
 		 * SSD
 		 */
 		p->cluster_next = 1 + (prandom_u32() % p->highest_bit);
+		nr_cluster = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 
-		cluster_info = vzalloc(DIV_ROUND_UP(maxpages,
-			SWAPFILE_CLUSTER) * sizeof(*cluster_info));
+		cluster_info = vzalloc(nr_cluster * sizeof(*cluster_info));
 		if (!cluster_info) {
 			error = -ENOMEM;
 			goto bad_swap;
 		}
+
+		for (ci = 0; ci < nr_cluster; ci++)
+			spin_lock_init(&((cluster_info + ci)->lock));
+
 		p->percpu_cluster = alloc_percpu(struct percpu_cluster);
 		if (!p->percpu_cluster) {
 			error = -ENOMEM;
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-swap-add-cluster-lock-v5-fix.patch
zram-remove-waitqueue-for-io-done.patch
zram-extend-zero-pages-to-same-element-pages-fix.patch

