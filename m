Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEE6221FBB
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744781; cv=none; b=hFCq3HefPJ4xCv9mkJRTKg7wJ+320pRW/sbn3VGdG3exQpOExrU/ST5UERDGi6plt3PCYaDbW5LJymRVeqNLRtkvN2gKwWhUuP6MztHihg0/z+KuGsiTJ7ghXrlfED+C+yzcuAcwh8NZfSeFJ6+cH3kUBx5pc3PCTThDqWaurv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744781; c=relaxed/simple;
	bh=0g3CTD3BKRikJ0F8GtR2Ry8kqa9QgE6KZhjtUnelFw4=;
	h=Date:To:From:Subject:Message-Id; b=tc4ZszTVtCKrSFAwMr0sWyGhffebRYAQA8Lgv0od6+hQMB5qrx2gE0azy/5iFzI9SRXhWcj55n42g3rRTR5nJHUX65QXMYygMq6HixApioDhb65bwp/tyrxzqlw6yrgkjiJwFlUUp1F7dmx3h95KUNwj+Tc4Skjj9f28Yp974e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bGz0h+KS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bGz0h+KS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24105C4CEF7;
	Sun, 29 Mar 2026 00:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744781;
	bh=0g3CTD3BKRikJ0F8GtR2Ry8kqa9QgE6KZhjtUnelFw4=;
	h=Date:To:From:Subject:From;
	b=bGz0h+KSEm2leuSqsDb50T0KGXsj0PsIY457otBCUGlFQGRoeEAfBhkrzSiwzUToM
	 g5y1/j6fbXCPkE4CVf9jBNQQg1phd09fuHeDZCMjJljfBT7ph5+AC1WZuHuU+Yvgeb
	 UanExRWcBdhALGEA954sz3tLLcj+cidVygf1PbX0=
Date: Sat, 28 Mar 2026 17:39:40 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hao.li@linux.dev,hannes@cmpxchg.org,jweiner@meta.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-simplify-objcg-charge-size-and-stock-remainder-math.patch removed from -mm tree
Message-Id: <20260329003941.24105C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: simplify objcg charge size and stock remainder math
has been removed from the -mm tree.  Its filename was
     mm-memcg-simplify-objcg-charge-size-and-stock-remainder-math.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <jweiner@meta.com>
Subject: mm: memcg: simplify objcg charge size and stock remainder math
Date: Mon, 2 Mar 2026 14:50:15 -0500

Use PAGE_ALIGN() and a more natural cache remainder calculation.

Link: https://lkml.kernel.org/r/20260302195305.620713-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Hao Li <hao.li@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-simplify-objcg-charge-size-and-stock-remainder-math
+++ a/mm/memcontrol.c
@@ -3159,7 +3159,7 @@ out:
 static int obj_cgroup_charge_account(struct obj_cgroup *objcg, gfp_t gfp, size_t size,
 				     struct pglist_data *pgdat, enum node_stat_item idx)
 {
-	unsigned int nr_pages, nr_bytes;
+	size_t charge_size, remainder;
 	int ret;
 
 	if (likely(consume_obj_stock(objcg, size, pgdat, idx)))
@@ -3188,16 +3188,12 @@ static int obj_cgroup_charge_account(str
 	 * bytes is (sizeof(object) + PAGE_SIZE - 2) if there is no data
 	 * race.
 	 */
-	nr_pages = size >> PAGE_SHIFT;
-	nr_bytes = size & (PAGE_SIZE - 1);
+	charge_size = PAGE_ALIGN(size);
+	remainder = charge_size - size;
 
-	if (nr_bytes)
-		nr_pages += 1;
-
-	ret = obj_cgroup_charge_pages(objcg, gfp, nr_pages);
-	if (!ret && (nr_bytes || pgdat))
-		refill_obj_stock(objcg, nr_bytes ? PAGE_SIZE - nr_bytes : 0,
-					 false, size, pgdat, idx);
+	ret = obj_cgroup_charge_pages(objcg, gfp, charge_size >> PAGE_SHIFT);
+	if (!ret && (remainder || pgdat))
+		refill_obj_stock(objcg, remainder, false, size, pgdat, idx);
 
 	return ret;
 }
_

Patches currently in -mm which might be from jweiner@meta.com are


