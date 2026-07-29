Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BFB324B06
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298376; cv=none; b=ljTylRu+hgE3f5XB8aqmwZJ1VTQ28BgR7FEf97wMab++1iofrNaYXs54SbnjYFJiTa9yZPrNmzftASQH/lUY6XuSHtCaStwoMQKSIXtiiZrGVy5xFbSZ8QnFJMOAh/vONdx/8qZNGO5UjldRiLB2E2o+IHnu/OH8ewO5Newa6/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298376; c=relaxed/simple;
	bh=orC2lb3u52G6uFH5RuwmYFQ0mb67vy98BVX/6vxpOQk=;
	h=Date:To:From:Subject:Message-Id; b=WUzLF6+ACrfEmD/mSsBoQUUk3+vkqYCcvE28xFr+/HAQlhuq2dyjDZeNn1djXpCYgxjYEkKeBf1CiYMPuM6lk/QOM/N0aqVw009R4I/TOqpzBWxsLFV3urRQbUa/uk2qDsW15P2Io0x61aB1kE6u4fBFXMI0yQEG14uSurFN1iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RzyKCXIM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RzyKCXIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873CD1F000E9;
	Wed, 29 Jul 2026 04:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298374;
	bh=erpDbpurpnD6YpqUqjxYAPH37ftVwtv4sI+cC5ApYR8=;
	h=Date:To:From:Subject;
	b=RzyKCXIMgmM6VffVSSt5d9mz9enTD6ecrPaD8FhLOE/eFab3m6+mvhh0WUaqvNT3s
	 4O31Hwh7qtQEmgidBE9pWmx3WsSXquDaF8EvAy2Ph9L4xqpfLJv0+zMRSEcnCX3cSz
	 UHG0Den8nbnZd/L3/ukr7VgfHWtQBpxjtGwXmA7g=
Date: Tue, 28 Jul 2026 21:12:54 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-remove-unused-for_each_mem_cgroup-macro-and-cleanup.patch removed from -mm tree
Message-Id: <20260729041254.873CD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memcontrol: remove unused for_each_mem_cgroup macro and cleanup
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-remove-unused-for_each_mem_cgroup-macro-and-cleanup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm/memcontrol: remove unused for_each_mem_cgroup macro and cleanup
Date: Wed, 24 Jun 2026 11:36:59 -0700

Commit 7e1c0d6f58207 ("memcg: switch lruvec stats to rstat") removed the
last caller of for_each_mem_cgroup back in 2021, and there have not been
any new callers since.  Remove the macro.

A comment in mem_cgroup_css_online has also been out of date since 2021,
when 2bfd36374edd9 ("mm: vmscan: consolidate shrinker_maps handling code")
open-coded the for_each_mem_cgroup iterator.  Update the comment.

Finally, 99430ab8b804c ("mm: introduce BPF kfuncs to access memcg
statistics and events") added a second declaration for memcg_events to
include/linux/memcontrol.h, duplicating the one in mm/memcontrol-v1.h. 
Let's clean that up too.

No functional changes intended.

Link: https://lore.kernel.org/20260624183700.1152742-1-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.h |    6 ------
 mm/memcontrol.c    |    2 +-
 2 files changed, 1 insertion(+), 7 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-remove-unused-for_each_mem_cgroup-macro-and-cleanup
+++ a/mm/memcontrol.c
@@ -4217,7 +4217,7 @@ static int mem_cgroup_css_online(struct
 	/*
 	 * A memcg must be visible for expand_shrinker_info()
 	 * by the time the maps are allocated. So, we allocate maps
-	 * here, when for_each_mem_cgroup() can't skip it.
+	 * here, when mem_cgroup_iter() can't skip it.
 	 */
 	if (alloc_shrinker_info(memcg))
 		goto offline_kmem;
--- a/mm/memcontrol-v1.h~mm-memcontrol-remove-unused-for_each_mem_cgroup-macro-and-cleanup
+++ a/mm/memcontrol-v1.h
@@ -17,14 +17,8 @@
 	     iter != NULL;				\
 	     iter = mem_cgroup_iter(root, iter, NULL))
 
-#define for_each_mem_cgroup(iter)			\
-	for (iter = mem_cgroup_iter(NULL, NULL, NULL);	\
-	     iter != NULL;				\
-	     iter = mem_cgroup_iter(NULL, iter, NULL))
-
 void drain_all_stock(struct mem_cgroup *root_memcg);
 
-unsigned long memcg_events(struct mem_cgroup *memcg, int event);
 int memory_stat_show(struct seq_file *m, void *v);
 
 struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg,
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are


