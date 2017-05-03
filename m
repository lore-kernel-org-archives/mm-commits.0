From: akpm@linux-foundation.org
Subject: [patch 060/102] mm, swap: avoid lock swap_avail_lock when
 held cluster lock
Date: Wed, 03 May 2017 14:54:39 -0700
Message-ID: <20170503215439.tcLUDapgj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49630 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751074AbdECVy6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:54:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, tim.c.chen@intel.com, torvalds@linux-foundation.org, ying.huang@intel.com

From: Huang Ying <ying.huang@intel.com>
Subject: mm, swap: avoid lock swap_avail_lock when held cluster lock

Cluster lock is used to protect the swap_cluster_info and corresponding
elements in swap_info_struct->swap_map[].  But it is found that now in
scan_swap_map_slots(), swap_avail_lock may be acquired when cluster lock
is held.  This does no good except making the locking more complex and
improving the potential locking contention, because the
swap_info_struct->lock is used to protect the data structure operated in
the code already.  Fix this via moving the corresponding operations in
scan_swap_map_slots() out of cluster lock.

Link: http://lkml.kernel.org/r/20170317064635.12792-3-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Tim Chen <tim.c.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/swapfile.c~mm-swap-avoid-lock-swap_avail_lock-when-held-cluster-lock mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-avoid-lock-swap_avail_lock-when-held-cluster-lock
+++ a/mm/swapfile.c
@@ -672,6 +672,9 @@ checks:
 		else
 			goto done;
 	}
+	si->swap_map[offset] = usage;
+	inc_cluster_info_page(si, si->cluster_info, offset);
+	unlock_cluster(ci);
 
 	if (offset == si->lowest_bit)
 		si->lowest_bit++;
@@ -685,9 +688,6 @@ checks:
 		plist_del(&si->avail_list, &swap_avail_head);
 		spin_unlock(&swap_avail_lock);
 	}
-	si->swap_map[offset] = usage;
-	inc_cluster_info_page(si, si->cluster_info, offset);
-	unlock_cluster(ci);
 	si->cluster_next = offset + 1;
 	slots[n_ret++] = swp_entry(si->type, offset);
 
_
