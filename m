Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8155210E9
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 22:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749076340; cv=none; b=d5PzWLwPGgsSRO4HR3PYMIkH/JfFBLDBeWya/mnnXv+egdIWYRq4HGuNEcqmIdS/LNEMwPSiZTzxN95ShDSYj+61//Gis+B6eb5pKHxTIvc27DNXuM2zUNnzBNbG/ePkzIva3dbbYroQx/NJqd9zE4JZwuiwYogpfd6Hs3USLgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749076340; c=relaxed/simple;
	bh=+6hPLWneHbM9YQ0gJE9+ME2E83EqR2q2niSQBH7Zv6Y=;
	h=Date:To:From:Subject:Message-Id; b=hpc/O261tk9st0c6GYx+r4fWqYYtfG/2wk6XSm8X6n7ENW/SwBvrSStggmEgM3LPQllsxgMvZUSecaM0H5V08yYL/+HelB9gqc3JqRdEgAZcm8P3xUmLg5+PgdXLHs7svxOiA3c4o4xlqX7dBM7PWFLxj/wNkJyyG+aIa0qX2b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XfHACi0R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XfHACi0R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD40C4CEE4;
	Wed,  4 Jun 2025 22:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749076339;
	bh=+6hPLWneHbM9YQ0gJE9+ME2E83EqR2q2niSQBH7Zv6Y=;
	h=Date:To:From:Subject:From;
	b=XfHACi0R1TyU4NhmY9UokK7ilH8DCDXpDbtLovz88cG9ABtLfl19YVKlQIcc9h/1C
	 D56B6sqyaQFbOSPtyxMABCZrcKzPzFqaXc61IB1dLWvVBsdRW5bFQ0rPW7JOMIar0K
	 AlO3TGIm22ZmcuqkZsM8YaSSO2gi4jRXsbvQQPs4=
Date: Wed, 04 Jun 2025 15:32:19 -0700
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,zhengqi.arch@bytedance.com,sj@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,lkp@intel.com,julia.lawall@inria.fr,hannes@cmpxchg.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lru-refactor-the-locking-code.patch added to mm-new branch
Message-Id: <20250604223219.BAD40C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, list_lru: refactor the locking code
has been added to the -mm mm-new branch.  Its filename is
     mm-list_lru-refactor-the-locking-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-list_lru-refactor-the-locking-code.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-userfaultfd-fix-race-of-userfaultfd_move-and-swap-cache.patch
mm-list_lru-refactor-the-locking-code.patch

