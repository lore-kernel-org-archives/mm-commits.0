Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645F71411DE
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756826; cv=none; b=c+2QfiRs+usWIf+ArBCnKyw9KbwinEIWWNel9LrssnMJiZPQEdzCyS1o5/f893kJg6vRc2/LmHHZHVal5UBVsqk40lcs90Qq9S9WVcb4kWkdtot6/9onQKUoo72ahGf1ngY3j2zAbqoypfdJnlZzwOmk4vXlJoXe/iSboqnNvLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756826; c=relaxed/simple;
	bh=TU4vWniXeEqAYMxQvrJxgAMfqAWX+l/h52q47xHpHKU=;
	h=Date:To:From:Subject:Message-Id; b=Jjt1kRD9KCW7T1N+51/6gFZNqo/J7apO8mWlruwQqHiPirZbryDwzwQsjL6Pwh2j6VTdRtiSdwH1UJtBTd4iHbo20T2ABGGwEZYt5GIr9Wh7cYhkvTZMh+q3E0k4xLSUIrgQ4HQfRcEKeIqCpQDiWrsZt1sUZ5BhcLC1NE/f02I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wJ0ZrZrV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wJ0ZrZrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6E7C4CEED;
	Sun,  1 Jun 2025 05:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756826;
	bh=TU4vWniXeEqAYMxQvrJxgAMfqAWX+l/h52q47xHpHKU=;
	h=Date:To:From:Subject:From;
	b=wJ0ZrZrVkKf7w4yoHxm+ZmXXEa7c5rLK/3glCQddYceenOpg4jX21LlIIL6jsJRex
	 sUQLuLPGedQ8iEo5UOveNT+by3Kyf1jEo/lyOZ8PaG2uohh9ECF5lFDMfaU5eGrIt3
	 zc2MGLKatrXWKGRuvRC0ZOBmxfDH1dbJIhc/CDOQ=
Date: Sat, 31 May 2025 22:47:05 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mhocko@kernel.org,mathieu.desnoyers@efficios.com,hannes@cmpxchg.org,bigeasy@linutronix.de,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-add-nmi-safe-update-for-memcg_kmem.patch removed from -mm tree
Message-Id: <20250601054706.2B6E7C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: add nmi-safe update for MEMCG_KMEM
has been removed from the -mm tree.  Its filename was
     memcg-add-nmi-safe-update-for-memcg_kmem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2715,6 +2715,23 @@ struct obj_cgroup *get_obj_cgroup_from_f
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
@@ -2727,7 +2744,7 @@ static void obj_cgroup_uncharge_pages(st
 
 	memcg = get_mem_cgroup_from_objcg(objcg);
 
-	mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
+	account_kmem_nmi_safe(memcg, -nr_pages);
 	memcg1_account_kmem(memcg, -nr_pages);
 	if (!mem_cgroup_is_root(memcg))
 		refill_stock(memcg, nr_pages);
@@ -2755,7 +2772,7 @@ static int obj_cgroup_charge_pages(struc
 	if (ret)
 		goto out;
 
-	mod_memcg_state(memcg, MEMCG_KMEM, nr_pages);
+	account_kmem_nmi_safe(memcg, nr_pages);
 	memcg1_account_kmem(memcg, nr_pages);
 out:
 	css_put(&memcg->css);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


