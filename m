Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05F04C67
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 00:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708389651; cv=none; b=aDmphwXMKrWKFEAk5efI7tqOg5xLZPpEN+IL265Ohpi0UgtBizfgAukX+/qlOtTO32fgz6KDU3AfnUw0OGg674/8SoTQG4ajfXjYlCYUCTbzCnsv+YFdqAa6gx1qZ5HlGRSZ5Y2wQWE04SypU4PW50E1m6YxnlLmHo14AgN7MYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708389651; c=relaxed/simple;
	bh=Kbaommqc8lSaSKYvw0gLOQgfHzsanX1A122rI+UynIE=;
	h=Date:To:From:Subject:Message-Id; b=oKUEOSWHA+g9k+Kqms5J7P70JSty0QULNkNg1lYaEN/7hJ87OheX5krbiwccHEAVgS9aHww7JFQ5dg7E7MN9Fxuf6Q6FHbFI5ScvSJZGlfOWewphT5pnul0iVwaHCqEhpaaZfumdsn9vA3/EXCAGR+bejKwpsIhA3eU8717kVaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N2Tta9mo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N2Tta9mo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB77C433F1;
	Tue, 20 Feb 2024 00:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708389651;
	bh=Kbaommqc8lSaSKYvw0gLOQgfHzsanX1A122rI+UynIE=;
	h=Date:To:From:Subject:From;
	b=N2Tta9moxQrtHVt0qH3/3mNQyD2Ikjkob1Ept1Ov4tq6GkcCak2qt6S6Eo/7gDt56
	 R7rtdGa1I0BW5+N+mekTAgPuTiochr3T6vLYCGy86ZiK9iVm3psf2bNB2d+TMv7K9o
	 bkOr5oHrT2/9LItqAQ4WB3h1zQVeesgfO9CbRGJ0=
Date: Mon, 19 Feb 2024 16:40:50 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-remove-unused-zspage-isolated.patch added to mm-unstable branch
Message-Id: <20240220004051.3CB77C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: remove unused zspage->isolated
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-remove-unused-zspage-isolated.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-remove-unused-zspage-isolated.patch

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
Subject: mm/zsmalloc: remove unused zspage->isolated
Date: Mon, 19 Feb 2024 13:33:53 +0000

The zspage->isolated is not used anywhere, we don't need to maintain it,
which needs to hold the heavy pool lock to update it, so just remove it.

Link: https://lkml.kernel.org/r/20240219-b4-szmalloc-migrate-v1-3-34cd49c6545b@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   32 --------------------------------
 1 file changed, 32 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-remove-unused-zspage-isolated
+++ a/mm/zsmalloc.c
@@ -116,7 +116,6 @@
 #define HUGE_BITS	1
 #define FULLNESS_BITS	4
 #define CLASS_BITS	8
-#define ISOLATED_BITS	5
 #define MAGIC_VAL_BITS	8
 
 #define MAX(a, b) ((a) >= (b) ? (a) : (b))
@@ -246,7 +245,6 @@ struct zspage {
 		unsigned int huge:HUGE_BITS;
 		unsigned int fullness:FULLNESS_BITS;
 		unsigned int class:CLASS_BITS + 1;
-		unsigned int isolated:ISOLATED_BITS;
 		unsigned int magic:MAGIC_VAL_BITS;
 	};
 	unsigned int inuse;
@@ -1732,17 +1730,6 @@ static void migrate_write_unlock(struct
 }
 
 #ifdef CONFIG_COMPACTION
-/* Number of isolated subpage for *page migration* in this zspage */
-static void inc_zspage_isolation(struct zspage *zspage)
-{
-	zspage->isolated++;
-}
-
-static void dec_zspage_isolation(struct zspage *zspage)
-{
-	VM_BUG_ON(zspage->isolated == 0);
-	zspage->isolated--;
-}
 
 static const struct movable_operations zsmalloc_mops;
 
@@ -1771,21 +1758,12 @@ static void replace_sub_page(struct size
 
 static bool zs_page_isolate(struct page *page, isolate_mode_t mode)
 {
-	struct zs_pool *pool;
-	struct zspage *zspage;
-
 	/*
 	 * Page is locked so zspage couldn't be destroyed. For detail, look at
 	 * lock_zspage in free_zspage.
 	 */
 	VM_BUG_ON_PAGE(PageIsolated(page), page);
 
-	zspage = get_zspage(page);
-	pool = zspage->pool;
-	spin_lock(&pool->lock);
-	inc_zspage_isolation(zspage);
-	spin_unlock(&pool->lock);
-
 	return true;
 }
 
@@ -1850,7 +1828,6 @@ static int zs_page_migrate(struct page *
 	kunmap_atomic(s_addr);
 
 	replace_sub_page(class, zspage, newpage, page);
-	dec_zspage_isolation(zspage);
 	/*
 	 * Since we complete the data copy and set up new zspage structure,
 	 * it's okay to release the pool's lock.
@@ -1872,16 +1849,7 @@ static int zs_page_migrate(struct page *
 
 static void zs_page_putback(struct page *page)
 {
-	struct zs_pool *pool;
-	struct zspage *zspage;
-
 	VM_BUG_ON_PAGE(!PageIsolated(page), page);
-
-	zspage = get_zspage(page);
-	pool = zspage->pool;
-	spin_lock(&pool->lock);
-	dec_zspage_isolation(zspage);
-	spin_unlock(&pool->lock);
 }
 
 static const struct movable_operations zsmalloc_mops = {
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

