Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCA937A833
	for <mm-commits@vger.kernel.org>; Sat, 26 Sep 2026 16:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790440563; cv=none; b=V7cz7qL+wo+PjqXV0YKFrug8BQEDN3rtQeyHEDZLOw2MBOCxrgb0tzcPK1b0Gnu8VDUtM1/Qx0rWNtpaAMZUIaJrpD/XVshOQx2RJllECGE7cCbXLu5ESWuAwOnxpFCVkYW0fcTV5hzb8s/XuXHzO9nBS5m93Lxl5GNx2h+8hMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790440563; c=relaxed/simple;
	bh=3ETqYb9OJ1RzYCJYTNHb1JXieLBgdxGWthunzjL8uwo=;
	h=Date:To:From:Subject:Message-Id; b=nuLE69ec4S0FhyBIcjTSdlZzatbDm4SRrPLo4dU2bgYW6XXJDHj1R/ld+LbQdXL4F7xoCZalIWOuHQD0HPI0jDdPKzK2N3wRf7EA9pWuVnUZHc3deOWpMuSA+I+rIJfyFNM2AzBStPUxw4pHsaKNxyPlLDgs4p+Ze32FvY9RMyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i+Bcw7iR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i+Bcw7iR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5A41F00893;
	Sat, 26 Sep 2026 16:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790440560;
	bh=Md5/+947wT8R4Ut96iBXum6nTCZjDzQH2iFgGo6HwyA=;
	h=Date:To:From:Subject;
	b=i+Bcw7iRqmb1b25wBJX5J6t6HK8+JxuwCXKTdGCKINykY9EF7cz/mHyTS2Nd79Hea
	 AVu9eVjEpiEA546pkSOeagAHtdXYl7qP2yls4ldswerdkjeiUqMmqI69T1K9jc8ITv
	 zOUxNG6sHbfqwGxo1TBfJMmDSx1C5o5RDiS/j3Uo=
Date: Sat, 26 Sep 2026 09:35:59 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,dev.jain@arm.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-fix-vmap_purge_lock-livelock-under-memory-pressure.patch removed from -mm tree
Message-Id: <20260926163559.ED5A41F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: fix vmap_purge_lock livelock under memory pressure
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-vmap_purge_lock-livelock-under-memory-pressure.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm: vmalloc: fix vmap_purge_lock livelock under memory pressure
Date: Fri, 28 Aug 2026 17:17:53 +0800

The vmap_purge_lock mutex can be held for an extended period by
__purge_vmap_area_lazy() which calls flush_work() to wait for
purge_vmap_node workers while holding the lock.  Under memory pressure,
those workers may themselves be blocked in direct reclaim trying to
acquire the same lock via the vmap_node_shrink_scan() shrinker callback,
creating a circular dependency that deadlocks the entire system.

Two places acquire vmap_purge_lock from paths that can be reached
during direct reclaim:

1. vmap_node_shrink_scan(): replace blocking guard(mutex) with
   mutex_trylock().  This is a shrinker that only decays the vmap
   pool and returns SHRINK_STOP without freeing memory; skipping a
   decay cycle when the lock is contended is harmless and prevents
   tasks from piling up on the mutex in the direct reclaim path.

2. reclaim_and_purge_vmap_areas(): replace mutex_lock() with
   mutex_trylock().  This is called from the vmalloc allocation
   overflow path; if trylock fails, another thread is already
   purging and the allocator's retry will find freed space.  The
   notifier chain provides a fallback if the retry still fails.

Both trylock failures break the circular dependency: the lock holder's
flush_work() can complete because workers are no longer blocked on
vmap_purge_lock in the direct reclaim path.

Link: https://lore.kernel.org/20260828091753.299295-1-ye.liu@linux.dev
Fixes: 7679ba6b36db ("mm: vmalloc: add a shrinker to drain vmap pools")
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Uladzislau Rezki <urezki@gmail.com>
Suggested-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---

 mm/vmalloc.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-vmap_purge_lock-livelock-under-memory-pressure
+++ a/mm/vmalloc.c
@@ -2452,7 +2452,8 @@ static bool __purge_vmap_area_lazy(unsig
 static void reclaim_and_purge_vmap_areas(void)
 
 {
-	mutex_lock(&vmap_purge_lock);
+	if (!mutex_trylock(&vmap_purge_lock))
+		return;
 	purge_fragmented_blocks_allcpus();
 	__purge_vmap_area_lazy(ULONG_MAX, 0, true);
 	mutex_unlock(&vmap_purge_lock);
@@ -5534,10 +5535,20 @@ vmap_node_shrink_scan(struct shrinker *s
 {
 	struct vmap_node *vn;
 
-	guard(mutex)(&vmap_purge_lock);
+	/*
+	 * This shrinker is invoked from direct reclaim where memory
+	 * pressure is already high.  Blocking on vmap_purge_lock here
+	 * can deadlock the system: the lock holder may be blocked in
+	 * flush_work() waiting for a worker that is stuck in this same
+	 * reclaim path trying to acquire the same lock.  Use trylock
+	 * to avoid this; skipping a pool decay cycle is harmless.
+	 */
+	if (!mutex_trylock(&vmap_purge_lock))
+		return SHRINK_STOP;
 	for_each_vmap_node(vn)
 		decay_va_pool_node(vn, true);
 
+	mutex_unlock(&vmap_purge_lock);
 	return SHRINK_STOP;
 }
 
_

Patches currently in -mm which might be from liuye@kylinos.cn are

tools-mm-page_owner_sort-fix-sort-option-being-silently-ignored.patch
tools-mm-page_owner_sort-add-module-name-sort-cull-filter-support.patch
tools-mm-page_owner_sort-show-available-sort-keys-in-usage-text.patch
mm-oom_kill-remove-unreachable-__gfp_thisnode-check-in-constrained_alloc.patch
mm-oom_kill-proc-replace-magic-number-1000-with-oom_score_adj_max.patch
mm-page_table_check-add-explicit-pmd_none-check-in-pte_clear_range.patch
mm-vmalloc-group-xa_init-with-vbq-field-initializations.patch
mm-vmalloc-extract-vmap_insert_free_area-helper.patch
mm-vmalloc-extract-show_busy_info-from-vmalloc_info_show.patch

