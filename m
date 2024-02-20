Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A674C67
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 00:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708389650; cv=none; b=KnIaS7y7bHt2IqBfyt7fuaih62kGC12KnGuNx/1qzH/48fxhe9LjK75vZGQWhliT0tFTlylvqHZD4HxujRvE08LiYgsdAOKyGY3Pf6A5tPd1hSn4EmRXErqZspNsa1k6OdkZ4WNpMBGOg3vAbYj21qB0U++5DwKkpBlxmOfCkyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708389650; c=relaxed/simple;
	bh=09REdStUODg4mFsGw+8RWclpPYrFpvEgFocdi87GdTk=;
	h=Date:To:From:Subject:Message-Id; b=qLK+OlM1/4GGf3Ktst2A/JPE8sGc+8YvmykOHHxflPodrN7rwiv/35Q0kzIClPfYXNUeERsM8yjPV++H0mS0pyA0whyXNVhzui9dKLg6l/Esj3rabUSzBjBl6avAdkdA1w7gDMjRwghsjHVjvKFGu0P/QA27FNqOWHDa43ySCGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zbfAbEUf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zbfAbEUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F613C433F1;
	Tue, 20 Feb 2024 00:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708389649;
	bh=09REdStUODg4mFsGw+8RWclpPYrFpvEgFocdi87GdTk=;
	h=Date:To:From:Subject:From;
	b=zbfAbEUfg7jF5dLzKeV5PwChhdm/Tf4MtEyyN9a12lAUvbXgktLe+h4CB0J4jjdTE
	 0YBElydT66slCIG7HCJILUz/MocWDA0jqe5/AddwLqsmGLBajyuwA2uNlWw7/hxQbr
	 hOvmFtebTOIRajilQL1L39n7Io4jglvzCGZS3Un4=
Date: Mon, 19 Feb 2024 16:40:48 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-remove-migrate_write_lock_nested.patch added to mm-unstable branch
Message-Id: <20240220004049.7F613C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: remove migrate_write_lock_nested()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-remove-migrate_write_lock_nested.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-remove-migrate_write_lock_nested.patch

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
Subject: mm/zsmalloc: remove migrate_write_lock_nested()
Date: Mon, 19 Feb 2024 13:33:52 +0000

The migrate write lock is to protect the race between zspage migration and
zspage objects' map users.

We only need to lock out the map users of src zspage, not dst zspage,
which is safe to map by users concurrently, since we only need to do
obj_malloc() from dst zspage.

So we can remove the migrate_write_lock_nested() use case.

As we are here, cleanup the __zs_compact() by moving putback_zspage()
outside of migrate_write_unlock since we hold pool lock, no malloc or free
users can come in.

Link: https://lkml.kernel.org/r/20240219-b4-szmalloc-migrate-v1-2-34cd49c6545b@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-remove-migrate_write_lock_nested
+++ a/mm/zsmalloc.c
@@ -279,7 +279,6 @@ static void migrate_lock_init(struct zsp
 static void migrate_read_lock(struct zspage *zspage);
 static void migrate_read_unlock(struct zspage *zspage);
 static void migrate_write_lock(struct zspage *zspage);
-static void migrate_write_lock_nested(struct zspage *zspage);
 static void migrate_write_unlock(struct zspage *zspage);
 
 #ifdef CONFIG_COMPACTION
@@ -1727,11 +1726,6 @@ static void migrate_write_lock(struct zs
 	write_lock(&zspage->lock);
 }
 
-static void migrate_write_lock_nested(struct zspage *zspage)
-{
-	write_lock_nested(&zspage->lock, SINGLE_DEPTH_NESTING);
-}
-
 static void migrate_write_unlock(struct zspage *zspage)
 {
 	write_unlock(&zspage->lock);
@@ -2003,19 +1997,17 @@ static unsigned long __zs_compact(struct
 			dst_zspage = isolate_dst_zspage(class);
 			if (!dst_zspage)
 				break;
-			migrate_write_lock(dst_zspage);
 		}
 
 		src_zspage = isolate_src_zspage(class);
 		if (!src_zspage)
 			break;
 
-		migrate_write_lock_nested(src_zspage);
-
+		migrate_write_lock(src_zspage);
 		migrate_zspage(pool, src_zspage, dst_zspage);
-		fg = putback_zspage(class, src_zspage);
 		migrate_write_unlock(src_zspage);
 
+		fg = putback_zspage(class, src_zspage);
 		if (fg == ZS_INUSE_RATIO_0) {
 			free_zspage(pool, class, src_zspage);
 			pages_freed += class->pages_per_zspage;
@@ -2025,7 +2017,6 @@ static unsigned long __zs_compact(struct
 		if (get_fullness_group(class, dst_zspage) == ZS_INUSE_RATIO_100
 		    || spin_is_contended(&pool->lock)) {
 			putback_zspage(class, dst_zspage);
-			migrate_write_unlock(dst_zspage);
 			dst_zspage = NULL;
 
 			spin_unlock(&pool->lock);
@@ -2034,15 +2025,12 @@ static unsigned long __zs_compact(struct
 		}
 	}
 
-	if (src_zspage) {
+	if (src_zspage)
 		putback_zspage(class, src_zspage);
-		migrate_write_unlock(src_zspage);
-	}
 
-	if (dst_zspage) {
+	if (dst_zspage)
 		putback_zspage(class, dst_zspage);
-		migrate_write_unlock(dst_zspage);
-	}
+
 	spin_unlock(&pool->lock);
 
 	return pages_freed;
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

