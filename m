Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F58B1DD0D4;
	Thu,  2 Jul 2026 02:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782957810; cv=none; b=l+ymZeLoRD9bJ7iq8VKyPh/mjOr3KmMyDEaFfiqDE6xrRcRvwDKooc0lFlgtDAWrYalKMlZdktKMz6VQY1aY4lRK9u1jmQ78ZmE7uHRIfmrpLLEYjszF81doPfVw8TqjOM29drAnB3OYTz4mEOuffULAbI+brcvGO2e1UehlfUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782957810; c=relaxed/simple;
	bh=HGJqcRx2j6WC2ei5x0W92qKRFVwuM9f5dkUxLq+R3ec=;
	h=Date:To:From:Subject:Message-Id; b=MjokCb4ZtQNpEUcVoQSpyVPxLspl9EvIgN2UnJMVsSOnvmhNdDvdluIk2rFnUqdtYM2ybZbGSVM0uUAhKsJMFBnQOskQ0u/jGAW3Jb0+jgYysBIyoN7AGRtvWbaYe2R6PnIF/mrFq2iKmMSafdkO6KxO1gLHBAgDsIWRY8khabM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=udEEPdcq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="udEEPdcq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6221F00A3A;
	Thu,  2 Jul 2026 02:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782957808;
	bh=pQk0Szd9KcQAVZm8BDhR1w9eoNA6XKXwIlUBLH0Xa+s=;
	h=Date:To:From:Subject;
	b=udEEPdcqLXOcEK1d1BQF+LyObdKag/zRRbLLZUO30snfb+fOAxOemX62Jt5qQUcTj
	 LogvcVCA8B3dTXCdpZetRIEg6FusIdRdtTXqqNcKFLqAVAnqtUxXCq22r8w8/AnJvP
	 P5v97Mk9Dl05ciDq5+ZfFvSX0wXX/LlVgCzlOGvg=
Date: Wed, 01 Jul 2026 19:03:28 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,david@fromorbit.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-shrinker-fix-shrinker_info-teardown-race-with-expansion.patch removed from -mm tree
Message-Id: <20260702020328.AB6221F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shrinker: fix shrinker_info teardown race with expansion
has been removed from the -mm tree.  Its filename was
     mm-shrinker-fix-shrinker_info-teardown-race-with-expansion.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


