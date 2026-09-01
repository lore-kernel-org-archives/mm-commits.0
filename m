Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9FD48989B;
	Tue,  1 Sep 2026 17:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788282647; cv=none; b=Oc19pOCF4diBe5ITZLyLS62iOfBE1LHsFHf8nYA2wf993ArRYSY6QXPvkZ0fo6WorOYSuQo6/F+F+a3TPmXvqvO6L0iN3OFAFZN4+TgFE4xZh0Cv35jpAANvQTGPy4WmDBbmhfO9ahUrnxTH2igvz/Ol9vJGMQLHexL+WrcV94o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788282647; c=relaxed/simple;
	bh=FqZgHN51tUHjV4aPQsRmQNaFjtvQEKsrP1Hg4Wfhe0k=;
	h=Date:To:From:Subject:Message-Id; b=gK5Zl4xtzEDg9zApUu8DDzKsOduUWN1JWfksyjmlpdXU5HfTanvT7yqOLweXxLTFmYovNu8VpWADPBmKuUha9HC1IajBHLfGUjaYGf2APtkkxHralZNIbD0IoWKPWxJFdyVOkwxnz7uEx+H8ZDDnHQGWabgPU1RRiSXNtlgE6hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OwqQMxqi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OwqQMxqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC181F000E9;
	Tue,  1 Sep 2026 17:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788282646;
	bh=lxiZzOFdTrcfWLVzDEaZMbLGMwyeOFVoHGRbmo4s2Ds=;
	h=Date:To:From:Subject;
	b=OwqQMxqifSDtTTN+Xucsz0MIfpaxiKChKntShRiFF/HoIkT8tEseDY7kBOs+E88vJ
	 u/EW7y8b0XjG7yiklm2Y6er4CnFzr1M4TUlHvZKq0EXENI5DrRV+15scxXbaT7q+tP
	 ScPBmIYcBB8P3AA9N7hT+HYAUkpOf61vwRgLrkd4=
Date: Tue, 01 Sep 2026 10:10:45 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-handle-extreme-memory-state-in-get_node_memcg_used_bp.patch added to mm-new branch
Message-Id: <20260901171046.3DC181F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: handle extreme memory state in get_node_memcg_used_bp()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-handle-extreme-memory-state-in-get_node_memcg_used_bp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-handle-extreme-memory-state-in-get_node_memcg_used_bp.patch

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
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: handle extreme memory state in get_node_memcg_used_bp()
Date: Tue, 1 Sep 2026 06:18:48 -0700

In extreme unlikely situations, total memory might be zero.  In less
extreme but still very unlikely situations, lruvec_page_state() calls
might let the caller show used memory larger than total memory.  In the
two cases, damos_get_node_memcg_used_bp() could cause division by zero, or
return underflowed value, respectively.  Handle the cases by respectively
returning 100% and 0% for used and free memory queries in the corner
cases.

This issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260901131850.98037-8-sj@kernel.org
Link: https://lore.kernel.org/20260329154813.47382-1-sj@kernel.org [1]
Fixes: b74a120bcf50 ("mm/damon/core: implement DAMOS_QUOTA_NODE_MEMCG_USED_BP")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-handle-extreme-memory-state-in-get_node_memcg_used_bp
+++ a/mm/damon/core.c
@@ -2854,6 +2854,12 @@ static unsigned long damos_get_node_memc
 	mem_cgroup_put(memcg);
 
 	si_meminfo_node(&i, goal->nid);
+	if (!i.totalram || i.totalram < used_pages) {
+		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
+			return 10000;
+		else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
+			return 0;
+	}
 	if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
 		numerator = used_pages;
 	else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-skip-applying-scheme-if-region-split-for-quota-fails.patch
mm-damon-paddr-respect-folio-end-for-damos_stat.patch
mm-damon-paddr-respect-folio-end-for-damos-actions-except-stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_migrate_hotcold.patch
mm-damon-core-handle-extreme-memory-state-in-damon_get_node_mem_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_node_memcg_used_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_in_active_mem_bp.patch

