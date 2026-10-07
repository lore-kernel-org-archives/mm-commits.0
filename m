Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F0032860B
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334384; cv=none; b=KyFnBvmjDECaRZxtsBgWduA/RikOrEZODJ/bA/qUHQhgzGxAoVHMFClOGerklKwYnQ4Vmf1feZKHkEO3LAjGf/KGc0NPhYtd8nR3GVoKCnaXIDqkPct6/SFV19wbmqKV+DzCHVHWUbq+nDkBSouLGB76Im2GUjRwgyc7UT2gSdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334384; c=relaxed/simple;
	bh=4CwhvU5aVshMu1PCgrhmlcmOTjbKebdAWni6eZ8tHM4=;
	h=Date:To:From:Subject:Message-Id; b=p53o6lDpKKTAptEb7cXfOSbBj0Ze6gVBXp4ZIoacCS7jJqI+QJcYdiSFaOjK1US6BKggShsd+L8emi2ImEk2Pax+y8y7fFYufR6bzPSCx8oTQgHPtLt1sgTSsUop11fWymFoQTE/Gd9MCrhLa4MJQSPp9ZfJyAWRIvER63MQQlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SdQYuyhz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SdQYuyhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB15A1F0089C;
	Wed,  7 Oct 2026 00:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334383;
	bh=gOxj2pYF2K7tKdWFfRbzVQuNIkYKzvN2HTKtb7ahyJU=;
	h=Date:To:From:Subject;
	b=SdQYuyhzrjNWEYs1XQw5goDrWnaiNOG2t0aXnEjb/fG634fWcE7fWA7mL1JUoKZ9M
	 z0m3Lpb/Ay2wrhdVuNJSK/I8tw5yA0JychlER5fqq1Y1O8TyPAQz05EFp9VKVgf1VA
	 C2LJ23MojIIGR2XboA5SAqiG30gd6OHpSPn/k2aw=
Date: Tue, 06 Oct 2026 17:53:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,mhocko@suse.com,ljs@kernel.org,hch@lst.de,hannes@cmpxchg.org,djwong@kernel.org,david@kernel.org,cem@kernel.org,brendan.jackman@linux.dev,brauner@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] iomap-simplify-writepages-reclaim-guard.patch removed from -mm tree
Message-Id: <20261007005303.AB15A1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: iomap: simplify writepages reclaim guard
has been removed from the -mm tree.  Its filename was
     iomap-simplify-writepages-reclaim-guard.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: iomap: simplify writepages reclaim guard
Date: Wed, 2 Sep 2026 21:16:51 +0800

Now that kswapd can no longer reach filesystem writeback (pageout()
returns PAGE_ACTIVATE for non-shmem, non-anon folios), any PF_MEMALLOC
context in iomap_writepages() indicates a VM regression, simplify the
check by removing PF_KSWAPD.

Link: https://lore.kernel.org/20260902131653.1338227-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Carlos Maiolino <cem@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
---

 fs/iomap/buffered-io.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/iomap/buffered-io.c~iomap-simplify-writepages-reclaim-guard
+++ a/fs/iomap/buffered-io.c
@@ -2077,8 +2077,7 @@ iomap_writepages(struct iomap_writepage_
 	 * Writeback from reclaim context should never happen except in the case
 	 * of a VM regression so warn about it and refuse to write the data.
 	 */
-	if (WARN_ON_ONCE((current->flags & (PF_MEMALLOC | PF_KSWAPD)) ==
-			PF_MEMALLOC))
+	if (WARN_ON_ONCE((current->flags & PF_MEMALLOC)))
 		return -EIO;
 
 	while ((folio = writeback_iter(mapping, wpc->wbc, folio, &error))) {
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-zswap-convert-zswap_invalidate-to-take-a-range.patch
mm-zswap-skip-xarray-walk-in-zswap_invalidate-when-zswap-is-unused.patch
mm-zswap-reuse-zswap_invalidate-in-zswap_store.patch
mm-mincore-use-per-vma-lock-during-page-table-walk.patch

