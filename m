From: akpm@linux-foundation.org
Subject: + mm-swap-add-swap_cluster_list-checkpatch-fixes.patch added to
 -mm tree
Date: Wed, 24 Aug 2016 14:20:10 -0700
Message-ID: <57be0f8a.jZC0CxhXxBKATXtW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58386 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752745AbcHXVV0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2016 17:21:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-swap-add-swap_cluster_list-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-swap-add-swap_cluster_list-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-add-swap_cluster_list-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-add-swap_cluster_list-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
sysctl-handle-error-writing-uint_max-to-u32-fields-checkpatch-fixes.patch
sysctl-handle-error-writing-uint_max-to-u32-fields-checkpatch-fixes-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
mm-swap-add-swap_cluster_list-checkpatch-fixes.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

