Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A3517BB6
	for <mm-commits@vger.kernel.org>; Sun, 11 May 2025 03:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746935006; cv=none; b=dNZ1Y9R24pPjRGJ7egz/8bSj3cGPb5QyiUn8gCDK/OollnPI9R5NaE6vWkn8DquvwmBkkliBsfIepiezAlCJWF6YG4VcFgBjA5src0VuEIpGCDKHYyQN2jzL3In5pG9zRYAdqb1JBJVf4tb3q1xidjTekAzs3kCasZH8XCD2GuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746935006; c=relaxed/simple;
	bh=8J48pNqOPmtMgzp23S7Su0K337vxDHU20/ujVWjGwdA=;
	h=Date:To:From:Subject:Message-Id; b=liL3yr3cyzJwFwCP0WlwQGZHrF7s5b7k9vQ1nPgjSA1WiVwpqjNARCSIjnrJu/U7CJ1mLdEADZmRY6eZYtNThZG4U3o+aLlm62z1uyY8+quWFF10RHi4MJ/PKQUI960zrKEd3uhVz3Q/cqMdzHmCYkUWNzIYOD3+7appc6Yx6EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QzLk3lzL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QzLk3lzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB61C4CEE4;
	Sun, 11 May 2025 03:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746935005;
	bh=8J48pNqOPmtMgzp23S7Su0K337vxDHU20/ujVWjGwdA=;
	h=Date:To:From:Subject:From;
	b=QzLk3lzLxBXyL28LXNVrmNoRirwhRCiz4sJ/Ep3r2P0ANOpEh7wm7DOOcaTFJa4Ds
	 JgPuNkiKc7kpmPQjJ43gkzZYCF907SCfBSXqYWI/vcfDHCYRCySfwAH4zTiNA8IbIf
	 KfkQzRpZ+bWvgWtxz7lNxGVhVWumxNXZEpYpMFPU=
Date: Sat, 10 May 2025 20:43:24 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,soheil@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,kuba@kernel.org,hughd@google.com,hannes@cmpxchg.org,edumazet@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] memcg-multi-memcg-percpu-charge-cache-fix.patch removed from -mm tree
Message-Id: <20250511034325.5BB61C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: multi-memcg percpu charge cache - fix
has been removed from the -mm tree.  Its filename was
     memcg-multi-memcg-percpu-charge-cache-fix.patch

This patch was dropped because it was folded into memcg-multi-memcg-percpu-charge-cache.patch

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: multi-memcg percpu charge cache - fix
Date: Wed, 23 Apr 2025 15:41:18 -0700

Add BUILD_BUG_ON() for MEMCG_CHARGE_BATCH

Link: https://lkml.kernel.org/r/rlsgeosg3j7v5nihhbxxxbv3xfy4ejvigihj7lkkbt3n6imyne@2apxx2jm2e57
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Eric Dumaze <edumazet@google.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/memcontrol.c~memcg-multi-memcg-percpu-charge-cache-fix
+++ a/mm/memcontrol.c
@@ -1907,6 +1907,13 @@ static void refill_stock(struct mem_cgro
 	bool evict = true;
 	int i;
 
+	/*
+	 * For now limit MEMCG_CHARGE_BATCH to 127 and less. In future if we
+	 * decide to increase it more than 127 then we will need more careful
+	 * handling of nr_pages[] in struct memcg_stock_pcp.
+	 */
+	BUILD_BUG_ON(MEMCG_CHARGE_BATCH > S8_MAX);
+
 	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
 
 	if (nr_pages > MEMCG_CHARGE_BATCH ||
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-vmalloc-simplify-memcg_vmalloc-updates.patch
memcg-remove-root-memcg-check-from-refill_stock.patch
memcg-decouple-drain_obj_stock-from-local-stock.patch
memcg-introduce-memcg_uncharge.patch
memcg-manually-inline-__refill_stock.patch
memcg-no-refilling-stock-from-obj_cgroup_release.patch
memcg-do-obj_cgroup_put-inside-drain_obj_stock.patch
memcg-use-__mod_memcg_state-in-drain_obj_stock.patch
memcg-manually-inline-replace_stock_objcg.patch
memcg-optimize-memcg_rstat_updated.patch
memcg-multi-memcg-percpu-charge-cache.patch
memcg-multi-memcg-percpu-charge-cache-fix-2.patch
memcg-multi-memcg-percpu-charge-cache-fix-4.patch
memcg-introduce-non-blocking-limit-setting-option.patch
memcg-introduce-non-blocking-limit-setting-option-v3.patch
memcg-simplify-consume_stock.patch
memcg-separate-local_trylock-for-memcg-and-obj.patch
memcg-completely-decouple-memcg-and-obj-stocks.patch
memcg-no-irq-disable-for-memcg-stock-lock.patch

