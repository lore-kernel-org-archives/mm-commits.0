Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B4D23DB
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 00:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708389648; cv=none; b=uo/1/9tE61AvE35iKt5SU9kEGY2d0IDG8EPlinLaDOOWDhkAPCRMr+XKswRTFClA1zXj/XW9HozY9jLyVO3b5Yjb5son4dFecPnumOs1TUi2u0sYg07N+j+92ZeYcRCi9IixQW4f+sEST0qT7vr2WEdwaHGt4GlmnlMRArddgGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708389648; c=relaxed/simple;
	bh=1fkp6gZ1RyxAfe//N3N0WfrxK8ob2w7u05SWyk6p8f4=;
	h=Date:To:From:Subject:Message-Id; b=CllRxH6qNTAXmmhAOPzSVzqREYEAvhAuSOLWdmpz0X3UKsgsm5ms7GGh2yRR9Qka1KK2u1XjqJuSf13r0UdsjD0lzoxt6khfP07BE4qsPfRWmFNazUKEm3Pv8vxqrAyNC1f8+5tMt4Pes+VUZYiEvG+ouG5SaUKqcvpJkKlfKPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lJQu5tc7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lJQu5tc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B4AC433F1;
	Tue, 20 Feb 2024 00:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708389647;
	bh=1fkp6gZ1RyxAfe//N3N0WfrxK8ob2w7u05SWyk6p8f4=;
	h=Date:To:From:Subject:From;
	b=lJQu5tc7KE1CQulzpPQ20phKMsyLHQNL4ejAVRlX8pvuWsD+eDdI34q6/f0wHxD2t
	 4eDrpdeA5M7wwKFWqQyV5484ewrVjwV/5RJHiySfQtxCsHNNtvJwWANYxkP5DeBvel
	 jQAGCDtITeuHoMJ276MtpzNinSQtZ938kGUeWnN0=
Date: Mon, 19 Feb 2024 16:40:46 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-fix-migrate_write_lock-when-config_compaction.patch added to mm-unstable branch
Message-Id: <20240220004047.99B4AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: fix migrate_write_lock() when !CONFIG_COMPACTION
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-fix-migrate_write_lock-when-config_compaction.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-fix-migrate_write_lock-when-config_compaction.patch

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
Subject: mm/zsmalloc: fix migrate_write_lock() when !CONFIG_COMPACTION
Date: Mon, 19 Feb 2024 13:33:51 +0000

Patch series "mm/zsmalloc: fix and optimize objects/page migration".

This series is to fix and optimize the zsmalloc objects/page migration.


This patch (of 3):

migrate_write_lock() is a empty function when !CONFIG_COMPACTION, in which
case zs_compact() can be triggered from shrinker reclaim context.  (Maybe
it's better to rename it to zs_shrink()?)

And zspage map object users rely on this migrate_read_lock() so object
won't be migrated elsewhere.

Fix it by always implementing the migrate_write_lock() related functions.

Link: https://lkml.kernel.org/r/20240219-b4-szmalloc-migrate-v1-0-34cd49c6545b@bytedance.com
Link: https://lkml.kernel.org/r/20240219-b4-szmalloc-migrate-v1-1-34cd49c6545b@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-fix-migrate_write_lock-when-config_compaction
+++ a/mm/zsmalloc.c
@@ -278,18 +278,15 @@ static bool ZsHugePage(struct zspage *zs
 static void migrate_lock_init(struct zspage *zspage);
 static void migrate_read_lock(struct zspage *zspage);
 static void migrate_read_unlock(struct zspage *zspage);
-
-#ifdef CONFIG_COMPACTION
 static void migrate_write_lock(struct zspage *zspage);
 static void migrate_write_lock_nested(struct zspage *zspage);
 static void migrate_write_unlock(struct zspage *zspage);
+
+#ifdef CONFIG_COMPACTION
 static void kick_deferred_free(struct zs_pool *pool);
 static void init_deferred_free(struct zs_pool *pool);
 static void SetZsPageMovable(struct zs_pool *pool, struct zspage *zspage);
 #else
-static void migrate_write_lock(struct zspage *zspage) {}
-static void migrate_write_lock_nested(struct zspage *zspage) {}
-static void migrate_write_unlock(struct zspage *zspage) {}
 static void kick_deferred_free(struct zs_pool *pool) {}
 static void init_deferred_free(struct zs_pool *pool) {}
 static void SetZsPageMovable(struct zs_pool *pool, struct zspage *zspage) {}
@@ -1725,7 +1722,6 @@ static void migrate_read_unlock(struct z
 	read_unlock(&zspage->lock);
 }
 
-#ifdef CONFIG_COMPACTION
 static void migrate_write_lock(struct zspage *zspage)
 {
 	write_lock(&zspage->lock);
@@ -1741,6 +1737,7 @@ static void migrate_write_unlock(struct
 	write_unlock(&zspage->lock);
 }
 
+#ifdef CONFIG_COMPACTION
 /* Number of isolated subpage for *page migration* in this zspage */
 static void inc_zspage_isolation(struct zspage *zspage)
 {
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

