From: akpm@linux-foundation.org
Subject: [merged]
 mm-swap-improve-readability-via-make-spin_lock-unlock-balanced.patch
 removed from -mm tree
Date: Thu, 04 May 2017 12:12:02 -0700
Message-ID: <20170504191202.10f1KWVv0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51580 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755434AbdEDTMD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:12:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tim.c.chen@intel.com, ying.huang@intel.com


The patch titled
     Subject: mm, swap: improve readability via make spin_lock/unlock balanced
has been removed from the -mm tree.  Its filename was
     mm-swap-improve-readability-via-make-spin_lock-unlock-balanced.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, swap: improve readability via make spin_lock/unlock balanced

This is just a cleanup patch, no functionality change.  In
cluster_list_add_tail(), spin_lock_nested() is used to lock the cluster,
while unlock_cluster() is used to unlock the cluster.  To improve the code
readability.  Use spin_unlock() directly to unlock the cluster.

Link: http://lkml.kernel.org/r/20170317064635.12792-2-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Tim Chen <tim.c.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swapfile.c~mm-swap-improve-readability-via-make-spin_lock-unlock-balanced mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-improve-readability-via-make-spin_lock-unlock-balanced
+++ a/mm/swapfile.c
@@ -335,7 +335,7 @@ static void cluster_list_add_tail(struct
 		ci_tail = ci + tail;
 		spin_lock_nested(&ci_tail->lock, SINGLE_DEPTH_NESTING);
 		cluster_set_next(ci_tail, idx);
-		unlock_cluster(ci_tail);
+		spin_unlock(&ci_tail->lock);
 		cluster_set_next_flag(&list->tail, idx, 0);
 	}
 }
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-swap-use-kvzalloc-to-allocate-some-swap-data-structure.patch

