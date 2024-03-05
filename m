Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F251DDC5
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 00:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600185; cv=none; b=T8XK0Gf4H0wzgy0GHqZ+zJdHgz8bh2bnrof4/5bsyLa4yt4yr9IdEy/0PPNUjgWtFsm/aXqnSHvcZ5thqagSyXuEvNUCPY0MinfmpeGWlQS16042sAKyeOdvusoDOu+uhYdh/xteELuqeiBsz07c3sqevclP1t9Tj0tLlCw7QdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600185; c=relaxed/simple;
	bh=DQEyRvzRpfcNQMfpZ1EQQiL+ZK8UmkbtCpboZiZXsdI=;
	h=Date:To:From:Subject:Message-Id; b=Lpt1CJMojM9pSicWfGG740n1S2ZgZByzdt6K8YzdSLqtQ5MMgJJtzUsncV0vSGb5zKMn4laTNxUGShMJZVP4XNR0JZXF/Hn4+qszG5i4ez5sHoiSq0aqm25xMUE+IFbyHtVYe+oLqUV4MkBi6hipJlZzwvEL+XIUrQLbZ7Z9wS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Otx/OzCT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Otx/OzCT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EECC433F1;
	Tue,  5 Mar 2024 00:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600184;
	bh=DQEyRvzRpfcNQMfpZ1EQQiL+ZK8UmkbtCpboZiZXsdI=;
	h=Date:To:From:Subject:From;
	b=Otx/OzCTz8WdRaduD4kAk3IvA0W9W9RcRDoYTKWAbvA9RO5Ucw16z1Ck0bfUl1c5A
	 sXSNp5MT5IfPhJ8xe0ApH9tkr6LSCX8oKzVtqm9aXUpp1KyJc1v/iPV3iiOz3gmELV
	 Rf1tDtD1uOCzn8mcQ2aLGmQg5j/SQ8PKG8ePjFhg=
Date: Mon, 04 Mar 2024 16:56:23 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,willy@infradead.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-zswap-change-zswap_pool-kref-to-percpu_ref-fix.patch removed from -mm tree
Message-Id: <20240305005624.86EECC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: fix zswap_pools_lock usages after changing to percpu_ref
has been removed from the -mm tree.  Its filename was
     mm-zswap-change-zswap_pool-kref-to-percpu_ref-fix.patch

This patch was dropped because it was folded into mm-zswap-change-zswap_pool-kref-to-percpu_ref.patch

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

mm-zswap-change-zswap_pool-kref-to-percpu_ref.patch
mm-zsmalloc-dont-need-to-reserve-lsb-in-handle.patch

