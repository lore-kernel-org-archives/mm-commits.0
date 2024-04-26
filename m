Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2BD7603F
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103842; cv=none; b=jCTPGaKYtRUwBU0m7df57cNcFqrO/f4EAYyujBycQa64b4F1PdVdpn+WKpIojOb8ljkUhBqrAucIwCBVWykPdFEcg3RD5kISwE06YTFEJbHFs4kmpWne4FFJyrBRaI5j0HesuQLBDWyaVvxnpxJAdRtXZHiO6miQMuv6Ij5L9Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103842; c=relaxed/simple;
	bh=+hB6CxsDa2THc7FR+BR3Ce6+NoWMKCF2sZms8xI8sHI=;
	h=Date:To:From:Subject:Message-Id; b=luYG7hQSCqUqaAjGhCQ6cGN6xqcefyBOUfUOSNyPTJlRhKIcEd1/13RNY1x8k9zWkriVpd/d+N4+q3V3Ln9GMDaLh99UvWhUWX/hhcty6Y2zfvL9S039G8Ozkrjr92Z7YADdhDKpatlnGljo5w6v2uNGRwNqJcTDtwOgnCU+FHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ht+q0PUh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ht+q0PUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96F0C116B1;
	Fri, 26 Apr 2024 03:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103841;
	bh=+hB6CxsDa2THc7FR+BR3Ce6+NoWMKCF2sZms8xI8sHI=;
	h=Date:To:From:Subject:From;
	b=Ht+q0PUhl0MmI8OyC8l9tO7sTxaJk9WAIDHYMXd8H2blJWNKCx+GzV8mklKZ/zK6U
	 GDs3t8hUd29aR0S1splj/JPmf/WbaCYcmAGsRO72B/WbFlj7Py4vPzZ0puwBFIzWo2
	 3bjk1PCgrcjNJMQ7BT/Dqgdug4/NtSSu8dgGWnCc=
Date: Thu, 25 Apr 2024 20:57:21 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-add-null-check-to-obj_cgroup_put.patch removed from -mm tree
Message-Id: <20240426035721.B96F0C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: add NULL check to obj_cgroup_put()
has been removed from the -mm tree.  Its filename was
     mm-memcg-add-null-check-to-obj_cgroup_put.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: memcg: add NULL check to obj_cgroup_put()
Date: Sat, 16 Mar 2024 01:58:03 +0000

9 out of 16 callers perform a NULL check before calling obj_cgroup_put(). 
Move the NULL check in the function, similar to mem_cgroup_put().  The
unlikely() NULL check in current_objcg_update() was left alone to avoid
dropping the unlikey() annotation as this a fast path.

Link: https://lkml.kernel.org/r/20240316015803.2777252-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    3 ++-
 kernel/bpf/memalloc.c      |    6 ++----
 mm/memcontrol.c            |   18 ++++++------------
 mm/zswap.c                 |    3 +--
 4 files changed, 11 insertions(+), 19 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-add-null-check-to-obj_cgroup_put
+++ a/include/linux/memcontrol.h
@@ -818,7 +818,8 @@ static inline void obj_cgroup_get_many(s
 
 static inline void obj_cgroup_put(struct obj_cgroup *objcg)
 {
-	percpu_ref_put(&objcg->refcnt);
+	if (objcg)
+		percpu_ref_put(&objcg->refcnt);
 }
 
 static inline bool mem_cgroup_tryget(struct mem_cgroup *memcg)
--- a/kernel/bpf/memalloc.c~mm-memcg-add-null-check-to-obj_cgroup_put
+++ a/kernel/bpf/memalloc.c
@@ -759,8 +759,7 @@ void bpf_mem_alloc_destroy(struct bpf_me
 			rcu_in_progress += atomic_read(&c->call_rcu_ttrace_in_progress);
 			rcu_in_progress += atomic_read(&c->call_rcu_in_progress);
 		}
-		if (ma->objcg)
-			obj_cgroup_put(ma->objcg);
+		obj_cgroup_put(ma->objcg);
 		destroy_mem_alloc(ma, rcu_in_progress);
 	}
 	if (ma->caches) {
@@ -776,8 +775,7 @@ void bpf_mem_alloc_destroy(struct bpf_me
 				rcu_in_progress += atomic_read(&c->call_rcu_in_progress);
 			}
 		}
-		if (ma->objcg)
-			obj_cgroup_put(ma->objcg);
+		obj_cgroup_put(ma->objcg);
 		destroy_mem_alloc(ma, rcu_in_progress);
 	}
 }
--- a/mm/memcontrol.c~mm-memcg-add-null-check-to-obj_cgroup_put
+++ a/mm/memcontrol.c
@@ -2369,8 +2369,7 @@ static void drain_local_stock(struct wor
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
 
 	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
-	if (old)
-		obj_cgroup_put(old);
+	obj_cgroup_put(old);
 }
 
 /*
@@ -3145,8 +3144,7 @@ static struct obj_cgroup *current_objcg_
 		if (old) {
 			old = (struct obj_cgroup *)
 				((unsigned long)old & ~CURRENT_OBJCG_UPDATE_FLAG);
-			if (old)
-				obj_cgroup_put(old);
+			obj_cgroup_put(old);
 
 			old = NULL;
 		}
@@ -3418,8 +3416,7 @@ void mod_objcg_state(struct obj_cgroup *
 		mod_objcg_mlstate(objcg, pgdat, idx, nr);
 
 	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
-	if (old)
-		obj_cgroup_put(old);
+	obj_cgroup_put(old);
 }
 
 static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
@@ -3546,8 +3543,7 @@ static void refill_obj_stock(struct obj_
 	}
 
 	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
-	if (old)
-		obj_cgroup_put(old);
+	obj_cgroup_put(old);
 
 	if (nr_pages)
 		obj_cgroup_uncharge_pages(objcg, nr_pages);
@@ -5468,8 +5464,7 @@ static void __mem_cgroup_free(struct mem
 {
 	int node;
 
-	if (memcg->orig_objcg)
-		obj_cgroup_put(memcg->orig_objcg);
+	obj_cgroup_put(memcg->orig_objcg);
 
 	for_each_node(node)
 		free_mem_cgroup_per_node_info(memcg, node);
@@ -6620,8 +6615,7 @@ static void mem_cgroup_exit(struct task_
 
 	objcg = (struct obj_cgroup *)
 		((unsigned long)objcg & ~CURRENT_OBJCG_UPDATE_FLAG);
-	if (objcg)
-		obj_cgroup_put(objcg);
+	obj_cgroup_put(objcg);
 
 	/*
 	 * Some kernel allocations can happen after this point,
--- a/mm/zswap.c~mm-memcg-add-null-check-to-obj_cgroup_put
+++ a/mm/zswap.c
@@ -1618,8 +1618,7 @@ put_pool:
 freepage:
 	zswap_entry_cache_free(entry);
 reject:
-	if (objcg)
-		obj_cgroup_put(objcg);
+	obj_cgroup_put(objcg);
 check_old:
 	/*
 	 * If the zswap store fails or zswap is disabled, we must invalidate the
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-zswap-always-shrink-in-zswap_store-if-zswap_pool_reached_full.patch
mm-zswap-refactor-limit-checking-from-zswap_store.patch
mm-zswap-move-more-same-filled-pages-checks-outside-of-zswap_store.patch
mm-zswap-remove-same_filled-module-params.patch
mm-zswap-remove-same_filled-module-params-fix.patch

