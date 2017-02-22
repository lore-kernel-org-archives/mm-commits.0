From: akpm@linux-foundation.org
Subject: [folded-merged] mm-swap-add-cluster-lock-v5.patch removed from
 -mm tree
Date: Wed, 22 Feb 2017 15:25:17 -0800
Message-ID: <58ae1ddd.jpm9VOzy4tTZ3fmo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46368 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934166AbdBVXZS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:25:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, aarcange@redhat.com, aaron.lu@intel.com, ak@linux.intel.com, borntraeger@de.ibm.com, corbet@lwn.net, dave.hansen@intel.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, riel@redhat.com, shli@kernel.org, tim.c.chen@linux.intel.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-swap-add-cluster-lock-v5
has been removed from the -mm tree.  Its filename was
     mm-swap-add-cluster-lock-v5.patch

This patch was dropped because it was folded into mm-swap-add-cluster-lock.patch

------------------------------------------------------
From: "Huang\, Ying" <ying.huang@intel.com>
Subject: mm-swap-add-cluster-lock-v5

Link: http://lkml.kernel.org/r/878tqeuuic.fsf_-_@yhuang-dev.intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net> escreveu:
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   19 ++++++++++---------
 mm/swapfile.c        |   32 ++++++++++++++++----------------
 2 files changed, 26 insertions(+), 25 deletions(-)

diff -puN include/linux/swap.h~mm-swap-add-cluster-lock-v5 include/linux/swap.h
--- a/include/linux/swap.h~mm-swap-add-cluster-lock-v5
+++ a/include/linux/swap.h
@@ -176,16 +176,17 @@ enum {
  * protected by swap_info_struct.lock.
  */
 struct swap_cluster_info {
-	unsigned long data;
+	spinlock_t lock;	/*
+				 * Protect swap_cluster_info fields
+				 * and swap_info_struct->swap_map
+				 * elements correspond to the swap
+				 * cluster
+				 */
+	unsigned int data:24;
+	unsigned int flags:8;
 };
-#define CLUSTER_COUNT_SHIFT		8
-#define CLUSTER_FLAG_MASK		((1UL << CLUSTER_COUNT_SHIFT) - 1)
-#define CLUSTER_COUNT_MASK		(~CLUSTER_FLAG_MASK)
-#define CLUSTER_FLAG_FREE		1 /* This cluster is free */
-#define CLUSTER_FLAG_NEXT_NULL		2 /* This cluster has no next cluster */
-/* cluster lock, protect cluster_info contents and sis->swap_map */
-#define CLUSTER_FLAG_LOCK_BIT		2
-#define CLUSTER_FLAG_LOCK		(1 << CLUSTER_FLAG_LOCK_BIT)
+#define CLUSTER_FLAG_FREE 1 /* This cluster is free */
+#define CLUSTER_FLAG_NEXT_NULL 2 /* This cluster has no next cluster */
 
 /*
  * We assign a cluster to each CPU, so each CPU can allocate swap entry from
diff -puN mm/swapfile.c~mm-swap-add-cluster-lock-v5 mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-add-cluster-lock-v5
+++ a/mm/swapfile.c
@@ -200,66 +200,66 @@ static void discard_swap_cluster(struct
 #define LATENCY_LIMIT		256
 
 static inline void cluster_set_flag(struct swap_cluster_info *info,
-				    unsigned int flag)
+	unsigned int flag)
 {
-	info->data = (info->data & (CLUSTER_COUNT_MASK | CLUSTER_FLAG_LOCK)) |
-		(flag & ~CLUSTER_FLAG_LOCK);
+	info->flags = flag;
 }
 
 static inline unsigned int cluster_count(struct swap_cluster_info *info)
 {
-	return info->data >> CLUSTER_COUNT_SHIFT;
+	return info->data;
 }
 
 static inline void cluster_set_count(struct swap_cluster_info *info,
 				     unsigned int c)
 {
-	info->data = (c << CLUSTER_COUNT_SHIFT) | (info->data & CLUSTER_FLAG_MASK);
+	info->data = c;
 }
 
 static inline void cluster_set_count_flag(struct swap_cluster_info *info,
 					 unsigned int c, unsigned int f)
 {
-	info->data = (info->data & CLUSTER_FLAG_LOCK) |
-		(c << CLUSTER_COUNT_SHIFT) | (f & ~CLUSTER_FLAG_LOCK);
+	info->flags = f;
+	info->data = c;
 }
 
 static inline unsigned int cluster_next(struct swap_cluster_info *info)
 {
-	return cluster_count(info);
+	return info->data;
 }
 
 static inline void cluster_set_next(struct swap_cluster_info *info,
 				    unsigned int n)
 {
-	cluster_set_count(info, n);
+	info->data = n;
 }
 
 static inline void cluster_set_next_flag(struct swap_cluster_info *info,
 					 unsigned int n, unsigned int f)
 {
-	cluster_set_count_flag(info, n, f);
+	info->flags = f;
+	info->data = n;
 }
 
 static inline bool cluster_is_free(struct swap_cluster_info *info)
 {
-	return info->data & CLUSTER_FLAG_FREE;
+	return info->flags & CLUSTER_FLAG_FREE;
 }
 
 static inline bool cluster_is_null(struct swap_cluster_info *info)
 {
-	return info->data & CLUSTER_FLAG_NEXT_NULL;
+	return info->flags & CLUSTER_FLAG_NEXT_NULL;
 }
 
 static inline void cluster_set_null(struct swap_cluster_info *info)
 {
-	cluster_set_next_flag(info, 0, CLUSTER_FLAG_NEXT_NULL);
+	info->flags = CLUSTER_FLAG_NEXT_NULL;
+	info->data = 0;
 }
 
-/* Protect swap_cluster_info fields and si->swap_map */
 static inline void __lock_cluster(struct swap_cluster_info *ci)
 {
-	bit_spin_lock(CLUSTER_FLAG_LOCK_BIT, &ci->data);
+	spin_lock(&ci->lock);
 }
 
 static inline struct swap_cluster_info *lock_cluster(struct swap_info_struct *si,
@@ -278,7 +278,7 @@ static inline struct swap_cluster_info *
 static inline void unlock_cluster(struct swap_cluster_info *ci)
 {
 	if (ci)
-		bit_spin_unlock(CLUSTER_FLAG_LOCK_BIT, &ci->data);
+		spin_unlock(&ci->lock);
 }
 
 static inline struct swap_cluster_info *lock_cluster_or_swap_info(
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-swap-fix-kernel-message-in-swap_info_get.patch
mm-swap-add-cluster-lock.patch
mm-swap-split-swap-cache-into-64mb-trunks.patch
mm-swap-add-cache-for-swap-slots-allocation-fix.patch
mm-swap-skip-readahead-only-when-swap-slot-cache-is-enabled.patch
mm-swap-skip-readahead-only-when-swap-slot-cache-is-enabled-fix.patch

