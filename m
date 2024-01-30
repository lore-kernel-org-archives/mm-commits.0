Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FBD4500D
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706596835; cv=none; b=Gu9orgIACe/AOCLJjDA0WDajxJG6alveALWnlG/O66KvOHlsEwaqd4NxQN9amwICdlU1qhmTHshUMq8pvHu/4Dzu3KpiWJp0ovsm0YH01aF511drGC57MM69sBNSj9b0U0UjWxzKDp/IP+OTfTe3nhbNQlxwQJ2cz6YU8mlZztc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706596835; c=relaxed/simple;
	bh=X+Ns23AHWHNsksx5e4G8QQmBM0odZ8hrx9AN/pno3LQ=;
	h=Date:To:From:Subject:Message-Id; b=GDOFXnPieW4IX4WV3cXV9nEKFE5qA+TtScdF8sNyklJEnhO8UILxB1k9rnFJrNEKRDEYr2T/cICgBBo8o7jV7FeReIoq4GJGB6TKcKcaWZ3MLuPs8f+4CaZLNCBCwySs10KbwOlyHOMTgRM5t42CA74e28q2uVNWPx7sxlvJK+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ebX1baq8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ebX1baq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC256C433C7;
	Tue, 30 Jan 2024 06:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706596835;
	bh=X+Ns23AHWHNsksx5e4G8QQmBM0odZ8hrx9AN/pno3LQ=;
	h=Date:To:From:Subject:From;
	b=ebX1baq8op4W6rJuzSh4FXhUEmCjO0TyVTkTZMLeSy5K6durp+YQjpxJLrsV22Igz
	 ALSHPkgtQ9Qa+oenMFkVM/RQziLXfa0SqqlZ9PiZazMo8y6eCDcXpC+XNHWmWXht9x
	 PFNRWGDAyvhUGxirpO3rKZsBNpZXaAciO82aOXGU=
Date: Mon, 29 Jan 2024 22:40:21 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-rename-__zswap_load-to-zswap_decompress.patch added to mm-unstable branch
Message-Id: <20240130064033.DC256C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: rename __zswap_load() to zswap_decompress()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-rename-__zswap_load-to-zswap_decompress.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-rename-__zswap_load-to-zswap_decompress.patch

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
Subject: mm: zswap: rename __zswap_load() to zswap_decompress()
Date: Mon, 29 Jan 2024 20:36:42 -0500

Link: https://lkml.kernel.org/r/20240130014208.565554-7-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/zswap.c~mm-zswap-rename-__zswap_load-to-zswap_decompress
+++ a/mm/zswap.c
@@ -1316,7 +1316,7 @@ static int zswap_enabled_param_set(const
 	return ret;
 }
 
-static void __zswap_load(struct zswap_entry *entry, struct page *page)
+static void zswap_decompress(struct zswap_entry *entry, struct page *page)
 {
 	struct zpool *zpool = zswap_find_zpool(entry);
 	struct scatterlist input, output;
@@ -1411,7 +1411,7 @@ static int zswap_writeback_entry(struct
 	zswap_entry_get(entry);
 	spin_unlock(&tree->lock);
 
-	__zswap_load(entry, &folio->page);
+	zswap_decompress(entry, &folio->page);
 
 	count_vm_event(ZSWPWB);
 	if (entry->objcg)
@@ -1702,7 +1702,7 @@ bool zswap_load(struct folio *folio)
 	spin_unlock(&tree->lock);
 
 	if (entry->length)
-		__zswap_load(entry, page);
+		zswap_decompress(entry, page);
 	else {
 		dst = kmap_local_page(page);
 		zswap_fill_page(dst, entry->value);
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

