Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E091CD1E4
	for <mm-commits@vger.kernel.org>; Sat, 19 Jul 2025 23:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752968361; cv=none; b=MFEj75IASvPVDV2Gzv4Rm0keh2PY0cIv+KJ/xjdAM/KEgxUvLaxCP65X29apCk7kkjU8+DIMf/y9FVX9QjsWtdBh1kKqebtaM2euS3dZy8NmGh9YXp5AXmkuPGhOp9bDmAbhf1+hJcHSccWyC0zV/GsODm5txs+GYZTBxNBuw9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752968361; c=relaxed/simple;
	bh=cAOt8FDu41S4AjHIiM52sL8OgY0QhM9EPzi9SZLVdFQ=;
	h=Date:To:From:Subject:Message-Id; b=J21ludwXNrQ09HLGpfBUxOWtiRyNkcvTcRnLazU1nha1s3NRq2GGKfUKuyIY7G9KhVGSFwZgecmZyyIveqDsdb1wzZqbqQtoZu9R448ySxbQd3lxOfkOsYCbGuNu4DYw3z3VWmuysGcw8pTVXO5bBw9IK6iq46L8I3Tt8nagEJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hot6nxc3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hot6nxc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFF6C4CEE3;
	Sat, 19 Jul 2025 23:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752968361;
	bh=cAOt8FDu41S4AjHIiM52sL8OgY0QhM9EPzi9SZLVdFQ=;
	h=Date:To:From:Subject:From;
	b=hot6nxc38TCN1gqRFRxmKYfiCPrfEV39V+jq1zdmShald5R871g1wD/8w9mMR/J0z
	 ZLOG9Y8gSRF7FIue+iwxR89vkFub/pL4Xmp/mMw1zUdW03dx2q2v7cw5+kCzSozAzi
	 kWIUUxHNpfT7w2lcmhoNEYxPeJ/m/gGTW697JHrU=
Date: Sat, 19 Jul 2025 16:39:20 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryncsn@gmail.com,rientjes@google.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,21cnbao@gmail.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-writeout-free-swap-if-swap_writeout-reactivates-fix.patch added to mm-unstable branch
Message-Id: <20250719233921.3AFF6C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem: writeout free swap if swap_writeout() reactivates fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-writeout-free-swap-if-swap_writeout-reactivates-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-writeout-free-swap-if-swap_writeout-reactivates-fix.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: mm/shmem: writeout free swap if swap_writeout() reactivates fix
Date: Fri, 18 Jul 2025 17:56:52 -0700 (PDT)

Per Baolin: use shmem_recalc_inode() rather than open coding.

Link: https://lkml.kernel.org/r/101a7d89-290c-545d-8a6d-b1174ed8b1e5@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/shmem.c~mm-shmem-writeout-free-swap-if-swap_writeout-reactivates-fix
+++ a/mm/shmem.c
@@ -1692,9 +1692,7 @@ try_split:
 				__GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
 		/* Swap entry might be erased by racing shmem_free_swap() */
 		if (!error) {
-			spin_lock(&info->lock);
-			info->swapped -= nr_pages;
-			spin_unlock(&info->lock);
+			shmem_recalc_inode(inode, 0, -nr_pages);
 			swap_free_nr(folio->swap, nr_pages);
 		}
 
_

Patches currently in -mm which might be from hughd@google.com are

mm-optimize-lru_note_cost-by-adding-lru_note_cost_unlock_irq.patch
mm-optimize-lru_note_cost-by-adding-lru_note_cost_unlock_irq-fix.patch
mm-shmem-hold-shmem_swaplist-spinlock-not-mutex-much-less.patch
mm-shmem-writeout-free-swap-if-swap_writeout-reactivates.patch
mm-shmem-writeout-free-swap-if-swap_writeout-reactivates-fix.patch

