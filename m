Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD4C39C637
	for <mm-commits@vger.kernel.org>; Sat, 26 Sep 2026 20:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790456260; cv=none; b=QRiD0GrTt/dZY5DkV3X6Yp/wjsaOi2PT8yZbtmFdUXn+57+hb2GhVY7ycVqSzie5vGGNih0j63cJMDO/HC3zvd7XWlhNJny4BefnTDCQKl8SldE/8pNgXj0efvVj6TvX/WW537TWJPsgSAH28pAeGNWDxhqaM8sEhG+U3i4a1tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790456260; c=relaxed/simple;
	bh=2OX3ZnSXKZcX2peJB/a5lyNHVp5G1gPs5GRSGSsciTo=;
	h=Date:To:From:Subject:Message-Id; b=Qn7D86xz9um8JzNefMrKmayImvAdZ41HUPVgj4t/0YFoN9YgTJKBpMW59ufQwNXy63tYNJWLG1Lm2W0DCMUCVi7t3Aaw0h0s8jYDiyzPpSIwxxCC3TiJQNMCYjHB2BKGEqZRExDSzsIr8PwBBWaJ9vOvmt4rZ7OPLsjh6SRO5H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wkecUd7L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wkecUd7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63F31F000FF;
	Sat, 26 Sep 2026 20:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790456258;
	bh=0lxiAeCXcFneby11anULokdbgwQ7aGYhWCvHHnZyMQ8=;
	h=Date:To:From:Subject;
	b=wkecUd7L95hiUYV4OkeJy4pRoU0oxHStSL1GLx2GfTLqbB0/VOlURgb0ehSThTVkC
	 5xtVOIzGOOfZ0/ISRdpueBd5xatl+Dvkkdnru2jcgTSkoSQ44CCR1vdHbzyZGJEvWe
	 pxNRODmqnGEY2noMMhATomN09R9qk2gdEElg5/HM=
Date: Sat, 26 Sep 2026 13:57:38 -0700
To: mm-commits@vger.kernel.org,qinyuntan@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memcontrol-drop-kmemcg_id-and-use-mem_cgroup_id-for-list_lru-indexing-fix.patch removed from -mm tree
Message-Id: <20260926205738.A63F31F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memcontrol-drop-kmemcg_id-and-use-mem_cgroup_id-for-list_lru-indexing-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-drop-kmemcg_id-and-use-mem_cgroup_id-for-list_lru-indexing-fix.patch

This patch was dropped because it was folded into mm-memcontrol-drop-kmemcg_id-and-use-mem_cgroup_id-for-list_lru-indexing.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcontrol-drop-kmemcg_id-and-use-mem_cgroup_id-for-list_lru-indexing-fix
Date: Tue Sep 22 08:33:18 PM PDT 2026

remove kmemcg_id from memcg_struct_check()

Cc: Qinyun Tan <qinyuntan@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-drop-kmemcg_id-and-use-mem_cgroup_id-for-list_lru-indexing-fix
+++ a/mm/memcontrol.c
@@ -5887,8 +5887,6 @@ static void __init memcg_struct_check(vo
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      private_id);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
-				      kmemcg_id);
-	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      oom_group);
 
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_hotplug-factor-out-node_is_memoryless-fix.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix-fix.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma-fix.patch
mm-selftests-add-shmem-into-memory-failure-test-fix.patch
mm-memcontrol-drop-kmemcg_id-and-use-mem_cgroup_id-for-list_lru-indexing.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

