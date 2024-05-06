Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF7738F91
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957156; cv=none; b=Gc6ryehvl1G3cD3FgnBHACV2bU3nhBzupUs8y1SdRjBmiuQ7LZjdNWBG9sMg+DqcGJ/1SwwsLjO0EPAUXu4UE3R1mEF41kAYRHMHm3p5pM/hJgoC0j1wCpnw1wve0HX0Deuylm7aQn+AxbP2pR2QCiaS5vgnyPIlbuE3S8TBQVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957156; c=relaxed/simple;
	bh=4e8K3N12hpZ82WywpP6TQ1a/olVZMOsvBtn2nn+SF04=;
	h=Date:To:From:Subject:Message-Id; b=Vii5BTnlDJAgCZdXbd0//nSk9ztrHvWPAmoA7OirsXbh4LcRlJo2WU6bMxOVktJwZjjJYwAeHlg9xghTGJzGrdJIF5HpFZLi+UVTqo7yAobfXN4988fgDsayUzUSuIabufGRB8mZZY8pp0McMyFIGHxq80q4rQ0j+w+dDQrJR+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wRlVOeEV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wRlVOeEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B12C4AF18;
	Mon,  6 May 2024 00:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957156;
	bh=4e8K3N12hpZ82WywpP6TQ1a/olVZMOsvBtn2nn+SF04=;
	h=Date:To:From:Subject:From;
	b=wRlVOeEVoWud86Ui61xIhc3C7w0+84lOfbpm4bfXdJTPSxEOkgD3rtrRO6fXvvSs3
	 r3E0v1X81i5zZmwrPA8BmMGkhZ/EBVdhIbUzIS4N0NG/wMQJJiK8NOfV7oBIlzikQ1
	 FmC4kWlRYwXEClLnLoEesVr+kGtk01vBb3qiKB6I=
Date: Sun, 05 May 2024 17:59:15 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-use-proper-type-for-mod_memcg_state.patch removed from -mm tree
Message-Id: <20240506005916.73B12C4AF18@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: use proper type for mod_memcg_state
has been removed from the -mm tree.  Its filename was
     memcg-use-proper-type-for-mod_memcg_state.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: use proper type for mod_memcg_state
Date: Wed, 1 May 2024 10:26:17 -0700

The memcg stats update functions can take arbitrary integer but the only
input which make sense is enum memcg_stat_item and we don't want these
functions to be called with arbitrary integer, so replace the parameter
type with enum memcg_stat_item and compiler will be able to warn if memcg
stat update functions are called with incorrect index value.

Link: https://lkml.kernel.org/r/20240501172617.678560-9-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   13 +++++++------
 mm/memcontrol.c            |    3 ++-
 2 files changed, 9 insertions(+), 7 deletions(-)

--- a/include/linux/memcontrol.h~memcg-use-proper-type-for-mod_memcg_state
+++ a/include/linux/memcontrol.h
@@ -974,7 +974,8 @@ void mem_cgroup_print_oom_group(struct m
 void folio_memcg_lock(struct folio *folio);
 void folio_memcg_unlock(struct folio *folio);
 
-void __mod_memcg_state(struct mem_cgroup *memcg, int idx, int val);
+void __mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
+		       int val);
 
 /* try to stablize folio_memcg() for all the pages in a memcg */
 static inline bool mem_cgroup_trylock_pages(struct mem_cgroup *memcg)
@@ -995,7 +996,7 @@ static inline void mem_cgroup_unlock_pag
 
 /* idx can be of type enum memcg_stat_item or node_stat_item */
 static inline void mod_memcg_state(struct mem_cgroup *memcg,
-				   int idx, int val)
+				   enum memcg_stat_item idx, int val)
 {
 	unsigned long flags;
 
@@ -1005,7 +1006,7 @@ static inline void mod_memcg_state(struc
 }
 
 static inline void mod_memcg_page_state(struct page *page,
-					int idx, int val)
+					enum memcg_stat_item idx, int val)
 {
 	struct mem_cgroup *memcg;
 
@@ -1491,19 +1492,19 @@ static inline void mem_cgroup_print_oom_
 }
 
 static inline void __mod_memcg_state(struct mem_cgroup *memcg,
-				     int idx,
+				     enum memcg_stat_item idx,
 				     int nr)
 {
 }
 
 static inline void mod_memcg_state(struct mem_cgroup *memcg,
-				   int idx,
+				   enum memcg_stat_item idx,
 				   int nr)
 {
 }
 
 static inline void mod_memcg_page_state(struct page *page,
-					int idx, int val)
+					enum memcg_stat_item idx, int val)
 {
 }
 
--- a/mm/memcontrol.c~memcg-use-proper-type-for-mod_memcg_state
+++ a/mm/memcontrol.c
@@ -955,7 +955,8 @@ static int memcg_state_val_in_pages(int
  * @idx: the stat item - can be enum memcg_stat_item or enum node_stat_item
  * @val: delta to add to the counter, can be negative
  */
-void __mod_memcg_state(struct mem_cgroup *memcg, int idx, int val)
+void __mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
+		       int val)
 {
 	int i = memcg_stats_index(idx);
 
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


