Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E84E165F1D
	for <mm-commits@vger.kernel.org>; Fri, 31 Jan 2025 23:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738364500; cv=none; b=ThDssQAgAhqDLptyS3Ek2shQj7MURO3RxCrwvlIHIPC8GsZLuaGE/TSiUCrRUpgc5G9qODjMYIDP0q72pdDAwHa4Q6Gm0BS1GuffxIC6NsrNQTFWN9/RD+UZrBUNTNZxeJ+UvzHvqltHLS0r888GA9tHdfKyYKl3Fkkx80cQlkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738364500; c=relaxed/simple;
	bh=E2wLF2Rop4VQMGyqrPPZNVDLolwjW6X8AIqtM3MFXZk=;
	h=Date:To:From:Subject:Message-Id; b=jcL2PBRfZ3+rvHxitnRY5D8kjbCnYseyM4ThxqvtRkM7+Crvh5mQoQCp46e4dKnpsaPT/d4ngoSimxk6pW5Ti8GYFKssv6Dn49StjcLRtmJpogQ/sf9U6FiC1YHQfPYgH4n0YgLfgw4sV+ZQNJrqUvN1EdHeP41sePihrtbYp/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xJnGmspP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xJnGmspP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA79C4CED1;
	Fri, 31 Jan 2025 23:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738364499;
	bh=E2wLF2Rop4VQMGyqrPPZNVDLolwjW6X8AIqtM3MFXZk=;
	h=Date:To:From:Subject:From;
	b=xJnGmspPTK3OiB2cVcWsLenNjIAW8XyxnNLV7dE6FZcLLithHh/nfBKPHKqPktmss
	 8TQDXLwVSENo5u+T7YmN1TR56wU6Yf6rlReM6325lq24uXyxJl2+ftwATnt2QxT/G7
	 TSAoDi4iI43mTpT2qR/a5ZGJJXQbzLIAZwIa18d4=
Date: Fri, 31 Jan 2025 15:01:39 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,nphamcs@gmail.com,kanchana.p.sridhar@intel.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-fix-inconsistency-when-zswap_store_page-fails-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20250131230139.BEA79C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: refactor zswap_store_page()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-zswap-fix-inconsistency-when-zswap_store_page-fails-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-fix-inconsistency-when-zswap_store_page-fails-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm/zswap: refactor zswap_store_page()
Date: Fri, 31 Jan 2025 17:20:37 +0900

Change zswap_store_page() to return a boolean value, where true indicates
the page is successfully stored in zswap, and false otherwise.

Since zswap_store_page() no longer returns the size of the entry,
remove 'bytes' variable from zswap_store(), and jump to the put_pool label
when it fails.

Move the objcg charging and the incrementing of zswap_store_pages just
after the tree store is successful.  At that point, there's no chance of
failure, and the freeing path will certainly uncharge zswap memory and
decrement the counter.

Link: https://lkml.kernel.org/r/20250131082037.2426-1-42.hyeyoo@gmail.com
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

--- a/mm/zswap.c~mm-zswap-fix-inconsistency-when-zswap_store_page-fails-fix
+++ a/mm/zswap.c
@@ -1445,9 +1445,9 @@ resched:
 * main API
 **********************************/
 
-static ssize_t zswap_store_page(struct page *page,
-				struct obj_cgroup *objcg,
-				struct zswap_pool *pool)
+static bool zswap_store_page(struct page *page,
+			     struct obj_cgroup *objcg,
+			     struct zswap_pool *pool)
 {
 	swp_entry_t page_swpentry = page_swap_entry(page);
 	struct zswap_entry *entry, *old;
@@ -1456,7 +1456,7 @@ static ssize_t zswap_store_page(struct p
 	entry = zswap_entry_cache_alloc(GFP_KERNEL, page_to_nid(page));
 	if (!entry) {
 		zswap_reject_kmemcache_fail++;
-		return -EINVAL;
+		return false;
 	}
 
 	if (!zswap_compress(page, entry, pool))
@@ -1483,13 +1483,17 @@ static ssize_t zswap_store_page(struct p
 
 	/*
 	 * The entry is successfully compressed and stored in the tree, there is
-	 * no further possibility of failure. Grab refs to the pool and objcg.
-	 * These refs will be dropped by zswap_entry_free() when the entry is
-	 * removed from the tree.
+	 * no further possibility of failure. Grab refs to the pool and objcg,
+	 * charge zswap memory, and increment zswap_stored_pages.
+	 * The opposite actions will be performed by zswap_entry_free()
+	 * when the entry is removed from the tree.
 	 */
 	zswap_pool_get(pool);
-	if (objcg)
+	if (objcg) {
 		obj_cgroup_get(objcg);
+		obj_cgroup_charge_zswap(objcg, entry->length);
+	}
+	atomic_long_inc(&zswap_stored_pages);
 
 	/*
 	 * We finish initializing the entry while it's already in xarray.
@@ -1504,22 +1508,19 @@ static ssize_t zswap_store_page(struct p
 	entry->pool = pool;
 	entry->swpentry = page_swpentry;
 	entry->objcg = objcg;
-	if (objcg)
-		obj_cgroup_charge_zswap(objcg, entry->length);
 	entry->referenced = true;
 	if (entry->length) {
 		INIT_LIST_HEAD(&entry->lru);
 		zswap_lru_add(&zswap_list_lru, entry);
 	}
-	atomic_long_inc(&zswap_stored_pages);
 
-	return entry->length;
+	return true;
 
 store_failed:
 	zpool_free(pool->zpool, entry->handle);
 compress_failed:
 	zswap_entry_cache_free(entry);
-	return -EINVAL;
+	return false;
 }
 
 bool zswap_store(struct folio *folio)
@@ -1566,10 +1567,8 @@ bool zswap_store(struct folio *folio)
 
 	for (index = 0; index < nr_pages; ++index) {
 		struct page *page = folio_page(folio, index);
-		ssize_t bytes;
 
-		bytes = zswap_store_page(page, objcg, pool);
-		if (bytes < 0)
+		if (!zswap_store_page(page, objcg, pool))
 			goto put_pool;
 	}
 
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are

mm-zsmalloc-add-__maybe_unused-attribute-for-is_first_zpdesc.patch
mm-zswap-fix-inconsistency-when-zswap_store_page-fails.patch
mm-zswap-fix-inconsistency-when-zswap_store_page-fails-fix.patch

