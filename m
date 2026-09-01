Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF2544162A
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 03:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788234011; cv=none; b=AZ9LpUQGxTBY1SlVIUFb/F3qfsI+j6ZX4xszPbyGFDIAkxEAAPV6tXG7RrqGy24vcxPpviKCasnLcxIddApzmdlmt8QKgE5RfYIPGr82vJtwB9GDKB1AQKSR42yivJj3q/EpysZkchaTHcRh7QQlIVtE6HE0ErfUhIxNIQ7Yn/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788234011; c=relaxed/simple;
	bh=jNPHNBeF8jPeqqjUAqqYcN7MiVFSudCjMargdgkSVBI=;
	h=Date:To:From:Subject:Message-Id; b=jVPGbxVA3b6Z4CfuQKGV7OggKBv7LxYe0eI1jBumWalqUCxFlne1OJC5+tO/QjZ0FEX8V3aT7PvoQET5QGc1BV5WyGdhf12M6YUtKXsGRqmHRuMds++0gzwuSeqD/dMKE40K0s122T+wpo7EB6TDXJOXCH1RI//jdTejdcBZvvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Djs/CGNt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Djs/CGNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B021F000E9;
	Tue,  1 Sep 2026 03:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788234009;
	bh=/8A5wNtLFEpWRpd8k+hvoCM8jSzAEbUAh6dYEAF5tN0=;
	h=Date:To:From:Subject;
	b=Djs/CGNtrZ/ASoHvpelOYcrigvBUQIwuglHtQ/9nYzdEmY9wRFTVETEWqoA4k014A
	 4TvSB7pzL7ioGjvMuodrucFFfQU9G1pJjcGqFqykwt+2pTT/E0YDDZ9VYaA2eIdeYe
	 Bx8bxukXv1ljMCJv7n9Ro7L/Kz7ohOmIKovc+X9o=
Date: Mon, 31 Aug 2026 20:40:09 -0700
To: mm-commits@vger.kernel.org,zhaonanzhe@xiaomi.com,youngjun.park@lge.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryncsn@gmail.com,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,xueyuan.chen21@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-split-large-folios-only-on-e2big.patch added to mm-new branch
Message-Id: <20260901034009.A1B021F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem: split large folios only on -E2BIG
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-split-large-folios-only-on-e2big.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-split-large-folios-only-on-e2big.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-distinguish-large-folio-swap-allocation-failures.patch
mm-shmem-split-large-folios-only-on-e2big.patch

