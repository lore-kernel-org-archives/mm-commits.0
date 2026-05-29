Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC18B370AD2
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027669; cv=none; b=cIC8RucQ0duicp/eTCNlezOLW8hqTDmsYI3FthKtGDCWe/yvUhhY3NuFrDpzuQGN83ff7HMYCxUQ1dqnPmn0iPMk+0cIKjFq0tk/uJkg/W1Zvioigu3tiWiWRPluI6PUBIxU7Qyku4Uwgy6jqjnImrs/AlilvytE+7eucvkMn40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027669; c=relaxed/simple;
	bh=dz+O846QY2Kye3/kkhwL/kUw9CcY9K7D8aTRrLSJAf4=;
	h=Date:To:From:Subject:Message-Id; b=M7I8X+aNFHrLFVDOqJubm/zwWPLMoKCbAxJyPXkDlEPq4NVcwlKNMrjmzDAGqUOv1uvP71dy3EQ8mmkVSiTAsTZSFDFOkiClZfAGrJw36zF91mE5seinpsgAbiuhl89tAK/zn4+6Mqt+fG/ZflxdcM3LFRDxDfiWaA4kmmnPFiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ufTuLUhf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ufTuLUhf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB411F00893;
	Fri, 29 May 2026 04:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027667;
	bh=2u1rh+0pd0Rk4zQbPGYg2RjBr8NFNnwBK3dyk9gGVfY=;
	h=Date:To:From:Subject;
	b=ufTuLUhff61+6uoucrnzIWJ9h8UP3CGjy3UawgLiIsIiYs+H1b6XTujULlyHBNZg8
	 6WHZXDRQlIA9A9EdO7gz6QPNfDGm3EbwX0QFe8x8SfeQjxypzP97y4ptQt3vS48Zdj
	 JOP2WvJNi+DPqrZ96jzf+cM9SIeZP3vs1ZTZOpog=
Date: Thu, 28 May 2026 21:07:47 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-hoist-pstatc_pcpu-assignment-out-of-cpu-loop.patch removed from -mm tree
Message-Id: <20260529040747.BFB411F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memcontrol: hoist pstatc_pcpu assignment out of CPU loop
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-hoist-pstatc_pcpu-assignment-out-of-cpu-loop.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: mm/memcontrol: hoist pstatc_pcpu assignment out of CPU loop
Date: Wed, 29 Apr 2026 16:42:16 +0800

In mem_cgroup_alloc(), the assignment of pstatc_pcpu is invariant with
respect to the for_each_possible_cpu() loop: both the 'parent' pointer and
'parent->vmstats_percpu' remain constant throughout all iterations.

The original code redundantly re-evaluated the 'if (parent)' condition and
reassigned pstatc_pcpu on every CPU iteration, then repeated the same
ternary check 'parent ?  pstatc_pcpu : NULL' when storing into
statc->parent_pcpu.

Move the single conditional assignment of pstatc_pcpu to before the loop,
resolving both the loop-invariant placement issue and the duplicated null
check.  On systems with a large number of possible CPUs, this eliminates
repeated branch evaluation with no functional change.

No functional change intended.

Link: https://lore.kernel.org/20260429084216.186238-1-hui.zhu@linux.dev
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-hoist-pstatc_pcpu-assignment-out-of-cpu-loop
+++ a/mm/memcontrol.c
@@ -4002,11 +4002,10 @@ static struct mem_cgroup *mem_cgroup_all
 	if (!memcg1_alloc_events(memcg))
 		goto fail;
 
+	pstatc_pcpu = parent ? parent->vmstats_percpu : NULL;
 	for_each_possible_cpu(cpu) {
-		if (parent)
-			pstatc_pcpu = parent->vmstats_percpu;
 		statc = per_cpu_ptr(memcg->vmstats_percpu, cpu);
-		statc->parent_pcpu = parent ? pstatc_pcpu : NULL;
+		statc->parent_pcpu = pstatc_pcpu;
 		statc->vmstats = memcg->vmstats;
 	}
 
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are


