Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B8B383B5
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706596820; cv=none; b=IENbcHoUwQIDHT4fTb7tTU0S2pS7mo0r8rhuCIhMwVJrnTPcvf018FU10PneIhxFcWvh80LszT0q3Af2BwWwweXE7fgtkwi9UrlsGfbteA7Yt5tVOK95QU3CLQoo4kepUUUUfiutPecVcaIgUCbhxd+coaQWAnbT3spWeRQEPDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706596820; c=relaxed/simple;
	bh=fDxF8KbvEwxVkToOSArghZot5hY40SxQf5KNCrqJqHI=;
	h=Date:To:From:Subject:Message-Id; b=NY2PmoF/JCkh1eVXy6bpXenuEXLKwzRp1MLOqcRiGuzChppG4XH4xOM7/XNtdphIn7g798dseVH+P/R8+kFhcirdbS7jdIVrqcW3PkBr4EnrGc3n1N4kMFypTDtdCQ5+iz+M81/PrMgnSIuTKgp2j1SHyTaS/FtMUlk/DpdVVIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0aw7RHBB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0aw7RHBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53183C433C7;
	Tue, 30 Jan 2024 06:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706596820;
	bh=fDxF8KbvEwxVkToOSArghZot5hY40SxQf5KNCrqJqHI=;
	h=Date:To:From:Subject:From;
	b=0aw7RHBB3ox+ZOikGU5szMaIcOAX89lBa6G7wdUP03AN+uPrxzGS7rh/pimeMh0ce
	 LiEot2MpuTmS5nnZdTf2wYkAyW5B4TySqAoYhs41JSikEtPrq+1hevJ2SmFM89nvXV
	 Na5DAR9cveWlSpqOubiIiedLZqDHJNsYXDg79E/M=
Date: Mon, 29 Jan 2024 22:40:07 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-clean-up-zswap_entry_put.patch added to mm-unstable branch
Message-Id: <20240130064019.53183C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: clean up zswap_entry_put()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-clean-up-zswap_entry_put.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-clean-up-zswap_entry_put.patch

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
Subject: mm: zswap: clean up zswap_entry_put()
Date: Mon, 29 Jan 2024 20:36:41 -0500

Remove stale comment and unnecessary local variable.

Link: https://lkml.kernel.org/r/20240130014208.565554-6-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/mm/zswap.c~mm-zswap-clean-up-zswap_entry_put
+++ a/mm/zswap.c
@@ -546,15 +546,11 @@ static void zswap_entry_get(struct zswap
 	entry->refcount++;
 }
 
-/* caller must hold the tree lock
-* remove from the tree and free it, if nobody reference the entry
-*/
+/* caller must hold the tree lock */
 static void zswap_entry_put(struct zswap_entry *entry)
 {
-	int refcount = --entry->refcount;
-
-	WARN_ON_ONCE(refcount < 0);
-	if (refcount == 0) {
+	WARN_ON_ONCE(!entry->refcount);
+	if (--entry->refcount == 0) {
 		WARN_ON_ONCE(!RB_EMPTY_NODE(&entry->rbnode));
 		zswap_entry_free(entry);
 	}
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

