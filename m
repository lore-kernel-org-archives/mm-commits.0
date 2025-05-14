Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5459D1FA15E
	for <mm-commits@vger.kernel.org>; Wed, 14 May 2025 05:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747202340; cv=none; b=GE2zvfO7wLcZk0cG6DmVUhhTRIbAZpmhjhyQh+r9yIjma2oUiRp1PY+65wOQGN6K5FCtmgbwiALvknh+k8wYtWhzlyYYzI996JOUruYPOFPf95Jw79eKwsdu9WH0RzZyABOY9ohmVAHXjtGi9GGHYFivMPFiBmUAv1IS4y/XhkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747202340; c=relaxed/simple;
	bh=O0PaiS8alh9YjULq3ddogTcbYjBbsvAG+qzK3HeKmdc=;
	h=Date:To:From:Subject:Message-Id; b=ashQLF3qkGJ6L+Ohpjg9QBWodFGWv64ZisHWq8UztJFGQHMX+2dULiwJyd5Ti+Wq19ycwaM9h9f99D2y3NU2CdaNqcWTKPKHn1ppgvk5/EGdyPsMz4dzJfc27V8N7e3WoCbGNOEacG57CfaDNVS3PAdVlUoLNF/SybiVPYEoGXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q8vj6W87; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q8vj6W87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09FBC4CEE9;
	Wed, 14 May 2025 05:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747202339;
	bh=O0PaiS8alh9YjULq3ddogTcbYjBbsvAG+qzK3HeKmdc=;
	h=Date:To:From:Subject:From;
	b=q8vj6W87tSsAJs5xCL/R2U/PhMplsBI8X5JdQSQvKA6Q2NC1Paabirm9lf64OuVVg
	 F5x+4G/FTjtTzRQjIR29Y8GuMo3pj55DO45INJk2dBU6VRmny6ozEqXo83zy/Giyql
	 4KePsIguFdgUuew7OZP+TzZg3xzx/IDX2FAjCVTs=
Date: Tue, 13 May 2025 22:58:59 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-no-stock-lock-for-cpu-hot-unplug.patch added to mm-new branch
Message-Id: <20250514055859.B09FBC4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: no stock lock for cpu hot-unplug
has been added to the -mm mm-new branch.  Its filename is
     memcg-no-stock-lock-for-cpu-hot-unplug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-no-stock-lock-for-cpu-hot-unplug.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: no stock lock for cpu hot-unplug
Date: Tue, 13 May 2025 22:08:12 -0700

Previously on the cpu hot-unplug, the kernel would call drain_obj_stock()
with objcg local lock.  However local lock was not needed as the stock
which was accessed belongs to a dead cpu but we kept it there to disable
irqs as drain_obj_stock() may call mod_objcg_mlstate() which required irqs
disabled.  However there is no need to disable irqs now for
mod_objcg_mlstate(), so we can remove the local lock altogether from cpu
hot-unplug path.

Link: https://lkml.kernel.org/r/20250514050813.2526843-7-shakeel.butt@linux.dev
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

memcg-memcg_rstat_updated-re-entrant-safe-against-irqs.patch
memcg-move-preempt-disable-to-callers-of-memcg_rstat_updated.patch
memcg-make-mod_memcg_state-re-entrant-safe-against-irqs.patch
memcg-make-count_memcg_events-re-entrant-safe-against-irqs.patch
memcg-make-__mod_memcg_lruvec_state-re-entrant-safe-against-irqs.patch
memcg-no-stock-lock-for-cpu-hot-unplug.patch
memcg-objcg-stock-trylock-without-irq-disabling.patch

