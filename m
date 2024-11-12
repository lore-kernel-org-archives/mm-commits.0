Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE187204946
	for <mm-commits@vger.kernel.org>; Tue, 12 Nov 2024 01:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731374576; cv=none; b=cEglUt63D0/yZrmyfocZkmvD/o6WkmiEgfPsG/rGgGp8Phj5PVpU5sOL4WBISah3Si1bbgfsm5kJbkFtzHzsMRCEWkdDjIhKgzY4CpPbUjwxVTNhSyGWYTRHt4JjkB7te3ATxyQWgUHTMKBAn6dGOSZQqrSK9KMIUifQTILuDdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731374576; c=relaxed/simple;
	bh=4KrzEg3+FGZ+yfP+LsaZBsDDt9LgOtOvFS2O5r7KUhc=;
	h=Date:To:From:Subject:Message-Id; b=bVivJeTikHXyMQVhL30EBGzf9xkM41Ut3B4pe4w/1kqa/SQLtILvMPMWfGfnM2JAQfLyJu6zzeuCa/e2ZNIHyFzDOs65NWB8Q8gsJx+JE/Z9Z9HQ8GSvVnUePGiyyk6cNlEcPdwVnCcvnW22lTHg3DMd7BuLfzs9WCfkD6Z3jVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mZzMhoZA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mZzMhoZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F70AC4CED0;
	Tue, 12 Nov 2024 01:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731374576;
	bh=4KrzEg3+FGZ+yfP+LsaZBsDDt9LgOtOvFS2O5r7KUhc=;
	h=Date:To:From:Subject:From;
	b=mZzMhoZAh/rmY/1e95LFhCcneNzuuZe00hbYHVH0ShxQNpoM1mgdFBsIUj4agrdGf
	 OV1X0RUSJgHo+25Fo4rIPkY46zr9D94TPLbc3Ms3Jiz7QTISDD5dQAeEM7O9ZCI6qf
	 zsgw60GShrG86VLZhxdjH0g82ygmfUQESctqFlR0=
Date: Mon, 11 Nov 2024 17:22:55 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,zhengqi.arch@bytedance.com,willy@infradead.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,longman@redhat.com,hannes@cmpxchg.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-list_lru-code-clean-up-for-reparenting.patch removed from -mm tree
Message-Id: <20241112012256.6F70AC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/list_lru: code clean up for reparenting
has been removed from the -mm tree.  Its filename was
     mm-list_lru-code-clean-up-for-reparenting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/list_lru: code clean up for reparenting
Date: Tue, 5 Nov 2024 01:52:54 +0800

No feature change, just change of code structure and fix comment.

The list lrus are not empty until memcg_reparent_list_lru_node() calls are
all done, so the comments in memcg_offline_kmem were slightly inaccurate.

Link: https://lkml.kernel.org/r/20241104175257.60853-4-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c   |   39 +++++++++++++++++----------------------
 mm/memcontrol.c |    7 -------
 2 files changed, 17 insertions(+), 29 deletions(-)

--- a/mm/list_lru.c~mm-list_lru-code-clean-up-for-reparenting
+++ a/mm/list_lru.c
@@ -421,35 +421,16 @@ out:
 	spin_unlock_irq(&nlru->lock);
 }
 
-static void memcg_reparent_list_lru(struct list_lru *lru,
-				    int src_idx, struct mem_cgroup *dst_memcg)
-{
-	int i;
-
-	for_each_node(i)
-		memcg_reparent_list_lru_node(lru, i, src_idx, dst_memcg);
-
-	memcg_list_lru_free(lru, src_idx);
-}
-
 void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {
 	struct cgroup_subsys_state *css;
 	struct list_lru *lru;
-	int src_idx = memcg->kmemcg_id;
+	int src_idx = memcg->kmemcg_id, i;
 
 	/*
 	 * Change kmemcg_id of this cgroup and all its descendants to the
 	 * parent's id, and then move all entries from this cgroup's list_lrus
 	 * to ones of the parent.
-	 *
-	 * After we have finished, all list_lrus corresponding to this cgroup
-	 * are guaranteed to remain empty. So we can safely free this cgroup's
-	 * list lrus in memcg_list_lru_free().
-	 *
-	 * Changing ->kmemcg_id to the parent can prevent memcg_list_lru_alloc()
-	 * from allocating list lrus for this cgroup after memcg_list_lru_free()
-	 * call.
 	 */
 	rcu_read_lock();
 	css_for_each_descendant_pre(css, &memcg->css) {
@@ -460,9 +441,23 @@ void memcg_reparent_list_lrus(struct mem
 	}
 	rcu_read_unlock();
 
+	/*
+	 * With kmemcg_id set to parent, holding the lock of each list_lru_node
+	 * below can prevent list_lru_{add,del,isolate} from touching the lru,
+	 * safe to reparent.
+	 */
 	mutex_lock(&list_lrus_mutex);
-	list_for_each_entry(lru, &memcg_list_lrus, list)
-		memcg_reparent_list_lru(lru, src_idx, parent);
+	list_for_each_entry(lru, &memcg_list_lrus, list) {
+		for_each_node(i)
+			memcg_reparent_list_lru_node(lru, i, src_idx, parent);
+
+		/*
+		 * Here all list_lrus corresponding to the cgroup are guaranteed
+		 * to remain empty, we can safely free this lru, any further
+		 * memcg_list_lru_alloc() call will simply bail out.
+		 */
+		memcg_list_lru_free(lru, src_idx);
+	}
 	mutex_unlock(&list_lrus_mutex);
 }
 
--- a/mm/memcontrol.c~mm-list_lru-code-clean-up-for-reparenting
+++ a/mm/memcontrol.c
@@ -3111,13 +3111,6 @@ static void memcg_offline_kmem(struct me
 		parent = root_mem_cgroup;
 
 	memcg_reparent_objcgs(memcg, parent);
-
-	/*
-	 * After we have finished memcg_reparent_objcgs(), all list_lrus
-	 * corresponding to this cgroup are guaranteed to remain empty.
-	 * The ordering is imposed by list_lru_node->lock taken by
-	 * memcg_reparent_list_lrus().
-	 */
 	memcg_reparent_list_lrus(memcg, parent);
 }
 
_

Patches currently in -mm which might be from kasong@tencent.com are


