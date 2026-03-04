Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34F3F513
	for <mm-commits@vger.kernel.org>; Wed,  4 Mar 2026 02:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772590167; cv=none; b=DIgITzsdSyI+NwH7EwNoeXzMP45KyZhrFjzTw6/MNVR1tiJvFRsIzo2ZmizSNCuNnsM4CsWlzpELGOOBGMtmq5VVBt3bq0cbqgDA1JnnzNbXxsvvD1m4hXD6B5TBAyKhcXiTyWvYs3FXxTTqU2sx4DrvQGMEsXxlsVXMqUbF0fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772590167; c=relaxed/simple;
	bh=DDdisWiG1RPLHnstKEisqmOGaKL6vxWHBMqMishnVR4=;
	h=Date:To:From:Subject:Message-Id; b=h4LdIbcDpIVfkokm55RVYMaCmSnG7yTZzlA11UwPpcRXKFaeo7r7m+Eoo5zN0N4Hr9kBGjvaJTa8Jyb0EjSqc8vnaa9n+JtUJTCNV0awKf5FDs5TezZxRB19/viZ7mBi6kM3FtRZA5mjYynhPh+uMYNIrfowqNLwhwupd8uJXvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WCt06gSn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WCt06gSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E289C116C6;
	Wed,  4 Mar 2026 02:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772590167;
	bh=DDdisWiG1RPLHnstKEisqmOGaKL6vxWHBMqMishnVR4=;
	h=Date:To:From:Subject:From;
	b=WCt06gSnwzrUx8vtu1eCAaZCCjLY9rrORWNfzT1Ou8eoAWz0oeRwJmlh5vtZB26BA
	 ojt0WT+L2FbMQkFJvExuCKO/GEtN8xofaTzOExjT9H+v0mOsyeZvxlhQBF1helRliJ
	 uAaVZnTHOIYXG7AFUJUICMjW0mUhUkeGztmaUUTs=
Date: Tue, 03 Mar 2026 18:09:26 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,bingjiao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-fix-unintended-mtc-nmask-mutation-in-alloc_demote_folio.patch added to mm-new branch
Message-Id: <20260304020927.2E289C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: fix unintended mtc->nmask mutation in alloc_demote_folio()
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-fix-unintended-mtc-nmask-mutation-in-alloc_demote_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-fix-unintended-mtc-nmask-mutation-in-alloc_demote_folio.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Bing Jiao <bingjiao@google.com>
Subject: mm/vmscan: fix unintended mtc->nmask mutation in alloc_demote_folio()
Date: Tue, 3 Mar 2026 05:25:17 +0000

In alloc_demote_folio(), mtc->nmask is set to NULL for the first
allocation.  If that succeeds, it returns without restoring mtc->nmask to
allowed_mask.  For subsequent allocations from the migrate_pages() batch,
mtc->nmask will be NULL.  If the target node then becomes full, the
fallback allocation will use nmask = NULL, allocating from any node
allowed by the task cpuset, which for kswapd is all nodes.

To address this issue, use a local copy of the mtc structure with nmask =
NULL for the first allocation attempt specifically, ensuring the original
mtc remains unmodified.

Link: https://lkml.kernel.org/r/20260303052519.109244-1-bingjiao@google.com
Fixes: 320080272892 ("mm/demotion: demote pages according to allocation fallback order")
Signed-off-by: Bing Jiao <bingjiao@google.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-fix-unintended-mtc-nmask-mutation-in-alloc_demote_folio
+++ a/mm/vmscan.c
@@ -966,13 +966,11 @@ static void folio_check_dirty_writeback(
 static struct folio *alloc_demote_folio(struct folio *src,
 		unsigned long private)
 {
+	struct migration_target_control *mtc, target_nid_mtc;
 	struct folio *dst;
-	nodemask_t *allowed_mask;
-	struct migration_target_control *mtc;
 
 	mtc = (struct migration_target_control *)private;
 
-	allowed_mask = mtc->nmask;
 	/*
 	 * make sure we allocate from the target node first also trying to
 	 * demote or reclaim pages from the target node via kswapd if we are
@@ -982,15 +980,13 @@ static struct folio *alloc_demote_folio(
 	 * a demotion of cold pages from the target memtier. This can result
 	 * in the kernel placing hot pages in slower(lower) memory tiers.
 	 */
-	mtc->nmask = NULL;
-	mtc->gfp_mask |= __GFP_THISNODE;
-	dst = alloc_migration_target(src, (unsigned long)mtc);
+	target_nid_mtc = *mtc;
+	target_nid_mtc.nmask = NULL;
+	target_nid_mtc.gfp_mask |= __GFP_THISNODE;
+	dst = alloc_migration_target(src, (unsigned long)&target_nid_mtc);
 	if (dst)
 		return dst;
 
-	mtc->gfp_mask &= ~__GFP_THISNODE;
-	mtc->nmask = allowed_mask;
-
 	return alloc_migration_target(src, (unsigned long)mtc);
 }
 
_

Patches currently in -mm which might be from bingjiao@google.com are

mm-vmscan-fix-unintended-mtc-nmask-mutation-in-alloc_demote_folio.patch

