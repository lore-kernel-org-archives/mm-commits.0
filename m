Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2801E98EF
	for <mm-commits@vger.kernel.org>; Sat,  5 Sep 2026 23:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788651281; cv=none; b=kkV5pS5NxxZCSYNEQ6FJbBrciCSknBIK1yLpE6He1/iWE3uClyb222u+e1pvYnyUEHUbtpmKtKR8wiUqtP6sN3BFkULGjDcVTtaI9uDlRHq3kOxzB7JZgbP6tb0LR5SVJARiML3ppQT8d+fNIyc3uQCVeLFSz+38czMriP296LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788651281; c=relaxed/simple;
	bh=DAx+kFPjW0uZFtuVf3v6TYsCS7TY4PntSE2MOKAKBjs=;
	h=Date:To:From:Subject:Message-Id; b=i/9lq5ncOizrZie1WreG+nX6EnTJVLOnEGxYijOWB7PTJhnfB9ioGmTP/tEJsk4wQYiH0ZoQqyM4dTf99phE2kkQEBMoaocTyIMep28FJiOuQyruhWwJleUS17/6qStH6lFSChQeHhzL6GtMEqS4TqNGROCLctoYkTzdWUPF9Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=to+Z0Px3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="to+Z0Px3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221C71F00A3A;
	Sat,  5 Sep 2026 23:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788651280;
	bh=k0+aUKaG1RVD9QiGHTQoji8rAG47Iq63o2A+Gc3tdEM=;
	h=Date:To:From:Subject;
	b=to+Z0Px3BjbojrpUgHeqTmsazz3rJsu64i2iHQ+U83QsIGzp3Jh9uEJp6u8aH4uU4
	 Zx2jlIrKRGMQYcvkAHW3JUzu75MXVB3KbcZvfn5yGPYc+dSs6jQv2sKiA3TF7HHlc0
	 lAG0kCRNJYbaJeak/3RxzWbZ7syN9T1k6R6W2uqM=
Date: Sat, 05 Sep 2026 16:34:39 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-split-mem_cgroup_private_id-into-two-fields.patch added to mm-new branch
Message-Id: <20260905233440.221C71F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: split mem_cgroup_private_id into two fields
has been added to the -mm mm-new branch.  Its filename is
     memcg-split-mem_cgroup_private_id-into-two-fields.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-split-mem_cgroup_private_id-into-two-fields.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: split mem_cgroup_private_id into two fields
Date: Fri, 4 Sep 2026 20:05:18 -0700

The two members of struct mem_cgroup_private_id have different access
patterns.  The id is read on every eviction and refault through
mem_cgroup_private_id(), and is only written when the memcg is created and
destroyed.  The ref is written on every swap charge and uncharge.

Split them into private_id and private_id_ref so a later patch can put
them into different cache line groups.  A struct member cannot be split
across two groups.

No functional change.

Link: https://lore.kernel.org/20260905030522.1887837-3-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   10 +++-------
 mm/memcontrol.c            |   18 +++++++++---------
 2 files changed, 12 insertions(+), 16 deletions(-)

--- a/include/linux/memcontrol.h~memcg-split-mem_cgroup_private_id-into-two-fields
+++ a/include/linux/memcontrol.h
@@ -66,11 +66,6 @@ struct mem_cgroup_reclaim_cookie {
 
 #define MEM_CGROUP_ID_SHIFT	16
 
-struct mem_cgroup_private_id {
-	int id;
-	refcount_t ref;
-};
-
 struct memcg_vmstats_percpu;
 struct memcg1_events_percpu;
 struct memcg_vmstats;
@@ -189,7 +184,8 @@ struct mem_cgroup {
 	struct cgroup_subsys_state css;
 
 	/* Private memcg ID. Used to ID objects that outlive the cgroup */
-	struct mem_cgroup_private_id id;
+	int private_id;
+	refcount_t private_id_ref;
 
 	/* Accounted resources */
 	struct page_counter memory;		/* Both v1 & v2 */
@@ -810,7 +806,7 @@ static inline unsigned short mem_cgroup_
 	if (mem_cgroup_disabled())
 		return 0;
 
-	return memcg->id.id;
+	return memcg->private_id;
 }
 struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id);
 
--- a/mm/memcontrol.c~memcg-split-mem_cgroup_private_id-into-two-fields
+++ a/mm/memcontrol.c
@@ -3773,7 +3773,7 @@ static void memcg_online_kmem(struct mem
 
 	static_branch_enable(&memcg_kmem_online_key);
 
-	memcg->kmemcg_id = memcg->id.id;
+	memcg->kmemcg_id = memcg->private_id;
 }
 
 static void memcg_offline_kmem(struct mem_cgroup *memcg)
@@ -4032,15 +4032,15 @@ static DEFINE_XARRAY_ALLOC1(mem_cgroup_p
 
 static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
 {
-	if (memcg->id.id > 0) {
-		xa_erase(&mem_cgroup_private_ids, memcg->id.id);
-		memcg->id.id = 0;
+	if (memcg->private_id > 0) {
+		xa_erase(&mem_cgroup_private_ids, memcg->private_id);
+		memcg->private_id = 0;
 	}
 }
 
 static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
 {
-	if (refcount_sub_and_test(n, &memcg->id.ref)) {
+	if (refcount_sub_and_test(n, &memcg->private_id_ref)) {
 		mem_cgroup_private_id_remove(memcg);
 
 		/* Memcg ID pins CSS */
@@ -4050,7 +4050,7 @@ static inline void mem_cgroup_private_id
 
 struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
 {
-	while (!refcount_add_not_zero(n, &memcg->id.ref)) {
+	while (!refcount_add_not_zero(n, &memcg->private_id_ref)) {
 		/*
 		 * The root cgroup cannot be destroyed, so it's refcount must
 		 * always be >= 1.
@@ -4174,7 +4174,7 @@ static struct mem_cgroup *mem_cgroup_all
 	if (!memcg)
 		return ERR_PTR(-ENOMEM);
 
-	error = xa_alloc(&mem_cgroup_private_ids, &memcg->id.id, NULL,
+	error = xa_alloc(&mem_cgroup_private_ids, &memcg->private_id, NULL,
 			 XA_LIMIT(1, MEM_CGROUP_ID_MAX), GFP_KERNEL);
 	if (error)
 		goto fail;
@@ -4320,7 +4320,7 @@ static int mem_cgroup_css_online(struct
 	lru_gen_online_memcg(memcg);
 
 	/* Online state pins memcg ID, memcg ID pins CSS */
-	refcount_set(&memcg->id.ref, 1);
+	refcount_set(&memcg->private_id_ref, 1);
 	css_get(css);
 
 	/*
@@ -4333,7 +4333,7 @@ static int mem_cgroup_css_online(struct
 	 * publish it here at the end of onlining. This matches the
 	 * regular ID destruction during offlining.
 	 */
-	xa_store(&mem_cgroup_private_ids, memcg->id.id, memcg, GFP_KERNEL);
+	xa_store(&mem_cgroup_private_ids, memcg->private_id, memcg, GFP_KERNEL);
 
 	return 0;
 free_objcg:
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-clear-flushing_cached_charge-on-cpu-offline.patch
memcg-trim-the-per-cpu-charge-stock-instead-of-draining-it.patch
memcg-remove-v1-soft-limit-reclaim.patch
memcg-remove-mem_cgroup_shrink_node.patch
memcg-remove-the-soft-limit-reclaim-tracepoints.patch
memcg-remove-the-soft-limit-rbtree.patch
memcg-remove-lru_gen_soft_reclaim.patch
memcg-remove-the-per-node-soft-limit-tree-fields.patch
memcg-remove-mem_cgroup-soft_limit.patch
memcg-simplify-v1-event-ratelimiting.patch
memcg-move-per-node-objcg-to-the-read-mostly-fields.patch
memcg-split-mem_cgroup_private_id-into-two-fields.patch
memcg-group-the-write-hot-fields-of-struct-mem_cgroup.patch
memcg-group-the-cold-fields-of-struct-mem_cgroup.patch
memcg-group-the-read-mostly-fields-of-struct-mem_cgroup.patch
memcg-group-the-fields-of-struct-mem_cgroup_per_node.patch

