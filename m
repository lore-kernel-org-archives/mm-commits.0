From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 068/128] mm/swapfile.c: omit a duplicate code by
 compare tmp and max first
Date: Mon, 01 Jun 2020 21:49:07 -0700
Message-ID: <20200602044907.ETKpNE7Lo%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726177AbgFBEtI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:49:08 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, tim.c.chen@linux.intel.com, torvalds@linux-foundation.org, ying.huang@intel.com

From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/swapfile.c: omit a duplicate code by compare tmp and max first

There are two duplicate code to handle the case when there is no available
swap entry.  To avoid this, we can compare tmp and max first and let the
second guard do its job.

No functional change is expected.

Link: http://lkml.kernel.org/r/20200421213824.8099-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-omit-a-duplicate-code-by-compare-tmp-and-max-first
+++ a/mm/swapfile.c
@@ -629,17 +629,15 @@ new_cluster:
 	tmp = cluster->next;
 	max = min_t(unsigned long, si->max,
 		    (cluster_next(&cluster->index) + 1) * SWAPFILE_CLUSTER);
-	if (tmp >= max) {
-		cluster_set_null(&cluster->index);
-		goto new_cluster;
-	}
-	ci = lock_cluster(si, tmp);
-	while (tmp < max) {
-		if (!si->swap_map[tmp])
-			break;
-		tmp++;
+	if (tmp < max) {
+		ci = lock_cluster(si, tmp);
+		while (tmp < max) {
+			if (!si->swap_map[tmp])
+				break;
+			tmp++;
+		}
+		unlock_cluster(ci);
 	}
-	unlock_cluster(ci);
 	if (tmp >= max) {
 		cluster_set_null(&cluster->index);
 		goto new_cluster;
_
