Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A809C1D7E31
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846403; cv=none; b=GCoruaUt9M5pB4Uot1jnfhoDcenneKyHBzMFleZEmGKZR9cnc42QZZUzhx72w32bkIKaccfVvvNZFMDRaPvNvozMul5d82zLk6vUH+T0hqaJGaoN8z9Xw9V51DNs+d80zI1R1Qk7GbComyZLIZO12zJeVs7azU1nQBV8PlHv8PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846403; c=relaxed/simple;
	bh=uw91moKxsuykNqwT8dIwSUEqekFGiXOaQPv04avcc2Q=;
	h=Date:To:From:Subject:Message-Id; b=MEbyuRMoN5j78zKDl1qyILuuoYm3dUFU/QAlKaDHAtpU1XUUOJX30DQbk/Qik8MQ/biHZb+ajSWPrpFmUZd93F/GIBnvACQlAdxok2152pfBhpxBiSXoMwrpbqu5rAnwac/MA6hwNsUN6APCpVI5ALO/FnI2m9V5Fkx++9AaGEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YYLZEF4I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YYLZEF4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3EBAC4CEE4;
	Wed, 21 May 2025 16:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846402;
	bh=uw91moKxsuykNqwT8dIwSUEqekFGiXOaQPv04avcc2Q=;
	h=Date:To:From:Subject:From;
	b=YYLZEF4IHLDvHbcTQLJGQ0j7gKI2iStbd4heiSrvnmhxqWGD5RAgaplV2i8/11PjK
	 r6pzWYKI31ztudlJpuH+SAPhiDClHM3Pd44DDdfJiOTuucxTfyosE9zEapytkyNnYY
	 eTT7/X2Og9dTd9Ga6CdQ0oW3xNgDgVp2ehtk5FiY=
Date: Wed, 21 May 2025 09:53:18 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,ast@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] memcg-memcg_rstat_updated-re-entrant-safe-against-irqs-fix.patch removed from -mm tree
Message-Id: <20250521165322.C3EBAC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg-memcg_rstat_updated-re-entrant-safe-against-irqs-fix
has been removed from the -mm tree.  Its filename was
     memcg-memcg_rstat_updated-re-entrant-safe-against-irqs-fix.patch

This patch was dropped because it was folded into memcg-memcg_rstat_updated-re-entrant-safe-against-irqs.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: memcg-memcg_rstat_updated-re-entrant-safe-against-irqs-fix
Date: Thu, 15 May 2025 13:43:46 +0100

fix build

Link: https://lkml.kernel.org/r/22f69e6e-7908-4e92-96ca-5c70d535c439@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Tested-by: Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-memcg_rstat_updated-re-entrant-safe-against-irqs-fix
+++ a/mm/memcontrol.c
@@ -3697,7 +3697,8 @@ static void mem_cgroup_free(struct mem_c
 
 static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 {
-	struct memcg_vmstats_percpu *statc, __percpu *pstatc_pcpu;
+	struct memcg_vmstats_percpu *statc;
+	struct memcg_vmstats_percpu __percpu *pstatc_pcpu;
 	struct mem_cgroup *memcg;
 	int node, cpu;
 	int __maybe_unused i;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-kernel-forkc-to-relevant-sections.patch
mm-remove-warn_on_once-in-file_has_valid_mmap_hooks.patch
memcg-memcg_rstat_updated-re-entrant-safe-against-irqs.patch

