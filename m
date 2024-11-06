Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BA0189913
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854889; cv=none; b=OSRrXKCTapsEVOBFyKFzc8GsJp60xSSDLPdqntLf6HgjPbmweyJlWT9QB+PzDRCzfj0/HH45qAt65b0Wntd6TavK0ay0Aa7taMAYjoa8Co5uwkhq8b6pXf3dif6Shu1zQFrXflcT57mEnI1UmHZelQkXdqn3ZwUGvZKH0Wkkj2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854889; c=relaxed/simple;
	bh=SBjxEc6cb+p/xE3waVoAgtx5LzdF1OMWrGNApnScoRI=;
	h=Date:To:From:Subject:Message-Id; b=V6iqZe9WsIcre1Fu754KcswTHu1ElU1BF5JvOQk5i9dWE14qhmw5vumpigVnZNRagIdLJDDfUf5iHtRrk7kZ0pJ+lW6pKN11wW1k+Uz4ea7OyceR60flwdsI415YS04RlSumJ94HV+Rs4JwRjUp5mC0B941nC1MKbGykeji44BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SKqJK1q6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SKqJK1q6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D15CC4CECF;
	Wed,  6 Nov 2024 01:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854889;
	bh=SBjxEc6cb+p/xE3waVoAgtx5LzdF1OMWrGNApnScoRI=;
	h=Date:To:From:Subject:From;
	b=SKqJK1q6LSBfSjY9YXKnt17IkhUSxMijb3b/NeSvRaVRhlLz/Jq137GppxaQEi4jv
	 Gpql3kV0duC0e54Xmc7eIw4MvWo7dPRwewUgYyNFeV4+a8gyntQEa58RI8sdjKNqU7
	 fUF4FqN7HHRg4oqbBDjo5eiGVn0Crozh4tKnsjtE=
Date: Tue, 05 Nov 2024 17:01:29 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,songmuchun@bytedance.com,roman.gushchin@linux.dev,mhocko@suse.com,hughd@google.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-workingset-remove-folio_memcg_rcu-usage.patch removed from -mm tree
Message-Id: <20241106010129.8D15CC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: workingset: remove folio_memcg_rcu usage
has been removed from the -mm tree.  Its filename was
     memcg-workingset-remove-folio_memcg_rcu-usage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: workingset: remove folio_memcg_rcu usage
Date: Sat, 26 Oct 2024 09:37:07 -0700

The function workingset_activation() is called from folio_mark_accessed()
with the guarantee that the given folio can not be freed under us in
workingset_activation().  In addition, the association of the folio and
its memcg can not be broken here because charge migration is no more. 
There is no need to use folio_memcg_rcu.  Simply use folio_memcg_charged()
because that is what this function cares about.

[akpm@linux-foundation.org: provide folio_memcg_charged stub for CONFIG_MEMCG=n]
Link: https://lkml.kernel.org/r/20241026163707.2479526-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Suggested-by: Yu Zhao <yuzhao@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   34 ++--------------------------------
 mm/workingset.c            |   14 ++------------
 2 files changed, 4 insertions(+), 44 deletions(-)

--- a/include/linux/memcontrol.h~memcg-workingset-remove-folio_memcg_rcu-usage
+++ a/include/linux/memcontrol.h
@@ -443,35 +443,6 @@ static inline bool folio_memcg_charged(s
 	return __folio_memcg(folio) != NULL;
 }
 
-/**
- * folio_memcg_rcu - Locklessly get the memory cgroup associated with a folio.
- * @folio: Pointer to the folio.
- *
- * This function assumes that the folio is known to have a
- * proper memory cgroup pointer. It's not safe to call this function
- * against some type of folios, e.g. slab folios or ex-slab folios.
- *
- * Return: A pointer to the memory cgroup associated with the folio,
- * or NULL.
- */
-static inline struct mem_cgroup *folio_memcg_rcu(struct folio *folio)
-{
-	unsigned long memcg_data = READ_ONCE(folio->memcg_data);
-
-	VM_BUG_ON_FOLIO(folio_test_slab(folio), folio);
-
-	if (memcg_data & MEMCG_DATA_KMEM) {
-		struct obj_cgroup *objcg;
-
-		objcg = (void *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
-		return obj_cgroup_memcg(objcg);
-	}
-
-	WARN_ON_ONCE(!rcu_read_lock_held());
-
-	return (struct mem_cgroup *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
-}
-
 /*
  * folio_memcg_check - Get the memory cgroup associated with a folio.
  * @folio: Pointer to the folio.
@@ -1084,10 +1055,9 @@ static inline struct mem_cgroup *folio_m
 	return NULL;
 }
 
-static inline struct mem_cgroup *folio_memcg_rcu(struct folio *folio)
+static inline bool folio_memcg_charged(struct folio *folio)
 {
-	WARN_ON_ONCE(!rcu_read_lock_held());
-	return NULL;
+	return false;
 }
 
 static inline struct mem_cgroup *folio_memcg_check(struct folio *folio)
--- a/mm/workingset.c~memcg-workingset-remove-folio_memcg_rcu-usage
+++ a/mm/workingset.c
@@ -591,22 +591,12 @@ void workingset_refault(struct folio *fo
  */
 void workingset_activation(struct folio *folio)
 {
-	struct mem_cgroup *memcg;
-
-	rcu_read_lock();
 	/*
 	 * Filter non-memcg pages here, e.g. unmap can call
 	 * mark_page_accessed() on VDSO pages.
-	 *
-	 * XXX: See workingset_refault() - this should return
-	 * root_mem_cgroup even for !CONFIG_MEMCG.
 	 */
-	memcg = folio_memcg_rcu(folio);
-	if (!mem_cgroup_disabled() && !memcg)
-		goto out;
-	workingset_age_nonresident(folio_lruvec(folio), folio_nr_pages(folio));
-out:
-	rcu_read_unlock();
+	if (mem_cgroup_disabled() || folio_memcg_charged(folio))
+		workingset_age_nonresident(folio_lruvec(folio), folio_nr_pages(folio));
 }
 
 /*
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


