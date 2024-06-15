Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F0F19D8A6
	for <mm-commits@vger.kernel.org>; Sat, 15 Jun 2024 02:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718419204; cv=none; b=QTuGUzD96wTfZVHv6DznhWTByHgZCQm3nNp/SPJXX9NBo8V44MjotdcU9il1lRB2u6s31gd0QuqISW/9oyVdZMIwcvCmxVgOP26Xso3rvB4XOHTj8sfk0Epfne4/bo6Yb5BH3AIcn8A81ktWlGu/Cejg0ViPS7BY8DvXebYLLl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718419204; c=relaxed/simple;
	bh=tRinRA08yEtjXHWlwF7h7afdvzMrmLHyc8npqKTydiA=;
	h=Date:To:From:Subject:Message-Id; b=jWF1LdRcSOMhUpQW9sFPImo/VJq+9PmVCdDTGvFjwZRxEQi+k3rlfssBVFIEgizTezxfrfB3WqfsEMQi6t2nWOiQw/L2kcqSfIyzkYqk7+fz1s45Y+PmVxMMomaMB5jRYgz1Zli0gZB6mQutpyrAmTmfdNn5mSYOVl2ZB6ALEAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SmbYlQTR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SmbYlQTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A3BC2BD10;
	Sat, 15 Jun 2024 02:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718419204;
	bh=tRinRA08yEtjXHWlwF7h7afdvzMrmLHyc8npqKTydiA=;
	h=Date:To:From:Subject:From;
	b=SmbYlQTRPrIJS8gWrqpj9WRucPbn8UM+rN3zwi4Bp9pG9W5HfPCd6V5BSCDy5ZKu+
	 w1hCIsoAEHSoEq00i7PZ2f2uUHDj80XpAW3CtiQYUvOc+MkbTv+R0CEvyqO8QLNy5M
	 Lzc6Iv57UltnlGR3NScT8TiWHbwMrQlN1kZKQUkA=
Date: Fri, 14 Jun 2024 19:40:03 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,shakeel.butt@linux.dev,nphamcs@gmail.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chengming.zhou@linux.dev,ak@linux.intel.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-code-to-handle-same-filled-pages.patch added to mm-unstable branch
Message-Id: <20240615024004.46A3BC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove code to handle same filled pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-code-to-handle-same-filled-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-code-to-handle-same-filled-pages.patch

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
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm: remove code to handle same filled pages
Date: Fri, 14 Jun 2024 11:07:06 +0100

With an earlier commit to handle zero-filled pages in swap directly, and
with only 1% of the same-filled pages being non-zero, zswap no longer
needs to handle same-filled pages and can just work on compressed pages.

Link: https://lkml.kernel.org/r/20240614100902.3469724-3-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   86 ++++-----------------------------------------------
 1 file changed, 8 insertions(+), 78 deletions(-)

--- a/mm/zswap.c~mm-remove-code-to-handle-same-filled-pages
+++ a/mm/zswap.c
@@ -44,8 +44,6 @@
 **********************************/
 /* The number of compressed pages currently stored in zswap */
 atomic_t zswap_stored_pages = ATOMIC_INIT(0);
-/* The number of same-value filled pages currently stored in zswap */
-static atomic_t zswap_same_filled_pages = ATOMIC_INIT(0);
 
 /*
  * The statistics below are not protected from concurrent access for
@@ -188,11 +186,9 @@ static struct shrinker *zswap_shrinker;
  *
  * swpentry - associated swap entry, the offset indexes into the red-black tree
  * length - the length in bytes of the compressed page data.  Needed during
- *          decompression. For a same value filled page length is 0, and both
- *          pool and lru are invalid and must be ignored.
+ *          decompression.
  * pool - the zswap_pool the entry's data is in
  * handle - zpool allocation handle that stores the compressed page data
- * value - value of the same-value filled pages which have same content
  * objcg - the obj_cgroup that the compressed memory is charged to
  * lru - handle to the pool's lru used to evict pages.
  */
@@ -200,10 +196,7 @@ struct zswap_entry {
 	swp_entry_t swpentry;
 	unsigned int length;
 	struct zswap_pool *pool;
-	union {
-		unsigned long handle;
-		unsigned long value;
-	};
+	unsigned long handle;
 	struct obj_cgroup *objcg;
 	struct list_head lru;
 };
@@ -820,13 +813,9 @@ static struct zpool *zswap_find_zpool(st
  */
 static void zswap_entry_free(struct zswap_entry *entry)
 {
-	if (!entry->length)
-		atomic_dec(&zswap_same_filled_pages);
-	else {
-		zswap_lru_del(&zswap_list_lru, entry);
-		zpool_free(zswap_find_zpool(entry), entry->handle);
-		zswap_pool_put(entry->pool);
-	}
+	zswap_lru_del(&zswap_list_lru, entry);
+	zpool_free(zswap_find_zpool(entry), entry->handle);
+	zswap_pool_put(entry->pool);
 	if (entry->objcg) {
 		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
 		obj_cgroup_put(entry->objcg);
@@ -1268,11 +1257,6 @@ static unsigned long zswap_shrinker_coun
 	 * This ensures that the better zswap compresses memory, the fewer
 	 * pages we will evict to swap (as it will otherwise incur IO for
 	 * relatively small memory saving).
-	 *
-	 * The memory saving factor calculated here takes same-filled pages into
-	 * account, but those are not freeable since they almost occupy no
-	 * space. Hence, we may scale nr_freeable down a little bit more than we
-	 * should if we have a lot of same-filled pages.
 	 */
 	return mult_frac(nr_freeable, nr_backing, nr_stored);
 }
@@ -1377,42 +1361,6 @@ resched:
 }
 
 /*********************************
-* same-filled functions
-**********************************/
-static bool zswap_is_folio_same_filled(struct folio *folio, unsigned long *value)
-{
-	unsigned long *data;
-	unsigned long val;
-	unsigned int pos, last_pos = PAGE_SIZE / sizeof(*data) - 1;
-	bool ret = false;
-
-	data = kmap_local_folio(folio, 0);
-	val = data[0];
-
-	if (val != data[last_pos])
-		goto out;
-
-	for (pos = 1; pos < last_pos; pos++) {
-		if (val != data[pos])
-			goto out;
-	}
-
-	*value = val;
-	ret = true;
-out:
-	kunmap_local(data);
-	return ret;
-}
-
-static void zswap_fill_folio(struct folio *folio, unsigned long value)
-{
-	unsigned long *data = kmap_local_folio(folio, 0);
-
-	memset_l(data, value, PAGE_SIZE / sizeof(unsigned long));
-	kunmap_local(data);
-}
-
-/*********************************
 * main API
 **********************************/
 bool zswap_store(struct folio *folio)
@@ -1423,7 +1371,6 @@ bool zswap_store(struct folio *folio)
 	struct zswap_entry *entry, *old;
 	struct obj_cgroup *objcg = NULL;
 	struct mem_cgroup *memcg = NULL;
-	unsigned long value;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
@@ -1456,13 +1403,6 @@ bool zswap_store(struct folio *folio)
 		goto reject;
 	}
 
-	if (zswap_is_folio_same_filled(folio, &value)) {
-		entry->length = 0;
-		entry->value = value;
-		atomic_inc(&zswap_same_filled_pages);
-		goto store_entry;
-	}
-
 	/* if entry is successfully added, it keeps the reference */
 	entry->pool = zswap_pool_current_get();
 	if (!entry->pool)
@@ -1480,7 +1420,6 @@ bool zswap_store(struct folio *folio)
 	if (!zswap_compress(folio, entry))
 		goto put_pool;
 
-store_entry:
 	entry->swpentry = swp;
 	entry->objcg = objcg;
 
@@ -1528,13 +1467,9 @@ store_entry:
 	return true;
 
 store_failed:
-	if (!entry->length)
-		atomic_dec(&zswap_same_filled_pages);
-	else {
-		zpool_free(zswap_find_zpool(entry), entry->handle);
+	zpool_free(zswap_find_zpool(entry), entry->handle);
 put_pool:
-		zswap_pool_put(entry->pool);
-	}
+	zswap_pool_put(entry->pool);
 freepage:
 	zswap_entry_cache_free(entry);
 reject:
@@ -1597,10 +1532,7 @@ bool zswap_load(struct folio *folio)
 	if (!entry)
 		return false;
 
-	if (entry->length)
-		zswap_decompress(entry, folio);
-	else
-		zswap_fill_folio(folio, entry->value);
+	zswap_decompress(entry, folio);
 
 	count_vm_event(ZSWPIN);
 	if (entry->objcg)
@@ -1703,8 +1635,6 @@ static int zswap_debugfs_init(void)
 			    zswap_debugfs_root, NULL, &total_size_fops);
 	debugfs_create_atomic_t("stored_pages", 0444,
 				zswap_debugfs_root, &zswap_stored_pages);
-	debugfs_create_atomic_t("same_filled_pages", 0444,
-				zswap_debugfs_root, &zswap_same_filled_pages);
 
 	return 0;
 }
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

mm-do-not-start-end-writeback-for-pages-stored-in-zswap.patch
mm-store-zero-pages-to-be-swapped-out-in-a-bitmap.patch
mm-remove-code-to-handle-same-filled-pages.patch

