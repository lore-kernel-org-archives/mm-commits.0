Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A76558BC
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854750; cv=none; b=UidpWJKalF2sSmBTxc+D3RutaZ9elum8/mDypeFrApRnCkfB8sw28paoBN+dBPwZK02s0XV4Pcyln7UG+hNZTbtXhKZ0HIw2MbFk8noaQYnD2L52VLGqd66tAg/aNSqWEpD1jChcpej3blYo1OEGqH4wwrakvYMjlqPFiOSWt+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854750; c=relaxed/simple;
	bh=NXp6PcyFrIvj8r7oaa6kHZ1W2OSSgQGp+6qmbthBJqE=;
	h=Date:To:From:Subject:Message-Id; b=QQ7YKwDs3qAOPNDnnyj58bkXVcCzdg6/FuuaTmRngJQha5UpIkXttmeFz76IRLgd8zpV/9xzSprLRWrRqrprF2V2fTLp9FBDWrIgl0bEb1PKniLKxXMpjAzDmvg7/brnlo8BtKNoPA2havaGxrSBeHSEXLQXhyOEJBL3q73jOhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qV4QmWxT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qV4QmWxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0D9C4CECF;
	Wed,  6 Nov 2024 00:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854750;
	bh=NXp6PcyFrIvj8r7oaa6kHZ1W2OSSgQGp+6qmbthBJqE=;
	h=Date:To:From:Subject:From;
	b=qV4QmWxTIsRiF82Dw3g9jki2INa4KXdHu7rDTny07pRoIB47ccyTUHwZUIa+N57SN
	 TKkXUK0apYOgcMKvIB8MrApmUBThKyOe94+Wt/KVVVn+f6whwtisuBqm77RyUslOGz
	 /eKOukhkL6gACGn0VvTpa9vCF8TU9kuZLYj9bhLo=
Date: Tue, 05 Nov 2024 16:59:09 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,wajdi.k.feghali@intel.com,usamaarif642@gmail.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,nphamcs@gmail.com,nanhai.zou@intel.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,21cnbao@gmail.com,kanchana.p.sridhar@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-change-count_objcg_event-to-count_objcg_events-for-batch-event-updates.patch removed from -mm tree
Message-Id: <20241106005909.ED0D9C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: change count_objcg_event() to count_objcg_events() for batch event updates
has been removed from the -mm tree.  Its filename was
     mm-change-count_objcg_event-to-count_objcg_events-for-batch-event-updates.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Subject: mm: change count_objcg_event() to count_objcg_events() for batch event updates
Date: Mon, 30 Sep 2024 22:32:19 -0700

With the introduction of zswap_store() swapping out large folios, we need
to efficiently update the objcg's memcg events once per successfully
stored folio.  For instance, the 'ZSWPOUT' event needs to be incremented
by folio_nr_pages().

To facilitate this, the existing count_objcg_event() API is modified to be
count_objcg_events() that additionally accepts a count parameter.  The
only existing calls to count_objcg_event() are in zswap.c - these have
been modified to call count_objcg_events() with a count of 1.

Link: https://lkml.kernel.org/r/20241001053222.6944-5-kanchana.p.sridhar@intel.com
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Wajdi Feghali <wajdi.k.feghali@intel.com>
Cc: "Zou, Nanhai" <nanhai.zou@intel.com>
Cc: Barry Song <21cnbao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   12 +++++++-----
 mm/zswap.c                 |    6 +++---
 2 files changed, 10 insertions(+), 8 deletions(-)

--- a/include/linux/memcontrol.h~mm-change-count_objcg_event-to-count_objcg_events-for-batch-event-updates
+++ a/include/linux/memcontrol.h
@@ -1764,8 +1764,9 @@ static inline int memcg_kmem_id(struct m
 
 struct mem_cgroup *mem_cgroup_from_slab_obj(void *p);
 
-static inline void count_objcg_event(struct obj_cgroup *objcg,
-				     enum vm_event_item idx)
+static inline void count_objcg_events(struct obj_cgroup *objcg,
+				      enum vm_event_item idx,
+				      unsigned long count)
 {
 	struct mem_cgroup *memcg;
 
@@ -1774,7 +1775,7 @@ static inline void count_objcg_event(str
 
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
-	count_memcg_events(memcg, idx, 1);
+	count_memcg_events(memcg, idx, count);
 	rcu_read_unlock();
 }
 
@@ -1829,8 +1830,9 @@ static inline struct mem_cgroup *mem_cgr
 	return NULL;
 }
 
-static inline void count_objcg_event(struct obj_cgroup *objcg,
-				     enum vm_event_item idx)
+static inline void count_objcg_events(struct obj_cgroup *objcg,
+				      enum vm_event_item idx,
+				      unsigned long count)
 {
 }
 
--- a/mm/zswap.c~mm-change-count_objcg_event-to-count_objcg_events-for-batch-event-updates
+++ a/mm/zswap.c
@@ -1053,7 +1053,7 @@ static int zswap_writeback_entry(struct
 
 	count_vm_event(ZSWPWB);
 	if (entry->objcg)
-		count_objcg_event(entry->objcg, ZSWPWB);
+		count_objcg_events(entry->objcg, ZSWPWB, 1);
 
 	zswap_entry_free(entry);
 
@@ -1483,7 +1483,7 @@ bool zswap_store(struct folio *folio)
 
 	if (objcg) {
 		obj_cgroup_charge_zswap(objcg, entry->length);
-		count_objcg_event(objcg, ZSWPOUT);
+		count_objcg_events(objcg, ZSWPOUT, 1);
 	}
 
 	/*
@@ -1577,7 +1577,7 @@ bool zswap_load(struct folio *folio)
 
 	count_vm_event(ZSWPIN);
 	if (entry->objcg)
-		count_objcg_event(entry->objcg, ZSWPIN);
+		count_objcg_events(entry->objcg, ZSWPIN, 1);
 
 	if (swapcache) {
 		zswap_entry_free(entry);
_

Patches currently in -mm which might be from kanchana.p.sridhar@intel.com are


