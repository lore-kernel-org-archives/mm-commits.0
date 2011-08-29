From: akpm@linux-foundation.org
Subject: + mm-change-isolate-mode-from-define-to-bitwise-type-fix.patch added to -mm tree
Date: Mon, 29 Aug 2011 13:39:56 -0700
Message-ID: <201108292039.p7TKdwvf024927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755026Ab1H2Ukk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Aug 2011 16:40:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, jweiner@redhat.com, mgorman@suse.de, riel@redhat.com


The patch titled
     mm-change-isolate-mode-from-define-to-bitwise-type-fix
has been added to the -mm tree.  Its filename is
     mm-change-isolate-mode-from-define-to-bitwise-type-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-change-isolate-mode-from-define-to-bitwise-type-fix
From: Minchan Kim <minchan.kim@gmail.com>

[c1e8b0ae8, mm-change-isolate-mode-from-define-to-bitwise-type]
made a mistake on the bitwise type.

This patch corrects it.

Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/mmzone.h~mm-change-isolate-mode-from-define-to-bitwise-type-fix include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-change-isolate-mode-from-define-to-bitwise-type-fix
+++ a/include/linux/mmzone.h
@@ -165,9 +165,9 @@ static inline int is_unevictable_lru(enu
 #define LRU_ALL	     ((1 << NR_LRU_LISTS) - 1)
 
 /* Isolate inactive pages */
-#define ISOLATE_INACTIVE	((__force fmode_t)0x1)
+#define ISOLATE_INACTIVE	((__force isolate_mode_t)0x1)
 /* Isolate active pages */
-#define ISOLATE_ACTIVE		((__force fmode_t)0x2)
+#define ISOLATE_ACTIVE		((__force isolate_mode_t)0x2)
 
 /* LRU Isolation modes. */
 typedef unsigned __bitwise__ isolate_mode_t;
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

mm-mempolicyc-fix-pgoff-in-mbind-vma-merge.patch
mm-compaction-trivial-clean-up-in-acct_isolated.patch
mm-change-isolate-mode-from-define-to-bitwise-type.patch
mm-change-isolate-mode-from-define-to-bitwise-type-fix.patch
mm-compaction-make-isolate_lru_page-filter-aware.patch
mm-compaction-make-isolate_lru_page-filter-aware-fix.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware-fix.patch
mm-migration-clean-up-unmap_and_move.patch
vmscan-add-block-plug-for-page-reclaim.patch
mm-vmscan-drop-nr_force_scan-from-get_scan_count.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch
xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch
ext4-warn-if-direct-reclaim-tries-to-writeback-pages.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority.patch
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch
mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch
vmscan-count-pages-into-balanced-for-zone-with-good-watermark.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
mm-add-free_hot_cold_page_list-helper.patch

