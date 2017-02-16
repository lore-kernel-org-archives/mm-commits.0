From: akpm@linux-foundation.org
Subject: + mm-swap-add-cluster-lock-v5-fix-2.patch added to -mm tree
Date: Thu, 16 Feb 2017 15:48:02 -0800
Message-ID: <58a63a32.aM7QptwBq9PXs3Pw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38222 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933692AbdBPXsE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2017 18:48:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, minchan@kernel.org, tim.c.chen@linux.intel.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, swap: annotate nested locking for cluster lock
has been added to the -mm tree.  Its filename is
     mm-swap-add-cluster-lock-v5-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-add-cluster-lock-v5-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-add-cluster-lock-v5-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm, swap: annotate nested locking for cluster lock

Fix swap cluster lockdep warnings.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.1702161050540.21773@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Minchan Kim <minchan@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN mm/swapfile.c~mm-swap-add-cluster-lock-v5-fix-2 mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-add-cluster-lock-v5-fix-2
+++ a/mm/swapfile.c
@@ -257,11 +257,6 @@ static inline void cluster_set_null(stru
 	info->data = 0;
 }
 
-static inline void __lock_cluster(struct swap_cluster_info *ci)
-{
-	spin_lock(&ci->lock);
-}
-
 static inline struct swap_cluster_info *lock_cluster(struct swap_info_struct *si,
 						     unsigned long offset)
 {
@@ -270,7 +265,7 @@ static inline struct swap_cluster_info *
 	ci = si->cluster_info;
 	if (ci) {
 		ci += offset / SWAPFILE_CLUSTER;
-		__lock_cluster(ci);
+		spin_lock(&ci->lock);
 	}
 	return ci;
 }
@@ -335,7 +330,7 @@ static void cluster_list_add_tail(struct
 		 * only acquired when we held swap_info_struct->lock
 		 */
 		ci_tail = ci + tail;
-		__lock_cluster(ci_tail);
+		spin_lock_nested(&ci_tail->lock, SINGLE_DEPTH_NESTING);
 		cluster_set_next(ci_tail, idx);
 		unlock_cluster(ci_tail);
 		cluster_set_next_flag(&list->tail, idx, 0);
_

Patches currently in -mm which might be from hughd@google.com are

tmpfs-change-shmem_mapping-to-test-shmem_aops.patch
mm-swap-add-cluster-lock-v5-fix-2.patch
mm-remove-shmem_mapping-shmem_zero_setup-duplicates.patch

