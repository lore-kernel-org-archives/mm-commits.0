From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-swap-add-cache-for-swap-slots-allocation-fix-2.patch removed from -mm
 tree
Date: Wed, 22 Feb 2017 15:26:51 -0800
Message-ID: <58ae1e3b./lUQXqLZDibIBDz7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47214 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934069AbdBVX0w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:26:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tim.c.chen@linux.intel.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: add comments on locks in swap_slots.h
has been removed from the -mm tree.  Its filename was
     mm-swap-add-cache-for-swap-slots-allocation-fix-2.patch

This patch was dropped because it was folded into mm-swap-add-cache-for-swap-slots-allocation.patch

------------------------------------------------------
From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: mm/swap: add comments on locks in swap_slots.h

Explains what each lock protects in swap_slots_cache structure.

Link: http://lkml.kernel.org/r/20170118180327.GA24225@linux.intel.com
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap_slots.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/swap_slots.h~mm-swap-add-cache-for-swap-slots-allocation-fix-2 include/linux/swap_slots.h
--- a/include/linux/swap_slots.h~mm-swap-add-cache-for-swap-slots-allocation-fix-2
+++ a/include/linux/swap_slots.h
@@ -11,11 +11,11 @@
 
 struct swap_slots_cache {
 	bool		lock_initialized;
-	struct mutex	alloc_lock;
+	struct mutex	alloc_lock; /* protects slots, nr, cur */
 	swp_entry_t	*slots;
 	int		nr;
 	int		cur;
-	spinlock_t	free_lock;
+	spinlock_t	free_lock;  /* protects slots_ret, n_ret */
 	swp_entry_t	*slots_ret;
 	int		n_ret;
 };
_

Patches currently in -mm which might be from tim.c.chen@linux.intel.com are

mm-swap-skip-read-ahead-for-unreferenced-swap-slots.patch
mm-swap-allocate-swap-slots-in-batches.patch
mm-swap-free-swap-slots-in-batch.patch
mm-swap-add-cache-for-swap-slots-allocation.patch
mm-swap-enable-swap-slots-cache-usage.patch

