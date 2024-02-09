Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6484439AC7
	for <mm-commits@vger.kernel.org>; Fri,  9 Feb 2024 22:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707517069; cv=none; b=uN4ZSJf651PaKcVyT6m02qaEh+gom8Oiam2Kq0ASmddST44+665DdUd9bImc3tvmgwbkwbwQ3kkLoDFe/iTrBgJ9z74kmZC1F9DdiBaaIP4NRRUZIXSkPqrADonC/UU6lMz61p9H3K0egpbVxbk9Bc/EieF0Tx8nokUkzILLeiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707517069; c=relaxed/simple;
	bh=1cDXtA0qzXb8OQKkFTia/9d6B0WtyNNBCR6xuIpxF28=;
	h=Date:To:From:Subject:Message-Id; b=nH+hc2mrUFJQSdbUIyr5qR0c2ePoBi1mgnmt31OyY4O4cfwsLD+0ER8kp90Ikz4jQv8P58U4YD9DhZieJ7KgYlx48szwE81G/kmImkdAC11EkAYOD7eVs+fmLdZOhGzCCvx41GsaAoRTV0EixdCvNxMnPyit8WCfz7Kl2ko9rUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BxDktf1L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BxDktf1L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC66FC433F1;
	Fri,  9 Feb 2024 22:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707517068;
	bh=1cDXtA0qzXb8OQKkFTia/9d6B0WtyNNBCR6xuIpxF28=;
	h=Date:To:From:Subject:From;
	b=BxDktf1L+/7TNqg91KVnaRwDm9iUlczkBpn2bwPvlk+ZYkGXkWIfKETcpM2fXGJes
	 j3rxNnAPfA+icQCWjupfeiF8dA0VRcDByjaz6CApqR1JahqJZT/1Lbowsd6VSRcT0I
	 0QLYQ3eD/6XYWV2+crsALCLpaosHsNNdlHH8hcPI=
Date: Fri, 09 Feb 2024 14:17:48 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,chrisl@kernel.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-optimize-and-cleanup-the-invalidation-of-duplicate-entry.patch added to mm-unstable branch
Message-Id: <20240209221748.AC66FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: optimize and cleanup the invalidation of duplicate entry
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-optimize-and-cleanup-the-invalidation-of-duplicate-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-optimize-and-cleanup-the-invalidation-of-duplicate-entry.patch

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
Subject: mm/zswap: optimize and cleanup the invalidation of duplicate entry
Date: Fri, 9 Feb 2024 04:41:12 +0000

We may encounter duplicate entry in the zswap_store():

1. swap slot that freed to per-cpu swap cache, doesn't invalidate
   the zswap entry, then got reused. This has been fixed.

2. !exclusive load mode, swapin folio will leave its zswap entry
   on the tree, then swapout again. This has been removed.

3. one folio can be dirtied again after zswap_store(), so need to
   zswap_store() again. This should be handled correctly.

So we must invalidate the old duplicate entry before inserting the
new one, which actually doesn't have to be done at the beginning
of zswap_store().

The good point is that we don't need to lock the tree twice in the normal
store success path.  And cleanup the loop as we are here.

Note we still need to invalidate the old duplicate entry when store failed
or zswap is disabled , otherwise the new data in swapfile could be
overwrite by the old data in zswap pool when lru writeback.

Link: https://lkml.kernel.org/r/20240209044112.3883835-1-chengming.zhou@linux.dev
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

--- a/mm/zswap.c~mm-zswap-optimize-and-cleanup-the-invalidation-of-duplicate-entry
+++ a/mm/zswap.c
@@ -1517,19 +1517,8 @@ bool zswap_store(struct folio *folio)
 	if (folio_test_large(folio))
 		return false;
 
-	/*
-	 * If this is a duplicate, it must be removed before attempting to store
-	 * it, otherwise, if the store fails the old page won't be removed from
-	 * the tree, and it might be written back overriding the new data.
-	 */
-	spin_lock(&tree->lock);
-	entry = zswap_rb_search(&tree->rbroot, offset);
-	if (entry)
-		zswap_invalidate_entry(tree, entry);
-	spin_unlock(&tree->lock);
-
 	if (!zswap_enabled)
-		return false;
+		goto check_old;
 
 	objcg = get_obj_cgroup_from_folio(folio);
 	if (objcg && !obj_cgroup_may_zswap(objcg)) {
@@ -1609,14 +1598,12 @@ insert_entry:
 	/* map */
 	spin_lock(&tree->lock);
 	/*
-	 * A duplicate entry should have been removed at the beginning of this
-	 * function. Since the swap entry should be pinned, if a duplicate is
-	 * found again here it means that something went wrong in the swap
-	 * cache.
+	 * The folio may have been dirtied again, invalidate the
+	 * possibly stale entry before inserting the new entry.
 	 */
-	while (zswap_rb_insert(&tree->rbroot, entry, &dupentry) == -EEXIST) {
-		WARN_ON(1);
+	if (zswap_rb_insert(&tree->rbroot, entry, &dupentry) == -EEXIST) {
 		zswap_invalidate_entry(tree, dupentry);
+		WARN_ON(zswap_rb_insert(&tree->rbroot, entry, &dupentry));
 	}
 	if (entry->length) {
 		INIT_LIST_HEAD(&entry->lru);
@@ -1639,6 +1626,17 @@ freepage:
 reject:
 	if (objcg)
 		obj_cgroup_put(objcg);
+check_old:
+	/*
+	 * If the zswap store fails or zswap is disabled, we must invalidate the
+	 * possibly stale entry which was previously stored at this offset.
+	 * Otherwise, writeback could overwrite the new data in the swapfile.
+	 */
+	spin_lock(&tree->lock);
+	entry = zswap_rb_search(&tree->rbroot, offset);
+	if (entry)
+		zswap_invalidate_entry(tree, entry);
+	spin_unlock(&tree->lock);
 	return false;
 
 shrink:
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zswap-invalidate-duplicate-entry-when-zswap_enabled.patch
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
mm-zswap-optimize-and-cleanup-the-invalidation-of-duplicate-entry.patch

