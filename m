Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500D43838F
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706596792; cv=none; b=SByPlCv6nl/u3je3PyjGpKixQJmrmhRqP1XwtgIh2eFR3KM4OjZuoP/ZL5zEm6FQR9AGp0KrwF6FmYeTeraoN+Oee9cEWKhqKTny3ILOh4/90x45i12J4VhfpBJG3RC0PcBAVHmxDwL51Orl0+N9ykbLGxU5AWScjXKvJMmfuYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706596792; c=relaxed/simple;
	bh=kHTgjzelzGGpOEI4/4sD9c1Zcmc5s1uIrwQr/0kv1RI=;
	h=Date:To:From:Subject:Message-Id; b=G0VWOK6JYM5BxxweR5LHbz9wEcn5kbljLn2F6DDomoYC8232HtGmtzub2sf+/N3rkxtO6VLpqz1aMaIuCUzVOXZxmswplOZyavv1dRGG85ub0ytjrp+HadC36HjTG91R43YLpG6EtPkBkS5jvJaMgNa+P0jZvFvvZDzO7OSgYaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ENvlw7eu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ENvlw7eu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6924C433C7;
	Tue, 30 Jan 2024 06:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706596791;
	bh=kHTgjzelzGGpOEI4/4sD9c1Zcmc5s1uIrwQr/0kv1RI=;
	h=Date:To:From:Subject:From;
	b=ENvlw7eu5Aoa+YJqgLPkJPVv8xGX+323ZVJUl1L3yDwQ+MQuRzqbCD4YM1/Z4Alnp
	 QnDPlowDRHozOVu/gWBIMFvMt9mkOr+Qgbhd0hRBqX8Wl06R1MoTRWDh8Q5e49kONu
	 5+DU4cTI32Qg8gujapkc9JDreolg8FMzSGG+FxiI=
Date: Mon, 29 Jan 2024 22:39:39 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-move-zswap_invalidate_entry-to-related-functions.patch added to mm-unstable branch
Message-Id: <20240130063950.B6924C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: move zswap_invalidate_entry() to related functions
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-move-zswap_invalidate_entry-to-related-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-move-zswap_invalidate_entry-to-related-functions.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: move zswap_invalidate_entry() to related functions
Date: Mon, 29 Jan 2024 20:36:39 -0500

Move it up to the other tree and refcounting functions.

Link: https://lkml.kernel.org/r/20240130014208.565554-4-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/mm/zswap.c~mm-zswap-move-zswap_invalidate_entry-to-related-functions
+++ a/mm/zswap.c
@@ -559,6 +559,18 @@ static void zswap_entry_put(struct zswap
 	}
 }
 
+/*
+ * If the entry is still valid in the tree, drop the initial ref and remove it
+ * from the tree. This function must be called with an additional ref held,
+ * otherwise it may race with another invalidation freeing the entry.
+ */
+static void zswap_invalidate_entry(struct zswap_tree *tree,
+				   struct zswap_entry *entry)
+{
+	if (zswap_rb_erase(&tree->rbroot, entry))
+		zswap_entry_put(entry);
+}
+
 /*********************************
 * shrinker functions
 **********************************/
@@ -809,18 +821,6 @@ static struct zswap_pool *zswap_pool_fin
 	return NULL;
 }
 
-/*
- * If the entry is still valid in the tree, drop the initial ref and remove it
- * from the tree. This function must be called with an additional ref held,
- * otherwise it may race with another invalidation freeing the entry.
- */
-static void zswap_invalidate_entry(struct zswap_tree *tree,
-				   struct zswap_entry *entry)
-{
-	if (zswap_rb_erase(&tree->rbroot, entry))
-		zswap_entry_put(entry);
-}
-
 static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_one *l,
 				       spinlock_t *lock, void *arg)
 {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-zswap-fix-objcg-use-after-free-in-entry-destruction.patch
mm-zswap-rename-zswap_free_entry-to-zswap_entry_free.patch
mm-zswap-inline-and-remove-zswap_entry_find_get.patch
mm-zswap-move-zswap_invalidate_entry-to-related-functions.patch
mm-zswap-warn-when-referencing-a-dead-entry.patch
mm-zswap-clean-up-zswap_entry_put.patch
mm-zswap-rename-__zswap_load-to-zswap_decompress.patch
mm-zswap-break-out-zwap_compress.patch
mm-zswap-further-cleanup-zswap_store.patch
mm-zswap-simplify-zswap_invalidate.patch
mm-zswap-function-ordering-pool-alloc-free.patch
mm-zswap-function-ordering-pool-refcounting.patch
mm-zswap-function-ordering-zswap_pools.patch
mm-zswap-function-ordering-pool-params.patch
mm-zswap-function-ordering-public-lru-api.patch
mm-zswap-function-ordering-move-entry-sections-out-of-lru-section.patch
mm-zswap-function-ordering-move-entry-section-out-of-tree-section.patch
mm-zswap-function-ordering-compress-decompress-functions.patch
mm-zswap-function-ordering-per-cpu-compression-infra.patch
mm-zswap-function-ordering-writeback.patch
mm-zswap-function-ordering-shrink_memcg_cb.patch

