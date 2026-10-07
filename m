Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AF93128A3
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334323; cv=none; b=h6QL9GRTwJRWeGjQjw4k9p0J3Fv/PoKVluZdT2dUkJ4MjvKK18TWQ6qvrkcx0eSBFvya1/KbmITIeb+N6AtRXzXiEuC4BoLTp7rZtwN1H55Qkbf0e/ulaFgD3XU1BqWYOXUr3gUQAzYQjIPEUsNb3y4UZkTsCiJbVQOPIQBkgDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334323; c=relaxed/simple;
	bh=77pHn6Q0c83KD89rJZPZyPkmy9qkWFyKd2eL8+/c/fk=;
	h=Date:To:From:Subject:Message-Id; b=e8Zuo8pFS4D5gsQ+7sxRVor875C9QRCJANAqxFQLWpHO1XGhT0As6F75EK+uXUPsynYdfX53C9HKevO0PkkeLAY8q/7FOTDjvMQ+LjxPqXf6ZxfTD1sF0zc/A3ORLnTOFJObH615tFdNvSdrY5up5qQAGBmJEPG1pL/cOcJ31/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ul973f9n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ul973f9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8491F0089D;
	Wed,  7 Oct 2026 00:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334322;
	bh=8fLIWq2MDWbb5JTkuK9K/DHJ768mT3Jp48RI4Z8+gTo=;
	h=Date:To:From:Subject;
	b=Ul973f9nlQVyXp6K4AEgowgZ9kIs/wibowJO/KOk67xrDV/61NG9D0b62rU8vXZ6s
	 b7m/fsiNjMkrXj4OGZQmndyslPpCvoIduHlRDX57gLvfE30Y8WeE3+eG/jYpU8Elj3
	 zuujjFyjkVBKoSjD4YMMAOMDw1QHMspxPi+oG6e4=
Date: Tue, 06 Oct 2026 17:52:01 -0700
To: mm-commits@vger.kernel.org,zhaonanzhe@xiaomi.com,youngjun.park@lge.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryncsn@gmail.com,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,xueyuan.chen21@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-split-large-folios-only-on-e2big.patch removed from -mm tree
Message-Id: <20261007005201.EB8491F0089D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem: split large folios only on -E2BIG
has been removed from the -mm tree.  Its filename was
     mm-shmem-split-large-folios-only-on-e2big.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: mm/shmem: split large folios only on -E2BIG
Date: Sun, 30 Aug 2026 12:29:20 +0800

shmem_writeout() currently splits a large folio on every
folio_alloc_swap() failure.  With the refined return-value contract, only
-E2BIG indicates that splitting might allow smaller folios to be swapped
out.

Enter the split fallback only for -E2BIG.  For -ENOSPC and -ENOMEM,
redirty and reactivate the folio as before.

Link: https://lore.kernel.org/20260830042920.2280454-5-xueyuan.chen21@gmail.com
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
---

 mm/shmem.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/shmem.c~mm-shmem-split-large-folios-only-on-e2big
+++ a/mm/shmem.c
@@ -1813,7 +1813,7 @@ int shmem_writeout(struct swap_io_ctx *c
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	pgoff_t index;
-	int nr_pages;
+	int nr_pages, ret;
 	bool split = false;
 
 	if ((info->flags & SHMEM_F_LOCKED) || sbinfo->noswap)
@@ -1894,7 +1894,8 @@ try_split:
 		folio_mark_uptodate(folio);
 	}
 
-	if (!folio_alloc_swap(folio)) {
+	ret = folio_alloc_swap(folio);
+	if (!ret) {
 		bool first_swapped = shmem_recalc_inode(inode, 0, nr_pages);
 		int error;
 
@@ -1947,7 +1948,7 @@ try_split:
 		swap_cache_del_folio(folio);
 		goto redirty;
 	}
-	if (nr_pages > 1)
+	if (nr_pages > 1 && ret == -E2BIG)
 		goto try_split;
 redirty:
 	folio_mark_dirty(folio);
_

Patches currently in -mm which might be from xueyuan.chen21@gmail.com are


