Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168DD337699
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498539; cv=none; b=oYFIlGiJwbmC7Pwxmn4NDCR7wOGRrBmh++oXHTr5lZ1XxnMfBrIsZ9fFjeiFHgi5LCrBAdxygZ0uwGeyFw2mZGEiMi+ONC7vYKu55VOicYZ/XS7/6MVZPUPrULy73SSVp+xUnlqSJR14/trisTSTjDxjHqBSs0M4vs2avhKtd38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498539; c=relaxed/simple;
	bh=OrZT7Rh3mq78pDWwIVCB7DeLoeT5iNa4Ia4nDTpu1E0=;
	h=Date:To:From:Subject:Message-Id; b=BK+FfL3N8t9xJYtWthoLmjPiSmuPAd20P21skRPbw2QTC76W7POj7rzwWdWgXvdE0KkWncadQwXU8Z5rPl+zWa7w4XWVmNeWzggTJl9H6wwnntZ9JIENOgUf8sDSOORJgvu1mFRni8a7MPRBHBV7+BtqSKEuUUULedQLwmQnqXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CpdchZP0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CpdchZP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6F9C19424;
	Sat, 18 Apr 2026 07:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498539;
	bh=OrZT7Rh3mq78pDWwIVCB7DeLoeT5iNa4Ia4nDTpu1E0=;
	h=Date:To:From:Subject:From;
	b=CpdchZP0vt5E1NdcuGxSoF/p8cljGoprCDkgRm4QEo7wrWtRT9Wx2iknK+TOHQ3ee
	 g3cYv8ZVF6Ywua9015qIbbuNfNEnYZrCBZnFuriR9n0DnIFOtyjjBpxahrwaPdgeSh
	 zb/HU6kKRbKiO3u08NjILbsaLvO3UsHdOQJnWC28=
Date: Sat, 18 Apr 2026 00:48:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,yosry@kernel.org,weixugc@google.com,vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,chenridong@huawei.com,chengming.zhou@linux.dev,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-prevent-memory-cgroup-release-in-mglru.patch removed from -mm tree
Message-Id: <20260418074857.0B6F9C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mglru: prevent memory cgroup release in mglru
has been removed from the -mm tree.  Its filename was
     mm-mglru-prevent-memory-cgroup-release-in-mglru.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: mglru: prevent memory cgroup release in mglru
Date: Thu, 5 Mar 2026 19:52:32 +0800

In the near future, a folio will no longer pin its corresponding memory
cgroup.  To ensure safety, it will only be appropriate to hold the rcu
read lock or acquire a reference to the memory cgroup returned by
folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard against
the release of the memory cgroup in mglru.

This serves as a preparatory measure for the reparenting of the LRU pages.

Link: https://lore.kernel.org/9d887662a9d39c425742dd8468e3123316bccfe3.1772711148.git.zhengqi.arch@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
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

 mm/vmscan.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/mm/vmscan.c~mm-mglru-prevent-memory-cgroup-release-in-mglru
+++ a/mm/vmscan.c
@@ -3440,8 +3440,10 @@ static struct folio *get_pfn_folio(unsig
 	if (folio_nid(folio) != pgdat->node_id)
 		return NULL;
 
+	rcu_read_lock();
 	if (folio_memcg(folio) != memcg)
-		return NULL;
+		folio = NULL;
+	rcu_read_unlock();
 
 	return folio;
 }
@@ -4211,12 +4213,12 @@ bool lru_gen_look_around(struct page_vma
 	unsigned long addr = pvmw->address;
 	struct vm_area_struct *vma = pvmw->vma;
 	struct folio *folio = pfn_folio(pvmw->pfn);
-	struct mem_cgroup *memcg = folio_memcg(folio);
+	struct mem_cgroup *memcg;
 	struct pglist_data *pgdat = folio_pgdat(folio);
-	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	struct lru_gen_mm_state *mm_state = get_mm_state(lruvec);
-	DEFINE_MAX_SEQ(lruvec);
-	int gen = lru_gen_from_seq(max_seq);
+	struct lruvec *lruvec;
+	struct lru_gen_mm_state *mm_state;
+	unsigned long max_seq;
+	int gen;
 
 	lockdep_assert_held(pvmw->ptl);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
@@ -4251,6 +4253,12 @@ bool lru_gen_look_around(struct page_vma
 		}
 	}
 
+	memcg = get_mem_cgroup_from_folio(folio);
+	lruvec = mem_cgroup_lruvec(memcg, pgdat);
+	max_seq = READ_ONCE((lruvec)->lrugen.max_seq);
+	gen = lru_gen_from_seq(max_seq);
+	mm_state = get_mm_state(lruvec);
+
 	lazy_mmu_mode_enable();
 
 	pte -= (addr - start) / PAGE_SIZE;
@@ -4300,6 +4308,8 @@ bool lru_gen_look_around(struct page_vma
 	if (mm_state && suitable_to_scan(i, young))
 		update_bloom_filter(mm_state, max_seq, pvmw->pmd);
 
+	mem_cgroup_put(memcg);
+
 	return true;
 }
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


