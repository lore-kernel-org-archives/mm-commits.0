Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3783B5E01
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896555; cv=none; b=W53gAw8S9/4l+ECckBiZcBWxMsPrwOgsy4tUU4J+Q2rWef10J+dK9qPTyhNoOwAqGUZErFNdwDmkSM2GaTcLoDtmYInVgmAJi2/1mQQfOgqR9wx7MGp6iLHH88wtmVrTEhumvgU1xRGDyzZcBifHX0IMQorKwN6dt+AExD4hZdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896555; c=relaxed/simple;
	bh=Ej7dOXizVgOOZlirZYchneZM0RtyWFNjE0X2wEQddo8=;
	h=Date:To:From:Subject:Message-Id; b=NyPRwss0hsOKHQHzYBFoFEE3Y93cVv0l40oUYYtYZdUBoelaBkmw6JTSj2iSYrsWYarXGM2a82atuFmqYVjUEz7rOMDO+sC2KoIlOlUlOQtlqIyn2fVZLfpo3LvSJnc99ck6S2OcVg+xY5dnrX4x6Kv5W6fEYGQM5VX6k7Ib1ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A+BKWtAB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A+BKWtAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D4F1F00A3A;
	Wed,  5 Aug 2026 02:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896553;
	bh=sSUC5FW3TC3keOlOhToVWyRU1aqb341K9e9hoc+We5o=;
	h=Date:To:From:Subject;
	b=A+BKWtABVMl+YpQEwCe/nvEeAwdBmkWBsfBPS5bi3kiiBFi0hNrucTBnDFc4DeGcg
	 JQoE2N7bHAvDhTGIbkfFbcXIHm4hNX9FWLd71bW59NBgv84swDqLRCoHiSLOXJpJ3d
	 HSsuXbgscbFR/7CnaamOtGmaAAZY5DRyrzgiA+Fo=
Date: Tue, 04 Aug 2026 19:22:32 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,yingfu.zhou@shopee.com,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,jiayuan.chen@linux.dev,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,jiayuan.chen@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-v1-bail-out-reclaim-when-memcg-is-dying.patch removed from -mm tree
Message-Id: <20260805022233.52D4F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg-v1: bail out reclaim when memcg is dying
has been removed from the -mm tree.  Its filename was
     memcg-v1-bail-out-reclaim-when-memcg-is-dying.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiayuan Chen <jiayuan.chen@shopee.com>
Subject: memcg-v1: bail out reclaim when memcg is dying
Date: Thu, 2 Jul 2026 20:02:30 +0800

The legacy memory.limit_in_bytes and memory.memsw.limit_in_bytes writers
retry page_counter_set_max() by reclaiming synchronously in the writer
context.  memory.force_empty similarly loops in synchronous reclaim until
the cgroup is empty or reclaim stops making progress.

These writes hold a kernfs active reference on the file.  If cgroup
removal starts in parallel, the remover sets CSS_DYING and then waits in
kernfs_drain() under cgroup_mutex for the active reference to drain. 
Continuing reclaim after the memcg is dying can therefore delay cgroup
removal and keep cgroup_mutex held for a long time.

Stop the v1 reclaim loops once the memcg is dying.  For limit resizing,
keep the existing -EBUSY semantics when the new limit could not be
installed.  For memory.force_empty, keep the existing best-effort success
semantics.

Link: https://lore.kernel.org/20260702120235.376752-5-jiayuan.chen@linux.dev
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Reported-by: Zhou Yingfu <yingfu.zhou@shopee.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/memcontrol-v1.c~memcg-v1-bail-out-reclaim-when-memcg-is-dying
+++ a/mm/memcontrol-v1.c
@@ -1805,6 +1805,10 @@ static int mem_cgroup_resize_max(struct
 		if (!ret)
 			break;
 
+		/* cgroup_rmdir() waits for us with cgroup_mutex held. */
+		if (memcg_is_dying(memcg))
+			break;
+
 		if (!drained) {
 			drain_all_stock(memcg);
 			drained = true;
@@ -1843,6 +1847,10 @@ static int mem_cgroup_force_empty(struct
 		if (signal_pending(current))
 			return -EINTR;
 
+		/* cgroup_rmdir() waits for us with cgroup_mutex held. */
+		if (memcg_is_dying(memcg))
+			break;
+
 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
 						  MEMCG_RECLAIM_MAY_SWAP, NULL))
 			nr_retries--;
_

Patches currently in -mm which might be from jiayuan.chen@shopee.com are


