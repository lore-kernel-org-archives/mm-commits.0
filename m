Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866084C61
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706596546; cv=none; b=ukY00NZ2i5z/JVV7f3HkJh6VT8GeN2biBWquM2EUhcSJw1FJu+MkrCKyewZvbOi3lYHyEp7M4+lBuOIWQ8mf3z3GWMsQA9c/OmAGgUXSSSUkaemt030j5+Eu7X2fJhmJJ5iMtTY0vLppPUx0Geeoi/MxGx8X3QudwJEdv2C/E7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706596546; c=relaxed/simple;
	bh=AV7Rb04QQYyWQWiT1QihDbhOczvwQEOV8PUG/zb8XyM=;
	h=Date:To:From:Subject:Message-Id; b=hLfOTLM139ZB6v+76u4Rq30CgXZMWeocC1FANaH2tq+udAiPDfYWDbgOqpcsaZA/DrAL92vVQDFGgrPwrlqibpndAiaYYkLAYBncslf8VLZHrY1Rgbf7MddCmXe2uz1yTvkTupluTYIhL/8tu89GBQVj2nUeOzYPiYpNTVJq++Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yk916BoV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yk916BoV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4784CC433C7;
	Tue, 30 Jan 2024 06:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706596546;
	bh=AV7Rb04QQYyWQWiT1QihDbhOczvwQEOV8PUG/zb8XyM=;
	h=Date:To:From:Subject:From;
	b=yk916BoVyAy8GOyS9Ob4UV0K0eYEbQ+QAR2kZ/O0mRzpsiAmXAafSyCgN6oyORNqP
	 9ru/Dv6vD7F0BTSN2d3/27u6250EFdUqo7Jpn4xEN3por9k/MasUEmJE6pPmG7irHt
	 SjlAxK2NT6o3Z74gyImkMgw5BH6U/1OJlPcgsBRM=
Date: Mon, 29 Jan 2024 22:35:26 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-fix-objcg-use-after-free-in-entry-destruction.patch added to mm-hotfixes-unstable branch
Message-Id: <20240130063544.4784CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: fix objcg use-after-free in entry destruction
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-zswap-fix-objcg-use-after-free-in-entry-destruction.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-fix-objcg-use-after-free-in-entry-destruction.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: fix objcg use-after-free in entry destruction
Date: Mon, 29 Jan 2024 20:34:38 -0500

In the per-memcg LRU universe, LRU removal uses entry->objcg to determine
which list count needs to be decreased.  Drop the objcg reference after
updating the LRU, to fix a possible use-after-free.

Link: https://lkml.kernel.org/r/20240130013438.565167-1-hannes@cmpxchg.org
Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/zswap.c~mm-zswap-fix-objcg-use-after-free-in-entry-destruction
+++ a/mm/zswap.c
@@ -536,10 +536,6 @@ static struct zpool *zswap_find_zpool(st
  */
 static void zswap_free_entry(struct zswap_entry *entry)
 {
-	if (entry->objcg) {
-		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
-		obj_cgroup_put(entry->objcg);
-	}
 	if (!entry->length)
 		atomic_dec(&zswap_same_filled_pages);
 	else {
@@ -548,6 +544,10 @@ static void zswap_free_entry(struct zswa
 		atomic_dec(&entry->pool->nr_stored);
 		zswap_pool_put(entry->pool);
 	}
+	if (entry->objcg) {
+		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
+		obj_cgroup_put(entry->objcg);
+	}
 	zswap_entry_cache_free(entry);
 	atomic_dec(&zswap_stored_pages);
 	zswap_update_total_size();
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

