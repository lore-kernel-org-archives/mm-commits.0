Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347EE2C08BC
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 19:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773085045; cv=none; b=jOWb6qoUUGLgs/FOGKTn21Xe0D975TWQ+MbYTGop0adavRwAeR6cGN2abmxHB5I0IK+yCfY2NvOuuD8btUwHut5nIUcHebbwzR3aTNN/QWSCdICYbLE340STRuJHR01j3KzlqtmdGtgyXVOXvUr3N/v6iDfS0AnZPt1KUVre38Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773085045; c=relaxed/simple;
	bh=NyQZa6o0jJkbgcNuEkDZ3gjvdt4zTOjqpd9UGCarfc4=;
	h=Date:To:From:Subject:Message-Id; b=f4qzSkHhcf8tQDjgfzfETKq131xrpB+VtFvE/MHiYgh0GJxhZ8yKYZ7UpNotdVxou52j0ZZK1N0EagocjeuA8RN03kEhJ43cbHb68sDKmlf0w9EXobLGA4QZSNBjAJPPiwMYBXLpR2yyznawukSMjBIzYPhinkmHwMs2K9drArE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XpnJOKvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XpnJOKvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0CACC4CEF7;
	Mon,  9 Mar 2026 19:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773085044;
	bh=NyQZa6o0jJkbgcNuEkDZ3gjvdt4zTOjqpd9UGCarfc4=;
	h=Date:To:From:Subject:From;
	b=XpnJOKvRp5j1GEGSaNujv8HMqj4NrdsQ2PyDIMmQSzM1AuMrDjqSPK2jLZrLc4ZJV
	 VEkrmXcSw0hYqZJFo6J0l28LhJzpNrsq4qb5INx0P0Mh9AxcG6hsjXnZL67OxsDSZ8
	 rLInSNUBxCybFPnO5+PXNH6jwktYz6JiC2FOwm78=
Date: Mon, 09 Mar 2026 12:37:24 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,yosry@kernel.org,weixugc@google.com,vbabka@kernel.org,usama.arif@linux.dev,usamaarif642@gmail.com,surenb@google.com,songmuchun@bytedance.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,chenridong@huawei.com,chengming.zhou@linux.dev,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix.patch added to mm-unstable branch
Message-Id: <20260309193724.B0CACC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix.patch

