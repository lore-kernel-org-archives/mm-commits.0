Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F1328467B
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126216; cv=none; b=kItg9kL4dLDaY4Gea0c+cftwmeHQEPKpWWjP82n0EY5B0DDZeaqu0KbAKolkpTd/AJ5UIbpL/ZiQb8MzZenfM7kGkFkgHtX/nvDcIBZ0A8T0117uoWI8UYECBE0JZ51kAIHIgMZm7xIJqIBTSCPydCD86HM4OJTSrf/RS3vXa3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126216; c=relaxed/simple;
	bh=skK7x6kuNcXCDHenWO3716WSlvW+S6Pu703o6b5oaPI=;
	h=Date:To:From:Subject:Message-Id; b=O8oDFLTvZHVPWo/1l0GL9oM81iyG1y6AQSfpTcyS4pQGsC6uU1xvKd7WF+FdrDaNRY89vH7MpeBqE2skStXjvJsTFjWV7jyN399p8UMQtj/M3iUMnQidtD1bMRNaHjqiQXVxtr9dbm0XgDZZbPTb4bAQC1zBViNLJ6dhwwyNTB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IzXFbIc4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IzXFbIc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73122C4CEE3;
	Thu, 10 Jul 2025 05:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126216;
	bh=skK7x6kuNcXCDHenWO3716WSlvW+S6Pu703o6b5oaPI=;
	h=Date:To:From:Subject:From;
	b=IzXFbIc4wjW+yNaKIm+c9feCFw3qmkQaYzIkU1FYnD5FLvkpQxBzoWXN5r+MFIwZX
	 XI1qKgZwXrsT5Lmqyrds1XMdqSXy3LdGJKQTDq9hUXpmdMSg9mwEpMewvU2UQeHCkp
	 StkGfLj6l4FtidkEp4MxcZKJ9kiHdYTi1zFRQETE=
Date: Wed, 09 Jul 2025 22:43:35 -0700
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,zhengqi.arch@bytedance.com,sj@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,lkp@intel.com,julia.lawall@inria.fr,hannes@cmpxchg.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-list_lru-refactor-the-locking-code.patch removed from -mm tree
Message-Id: <20250710054336.73122C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, list_lru: refactor the locking code
has been removed from the -mm tree.  Its filename was
     mm-list_lru-refactor-the-locking-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, list_lru: refactor the locking code
Date: Tue, 27 May 2025 02:06:38 +0800

Cocci is confused by the try lock then release RCU and return logic here. 
So separate the try lock part out into a standalone helper.  The code is
easier to follow too.

No feature change, fixes:

cocci warnings: (new ones prefixed by >>)
>> mm/list_lru.c:82:3-9: preceding lock on line 77
>> mm/list_lru.c:82:3-9: preceding lock on line 77
   mm/list_lru.c:82:3-9: preceding lock on line 75
   mm/list_lru.c:82:3-9: preceding lock on line 75

Link: https://lkml.kernel.org/r/20250526180638.14609-1-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@inria.fr>
Closes: https://lore.kernel.org/r/202505252043.pbT1tBHJ-lkp@intel.com/
Reviewed-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

--- a/mm/list_lru.c~mm-list_lru-refactor-the-locking-code
+++ a/mm/list_lru.c
@@ -60,30 +60,34 @@ list_lru_from_memcg_idx(struct list_lru
 	return &lru->node[nid].lru;
 }
 
+static inline bool lock_list_lru(struct list_lru_one *l, bool irq)
+{
+	if (irq)
+		spin_lock_irq(&l->lock);
+	else
+		spin_lock(&l->lock);
+	if (unlikely(READ_ONCE(l->nr_items) == LONG_MIN)) {
+		if (irq)
+			spin_unlock_irq(&l->lock);
+		else
+			spin_unlock(&l->lock);
+		return false;
+	}
+	return true;
+}
+
 static inline struct list_lru_one *
 lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 		       bool irq, bool skip_empty)
 {
 	struct list_lru_one *l;
-	long nr_items;
 
 	rcu_read_lock();
 again:
 	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
-	if (likely(l)) {
-		if (irq)
-			spin_lock_irq(&l->lock);
-		else
-			spin_lock(&l->lock);
-		nr_items = READ_ONCE(l->nr_items);
-		if (likely(nr_items != LONG_MIN)) {
-			rcu_read_unlock();
-			return l;
-		}
-		if (irq)
-			spin_unlock_irq(&l->lock);
-		else
-			spin_unlock(&l->lock);
+	if (likely(l) && lock_list_lru(l, irq)) {
+		rcu_read_unlock();
+		return l;
 	}
 	/*
 	 * Caller may simply bail out if raced with reparenting or
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hung.patch
mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch
mm-shmem-swap-tidy-up-thp-swapin-checks.patch
mm-shmem-swap-tidy-up-swap-entry-splitting.patch
mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling.patch
mm-shmem-swap-rework-swap-entry-and-index-calculation-for-large-swapin.patch
mm-shmem-swap-fix-major-fault-counting.patch

