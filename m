Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FD531F985;
	Fri,  7 Aug 2026 19:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786130632; cv=none; b=TKa5If1Rn+JELhf+G5N9MsCJ6kNX/Sw76DPCzWNLCMkFBh1VjrrVoXi+otrR+21ukWx/Mg3nERm51xhOENPdCClNb47um8dTs+dhYAeo6hp+dz3qNwrYT6iWhr+V4HKrZuNDNCpWfgbSUQQTz2o9kl9TB6dhrLNrOtiSJ7xz6NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786130632; c=relaxed/simple;
	bh=m696VKaFqgLaeH1EJD0WlQkK4qujYV6BUUeKD+ZbzEA=;
	h=Date:To:From:Subject:Message-Id; b=dAiLvgKf3Qxau/NqE7Ifg5AD02FFB5KBu+Aeue/g9Tw3wlKb6X3wCTuisyoz4Mt6SwxSsbetAOCMvl4DI/qRL+P0cr06zguwKOH+IDEk5dh3Jf8b3/RMfajdLbktn0rlSrqaOIae6OE49EZ29jNzy0AngzaAVJoVarOufWT/6kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HW6EZYHD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HW6EZYHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D856F1F000E9;
	Fri,  7 Aug 2026 19:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786130631;
	bh=vpJDcCDffDabyQWi1Kpc2u93ABjDxe4rpGvYZtxAUpg=;
	h=Date:To:From:Subject;
	b=HW6EZYHDVyvPr3i3OmsXl+sGzZhwe2ca3yYZuHUwQyzPx7GPXEmPnP9ReQ+oXPbE2
	 OKe9SqvFdvB/8EzyYINZsjS6iy/oH/9EknDocacTru6hmrCeTgqs/z3uwHrt7RFWSI
	 +4vASVzVEI3gwfiGsA7PefcwxWOfZYYB9w4DOo20=
Date: Fri, 07 Aug 2026 12:23:50 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,karl.e.hofseth@opoint.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-keep-folios-objcg-same-as-its-node.patch added to mm-hotfixes-unstable branch
Message-Id: <20260807192350.D856F1F000E9@smtp.kernel.org>
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
Date: Fri, 7 Aug 2026 07:24:05 -0700

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

Link: https://lore.kernel.org/20260807142406.443516-1-shakeel.butt@linux.dev
Fixes: f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying memory cgroup for LRU folios")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: Karl Erik Hofseth <karl.e.hofseth@opoint.com>
Closes: https://lore.kernel.org/all/anMmd1ADrDVwMO6v@work/
Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  100 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 83 insertions(+), 17 deletions(-)

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
@@ -5319,6 +5319,46 @@ void __mem_cgroup_uncharge_folios(struct
 		uncharge_batch(&ug);
 }
 
+/*
+ * An LRU folio must hold the objcg belonging to its own node.
+ *
+ * memcg_reparent_objcgs() reparents a dying cgroup one node at a time: the
+ * folios on that node's LRU lists move to the parent and that node's objcg is
+ * redirected to the parent, atomically under the node's lru_lock.
+ * folio_lruvec_lock() relies on this to provide a stable folio<->lruvec
+ * binding. If a folio holds another node's objcg, its list membership and its
+ * lruvec resolution change in separate lock sections, and an LRU operation in
+ * between can re-add the folio to, and strand it on, the LRU list of a dead
+ * memcg.
+ *
+ * So when migration transfers the memcg state to a folio on another node,
+ * re-derive the objcg for the destination node. If the memcg is dying and the
+ * destination node has already been reparented, the lookup walks up to the
+ * nearest live ancestor - which is also where that node's LRU lists went.
+ *
+ * Returns the objcg to commit to @new, with a reference for the caller.
+ */
+static struct obj_cgroup *get_migration_objcg(struct folio *old,
+					      struct folio *new)
+{
+	struct obj_cgroup *old_objcg, *new_objcg;
+	int new_nid = folio_nid(new);
+
+	old_objcg = get_obj_cgroup_from_folio(old);
+
+	if (folio_nid(old) == new_nid)
+		return old_objcg;
+
+	rcu_read_lock();
+	new_objcg = __get_obj_cgroup_from_memcg(obj_cgroup_memcg(old_objcg),
+						new_nid);
+	rcu_read_unlock();
+
+	obj_cgroup_put(old_objcg);
+
+	return new_objcg;
+}
+
 /**
  * mem_cgroup_replace_folio - Charge a folio's replacement.
  * @old: Currently circulating folio.
@@ -5347,21 +5387,28 @@ void mem_cgroup_replace_folio(struct fol
 	if (folio_memcg_charged(new))
 		return;
 
-	objcg = folio_objcg(old);
-	VM_WARN_ON_ONCE_FOLIO(!objcg, old);
-	if (!objcg)
+	VM_WARN_ON_ONCE_FOLIO(!folio_objcg(old), old);
+	if (!folio_objcg(old))
 		return;
 
+	objcg = get_migration_objcg(old, new);
+
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
-	/* Force-charge the new page. The old one will be freed soon */
+
+	/*
+	 * Force-charge the new page. The old one will be freed soon.
+	 *
+	 * The rootness of the committed objcg decides whether the final
+	 * uncharge of @new goes through the page counters (see
+	 * uncharge_folio()); charge them only if the uncharge will.
+	 */
 	if (!obj_cgroup_is_root(objcg)) {
 		page_counter_charge(&memcg->memory, nr_pages);
 		if (do_memsw_account())
 			page_counter_charge(&memcg->memsw, nr_pages);
 	}
 
-	obj_cgroup_get(objcg);
 	commit_charge(new, objcg);
 	memcg1_commit_charge(new, memcg);
 	rcu_read_unlock();
@@ -5373,14 +5420,15 @@ void mem_cgroup_replace_folio(struct fol
  * @new: Replacement folio.
  *
  * Transfer the memcg data from the old folio to the new folio for migration.
- * The old folio's data info will be cleared. Note that the memory counters
- * will remain unchanged throughout the process.
+ * The old folio's data info will be cleared. The memory counters remain
+ * unchanged, unless the charge moves out of a fully reparented ancestry
+ * and has to be settled (see below).
  *
  * Both folios must be locked, @new->mapping must be set up.
  */
 void mem_cgroup_migrate(struct folio *old, struct folio *new)
 {
-	struct obj_cgroup *objcg;
+	struct obj_cgroup *objcg, *new_objcg;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(old), old);
 	VM_BUG_ON_FOLIO(!folio_test_locked(new), new);
@@ -5401,12 +5449,30 @@ void mem_cgroup_migrate(struct folio *ol
 	if (!objcg)
 		return;
 
-	/* Transfer the charge and the objcg ref */
-	commit_charge(new, objcg);
+	new_objcg = get_migration_objcg(old, new);
+
+	/*
+	 * @old was charged through a non-root objcg, so its charge is in the
+	 * page counters. If the re-derivation walked up to the root objcg -
+	 * @old's entire ancestry is dying and already reparented - the final
+	 * uncharge of @new will skip the page counters (see uncharge_folio()).
+	 * Settle them now: this is @old's eventual uncharge, moved up to the
+	 * point where its charge record ends.
+	 */
+	if (obj_cgroup_is_root(new_objcg) && !obj_cgroup_is_root(objcg)) {
+		rcu_read_lock();
+		memcg_uncharge(obj_cgroup_memcg(objcg), folio_nr_pages(old));
+		rcu_read_unlock();
+	}
+
+	commit_charge(new, new_objcg);
 
 	/* Warning should never happen, so don't worry about refcount non-0 */
 	WARN_ON_ONCE(folio_unqueue_deferred_split(old));
 	old->memcg_data = 0;
+
+	/* @new holds its own reference now, drop @old's */
+	obj_cgroup_put(objcg);
 }
 
 DEFINE_STATIC_KEY_FALSE(memcg_sockets_enabled_key);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-keep-folios-objcg-same-as-its-node.patch
memcg-bypass-the-reclaim-and-oom-killer-for-dying-tasks-once-oom_reaper-is-done.patch

