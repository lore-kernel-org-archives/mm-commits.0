From: akpm@linux-foundation.org
Subject: + mm-bail-out-in-shrin_inactive_list-fix.patch added to -mm tree
Date: Mon, 25 Jul 2016 16:27:04 -0700
Message-ID: <5796a048.XrquGG2UW8bTl53J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbcGYX1F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2016 19:27:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mgorman@techsingularity.net, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-bail-out-in-shrin_inactive_list-fix
has been added to the -mm tree.  Its filename is
     mm-bail-out-in-shrin_inactive_list-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-bail-out-in-shrin_inactive_list-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-bail-out-in-shrin_inactive_list-fix.patch

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
Subject: mm-bail-out-in-shrin_inactive_list-fix

fixes per Mel

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/vmscan.c~mm-bail-out-in-shrin_inactive_list-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-bail-out-in-shrin_inactive_list-fix
+++ a/mm/vmscan.c
@@ -1652,13 +1652,12 @@ static int current_may_throttle(void)
 		bdi_write_congested(current->backing_dev_info);
 }
 
-static inline bool inactive_reclaimable_pages(struct lruvec *lruvec,
-				struct scan_control *sc,
-				enum lru_list lru)
+static bool inactive_reclaimable_pages(struct lruvec *lruvec,
+				struct scan_control *sc, enum lru_list lru)
 {
 	int zid;
 	struct zone *zone;
-	bool file = is_file_lru(lru);
+	int file = is_file_lru(lru);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
 	if (!global_reclaim(sc))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-improve-recovery-performance-v2-fix.patch
ocfs2-dlm-disable-bug_on-when-dlm_lock_res_dropping_ref-is-cleared-before-dlm_deref_lockres_done_handler-fix.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-balloon-use-general-non-lru-movable-page-feature-fix.patch
mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
mm-fix-build-warnings-in-linux-compactionh-fix.patch
mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes.patch
mm-bail-out-in-shrin_inactive_list-fix.patch
revert-mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements-checkpatch-fixes.patch
mm-optimize-copy_page_to-from_iter_iovec-fix.patch
mm-optimize-copy_page_to-from_iter_iovec-fix-fix.patch
treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes.patch
printk-create-pr_level-functions-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
allow-kdump-with-crash_kexec_post_notifiers-fix.patch
kexec-add-resriction-on-the-kexec_load-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

