From: akpm@linux-foundation.org
Subject: + mm-swap-avoid-lock-swap_avail_lock-when-held-cluster-lock.patch added to -mm tree
Date: Fri, 17 Mar 2017 14:38:26 -0700
Message-ID: <58cc5752.DyXr9I+u5A3Ruv+X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49442 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751061AbdCQVi1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Mar 2017 17:38:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, tim.c.chen@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, swap: avoid lock swap_avail_lock when held cluster lock
has been added to the -mm tree.  Its filename is
     mm-swap-avoid-lock-swap_avail_lock-when-held-cluster-lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-avoid-lock-swap_avail_lock-when-held-cluster-lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-avoid-lock-swap_avail_lock-when-held-cluster-lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from ying.huang@intel.com are

mm-swap-fix-a-race-in-free_swap_and_cache.patch
mm-swap-fix-comment-in-__read_swap_cache_async.patch
mm-swap-improve-readability-via-make-spin_lock-unlock-balanced.patch
mm-swap-avoid-lock-swap_avail_lock-when-held-cluster-lock.patch

