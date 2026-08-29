Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2468A31716B
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 02:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787971434; cv=none; b=XmAEgwbOT1BZpjytLGb/t/yao0IyIGG8l/xNaL7ujw49944998d0v7t1jw37NkMkCNa4LJx+Yd+iNZV9RCTqg8BwbD8Ju/PBXXvjyvSbRjRHt5y2wIe8H9jbmtRjJwhpCjMydvb2Dzg9xdR/F8gs5+YjSWJfoAyO2bUD0dlYMF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787971434; c=relaxed/simple;
	bh=uY2YqK1okqtoQzvP7+OHrgMi5OM+JzBwVNxBK/mALWY=;
	h=Date:To:From:Subject:Message-Id; b=lEcxXwka5f59uiqlF7eFUKjyKw/AlIgfzAfezGQArkicJL3ylEPvVdRzRNQUz4sFC7yJpG49APWmuwz8bVczs8ZklUIHJDXAjicxc5KEGOWSgZ842nCNFvemgTT1UA0Y33H6EcWbO0CfP0tZPtbJhLyUp446dIIetSfjdxyjL+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JOoC1pHs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JOoC1pHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8AA1F000E9;
	Sat, 29 Aug 2026 02:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787971432;
	bh=ruhaXgLo2rUkOJ7uiq0ZmCdPx0QC5Ukp8KhA71pqQBI=;
	h=Date:To:From:Subject;
	b=JOoC1pHsMDjv82diUriBIMeO+1Kghb8JRRtbgSmDLav9hTaEAM6WYFGtRtDGFx2CF
	 CgduY2Jf4LBdqvWHS/iPZDHtIcnyk1TbwWfwGGRLfcZCQBwCeRgwBcbOGB/uPOwtgG
	 aQ9sFdGLhjAbAkyLTd1FBk8kjwynIiWszVkMfOy4=
Date: Fri, 28 Aug 2026 19:43:52 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-remove-the-soft-limit-reclaim-tracepoints.patch added to mm-new branch
Message-Id: <20260829024352.BC8AA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: remove the soft limit reclaim tracepoints
has been added to the -mm mm-new branch.  Its filename is
     memcg-remove-the-soft-limit-reclaim-tracepoints.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-remove-the-soft-limit-reclaim-tracepoints.patch

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: remove the soft limit reclaim tracepoints
Date: Tue, 11 Aug 2026 13:31:58 -0700

mm_vmscan_memcg_softlimit_reclaim_begin and
mm_vmscan_memcg_softlimit_reclaim_end were only emitted by
mem_cgroup_shrink_node(), which is gone, so they can never fire again.

Link: https://lore.kernel.org/20260811203203.3456029-5-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |   14 --------------
 1 file changed, 14 deletions(-)

--- a/include/trace/events/vmscan.h~memcg-remove-the-soft-limit-reclaim-tracepoints
+++ a/include/trace/events/vmscan.h
@@ -214,13 +214,6 @@ DEFINE_EVENT(mm_vmscan_direct_reclaim_be
 
 	TP_ARGS(gfp_flags, order, memcg)
 );
-
-DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_softlimit_reclaim_begin,
-
-	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
-
-	TP_ARGS(gfp_flags, order, memcg)
-);
 #endif /* CONFIG_MEMCG */
 
 DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_end_template,
@@ -258,13 +251,6 @@ DEFINE_EVENT(mm_vmscan_direct_reclaim_en
 
 	TP_PROTO(unsigned long nr_reclaimed, struct mem_cgroup *memcg),
 
-	TP_ARGS(nr_reclaimed, memcg)
-);
-
-DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_softlimit_reclaim_end,
-
-	TP_PROTO(unsigned long nr_reclaimed, struct mem_cgroup *memcg),
-
 	TP_ARGS(nr_reclaimed, memcg)
 );
 #endif /* CONFIG_MEMCG */
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-clear-flushing_cached_charge-on-cpu-offline.patch
memcg-trim-the-per-cpu-charge-stock-instead-of-draining-it.patch
memcg-remove-v1-soft-limit-reclaim.patch
memcg-remove-mem_cgroup_shrink_node.patch
memcg-remove-the-soft-limit-reclaim-tracepoints.patch
memcg-remove-the-soft-limit-rbtree.patch
memcg-remove-lru_gen_soft_reclaim.patch
memcg-remove-the-per-node-soft-limit-tree-fields.patch
memcg-remove-mem_cgroup-soft_limit.patch
memcg-simplify-v1-event-ratelimiting.patch

