From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-swap-add-swap_cluster_list-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 07 Oct 2016 16:37:07 -0700
Message-ID: <57f831a3.KgMVDZ1Of1Qhj+1c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38365 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753920AbcJGXhI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:37:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-swap-add-swap_cluster_list-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-swap-add-swap_cluster_list-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-swap-add-swap_cluster_list.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swap-add-swap_cluster_list-checkpatch-fixes

WARNING: Missing a blank line after declarations
#91: FILE: mm/swapfile.c:285:
+		unsigned int tail = cluster_next(&list->tail);
+		cluster_set_next(&ci[tail], idx);

WARNING: line over 80 characters
#261: FILE: mm/swapfile.c:2347:
+			cluster_list_add_tail(&p->free_clusters, cluster_info, idx);

total: 0 errors, 2 warnings, 222 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-swap-add-swap_cluster_list.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/swapfile.c~mm-swap-add-swap_cluster_list-checkpatch-fixes mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-add-swap_cluster_list-checkpatch-fixes
+++ a/mm/swapfile.c
@@ -282,6 +282,7 @@ static void cluster_list_add_tail(struct
 		cluster_set_next_flag(&list->tail, idx, 0);
 	} else {
 		unsigned int tail = cluster_next(&list->tail);
+
 		cluster_set_next(&ci[tail], idx);
 		cluster_set_next_flag(&list->tail, idx, 0);
 	}
@@ -2344,7 +2345,8 @@ static int setup_swap_map_and_extents(st
 	for (i = 0; i < nr_clusters; i++) {
 		if (!cluster_count(&cluster_info[idx])) {
 			cluster_set_flag(&cluster_info[idx], CLUSTER_FLAG_FREE);
-			cluster_list_add_tail(&p->free_clusters, cluster_info, idx);
+			cluster_list_add_tail(&p->free_clusters, cluster_info,
+					      idx);
 		}
 		idx++;
 		if (idx == nr_clusters)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-swap-add-swap_cluster_list.patch
mm-mlock-check-against-vma-for-actual-mlock-size-fix.patch
mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page.patch
mm-memcontrol-consolidate-cgroup-socket-tracking-checkpatch-fixes.patch
mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node-v2-fix.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
a.patch

