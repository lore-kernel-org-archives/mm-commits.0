From: akpm@linux-foundation.org
Subject: [folded-merged]
 kasan-detect-negative-size-in-memory-operation-function-fix.patch removed
 from -mm tree
Date: Wed, 01 Apr 2020 20:33:22 -0700
Message-ID: <20200402033322.rt7wSdrwU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732498AbgDBDdZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 1 Apr 2020 23:33:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, mm-commits@vger.kernel.org, walter-zh.wu@mediatek.com


The patch titled
     Subject: kasan/tags: fix -Wdeclaration-after-statement warn
has been removed from the -mm tree.  Its filename was
     kasan-detect-negative-size-in-memory-operation-function-fix.patch

This patch was dropped because it was folded into kasan-detect-negative-size-in-memory-operation-function.patch

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
kasan-detect-negative-size-in-memory-operation-function.patch
mm-vmscan-fix-data-races-at-kswapd_classzone_idx.patch
