Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C2D77650
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 17:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708451935; cv=none; b=YkQvspcWMYDdsCto4NWj1D2NPWmNjSaz9wXcDYD9Ha6/h4vnxqqsd4TzLAIGt/lK7mSfJigyVznwL5+W/kU8atjK34rsEoe0NzIwONCrLmNiK+J8G04el/Ah/DP5tnO/dC/zdswjwWArSPHEVd+bDr60j14NlHZNoWGMOM7mPJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708451935; c=relaxed/simple;
	bh=pT+CzV6qF6Mj1+K4sRv4v5TS68ZxvZbG6t1p/APiBLA=;
	h=Date:To:From:Subject:Message-Id; b=rBvKyuXEHmEiv0r5ysKnwmADy4z7WsCP2lQ+LXQewHKP2urrU6dXLFtjdQf/HIrZAdsz2uk9Lzx91gqbNdwoDgwMUkQp5fYstUO5zJMIiE5E59dNhb4oskHDtVHOJmv8oDzieJmq1drhDZablMqyGkX+Qh8AjPTj7uxjEW1P6BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PesZAUOS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PesZAUOS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A19BC433C7;
	Tue, 20 Feb 2024 17:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708451934;
	bh=pT+CzV6qF6Mj1+K4sRv4v5TS68ZxvZbG6t1p/APiBLA=;
	h=Date:To:From:Subject:From;
	b=PesZAUOSf8KRGotKSUWcK5jasLUkQ9TrxS8H/ksCTgANq0KCpUgdh2c/Bi10GVvv5
	 Tu5EuvS2HwZ/HAXOU+kWT/ZOPbNaneeksuQl/jheTMNiovqxaiF4ICepx+yPYx7zkf
	 6Ew7F9QyFE9FCGwiXZjjmLdLFqOSOD3G1p0YUlC4=
Date: Tue, 20 Feb 2024 09:58:54 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-remove-get_zspage_mapping.patch added to mm-unstable branch
Message-Id: <20240220175854.9A19BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: remove get_zspage_mapping()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-remove-get_zspage_mapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-remove-get_zspage_mapping.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zsmalloc: remove get_zspage_mapping()
Date: Tue, 20 Feb 2024 06:53:02 +0000

Actually we seldom use the class_idx returned from get_zspage_mapping(),
only the zspage->fullness is useful, just use zspage->fullness to remove
this helper.

Note zspage->fullness is not stable outside pool->lock, remove redundant
"VM_BUG_ON(fullness != ZS_INUSE_RATIO_0)" in async_free_zspage() since we
already have the same VM_BUG_ON() in __free_zspage(), which is safe to
access zspage->fullness with pool->lock held.

Link: https://lkml.kernel.org/r/20240220-b4-zsmalloc-cleanup-v1-3-5c5ee4ccdd87@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   28 ++++------------------------
 1 file changed, 4 insertions(+), 24 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-remove-get_zspage_mapping
+++ a/mm/zsmalloc.c
@@ -470,16 +470,6 @@ static inline void set_freeobj(struct zs
 	zspage->freeobj = obj;
 }
 
-static void get_zspage_mapping(struct zspage *zspage,
-			       unsigned int *class_idx,
-			       int *fullness)
-{
-	BUG_ON(zspage->magic != ZSPAGE_MAGIC);
-
-	*fullness = zspage->fullness;
-	*class_idx = zspage->class;
-}
-
 static struct size_class *zspage_class(struct zs_pool *pool,
 				       struct zspage *zspage)
 {
@@ -708,12 +698,10 @@ static void remove_zspage(struct size_cl
  */
 static int fix_fullness_group(struct size_class *class, struct zspage *zspage)
 {
-	int class_idx;
-	int currfg, newfg;
+	int newfg;
 
-	get_zspage_mapping(zspage, &class_idx, &currfg);
 	newfg = get_fullness_group(class, zspage);
-	if (newfg == currfg)
+	if (newfg == zspage->fullness)
 		goto out;
 
 	remove_zspage(class, zspage);
@@ -835,15 +823,11 @@ static void __free_zspage(struct zs_pool
 				struct zspage *zspage)
 {
 	struct page *page, *next;
-	int fg;
-	unsigned int class_idx;
-
-	get_zspage_mapping(zspage, &class_idx, &fg);
 
 	assert_spin_locked(&pool->lock);
 
 	VM_BUG_ON(get_zspage_inuse(zspage));
-	VM_BUG_ON(fg != ZS_INUSE_RATIO_0);
+	VM_BUG_ON(zspage->fullness != ZS_INUSE_RATIO_0);
 
 	next = page = get_first_page(zspage);
 	do {
@@ -1857,8 +1841,6 @@ static void async_free_zspage(struct wor
 {
 	int i;
 	struct size_class *class;
-	unsigned int class_idx;
-	int fullness;
 	struct zspage *zspage, *tmp;
 	LIST_HEAD(free_pages);
 	struct zs_pool *pool = container_of(work, struct zs_pool,
@@ -1879,10 +1861,8 @@ static void async_free_zspage(struct wor
 		list_del(&zspage->list);
 		lock_zspage(zspage);
 
-		get_zspage_mapping(zspage, &class_idx, &fullness);
-		VM_BUG_ON(fullness != ZS_INUSE_RATIO_0);
-		class = pool->size_class[class_idx];
 		spin_lock(&pool->lock);
+		class = zspage_class(pool, zspage);
 		__free_zspage(pool, class, zspage);
 		spin_unlock(&pool->lock);
 	}
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zswap-invalidate-duplicate-entry-when-zswap_enabled.patch
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

