Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE301B3922;
	Tue, 18 Feb 2025 06:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739860846; cv=none; b=Fol8EH2nW/dmyME+X/wnlDAESbi/oiQW96kJdRWkVJW+DtUJtblJMlMAQOHHFwhCLjJsADT8MnPpMgeY1OhIC10D6u6X/8Oo2cY9xmRUbdhXVeuPpkGEUdCr3K3T8U8/TfAshKjTuYl/iU83LxVAC5Emxzka9m7Dgglo3xAAbfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739860846; c=relaxed/simple;
	bh=Yt4Bnl/mOMZkdILTiHb24V5CHhW/cmwAghYn/J1DJ6k=;
	h=Date:To:From:Subject:Message-Id; b=HAyJzvFcfUOZ3Y11wFrEIh1F3eOM54yRDhj4+NV3S8AWDI9Tq0FOJ2fywgzLJ2CJ//Q5AuWetEvCxAAk/Bls7sy0W3iu91AM34qMSV+gMvZ1uYAJPVU73nxeQLXjy+kgcF3jaeUCPhIjZamhNaGj/4ZIkFLwA4cE6DEyAZgtN4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rDN8UJ0c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rDN8UJ0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4413C4CEE6;
	Tue, 18 Feb 2025 06:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739860845;
	bh=Yt4Bnl/mOMZkdILTiHb24V5CHhW/cmwAghYn/J1DJ6k=;
	h=Date:To:From:Subject:From;
	b=rDN8UJ0cRT9Kg0cAEb1sIpCxi80C0o9C/cJDdD5KtyRSnfvDbp1qVzQcrkrMrCiO0
	 ZPx+JhOiJGKYjEJGER+ZzcMfqR5kLL4Dg9D0PyH9/pcAFBa429TbTSFdb5Lj79FApv
	 74nc0yWh1fupGnDK3r5EMHjHNS88JJDokOihrZIY=
Date: Mon, 17 Feb 2025 22:40:45 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,stable@vger.kernel.org,nphamcs@gmail.com,kanchana.p.sridhar@intel.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-zswap-fix-inconsistency-when-zswap_store_page-fails.patch removed from -mm tree
Message-Id: <20250218064045.A4413C4CEE6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: fix inconsistency when zswap_store_page() fails
has been removed from the -mm tree.  Its filename was
     mm-zswap-fix-inconsistency-when-zswap_store_page-fails.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm/zswap: fix inconsistency when zswap_store_page() fails
Date: Wed, 29 Jan 2025 19:08:44 +0900

Commit b7c0ccdfbafd ("mm: zswap: support large folios in zswap_store()")
skips charging any zswap entries when it failed to zswap the entire folio.

However, when some base pages are zswapped but it failed to zswap the
entire folio, the zswap operation is rolled back.  When freeing zswap
entries for those pages, zswap_entry_free() uncharges the zswap entries
that were not previously charged, causing zswap charging to become
inconsistent.

This inconsistency triggers two warnings with following steps:
  # On a machine with 64GiB of RAM and 36GiB of zswap
  $ stress-ng --bigheap 2 # wait until the OOM-killer kills stress-ng
  $ sudo reboot

  The two warnings are:
    in mm/memcontrol.c:163, function obj_cgroup_release():
      WARN_ON_ONCE(nr_bytes & (PAGE_SIZE - 1));

    in mm/page_counter.c:60, function page_counter_cancel():
      if (WARN_ONCE(new < 0, "page_counter underflow: %ld nr_pages=%lu\n",
	  new, nr_pages))

zswap_stored_pages also becomes inconsistent in the same way.

As suggested by Kanchana, increment zswap_stored_pages and charge zswap
entries within zswap_store_page() when it succeeds.  This way,
zswap_entry_free() will decrement the counter and uncharge the entries
when it failed to zswap the entire folio.

While this could potentially be optimized by batching objcg charging and
incrementing the counter, let's focus on fixing the bug this time and
leave the optimization for later after some evaluation.

After resolving the inconsistency, the warnings disappear.

[42.hyeyoo@gmail.com: refactor zswap_store_page()]
  Link: https://lkml.kernel.org/r/20250131082037.2426-1-42.hyeyoo@gmail.com
Link: https://lkml.kernel.org/r/20250129100844.2935-1-42.hyeyoo@gmail.com
Fixes: b7c0ccdfbafd ("mm: zswap: support large folios in zswap_store()")
Co-developed-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

--- a/mm/zswap.c~mm-zswap-fix-inconsistency-when-zswap_store_page-fails
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
@@ -1510,13 +1514,13 @@ static ssize_t zswap_store_page(struct p
 		zswap_lru_add(&zswap_list_lru, entry);
 	}
 
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
@@ -1526,7 +1530,6 @@ bool zswap_store(struct folio *folio)
 	struct obj_cgroup *objcg = NULL;
 	struct mem_cgroup *memcg = NULL;
 	struct zswap_pool *pool;
-	size_t compressed_bytes = 0;
 	bool ret = false;
 	long index;
 
@@ -1564,20 +1567,14 @@ bool zswap_store(struct folio *folio)
 
 	for (index = 0; index < nr_pages; ++index) {
 		struct page *page = folio_page(folio, index);
-		ssize_t bytes;
 
-		bytes = zswap_store_page(page, objcg, pool);
-		if (bytes < 0)
+		if (!zswap_store_page(page, objcg, pool))
 			goto put_pool;
-		compressed_bytes += bytes;
 	}
 
-	if (objcg) {
-		obj_cgroup_charge_zswap(objcg, compressed_bytes);
+	if (objcg)
 		count_objcg_events(objcg, ZSWPOUT, nr_pages);
-	}
 
-	atomic_long_add(nr_pages, &zswap_stored_pages);
 	count_vm_events(ZSWPOUT, nr_pages);
 
 	ret = true;
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are


