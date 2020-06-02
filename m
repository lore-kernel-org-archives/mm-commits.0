From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 063/128] mm/swapfile.c: remove the unnecessary
 goto for SSD case
Date: Tue, 02 Jun 2020 13:13:36 -0700
Message-ID: <20200602201336.PDLSwGJw5%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726223AbgFBUNi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 16:13:38 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, tim.c.chen@linux.intel.com, torvalds@linux-foundation.org

From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/swapfile.c: remove the unnecessary goto for SSD case

Now we can see there is redundant goto for SSD case.  In these two places,
we can just let the code walk through to the correct tag instead of
explicitly jump to it.

Let's remove them for better readability.

Link: http://lkml.kernel.org/r/20200328060520.31449-4-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-remove-the-unnecessary-goto-for-ssd-case
+++ a/mm/swapfile.c
@@ -759,9 +759,7 @@ static int scan_swap_map_slots(struct sw
 
 	/* SSD algorithm */
 	if (si->cluster_info) {
-		if (scan_swap_map_try_ssd_cluster(si, &offset, &scan_base))
-			goto checks;
-		else
+		if (!scan_swap_map_try_ssd_cluster(si, &offset, &scan_base))
 			goto scan;
 	} else if (unlikely(!si->cluster_nr--)) {
 		if (si->pages - si->inuse_pages < SWAPFILE_CLUSTER) {
@@ -869,8 +867,6 @@ checks:
 	if (si->cluster_info) {
 		if (scan_swap_map_try_ssd_cluster(si, &offset, &scan_base))
 			goto checks;
-		else
-			goto done;
 	} else if (si->cluster_nr && !si->swap_map[++offset]) {
 		/* non-ssd case, still more slots in cluster? */
 		--si->cluster_nr;
_
