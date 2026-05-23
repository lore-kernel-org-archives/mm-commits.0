Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09EA1E5B88
	for <mm-commits@vger.kernel.org>; Sat, 23 May 2026 02:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779503496; cv=none; b=SzKnN/ip33MX1WOXEjZRPhfAFNYszjIf8WtgEKFgSlCfoaX+hOOLUtVVHUJDtqRwl+CKFyqHFkG4gbqUq/l2QX9cAQ7YSBqGExG/SHgHAYlgGm1Ky46C80BgpMeEr1rxukgGT4+k0C+8uH25bWR0H00bGUF98b1n6PGfLu2b/c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779503496; c=relaxed/simple;
	bh=+MfmQNRlX+6j3lW6hKuyVAzY7sqrc6fO/QEu0ZuvMnk=;
	h=Date:To:From:Subject:Message-Id; b=t1q2hPrWc89QyOu6hJMn5HsF1gRMxjAwkp8XqNxpZTv6ZURkfjV6dMSqI15vrY0fxeiisxIVj0GLBXk/9jSaiZVAaPcxQitj78lxbfmuGb+2ds0iiD9q8iIxrJGrdC9LKzzJMHUu2MNxew2ZzUasce9SSYT0XRDY5s8b8Ijra4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PjtQTe8H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PjtQTe8H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A181F000E9;
	Sat, 23 May 2026 02:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779503494;
	bh=hlsAAwA9uQVEDgX1wwNCYpcI/JbB22XqtmAn2z+qpdU=;
	h=Date:To:From:Subject;
	b=PjtQTe8HfZB0kkLEAfGHK8qAOzRJSshODLesmqBOmx3AkJiJBshLBajBGAbsrNep5
	 vIh3GzujdVNAZ5tlV+wdUVy1Yb6+zJX4/d3WpGR1eKuMsHCv97eOTV20hS/ozRtWFj
	 +PRJoChWGENiCM8HQ+XmnKkQf8u+F15vTgDiExXI=
Date: Fri, 22 May 2026 19:31:33 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,qi.zheng@linux.dev,oliver.sang@intel.com,muchun.song@linux.dev,mhocko@kernel.org,joshua.hahnjy@gmail.com,harry@kernel.org,hannes@cmpxchg.org,alex@ghiti.fr,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-int16_t-for-cached-slab-stats.patch added to mm-new branch
Message-Id: <20260523023134.55A181F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: int16_t for cached slab stats
has been added to the -mm mm-new branch.  Its filename is
     memcg-int16_t-for-cached-slab-stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-int16_t-for-cached-slab-stats.patch

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: int16_t for cached slab stats
Date: Thu, 21 May 2026 18:19:07 -0700

Currently struct obj_stock_pcp stores cached slab stats in 'int' which is
4 bytes per counter on 64-bit machines.  Switch them to int16_t to shrink
the cached metadata.

The existing PAGE_SIZE flush in __account_obj_stock() bounds *bytes at
PAGE_SIZE on 4KiB and 16KiB page archs, well within int16_t.  On 64KiB
pages PAGE_SIZE is well above S16_MAX so that flush never fires, and a
sufficiently long run of accumulations would overflow the cache.  Add an
explicit S16_MAX guard before each add: when the next add would push
abs(*bytes) past S16_MAX, fold the cached value into @nr and flush
directly via mod_objcg_mlstate() before the accumulation.

Link: https://lore.kernel.org/20260522011908.1669332-4-shakeel.butt@linux.dev
Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Tested-by: kernel test robot <oliver.sang@intel.com>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~memcg-int16_t-for-cached-slab-stats
+++ a/mm/memcontrol.c
@@ -2023,8 +2023,8 @@ struct obj_stock_pcp {
 	struct obj_cgroup *cached_objcg;
 	uint16_t nr_bytes;
 	int16_t node_id;
-	int nr_slab_reclaimable_b;
-	int nr_slab_unreclaimable_b;
+	int16_t nr_slab_reclaimable_b;
+	int16_t nr_slab_unreclaimable_b;
 
 	struct work_struct work;
 	unsigned long flags;
@@ -3161,7 +3161,7 @@ static void __account_obj_stock(struct o
 				struct obj_stock_pcp *stock, int nr,
 				struct pglist_data *pgdat, enum node_stat_item idx)
 {
-	int *bytes;
+	int16_t *bytes;
 
 	/*
 	 * Though at the moment MAX_NUMNODES <= 1024 in all archs but let's make
@@ -3199,6 +3199,16 @@ static void __account_obj_stock(struct o
 	bytes = (idx == NR_SLAB_RECLAIMABLE_B) ? &stock->nr_slab_reclaimable_b
 					       : &stock->nr_slab_unreclaimable_b;
 	/*
+	 * To avoid overflow or underflow, flush directly if accumulating @nr
+	 * would push the cached value past S16_MAX.
+	 */
+	if (abs(nr + *bytes) > S16_MAX) {
+		nr += *bytes;
+		*bytes = 0;
+		goto direct;
+	}
+
+	/*
 	 * Even for large object >= PAGE_SIZE, the vmstat data will still be
 	 * cached locally at least once before pushing it out.
 	 */
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-use-round-robin-victim-selection-in-refill_stock.patch
memcg-store-node_id-instead-of-pglist_data-pointer.patch
memcg-uint16_t-for-nr_bytes-in-obj_stock_pcp.patch
memcg-int16_t-for-cached-slab-stats.patch
memcg-multi-objcg-charge-support.patch

