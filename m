Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C893AF65A
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 03:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790134632; cv=none; b=K1NCuFoUbH+KnWWp7wP+nQU+ljn9u6tQKtgy6P3aqduKYYBsQwLvBfzWfbWwXCERSdFDEdmZciXyJE6ymP2zZRm3+IF6qP3iQ1lf2zbQIuS289bWQOO26qMLtdf6D6UE7qxP0/42QSe7vGJd/IkVdHtZX7bdYh639alv1YF6nIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790134632; c=relaxed/simple;
	bh=VNtzOHpzYKzdBrbzJ78LCZD2+9zeDccS4GywQWC1n+E=;
	h=Date:To:From:Subject:Message-Id; b=NS5p/ZdHlQv1m8W49RWPeJj+OctQdKkg3Je3mjQtQKK8ECINk5mEAyu9ZypVL3ba5q+sPxmM7e4QT64ARpyafAD+8IRgfJOdU6KMl9SnFY04ZVDaHPvsPV9w/3fbvVWPejedMdHZY2UF5IAhNKr+/hIn/r/gwg9UtMSZhP9xMSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sPHXVaUh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sPHXVaUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61181F000FF;
	Wed, 23 Sep 2026 03:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790134630;
	bh=04d2M8lyeHrzgADNTrFK3f80u83JScai4LE5v0E6xa8=;
	h=Date:To:From:Subject;
	b=sPHXVaUhpx+EcjYT/pugz13E+ziozra5Vne7gwMjQNTsQmmJ0PmVAC5fk0INVpObi
	 TM9fehiXdqAub/19xk8HRxSh+VOEqFaouqeUW2vlvePRRnXAdRoTFocOzR0VfjG0L6
	 TfcOSI2F2tsQ/3+Wm2LGytFPdA/veBX1AMtfy2PQ=
Date: Tue, 22 Sep 2026 20:37:10 -0700
To: mm-commits@vger.kernel.org,qinyuntan@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-drop-kmemcg_id-and-use-mem_cgroup_id-for-list_lru-indexing-fix.patch added to mm-new branch
Message-Id: <20260923033710.D61181F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memcontrol-drop-kmemcg_id-and-use-mem_cgroup_id-for-list_lru-indexing-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-drop-kmemcg_id-and-use-mem_cgroup_id-for-list_lru-indexing-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-drop-kmemcg_id-and-use-mem_cgroup_id-for-list_lru-indexing-fix.patch

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
mm-memcontrol-drop-kmemcg_id-and-use-mem_cgroup_id-for-list_lru-indexing-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

