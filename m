Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEF11553A3
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011026; cv=none; b=M+npfH4eEQ1iqrmaGywEK6i2MWo8WeEoP07gyG0Iim45ATtTrVgxv9h0djDM9ififd8Kvu9Z+cKG+gdflCmCwcmy+XkR6NK03a5koie6tnpk/0S3HZgzD0esDawnRcqCT9a+d9kvBPvr7YI7QlgFedEN8p9+TuEOltjAxQ43cSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011026; c=relaxed/simple;
	bh=di23LRBE+XNXspOw8YkvjmuDOffJtpB0auFKtIbVAV4=;
	h=Date:To:From:Subject:Message-Id; b=i103fQxUA6Xkn0lJSgN3Z2hlcacQlom3xmcSrUj2b1K0UAGWVzJkdzDSEJQB6RVwgdp4EcJ/Ws658+ao7oK6X+LozJKlnJPvAv0GIvB+dwA3q4+iTp/0ErXZW614dGe8DmF0uoY0D5xYBSmf83jMbz776S8YovGxqj/iV5GJ2JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HENt8LG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HENt8LG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5EB5C4CEE4;
	Mon, 12 May 2025 00:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011026;
	bh=di23LRBE+XNXspOw8YkvjmuDOffJtpB0auFKtIbVAV4=;
	h=Date:To:From:Subject:From;
	b=HENt8LG8tyAwEMQ78+DoH18WIef8GKH6RjKvpqismDs4RBrDs4IqevtyzlM+TcAx5
	 nz98y0ov1JrU9dSL2yhzbjX2oxnTxtj56QgeRHE27zV63Z8SFPLGRIuXg/dr3fgu9V
	 4R+AtU/5OO1/Zg8QriE+3dl9q0Cu/+xzSPO1Ik5c=
Date: Sun, 11 May 2025 17:50:25 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-use-__mod_memcg_state-in-drain_obj_stock.patch removed from -mm tree
Message-Id: <20250512005025.E5EB5C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: use __mod_memcg_state in drain_obj_stock
has been removed from the -mm tree.  Its filename was
     memcg-use-__mod_memcg_state-in-drain_obj_stock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: use __mod_memcg_state in drain_obj_stock
Date: Thu, 3 Apr 2025 18:39:11 -0700

For non-PREEMPT_RT kernels, drain_obj_stock() is always called with irq
disabled, so we can use __mod_memcg_state() instead of mod_memcg_state(). 
For PREEMPT_RT, we need to add memcg_stats_[un]lock in
__mod_memcg_state().

Link: https://lkml.kernel.org/r/20250404013913.1663035-8-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-use-__mod_memcg_state-in-drain_obj_stock
+++ a/mm/memcontrol.c
@@ -710,10 +710,12 @@ void __mod_memcg_state(struct mem_cgroup
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return;
 
+	memcg_stats_lock();
 	__this_cpu_add(memcg->vmstats_percpu->state[i], val);
 	val = memcg_state_val_in_pages(idx, val);
 	memcg_rstat_updated(memcg, val);
 	trace_mod_memcg_state(memcg, idx, val);
+	memcg_stats_unlock();
 }
 
 #ifdef CONFIG_MEMCG_V1
@@ -2866,7 +2868,7 @@ static void drain_obj_stock(struct memcg
 
 			memcg = get_mem_cgroup_from_objcg(old);
 
-			mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
+			__mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
 			memcg1_account_kmem(memcg, -nr_pages);
 			if (!mem_cgroup_is_root(memcg))
 				memcg_uncharge(memcg, nr_pages);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-introduce-non-blocking-limit-setting-option.patch
memcg-introduce-non-blocking-limit-setting-option-v3.patch
memcg-simplify-consume_stock.patch
memcg-separate-local_trylock-for-memcg-and-obj.patch
memcg-completely-decouple-memcg-and-obj-stocks.patch
memcg-no-irq-disable-for-memcg-stock-lock.patch

