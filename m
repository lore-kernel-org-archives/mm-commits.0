From: akpm@linux-foundation.org
Subject: [merged]
 mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch
 removed from -mm tree
Date: Fri, 07 Feb 2014 12:18:41 -0800
Message-ID: <52f53fa1.85ZNQYZEIjRD+RKb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbaBGUSl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Feb 2014 15:18:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, k.kozlowski@samsung.com, hughd@google.com, weijie.yang@samsung.com

Subject: [merged] mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch removed from -mm tree
To: weijie.yang@samsung.com,hughd@google.com,k.kozlowski@samsung.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 07 Feb 2014 12:18:41 -0800


The patch titled
     Subject: mm/swap: fix race on swap_info reuse between swapoff and swapon
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: mm/swap: fix race on swap_info reuse between swapoff and swapon

swapoff clear swap_info's SWP_USED flag prematurely and free its resources
after that.  A concurrent swapon will reuse this swap_info while its
previous resources are not cleared completely.

These late freed resources are:
- p->percpu_cluster
- swap_cgroup_ctrl[type]
- block_device setting
- inode->i_flags &= ~S_SWAPFILE

This patch clears the SWP_USED flag after all its resources are freed, so
that swapon can reuse this swap_info by alloc_swap_info() safely.

[akpm@linux-foundation.org: tidy up code comment]
Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN mm/swapfile.c~mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon
+++ a/mm/swapfile.c
@@ -1923,7 +1923,6 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	p->swap_map = NULL;
 	cluster_info = p->cluster_info;
 	p->cluster_info = NULL;
-	p->flags = 0;
 	frontswap_map = frontswap_map_get(p);
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
@@ -1949,6 +1948,16 @@ SYSCALL_DEFINE1(swapoff, const char __us
 		mutex_unlock(&inode->i_mutex);
 	}
 	filp_close(swap_file, NULL);
+
+	/*
+	 * Clear the SWP_USED flag after all resources are freed so that swapon
+	 * can reuse this swap_info in alloc_swap_info() safely.  It is ok to
+	 * not hold p->lock after we cleared its SWP_WRITEOK.
+	 */
+	spin_lock(&swap_lock);
+	p->flags = 0;
+	spin_unlock(&swap_lock);
+
 	err = 0;
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
_

Patches currently in -mm which might be from weijie.yang@samsung.com are

origin.patch

