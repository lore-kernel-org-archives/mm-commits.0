Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9CF2206A7
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744783; cv=none; b=SwxxkrP/Tq8KbezBuE/lYQuO8PIYAkrDe2HMYSdMszb7P6L2dmZjspYyYv38XcXPKv+XgtQVxnl6uBilXwczdoNgOow2zp5CQZxrFLHKnuEwjG4CFOLyzVeMtQ4kaaLoSIt+LiNWoomc5knfUY5ZEnYdRSygQG60QzpAaIfUDRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744783; c=relaxed/simple;
	bh=8UvzwIUCnwOXEgtLUpxcsxeLB9/ncKI/5nL+4wKFEIc=;
	h=Date:To:From:Subject:Message-Id; b=jYatIoDj/5rIs8u1qYdwCL4heiAEi9OEAYGTtD6h19gmLAxlgWedAQ01h/HpuXKq+fGQrWusXtWT5VC7ttD0gLysEa53RQgPObCFZlY0lswzHE3e18PxzzLP6Y6pYl4UW2TTPqYvYGiWr3rA60D+v8G85yzJuIVTW0qe2AJ5X0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jiZezGDy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jiZezGDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B52EC4CEF7;
	Sun, 29 Mar 2026 00:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744783;
	bh=8UvzwIUCnwOXEgtLUpxcsxeLB9/ncKI/5nL+4wKFEIc=;
	h=Date:To:From:Subject:From;
	b=jiZezGDyIvgTKOZ5Y1+ro+OmMt+PNAfa9caovcOSuxlF1cRSNhzrX5WnxCimPCGW1
	 12/8c3mwgigTvWoot8acw8F2ogO9/3V3OJTLNcgcSbzRPCmrjs43ypewjsQLoXnFkQ
	 CSf+s8eNWW3iB5cEgof1+TqEQW3oLlsGUtrsgDCs=
Date: Sat, 28 Mar 2026 17:39:43 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,jweiner@meta.com,hao.li@linux.dev,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-use-__account_obj_stock-in-the-locked-path.patch removed from -mm tree
Message-Id: <20260329003943.8B52EC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: use __account_obj_stock() in the !locked path
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-use-__account_obj_stock-in-the-locked-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: use __account_obj_stock() in the !locked path
Date: Mon, 2 Mar 2026 14:50:17 -0500

Make __account_obj_stock() usable for the case where the local trylock
failed.  Then switch refill_obj_stock() over to it.

This consolidates the mod_objcg_mlstate() call into one place and will
make the next patch easier to follow.

Link: https://lkml.kernel.org/r/20260302195305.620713-5-hannes@cmpxchg.org
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

 mm/memcontrol.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-use-__account_obj_stock-in-the-locked-path
+++ a/mm/memcontrol.c
@@ -2969,6 +2969,9 @@ static void __account_obj_stock(struct o
 {
 	int *bytes;
 
+	if (!stock)
+		goto direct;
+
 	/*
 	 * Save vmstat data in stock and skip vmstat array update unless
 	 * accumulating over a page of vmstat data or when pgdat changes.
@@ -3008,6 +3011,7 @@ static void __account_obj_stock(struct o
 			nr = 0;
 		}
 	}
+direct:
 	if (nr)
 		mod_objcg_mlstate(objcg, pgdat, idx, nr);
 }
@@ -3124,7 +3128,7 @@ static void refill_obj_stock(struct obj_
 	stock = trylock_stock();
 	if (!stock) {
 		if (pgdat)
-			mod_objcg_mlstate(objcg, pgdat, idx, nr_acct);
+			__account_obj_stock(objcg, NULL, nr_acct, pgdat, idx);
 		nr_pages = nr_bytes >> PAGE_SHIFT;
 		nr_bytes = nr_bytes & (PAGE_SIZE - 1);
 		atomic_add(nr_bytes, &objcg->nr_charged_bytes);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-list_lru-lock_list_lru_of_memcg-cannot-return-null-if-skip_empty.patch
mm-list_lru-deduplicate-unlock_list_lru.patch
mm-list_lru-move-list-dead-check-to-lock_list_lru_of_memcg.patch
mm-list_lru-deduplicate-lock_list_lru.patch
mm-list_lru-introduce-caller-locking-for-additions-and-deletions.patch
mm-list_lru-introduce-folio_memcg_list_lru_alloc.patch
mm-switch-deferred-split-shrinker-to-list_lru.patch

