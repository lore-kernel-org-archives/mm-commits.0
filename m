Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA3E16C684
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854748; cv=none; b=nxwqZ0VoKr9d0UAqngpztZ65wlAZYDpXFA8f1BEZw3+/otWgCRERiFujCdRVU4c/EBAWLD4n7lfTV9DGKgdjChb/y2Q5wWxQm2Rm4GebDkUrWs/XflQFr+sk9dAu+U2D7YweOk4pYohhwMzRZALiDwsW+I7DzqDivqSgoALf68Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854748; c=relaxed/simple;
	bh=R5wS1YJutdxCJz8WDUeRa8m5VyjvpEjE62TUotKhMJo=;
	h=Date:To:From:Subject:Message-Id; b=lhwwEBAO4Es8j0fRkzecNhM3WKyY+C7U4xNFdqnW41DlgV/bWJTG324yADJQX8EHNqACmKZRLuweefhAcoTqB6oDS6S+6TYXbCqz62qaIPgknbNxKwprOPL3edVo6tnezBCFGbnv7s9FRwKsk+xsdWZCXGKgQ0AB7OiDOYKtn5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X+8BW9KF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X+8BW9KF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1310C4CECF;
	Wed,  6 Nov 2024 00:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854748;
	bh=R5wS1YJutdxCJz8WDUeRa8m5VyjvpEjE62TUotKhMJo=;
	h=Date:To:From:Subject:From;
	b=X+8BW9KFt+TysUJm/kunrLnXMYqgKShiXDg9pIBjYUCBUxKxkBv5BCfOb+B7QfVBC
	 eJH3ajadsnY2WHm4pZeB/XegldM2Jj3f2oFrp2FMovm/I8x2MH8tNPAwm1tpOOIZOe
	 zaQRrKgHIVv1T5QnXdTXbF/ukRGlVCspt3IzBcKk=
Date: Tue, 05 Nov 2024 16:59:08 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,wajdi.k.feghali@intel.com,usamaarif642@gmail.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,nphamcs@gmail.com,nanhai.zou@intel.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,21cnbao@gmail.com,kanchana.p.sridhar@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-rename-zswap_pool_get-to-zswap_pool_tryget.patch removed from -mm tree
Message-Id: <20241106005908.B1310C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: rename zswap_pool_get() to zswap_pool_tryget()
has been removed from the -mm tree.  Its filename was
     mm-zswap-rename-zswap_pool_get-to-zswap_pool_tryget.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Subject: mm: zswap: rename zswap_pool_get() to zswap_pool_tryget()
Date: Mon, 30 Sep 2024 22:32:18 -0700

Modify the name of the existing zswap_pool_get() to zswap_pool_tryget() to
be representative of the call it makes to percpu_ref_tryget().  A
subsequent patch will introduce a new zswap_pool_get() that calls
percpu_ref_get().

The intent behind this change is for higher level zswap API such as
zswap_store() to call zswap_pool_tryget() to check upfront if the pool's
refcount is "0" (which means it could be getting destroyed) and to handle
this as an error condition.  zswap_store() would proceed only if
zswap_pool_tryget() returns success, and any additional pool refcounts
that need to be obtained for compressing sub-pages in a large folio could
simply call zswap_pool_get().

Link: https://lkml.kernel.org/r/20241001053222.6944-4-kanchana.p.sridhar@intel.com
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Wajdi Feghali <wajdi.k.feghali@intel.com>
Cc: "Zou, Nanhai" <nanhai.zou@intel.com>
Cc: Barry Song <21cnbao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/zswap.c~mm-zswap-rename-zswap_pool_get-to-zswap_pool_tryget
+++ a/mm/zswap.c
@@ -402,7 +402,7 @@ static void __zswap_pool_empty(struct pe
 	spin_unlock_bh(&zswap_pools_lock);
 }
 
-static int __must_check zswap_pool_get(struct zswap_pool *pool)
+static int __must_check zswap_pool_tryget(struct zswap_pool *pool)
 {
 	if (!pool)
 		return 0;
@@ -440,7 +440,7 @@ static struct zswap_pool *zswap_pool_cur
 	rcu_read_lock();
 
 	pool = __zswap_pool_current();
-	if (!zswap_pool_get(pool))
+	if (!zswap_pool_tryget(pool))
 		pool = NULL;
 
 	rcu_read_unlock();
@@ -461,7 +461,7 @@ static struct zswap_pool *zswap_pool_fin
 		if (strcmp(zpool_get_type(pool->zpool), type))
 			continue;
 		/* if we can't get it, it's about to be destroyed */
-		if (!zswap_pool_get(pool))
+		if (!zswap_pool_tryget(pool))
 			continue;
 		return pool;
 	}
_

Patches currently in -mm which might be from kanchana.p.sridhar@intel.com are


