From: akpm@linux-foundation.org
Subject: +
 mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch added
 to -mm tree
Date: Fri, 10 Jan 2014 16:38:34 -0800
Message-ID: <52d0928a.0E6X2989fYfV00FO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33929 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaAKAie (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jan 2014 19:38:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, weijie.yang@samsung.com

Subject: + mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch added to -mm tree
To: weijie.yang@samsung.com,hughd@google.com
From: akpm@linux-foundation.org
Date: Fri, 10 Jan 2014 16:38:34 -0800


The patch titled
     Subject: mm/swap: fix race on swap_info reuse between swapoff and swapon
has been added to the -mm tree.  Its filename is
     mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN mm/swapfile.c~mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon
+++ a/mm/swapfile.c
@@ -1922,7 +1922,6 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	p->swap_map = NULL;
 	cluster_info = p->cluster_info;
 	p->cluster_info = NULL;
-	p->flags = 0;
 	frontswap_map = frontswap_map_get(p);
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
@@ -1948,6 +1947,16 @@ SYSCALL_DEFINE1(swapoff, const char __us
 		mutex_unlock(&inode->i_mutex);
 	}
 	filp_close(swap_file, NULL);
+
+	/*
+	* clear SWP_USED flag after all resources freed
+	* so that swapon can reuse this swap_info in alloc_swap_info() safely
+	* it is ok to not hold p->lock after we cleared its SWP_WRITEOK
+	*/
+	spin_lock(&swap_lock);
+	p->flags = 0;
+	spin_unlock(&swap_lock);
+
 	err = 0;
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
_

Patches currently in -mm which might be from weijie.yang@samsung.com are

mm-zswapc-change-params-from-hidden-to-ro.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch

