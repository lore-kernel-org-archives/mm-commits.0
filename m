Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6C71D5CD1
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498632; cv=none; b=fIDCuLc403kd/JfMNBRkpQSgS0QyjUGqsuF1VR+zHwn4Eg/kMG3XLhK9KWYTDP7SDMmQpFDyCeC4Vad+8d8+gx7gAKWo6FVapY5uHacjp2Dmr6+m7oLfg1wmNeW3EviCpCoVGnY9JQj0LaWnjz5FrlB0dRDtsNWUdR233zvpqog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498632; c=relaxed/simple;
	bh=wZw3qPdO7dvsgZM43TBuz5EuxhDfl5SNCbQOww1twjU=;
	h=Date:To:From:Subject:Message-Id; b=ok2XrVoIAPTURqYcqFJkO5vrMbIAvAOWe4WJ8EVi/Af+DZQ6RmzrzfL3oMVTW/oHFTrMN6EB7Yx0YVURnXL3G4031kAKm7F+Rd6hI3Z2fhCSAonipNVAXlLKFsy78SR6c+2ydst+CAgPYVO/P/BUI3RojNMohgwK3rjoArgbKHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DQ8nKji+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DQ8nKji+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDF0C19424;
	Sat, 18 Apr 2026 07:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498631;
	bh=wZw3qPdO7dvsgZM43TBuz5EuxhDfl5SNCbQOww1twjU=;
	h=Date:To:From:Subject:From;
	b=DQ8nKji+HzykxbbjoZwXjza16nejuBtvsAawoR6Egq5fYKiQzvoBMI5TexQqH/fv9
	 nHKd2wb5J9qoNyEWQ55RPX0yIPTfzv8agONVbn2h/6RWUe/ElCIn5FWYwI+YfzD/na
	 OKu47umid8or1UptccKoHeu8q9X3I5TcoH9iWe8c=
Date: Sat, 18 Apr 2026 00:50:26 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,yosry@kernel.org,weixugc@google.com,vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,songmuchun@bytedance.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,chenridong@huawei.com,chengming.zhou@linux.dev,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-workingset-use-lruvec_lru_size-to-get-the-number-of-lru-pages.patch removed from -mm tree
Message-Id: <20260418075030.4EDF0C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: workingset: use lruvec_lru_size() to get the number of lru pages
has been removed from the -mm tree.  Its filename was
     mm-workingset-use-lruvec_lru_size-to-get-the-number-of-lru-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: workingset: use lruvec_lru_size() to get the number of lru pages
Date: Thu, 5 Mar 2026 19:52:46 +0800

For cgroup v2, count_shadow_nodes() is the only place to read
non-hierarchical stats (lruvec_stats->state_local).  To avoid the need to
consider cgroup v2 during subsequent non-hierarchical stats reparenting,
use lruvec_lru_size() instead of lruvec_page_state_local() to get the
number of lru pages.

For NR_SLAB_RECLAIMABLE_B and NR_SLAB_UNRECLAIMABLE_B cases, it appears
that the statistics here have already been problematic for a while since
slab pages have been reparented.  So just ignore it for now.

Link: https://lore.kernel.org/b1d448c667a8fb377c3390d9aba43bdb7e4d5739.1772711148.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
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
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
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

 include/linux/swap.h |    1 +
 mm/vmscan.c          |    3 +--
 mm/workingset.c      |    5 +++--
 3 files changed, 5 insertions(+), 4 deletions(-)

--- a/include/linux/swap.h~mm-workingset-use-lruvec_lru_size-to-get-the-number-of-lru-pages
+++ a/include/linux/swap.h
@@ -352,6 +352,7 @@ extern void swap_setup(void);
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
+unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone_idx);
 
 #define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
 #define MEMCG_RECLAIM_PROACTIVE (1 << 2)
--- a/mm/vmscan.c~mm-workingset-use-lruvec_lru_size-to-get-the-number-of-lru-pages
+++ a/mm/vmscan.c
@@ -390,8 +390,7 @@ unsigned long zone_reclaimable_pages(str
  * @lru: lru to use
  * @zone_idx: zones to consider (use MAX_NR_ZONES - 1 for the whole LRU list)
  */
-static unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru,
-				     int zone_idx)
+unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone_idx)
 {
 	unsigned long size = 0;
 	int zid;
--- a/mm/workingset.c~mm-workingset-use-lruvec_lru_size-to-get-the-number-of-lru-pages
+++ a/mm/workingset.c
@@ -691,9 +691,10 @@ static unsigned long count_shadow_nodes(
 
 		mem_cgroup_flush_stats_ratelimited(sc->memcg);
 		lruvec = mem_cgroup_lruvec(sc->memcg, NODE_DATA(sc->nid));
+
 		for (pages = 0, i = 0; i < NR_LRU_LISTS; i++)
-			pages += lruvec_page_state_local(lruvec,
-							 NR_LRU_BASE + i);
+			pages += lruvec_lru_size(lruvec, i, MAX_NR_ZONES - 1);
+
 		pages += lruvec_page_state_local(
 			lruvec, NR_SLAB_RECLAIMABLE_B) >> PAGE_SHIFT;
 		pages += lruvec_page_state_local(
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


