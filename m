Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D48C1D63E4
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343082; cv=none; b=QGijRn59oYDrInr8gyVQ38SNLpKWNDZ2kcUZBGKW4o2tY1usesvGXl1Zta1HXbZGTX8ZG3bp9uAV76VEA8RfoYYUV138AjLm+QcMv3AEn7S6Rmu9PLnRDOT1uVSeR5LZRgRXAfzjZpO5mlX7jLXtOzsEKqzgPBgURO8Kb3PUwE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343082; c=relaxed/simple;
	bh=SDt8dCp0MxsLBvUmglGYeTwvF0u3GLmzmAzxZVpdhAg=;
	h=Date:To:From:Subject:Message-Id; b=f7Rux76llkSkqYg8pFFTVnkUzIoCqT9Wtqd9OMc0SO+MUAQH3GNULcGipFZSuu/UG27Vn2Xcct1iSSxg50mmf7oXdzdULaJg/9WWiFHEYwLpfsWPlWnxapLBb227ZbIp87I+nH7ECttX+ca2t4N6krIT2jfIZk3pv6BRWStriQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QpZhGIeG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QpZhGIeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B13C4CEF5;
	Mon, 17 Nov 2025 01:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343081;
	bh=SDt8dCp0MxsLBvUmglGYeTwvF0u3GLmzmAzxZVpdhAg=;
	h=Date:To:From:Subject:From;
	b=QpZhGIeGIuYdFiK9qZT5rGE7b4n/i4QGRAb4odDLUcofpRSEmELXiarg+kaRT+lyu
	 iL2f5CQg7wuB04roag+7tJYxp65cc5jhBmov5LkYLQD23EJnKjFDqSy1ZLRzzcdD5/
	 L0albXF+gsBBI87r12YKTBdpCZuXd7xyqMk8HALI=
Date: Sun, 16 Nov 2025 17:31:20 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,mhocko@suse.com,mhocko@kernel.org,glider@google.com,elver@google.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-support-non-blocking-gfp-flags-in-alloc_vmap_area.patch removed from -mm tree
Message-Id: <20251117013121.80B13C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: support non-blocking GFP flags in alloc_vmap_area()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-support-non-blocking-gfp-flags-in-alloc_vmap_area.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: support non-blocking GFP flags in alloc_vmap_area()
Date: Tue, 7 Oct 2025 14:20:28 +0200

alloc_vmap_area() currently assumes that sleeping is allowed during
allocation.  This is not true for callers which pass non-blocking GFP
flags, such as GFP_ATOMIC or GFP_NOWAIT.

This patch adds logic to detect whether the given gfp_mask permits
blocking.  It avoids invoking might_sleep() or falling back to reclaim
path if blocking is not allowed.

This makes alloc_vmap_area() safer for use in non-sleeping contexts, where
previously it could hit unexpected sleeps, trigger warnings.

It is a preparation and adjustment step to later allow both GFP_ATOMIC and
GFP_NOWAIT allocations in this series.

Link: https://lkml.kernel.org/r/20251007122035.56347-4-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-support-non-blocking-gfp-flags-in-alloc_vmap_area
+++ a/mm/vmalloc.c
@@ -2017,6 +2017,7 @@ static struct vmap_area *alloc_vmap_area
 	unsigned long freed;
 	unsigned long addr;
 	unsigned int vn_id;
+	bool allow_block;
 	int purged = 0;
 	int ret;
 
@@ -2028,7 +2029,8 @@ static struct vmap_area *alloc_vmap_area
 
 	/* Only reclaim behaviour flags are relevant. */
 	gfp_mask = gfp_mask & GFP_RECLAIM_MASK;
-	might_sleep();
+	allow_block = gfpflags_allow_blocking(gfp_mask);
+	might_sleep_if(allow_block);
 
 	/*
 	 * If a VA is obtained from a global heap(if it fails here)
@@ -2062,7 +2064,8 @@ retry:
 		 * This is not a fast path.  Check if yielding is needed. This
 		 * is the only reschedule point in the vmalloc() path.
 		 */
-		cond_resched();
+		if (allow_block)
+			cond_resched();
 	}
 
 	trace_alloc_vmap_area(addr, size, align, vstart, vend, IS_ERR_VALUE(addr));
@@ -2071,8 +2074,16 @@ retry:
 	 * If an allocation fails, the error value is
 	 * returned. Therefore trigger the overflow path.
 	 */
-	if (IS_ERR_VALUE(addr))
-		goto overflow;
+	if (IS_ERR_VALUE(addr)) {
+		if (allow_block)
+			goto overflow;
+
+		/*
+		 * We can not trigger any reclaim logic because
+		 * sleeping is not allowed, thus fail an allocation.
+		 */
+		goto out_free_va;
+	}
 
 	va->va_start = addr;
 	va->va_end = addr + size;
@@ -2122,6 +2133,7 @@ overflow:
 		pr_warn("vmalloc_node_range for size %lu failed: Address range restricted to %#lx - %#lx\n",
 				size, vstart, vend);
 
+out_free_va:
 	kmem_cache_free(vmap_area_cachep, va);
 	return ERR_PTR(-EBUSY);
 }
_

Patches currently in -mm which might be from urezki@gmail.com are


