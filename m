Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2291991CD
	for <mm-commits@vger.kernel.org>; Mon, 19 May 2025 22:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747693768; cv=none; b=UPYqu+RXybEv0++f8buk9SmQFOiISOusHsEeHOKdLIxY0gzbTbLlMdciPWgEGj6JFHclS1wzlnnQtvMcoaFeezKsKnZxRZ2qkEaEbC+bIl+40Aa6bbZ9eL+j5wN6UwyT4bhbFMnW1crKUvar9PLU2n/+D5W1qb7lb4UFYMcb/lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747693768; c=relaxed/simple;
	bh=K/ZbEXhXOi85gCqzNoDvT3haLYr0udDOkLU7hfCN2Hw=;
	h=Date:To:From:Subject:Message-Id; b=T68ie40OKkd32rZK/8+1vwkNu20f9LzNOiamrEgE6J9R+9ETy89pY1mPN2/zv/mSgSqWg0/+g5l0QF0EFVbTghCfS//x0fuU/SpwVzqq9vJsdGInUQCcn+m3qfrWIpKLkbP9V4nMTuT4g6C+TJAz5u7kgrxTd8OPUI22hrEKKBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QvS/iYlo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QvS/iYlo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A944FC4CEE4;
	Mon, 19 May 2025 22:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747693767;
	bh=K/ZbEXhXOi85gCqzNoDvT3haLYr0udDOkLU7hfCN2Hw=;
	h=Date:To:From:Subject:From;
	b=QvS/iYloemU/MKQFnZSFt0y+zhsJuI58Qar7efS4X9k+yeiCoSA/6nNoJTbD9V+Dp
	 W+nf4up2N4DzFoFpkD6PiTnGE0D0hCuC/N8Vu5Rv4QIpEb/77coMmW5ioUNDrcExbX
	 hxktRaKN9Xbnnzn9hu7R3NYZbauzhjY1w4N9ylM0=
Date: Mon, 19 May 2025 15:29:27 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mhocko@kernel.org,mathieu.desnoyers@efficios.com,hannes@cmpxchg.org,bigeasy@linutronix.de,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-add-nmi-safe-update-for-memcg_kmem.patch added to mm-new branch
Message-Id: <20250519222927.A944FC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: add nmi-safe update for MEMCG_KMEM
has been added to the -mm mm-new branch.  Its filename is
     memcg-add-nmi-safe-update-for-memcg_kmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-add-nmi-safe-update-for-memcg_kmem.patch

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
Subject: memcg: add nmi-safe update for MEMCG_KMEM
Date: Sun, 18 May 2025 23:31:40 -0700

The objcg based kmem charging and uncharging code path needs to update
MEMCG_KMEM appropriately.  Let's add support to update MEMCG_KMEM in
nmi-safe way for those code paths.

Link: https://lkml.kernel.org/r/20250519063142.111219-4-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~memcg-add-nmi-safe-update-for-memcg_kmem
+++ a/mm/memcontrol.c
@@ -2717,6 +2717,23 @@ struct obj_cgroup *get_obj_cgroup_from_f
 	return objcg;
 }
 
+#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
+static inline void account_kmem_nmi_safe(struct mem_cgroup *memcg, int val)
+{
+	if (likely(!in_nmi())) {
+		mod_memcg_state(memcg, MEMCG_KMEM, val);
+	} else {
+		/* TODO: add to cgroup update tree once it is nmi-safe. */
+		atomic_add(val, &memcg->kmem_stat);
+	}
+}
+#else
+static inline void account_kmem_nmi_safe(struct mem_cgroup *memcg, int val)
+{
+	mod_memcg_state(memcg, MEMCG_KMEM, val);
+}
+#endif
+
 /*
  * obj_cgroup_uncharge_pages: uncharge a number of kernel pages from a objcg
  * @objcg: object cgroup to uncharge
@@ -2729,7 +2746,7 @@ static void obj_cgroup_uncharge_pages(st
 
 	memcg = get_mem_cgroup_from_objcg(objcg);
 
-	mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
+	account_kmem_nmi_safe(memcg, -nr_pages);
 	memcg1_account_kmem(memcg, -nr_pages);
 	if (!mem_cgroup_is_root(memcg))
 		refill_stock(memcg, nr_pages);
@@ -2757,7 +2774,7 @@ static int obj_cgroup_charge_pages(struc
 	if (ret)
 		goto out;
 
-	mod_memcg_state(memcg, MEMCG_KMEM, nr_pages);
+	account_kmem_nmi_safe(memcg, nr_pages);
 	memcg1_account_kmem(memcg, nr_pages);
 out:
 	css_put(&memcg->css);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-memcg_rstat_updated-re-entrant-safe-against-irqs.patch
memcg-move-preempt-disable-to-callers-of-memcg_rstat_updated.patch
memcg-make-mod_memcg_state-re-entrant-safe-against-irqs.patch
memcg-make-count_memcg_events-re-entrant-safe-against-irqs.patch
memcg-make-__mod_memcg_lruvec_state-re-entrant-safe-against-irqs.patch
memcg-no-stock-lock-for-cpu-hot-unplug.patch
memcg-objcg-stock-trylock-without-irq-disabling.patch
memcg-disable-kmem-charging-in-nmi-for-unsupported-arch.patch
memcg-nmi-safe-memcg-stats-for-specific-archs.patch
memcg-add-nmi-safe-update-for-memcg_kmem.patch
memcg-nmi-safe-slab-stats-updates.patch
memcg-make-memcg_rstat_updated-nmi-safe.patch

