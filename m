Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B066D318BA7;
	Wed, 17 Jun 2026 17:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781716830; cv=none; b=WX0T6Vv2rH65Zto9LUfDvfIP7meVaoKm7nr1Eo6pj6z1KPLunRJM5e0to0mMZ4/GRnCJIOtniGui+hLbVrqtgM6ctuQ9QdacYS/29hGejU6nxAHJz911RgnF36mO7mDeHYJbCMrOyzRxg9lyIbftEAuig0STHOss6ZHX97mgcss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781716830; c=relaxed/simple;
	bh=Nzm64MZ0U50LvGJEIPNUK2Xhx/pQRBWgAqw5ps3uOCk=;
	h=Date:To:From:Subject:Message-Id; b=BAyYdABuG0wfwOzVjxNhEi48GhIqJaouYE/c/3DOFx8zngw0G1fKWrj5kTszw2xBrI+dsBivNtVBB13WOdVYQ+8lGIERz3b6JlNcgAeBOBN+coUPq69Fineb18/tzqgsi/qeTY0oCYWv1J5LP4btV9QdR4c9aQEOT1x+usGOCWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wKvfxzP0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wKvfxzP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC76D1F000E9;
	Wed, 17 Jun 2026 17:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781716827;
	bh=mdLS4DcstOIgnb++Z9Kesrd+VQTAcWdRQKJ91IFWQbg=;
	h=Date:To:From:Subject;
	b=wKvfxzP0rtGkQxgsdbcjdLnAkXDqa1pTNjUR90rxBayISrLp1gk46vIhGwqmO15wo
	 i2KLcCanfpKh3sc50TYjz+YqGDi6rk1q4QSNLI063tYyeAmeYiY/0m27x0DpGYlfqz
	 UvIS2Z70lj8pkc4ljMU2viioPYHEKcTBoQhyD6VU=
Date: Wed, 17 Jun 2026 10:20:26 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,david@fromorbit.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinker-fix-shrinker_info-teardown-race-with-expansion.patch added to mm-hotfixes-unstable branch
Message-Id: <20260617172026.DC76D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shrinker: fix shrinker_info teardown race with expansion
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shrinker-fix-shrinker_info-teardown-race-with-expansion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinker-fix-shrinker_info-teardown-race-with-expansion.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: shrinker: fix shrinker_info teardown race with expansion
Date: Wed, 17 Jun 2026 16:56:58 +0800

expand_shrinker_info() iterates all visible memcgs under shrinker_mutex,
including memcgs that have not finished ->css_online() yet.

Once pn->shrinker_info has been published, teardown must stay serialized
with expand_shrinker_info() until that memcg is either fully online or no
longer visible to iteration.  Today alloc_shrinker_info() breaks that rule
by dropping shrinker_mutex before freeing a partially initialized
shrinker_info array, which may cause the following race:

CPU0                   CPU1
====                   ====

css_create
--> list_add_tail_rcu(&css->sibling, &parent_css->children);
    online_css
    --> mem_cgroup_css_online
        --> alloc_shrinker_info
            --> alloc node0 info
                rcu_assign_pointer(C->node0->shrinker_info, old0)
                alloc node1 info -> FAIL -> goto err
                mutex_unlock(shrinker_mutex)

                       shrinker_alloc()
                       --> shrinker_memcg_alloc
                           --> mutex_lock(shrinker_mutex)
                               expand_shrinker_info
                               --> mem_cgroup_iter see the memcg
                                   expand_one_shrinker_info
                                   --> old0 = C->node0->shrinker_info
                                       memcpy(new->unit, old0->unit, ...);

                free_shrinker_info
                --> kvfree(old0);

                                       /* double free !! */
                                       kvfree_rcu(old0, rcu);

The same problem exists later in mem_cgroup_css_online().  If
alloc_shrinker_info() succeeds but a subsequent objcg allocation fails,
the free_objcg -> free_shrinker_info() unwind path tears down the already
published pn->shrinker_info arrays without shrinker_mutex.  The
expand_one_shrinker_info() can race with that teardown in the same way,
leading to use-after-free or double-free of the old shrinker_info.

Fix this by serializing shrinker_info teardown with shrinker_mutex, and by
keeping alloc_shrinker_info() error cleanup inside the locked section.

Link: https://lore.kernel.org/20260617085658.27096-1-qi.zheng@linux.dev
Fixes: 307bececcd12 ("mm: shrinker: add a secondary array for shrinker_info::{map, nr_deferred}")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/mm/shrinker.c~mm-shrinker-fix-shrinker_info-teardown-race-with-expansion
+++ a/mm/shrinker.c
@@ -59,12 +59,14 @@ static inline int shrinker_unit_alloc(st
 	return 0;
 }
 
-void free_shrinker_info(struct mem_cgroup *memcg)
+static void __free_shrinker_info(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup_per_node *pn;
 	struct shrinker_info *info;
 	int nid;
 
+	lockdep_assert_held(&shrinker_mutex);
+
 	for_each_node(nid) {
 		pn = memcg->nodeinfo[nid];
 		info = rcu_dereference_protected(pn->shrinker_info, true);
@@ -74,6 +76,13 @@ void free_shrinker_info(struct mem_cgrou
 	}
 }
 
+void free_shrinker_info(struct mem_cgroup *memcg)
+{
+	mutex_lock(&shrinker_mutex);
+	__free_shrinker_info(memcg);
+	mutex_unlock(&shrinker_mutex);
+}
+
 int alloc_shrinker_info(struct mem_cgroup *memcg)
 {
 	int nid, ret = 0;
@@ -98,8 +107,8 @@ int alloc_shrinker_info(struct mem_cgrou
 	return ret;
 
 err:
+	__free_shrinker_info(memcg);
 	mutex_unlock(&shrinker_mutex);
-	free_shrinker_info(memcg);
 	return -ENOMEM;
 }
 
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-shrinker-fix-shrinker_info-teardown-race-with-expansion.patch

