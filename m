Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4764825B8
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865956; cv=none; b=ZK+oxHceUGLXY0m+PrgMRf8GOKJbcWhmG+7f4mVWFnzMQyng3MbPNN8QvJm4AcWyv4HXuT8pF1Y3BT0KHiTYITiVuunK3Gt1FUbp055R2ShG7eAcdAFDaXd7GvVmKaja7TWnUAkKQdMkmNwwcLvZ5m56N0cSIfuuevCLz81Z/08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865956; c=relaxed/simple;
	bh=pm2M0zZWI4D8X2KNXJHAilvQ48ZSeIGNJ6gaJvFjaJQ=;
	h=Date:To:From:Subject:Message-Id; b=noh08Y+5ualEG+65Jc88x3jvsTGEfbzbgyVpD3tTsggKOQcG7fm5wtfS/D0sWCq0HHJ/lyT+tEd6Ugx09a0TJUwuiy6QezvtqN66W4ppwCT63eSrI94ivRTNcxIPKx6+yaFENewOaZiwrPjvj9lWxVf3Hjh9o+U3QxNiGJWx/Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jzT8vCx8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jzT8vCx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6631E1F000FF;
	Tue, 13 Oct 2026 04:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865955;
	bh=V8MrrCYDPaBJGc27lOuB0BGyu2CyFBtaKHo3MsQcSSg=;
	h=Date:To:From:Subject;
	b=jzT8vCx8kBOZJDUOIliUy5fdF9RwCOnNhZvGQQNAb02ydMBPoEG44P0okdLXyUTkd
	 2bWDVMY2S51FAyoM7OP068KHYxAnxZkEhktzfXsya2gRxyiNy7QXkRF6xyRyCWxWO9
	 L2Nspqb4c/PlZMlJcaIca0eB/fruLy5m7I9EBJYE=
Date: Mon, 12 Oct 2026 21:32:35 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,willy@infradead.org,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-constify-the-swap-accounting-helpers.patch removed from -mm tree
Message-Id: <20261013043235.6631E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: constify the swap accounting helpers
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-constify-the-swap-accounting-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm: memcontrol: constify the swap accounting helpers
Date: Tue, 15 Sep 2026 19:20:13 -0400

mem_cgroup_get_nr_swap_pages(), mem_cgroup_get_folio_swap_margin(), and
mem_cgroup_swap_full() only read swap counters and limits.  Constify them.

Remove externs from function declarations while at it.

Link: https://lore.kernel.org/20260915-folio_memcg-const-v3-9-c239a6010b58@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
---

 include/linux/swap.h |   12 ++++++------
 mm/memcontrol.c      |    6 +++---
 2 files changed, 9 insertions(+), 9 deletions(-)

--- a/include/linux/swap.h~mm-memcontrol-constify-the-swap-accounting-helpers
+++ a/include/linux/swap.h
@@ -527,9 +527,9 @@ static inline void mem_cgroup_uncharge_s
 	__mem_cgroup_uncharge_swap(id, nr_pages);
 }
 
-long mem_cgroup_get_folio_swap_margin(struct folio *folio);
-extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
-extern bool mem_cgroup_swap_full(struct folio *folio);
+long mem_cgroup_get_folio_swap_margin(const struct folio *folio);
+long mem_cgroup_get_nr_swap_pages(const struct mem_cgroup *memcg);
+bool mem_cgroup_swap_full(const struct folio *folio);
 #else
 static inline int mem_cgroup_try_charge_swap(struct folio *folio)
 {
@@ -541,17 +541,17 @@ static inline void mem_cgroup_uncharge_s
 {
 }
 
-static inline long mem_cgroup_get_folio_swap_margin(struct folio *folio)
+static inline long mem_cgroup_get_folio_swap_margin(const struct folio *folio)
 {
 	return PAGE_COUNTER_MAX;
 }
 
-static inline long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
+static inline long mem_cgroup_get_nr_swap_pages(const struct mem_cgroup *memcg)
 {
 	return get_nr_swap_pages();
 }
 
-static inline bool mem_cgroup_swap_full(struct folio *folio)
+static inline bool mem_cgroup_swap_full(const struct folio *folio)
 {
 	return vm_swap_full();
 }
--- a/mm/memcontrol.c~mm-memcontrol-constify-the-swap-accounting-helpers
+++ a/mm/memcontrol.c
@@ -6017,7 +6017,7 @@ void __mem_cgroup_uncharge_swap(unsigned
 	rcu_read_unlock();
 }
 
-long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
+long mem_cgroup_get_nr_swap_pages(const struct mem_cgroup *memcg)
 {
 	long nr_swap_pages = get_nr_swap_pages();
 
@@ -6033,7 +6033,7 @@ long mem_cgroup_get_nr_swap_pages(struct
  *
  * Return: Remaining chargeable pages in the folio's memcg hierarchy.
  */
-long mem_cgroup_get_folio_swap_margin(struct folio *folio)
+long mem_cgroup_get_folio_swap_margin(const struct folio *folio)
 {
 	struct mem_cgroup *memcg;
 	long margin;
@@ -6050,7 +6050,7 @@ long mem_cgroup_get_folio_swap_margin(st
 	return margin;
 }
 
-bool mem_cgroup_swap_full(struct folio *folio)
+bool mem_cgroup_swap_full(const struct folio *folio)
 {
 	struct mem_cgroup *memcg;
 	bool ret = false;
_

Patches currently in -mm which might be from tz2294@columbia.edu are


