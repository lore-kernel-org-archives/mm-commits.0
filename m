From: akpm@linux-foundation.org
Subject: + memcg-zap-mem_cgroup_lookup.patch added to -mm tree
Date: Tue, 17 Mar 2015 15:14:06 -0700
Message-ID: <5508a72e.PqXHdDvfmh28kBuG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52263 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265AbbCQWOH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Mar 2015 18:14:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: zap mem_cgroup_lookup()
has been added to the -mm tree.  Its filename is
     memcg-zap-mem_cgroup_lookup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-zap-mem_cgroup_lookup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-zap-mem_cgroup_lookup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: zap mem_cgroup_lookup()

mem_cgroup_lookup() is a wrapper around mem_cgroup_from_id(), which checks
that id != 0 before issuing the function call.  Today, there is no point
in this additional check apart from optimization, because there is no css
with id <= 0, so that css_from_id, called by mem_cgroup_from_id, will
return NULL for any id <= 0.

Since mem_cgroup_from_id is only called from mem_cgroup_lookup, let us zap
mem_cgroup_lookup, substituting calls to it with mem_cgroup_from_id and
moving the check if id > 0 to css_from_id.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    2 +-
 mm/memcontrol.c |   24 ++++++++----------------
 2 files changed, 9 insertions(+), 17 deletions(-)

diff -puN kernel/cgroup.c~memcg-zap-mem_cgroup_lookup kernel/cgroup.c
--- a/kernel/cgroup.c~memcg-zap-mem_cgroup_lookup
+++ a/kernel/cgroup.c
@@ -5451,7 +5451,7 @@ struct cgroup_subsys_state *css_tryget_o
 struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss)
 {
 	WARN_ON_ONCE(!rcu_read_lock_held());
-	return idr_find(&ss->css_idr, id);
+	return id > 0 ? idr_find(&ss->css_idr, id) : NULL;
 }
 
 #ifdef CONFIG_CGROUP_DEBUG
diff -puN mm/memcontrol.c~memcg-zap-mem_cgroup_lookup mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-zap-mem_cgroup_lookup
+++ a/mm/memcontrol.c
@@ -460,6 +460,12 @@ static inline unsigned short mem_cgroup_
 	return memcg->css.id;
 }
 
+/*
+ * A helper function to get mem_cgroup from ID. must be called under
+ * rcu_read_lock().  The caller is responsible for calling
+ * css_tryget_online() if the mem_cgroup is used for charging. (dropping
+ * refcnt from swap can be called against removed memcg.)
+ */
 static inline struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
 {
 	struct cgroup_subsys_state *css;
@@ -2349,20 +2355,6 @@ static void cancel_charge(struct mem_cgr
 }
 
 /*
- * A helper function to get mem_cgroup from ID. must be called under
- * rcu_read_lock().  The caller is responsible for calling
- * css_tryget_online() if the mem_cgroup is used for charging. (dropping
- * refcnt from swap can be called against removed memcg.)
- */
-static struct mem_cgroup *mem_cgroup_lookup(unsigned short id)
-{
-	/* ID 0 is unused ID */
-	if (!id)
-		return NULL;
-	return mem_cgroup_from_id(id);
-}
-
-/*
  * try_get_mem_cgroup_from_page - look up page's memcg association
  * @page: the page
  *
@@ -2388,7 +2380,7 @@ struct mem_cgroup *try_get_mem_cgroup_fr
 		ent.val = page_private(page);
 		id = lookup_swap_cgroup_id(ent);
 		rcu_read_lock();
-		memcg = mem_cgroup_lookup(id);
+		memcg = mem_cgroup_from_id(id);
 		if (memcg && !css_tryget_online(&memcg->css))
 			memcg = NULL;
 		rcu_read_unlock();
@@ -5869,7 +5861,7 @@ void mem_cgroup_uncharge_swap(swp_entry_
 
 	id = swap_cgroup_record(entry, 0);
 	rcu_read_lock();
-	memcg = mem_cgroup_lookup(id);
+	memcg = mem_cgroup_from_id(id);
 	if (memcg) {
 		if (!mem_cgroup_is_root(memcg))
 			page_counter_uncharge(&memcg->memsw, 1);
_

Patches currently in -mm which might be from vdavydov@parallels.com are

mm-hotplug-fix-concurrent-memory-hot-add-deadlock.patch
ocfs2-copy-fs-uuid-to-superblock.patch
cleancache-zap-uuid-arg-of-cleancache_init_shared_fs.patch
cleancache-forbid-overriding-cleancache_ops.patch
cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems.patch
cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems-fix.patch
memcg-zap-mem_cgroup_lookup.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
linux-next.patch

