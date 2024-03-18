Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881AA5645C
	for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2024 19:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710789459; cv=none; b=JTPJNcThjtN9sOOdL42fDMp8UMq0izFmgQUya5JIepMECgoprZldhA82Sjr/dNzLmkijtl+lWjCTc40kXVaUT0bYh6g4dubgdCoRUhbgwpnV9pqOlrLPuNtg8hGgyFAng8dQeR/UfstZ7U6QJXgWPi6gwKcif0Nzh4y09emB6TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710789459; c=relaxed/simple;
	bh=72na52wUllFPb8QkLmWXbNzDUh72zzfkjhQ7B8JuT/k=;
	h=Date:To:From:Subject:Message-Id; b=RVqFZ83LCRupLQf1BbngHhuVuOslXUV5hM57RCq1XPJZrHvOD/0yXFbo9UVweILwJ6rmKVt6B1xbtPB/xXTbkoHuSfEWC94FG+UkTI+J5BpJIsVzE/8WD9IyrKYrW7lGdxhJ0CpQS1rXgXLchWgYhDTs79/JS5xsguR0IbEnEck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lq7eCYRl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lq7eCYRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB352C43390;
	Mon, 18 Mar 2024 19:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710789459;
	bh=72na52wUllFPb8QkLmWXbNzDUh72zzfkjhQ7B8JuT/k=;
	h=Date:To:From:Subject:From;
	b=Lq7eCYRlKdgyOpqmcLhSfogF/CPL/m40ww1fc9IsGHzr6+jIB7EL6VNewKR3I5hHk
	 fH6a9wk+RvV6ZeabniMEOaXT/ftFDoTz4Ie4L5axkgwGZhXJdgMascNNgDWzxkvZII
	 ekAYIo6mEYatcW6T1Ta0brvfnB9zzPPxL0mHcVKI=
Date: Mon, 18 Mar 2024 12:17:38 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-add-null-check-to-obj_cgroup_put.patch added to mm-unstable branch
Message-Id: <20240318191738.EB352C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: add NULL check to obj_cgroup_put()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-add-null-check-to-obj_cgroup_put.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-add-null-check-to-obj_cgroup_put.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -1593,8 +1593,7 @@ put_pool:
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

mm-memcg-add-null-check-to-obj_cgroup_put.patch

