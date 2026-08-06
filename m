Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E6C1A9FA8;
	Thu,  6 Aug 2026 06:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785997939; cv=none; b=t8J07UFWJkO1Te93tvHwaQrAgp2nAQftVaGSx/pigHfmOYb+nK0r+J48V7ATo3CAWGeRQMXMIJ19jBTTTuKViY84BGX0r3Nxjh93BPs30/TjEpp5rHyWXjx7eDkxoZ3DgTXEaDbIDbTvUPSH/5iEEue4qhHD61DPQMsJnoUmYNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785997939; c=relaxed/simple;
	bh=mpg5gA/An9DPLEuz+rX//6RHDkWXkSQPFIuq6rlCsDA=;
	h=Date:To:From:Subject:Message-Id; b=OGPkAW1jvjlFcLP6hLlV9PnPXrA881DJR0QR02n3fxYGfwnFMnzV+GumprrLLZcEGoL27tijTvTU2ZiIzS2Sq2RSiPb2RX+KiWH+sVuzuPvi2Ju70Y0s/qbo4MWDSQAb9jVkffgxg7LQkUOt+xk+swH6cLp57FDXfMd3nPLt31s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZIduuewC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZIduuewC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7BA1F000E9;
	Thu,  6 Aug 2026 06:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785997938;
	bh=BC4lGM7WjSYaSvhZDnq1CfRcStOmg1JBDWIPv2voXgk=;
	h=Date:To:From:Subject;
	b=ZIduuewCq/k6PT17qFCQm1ZCTr1mP2aKEOJ95gcpzVd6lW/HCcd6+HWPKANHNiwSI
	 M/lKWRMcIti2nzsRQbpNCLSLHSGGYwhVIeCQ0rqRBetTnltMwZZvc8mJLkfWZkQqZI
	 V7zu2FOd/QuXCjpSQdM3+88d+p13o4XmbrWeB5rI=
Date: Wed, 05 Aug 2026 23:32:17 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,karl.e.hofseth@opoint.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-keep-folios-objcg-same-as-its-node.patch added to mm-hotfixes-unstable branch
Message-Id: <20260806063218.2A7BA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: keep folio's objcg same as its node
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     memcg-keep-folios-objcg-same-as-its-node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-keep-folios-objcg-same-as-its-node.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: memcg: keep folio's objcg same as its node
Date: Wed, 5 Aug 2026 23:18:30 -0700

memcg_reparent_objcgs() has an inherent assumption that a folio's objcg is
the objcg of the folio's node.  Folio migration across nodes breaks that
assumption: the new folio simply inherits the old folio's objcg while
living on a different node.

Once the assumption is broken, the reparenting of the folio's objcg and
the reparenting of the folio's LRU list are no longer atomic. 
memcg_reparent_objcgs() handles one node per iteration and drops all the
locks in between, so the objcg gets reparented in the iteration for the
objcg's node while the LRU list gets spliced in the iteration for the
folio's node.  Any LRU operation on that folio in between resolves its
lruvec through the objcg, and thus takes the lru_lock of the wrong memcg,
not the lru_lock of the list the folio is actually on.

Fix this by selecting the objcg by folio_nid() at charge time, and by
re-deriving it for the destination node in mem_cgroup_migrate() and
mem_cgroup_replace_folio().

Link: https://lore.kernel.org/20260806061830.3294679-1-shakeel.butt@linux.dev
Reported-by: Karl Erik Hofseth <karl.e.hofseth@opoint.com>
Closes: https://lore.kernel.org/all/anMmd1ADrDVwMO6v@work/
Fixes: f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying memory cgroup for LRU folios")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

--- a/mm/memcontrol.c~memcg-keep-folios-objcg-same-as-its-node
+++ a/mm/memcontrol.c
@@ -2907,10 +2907,9 @@ struct mem_cgroup *mem_cgroup_from_virt(
 	return folio_memcg_check(virt_to_folio(p));
 }
 
-static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
+static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg,
+						      int nid)
 {
-	int nid = numa_node_id();
-
 	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
 		struct obj_cgroup *objcg = rcu_dereference(memcg->nodeinfo[nid]->objcg);
 
@@ -2921,12 +2920,13 @@ static struct obj_cgroup *__get_obj_cgro
 	return NULL;
 }
 
-static inline struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
+static inline struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg,
+							   int nid)
 {
 	struct obj_cgroup *objcg;
 
 	rcu_read_lock();
-	objcg = __get_obj_cgroup_from_memcg(memcg);
+	objcg = __get_obj_cgroup_from_memcg(memcg, nid);
 	rcu_read_unlock();
 
 	return objcg;
@@ -2970,7 +2970,7 @@ static struct obj_cgroup *current_objcg_
 
 		rcu_read_lock();
 		memcg = mem_cgroup_from_task(current);
-		objcg = __get_obj_cgroup_from_memcg(memcg);
+		objcg = __get_obj_cgroup_from_memcg(memcg, numa_node_id());
 		rcu_read_unlock();
 
 		/*
@@ -5120,7 +5120,7 @@ static int charge_memcg(struct folio *fo
 	int ret = 0;
 	struct obj_cgroup *objcg;
 
-	objcg = get_obj_cgroup_from_memcg(memcg);
+	objcg = get_obj_cgroup_from_memcg(memcg, folio_nid(folio));
 	/* Do not account at the root objcg level. */
 	if (!obj_cgroup_is_root(objcg))
 		ret = try_charge_memcg(memcg, gfp, folio_nr_pages(folio));
@@ -5354,6 +5354,7 @@ void mem_cgroup_replace_folio(struct fol
 
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
+
 	/* Force-charge the new page. The old one will be freed soon */
 	if (!obj_cgroup_is_root(objcg)) {
 		page_counter_charge(&memcg->memory, nr_pages);
@@ -5361,7 +5362,12 @@ void mem_cgroup_replace_folio(struct fol
 			page_counter_charge(&memcg->memsw, nr_pages);
 	}
 
-	obj_cgroup_get(objcg);
+	/* If replacing folio of different node, get objcg of that node. */
+	if (folio_nid(old) != folio_nid(new))
+		objcg = __get_obj_cgroup_from_memcg(memcg, folio_nid(new));
+	else
+		obj_cgroup_get(objcg);
+
 	commit_charge(new, objcg);
 	memcg1_commit_charge(new, memcg);
 	rcu_read_unlock();
@@ -5401,6 +5407,17 @@ void mem_cgroup_migrate(struct folio *ol
 	if (!objcg)
 		return;
 
+	/* If migrating to different node, get objcg of that node. */
+	if (folio_nid(old) != folio_nid(new)) {
+		struct obj_cgroup *old_objcg = objcg;
+
+		rcu_read_lock();
+		objcg = __get_obj_cgroup_from_memcg(obj_cgroup_memcg(old_objcg),
+						    folio_nid(new));
+		rcu_read_unlock();
+		obj_cgroup_put(old_objcg);
+	}
+
 	/* Transfer the charge and the objcg ref */
 	commit_charge(new, objcg);
 
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-keep-folios-objcg-same-as-its-node.patch
memcg-bypass-the-reclaim-and-oom-killer-for-dying-tasks-once-oom_reaper-is-done.patch

