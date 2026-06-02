Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932A73BED24
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439074; cv=none; b=LaGN+Qv/cS+WMJRxNAUQQoYT4ivT4AlLXRX7R/0Inde/UPcC/8T4ZRJIDEqAVz+mnRbVzeMLGFXYoBDS99e0SltE0EhQu636+k4AxkLudREtDsPwLw59r/qznLWYVtbn/5ADeDJin+CW7GtRksU0GJoxFCrxRniWMlIgn0oJTLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439074; c=relaxed/simple;
	bh=zDiBUyXiDHbQYrRsDoTRzd0m3maoOLHr4Qyy8EWBjgw=;
	h=Date:To:From:Subject:Message-Id; b=EbLV1PIgXI6UVJEC43w6oQrjpBJ9QiZ5SZZLesPl840HpiXBY43kWleuZ/LlOttT9PDOXWEdnTljA1SArUyEjXjA3hxsJQJERz+u+pgZ0gE7eSkaJtm9+BotQPV7iHPBtoGOY4UXlXhHn4KOIae8R4R4ReFtLr29/VMC24cWxN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MvJNkUF4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MvJNkUF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E76B1F00893;
	Tue,  2 Jun 2026 22:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439072;
	bh=g67UvZzL8UtMrbec6CYWwazCh6VSqwE6pvpgZhpDbkM=;
	h=Date:To:From:Subject;
	b=MvJNkUF4ZOBsAPnhCaIvPCcJGlx5wa9+3U2uQghIoga5EjicxjiAc+57J0Z5fygFs
	 aVbv/f0Cq9ePCjVChAucGfLpaTxdMmRzQSvFzvo+TeYPKUL16srjeVNoI+Q0ux/0aL
	 4lNq6zpyd+U4bLTvUGhLhq9s18oFDFsOvRd3Pv3c=
Date: Tue, 02 Jun 2026 15:24:32 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,youngjun.park@lge.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,ljs@kernel.org,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-support-flexible-batch-freeing-of-slots-in-different-memcgs.patch removed from -mm tree
Message-Id: <20260602222432.6E76B1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: support flexible batch freeing of slots in different memcgs
has been removed from the -mm tree.  Its filename was
     mm-swap-support-flexible-batch-freeing-of-slots-in-different-memcgs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: support flexible batch freeing of slots in different memcgs
Date: Sun, 17 May 2026 23:39:46 +0800

Instead of requiring the caller to ensure all slots are in the same memcg,
make the function handle different memcgs at once.

This is both a micro optimization and required for removing the memcg
lookup in the page table layer, so it can be unified at the swap layer.

We are not removing the memcg lookup in the page table in this commit.  It
has to be done after the memcg lookup is deferred to the swap layer.

Link: https://lore.kernel.org/20260517-swap-table-p4-v5-7-88ae43e064c7@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

--- a/mm/swapfile.c~mm-swap-support-flexible-batch-freeing-of-slots-in-different-memcgs
+++ a/mm/swapfile.c
@@ -1899,21 +1899,46 @@ void __swap_cluster_free_entries(struct
 				 unsigned int ci_start, unsigned int nr_pages)
 {
 	unsigned long old_tb;
+	unsigned int type = si->type;
+	unsigned short batch_id = 0, id_cur;
 	unsigned int ci_off = ci_start, ci_end = ci_start + nr_pages;
-	unsigned long offset = cluster_offset(si, ci) + ci_start;
+	unsigned long ci_head = cluster_offset(si, ci);
+	unsigned int batch_off = ci_off;
+	swp_entry_t entry;
 
 	VM_WARN_ON(ci->count < nr_pages);
 
 	ci->count -= nr_pages;
 	do {
 		old_tb = __swap_table_get(ci, ci_off);
-		/* Release the last ref, or after swap cache is dropped */
+		/*
+		 * Freeing is done after release of the last swap count
+		 * ref, or after swap cache is dropped
+		 */
 		VM_WARN_ON(!swp_tb_is_shadow(old_tb) || __swp_tb_get_count(old_tb) > 1);
 		__swap_table_set(ci, ci_off, null_to_swp_tb());
+
+		/*
+		 * Uncharge swap slots by memcg in batches. Consecutive
+		 * slots with the same cgroup id are uncharged together.
+		 */
+		entry = swp_entry(type, ci_head + ci_off);
+		id_cur = lookup_swap_cgroup_id(entry);
+		if (batch_id != id_cur) {
+			if (batch_id)
+				mem_cgroup_uncharge_swap(swp_entry(type, ci_head + batch_off),
+							 ci_off - batch_off);
+			batch_id = id_cur;
+			batch_off = ci_off;
+		}
 	} while (++ci_off < ci_end);
 
-	mem_cgroup_uncharge_swap(swp_entry(si->type, offset), nr_pages);
-	swap_range_free(si, offset, nr_pages);
+	if (batch_id) {
+		mem_cgroup_uncharge_swap(swp_entry(type, ci_head + batch_off),
+					 ci_off - batch_off);
+	}
+
+	swap_range_free(si, ci_head + ci_start, nr_pages);
 	swap_cluster_assert_empty(ci, ci_start, nr_pages, false);
 
 	if (!ci->count)
_

Patches currently in -mm which might be from kasong@tencent.com are


