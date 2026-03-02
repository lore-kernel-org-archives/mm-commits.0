Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C8C3859C8
	for <mm-commits@vger.kernel.org>; Mon,  2 Mar 2026 20:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772481924; cv=none; b=Xqh3iDwQXPGRYEifZg9JBK9OFIKEB9C2G3G3CauL0AC7QyA2ozGzA6mD27mH21b0knureMST1/Y+MwYTW1z8IvVpsdjpOwN9nAqTXKopEJ7o1ktTbw7M9AhzbuGHvJELs44NO5fWKRXlqtbkNCYJmMOCkPVyoDiGrbWfY8KSFv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772481924; c=relaxed/simple;
	bh=P6rAOyixtqlg/AnzQLItz6QN9PDbdkbT7794BsMF/dk=;
	h=Date:To:From:Subject:Message-Id; b=ZVFw3se50u2IbGkoDoasQB/9IEm/VZ2Erez8SzJ/lcsxSCzIZZApD9IlHbDxvyDssdPsgF6ro3DvCWrhZP+CjZzj5ziVooviTvs1TZBNtxL80f1JOWcQIZaV9Ta7Hr+P6lzgMd7zre6PFD14xSP2anUizFkMXPkmvAUiZZuABtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SI9BHZ4D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SI9BHZ4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7112DC19423;
	Mon,  2 Mar 2026 20:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772481924;
	bh=P6rAOyixtqlg/AnzQLItz6QN9PDbdkbT7794BsMF/dk=;
	h=Date:To:From:Subject:From;
	b=SI9BHZ4DAH+MqJsPMtUcSvG9HUXa+vNzsoLgfxo+pTfl1HUX4S9F2Euc8METMKgqu
	 atzYigA8nvDNKld0yFN/v5dMOJOwO4IzGLIxV+GTu4ZhiLWbrd8m2EtInMMTKF7+nv
	 FEu+lOS3OSQvjYd+UreUJOG5FGTTVb010ljIle2Q=
Date: Mon, 02 Mar 2026 12:05:23 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hao.li@linux.dev,hannes@cmpxchg.org,jweiner@meta.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-simplify-objcg-charge-size-and-stock-remainder-math.patch added to mm-new branch
Message-Id: <20260302200524.7112DC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: simplify objcg charge size and stock remainder math
has been added to the -mm mm-new branch.  Its filename is
     mm-memcg-simplify-objcg-charge-size-and-stock-remainder-math.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-simplify-objcg-charge-size-and-stock-remainder-math.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Johannes Weiner <jweiner@meta.com>
Subject: mm: memcg: simplify objcg charge size and stock remainder math
Date: Mon, 2 Mar 2026 14:50:15 -0500

Use PAGE_ALIGN() and a more natural cache remainder calculation.

Link: https://lkml.kernel.org/r/20260302195305.620713-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hao Li <hao.li@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-simplify-objcg-charge-size-and-stock-remainder-math
+++ a/mm/memcontrol.c
@@ -3417,7 +3417,7 @@ out:
 static int obj_cgroup_charge_account(struct obj_cgroup *objcg, gfp_t gfp, size_t size,
 				     struct pglist_data *pgdat, enum node_stat_item idx)
 {
-	unsigned int nr_pages, nr_bytes;
+	size_t charge_size, remainder;
 	int ret;
 
 	if (likely(consume_obj_stock(objcg, size, pgdat, idx)))
@@ -3446,16 +3446,12 @@ static int obj_cgroup_charge_account(str
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

mm-memcg-factor-out-trylock_stock-and-unlock_stock.patch
mm-memcg-simplify-objcg-charge-size-and-stock-remainder-math.patch

