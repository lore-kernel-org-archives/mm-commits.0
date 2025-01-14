Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79FD23A103
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836961; cv=none; b=RbsnOUiOsD9aejTG2eOMp3JnMPJAH4N4Ny9Yo0CrsAUsBs2nu3txmPTl+3e1Np5bX2Z0opK9ugrCi0tEXlZj8HtHb2lf8tw36tgANFSyEzdSLNhpp2/jfabUPL1MDVV2Boy8V24+7OGt6Ag6uqZaeYITrwgE0kkw6hz1TznhYXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836961; c=relaxed/simple;
	bh=A9NkOq/M2ew3GVrAlexvUV6rlxm+Jqqx6mIWHd/iJZI=;
	h=Date:To:From:Subject:Message-Id; b=eZnAMtKornYKftnI5INd7Pr8WgcVek2Jb11O0Dxf8P2rg3elnG11jRS8K2ERw/LtyG0AokNOhysFeVhhLnQgtH/jtYe5Wdn0M0Jc9sWkH5crOg7lsvZP1KduTNqDic77pli/M+FzFKy9N1LlrMAFoNoNtO0gcfPiiGZoqC5Y7/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZASilMwW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZASilMwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955E8C4CEDF;
	Tue, 14 Jan 2025 06:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836961;
	bh=A9NkOq/M2ew3GVrAlexvUV6rlxm+Jqqx6mIWHd/iJZI=;
	h=Date:To:From:Subject:From;
	b=ZASilMwWB4KEnA4gbKzQl1/68fIofjotnGkasaG777wCMD25Zz8TvOEso282whiJ2
	 eyj7yqPlpn50GDRpQ6o1mB+t5YGJTMRdvetd1ljgzdGzH8JmvyiVC03S3ALzcbxUgb
	 Qku44dRoQSikYxl2j5DoO62MOcFApqi/etZPk4xo=
Date: Mon, 13 Jan 2025 22:42:41 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc.patch removed from -mm tree
Message-Id: <20250114064241.955E8C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap_cgroup: allocate swap_cgroup map using vcalloc()
has been removed from the -mm tree.  Its filename was
     mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: swap_cgroup: allocate swap_cgroup map using vcalloc()
Date: Fri, 15 Nov 2024 19:02:28 +0000

Currently swap_cgroup's map is constructed as a vmalloc()'s-based array of
pointers to individual struct pages.  This brings an unnecessary
complexity into the code.

This patch turns the swap_cgroup's map into a single space
allocated by vcalloc().

[akpm@linux-foundation.org: s/vfree/kvfree/, per Shakeel]
Link: https://lkml.kernel.org/r/20241115190229.676440-1-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_cgroup.c |   83 +++++++--------------------------------------
 1 file changed, 13 insertions(+), 70 deletions(-)

--- a/mm/swap_cgroup.c~mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc
+++ a/mm/swap_cgroup.c
@@ -6,17 +6,18 @@
 #include <linux/swapops.h> /* depends on mm.h include */
 
 static DEFINE_MUTEX(swap_cgroup_mutex);
+
+struct swap_cgroup {
+	unsigned short		id;
+};
+
 struct swap_cgroup_ctrl {
-	struct page **map;
-	unsigned long length;
+	struct swap_cgroup *map;
 	spinlock_t	lock;
 };
 
 static struct swap_cgroup_ctrl swap_cgroup_ctrl[MAX_SWAPFILES];
 
-struct swap_cgroup {
-	unsigned short		id;
-};
 #define SC_PER_PAGE	(PAGE_SIZE/sizeof(struct swap_cgroup))
 
 /*
@@ -33,44 +34,10 @@ struct swap_cgroup {
  * TODO: we can push these buffers out to HIGHMEM.
  */
 
-/*
- * allocate buffer for swap_cgroup.
- */
-static int swap_cgroup_prepare(int type)
-{
-	struct page *page;
-	struct swap_cgroup_ctrl *ctrl;
-	unsigned long idx, max;
-
-	ctrl = &swap_cgroup_ctrl[type];
-
-	for (idx = 0; idx < ctrl->length; idx++) {
-		page = alloc_page(GFP_KERNEL | __GFP_ZERO);
-		if (!page)
-			goto not_enough_page;
-		ctrl->map[idx] = page;
-
-		if (!(idx % SWAP_CLUSTER_MAX))
-			cond_resched();
-	}
-	return 0;
-not_enough_page:
-	max = idx;
-	for (idx = 0; idx < max; idx++)
-		__free_page(ctrl->map[idx]);
-
-	return -ENOMEM;
-}
-
 static struct swap_cgroup *__lookup_swap_cgroup(struct swap_cgroup_ctrl *ctrl,
 						pgoff_t offset)
 {
-	struct page *mappage;
-	struct swap_cgroup *sc;
-
-	mappage = ctrl->map[offset / SC_PER_PAGE];
-	sc = page_address(mappage);
-	return sc + offset % SC_PER_PAGE;
+	return &ctrl->map[offset];
 }
 
 static struct swap_cgroup *lookup_swap_cgroup(swp_entry_t ent,
@@ -168,32 +135,20 @@ unsigned short lookup_swap_cgroup_id(swp
 
 int swap_cgroup_swapon(int type, unsigned long max_pages)
 {
-	void *array;
-	unsigned long length;
+	struct swap_cgroup *map;
 	struct swap_cgroup_ctrl *ctrl;
 
 	if (mem_cgroup_disabled())
 		return 0;
 
-	length = DIV_ROUND_UP(max_pages, SC_PER_PAGE);
-
-	array = vcalloc(length, sizeof(void *));
-	if (!array)
+	map = vcalloc(max_pages, sizeof(struct swap_cgroup));
+	if (!map)
 		goto nomem;
 
 	ctrl = &swap_cgroup_ctrl[type];
 	mutex_lock(&swap_cgroup_mutex);
-	ctrl->length = length;
-	ctrl->map = array;
+	ctrl->map = map;
 	spin_lock_init(&ctrl->lock);
-	if (swap_cgroup_prepare(type)) {
-		/* memory shortage */
-		ctrl->map = NULL;
-		ctrl->length = 0;
-		mutex_unlock(&swap_cgroup_mutex);
-		vfree(array);
-		goto nomem;
-	}
 	mutex_unlock(&swap_cgroup_mutex);
 
 	return 0;
@@ -205,8 +160,7 @@ nomem:
 
 void swap_cgroup_swapoff(int type)
 {
-	struct page **map;
-	unsigned long i, length;
+	struct swap_cgroup *map;
 	struct swap_cgroup_ctrl *ctrl;
 
 	if (mem_cgroup_disabled())
@@ -215,19 +169,8 @@ void swap_cgroup_swapoff(int type)
 	mutex_lock(&swap_cgroup_mutex);
 	ctrl = &swap_cgroup_ctrl[type];
 	map = ctrl->map;
-	length = ctrl->length;
 	ctrl->map = NULL;
-	ctrl->length = 0;
 	mutex_unlock(&swap_cgroup_mutex);
 
-	if (map) {
-		for (i = 0; i < length; i++) {
-			struct page *page = map[i];
-			if (page)
-				__free_page(page);
-			if (!(i % SWAP_CLUSTER_MAX))
-				cond_resched();
-		}
-		vfree(map);
-	}
+	vfree(map);
 }
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are


