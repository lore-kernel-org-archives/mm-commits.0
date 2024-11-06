Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E1318785C
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854879; cv=none; b=fZbHcvSFFm3XkZ9djDF147St0GzoSGSUnm170VkVBvyVXzDaCxgou+iBUNXMlTPAS0ZKCT3N3YWMGSnmAWajaz0zkqrpnROVtltl8tQofq0B2woC3oCp/mxtAXOwuv31eeEHjJmMo+DReXB1SDMU0tIi3BIAtgOt7JhejGqQ8gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854879; c=relaxed/simple;
	bh=EC5EkzHRiKiV+z95Bp9AV7m/2wwtNBvmxBzSFfcLN3s=;
	h=Date:To:From:Subject:Message-Id; b=Dg+Juya/G2esi0vT8oGlja9mABK1rCp+5ttAtRFHZ7XBotaJVhMxz/2kKEWlviqaDMEMXTl795ziJIKgWEz8xzeeKjYbo2H+lcG5w3K5mLT6SjJjphch+1nMiD5G+E5SqvRy2XP6IyjlfnEzbNjhTFE3S8KFk/rO4r6jPdT6ATg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eyEddau0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eyEddau0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5184C4CECF;
	Wed,  6 Nov 2024 01:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854878;
	bh=EC5EkzHRiKiV+z95Bp9AV7m/2wwtNBvmxBzSFfcLN3s=;
	h=Date:To:From:Subject:From;
	b=eyEddau0rpeLEXDR+U5I4NFFWA9r5VLoB94/U79mU+ZvLN6KoSA5bWCzLtwq1FV+i
	 M4ec4/8ZBg0P5czoCtBTBV4HdUHei9JesijLXw7Dq+BOabNTCo+OQ2diQMtbqgW7EO
	 ndja+frs1IeE2NegcuCln8CjvWF7Sp+AOOzzYxLA=
Date: Tue, 05 Nov 2024 17:01:18 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hughd@google.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-v1-no-need-for-memcg-locking-for-mglru.patch removed from -mm tree
Message-Id: <20241106010118.D5184C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg-v1: no need for memcg locking for MGLRU
has been removed from the -mm tree.  Its filename was
     memcg-v1-no-need-for-memcg-locking-for-mglru.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg-v1: no need for memcg locking for MGLRU
Date: Thu, 24 Oct 2024 18:23:02 -0700

While updating the generation of the folios, MGLRU requires that the
folio's memcg association remains stable.  With the charge migration
deprecated, there is no need for MGLRU to acquire locks to keep the folio
and memcg association stable.

[yuzhao@google.com: remove !rcu_read_lock_held() assertion]
  Link: https://lkml.kernel.org/r/ZykEtcHrQRq-KrBC@google.com
  Link: https://syzkaller.appspot.com/bug?extid=24f45b8beab9788e467e
  Link: https://lore.kernel.org/lkml/67294349.050a0220.701a.0010.GAE@google.com/
[akpm@linux-foundation.org: remove now-unused local]
[shakeel.butt@linux.dev: folio_rcu() fixup, per Yu Zhao]
  Link: https://lkml.kernel.org/r/iwmabnye3nl4merealrawt3bdvfii2pwavwrddrqpraoveet7h@ezrsdhjwwej7
Link: https://lkml.kernel.org/r/20241025012304.2473312-6-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

--- a/mm/vmscan.c~memcg-v1-no-need-for-memcg-locking-for-mglru
+++ a/mm/vmscan.c
@@ -3137,7 +3137,6 @@ static int folio_update_gen(struct folio
 	unsigned long new_flags, old_flags = READ_ONCE(folio->flags);
 
 	VM_WARN_ON_ONCE(gen >= MAX_NR_GENS);
-	VM_WARN_ON_ONCE(!rcu_read_lock_held());
 
 	do {
 		/* lru_gen_del_folio() has isolated this page? */
@@ -3353,7 +3352,7 @@ static struct folio *get_pfn_folio(unsig
 	if (folio_nid(folio) != pgdat->node_id)
 		return NULL;
 
-	if (folio_memcg_rcu(folio) != memcg)
+	if (folio_memcg(folio) != memcg)
 		return NULL;
 
 	/* file VMAs can contain anon pages from COW */
@@ -3649,10 +3648,8 @@ static void walk_mm(struct mm_struct *mm
 		.p4d_entry = walk_pud_range,
 		.walk_lock = PGWALK_RDLOCK,
 	};
-
 	int err;
 	struct lruvec *lruvec = walk->lruvec;
-	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
 	walk->next_addr = FIRST_USER_ADDRESS;
 
@@ -3665,10 +3662,6 @@ static void walk_mm(struct mm_struct *mm
 		if (walk->seq != max_seq)
 			break;
 
-		/* folio_update_gen() requires stable folio_memcg() */
-		if (!mem_cgroup_trylock_pages(memcg))
-			break;
-
 		/* the caller might be holding the lock for write */
 		if (mmap_read_trylock(mm)) {
 			err = walk_page_range(mm, walk->next_addr, ULONG_MAX, &mm_walk_ops, walk);
@@ -3676,8 +3669,6 @@ static void walk_mm(struct mm_struct *mm
 			mmap_read_unlock(mm);
 		}
 
-		mem_cgroup_unlock_pages();
-
 		if (walk->batched) {
 			spin_lock_irq(&lruvec->lru_lock);
 			reset_batch_size(walk);
@@ -4099,10 +4090,6 @@ bool lru_gen_look_around(struct page_vma
 		}
 	}
 
-	/* folio_update_gen() requires stable folio_memcg() */
-	if (!mem_cgroup_trylock_pages(memcg))
-		return true;
-
 	arch_enter_lazy_mmu_mode();
 
 	pte -= (addr - start) / PAGE_SIZE;
@@ -4147,7 +4134,6 @@ bool lru_gen_look_around(struct page_vma
 	}
 
 	arch_leave_lazy_mmu_mode();
-	mem_cgroup_unlock_pages();
 
 	/* feedback from rmap walkers to page table walkers */
 	if (mm_state && suitable_to_scan(i, young))
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


