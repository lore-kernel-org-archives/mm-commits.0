From: akpm@linux-foundation.org
Subject: [merged] cgroup-remove-css_get_next.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:47:06 -0700
Message-ID: <20130430184706.856D75A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:42263 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932778Ab3D3SrI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:47:08 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so86346qad.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:47:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, glommer@parallels.com, hannes@cmpxchg.org, htejun@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: remove css_get_next
has been removed from the -mm tree.  Its filename was
     cgroup-remove-css_get_next.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: cgroup: remove css_get_next

Now that we have generic and well ordered cgroup tree walkers there is
no need to keep css_get_next in the place.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ying Han <yinghan@google.com>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    7 -----
 kernel/cgroup.c        |   49 ---------------------------------------
 2 files changed, 56 deletions(-)

diff -puN include/linux/cgroup.h~cgroup-remove-css_get_next include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroup-remove-css_get_next
+++ a/include/linux/cgroup.h
@@ -687,13 +687,6 @@ void free_css_id(struct cgroup_subsys *s
 
 struct cgroup_subsys_state *css_lookup(struct cgroup_subsys *ss, int id);
 
-/*
- * Get a cgroup whose id is greater than or equal to id under tree of root.
- * Returning a cgroup_subsys_state or NULL.
- */
-struct cgroup_subsys_state *css_get_next(struct cgroup_subsys *ss, int id,
-		struct cgroup_subsys_state *root, int *foundid);
-
 /* Returns true if root is ancestor of cg */
 bool css_is_ancestor(struct cgroup_subsys_state *cg,
 		     const struct cgroup_subsys_state *root);
diff -puN kernel/cgroup.c~cgroup-remove-css_get_next kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-remove-css_get_next
+++ a/kernel/cgroup.c
@@ -5416,55 +5416,6 @@ struct cgroup_subsys_state *css_lookup(s
 }
 EXPORT_SYMBOL_GPL(css_lookup);
 
-/**
- * css_get_next - lookup next cgroup under specified hierarchy.
- * @ss: pointer to subsystem
- * @id: current position of iteration.
- * @root: pointer to css. search tree under this.
- * @foundid: position of found object.
- *
- * Search next css under the specified hierarchy of rootid. Calling under
- * rcu_read_lock() is necessary. Returns NULL if it reaches the end.
- */
-struct cgroup_subsys_state *
-css_get_next(struct cgroup_subsys *ss, int id,
-	     struct cgroup_subsys_state *root, int *foundid)
-{
-	struct cgroup_subsys_state *ret = NULL;
-	struct css_id *tmp;
-	int tmpid;
-	int rootid = css_id(root);
-	int depth = css_depth(root);
-
-	if (!rootid)
-		return NULL;
-
-	BUG_ON(!ss->use_id);
-	WARN_ON_ONCE(!rcu_read_lock_held());
-
-	/* fill start point for scan */
-	tmpid = id;
-	while (1) {
-		/*
-		 * scan next entry from bitmap(tree), tmpid is updated after
-		 * idr_get_next().
-		 */
-		tmp = idr_get_next(&ss->idr, &tmpid);
-		if (!tmp)
-			break;
-		if (tmp->depth >= depth && tmp->stack[depth] == rootid) {
-			ret = rcu_dereference(tmp->css);
-			if (ret) {
-				*foundid = tmpid;
-				break;
-			}
-		}
-		/* continue to scan from next id */
-		tmpid = tmpid + 1;
-	}
-	return ret;
-}
