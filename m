Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4EC261588
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846670; cv=none; b=BLT42QOwjQB+83LxavmDywd0IURqU745ys966uQSG+ZGbQByWefs/7JcxolFLnAHG5rWPCdm1XsTZk9Xi09336uBM+Fko6JHWXcjVQ0oNPYkKn2teM4Ms0eauyLPEemdBdMoX5cgS2rXvJDsUAiBLIQf6up9excS3FvyzJpenrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846670; c=relaxed/simple;
	bh=1/c3QanMBnaA0yveJhhEADUfmBF4JzC3Z/10AfJosNc=;
	h=Date:To:From:Subject:Message-Id; b=cGPBiR5DTRG+cqOamynRtOJ1Vci+yb0c5iinqWy1Ib+kcaQjC0QBPWjxX6EAG98t/pFXZq3NnDldpnT/ZNYU55U95PzTXSyRBfA1WpAHHDHjXXLZOPc69KwkAyDA3MYWc7yGPE9Gi148pAGO1IwuW+BSIM1wq1oJcYQDKlB7fXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e0MKhgQ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e0MKhgQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BF4C4CEE4;
	Wed, 21 May 2025 16:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846670;
	bh=1/c3QanMBnaA0yveJhhEADUfmBF4JzC3Z/10AfJosNc=;
	h=Date:To:From:Subject:From;
	b=e0MKhgQ3C49JvJUyAq9TnzEK4sk/9y8pGmXAjE9lmudC5AK3eDCfjRp84FsntEoFK
	 4x8OYKm0AFkW09BILOlFziWi9dutoWd0H/EtEeJz5ycLFjYlxXhTgK/Pcnwx0mskFN
	 Jvg7y0pE6P0Vh79aRVy5KzOwGpCT9oRrAh/SrlBk=
Date: Wed, 21 May 2025 09:57:49 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-no-stock-lock-for-cpu-hot-unplug.patch removed from -mm tree
Message-Id: <20250521165750.50BF4C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: no stock lock for cpu hot-unplug
has been removed from the -mm tree.  Its filename was
     memcg-no-stock-lock-for-cpu-hot-unplug.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: no stock lock for cpu hot-unplug
Date: Wed, 14 May 2025 11:41:57 -0700

Previously on the cpu hot-unplug, the kernel would call drain_obj_stock()
with objcg local lock.  However local lock was not needed as the stock
which was accessed belongs to a dead cpu but we kept it there to disable
irqs as drain_obj_stock() may call mod_objcg_mlstate() which required irqs
disabled.  However there is no need to disable irqs now for
mod_objcg_mlstate(), so we can remove the local lock altogether from cpu
hot-unplug path.

Link: https://lkml.kernel.org/r/20250514184158.3471331-7-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/mm/memcontrol.c~memcg-no-stock-lock-for-cpu-hot-unplug
+++ a/mm/memcontrol.c
@@ -2025,17 +2025,8 @@ void drain_all_stock(struct mem_cgroup *
 
 static int memcg_hotplug_cpu_dead(unsigned int cpu)
 {
-	struct obj_stock_pcp *obj_st;
-	unsigned long flags;
-
-	obj_st = &per_cpu(obj_stock, cpu);
-
-	/* drain_obj_stock requires objstock.lock */
-	local_lock_irqsave(&obj_stock.lock, flags);
-	drain_obj_stock(obj_st);
-	local_unlock_irqrestore(&obj_stock.lock, flags);
-
 	/* no need for the local lock */
+	drain_obj_stock(&per_cpu(obj_stock, cpu));
 	drain_stock_fully(&per_cpu(memcg_stock, cpu));
 
 	return 0;
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-disable-kmem-charging-in-nmi-for-unsupported-arch.patch
memcg-nmi-safe-memcg-stats-for-specific-archs.patch
memcg-add-nmi-safe-update-for-memcg_kmem.patch
memcg-nmi-safe-slab-stats-updates.patch
memcg-make-memcg_rstat_updated-nmi-safe.patch

