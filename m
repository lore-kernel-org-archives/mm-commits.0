Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE85D51C
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739443; cv=none; b=UFBeLA18tnACWisKUU7BP7Z4hq1TbRH/xx/khMe4tgjvXJ0Uaxgi/gtUJVSZfIDNLJMta+/+MG4Drq6T8CGyO04TkVmlGSt698tbFvtkCumPv0J0qy2UUNAPckE4AH0ZjRONw2ZjYFU/SQy7E3meJYm1qvsaQgUYduPPTNrZiRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739443; c=relaxed/simple;
	bh=mp2GGxdjKGG6Bm3Qob7sGs+ZuIA0r6pTZhsS8RLWRzw=;
	h=Date:To:From:Subject:Message-Id; b=Wct0S4s4eeN+h5oQ/M82g4nZkkzY9EaVVJshJw3POFfUAuEMgVZ47LUQGtQfSmwqOnB61aH6B0aEAD7eMfFPEkYlTTA16BjMpNtXlO04Pz+y/rOfvYVZKn6aNMmjjovrNvKjz84zcUrwzg32x+TQJF98wUB1tgwE28d57jcRKXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qVU2Kx4A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qVU2Kx4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4516BC433C7;
	Sat, 24 Feb 2024 01:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739443;
	bh=mp2GGxdjKGG6Bm3Qob7sGs+ZuIA0r6pTZhsS8RLWRzw=;
	h=Date:To:From:Subject:From;
	b=qVU2Kx4AKhpmi+iBlguy9Zs32ubrA4qk8LdHD3PC/+5tSVgLvwBHLfYo6GRs/4fxI
	 tC4TVuuVVweFwxwPzF6Rd7sK7KksklOg12Lfkwb+Un4rNfJ6MIt7XwOvPRjS4IctR2
	 4M5hGji4MKGaXMrZe85Lf1uvI2BrjBu4BGSLbTKk=
Date: Fri, 23 Feb 2024 17:50:42 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-remove-get_zspage_mapping.patch removed from -mm tree
Message-Id: <20240224015043.4516BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: remove get_zspage_mapping()
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-remove-get_zspage_mapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
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

mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools.patch
mm-zswap-change-zswap_pool-kref-to-percpu_ref.patch

