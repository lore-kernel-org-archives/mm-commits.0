Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6337F1684BE
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 23:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774394171; cv=none; b=GIBkeNoI/wJyeH1Bd+jHgvT9ckRKFhIKAwlUVyxU1A5imW3uf+L7cMbnazkhY2DDs1Oj7XjfLwZm9Va+XAf1SOdtT8GuFt5wPKdoa1nFGoZdaMBY4Fa/7gGRD5Do52FSc7ES9aHH6w9nSCRmiK6+mL83IQYpWrQoiziG1EMxKnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774394171; c=relaxed/simple;
	bh=30L/nrljYGFhFe86xJfKUBnUrPWdsKFpWwaq7FgfQ88=;
	h=Date:To:From:Subject:Message-Id; b=hdoPZiFUWKtAL/lYsRLgnZctijHoHSlrFxHZhdpMjEiY/hcEmxGd4V4jPFcw3nD/SMlPfT8dgSfOdTdz0MN31ZL5LkvTRH8y48yeC7Y63vSJIE2iLcBQcFeMOOZNhvacg5v7SXRfPxBHNWZ8PvJjsnZeVBdrNAb3I4JtLWHyrWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rR7o/zz3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rR7o/zz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C77C19424;
	Tue, 24 Mar 2026 23:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774394171;
	bh=30L/nrljYGFhFe86xJfKUBnUrPWdsKFpWwaq7FgfQ88=;
	h=Date:To:From:Subject:From;
	b=rR7o/zz3u1LSLh7tv1L1akPsJv1SLrJzuEsODwmCpKJIn5Km4AzmpYKWZ25ZSWOM2
	 2/mtalWhm+S6IrULE3AjBxy+vo0tSXEojbFM8XJp+w9roEvdS7c8n4f2mb5uFPRaOU
	 0zOJ/xLapfh3NY0cuHCSyB+UfM6bCTT+0Y1ZwPK8=
Date: Tue, 24 Mar 2026 16:16:10 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,yosry@kernel.org,weixugc@google.com,vbabka@kernel.org,usama.arif@linux.dev,usamaarif642@gmail.com,surenb@google.com,songmuchun@bytedance.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,chenridong@huawei.com,chengming.zhou@linux.dev,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix.patch removed from -mm tree
Message-Id: <20260324231610.E0C77C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix.patch

This patch was dropped because it was folded into mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type.patch

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix
Date: Mon, 9 Mar 2026 19:29:39 +0800

Reset pn->orig_objcg to NULL to prevent obj_cgroup_put() from being called
agagin in __mem_cgroup_free().

Link: https://lkml.kernel.org/r/20260309112939.31937-1-qi.zheng@linux.dev
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reported-by: Usama Arif <usama.arif@linux.dev>
Cc: Allen Pais <apais@linux.microsoft.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chen Ridong <chenridong@huawei.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Imran Khan <imran.f.khan@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix
+++ a/mm/memcontrol.c
@@ -4056,8 +4056,14 @@ free_objcg:
 	for_each_node(nid) {
 		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
 
-		if (pn && pn->orig_objcg)
+		if (pn && pn->orig_objcg) {
 			obj_cgroup_put(pn->orig_objcg);
+			/*
+			 * Reset pn->orig_objcg to NULL to prevent obj_cgroup_put()
+			 * from being called agagin in __mem_cgroup_free().
+			 */
+			pn->orig_objcg = NULL;
+		}
 	}
 	free_shrinker_info(memcg);
 offline_kmem:
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-vmscan-prepare-for-the-refactoring-the-move_folios_to_lru.patch
mm-thp-prevent-memory-cgroup-release-in-folio_split_queue_lock_irqsave.patch
mm-zswap-prevent-memory-cgroup-release-in-zswap_compress.patch
mm-do-not-open-code-lruvec-lock.patch
mm-vmscan-prepare-for-reparenting-traditional-lru-folios.patch
mm-vmscan-prepare-for-reparenting-mglru-folios.patch
mm-memcontrol-refactor-memcg_reparent_objcgs.patch
mm-workingset-use-lruvec_lru_size-to-get-the-number-of-lru-pages.patch
mm-memcontrol-refactor-mod_memcg_state-and-mod_memcg_lruvec_state.patch
mm-memcontrol-prepare-for-reparenting-non-hierarchical-stats.patch
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type.patch

