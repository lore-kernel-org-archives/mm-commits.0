From: akpm@linux-foundation.org
Subject: [to-be-updated] cgroups-forbid-pre_destroy-callback-to-fail.patch removed from -mm tree
Date: Tue, 30 Oct 2012 13:47:58 -0700
Message-ID: <20121030204759.4D5B3100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:45256 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322Ab2J3UsB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Oct 2012 16:48:01 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so81622qae.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Oct 2012 13:48:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, bsingharora@gmail.com, glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroups: forbid pre_destroy() callback failures
has been removed from the -mm tree.  Its filename was
     cgroups-forbid-pre_destroy-callback-to-fail.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: cgroups: forbid pre_destroy() callback failures

Now that the mem_cgroup_pre_destroy() callback doesn't fail (other than a
race with a task attach resp.  child group appears) finally we can safely
move on and forbid all the callbacks from failing.

The last missing piece is moving cgroup_call_pre_destroy() after
cgroup_clear_css_refs() so that css_tryget() fails so no new charges for
the memcg can happen.

We cannot, however, move cgroup_call_pre_destroy right after because we
cannot call mem_cgroup_pre_destroy with the cgroup_lock held (see 3fa59dfb
cgroup: fix potential deadlock in pre_destroy) so we have to move it after
the lock is released.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff -puN kernel/cgroup.c~cgroups-forbid-pre_destroy-callback-to-fail kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-forbid-pre_destroy-callback-to-fail
+++ a/kernel/cgroup.c
@@ -858,7 +858,7 @@ static struct inode *cgroup_new_inode(um
  * Call subsys's pre_destroy handler.
  * This is called before css refcnt check.
  */
-static int cgroup_call_pre_destroy(struct cgroup *cgrp)
+static void cgroup_call_pre_destroy(struct cgroup *cgrp)
 {
 	struct cgroup_subsys *ss;
 	int ret = 0;
@@ -867,15 +867,8 @@ static int cgroup_call_pre_destroy(struc
 		if (!ss->pre_destroy)
 			continue;
 
-		ret = ss->pre_destroy(cgrp);
-		if (ret) {
-			/* ->pre_destroy() failure is being deprecated */
-			WARN_ON_ONCE(!ss->__DEPRECATED_clear_css_refs);
-			break;
-		}
+		BUG_ON(ss->pre_destroy(cgrp));
 	}
-
-	return ret;
 }
 
 static void cgroup_diput(struct dentry *dentry, struct inode *inode)
@@ -4282,7 +4275,6 @@ again:
 		mutex_unlock(&cgroup_mutex);
 		return -EBUSY;
 	}
-	mutex_unlock(&cgroup_mutex);
 
 	/*
 	 * In general, subsystem has no css->refcnt after pre_destroy(). But
@@ -4295,17 +4287,6 @@ again:
 	 */
 	set_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
 
-	/*
-	 * Call pre_destroy handlers of subsys. Notify subsystems
-	 * that rmdir() request comes.
-	 */
-	ret = cgroup_call_pre_destroy(cgrp);
-	if (ret) {
-		clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
-		return ret;
-	}
-
-	mutex_lock(&cgroup_mutex);
 	parent = cgrp->parent;
 	if (atomic_read(&cgrp->count) || !list_empty(&cgrp->children)) {
 		clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
@@ -4327,6 +4308,7 @@ again:
 			return -EINTR;
 		goto again;
 	}
+
 	/* NO css_tryget() can success after here. */
 	finish_wait(&cgroup_rmdir_waitq, &wait);
 	clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
@@ -4365,6 +4347,12 @@ again:
 	spin_unlock(&cgrp->event_list_lock);
 
 	mutex_unlock(&cgroup_mutex);
+
+	/*
+	 * Call pre_destroy handlers of subsys. Notify subsystems
+	 * that rmdir() request comes.
+	 */
+	cgroup_call_pre_destroy(cgrp);
 	return 0;
 }
 
_

Patches currently in -mm which might be from mhocko@suse.cz are

linux-next.patch
thp-clean-up-__collapse_huge_page_isolate.patch
thp-clean-up-__collapse_huge_page_isolate-v2.patch
mm-introduce-mm_find_pmd.patch
mm-introduce-mm_find_pmd-fix.patch
thp-introduce-hugepage_vma_check.patch
thp-cleanup-introduce-mk_huge_pmd.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch
memcg-make-mem_cgroup_reparent_charges-non-failing.patch
hugetlb-do-not-fail-in-hugetlb_cgroup_pre_destroy.patch
drop_caches-add-some-documentation-and-info-messsge.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
mm-memblock-reduce-overhead-in-binary-search.patch

