Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88D81534F5;
	Tue, 20 Feb 2024 22:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708467750; cv=none; b=ftaMeztVPLjIUEjXI0Msi0QInzOqFzuNLiylrClXXsu0RpUfe8fXyJW2FlVcCk7EthLHx1vd7T4ImC7LnOiep1eXt5CgPXNfnFQK5JrgDnd5XeVpjZjV1ieuW07N8Kg9iqp+oe7GwiDk5zS8aHl7mMaDlxpwLmVhz1JB9BW+ecE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708467750; c=relaxed/simple;
	bh=VdS5YoS9WdODIfdAuprmQTgrbit/VxlKgHmvgyt12k0=;
	h=Date:To:From:Subject:Message-Id; b=DOTPPnGchejRKUwcrPR11PM7vp8O8PZOkMiedPeJrbK/YfXnM20jbh5kNCSgK+kwsA8o5F2h2acfduqZHaHIhrDvz6mr0mL/LAsJ3PSbMLllNBAhsASgC73+fsdp7hkL8cEYXNkEvS1pMRB5AMvy2tnYosAul4XWcvO9sMSC3xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hVtz3vTf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hVtz3vTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B61C43390;
	Tue, 20 Feb 2024 22:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708467750;
	bh=VdS5YoS9WdODIfdAuprmQTgrbit/VxlKgHmvgyt12k0=;
	h=Date:To:From:Subject:From;
	b=hVtz3vTfcP/cRyE2T7OAHQpl0k4eKoXOnJCtFTP8yoSQi284iwnRKvxiF3sFrhr0W
	 yY2B40m3A2Xz4tNG7aACXWuYZqZ7LlQiJOIJnz1RYuQKU52YHh+0Fr5rXWREOfk6fe
	 +A7CYMlhZAT5Vj05gc/G6FZEuhntNMZnHLw65ksA=
Date: Tue, 20 Feb 2024 14:22:29 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,stable@vger.kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-zswap-invalidate-duplicate-entry-when-zswap_enabled.patch removed from -mm tree
Message-Id: <20240220222230.20B61C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: invalidate duplicate entry when !zswap_enabled
has been removed from the -mm tree.  Its filename was
     mm-zswap-invalidate-duplicate-entry-when-zswap_enabled.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zswap: invalidate duplicate entry when !zswap_enabled
Date: Thu, 8 Feb 2024 02:32:54 +0000

We have to invalidate any duplicate entry even when !zswap_enabled since
zswap can be disabled anytime.  If the folio store success before, then
got dirtied again but zswap disabled, we won't invalidate the old
duplicate entry in the zswap_store().  So later lru writeback may
overwrite the new data in swapfile.

Link: https://lkml.kernel.org/r/20240208023254.3873823-1-chengming.zhou@linux.dev
Fixes: 42c06a0e8ebe ("mm: kill frontswap")
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-invalidate-duplicate-entry-when-zswap_enabled
+++ a/mm/zswap.c
@@ -1518,7 +1518,7 @@ bool zswap_store(struct folio *folio)
 	if (folio_test_large(folio))
 		return false;
 
-	if (!zswap_enabled || !tree)
+	if (!tree)
 		return false;
 
 	/*
@@ -1533,6 +1533,10 @@ bool zswap_store(struct folio *folio)
 		zswap_invalidate_entry(tree, dupentry);
 	}
 	spin_unlock(&tree->lock);
+
+	if (!zswap_enabled)
+		return false;
+
 	objcg = get_obj_cgroup_from_folio(folio);
 	if (objcg && !obj_cgroup_may_zswap(objcg)) {
 		memcg = get_mem_cgroup_from_objcg(objcg);
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zswap-make-sure-each-swapfile-always-have-zswap-rb-tree.patch
mm-zswap-split-zswap-rb-tree.patch
mm-zswap-fix-race-between-lru-writeback-and-swapoff.patch
mm-list_lru-remove-list_lru_putback.patch
mm-zswap-add-more-comments-in-shrink_memcg_cb.patch
mm-zswap-invalidate-zswap-entry-when-swap-entry-free.patch
mm-zswap-stop-lru-list-shrinking-when-encounter-warm-region.patch
mm-zswap-remove-duplicate_entry-debug-value.patch
mm-zswap-only-support-zswap_exclusive_loads_enabled.patch
mm-zswap-zswap-entry-doesnt-need-refcount-anymore.patch
mm-zswap-optimize-and-cleanup-the-invalidation-of-duplicate-entry.patch
mm-zsmalloc-fix-migrate_write_lock-when-config_compaction.patch
mm-zsmalloc-remove-migrate_write_lock_nested.patch
mm-zsmalloc-remove-unused-zspage-isolated.patch
mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools.patch
mm-zswap-change-zswap_pool-kref-to-percpu_ref.patch
mm-zsmalloc-remove-set_zspage_mapping.patch
mm-zsmalloc-remove_zspage-dont-need-fullness-parameter.patch
mm-zsmalloc-remove-get_zspage_mapping.patch
maintainers-add-chengming-zhou-as-a-zswap-reviewer.patch

