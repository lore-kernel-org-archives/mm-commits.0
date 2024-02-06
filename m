Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4FE639
	for <mm-commits@vger.kernel.org>; Tue,  6 Feb 2024 00:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707178527; cv=none; b=jxp5UKxYOyCWkD6nrMVhcjOBI7Ib926MtiJ0xhgLZ6goTaPvF1H2KcWLS59HPLuLMv4AoBnBTVDsSNbXQlG4UwiyXDqE78kRp89kuPJYi6yX256EC1Jtz3y99zNnZhgzzBYc3ZhtO7nY/NJ89KsBbP346w4/nwIK5BqQZOsBeP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707178527; c=relaxed/simple;
	bh=upeCHI3Kpqf0KOiXmKSV843J7zvB/KLRmCHGJbQ0NL4=;
	h=Date:To:From:Subject:Message-Id; b=PrSaoOjWsirqtZorfafCj0UWirqaZ/fu8J8XDrBTzUweRSyBjOdyiTDSG1et1rSqtBDoH5ZW+iM5kAZhmZYrOQA1OjEiOftpyComoae7RzxGOauhPByS6Xh0OiwTvkrysqqE/CKyYWXd7puha/2/aXVor6+/96K8pIAD04h7W5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YTDY+hh6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YTDY+hh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BEDC43390;
	Tue,  6 Feb 2024 00:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707178526;
	bh=upeCHI3Kpqf0KOiXmKSV843J7zvB/KLRmCHGJbQ0NL4=;
	h=Date:To:From:Subject:From;
	b=YTDY+hh6jbrsZk4g5x0UlyLrRtFtKV4WQJfbkSkqkNdQlQ/VhN26HAybi2+peLCfU
	 iLnLdazei6e6Sexa5QGJZL2ykKb/voBLi4PHUph6mHj3CdglbhzjePKsomJqbbG0AW
	 NOZg292z3h0eRkLT4kgrbTgKqSVT0NzJFP8GZHpY=
Date: Mon, 05 Feb 2024 16:15:26 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-remove-duplicate_entry-debug-value.patch added to mm-unstable branch
Message-Id: <20240206001526.B6BEDC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: remove duplicate_entry debug value
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-remove-duplicate_entry-debug-value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-remove-duplicate_entry-debug-value.patch

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
@@ -1571,10 +1569,8 @@ bool zswap_store(struct folio *folio)
 	 */
 	spin_lock(&tree->lock);
 	entry = zswap_rb_search(&tree->rbroot, offset);
-	if (entry) {
+	if (entry)
 		zswap_invalidate_entry(tree, entry);
-		zswap_duplicate_entry++;
-	}
 	spin_unlock(&tree->lock);
 	objcg = get_obj_cgroup_from_folio(folio);
 	if (objcg && !obj_cgroup_may_zswap(objcg)) {
@@ -1661,7 +1657,6 @@ insert_entry:
 	 */
 	while (zswap_rb_insert(&tree->rbroot, entry, &dupentry) == -EEXIST) {
 		WARN_ON(1);
-		zswap_duplicate_entry++;
 		zswap_invalidate_entry(tree, dupentry);
 	}
 	if (entry->length) {
@@ -1822,8 +1817,6 @@ static int zswap_debugfs_init(void)
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

mm-zswap-dont-return-lru_skip-if-we-have-dropped-lru-lock.patch
mm-zswap-make-sure-each-swapfile-always-have-zswap-rb-tree.patch
mm-zswap-split-zswap-rb-tree.patch
mm-zswap-fix-race-between-lru-writeback-and-swapoff.patch
mm-list_lru-remove-list_lru_putback.patch
mm-zswap-add-more-comments-in-shrink_memcg_cb.patch
mm-zswap-invalidate-zswap-entry-when-swap-entry-free.patch
mm-zswap-stop-lru-list-shrinking-when-encounter-warm-region.patch
mm-zswap-remove-duplicate_entry-debug-value.patch
mm-zswap-only-support-zswap_exclusive_loads_enabled.patch
mm-zswap-zswap-entry-doesnt-need-refcount-anymore.patch

