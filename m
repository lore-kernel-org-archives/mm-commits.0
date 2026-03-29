Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6AA21B905
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744782; cv=none; b=Tb6tQ5/tmFLIph1LqJTCqPLwDPTE7yrSUpFmF09u3NbRHNpcbugwr9trIAaPqKe0AWT7I4ElT7emU9NMyZ8pty6DvsuGp1WCekkn9RryETO7Z3vE/mugKlohELCWEeOOTguy+wVMUbNhdsaIXYkc4BEhJs8gOETycwevqp7yHYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744782; c=relaxed/simple;
	bh=Isbi0e22+QU5Ot7NsVL0P0Qp8hNBWO5L0avDGR3fv2g=;
	h=Date:To:From:Subject:Message-Id; b=VbeJWJL/nkauT2e3kAYBjjvU7jqp428CYuW8BODOn6uR/a1H1P5PhTEiM0tY6/vJk0k4dxeJSl5VvuNTTSttH+RLLPMn89N5uL0z9CbmTE8+nLKEXgkBZKCBpL+KbwoFhQTPK8vpX1EsgxtLmqQGv0IPSkAzgJc6ISSguMNRCaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l5ixJvwx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l5ixJvwx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A99C4CEF7;
	Sun, 29 Mar 2026 00:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744782;
	bh=Isbi0e22+QU5Ot7NsVL0P0Qp8hNBWO5L0avDGR3fv2g=;
	h=Date:To:From:Subject:From;
	b=l5ixJvwxAFWEemeYriUSohh/kl40HYCZbsYH68MhdpO+wPymFhBcqQ/6Edpm6RjVy
	 tL8S0nRrxZm61043bDwe7V+0bBc08Q1+ubNJ2CvtWFSPjWC8mGHooKzi6Dwxvlz4Sw
	 X8fYBzY5QLtNxXklpDiy4c7ArTmm0q25kQZE1xqs=
Date: Sat, 28 Mar 2026 17:39:41 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,jweiner@meta.com,hao.li@linux.dev,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-split-out-__obj_cgroup_charge.patch removed from -mm tree
Message-Id: <20260329003942.58A99C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: split out __obj_cgroup_charge()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-split-out-__obj_cgroup_charge.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: split out __obj_cgroup_charge()
Date: Mon, 2 Mar 2026 14:50:16 -0500

Move the page charge and remainder calculation into its own function.  It
will make the slab stat refactor easier to follow.

Link: https://lkml.kernel.org/r/20260302195305.620713-4-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Hao Li <hao.li@linux.dev>
Cc: Johannes Weiner <jweiner@meta.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-split-out-__obj_cgroup_charge
+++ a/mm/memcontrol.c
@@ -3156,10 +3156,24 @@ out:
 		obj_cgroup_uncharge_pages(objcg, nr_pages);
 }
 
+static int __obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp,
+			       size_t size, size_t *remainder)
+{
+	size_t charge_size;
+	int ret;
+
+	charge_size = PAGE_ALIGN(size);
+	ret = obj_cgroup_charge_pages(objcg, gfp, charge_size >> PAGE_SHIFT);
+	if (!ret)
+		*remainder = charge_size - size;
+
+	return ret;
+}
+
 static int obj_cgroup_charge_account(struct obj_cgroup *objcg, gfp_t gfp, size_t size,
 				     struct pglist_data *pgdat, enum node_stat_item idx)
 {
-	size_t charge_size, remainder;
+	size_t remainder;
 	int ret;
 
 	if (likely(consume_obj_stock(objcg, size, pgdat, idx)))
@@ -3188,10 +3202,7 @@ static int obj_cgroup_charge_account(str
 	 * bytes is (sizeof(object) + PAGE_SIZE - 2) if there is no data
 	 * race.
 	 */
-	charge_size = PAGE_ALIGN(size);
-	remainder = charge_size - size;
-
-	ret = obj_cgroup_charge_pages(objcg, gfp, charge_size >> PAGE_SHIFT);
+	ret = __obj_cgroup_charge(objcg, gfp, size, &remainder);
 	if (!ret && (remainder || pgdat))
 		refill_obj_stock(objcg, remainder, false, size, pgdat, idx);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-list_lru-lock_list_lru_of_memcg-cannot-return-null-if-skip_empty.patch
mm-list_lru-deduplicate-unlock_list_lru.patch
mm-list_lru-move-list-dead-check-to-lock_list_lru_of_memcg.patch
mm-list_lru-deduplicate-lock_list_lru.patch
mm-list_lru-introduce-caller-locking-for-additions-and-deletions.patch
mm-list_lru-introduce-folio_memcg_list_lru_alloc.patch
mm-switch-deferred-split-shrinker-to-list_lru.patch

