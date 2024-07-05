Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E059EEDD
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141624; cv=none; b=coJTZUz2P8ftCSEGgmOy9KKQObzs6sDKpieO1mC9hdN/gc7ivbWll1fb0658s3aXPc+WERFHMvBt9pAX7CTIYxcqBXBtfgaFl2vrShYtroBVBxrDRKGgTjvhzM6zW2W7JnaZLSDTsDx3UztC6q+qqHbvtptvmPiNozoGo5MMXfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141624; c=relaxed/simple;
	bh=CwQB7zEln9u7uM7+/O31QpQy1LZdMVQYKEShIYUJWL8=;
	h=Date:To:From:Subject:Message-Id; b=n6HTej0cWh1KlPCuv/XlGxU125kTPITmbMaeKa4maZcvEyckJ07o4g1RBDQjD6mBmiQ13R0E8ox2AcATz3FGVZeV1UlQSEEipyUftUyIzF7UD8mV1avSFEh0fHdto72+0Eu+iut0vEGOV8B2A/+08kFz8zmN8TriYbO1DkhVY10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j3Qo3XZl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j3Qo3XZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367A2C4AF07;
	Fri,  5 Jul 2024 01:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141624;
	bh=CwQB7zEln9u7uM7+/O31QpQy1LZdMVQYKEShIYUJWL8=;
	h=Date:To:From:Subject:From;
	b=j3Qo3XZlgsrPxZmu/4GYr+20Z9IJbMK3xj17iqtAE1BZEGqDaRAbWPlUBiHyRYe07
	 sA6ajCjvb6ZY31IDHAsXI3l829Gon3icU93bwVpF3CQtj0Hat/hxDBk28bqN8g9aRH
	 dTrF6wFOV10XhpEgDqL48rvCHKRJtrlHTn4U6ARk=
Date: Thu, 04 Jul 2024 18:07:03 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-guard-memcg1-specific-fields-accesses-in-mm-memcontrolc.patch removed from -mm tree
Message-Id: <20240705010704.367A2C4AF07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: guard memcg1-specific fields accesses in mm/memcontrol.c
has been removed from the -mm tree.  Its filename was
     mm-memcg-guard-memcg1-specific-fields-accesses-in-mm-memcontrolc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcg: guard memcg1-specific fields accesses in mm/memcontrol.c
Date: Fri, 28 Jun 2024 21:03:13 +0000

There are only few memcg1-specific struct mem_cgroup's members accesses
left in mm/memcontrol.c.  Let's guard them with the CONFIG_MEMCG_V1 config
option.

Link: https://lkml.kernel.org/r/20240628210317.272856-6-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-guard-memcg1-specific-fields-accesses-in-mm-memcontrolc
+++ a/mm/memcontrol.c
@@ -3637,20 +3637,23 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	if (parent) {
 		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
-		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
 
 		page_counter_init(&memcg->memory, &parent->memory);
 		page_counter_init(&memcg->swap, &parent->swap);
+#ifdef CONFIG_MEMCG_V1
+		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
 		page_counter_init(&memcg->kmem, &parent->kmem);
 		page_counter_init(&memcg->tcpmem, &parent->tcpmem);
+#endif
 	} else {
 		init_memcg_stats();
 		init_memcg_events();
 		page_counter_init(&memcg->memory, NULL);
 		page_counter_init(&memcg->swap, NULL);
+#ifdef CONFIG_MEMCG_V1
 		page_counter_init(&memcg->kmem, NULL);
 		page_counter_init(&memcg->tcpmem, NULL);
-
+#endif
 		root_mem_cgroup = memcg;
 		return &memcg->css;
 	}
@@ -3785,8 +3788,10 @@ static void mem_cgroup_css_reset(struct
 
 	page_counter_set_max(&memcg->memory, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->swap, PAGE_COUNTER_MAX);
+#ifdef CONFIG_MEMCG_V1
 	page_counter_set_max(&memcg->kmem, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->tcpmem, PAGE_COUNTER_MAX);
+#endif
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-drop-obsolete-cache-line-padding-in-struct-mem_cgroup.patch
mm-memcg-add-cache-line-padding-to-mem_cgroup_per_node.patch

