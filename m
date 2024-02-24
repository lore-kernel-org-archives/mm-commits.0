Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66DEBA2D
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739431; cv=none; b=PRrsV7ie8VS6pXJ/nnd9z2jRJ0JWIkmei6v2h9WPhFsI/hkIdsMS7UVRjwXPUkFZ+1fRj9En+uuNELRSju0l56gyJ4yiTu7xpVf/kz2VcsJoYwH2qmZikP6PlY4K4kShp6vNS0NmpujdwAKPsUkfmoKRANhcLwpUQM2578q0bQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739431; c=relaxed/simple;
	bh=CAnkyS019uqp325oDy9NziO4L3X4XFO55Cjo4yyg6KE=;
	h=Date:To:From:Subject:Message-Id; b=RD32fwIJPAE4PattRnrBm9kyqMfcQtGMyMXhRFJ7OKmG8t6bttXEglo/EW/340230O2qJZdoRROyj8Bhgi41WhfQ8GrvSAsSLZvLWczvunZLLWczcggqb0g+iNkNE+HLVl8hWDXgJKg0B6N3W+j/+j//TfaXr/Y7geJFBSD0jvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t3LcFZjW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t3LcFZjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2519BC43394;
	Sat, 24 Feb 2024 01:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739431;
	bh=CAnkyS019uqp325oDy9NziO4L3X4XFO55Cjo4yyg6KE=;
	h=Date:To:From:Subject:From;
	b=t3LcFZjWkNON2GohkpZGvKdjdW6o7gH6LAH9Bx75ryRgwRDGzwLdZ3oXYEw7QJ/Va
	 UmHdQEU5MWHKIzsLa42Jr6iER20K18nstKMlpUBIBokKab9+eH27zpZkuxuoQwD2i/
	 4pYfoC+2445fGB5pQBxTwvzyOxSh1uLUh9AISOZY=
Date: Fri, 23 Feb 2024 17:50:30 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-fix-migrate_write_lock-when-config_compaction.patch removed from -mm tree
Message-Id: <20240224015031.2519BC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: fix migrate_write_lock() when !CONFIG_COMPACTION
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-fix-migrate_write_lock-when-config_compaction.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
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

mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools.patch
mm-zswap-change-zswap_pool-kref-to-percpu_ref.patch

