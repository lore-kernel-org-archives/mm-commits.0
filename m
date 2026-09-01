Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827ED48CD63;
	Tue,  1 Sep 2026 17:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788282645; cv=none; b=EgTtSAQW22Z2/IafMEgpl+bkbAdX4CSWHHkPJNddvtSMV2xSvlX4QUKBCM2pQqoed4+ToF28AhBUWZaqWjzRbmtzHNK8wkAm0wBjK3rCcr42OSfK5wOTBM2VXlL0i8uI3JDW06oCZLyp9MWjMI7Uq0xNCrryoux9jDQT6hfJG74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788282645; c=relaxed/simple;
	bh=T3TKzTWz9obYcj0jPzQuxqQXQvJ4THsT4F3PGNtYxvk=;
	h=Date:To:From:Subject:Message-Id; b=S1tMp5TBjpKho9Xx0xKEF5raIGquNSWK6WO9o8liakOul8K6vP3htl9P7qjZRfdUV9lyNmaeZDSWkmjhnu+c3RRN15zdai6w+13nqqf0odAYPHOsD2jgGFkmMVltR7sMTZ7vo/vWbHk+3tGAC1oj/VYo3sFzX9a5MV87NC7+/qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DzilRMYQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DzilRMYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430981F000E9;
	Tue,  1 Sep 2026 17:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788282644;
	bh=spztjArIVRkzn8uhYMThTOBLp19xYPANEVa4ambncv8=;
	h=Date:To:From:Subject;
	b=DzilRMYQsSc0v3y6OEqp/EmYwTKfSz6ZMTfCTinstcjv9Fv/8/kLOgSm22emIHYas
	 xmKsW0zB7BxPzCgJemorIgOqOhhWMr9B/u2YIzds7JMMNExfsuA/XSv3e1ZMFwkKZS
	 a29p4teoVnz5haI0+cSyEN+thFeZYPtxmpzNKYFQ=
Date: Tue, 01 Sep 2026 10:10:43 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-handle-extreme-memory-state-in-damon_get_node_mem_bp.patch added to mm-new branch
Message-Id: <20260901171044.430981F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: handle extreme memory state in damon_get_node_mem_bp()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-handle-extreme-memory-state-in-damon_get_node_mem_bp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-handle-extreme-memory-state-in-damon_get_node_mem_bp.patch

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
Subject: mm/damon/core: handle extreme memory state in damon_get_node_mem_bp()
Date: Tue, 1 Sep 2026 06:18:47 -0700

In an extreme and unlikely situation, si_meminfo_node() might let the
caller show zero total ram.  That could cause a divide by zero in
damon_get_node_mem_bp().  It could also show free memory larger than the
total memory.  This could cause underflow and make DAMOS temporarily make
unexpected behavior.  Thanks to safety guards in the auto-tuning feedback
loop, that should not be a real problem, though.  Fix the problems by
respectively returning 100% and 0% for used and free memory queries in the
corner cases.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260901131850.98037-7-sj@kernel.org
Link: https://lore.kernel.org/20260328133216.9697-1-sj@kernel.org [1]
Fixes: 0e1c773b501f ("mm/damon/core: introduce damos quota goal metrics for memory node utilization")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-handle-extreme-memory-state-in-damon_get_node_mem_bp
+++ a/mm/damon/core.c
@@ -2807,6 +2807,13 @@ static __kernel_ulong_t damos_get_node_m
 	}
 
 	si_meminfo_node(&i, goal->nid);
+	if (!i.totalram || i.totalram < i.freeram) {
+		if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
+			return 10000;
+		else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
+			return 0;
+	}
+
 	if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
 		numerator = i.totalram - i.freeram;
 	else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
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

