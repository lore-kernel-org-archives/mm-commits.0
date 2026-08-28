Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633D02517A5
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 18:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787940365; cv=none; b=OKyvePZSAwiindX1iUf+FDFhNDuvH/6DEYhPyFXzacRx1+1CNh5fq99CVG0CFhsBkJnMgUbeVByJ1jzqNvM+Aby8uh55SDkIR7dcrd0qB8FKZyIwgLjF68ic/YmRuHYRs2KJMGHnMmuQQpmqSFYOoOtqEfThufbZp3TbVYrXgDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787940365; c=relaxed/simple;
	bh=l29tqTuI5pwTUN1NhcRJIRliaab0AfVkB8VEDcK+pUE=;
	h=Date:To:From:Subject:Message-Id; b=XkEqd1j85/YUKNgQvfRvl89Mc/fqBPqEnlNzB0KEnbMybFGqIuGm0sw3Gh3mSe830N/ybP4wdzt/q6su78CsdezrGno+TawLjnrspDvbRhY75canLk6kwur+9Gd6mnLrBwoQelQLu58aiqSCOLTlILA3YQVR+OfjV5P1AjuXNsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wYZ+g2vN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wYZ+g2vN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36821F000E9;
	Fri, 28 Aug 2026 18:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787940364;
	bh=eAcEzxHeM5eUN2dobMTH1Nb6TYZe01EKoawR8e3ciG4=;
	h=Date:To:From:Subject;
	b=wYZ+g2vNujv+iR7qIx9QAnwiL88bH9aFgl4L9+vrmBWZQzJX5+3l8INEmMwTMYdTF
	 Yd1ejXCgEyE/TqSjz2jeSK9hfrwa9ohJ40T/CXlMVnJyjLtPsoD3GsZrUyAb6QZwVP
	 Q7tI9ZMnjlH2Gg8UCPRqtLoKEP+H7sHz3YWWIhho=
Date: Fri, 28 Aug 2026 11:06:03 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,dev.jain@arm.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-fix-vmap_purge_lock-livelock-under-memory-pressure.patch added to mm-new branch
Message-Id: <20260828180603.E36821F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmalloc: fix vmap_purge_lock livelock under memory pressure
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-fix-vmap_purge_lock-livelock-under-memory-pressure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-fix-vmap_purge_lock-livelock-under-memory-pressure.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Suggested-by: Uladzislau Rezki <urezki@gmail.com>
Suggested-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-vmap_purge_lock-livelock-under-memory-pressure
+++ a/mm/vmalloc.c
@@ -2445,7 +2445,8 @@ static bool __purge_vmap_area_lazy(unsig
 static void reclaim_and_purge_vmap_areas(void)
 
 {
-	mutex_lock(&vmap_purge_lock);
+	if (!mutex_trylock(&vmap_purge_lock))
+		return;
 	purge_fragmented_blocks_allcpus();
 	__purge_vmap_area_lazy(ULONG_MAX, 0, true);
 	mutex_unlock(&vmap_purge_lock);
@@ -5526,10 +5527,20 @@ vmap_node_shrink_scan(struct shrinker *s
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

mm-vmalloc-fix-vmap_purge_lock-livelock-under-memory-pressure.patch

