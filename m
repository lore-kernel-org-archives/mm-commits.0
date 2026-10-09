Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0CC409103
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525492; cv=none; b=BBFKtivuiRZn50sEhxZUSc7ACb9juDB6jfxwyAZxtTESgOjDVgfnGB505hJVgngpWeTM0Ts3U9e7WGPFBOrsyO5+9K1wZUPwVYHwzm/5SZub9irqdypYGBYw1mony/eQ9bs/xhOCwW+DY+fI99bMZ4WBhBMfWdRNuQAV0xKr71o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525492; c=relaxed/simple;
	bh=GrBN8+L+DFI2G2i07+QDDK1FsxW4KBl5nn8JkkwEAxU=;
	h=Date:To:From:Subject:Message-Id; b=GmdqVbqr6L3V8TXZFsc0lI85oFDGdEHpz5Pb1gDY8IeqEGBLwL5ZnTFfaWQdqFZ9oZJAtwcRfqLAGnjz7IwS+fE4TpHE8t72uaDGGI/iO5DZhKO0Cf0RLSU+Qm+g5pkWYb7qVqYxdfOefyeqwo1y3BlsomBtna8tkoBmdR9xuXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=skU8dqxo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="skU8dqxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54B11F000FF;
	Fri,  9 Oct 2026 05:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525490;
	bh=O/mETMRHNxGXlXFFt7FM/5ow/VO+/KSkx8RcovuH/RE=;
	h=Date:To:From:Subject;
	b=skU8dqxo3xdF4s01EtPzZGVlpmVSeZHbi+BVaWA4clQPc0oLVjj9JiSDKEw1xTB++
	 JaezEjb6eZ87k2H4qTCdkmL1nLOEK1FePPQluTTvw3d5Qwr1k9ektXpjt5oICKFzLU
	 oqQjA08eswPcpgJCE27h5h78JjGEYFKt0QGYD1yE=
Date: Thu, 08 Oct 2026 22:58:10 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,yosryahmed@google.com,nphamcs@gmail.com,kasong@tencent.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-convert-zswap_invalidate-to-take-a-range.patch removed from -mm tree
Message-Id: <20261009055810.D54B11F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: convert zswap_invalidate() to take a range
has been removed from the -mm tree.  Its filename was
     mm-zswap-convert-zswap_invalidate-to-take-a-range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: zswap: convert zswap_invalidate() to take a range
Date: Thu, 10 Sep 2026 20:35:42 +0800

Patch series "mm: zswap: optimize zswap invalidate and store", v3.

This series range-ifies zswap_invalidate() to skip xarray lookups when
zswap is unused, and reuses it in zswap_store() to eliminate redundant
per-slot lookups and open-coded logic.


This patch (of 3):

zswap_invalidate() takes a swp_entry_t only to unpack it right back into
type and offset, and both callers already have those values in hand.  Pass
type, offset, and nr_entries directly so swap_range_free() can invalidate
an entire range in one call instead of looping in the caller.

Link: https://lore.kernel.org/20260910123544.818146-1-wangkefeng.wang@huawei.com
Link: https://lore.kernel.org/20260910123544.818146-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
---

 include/linux/zswap.h |    8 ++++++--
 mm/swapfile.c         |    4 +---
 mm/zswap.c            |   29 +++++++++++++++++++----------
 3 files changed, 26 insertions(+), 15 deletions(-)

--- a/include/linux/zswap.h~mm-zswap-convert-zswap_invalidate-to-take-a-range
+++ a/include/linux/zswap.h
@@ -27,7 +27,7 @@ struct zswap_lruvec_state {
 unsigned long zswap_total_pages(void);
 bool zswap_store(struct folio *folio);
 int zswap_load(struct folio *folio);
-void zswap_invalidate(swp_entry_t swp);
+void zswap_invalidate(int type, pgoff_t offset, unsigned long nr_entries);
 int zswap_swapon(int type, unsigned long nr_pages);
 void zswap_swapoff(int type);
 void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg);
@@ -49,7 +49,11 @@ static inline int zswap_load(struct foli
 	return -ENOENT;
 }
 
-static inline void zswap_invalidate(swp_entry_t swp) {}
+static inline void zswap_invalidate(int type, pgoff_t offset,
+		unsigned long nr_entries)
+{
+}
+
 static inline int zswap_swapon(int type, unsigned long nr_pages)
 {
 	return 0;
--- a/mm/swapfile.c~mm-zswap-convert-zswap_invalidate-to-take-a-range
+++ a/mm/swapfile.c
@@ -1316,10 +1316,8 @@ static void swap_range_free(struct swap_
 {
 	unsigned long end = offset + nr_entries - 1;
 	void (*swap_slot_free_notify)(struct block_device *, unsigned long);
-	unsigned int i;
 
-	for (i = 0; i < nr_entries; i++)
-		zswap_invalidate(swp_entry(si->type, offset + i));
+	zswap_invalidate(si->type, offset, nr_entries);
 
 	if (si->flags & SWP_BLKDEV)
 		swap_slot_free_notify =
--- a/mm/zswap.c~mm-zswap-convert-zswap_invalidate-to-take-a-range
+++ a/mm/zswap.c
@@ -228,10 +228,15 @@ static bool zswap_has_pool;
 /* One swap address space for each 64M swap space */
 #define ZSWAP_ADDRESS_SPACE_SHIFT 14
 #define ZSWAP_ADDRESS_SPACE_PAGES (1 << ZSWAP_ADDRESS_SPACE_SHIFT)
+
+static inline struct xarray *zswap_tree(int type, pgoff_t offset)
+{
+	return &zswap_trees[type][offset >> ZSWAP_ADDRESS_SPACE_SHIFT];
+}
+
 static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
 {
-	return &zswap_trees[swp_type(swp)][swp_offset(swp)
-		>> ZSWAP_ADDRESS_SPACE_SHIFT];
+	return zswap_tree(swp_type(swp), swp_offset(swp));
 }
 
 #define zswap_pool_debug(msg, p)			\
@@ -1656,18 +1661,22 @@ int zswap_load(struct folio *folio)
 	return 0;
 }
 
-void zswap_invalidate(swp_entry_t swp)
+void zswap_invalidate(int type, pgoff_t offset, unsigned long nr_entries)
 {
-	pgoff_t offset = swp_offset(swp);
-	struct xarray *tree = swap_zswap_tree(swp);
 	struct zswap_entry *entry;
+	struct xarray *tree;
+	unsigned long i;
 
-	if (xa_empty(tree))
-		return;
+	for (i = 0; i < nr_entries; i++) {
+		tree = zswap_tree(type, offset + i);
 
-	entry = xa_erase(tree, offset);
-	if (entry)
-		zswap_entry_free(entry);
+		if (xa_empty(tree))
+			continue;
+
+		entry = xa_erase(tree, offset + i);
+		if (entry)
+			zswap_entry_free(entry);
+	}
 }
 
 int zswap_swapon(int type, unsigned long nr_pages)
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-mincore-use-per-vma-lock-during-page-table-walk.patch

