Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94682152176
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560547; cv=none; b=oonYrhRQRLtrF73fFsH3iudn/5toZ+aqcHvg5aipJjsBUMdw5elBxxA/yVCVp2HQaOutiyprt3zUkhy0Ly8HaTrk1LjR3+qlAFDQFwNBD/9nIE9E5O3H2hILRnSEKwpE9eF4bjqvTUqblou7j0u+5LflmbuwpS1Dh3/Do12Tp+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560547; c=relaxed/simple;
	bh=AjsaPyQVNpsJ+7sfHMzjDCzScX8P/ba3Awt1kzPDszs=;
	h=Date:To:From:Subject:Message-Id; b=KQqRDpsOXR2DgDNo79jUN0F1qYn7XT9qRk7L3nyJB89+rb0flsAWsWmaKs/7ohr3FPJb7IwN94ftvFq4Mkxl+u23pVLwLTXUcKSp62FzIgkEIZWYQ8rKOAIrXYtBEdfBNRzFxpEVu4NFuOpkoX2xhQGGVGtLzF/0VZhivTIH+gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1QP0tv9j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1QP0tv9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F241C4CEC6;
	Tue, 17 Sep 2024 08:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560547;
	bh=AjsaPyQVNpsJ+7sfHMzjDCzScX8P/ba3Awt1kzPDszs=;
	h=Date:To:From:Subject:From;
	b=1QP0tv9jj4y0DryAB/dlj+/iYZ9V46MlP1GC2Th7cN5uGh3KvCDKkuRlTM411wfxa
	 jKvMmLTdzTu5XTiC58xdLBHP87hzh1fGnrlcR/zi09xX4imTOVgutXfBXFe7WsTq+/
	 0xXs5i/ZYFC53GHnlZsQAaQOIfYp8XVIAZsJCD8w=
Date: Tue, 17 Sep 2024 01:09:04 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,longman@redhat.com,lizefan.x@bytedance.com,hannes@cmpxchg.org,chenridong@huawei.com,mkoutny@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-cleanup-with-config_memcg_v1.patch removed from -mm tree
Message-Id: <20240917080907.0F241C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: cleanup with !CONFIG_MEMCG_V1
has been removed from the -mm tree.  Its filename was
     memcg-cleanup-with-config_memcg_v1.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Michal Koutný <mkoutny@suse.com>
Subject: memcg: cleanup with !CONFIG_MEMCG_V1
Date: Mon, 9 Sep 2024 18:32:20 +0200

Extern declarations have no definitions with !CONFIG_MEMCG_V1 and no
users, drop them altogether.

Link: https://lkml.kernel.org/r/20240909163223.3693529-1-mkoutny@suse.com
Link: https://lkml.kernel.org/r/20240909163223.3693529-2-mkoutny@suse.com
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Chen Ridong <chenridong@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.h |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memcontrol-v1.h~memcg-cleanup-with-config_memcg_v1
+++ a/mm/memcontrol-v1.h
@@ -154,8 +154,6 @@ static inline bool memcg1_charge_skmem(s
 				       gfp_t gfp_mask) { return true; }
 static inline void memcg1_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages) {}
 
-extern struct cftype memsw_files[];
-extern struct cftype mem_cgroup_legacy_files[];
 #endif	/* CONFIG_MEMCG_V1 */
 
 #endif	/* __MM_MEMCONTROL_V1_H */
_

Patches currently in -mm which might be from mkoutny@suse.com are


