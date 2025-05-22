Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01B8257434
	for <mm-commits@vger.kernel.org>; Thu, 22 May 2025 21:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747950103; cv=none; b=HekfLXxMkxwS9uajvCi20ew6LIGdcqy8C3zCZuJq+F9O+FQQ3SF7h9Asp2Vl+vxEJnsu6DVbfNpNGtONN16IqFp6gLnLVUjHbXrXt3jIOndvx5jrHZuU7rwEol64p2lnOjmSolE36eIyPvPWhj1lWRvOlKuumR2BYM4akXKsTYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747950103; c=relaxed/simple;
	bh=KLLZXNg2v0bqnIWTwywGvY/ukj0OywftDlfEgHsel24=;
	h=Date:To:From:Subject:Message-Id; b=AP+zJWE7HseRmLBN3udavcpZ3Yoe9z87DJ+4/SFtRvczd98oTxVDhrqYoNGCWwnPkROICQXfvRJoLO3kK66KQYMI7yEBC3cDrlGpPfi3/WY+aeH6jUQ8PNa1AWUu5aqaixHr2HUJQx7j1VbQIaSldtjSbYwO9gkPZq9EcL6ZdmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QLxBTzeO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QLxBTzeO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83E2C4CEEB;
	Thu, 22 May 2025 21:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747950102;
	bh=KLLZXNg2v0bqnIWTwywGvY/ukj0OywftDlfEgHsel24=;
	h=Date:To:From:Subject:From;
	b=QLxBTzeOksSQJeBegj+t5sWgdaCGwLh+4ImWjIpSoX6guqxBu/r1fiD1xYV/7bpH8
	 NjRurfzYNPx2+4/DyoLkirXbWo6DqEmfvwolaGh/JgQKfEmZnfKQVKfACBn70ib3qG
	 QC4BBs2rKIkj11ArjnLdzMvyhxKtcG8EtR7F0obk=
Date: Thu, 22 May 2025 14:41:42 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,hannes@cmpxchg.org,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-remove-stale-comment-stale-comment-in-cluster_alloc_swap_entry.patch added to mm-new branch
Message-Id: <20250522214142.A83E2C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: remove stale comment stale comment in cluster_alloc_swap_entry()
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-remove-stale-comment-stale-comment-in-cluster_alloc_swap_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-remove-stale-comment-stale-comment-in-cluster_alloc_swap_entry.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: swap: remove stale comment stale comment in cluster_alloc_swap_entry()
Date: Thu, 22 May 2025 20:25:54 +0800

As cluster_next_cpu was already dropped, the associated comment is stale
now.

Link: https://lkml.kernel.org/r/20250522122554.12209-5-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swap-remove-stale-comment-stale-comment-in-cluster_alloc_swap_entry
+++ a/mm/swapfile.c
@@ -956,9 +956,8 @@ new_cluster:
 	}
 
 	/*
-	 * We don't have free cluster but have some clusters in
-	 * discarding, do discard now and reclaim them, then
-	 * reread cluster_next_cpu since we dropped si->lock
+	 * We don't have free cluster but have some clusters in discarding,
+	 * do discard now and reclaim them.
 	 */
 	if ((si->flags & SWP_PAGE_DISCARD) && swap_do_scheduled_discard(si))
 		goto new_cluster;
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-shmem-avoid-unpaired-folio_unlock-in-shmem_swapin_folio.patch
mm-shmem-add-missing-shmem_unacct_size-in-__shmem_file_setup.patch
mm-shmem-fix-potential-dead-loop-in-shmem_unuse.patch
mm-shmem-only-remove-inode-from-swaplist-when-its-swapped-page-count-is-0.patch
mm-shmem-remove-unneeded-xa_is_value-check-in-shmem_unuse_swap_entries.patch
mm-swap-move-nr_swap_pages-counter-decrement-from-folio_alloc_swap-to-swap_range_alloc.patch
mm-swap-correctly-use-maxpages-in-swapon-syscall-to-avoid-potensial-deadloop.patch
mm-swap-fix-potensial-buffer-overflow-in-setup_clusters.patch
mm-swap-remove-stale-comment-stale-comment-in-cluster_alloc_swap_entry.patch

