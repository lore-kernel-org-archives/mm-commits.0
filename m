From: akpm@linux-foundation.org
Subject: +
 mm-swap-improve-readability-via-make-spin_lock-unlock-balanced.patch added
 to -mm tree
Date: Fri, 17 Mar 2017 14:38:24 -0700
Message-ID: <58cc5750.Z/VMrlhloyQE72yD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49438 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751425AbdCQVib (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Mar 2017 17:38:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, tim.c.chen@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, swap: improve readability via make spin_lock/unlock balanced
has been added to the -mm tree.  Its filename is
     mm-swap-improve-readability-via-make-spin_lock-unlock-balanced.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-improve-readability-via-make-spin_lock-unlock-balanced.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-improve-readability-via-make-spin_lock-unlock-balanced.patch

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

mm-swap-fix-a-race-in-free_swap_and_cache.patch
mm-swap-fix-comment-in-__read_swap_cache_async.patch
mm-swap-improve-readability-via-make-spin_lock-unlock-balanced.patch
mm-swap-avoid-lock-swap_avail_lock-when-held-cluster-lock.patch

