Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CD14825CF
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865948; cv=none; b=headzhSY6TL688Cs9ZmGR+5Q6GTe/5Xy3yj+NBrFFfqFlNFQedeQCZ0jvnFO2L1g0hXgmqI9jXwqj585jqIKzf4QyED0uBiD8ak98ey9+NoUBmV3Nw0fog2VWJbSvFhsmo/zH8X48keyBInFPiGSCXUKrYYi9lcbaIIHBrxPGt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865948; c=relaxed/simple;
	bh=clVhxq1u+3cyruSHs73Fuumu+hy3r6GWFpRdTf3Zu34=;
	h=Date:To:From:Subject:Message-Id; b=pFcmmASybVuZNafArtIt6FzxdrgTxxHc7H8yfFYVKCmj/+lK4d1RVFYDfEfItqDILpzOIns9gg2EEhRaIqU40cv7MvgQ0b6E0bkan6yoPSLTPj1o23ozKIhc0oqo8Y+zhcCZlYwiGk/FNPnRiMJA+HtDnrAIThqM5ooSRfPgIsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UuPtoGaS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UuPtoGaS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094B21F000FF;
	Tue, 13 Oct 2026 04:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865947;
	bh=mBiJLlgwBZyz0iQL7qmXOPKLPqCAZXZmmEvmK4M4gKA=;
	h=Date:To:From:Subject;
	b=UuPtoGaSrpQxv/Rli3KzbnNfABLFHeXKrZczEXlS6BdBSf8tPi0oCJ7Tkeu51uDHn
	 5TQZSWx79Qa8n6DIk/EqRkai2NlF0J1FiBL+/GacSvW6KD1ZsAFaysGSKQDGwd36i0
	 txYwMGMeZzdXZEPE7ZEAzyVEu8pPXSWpsTx9NuRw=
Date: Mon, 12 Oct 2026 21:32:26 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,willy@infradead.org,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-take-a-const-folio-in-folio_memcg-and-friends.patch removed from -mm tree
Message-Id: <20261013043227.094B21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: take a const folio in folio_memcg() and friends
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-take-a-const-folio-in-folio_memcg-and-friends.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm: memcontrol: take a const folio in folio_memcg() and friends
Date: Tue, 15 Sep 2026 19:20:05 -0400

Patch series "mm: memcontrol: constify the read side of the read side of
the memcg API", v3.

The memcg accessors, lruvec helpers, and stat readers only read from the
memcg, folio, or lruvec they are given, but take non-const pointers. 
Constify them, along with the page_counter readers and the swap I/O blkg
helpers along the way.


This patch (of 11):

The folio_memcg() family only reads from the folio, and everything it
calls already takes a const folio.  Constify it, along with the page
wrappers built on top of it and get_obj_cgroup_from_folio(), which only
reads the folio's objcg.

Link: https://lore.kernel.org/20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu
Link: https://lore.kernel.org/20260915-folio_memcg-const-v3-1-c239a6010b58@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
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

 include/linux/memcontrol.h |   50 +++++++++++++++++------------------
 mm/memcontrol.c            |    8 ++---
 2 files changed, 29 insertions(+), 29 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-take-a-const-folio-in-folio_memcg-and-friends
+++ a/include/linux/memcontrol.h
@@ -410,7 +410,7 @@ static inline struct mem_cgroup *obj_cgr
  * or NULL. This function assumes that the folio is known to have a
  * proper object cgroup pointer.
  */
-static inline struct obj_cgroup *folio_objcg(struct folio *folio)
+static inline struct obj_cgroup *folio_objcg(const struct folio *folio)
 {
 	unsigned long memcg_data = folio->memcg_data;
 
@@ -448,7 +448,7 @@ static inline struct obj_cgroup *folio_o
  * Note: The caller should hold an rcu read lock or cgroup_mutex to protect
  * memcg associated with a folio from being released.
  */
-static inline struct mem_cgroup *folio_memcg(struct folio *folio)
+static inline struct mem_cgroup *folio_memcg(const struct folio *folio)
 {
 	struct obj_cgroup *objcg = folio_objcg(folio);
 
@@ -461,7 +461,7 @@ static inline struct mem_cgroup *folio_m
  *
  * Returns true if folio is charged to a memory cgroup, otherwise returns false.
  */
-static inline bool folio_memcg_charged(struct folio *folio)
+static inline bool folio_memcg_charged(const struct folio *folio)
 {
 	return folio->memcg_data != 0;
 }
@@ -481,7 +481,7 @@ static inline bool folio_memcg_charged(s
  * A caller should hold an rcu read lock to protect memcg associated with a
  * page from being released.
  */
-static inline struct mem_cgroup *folio_memcg_check(struct folio *folio)
+static inline struct mem_cgroup *folio_memcg_check(const struct folio *folio)
 {
 	/*
 	 * Because folio->memcg_data might be changed asynchronously
@@ -498,11 +498,11 @@ static inline struct mem_cgroup *folio_m
 	return obj_cgroup_memcg(objcg);
 }
 
-static inline struct mem_cgroup *page_memcg_check(struct page *page)
+static inline struct mem_cgroup *page_memcg_check(const struct page *page)
 {
 	if (PageTail(page))
 		return NULL;
-	return folio_memcg_check((struct folio *)page);
+	return folio_memcg_check((const struct folio *)page);
 }
 
 static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
@@ -527,14 +527,14 @@ retry:
  * that the folio has an associated memory cgroup. It's not safe to call
  * this function against some types of folios, e.g. slab folios.
  */
-static inline bool folio_memcg_kmem(struct folio *folio)
+static inline bool folio_memcg_kmem(const struct folio *folio)
 {
 	VM_BUG_ON_PGFLAGS(PageTail(&folio->page), &folio->page);
 	VM_BUG_ON_FOLIO(folio->memcg_data & MEMCG_DATA_OBJEXTS, folio);
 	return folio->memcg_data & MEMCG_DATA_KMEM;
 }
 
-static inline bool PageMemcgKmem(struct page *page)
+static inline bool PageMemcgKmem(const struct page *page)
 {
 	return folio_memcg_kmem(page_folio(page));
 }
@@ -777,7 +777,7 @@ struct mem_cgroup *get_mem_cgroup_from_m
 
 struct mem_cgroup *get_mem_cgroup_from_current(void);
 
-struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio);
+struct mem_cgroup *get_mem_cgroup_from_folio(const struct folio *folio);
 
 struct lruvec *folio_lruvec_lock(struct folio *folio);
 struct lruvec *folio_lruvec_lock_irq(struct folio *folio);
@@ -905,8 +905,8 @@ static inline bool mm_match_cgroup(struc
 	return match;
 }
 
-struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(struct folio *folio);
-ino_t page_cgroup_ino(struct page *page);
+struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(const struct folio *folio);
+ino_t page_cgroup_ino(const struct page *page);
 
 static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
 {
@@ -956,7 +956,7 @@ void mem_cgroup_print_oom_group(struct m
 void mod_memcg_state(struct mem_cgroup *memcg,
 		     enum memcg_stat_item idx, int val);
 
-static inline void mod_memcg_page_state(struct page *page,
+static inline void mod_memcg_page_state(const struct page *page,
 					enum memcg_stat_item idx, int val)
 {
 	struct mem_cgroup *memcg;
@@ -990,7 +990,7 @@ void mod_lruvec_kmem_state(void *p, enum
 void count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 			unsigned long count);
 
-static inline void count_memcg_folio_events(struct folio *folio,
+static inline void count_memcg_folio_events(const struct folio *folio,
 		enum vm_event_item idx, unsigned long nr)
 {
 	struct mem_cgroup *memcg;
@@ -1084,22 +1084,22 @@ static inline struct mem_cgroup *obj_cgr
 
 #define root_mem_cgroup		(NULL)
 
-static inline struct mem_cgroup *folio_memcg(struct folio *folio)
+static inline struct mem_cgroup *folio_memcg(const struct folio *folio)
 {
 	return NULL;
 }
 
-static inline bool folio_memcg_charged(struct folio *folio)
+static inline bool folio_memcg_charged(const struct folio *folio)
 {
 	return false;
 }
 
-static inline struct mem_cgroup *folio_memcg_check(struct folio *folio)
+static inline struct mem_cgroup *folio_memcg_check(const struct folio *folio)
 {
 	return NULL;
 }
 
-static inline struct mem_cgroup *page_memcg_check(struct page *page)
+static inline struct mem_cgroup *page_memcg_check(const struct page *page)
 {
 	return NULL;
 }
@@ -1109,12 +1109,12 @@ static inline struct mem_cgroup *get_mem
 	return NULL;
 }
 
-static inline bool folio_memcg_kmem(struct folio *folio)
+static inline bool folio_memcg_kmem(const struct folio *folio)
 {
 	return false;
 }
 
-static inline bool PageMemcgKmem(struct page *page)
+static inline bool PageMemcgKmem(const struct page *page)
 {
 	return false;
 }
@@ -1248,7 +1248,7 @@ static inline struct mem_cgroup *get_mem
 	return NULL;
 }
 
-static inline struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
+static inline struct mem_cgroup *get_mem_cgroup_from_folio(const struct folio *folio)
 {
 	return NULL;
 }
@@ -1406,7 +1406,7 @@ static inline void mod_memcg_state(struc
 {
 }
 
-static inline void mod_memcg_page_state(struct page *page,
+static inline void mod_memcg_page_state(const struct page *page,
 					enum memcg_stat_item idx, int val)
 {
 }
@@ -1471,7 +1471,7 @@ static inline void count_memcg_events(st
 {
 }
 
-static inline void count_memcg_folio_events(struct folio *folio,
+static inline void count_memcg_folio_events(const struct folio *folio,
 		enum vm_event_item idx, unsigned long nr)
 {
 }
@@ -1767,7 +1767,7 @@ void __memcg_kmem_uncharge_page(struct p
  * needs to be used outside of the local scope.
  */
 struct obj_cgroup *current_obj_cgroup(void);
-struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio);
+struct obj_cgroup *get_obj_cgroup_from_folio(const struct folio *folio);
 
 static inline struct obj_cgroup *get_obj_cgroup_from_current(void)
 {
@@ -1870,7 +1870,7 @@ static inline void __memcg_kmem_uncharge
 {
 }
 
-static inline struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio)
+static inline struct obj_cgroup *get_obj_cgroup_from_folio(const struct folio *folio)
 {
 	return NULL;
 }
@@ -1901,7 +1901,7 @@ static inline void count_objcg_events(st
 {
 }
 
-static inline ino_t page_cgroup_ino(struct page *page)
+static inline ino_t page_cgroup_ino(const struct page *page)
 {
 	return 0;
 }
--- a/mm/memcontrol.c~mm-memcontrol-take-a-const-folio-in-folio_memcg-and-friends
+++ a/mm/memcontrol.c
@@ -348,7 +348,7 @@ EXPORT_SYMBOL(memcg_bpf_enabled_key);
  * If memcg is bound to a traditional hierarchy, the css of root_mem_cgroup
  * is returned.
  */
-struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(struct folio *folio)
+struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(const struct folio *folio)
 {
 	struct mem_cgroup *memcg;
 
@@ -373,7 +373,7 @@ struct cgroup_subsys_state *get_mem_cgro
  * after page_cgroup_ino() returns, so it only should be used by callers that
  * do not care (such as procfs interfaces).
  */
-ino_t page_cgroup_ino(struct page *page)
+ino_t page_cgroup_ino(const struct page *page)
 {
 	struct mem_cgroup *memcg;
 	unsigned long ino = 0;
@@ -1256,7 +1256,7 @@ again:
  *
  * See folio_memcg() for folio->objcg/memcg binding rules.
  */
-struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
+struct mem_cgroup *get_mem_cgroup_from_folio(const struct folio *folio)
 {
 	struct mem_cgroup *memcg;
 
@@ -3154,7 +3154,7 @@ from_memcg:
 	return rcu_dereference_check(root_mem_cgroup->nodeinfo[nid]->objcg, 1);
 }
 
-struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio)
+struct obj_cgroup *get_obj_cgroup_from_folio(const struct folio *folio)
 {
 	struct obj_cgroup *objcg;
 
_

Patches currently in -mm which might be from tz2294@columbia.edu are


