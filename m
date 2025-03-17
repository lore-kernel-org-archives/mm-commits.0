Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE8C215043
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188174; cv=none; b=IkGI5NUaeeyYiUagwOEqOioSUsDLnYNEvCi7P0FCjfn0zxAzXEEyNHgs7f/n48gCk4LhTgmMEX/FypB9L42uhIXtLdOt8XEx3ZSCJEDoa0LzubRArIq8iTORP79H9O6K/6wLFcCQgwglWXrICAWs3EXy0Wrr7c8RYD1RNavWj+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188174; c=relaxed/simple;
	bh=rq7IISNRgUYqOjgOmU0pbSJVdGMYX5ow8Kfjs6iGm4U=;
	h=Date:To:From:Subject:Message-Id; b=nAUlBdlJSdCtqk08ERMNk6DB6Pb+tAAi+xvhcvsNnnHVdyfJbeeGVF9nb/WHCz8f+MPII1dlqWVbrhwY8Bt3dxKQdr4A5QP3mpfga5P70ThUBd4F9o2c97i+SuxKPtR4kWLXPmrVoU12P8N2rQMgAR1UORGYqPLRdSK7jNmcaGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aRfvKuBT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aRfvKuBT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01459C4CEEC;
	Mon, 17 Mar 2025 05:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188174;
	bh=rq7IISNRgUYqOjgOmU0pbSJVdGMYX5ow8Kfjs6iGm4U=;
	h=Date:To:From:Subject:From;
	b=aRfvKuBTNw3IahIkBxQx1zrLVs6s+LlfQIaa1lWZTFs0pcoqYR85AkPvSCplVaE2g
	 pT9IbYCvo9LDNWf8S9u3LTBxnnIgryU2Ffa3Hl+qidLN12sU0JqFZGEJMOFDffXg6x
	 LoRY5eDcjpVDF+4xZqJ/4nt1zRykxECOE0mYZEPg=
Date: Sun, 16 Mar 2025 22:09:33 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-unshare-v2-only-charge-api-bits-again.patch removed from -mm tree
Message-Id: <20250317050934.01459C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: unshare v2-only charge API bits again
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-unshare-v2-only-charge-api-bits-again.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: unshare v2-only charge API bits again
Date: Thu, 23 Jan 2025 23:38:58 -0500

6b611388b626 ("memcg-v1: remove charge move code") removed the remaining
v1 callers.

Link: https://lkml.kernel.org/r/20250124043859.18808-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.h |   15 ---------------
 mm/memcontrol.c    |   17 +++++++++++++----
 2 files changed, 13 insertions(+), 19 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-unshare-v2-only-charge-api-bits-again
+++ a/mm/memcontrol.c
@@ -2213,8 +2213,8 @@ out:
 	css_put(&memcg->css);
 }
 
-int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
-		     unsigned int nr_pages)
+static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
+			    unsigned int nr_pages)
 {
 	unsigned int batch = max(MEMCG_CHARGE_BATCH, nr_pages);
 	int nr_retries = MAX_RECLAIM_RETRIES;
@@ -2403,6 +2403,15 @@ done_restock:
 	return 0;
 }
 
+static inline int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
+			     unsigned int nr_pages)
+{
+	if (mem_cgroup_is_root(memcg))
+		return 0;
+
+	return try_charge_memcg(memcg, gfp_mask, nr_pages);
+}
+
 static void commit_charge(struct folio *folio, struct mem_cgroup *memcg)
 {
 	VM_BUG_ON_FOLIO(folio_memcg_charged(folio), folio);
@@ -3389,13 +3398,13 @@ static void mem_cgroup_id_remove(struct
 	}
 }
 
-void __maybe_unused mem_cgroup_id_get_many(struct mem_cgroup *memcg,
+static void __maybe_unused mem_cgroup_id_get_many(struct mem_cgroup *memcg,
 					   unsigned int n)
 {
 	refcount_add(n, &memcg->id.ref);
 }
 
-void mem_cgroup_id_put_many(struct mem_cgroup *memcg, unsigned int n)
+static void mem_cgroup_id_put_many(struct mem_cgroup *memcg, unsigned int n)
 {
 	if (refcount_sub_and_test(n, &memcg->id.ref)) {
 		mem_cgroup_id_remove(memcg);
--- a/mm/memcontrol-v1.h~mm-memcontrol-unshare-v2-only-charge-api-bits-again
+++ a/mm/memcontrol-v1.h
@@ -7,21 +7,6 @@
 
 /* Cgroup v1 and v2 common declarations */
 
-int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
-		     unsigned int nr_pages);
-
-static inline int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
-			     unsigned int nr_pages)
-{
-	if (mem_cgroup_is_root(memcg))
-		return 0;
-
-	return try_charge_memcg(memcg, gfp_mask, nr_pages);
-}
-
-void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n);
-void mem_cgroup_id_put_many(struct mem_cgroup *memcg, unsigned int n);
-
 /*
  * Iteration constructs for visiting all cgroups (under a tree).  If
  * loops are exited prematurely (break), mem_cgroup_iter_break() must
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-swap_cgroup-remove-double-initialization-of-locals.patch
mm-compaction-push-watermark-into-compaction_suitable-callers.patch
mm-page_alloc-trace-type-pollution-from-compaction-capturing.patch
mm-page_alloc-defrag_mode.patch
mm-page_alloc-defrag_mode-kswapd-kcompactd-assistance.patch
mm-page_alloc-defrag_mode-kswapd-kcompactd-watermarks.patch
mm-page_alloc-defrag_mode-kswapd-kcompactd-watermarks-fix.patch

