Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8825381E
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247775; cv=none; b=rPHJq+Ky7wKATbmv5mcqMY4vllALZwrBponWFAC+SV85xQYrD5V6/K/ycccSfZ+CMM9VZTVbjOqG2d6iOVyliWdfITYr8O2mJys43XYJHBUclQ3JRCX7Xy6zR+wi9WbbJIhfEFC8IgdTTIM7DtJNvwdm0q/WVTq/KD5EKFcVZio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247775; c=relaxed/simple;
	bh=qowaVhmI8LM/xl84/WrV4YmE5nqprCJ4uevvi3YmOqY=;
	h=Date:To:From:Subject:Message-Id; b=P8RR697vQayLfCVp0gf20o+cEH0uQK3xSZ9jAbPEzPAt4izuAjS8EZfYZNjTJYDzuNxFrO36R8PIDWMrAPCMjhZ8lx3gAxJKHa5raP0sYEMsJwxHzoZUESkBGvENkgAS0v+0iD7oaCaaXKC2X76DfJN0k/WOBIZaF5vST0a2u1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eB8tx6co; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eB8tx6co"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52882C4CEC2;
	Mon,  2 Sep 2024 03:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247775;
	bh=qowaVhmI8LM/xl84/WrV4YmE5nqprCJ4uevvi3YmOqY=;
	h=Date:To:From:Subject:From;
	b=eB8tx6codioyHMK++fR2jYeDvw42C/hpt58TqL86BsHVPlyfqVcCUUcuO2SxwRXlZ
	 P1+FJ6pyAmGkMZXKAaTAb3bp77mVvJeSn365jAxgDqvqsN764nxorveW1pEI0TE97b
	 y96UGzL206X/9cvTpOZkXl1EgdOgF9dlhtPpKXdY=
Date: Sun, 01 Sep 2024 20:29:34 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,dan.carpenter@linaro.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-replace-memcg-id-idr-with-xarray.patch removed from -mm tree
Message-Id: <20240902032935.52882C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: replace memcg ID idr with xarray
has been removed from the -mm tree.  Its filename was
     memcg-replace-memcg-id-idr-with-xarray.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: replace memcg ID idr with xarray
Date: Fri, 9 Aug 2024 10:26:18 -0700

At the moment memcg IDs are managed through IDR which requires external
synchronization mechanisms and makes the allocation code a bit awkward. 
Let's switch to xarray and make the code simpler.

[shakeel.butt@linux.dev: fix error path in mem_cgroup_alloc(), per Dan]
  Link: https://lkml.kernel.org/r/20240815155402.3630804-1-shakeel.butt@linux.dev
Link: https://lkml.kernel.org/r/20240809172618.2946790-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   39 ++++++++++-----------------------------
 1 file changed, 10 insertions(+), 29 deletions(-)

--- a/mm/memcontrol.c~memcg-replace-memcg-id-idr-with-xarray
+++ a/mm/memcontrol.c
@@ -3363,29 +3363,12 @@ static void memcg_wb_domain_size_changed
  */
 
 #define MEM_CGROUP_ID_MAX	((1UL << MEM_CGROUP_ID_SHIFT) - 1)
-static DEFINE_IDR(mem_cgroup_idr);
-static DEFINE_SPINLOCK(memcg_idr_lock);
-
-static int mem_cgroup_alloc_id(void)
-{
-	int ret;
-
-	idr_preload(GFP_KERNEL);
-	spin_lock(&memcg_idr_lock);
-	ret = idr_alloc(&mem_cgroup_idr, NULL, 1, MEM_CGROUP_ID_MAX + 1,
-			GFP_NOWAIT);
-	spin_unlock(&memcg_idr_lock);
-	idr_preload_end();
-	return ret;
-}
+static DEFINE_XARRAY_ALLOC1(mem_cgroup_ids);
 
 static void mem_cgroup_id_remove(struct mem_cgroup *memcg)
 {
 	if (memcg->id.id > 0) {
-		spin_lock(&memcg_idr_lock);
-		idr_remove(&mem_cgroup_idr, memcg->id.id);
-		spin_unlock(&memcg_idr_lock);
-
+		xa_erase(&mem_cgroup_ids, memcg->id.id);
 		memcg->id.id = 0;
 	}
 }
@@ -3420,7 +3403,7 @@ static inline void mem_cgroup_id_put(str
 struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
 {
 	WARN_ON_ONCE(!rcu_read_lock_held());
-	return idr_find(&mem_cgroup_idr, id);
+	return xa_load(&mem_cgroup_ids, id);
 }
 
 #ifdef CONFIG_SHRINKER_DEBUG
@@ -3513,17 +3496,17 @@ static struct mem_cgroup *mem_cgroup_all
 	struct mem_cgroup *memcg;
 	int node, cpu;
 	int __maybe_unused i;
-	long error = -ENOMEM;
+	long error;
 
 	memcg = kzalloc(struct_size(memcg, nodeinfo, nr_node_ids), GFP_KERNEL);
 	if (!memcg)
-		return ERR_PTR(error);
+		return ERR_PTR(-ENOMEM);
 
-	memcg->id.id = mem_cgroup_alloc_id();
-	if (memcg->id.id < 0) {
-		error = memcg->id.id;
+	error = xa_alloc(&mem_cgroup_ids, &memcg->id.id, NULL,
+			 XA_LIMIT(1, MEM_CGROUP_ID_MAX), GFP_KERNEL);
+	if (error)
 		goto fail;
-	}
+	error = -ENOMEM;
 
 	memcg->vmstats = kzalloc(sizeof(struct memcg_vmstats),
 				 GFP_KERNEL_ACCOUNT);
@@ -3664,9 +3647,7 @@ static int mem_cgroup_css_online(struct
 	 * publish it here at the end of onlining. This matches the
 	 * regular ID destruction during offlining.
 	 */
-	spin_lock(&memcg_idr_lock);
-	idr_replace(&mem_cgroup_idr, memcg, memcg->id.id);
-	spin_unlock(&memcg_idr_lock);
+	xa_store(&mem_cgroup_ids, memcg->id.id, memcg, GFP_KERNEL);
 
 	return 0;
 offline_kmem:
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


