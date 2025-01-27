Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BDE82866
	for <mm-commits@vger.kernel.org>; Mon, 27 Jan 2025 23:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738020105; cv=none; b=lHlMMWagvapO8XUkOF7Uun4I0eYK0UDBKnD/mFPfRWW+iJFDkNQC4wBAzXpX+APYbrt7BdZvFlKh4aNVlYCu0HikQtUyznFq7y1Rel9TPLpnIb6JTdJs93+8D3vYogVcdep8j7/28ECUmJ5Ds6Q+Xk3zTKDKr4fMfJPX8R0ocHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738020105; c=relaxed/simple;
	bh=V+8IeZxP75XUC7ouEh4Few3GYJ9dhtkvMUCBCqp2304=;
	h=Date:To:From:Subject:Message-Id; b=Y4XDp2nQBNuNxiiJvEsCwxfny4/lpiNWJwukir7DzblI8MqtOHKdeT4KlEWNb173FNeowqL3Mecjq2XwgyLdFaP0fja4uCnzqye2b6zZI4W6+rA59HPPdJ2CyYZwzEFvZoFgvVGbn8Aal9E94wN1qIIfLsL9zLNqIF6javgy5+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZCFbQLem; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZCFbQLem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B831BC4CED2;
	Mon, 27 Jan 2025 23:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738020104;
	bh=V+8IeZxP75XUC7ouEh4Few3GYJ9dhtkvMUCBCqp2304=;
	h=Date:To:From:Subject:From;
	b=ZCFbQLemK63DSDQbI1zmRCQLuvR/HlhwF45tmZTNJk5mTSj3bJsVc0/RDAkrrcbDy
	 Er+KBbpX0JG8YtSwouvByWkwde1OHYs4MaA5owRTd4tHc4qFpSyqP/5yD1E8WP2RB1
	 kK4W1XjKqYnDLzGg66U6c8+/MA6lLOHSEROagZ0o=
Date: Mon, 27 Jan 2025 15:21:44 -0800
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-unshare-v2-only-charge-api-bits-again.patch added to mm-unstable branch
Message-Id: <20250127232144.B831BC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcontrol: unshare v2-only charge API bits again
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-unshare-v2-only-charge-api-bits-again.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-unshare-v2-only-charge-api-bits-again.patch

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
@@ -2204,8 +2204,8 @@ out:
 	css_put(&memcg->css);
 }
 
-int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
-		     unsigned int nr_pages)
+static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
+			    unsigned int nr_pages)
 {
 	unsigned int batch = max(MEMCG_CHARGE_BATCH, nr_pages);
 	int nr_retries = MAX_RECLAIM_RETRIES;
@@ -2394,6 +2394,15 @@ done_restock:
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
@@ -3380,13 +3389,13 @@ static void mem_cgroup_id_remove(struct
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

mm-memcontrol-move-memsw-charge-callbacks-to-v1.patch
mm-memcontrol-unshare-v2-only-charge-api-bits-again.patch
mm-memcontrol-move-stray-ratelimit-bits-to-v1.patch

