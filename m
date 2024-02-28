Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41A679B86
	for <mm-commits@vger.kernel.org>; Wed, 28 Feb 2024 18:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709144619; cv=none; b=JG2d5KFuJfSP0R2xToCz/i9sk3bAFrCaaPRB6Ch8ONtjrSq8NgCZQxrRB0QZrjPQS4cjh9YjksGFuzvHUXkofS1XN0CJaBymzyUX6+PQ9HK+KN2OR1mW/Nby5RglZEkpOB4XK3TFyq7nTmTPRPdbNNIIjA4m+nr1y+uvkuZG/mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709144619; c=relaxed/simple;
	bh=XDFsIvzIf4KsCB9lWF02/l3gh8mBadgr5ilhhY+sK5g=;
	h=Date:To:From:Subject:Message-Id; b=jdsKuJE9aPId0f3bHxgLXH+ONiWD9/P5eoTNrHVS+Vx/7z4FY2LGKKD7UDhTgmEz6RkFCqYgSNUguQbkwbLzEWc8/Z15V0lbX1Geer/RK526eM2YnFKwtfCaiVqFMZK0zYlMEgN5ABp8oTcvZWJJc+HF2OuGJz4wfOmJYDD+dos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OBzVl/4Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OBzVl/4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D471C433F1;
	Wed, 28 Feb 2024 18:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709144619;
	bh=XDFsIvzIf4KsCB9lWF02/l3gh8mBadgr5ilhhY+sK5g=;
	h=Date:To:From:Subject:From;
	b=OBzVl/4YsVT3g+h5fPetOBPaT5lA41cz1l2E5Zp21HmxJtSW+31mqTN0FqjTl3UP8
	 LJEuMv+b13xFzL/HfNPQIrwxG5BOy5B2ByzuBCYJs7UElK+u6yKe3EC3PzYz3Q28+9
	 nIMxbue4ij1/oRndYlHeheh55mlD/2tVIcHdU/aU=
Date: Wed, 28 Feb 2024 10:23:38 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,willy@infradead.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-change-zswap_pool-kref-to-percpu_ref-fix.patch added to mm-unstable branch
Message-Id: <20240228182339.2D471C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: fix zswap_pools_lock usages after changing to percpu_ref
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-change-zswap_pool-kref-to-percpu_ref-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-change-zswap_pool-kref-to-percpu_ref-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Chengming Zhou <chengming.zhou@linux.dev>
Subject: mm/zswap: fix zswap_pools_lock usages after changing to percpu_ref
Date: Wed, 28 Feb 2024 15:49:54 +0000

Now the release of zswap pool is controlled by percpu_ref, its release
callback (__zswap_pool_empty()) will be called when percpu_ref hit 0.  But
this release callback may potentially be called from RCU callback context
by percpu_ref_kill(), which maybe from the softirq context.

So we need to use spin_lock/unlock_bh() to avoid potential deadlock.

This problem is introduced by the commit f3da427e82c4 ("mm/zswap: change
zswap_pool kref to percpu_ref"), which is in mm-unstable branch now.  It
can be reproduced by testing kernel build in tmpfs with zswap and
CONFIG_LOCKDEP enabled, meanwhile changing the zswap compressor setting
dynamically.

Link: https://lkml.kernel.org/r/20240228154954.3028626-1-chengming.zhou@linux.dev
Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/zswap.c~mm-zswap-change-zswap_pool-kref-to-percpu_ref-fix
+++ a/mm/zswap.c
@@ -459,7 +459,7 @@ static void __zswap_pool_empty(struct pe
 
 	pool = container_of(ref, typeof(*pool), ref);
 
-	spin_lock(&zswap_pools_lock);
+	spin_lock_bh(&zswap_pools_lock);
 
 	WARN_ON(pool == zswap_pool_current());
 
@@ -468,7 +468,7 @@ static void __zswap_pool_empty(struct pe
 	INIT_WORK(&pool->release_work, __zswap_pool_release);
 	schedule_work(&pool->release_work);
 
-	spin_unlock(&zswap_pools_lock);
+	spin_unlock_bh(&zswap_pools_lock);
 }
 
 static int __must_check zswap_pool_get(struct zswap_pool *pool)
@@ -598,7 +598,7 @@ static int __zswap_param_set(const char
 		return -EINVAL;
 	}
 
-	spin_lock(&zswap_pools_lock);
+	spin_lock_bh(&zswap_pools_lock);
 
 	pool = zswap_pool_find_get(type, compressor);
 	if (pool) {
@@ -607,7 +607,7 @@ static int __zswap_param_set(const char
 		list_del_rcu(&pool->list);
 	}
 
-	spin_unlock(&zswap_pools_lock);
+	spin_unlock_bh(&zswap_pools_lock);
 
 	if (!pool)
 		pool = zswap_pool_create(type, compressor);
@@ -628,7 +628,7 @@ static int __zswap_param_set(const char
 	else
 		ret = -EINVAL;
 
-	spin_lock(&zswap_pools_lock);
+	spin_lock_bh(&zswap_pools_lock);
 
 	if (!ret) {
 		put_pool = zswap_pool_current();
@@ -643,7 +643,7 @@ static int __zswap_param_set(const char
 		put_pool = pool;
 	}
 
-	spin_unlock(&zswap_pools_lock);
+	spin_unlock_bh(&zswap_pools_lock);
 
 	if (!zswap_has_pool && !pool) {
 		/* if initial pool creation failed, and this pool creation also
_

Patches currently in -mm which might be from chengming.zhou@linux.dev are

mm-zswap-change-zswap_pool-kref-to-percpu_ref-fix.patch

