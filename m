Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1201C695
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498498; cv=none; b=IIH/QdmvZUG/usE0xeMXBxOPKgwan1TJk2AVL4q32s1iGlIlbNpKzB39cBwsZf7SpVUyb5Xa4vLyV6iZiTkcP4AxvXt0qYZDpVoCDBnLAIwK34CQHkVDiMqfiIyrNWANh/CDDkLjx5Qc3raRysbKmy+LsK1+bd6xEjpmDA1x7eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498498; c=relaxed/simple;
	bh=5UNCH13iIWHzN55nEAvOG2NuXwZchzlOZmXZPsednYo=;
	h=Date:To:From:Subject:Message-Id; b=GjtSlcxPuLcxWlMYOskN0cQvhY0BZUD6703T39ygPPSkV2PNshXSF/oNJCu2iGcFfzyy9U2f940yB6xqFxb1rPDouPGssTP65+QkJrhAU+W3LjxNAhgPZU1nNSn+YiM3FeplguvvUagpfg9H7TilNgwYztKG5ondOTD5T23JHf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pk7NAEjg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pk7NAEjg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C84C19424;
	Sat, 18 Apr 2026 07:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498498;
	bh=5UNCH13iIWHzN55nEAvOG2NuXwZchzlOZmXZPsednYo=;
	h=Date:To:From:Subject:From;
	b=Pk7NAEjgjfYilJgEvYcWMgOxBpPFWB88GqquV5SJKe3K9lcfDsjQSKSwQDvrl/IK9
	 Uol7eKUJTxdcx4oWQYo9YvrLY/HVqJGAGV22R0At6luEnccAFFcltLhNa3pHk2jim7
	 PrJqsn2EWG3LQd8vsQW7Rg+ez87bRSRHSjowfRss=
Date: Sat, 18 Apr 2026 00:48:13 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,yosry@kernel.org,weixugc@google.com,vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,chenridong@huawei.com,chengming.zhou@linux.dev,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-prevent-memory-cgroup-release-in-get_mem_cgroup_from_folio.patch removed from -mm tree
Message-Id: <20260418074817.99C84C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: prevent memory cgroup release in get_mem_cgroup_from_folio()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-prevent-memory-cgroup-release-in-get_mem_cgroup_from_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: prevent memory cgroup release in get_mem_cgroup_from_folio()
Date: Thu, 5 Mar 2026 19:52:26 +0800

In the near future, a folio will no longer pin its corresponding memory
cgroup.  To ensure safety, it will only be appropriate to hold the rcu
read lock or acquire a reference to the memory cgroup returned by
folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard against
the release of the memory cgroup in get_mem_cgroup_from_folio().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Link: https://lore.kernel.org/a5a64c6173a566bd21534606aeaaa9220cb1366d.1772711148.git.zhengqi.arch@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Allen Pais <apais@linux.microsoft.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chen Ridong <chenridong@huawei.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Imran Khan <imran.f.khan@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-prevent-memory-cgroup-release-in-get_mem_cgroup_from_folio
+++ a/mm/memcontrol.c
@@ -996,14 +996,18 @@ again:
  */
 struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
 {
-	struct mem_cgroup *memcg = folio_memcg(folio);
+	struct mem_cgroup *memcg;
 
 	if (mem_cgroup_disabled())
 		return NULL;
 
+	if (!folio_memcg_charged(folio))
+		return root_mem_cgroup;
+
 	rcu_read_lock();
-	if (!memcg || WARN_ON_ONCE(!css_tryget(&memcg->css)))
-		memcg = root_mem_cgroup;
+	do {
+		memcg = folio_memcg(folio);
+	} while (unlikely(!css_tryget(&memcg->css)));
 	rcu_read_unlock();
 	return memcg;
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


