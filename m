From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 kasan-detect-negative-size-in-memory-operation-function-fix.patch added to
 -mm tree
Date: Sat, 07 Mar 2020 15:11:23 -0800
Message-ID: <20200307231123.SSdia7THE%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbgCGXLY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Mar 2020 18:11:24 -0500
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, mm-commits@vger.kernel.org, walter-zh.wu@mediatek.com


The patch titled
     Subject: kasan/tags: fix -Wdeclaration-after-statement warn
has been added to the -mm tree.  Its filename is
     kasan-detect-negative-size-in-memory-operation-function-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-detect-negative-size-in-memory-operation-function-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-detect-negative-size-in-memory-operation-function-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: kasan/tags: fix -Wdeclaration-after-statement warn

The linux-next commit "kasan: detect negative size in memory operation
function" introduced a compilation warning,

mm/kasan/tags_report.c:51:27: warning: ISO C90 forbids mixing
declarations and code [-Wdeclaration-after-statement]
        struct kasan_alloc_meta *alloc_meta;

Fix it by moving a code around a bit where there is no strict
dependency.

Link: http://lkml.kernel.org/r/1583509030-27939-1-git-send-email-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Walter Wu <walter-zh.wu@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/tags_report.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/mm/kasan/tags_report.c~kasan-detect-negative-size-in-memory-operation-function-fix
+++ a/mm/kasan/tags_report.c
@@ -36,17 +36,6 @@
 
 const char *get_bug_type(struct kasan_access_info *info)
 {
-	/*
-	 * If access_size is a negative number, then it has reason to be
-	 * defined as out-of-bounds bug type.
-	 *
-	 * Casting negative numbers to size_t would indeed turn up as
-	 * a large size_t and its value will be larger than ULONG_MAX/2,
-	 * so that this can qualify as out-of-bounds.
-	 */
-	if (info->access_addr + info->access_size < info->access_addr)
-		return "out-of-bounds";
-
 #ifdef CONFIG_KASAN_SW_TAGS_IDENTIFY
 	struct kasan_alloc_meta *alloc_meta;
 	struct kmem_cache *cache;
@@ -71,6 +60,17 @@ const char *get_bug_type(struct kasan_ac
 	}
 
 #endif
+	/*
+	 * If access_size is a negative number, then it has reason to be
+	 * defined as out-of-bounds bug type.
+	 *
+	 * Casting negative numbers to size_t would indeed turn up as
+	 * a large size_t and its value will be larger than ULONG_MAX/2,
+	 * so that this can qualify as out-of-bounds.
+	 */
+	if (info->access_addr + info->access_size < info->access_addr)
+		return "out-of-bounds";
+
 	return "invalid-access";
 }
 
_

Patches currently in -mm which might be from cai@lca.pw are

mm-disable-kcsan-for-kmemleak.patch
mm-swapfile-fix-data-races-in-try_to_unuse.patch
kasan-detect-negative-size-in-memory-operation-function-fix.patch
mm-vmscan-fix-data-races-at-kswapd_classzone_idx.patch
percpu_counter-fix-a-data-race-at-vm_committed_as.patch
mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races-v2.patch
mm-swap_state-mark-various-intentional-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races-v2.patch
mm-page_counter-fix-various-data-races-at-memsw.patch
mm-memcontrol-fix-a-data-race-in-scan-count.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-mempool-fix-a-data-race-in-mempool_free.patch
mm-util-annotate-an-data-race-at-vm_committed_as.patch
mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
mm-annotate-a-data-race-in-page_zonenum.patch
mm-swap-annotate-data-races-for-lru_rotate_pvecs.patch
