Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679129476
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 22:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768257358; cv=none; b=L7QAousYde138lhZvN5MT+VKp6ELvNUFsLJZQTJdpKJ3ouLyafYsawYfwH6OyRmZ51/slpW9dn3M71Tj7Mpfs9ad5lHW8ERYARRr30RX0s+4uw6AbGf2Q+zhzb4gWjvnjmkZ8jTIoATky31ABV8F4Jf1P+3/U2eIfdeccE6idPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768257358; c=relaxed/simple;
	bh=bbfpi/PeFeXn4SKweqnx38B+HzJ6B9QkSlQ7R5gP+N0=;
	h=Date:To:From:Subject:Message-Id; b=qNsn2HqcJf08EVgCPemLKpAQt6GwEqUPYaEsAY+PpgrfWEA0+11DR8+/GCpUvCRaiDha4iCv9rnO7IQ2KcKvtQc4lhVk++XjN3N9ihcHBiLA6H0xzTP5Q2WqkfBFYnY7t1ki8GT80P4/er9RpkdyLLgOaWX+FrGETJrjINiIK5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0emZeA8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0emZeA8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D138C116D0;
	Mon, 12 Jan 2026 22:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768257358;
	bh=bbfpi/PeFeXn4SKweqnx38B+HzJ6B9QkSlQ7R5gP+N0=;
	h=Date:To:From:Subject:From;
	b=0emZeA8FourMSJpwUmMRTNdzLMCU4XVeoTWvykQw1B12m2I+hRVrJdxPDBk98DRkL
	 GHBQBlrE2tyFdKHGt+L3dggtv6Q2HJuQ5BN3gGKDJqDoLemRDpy7zzNGXmDq+jtLnJ
	 ObkWe+SE18JA4Z/SWX/0C1eiw7xusrzSifTvUjK8=
Date: Mon, 12 Jan 2026 14:35:57 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix.patch added to mm-unstable branch
Message-Id: <20260112223558.3D138C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix
Date: Mon, 12 Jan 2026 13:34:27 -0800

replace ino with id, per SeongJae

Link: https://lkml.kernel.org/r/flkqanhyettp5uq22bjwg37rtmnpeg3mghznsylxcxxgaafpl4@nov2x7tagma7
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 mm/memcontrol.c            |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/memcontrol.h~memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix
+++ a/include/linux/memcontrol.h
@@ -835,7 +835,7 @@ static inline u64 mem_cgroup_id(struct m
 	return memcg ? cgroup_id(memcg->css.cgroup) : 0;
 }
 
-struct mem_cgroup *mem_cgroup_get_from_id(u64 ino);
+struct mem_cgroup *mem_cgroup_get_from_id(u64 id);
 
 static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
 {
@@ -1293,7 +1293,7 @@ static inline u64 mem_cgroup_id(struct m
 	return 0;
 }
 
-static inline struct mem_cgroup *mem_cgroup_get_from_id(u64 ino)
+static inline struct mem_cgroup *mem_cgroup_get_from_id(u64 id)
 {
 	return NULL;
 }
--- a/mm/memcontrol.c~memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix
+++ a/mm/memcontrol.c
@@ -3615,7 +3615,7 @@ struct mem_cgroup *mem_cgroup_from_priva
 	return xa_load(&mem_cgroup_private_ids, id);
 }
 
-struct mem_cgroup *mem_cgroup_get_from_id(u64 ino)
+struct mem_cgroup *mem_cgroup_get_from_id(u64 id)
 {
 	struct cgroup *cgrp;
 	struct cgroup_subsys_state *css;
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

lib-buildid-use-__kernel_read-for-sleepable-context.patch
mm-damon-core-get-memcg-reference-before-access.patch
memcg-introduce-private-id-api-for-in-kernel-users.patch
memcg-expose-mem_cgroup_ino-and-mem_cgroup_get_from_ino-unconditionally.patch
memcg-mem_cgroup_get_from_ino-returns-null-on-error.patch
memcg-use-cgroup_id-instead-of-cgroup_ino-for-memcg-id.patch
mm-damon-use-cgroup-id-instead-of-private-memcg-id.patch
mm-vmscan-use-cgroup-id-instead-of-private-memcg-id-in-lru_gen-interface.patch
memcg-remove-unused-mem_cgroup_id-and-mem_cgroup_from_id.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix.patch

