Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349A118052
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 04:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730952834; cv=none; b=cedNmsfZNl3bMx5SsqkXcg4bpWpz+OS/BnVsYKv2pwXaizwpwf/UHwQCGDCEbPXVyXXuXQjPEfoQ+2OX0XZKaYX96YeQNJp27a8lQKqDbuUHTYLAQIC277WAJmCw9rwb0X//3+sikS9mB4Hc6nGyujH2UgAraKd4wBCiqqgKkX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730952834; c=relaxed/simple;
	bh=2GZsmvwgXG8e9nmX6yERN3ebyoFFCiLww+smaB4UYeY=;
	h=Date:To:From:Subject:Message-Id; b=dIJ1kkcCLI69w9ZHX2dRfb9WB49YkXVxAKSiAM4HjAiwH75BBLMZl/9pmfr0Jy754iARl5kjYGAGLIdJb4O/V0Mmr1aXyiFhK+qAjYNySdZJ1SOh5g2ij8M9+vyBGSwOPJiJzI2f+1pjc1eEDPyPlZI3b+jO/15ElFnZ/MZYNAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ILpZ0G17; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ILpZ0G17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C76C4CECC;
	Thu,  7 Nov 2024 04:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730952833;
	bh=2GZsmvwgXG8e9nmX6yERN3ebyoFFCiLww+smaB4UYeY=;
	h=Date:To:From:Subject:From;
	b=ILpZ0G17ypWN1rCOgLYh6vCAJVI4tkD81g7enKfUCy0uWLzIuv8i8KxrbIHIYB+nW
	 1VkEtb2y5kQWiTB7vIN8ce3u9RnJGKOpVVCCUcH8vSpc9ISPN7GobxLRn3/mm+tpRG
	 z5y3iqsVOqFy36cLpDy804b7k0BVw2+9NBMXVHQc=
Date: Wed, 06 Nov 2024 20:13:53 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,wajdi.k.feghali@intel.com,usamaarif642@gmail.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,nphamcs@gmail.com,nanhai.zou@intel.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,21cnbao@gmail.com,kanchana.p.sridhar@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-change-count_objcg_event-to-count_objcg_events-for-batch-event-updates.patch removed from -mm tree
Message-Id: <20241107041353.A4C76C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: change count_objcg_event() to count_objcg_events() for batch event updates
has been removed from the -mm tree.  Its filename was
     mm-change-count_objcg_event-to-count_objcg_events-for-batch-event-updates.patch

This patch was dropped because an alternative patch was or shall be merged

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

mm-define-obj_cgroup_get-if-config_memcg-is-not-defined.patch
mm-zswap-modify-zswap_compress-to-accept-a-page-instead-of-a-folio.patch
mm-zswap-rename-zswap_pool_get-to-zswap_pool_tryget.patch
mm-zswap-modify-zswap_stored_pages-to-be-atomic_long_t.patch
mm-zswap-support-large-folios-in-zswap_store.patch
mm-swap-count-successful-large-folio-zswap-stores-in-hugepage-zswpout-stats.patch
mm-zswap-zswap_store_page-will-initialize-entry-after-adding-to-xarray.patch

