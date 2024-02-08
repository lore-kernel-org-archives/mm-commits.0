Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BE467A13
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 05:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707369683; cv=none; b=utDfntoWteFDMdh3xUkAFz2SSV/K/qdP/gEyJD8gHJs5p0l9/eCaqZ2ucmU0QKx87+CUKGzsPwX1dikv8eD6/tlaoKfnlcoBKrFI4gHwAZvgxz7SmIogcwN2A61WSrf010QdNSr3dv7tX8Jw30BJ9pt0UiIBVQ2F+YK0mCDEIw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707369683; c=relaxed/simple;
	bh=grJOwpPynE+90zQo0XLVpYi0arye36i9Sq3KFi+W7D4=;
	h=Date:To:From:Subject:Message-Id; b=ecbQBlGwahWyBnvMeff9LgyRnlJAmnX9sZZtJvhGQ9irJCZap+wrr77GVdLEJ9peQ9JBDUvjn7QXI4h0AlkRs3q1cIDq80iZUlnxsAKZ3Rcceg8WSDGzH+F6LAqAnnh5+BJfzKZC9okU36tkvvbFvLFzTkBT9vCRt1EB7PTbl28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kwNFiajp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kwNFiajp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D16C433F1;
	Thu,  8 Feb 2024 05:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707369683;
	bh=grJOwpPynE+90zQo0XLVpYi0arye36i9Sq3KFi+W7D4=;
	h=Date:To:From:Subject:From;
	b=kwNFiajprANv05XJWxbVj0uJHXm1tTTRNXlJFDKU16ZVX6FX/w8Xeh3SnJ2Hi1Xja
	 Y03p5kSAs2XYeudi6APCsvaP82oDrIPMPZerrbdX+DA10yqyVyMeLa1MFr7uJ0TNTN
	 De39V4YH/WWBVHyDJELL71Vc1AKc71N9l7Yn6gtU=
Date: Wed, 07 Feb 2024 21:21:22 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-zswap-fix-objcg-use-after-free-in-entry-destruction.patch removed from -mm tree
Message-Id: <20240208052123.14D16C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: fix objcg use-after-free in entry destruction
has been removed from the -mm tree.  Its filename was
     mm-zswap-fix-objcg-use-after-free-in-entry-destruction.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: fix objcg use-after-free in entry destruction
Date: Mon, 29 Jan 2024 20:34:38 -0500

In the per-memcg LRU universe, LRU removal uses entry->objcg to determine
which list count needs to be decreased.  Drop the objcg reference after
updating the LRU, to fix a possible use-after-free.

Link: https://lkml.kernel.org/r/20240130013438.565167-1-hannes@cmpxchg.org
Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/zswap.c~mm-zswap-fix-objcg-use-after-free-in-entry-destruction
+++ a/mm/zswap.c
@@ -536,10 +536,6 @@ static struct zpool *zswap_find_zpool(st
  */
 static void zswap_free_entry(struct zswap_entry *entry)
 {
-	if (entry->objcg) {
-		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
-		obj_cgroup_put(entry->objcg);
-	}
 	if (!entry->length)
 		atomic_dec(&zswap_same_filled_pages);
 	else {
@@ -548,6 +544,10 @@ static void zswap_free_entry(struct zswa
 		atomic_dec(&entry->pool->nr_stored);
 		zswap_pool_put(entry->pool);
 	}
+	if (entry->objcg) {
+		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
+		obj_cgroup_put(entry->objcg);
+	}
 	zswap_entry_cache_free(entry);
 	atomic_dec(&zswap_stored_pages);
 	zswap_update_total_size();
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-zswap-rename-zswap_free_entry-to-zswap_entry_free.patch
mm-zswap-inline-and-remove-zswap_entry_find_get.patch
mm-zswap-move-zswap_invalidate_entry-to-related-functions.patch
mm-zswap-warn-when-referencing-a-dead-entry.patch
mm-zswap-clean-up-zswap_entry_put.patch
mm-zswap-rename-__zswap_load-to-zswap_decompress.patch
mm-zswap-break-out-zwap_compress.patch
mm-zswap-further-cleanup-zswap_store.patch
mm-zswap-simplify-zswap_invalidate.patch
mm-zswap-function-ordering-pool-alloc-free.patch
mm-zswap-function-ordering-pool-refcounting.patch
mm-zswap-function-ordering-zswap_pools.patch
mm-zswap-function-ordering-pool-params.patch
mm-zswap-function-ordering-public-lru-api.patch
mm-zswap-function-ordering-move-entry-sections-out-of-lru-section.patch
mm-zswap-function-ordering-move-entry-section-out-of-tree-section.patch
mm-zswap-function-ordering-compress-decompress-functions.patch
mm-zswap-function-ordering-per-cpu-compression-infra.patch
mm-zswap-function-ordering-writeback.patch
mm-zswap-function-ordering-shrink_memcg_cb.patch

