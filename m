Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415106;
	b=LhX3XkPATj0M+yjt3ZjXPg9lATaMMoyNjmZDscChhuE+Gp8ZEshm6BjF4/oH4cuVd6T4
	 PEB+zlBW3e51lYTWgFZtTJPyfA6z6pw/ur41mG6fEFiO37mnROHSdwufbV9O2SNd15sxp
	 HsPpDM3dq3TQwWEdydRGEa4OckIMXOH+zGLB1UC0NW/eLJvZ5kCoAVXlDiUFLMilNzRsE
	 T+pVzsyU1Gp7nTpqb5Yj+o4j2tJOfHKn7eV0wEoAk6oCehTxc+v3kbQotoMK0NprhJsMh
	 C9yhSLewmrrFxzucrmmJisHfwXMC3CfdpXvZkpeaUmxr+AZBwyVxGTkuuanTeSlxPbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415106;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=gRLGxMUijEjcjpSvnhcly2PgKTY+iEwCXuDQZOFashQ=;
	b=sGHvauMKdZJ0eQFUcg1uGXbNwOQ4N9s5CgYsryAIe940sHfAOxtOJWMoFCPubmrUr7F4
	 /k/Lz2C1u0w8Nsd17DtcmJT4+WF9P0qm1NwhK+k2JWDwmo5CEBpdwLbnVM+KpUJExvHUi
	 lD3sde80Ikev1peGrShb++AOHaUR6/0Ff/Y/ZSbolieqJIp+3WWwoP9T4DN9pV0F7Qd4O
	 zCjBxiCpjc2lnueYSnUYf9Rw177GAs2OgjBWWcR/x9mFgwLYxFWk/R/CRFP+dyNBeMTtO
	 1gPo/6QflMxhDUQ/I+3n+UV9JdF64tyy3lZdiS8yQ5CAGlPkPeuDwyAQEmzOSriw3Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=yEY7Hhun;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AEA606A31F;
	Mon, 23 Nov 2026 06:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=yEY7Hhun
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1320F1F000C6;
	Mon, 23 Nov 2026 06:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795415106;
	bh=gRLGxMUijEjcjpSvnhcly2PgKTY+iEwCXuDQZOFashQ=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=yEY7HhunRpRSL06LFjm3MqyGOe5X6sMND4fwZno9Ma2mtP10kyXgQ9r8Jn10/AC6M
	 wp4hGAKQ3PTH9ke+XEhpOFtI/RoEl01d0sxglifzrrEd21N2eosRniW0wGaQD1/+cg
	 0nHCtN6Foa/PDTbuhm6Vm5xHghnBcZ1ICF7x8AIg=
Date: Sun, 22 Nov 2026 22:25:05 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,
	roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,
	mason@kernel.org,harry@kernel.org,hannes@cmpxchg.org,david@kernel.org,
	shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261112013220.4064478-1-shakeel.butt@linux.dev>
References: <20261112013220.4064478-1-shakeel.butt@linux.dev>
Subject: [merged mm-hotfixes-stable] memcg-flush-nr_charged_bytes-when-the-obj-stock-trylock-fails.patch removed from -mm tree
Message-Id: <20261123062506.1320F1F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: memcg: flush nr_charged_bytes when the obj stock trylock fails
has been removed from the -mm tree.  Its filename was
     memcg-flush-nr_charged_bytes-when-the-obj-stock-trylock-fails.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: flush nr_charged_bytes when the obj stock trylock fails
Date: Wed, 11 Nov 2026 17:32:20 -0800

When interrupt code, such as an RCU callback in softirq, runs on top of a
task that holds the obj stock lock, its trylock fails and the bytes go to
objcg->nr_charged_bytes.  Nothing empties that counter while every CPU
using the objcg keeps it in its stock, so it can grow without limit.

Users see memory.current and the "kernel" field of memory.stat keep
growing while the cgroup's real usage does not.  With memory.high or
memory.max set, the cgroup is reclaimed, throttled or even OOM-killed for
memory it does not use.  The counter is 32-bit, so after 4 GiB it wraps,
and those 4 GiB stay charged to the cgroup and its ancestors until reboot,
even after the cgroup is removed.

Fix it by uncharging the whole pages in nr_charged_bytes whenever the
trylock fails.

Link: https://patch.msgid.link/20261112013220.4064478-1-shakeel.butt@linux.dev
Fixes: 200577f69f29 ("memcg: objcg stock trylock without irq disabling")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chris Mason <mason@kernel.org>
Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memcontrol.c~memcg-flush-nr_charged_bytes-when-the-obj-stock-trylock-fails
+++ a/mm/memcontrol.c
@@ -3532,6 +3532,8 @@ static void __refill_obj_stock(struct ob
 	int i, slot = -1, empty_slot = -1;
 
 	if (!stock) {
+		nr_bytes += atomic_read(&objcg->nr_charged_bytes)
+			? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
 		nr_pages = nr_bytes >> PAGE_SHIFT;
 		nr_bytes = nr_bytes & (PAGE_SIZE - 1);
 		atomic_add(nr_bytes, &objcg->nr_charged_bytes);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-move-memoryhigh-enforcement-out-of-try_charge_memcg.patch
memcg-force-charges-from-reclaim-before-trying-the-limits.patch
memcg-use-high_work-for-kernel-threads.patch
memcg-use-high_work-for-remote-charges.patch
memcg-simplify-high-limit-handling-after-a-charge.patch

