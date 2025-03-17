Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7837E24B28;
	Mon, 17 Mar 2025 00:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742172081; cv=none; b=mtGO/PSgE+CA5In7+hAbBhMrBQiNVzH+fL0qqG8w2KrxODb0LzuPjW/ekANJWrT5/lCGsaQItIJJRL2m8tsmtrhMXcm/LlEo+T2qBCSS8dICgsqIRQ9fLdDvVlb/RYDdooOUI6kZ2BuU/yoFjQEX7HMudqp+SLB0TNPJUMQ/L4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742172081; c=relaxed/simple;
	bh=Cf2o9LXdxnYRluCbu2i0Rht4BH4IfliLBPzB8LmzGqA=;
	h=Date:To:From:Subject:Message-Id; b=b1ivdm3qmdSsw6FIsJarFfqet/nwYkPQYOcBD9GX6B5UJVd4QNO8rvhOLT2lkIh8c8Fu10ENTSCJ3bcmQLg8SIPLCI/E0f2jqrji6kQctExJKx/a1El9Ja3RHCZ8hKzdNlyRnn9ywmJoEA90tN9bHlWAAN+gHu2+hE4swfBbnqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gxt0oRQQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gxt0oRQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D605DC4CEDD;
	Mon, 17 Mar 2025 00:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742172080;
	bh=Cf2o9LXdxnYRluCbu2i0Rht4BH4IfliLBPzB8LmzGqA=;
	h=Date:To:From:Subject:From;
	b=Gxt0oRQQTfeP++bS3m+4kIf+1TOBEYpA3eiEKx0yrFz9/d1vfQjtRTr48Yl/ocdaq
	 Ch456OoYRmTvhLSz2r/2gV3RMU9kWGlgX6ZYjU6Qefp9DdDj75yQGx8IgAfU7JS95h
	 oZnQ+oSFY4K1kK8wP5fzywghCuKr2IWyu7fuK/dE=
Date: Sun, 16 Mar 2025 17:41:20 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] memcg-drain-obj-stock-on-cpu-hotplug-teardown.patch removed from -mm tree
Message-Id: <20250317004120.D605DC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: drain obj stock on cpu hotplug teardown
has been removed from the -mm tree.  Its filename was
     memcg-drain-obj-stock-on-cpu-hotplug-teardown.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: drain obj stock on cpu hotplug teardown
Date: Mon, 10 Mar 2025 16:09:34 -0700

Currently on cpu hotplug teardown, only memcg stock is drained but we
need to drain the obj stock as well otherwise we will miss the stats
accumulated on the target cpu as well as the nr_bytes cached. The stats
include MEMCG_KMEM, NR_SLAB_RECLAIMABLE_B & NR_SLAB_UNRECLAIMABLE_B. In
addition we are leaking reference to struct obj_cgroup object.

Link: https://lkml.kernel.org/r/20250310230934.2913113-1-shakeel.butt@linux.dev
Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/memcontrol.c~memcg-drain-obj-stock-on-cpu-hotplug-teardown
+++ a/mm/memcontrol.c
@@ -1921,9 +1921,18 @@ void drain_all_stock(struct mem_cgroup *
 static int memcg_hotplug_cpu_dead(unsigned int cpu)
 {
 	struct memcg_stock_pcp *stock;
+	struct obj_cgroup *old;
+	unsigned long flags;
 
 	stock = &per_cpu(memcg_stock, cpu);
+
+	/* drain_obj_stock requires stock_lock */
+	local_lock_irqsave(&memcg_stock.stock_lock, flags);
+	old = drain_obj_stock(stock);
+	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
+
 	drain_stock(stock);
+	obj_cgroup_put(old);
 
 	return 0;
 }
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-add-hierarchical-effective-limits-for-v2.patch
memcg-dont-call-propagate_protected_usage-for-v1.patch
page_counter-track-failcnt-only-for-legacy-cgroups.patch
page_counter-reduce-struct-page_counter-size.patch
memcg-bypass-root-memcg-check-for-skmem-charging.patch
memcg-avoid-refill_stock-for-root-memcg.patch
memcg-move-do_memsw_account-to-config_memcg_v1.patch

