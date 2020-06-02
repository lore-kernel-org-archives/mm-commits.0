From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 070/128] mm/swapfile.c: classify SWAP_MAP_XXX to
 make it more readable
Date: Tue, 02 Jun 2020 13:14:01 -0700
Message-ID: <20200602201401.nO7qGv7bt%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgFBUOD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 16:14:03 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, torvalds@linux-foundation.org

From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/swapfile.c: classify SWAP_MAP_XXX to make it more readable

swap_info_struct->swap_map[] encodes some flag and count. And to
do some condition check, it also introduces some special values.

Currently those macros are defined with some magic order, which makes
audience hard to understand the exact meaning.

This patch split those macros into three categories:

    flag
    special value for first swap_map
    special value for continued swap_map

May this help audiences a little.

[akpm@linux-foundation.org: tweak capitalization in comments]
Link: http://lkml.kernel.org/r/20200501015259.32237-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/include/linux/swap.h~mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable
+++ a/include/linux/swap.h
@@ -183,12 +183,17 @@ enum {
 #define SWAP_CLUSTER_MAX 32UL
 #define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
 
-#define SWAP_MAP_MAX	0x3e	/* Max duplication count, in first swap_map */
-#define SWAP_MAP_BAD	0x3f	/* Note pageblock is bad, in first swap_map */
+/* Bit flag in swap_map */
 #define SWAP_HAS_CACHE	0x40	/* Flag page is cached, in first swap_map */
-#define SWAP_CONT_MAX	0x7f	/* Max count, in each swap_map continuation */
-#define COUNT_CONTINUED	0x80	/* See swap_map continuation for full count */
-#define SWAP_MAP_SHMEM	0xbf	/* Owned by shmem/tmpfs, in first swap_map */
+#define COUNT_CONTINUED	0x80	/* Flag swap_map continuation for full count */
+
+/* Special value in first swap_map */
+#define SWAP_MAP_MAX	0x3e	/* Max count */
+#define SWAP_MAP_BAD	0x3f	/* Note page is bad */
+#define SWAP_MAP_SHMEM	0xbf	/* Owned by shmem/tmpfs */
+
+/* Special value in each swap_map continuation */
+#define SWAP_CONT_MAX	0x7f	/* Max count */
 
 /*
  * We use this to track usage of a cluster. A cluster is a block of swap disk
_
