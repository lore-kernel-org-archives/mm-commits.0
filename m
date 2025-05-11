Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C28817BB6
	for <mm-commits@vger.kernel.org>; Sun, 11 May 2025 03:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746935009; cv=none; b=FxZ70d96Q5VrljRAPFaYJzdS72uyz6WUhpEiGDeP3Re92+SaZBkoLTZDtyihg9YFsvSOnIxq4RtRKbQAMzj454oTKgP5Gj87m/6LshCSgjPABf/KgeLc4yIGvaBuNmLYTduNpQxGcXkLoRoePQr5nt3cLJDHHoRfr4JcIBiC0N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746935009; c=relaxed/simple;
	bh=fkxHeMRDPIMIIzu7epL1TQ8xrU1ELLGdru03bETwilo=;
	h=Date:To:From:Subject:Message-Id; b=Muf5tlMh+0oCecDIkCcx1vRYlwywCx1Btwf3TGYaV8GgddtiVTyIy9r5saB9Nmwsx7DdShz9Jg7SKqCXv3Um5P4bDI7xCy1kNoPKf0iPqYgwjp8pYived3e6P5PEiPuhBkR6Ad/MApqfqmwkMpU8I/1JWt3p7qX17hi1aqUDJuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vcT+DpTM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vcT+DpTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE3DC4CEE4;
	Sun, 11 May 2025 03:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746935009;
	bh=fkxHeMRDPIMIIzu7epL1TQ8xrU1ELLGdru03bETwilo=;
	h=Date:To:From:Subject:From;
	b=vcT+DpTMHRBQKSg8DjYKNR/yEQ9uXUORJIRt8AaCPMF/5mZ2F6AMKJEkhhUlwW9vn
	 vyKECnboQQfVMQtGk4EA5NJKy9j84V2KlEA27EMMWcLpUUJ0MSXWH3ZhJ2eBD0P9ni
	 0HgyjNhfllalHLTD2BRrWwufJOGVNj2P5x9dtbtU=
Date: Sat, 10 May 2025 20:43:28 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,soheil@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,kuba@kernel.org,hughd@google.com,hannes@cmpxchg.org,edumazet@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] memcg-multi-memcg-percpu-charge-cache-fix-4.patch removed from -mm tree
Message-Id: <20250511034329.4DE3DC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: multi-memcg percpu charge cache - fix 4
has been removed from the -mm tree.  Its filename was
     memcg-multi-memcg-percpu-charge-cache-fix-4.patch

This patch was dropped because it was folded into memcg-multi-memcg-percpu-charge-cache.patch

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: multi-memcg percpu charge cache - fix 4
Date: Wed, 30 Apr 2025 08:28:23 -0700

Add comment suggested by Michal and use DEFINE_PER_CPU_ALIGNED instead of
DEFINE_PER_CPU suggested by Vlastimil.

Link: https://lkml.kernel.org/r/dieeei3squ2gcnqxdjayvxbvzldr266rhnvtl3vjzsqevxkevf@ckui5vjzl2qg
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Eric Dumaze <edumazet@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-multi-memcg-percpu-charge-cache-fix-4
+++ a/mm/memcontrol.c
@@ -1769,6 +1769,10 @@ void mem_cgroup_print_oom_group(struct m
 	pr_cont(" are going to be killed due to memory.oom.group set\n");
 }
 
+/*
+ * The value of NR_MEMCG_STOCK is selected to keep the cached memcgs and their
+ * nr_pages in a single cacheline. This may change in future.
+ */
 #define NR_MEMCG_STOCK 7
 struct memcg_stock_pcp {
 	local_trylock_t stock_lock;
@@ -1785,7 +1789,7 @@ struct memcg_stock_pcp {
 	unsigned long flags;
 #define FLUSHING_CACHED_CHARGE	0
 };
-static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock) = {
+static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
 	.stock_lock = INIT_LOCAL_TRYLOCK(stock_lock),
 };
 static DEFINE_MUTEX(percpu_charge_mutex);
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
memcg-introduce-non-blocking-limit-setting-option.patch
memcg-introduce-non-blocking-limit-setting-option-v3.patch
memcg-simplify-consume_stock.patch
memcg-separate-local_trylock-for-memcg-and-obj.patch
memcg-completely-decouple-memcg-and-obj-stocks.patch
memcg-no-irq-disable-for-memcg-stock-lock.patch

