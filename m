Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0864A3BFE43
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 17:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499240; cv=none; b=BhIWDzVqtCfYZ9DdTvIXOK6xTFlv0Px0a/Je9dYqJIVwGYbIOd65J0bOdXW6kOFSDcBFwhznzo29Zk44mR9cMANQEUf13oN8Ck93qRcpkDDxtKdsws1cWamp7wPdASYtXZeXWw+r++qc0NkWX+D6Zsco4LnEo4n3FwymW/tiHiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499240; c=relaxed/simple;
	bh=owC6evCP7s/MbLcnTi4wItrUo8pPO4UqoQLNt9Dbujc=;
	h=Date:To:From:Subject:Message-Id; b=RtSOXC4DeEUZcaIQ7osuppeS7JlSzsuG8t+a0DONTC3PUP69wk8DaFUmaZTRvhWNLRpIVKqX3zDnsF4qKQkLXXllYGUvKyyCGWaJ/ORssvyGX4BjMuTDBZjljMWkexaau/c79FL2gqgyyVqJxsMeAPxtSOxtnkFUMx13QeRLAgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b2GU6Jr4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b2GU6Jr4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C35C116D0;
	Thu, 15 Jan 2026 17:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768499239;
	bh=owC6evCP7s/MbLcnTi4wItrUo8pPO4UqoQLNt9Dbujc=;
	h=Date:To:From:Subject:From;
	b=b2GU6Jr4hLRbp3cSUrwBcVc4y6gPNfXnjwooP9yDwjh0ra9TufjBzP5FYbFRAkX3U
	 3je35d9rzA/AIUJuDKHotGl8pdm1ulaYZKjDmqkgpOGPbUH3UGKipp44Funul2j9uI
	 wpsHM8DwFMGoHs/6leuJBv+jA9UNqVUByV02fkoc=
Date: Thu, 15 Jan 2026 09:47:19 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,mkoutny@suse.com,mhocko@kernel.org,lorenzo.stoakes@oracle.com,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,david@fromorbit.com,chenridong@huawei.com,chengming.zhou@linux.dev,axelrasmussen@google.com,apais@linux.microsoft.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-prepare-for-reparenting-mglru-folios-fix.patch added to mm-new branch
Message-Id: <20260115174719.B2C35C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mglru: do not call update_lru_size() during reparenting
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-prepare-for-reparenting-mglru-folios-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-prepare-for-reparenting-mglru-folios-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
Subject: mm: mglru: do not call update_lru_size() during reparenting
Date: Thu, 15 Jan 2026 18:44:44 +0800

Only non-hierarchical lruvec_stats->state_local needs to be reparented, so
handle it in reparent_state_local(), and remove the unreasonable
update_lru_size() call in __lru_gen_reparent_memcg().

Link: https://lkml.kernel.org/r/20260115104444.85986-1-qi.zheng@linux.dev
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Allen Pais <apais@linux.microsoft.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chen Ridong <chenridong@huawei.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Imran Khan <imran.f.khan@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-prepare-for-reparenting-mglru-folios-fix
+++ a/mm/vmscan.c
@@ -4545,7 +4545,6 @@ static void __lru_gen_reparent_memcg(str
 				     int zone, int type)
 {
 	struct lru_gen_folio *child_lrugen, *parent_lrugen;
-	enum lru_list lru = type * LRU_INACTIVE_FILE;
 	int i;
 
 	child_lrugen = &child_lruvec->lrugen;
@@ -4554,7 +4553,6 @@ static void __lru_gen_reparent_memcg(str
 	for (i = 0; i < get_nr_gens(child_lruvec, type); i++) {
 		int gen = lru_gen_from_seq(child_lrugen->max_seq - i);
 		long nr_pages = child_lrugen->nr_pages[gen][type][zone];
-		int dst_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;
 
 		/* Assuming that child pages are colder than parent pages */
 		list_splice_init(&child_lrugen->folios[gen][type][zone],
@@ -4563,8 +4561,6 @@ static void __lru_gen_reparent_memcg(str
 		WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
 		WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
 			   parent_lrugen->nr_pages[gen][type][zone] + nr_pages);
-
-		update_lru_size(parent_lruvec, lru + dst_lru_active, zone, nr_pages);
 	}
 }
 
@@ -4576,15 +4572,21 @@ void lru_gen_reparent_memcg(struct mem_c
 		struct lruvec *child_lruvec, *parent_lruvec;
 		int type, zid;
 		struct zone *zone;
+		enum lru_list lru;
 
 		child_lruvec = get_lruvec(memcg, nid);
 		parent_lruvec = get_lruvec(parent, nid);
 
-		for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1) {
+		for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1)
 			for (type = 0; type < ANON_AND_FILE; type++)
 				__lru_gen_reparent_memcg(child_lruvec, parent_lruvec, zid, type);
-			mem_cgroup_update_lru_size(parent_lruvec, LRU_UNEVICTABLE, zid,
-				mem_cgroup_get_zone_lru_size(child_lruvec, LRU_UNEVICTABLE, zid));
+
+		for_each_lru(lru) {
+			for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1) {
+				unsigned long size = mem_cgroup_get_zone_lru_size(child_lruvec, lru, zid);
+
+				mem_cgroup_update_lru_size(parent_lruvec, lru, zid, size);
+			}
 		}
 	}
 }
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-change-mm-pt_reclaimc-to-use-asm-tlbh-instead-of-asm-generic-tlbh.patch
alpha-mm-enable-mmu_gather_rcu_table_free.patch
loongarch-mm-enable-mmu_gather_rcu_table_free.patch
mips-mm-enable-mmu_gather_rcu_table_free.patch
parisc-mm-enable-mmu_gather_rcu_table_free.patch
um-mm-enable-mmu_gather_rcu_table_free.patch
mm-make-pt_reclaim-depends-on-mmu_gather_rcu_table_free.patch
mm-vmscan-prepare-for-the-refactoring-the-move_folios_to_lru.patch
mm-thp-prevent-memory-cgroup-release-in-folio_split_queue_lock_irqsave.patch
mm-zswap-prevent-memory-cgroup-release-in-zswap_compress.patch
mm-do-not-open-code-lruvec-lock.patch
mm-vmscan-prepare-for-reparenting-traditional-lru-folios.patch
mm-vmscan-prepare-for-reparenting-mglru-folios.patch
mm-vmscan-prepare-for-reparenting-mglru-folios-fix.patch
mm-memcontrol-refactor-memcg_reparent_objcgs.patch
mm-memcontrol-prepare-for-reparenting-state_local.patch
mm-memcontrol-prepare-for-reparenting-state_local-fix.patch
mm-memcontrol-prepare-for-reparenting-state_local-fix-2.patch

