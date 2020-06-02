From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 066/128] mm/swapfile.c: found_free could be
 represented by (tmp < max)
Date: Tue, 02 Jun 2020 13:13:48 -0700
Message-ID: <20200602201348.yqPO8srWq%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgFBUNu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 16:13:50 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, tim.c.chen@linux.intel.com, torvalds@linux-foundation.org, ying.huang@intel.com

From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/swapfile.c: found_free could be represented by (tmp < max)

This is not necessary to use the variable found_free to record the status.
Just check tmp and max is enough.

Link: http://lkml.kernel.org/r/20200421213824.8099-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-found_free-could-be-represented-by-tmp-max
+++ a/mm/swapfile.c
@@ -601,7 +601,6 @@ static bool scan_swap_map_try_ssd_cluste
 {
 	struct percpu_cluster *cluster;
 	struct swap_cluster_info *ci;
-	bool found_free;
 	unsigned long tmp, max;
 
 new_cluster:
@@ -623,8 +622,6 @@ new_cluster:
 			return false;
 	}
 
-	found_free = false;
-
 	/*
 	 * Other CPUs can use our cluster if they can't find a free cluster,
 	 * check if there is still free entry in the cluster
@@ -638,21 +635,19 @@ new_cluster:
 	}
 	ci = lock_cluster(si, tmp);
 	while (tmp < max) {
-		if (!si->swap_map[tmp]) {
-			found_free = true;
+		if (!si->swap_map[tmp])
 			break;
-		}
 		tmp++;
 	}
 	unlock_cluster(ci);
-	if (!found_free) {
+	if (tmp >= max) {
 		cluster_set_null(&cluster->index);
 		goto new_cluster;
 	}
 	cluster->next = tmp + 1;
 	*offset = tmp;
 	*scan_base = tmp;
-	return found_free;
+	return tmp < max;
 }
 
 static void __del_from_avail_list(struct swap_info_struct *p)
_
