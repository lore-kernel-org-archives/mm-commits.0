Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48ED217F33
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188467; cv=none; b=NX+b4NHd6XMlySni7qiAdFgF+Flhh9GCZTtOGZkSs9doUFrMa7TZaGv5llKncTf06LZoAWkrgDRx2L+gpbfkPNVtI21ii9pf2fjl8M5fXTgm8fml26I9i4s52Grkl8IATqX78k1X6eLeD+DNtz0LqhGjY5GuWayMWAiEi4Me7mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188467; c=relaxed/simple;
	bh=D8GSDwAG710qo5unrEH5+bfoDBscdnObuk6T0/5b4vk=;
	h=Date:To:From:Subject:Message-Id; b=Ir/Jqy2c3AErQOdIZgozAZkr66ncNkAxm8hUqL8i8kbbmhrXHkvuqNAO6qGs5lb5ntS5xj/vQju/9eF4v06HtNBCJe2DfjmY5qw2AFmbt+Mdr/sXs/fmCzpcyNm/brUfd2FbHjR8Xt+A/oBP9MogVdGe1ebsQxwxw3h4zWR1nAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=un7uymvO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="un7uymvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9819BC4CEEC;
	Mon, 17 Mar 2025 05:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188467;
	bh=D8GSDwAG710qo5unrEH5+bfoDBscdnObuk6T0/5b4vk=;
	h=Date:To:From:Subject:From;
	b=un7uymvOVx7JvL5RfWmBW9nqGswgN46BIh+1JvUr7/j7mH9cX3CXUeuHMUDt5i4nw
	 jmKpS8lIruBdyft3QtQH3nlmNWcTkNogNiNnu4pE9oFtJG1RZHfnyB2ViltFYfTAtV
	 QrRJM4FI57jahw+8RvnhhL7yPcZVgDruNR50BY2M=
Date: Sun, 16 Mar 2025 22:14:27 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,v-songbaohua@oppo.com,nphamcs@gmail.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-dont-update-the-counter-up-front.patch removed from -mm tree
Message-Id: <20250317051427.9819BC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: don't update the counter up-front
has been removed from the -mm tree.  Its filename was
     mm-swap-dont-update-the-counter-up-front.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: don't update the counter up-front
Date: Fri, 14 Mar 2025 00:59:32 +0800

The counter update before allocation design was useful to avoid
unnecessary scan when device is full, so it will abort early if the
counter indicates the device is full.  But that is an uncommon case, and
now scanning of a full device is very fast, so the up-front update is not
helpful any more.

Remove it and simplify the slot allocation logic.

Link: https://lkml.kernel.org/r/20250313165935.63303-5-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

--- a/mm/swapfile.c~mm-swap-dont-update-the-counter-up-front
+++ a/mm/swapfile.c
@@ -1201,22 +1201,10 @@ int get_swap_pages(int n_goal, swp_entry
 	int order = swap_entry_order(entry_order);
 	unsigned long size = 1 << order;
 	struct swap_info_struct *si, *next;
-	long avail_pgs;
 	int n_ret = 0;
 	int node;
 
 	spin_lock(&swap_avail_lock);
-
-	avail_pgs = atomic_long_read(&nr_swap_pages) / size;
-	if (avail_pgs <= 0) {
-		spin_unlock(&swap_avail_lock);
-		goto noswap;
-	}
-
-	n_goal = min3((long)n_goal, (long)SWAP_BATCH, avail_pgs);
-
-	atomic_long_sub(n_goal * size, &nr_swap_pages);
-
 start_over:
 	node = numa_node_id();
 	plist_for_each_entry_safe(si, next, &swap_avail_heads[node], avail_lists[node]) {
@@ -1250,10 +1238,8 @@ start_over:
 	spin_unlock(&swap_avail_lock);
 
 check_out:
-	if (n_ret < n_goal)
-		atomic_long_add((long)(n_goal - n_ret) * size,
-				&nr_swap_pages);
-noswap:
+	atomic_long_sub(n_ret * size, &nr_swap_pages);
+
 	return n_ret;
 }
 
_

Patches currently in -mm which might be from kasong@tencent.com are


