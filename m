Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660B21CDA2F
	for <mm-commits@vger.kernel.org>; Tue,  1 Oct 2024 22:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727820798; cv=none; b=HbPJioKG1R4Fd41xn/vAXq581qoQwj37Xr86d4SUoFDO73s+XjgoW9cNVAQNZ9gzuSB6FlRr16IqmuvJIlDuy8zD2ljAFG5DMMCXsct1yYdJ52nvMNlEH+G7gNQE4VDsDBgbGfy+YuOFfpBC5CsMpK1Afk9Wu/+DHNaeLBQJIZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727820798; c=relaxed/simple;
	bh=hhqlbcdkWfFBWgkJLVg4Q52RRhEbSHhzTuQoD8v5W1c=;
	h=Date:To:From:Subject:Message-Id; b=dDLH0zaAIMMmlYnvWolBYIMVxWKIDU3N1yWC0WEamtmxc87uXLQqayw1i38uIoXhGd3zPFdx9pILBb1kGmnkAnNGHT+BIZsKlkD1yH9Cu+Ec3lXyTMho1147H6NoQB9e0mKnpCLuwME+wlUsIyWZB7CCISe0AuBgU7J9Fszw37g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z2e82QOp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z2e82QOp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC3AFC4CEC6;
	Tue,  1 Oct 2024 22:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727820797;
	bh=hhqlbcdkWfFBWgkJLVg4Q52RRhEbSHhzTuQoD8v5W1c=;
	h=Date:To:From:Subject:From;
	b=z2e82QOphLcWuJsFffj/fw5ruSuuO90ERFUoPAvnL/o9S6r1bdPxQqEPncFVkHL65
	 I4DQ/ElDfaTrKqx39s6TEvtIkIQlm5WPCTRWNZ8r5P1M7T008B14tZPZ2/WfjGWR5m
	 eSISwiXbInAWbKMdOAZwwRd7lZFl55zMo8ubkiUo=
Date: Tue, 01 Oct 2024 15:13:17 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,wajdi.k.feghali@intel.com,usamaarif642@gmail.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,nphamcs@gmail.com,nanhai.zou@intel.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,kanchana.p.sridhar@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-rename-zswap_pool_get-to-zswap_pool_tryget.patch added to mm-unstable branch
Message-Id: <20241001221317.DC3AFC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: rename zswap_pool_get() to zswap_pool_tryget().
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-rename-zswap_pool_get-to-zswap_pool_tryget.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-rename-zswap_pool_get-to-zswap_pool_tryget.patch

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
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Subject: mm: zswap: rename zswap_pool_get() to zswap_pool_tryget().
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/zswap.c~mm-zswap-rename-zswap_pool_get-to-zswap_pool_tryget
+++ a/mm/zswap.c
@@ -403,7 +403,7 @@ static void __zswap_pool_empty(struct pe
 	spin_unlock_bh(&zswap_pools_lock);
 }
 
-static int __must_check zswap_pool_get(struct zswap_pool *pool)
+static int __must_check zswap_pool_tryget(struct zswap_pool *pool)
 {
 	if (!pool)
 		return 0;
@@ -441,7 +441,7 @@ static struct zswap_pool *zswap_pool_cur
 	rcu_read_lock();
 
 	pool = __zswap_pool_current();
-	if (!zswap_pool_get(pool))
+	if (!zswap_pool_tryget(pool))
 		pool = NULL;
 
 	rcu_read_unlock();
@@ -462,7 +462,7 @@ static struct zswap_pool *zswap_pool_fin
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

mm-define-obj_cgroup_get-if-config_memcg-is-not-defined.patch
mm-zswap-modify-zswap_compress-to-accept-a-page-instead-of-a-folio.patch
mm-zswap-rename-zswap_pool_get-to-zswap_pool_tryget.patch
mm-change-count_objcg_event-to-count_objcg_events-for-batch-event-updates.patch
mm-zswap-modify-zswap_stored_pages-to-be-atomic_long_t.patch
mm-zswap-support-large-folios-in-zswap_store.patch
mm-swap-count-successful-large-folio-zswap-stores-in-hugepage-zswpout-stats.patch

