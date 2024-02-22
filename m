Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7A9320B
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560196; cv=none; b=qSJoqYKy3slLzCx/781HQoooQEyIGb2jfiVrT7sAONLSdXTNG+HGZPhiRsnzNKY0uNG9ipC+KtbsMpAMAmhX0LqjdaLiwdJnvDxVe3FnhwryJ6mHyjC0XC7A/9n+H3aLtX6S3l9ilkmGaZXmh7fVh/6aHPIQwfRocG2UPwaat5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560196; c=relaxed/simple;
	bh=/zDJ92hrwiZiTTaxEABik4p4D7Ro6caolY4gycSjLJo=;
	h=Date:To:From:Subject:Message-Id; b=C6fLvh4DboCDVQFcOw3lrrzdf7aF51/G8lH5LWqjn8L4kZ+8sm/c0GTUlIixiua0opvyzWMIIAXcP1AJ2TC+CErinYmFXAKSl7uPTZPHWZfs/uFUb/TVMPIEIkhx9MJ3ug+/tkGNbqIi53wthPitYB4PUVJXxSNOasuYrqBZ1Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=euDkrpO3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="euDkrpO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F48C43390;
	Thu, 22 Feb 2024 00:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560196;
	bh=/zDJ92hrwiZiTTaxEABik4p4D7Ro6caolY4gycSjLJo=;
	h=Date:To:From:Subject:From;
	b=euDkrpO3kK//fff2pk3sJDDHnrvSTEfHiupf6hLGGLesZdYR8WSYP1vCGifAM2CCk
	 G2OgePI//aLuadornw/b02k7rOj3xRNH3SDvaWPG2XE9+/EezsFQENByAFj1novRrg
	 6cMrS6FGvPIYAlv1hbb8Xm1W9W/LY6dlP6ZkxE6g=
Date: Wed, 21 Feb 2024 16:03:16 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-remove-duplicate_entry-debug-value.patch removed from -mm tree
Message-Id: <20240222000316.B0F48C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: remove duplicate_entry debug value
has been removed from the -mm tree.  Its filename was
     mm-zswap-remove-duplicate_entry-debug-value.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zswap: remove duplicate_entry debug value
Date: Sun, 04 Feb 2024 03:06:02 +0000

cat /sys/kernel/debug/zswap/duplicate_entry
2086447

When testing, the duplicate_entry value is very high, but no warning
message in the kernel log.  From the comment of duplicate_entry "Duplicate
store was encountered (rare)", it seems something goes wrong.

Actually it's incremented in the beginning of zswap_store(), which found
its zswap entry has already on the tree.  And this is a normal case, since
the folio could leave zswap entry on the tree after swapin, later it's
dirtied and swapout/zswap_store again, found its original zswap entry.

So duplicate_entry should be only incremented in the real bug case, which
already have "WARN_ON(1)", it looks redundant to count bug case, so this
patch just remove it.

Link: https://lkml.kernel.org/r/20240201-b4-zswap-invalidate-entry-v2-4-99d4084260a0@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/mm/zswap.c~mm-zswap-remove-duplicate_entry-debug-value
+++ a/mm/zswap.c
@@ -71,8 +71,6 @@ static u64 zswap_reject_compress_poor;
 static u64 zswap_reject_alloc_fail;
 /* Store failed because the entry metadata could not be allocated (rare) */
 static u64 zswap_reject_kmemcache_fail;
-/* Duplicate store was encountered (rare) */
-static u64 zswap_duplicate_entry;
 
 /* Shrinker work queue */
 static struct workqueue_struct *shrink_wq;
@@ -1568,10 +1566,8 @@ bool zswap_store(struct folio *folio)
 	 */
 	spin_lock(&tree->lock);
 	entry = zswap_rb_search(&tree->rbroot, offset);
-	if (entry) {
+	if (entry)
 		zswap_invalidate_entry(tree, entry);
-		zswap_duplicate_entry++;
-	}
 	spin_unlock(&tree->lock);
 
 	if (!zswap_enabled)
@@ -1662,7 +1658,6 @@ insert_entry:
 	 */
 	while (zswap_rb_insert(&tree->rbroot, entry, &dupentry) == -EEXIST) {
 		WARN_ON(1);
-		zswap_duplicate_entry++;
 		zswap_invalidate_entry(tree, dupentry);
 	}
 	if (entry->length) {
@@ -1823,8 +1818,6 @@ static int zswap_debugfs_init(void)
 			   zswap_debugfs_root, &zswap_reject_compress_poor);
 	debugfs_create_u64("written_back_pages", 0444,
 			   zswap_debugfs_root, &zswap_written_back_pages);
-	debugfs_create_u64("duplicate_entry", 0444,
-			   zswap_debugfs_root, &zswap_duplicate_entry);
 	debugfs_create_u64("pool_total_size", 0444,
 			   zswap_debugfs_root, &zswap_pool_total_size);
 	debugfs_create_atomic_t("stored_pages", 0444,
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zsmalloc-fix-migrate_write_lock-when-config_compaction.patch
mm-zsmalloc-remove-migrate_write_lock_nested.patch
mm-zsmalloc-remove-unused-zspage-isolated.patch
mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools.patch
mm-zswap-change-zswap_pool-kref-to-percpu_ref.patch
mm-zsmalloc-remove-set_zspage_mapping.patch
mm-zsmalloc-remove_zspage-dont-need-fullness-parameter.patch
mm-zsmalloc-remove-get_zspage_mapping.patch
maintainers-add-chengming-zhou-as-a-zswap-reviewer.patch

