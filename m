Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B963A13AA2F
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 03:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765855165; cv=none; b=eZiUXhbe6hdAylkQzAfgT/VRSQDzXdJWPftA4U6xuZjHK+f3aIKc9nYZ1+8ueQx7ENwQdTtC+Xj2se9QFngeUs0/ekhSdZZM+lwgQrNQFvUT+aWwcLx6DCUc29EP4RDtBS6PHBolB2aXs9A0hrj7sRNGULXZsK22peythHGGcAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765855165; c=relaxed/simple;
	bh=yNSNflKq9/13/TFjhdhyzrLB1rI8qK9mMoLXaIRkGco=;
	h=Date:To:From:Subject:Message-Id; b=nUQXFCOF3royz1gTNm7ufmMPYodll1qVgeaKwlCnGxVXVMYP0QUUZTRz0JOTEoVBrLbPRiSiI1U59qZGm1ik8PxB9VtMvELd0cjpcxgtgY5MWOkIkVYhIW2qJXgQObLcH/s0FEbV1z31tTgzhkKCUonybggxiz9VcqHZWGE1hPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NqGZmosm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NqGZmosm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CA1C4CEF5;
	Tue, 16 Dec 2025 03:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765855165;
	bh=yNSNflKq9/13/TFjhdhyzrLB1rI8qK9mMoLXaIRkGco=;
	h=Date:To:From:Subject:From;
	b=NqGZmosmB/AzspFu5mZPtRsE9J7OJ7XsVdB9bdaehCQ8TYdEKQDXnbsFRIsM1b9xW
	 yuU5cqP8+hSKZSFaHnHUQG2X5CPU9UUNnca6A2HP4ZuF93qLNcrBaVcJ/weBNIKdS1
	 7sCH6dKFRPeN964djBpvO64qaR4OObbNPhmdmDTo=
Date: Mon, 15 Dec 2025 19:19:24 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,lujialin4@huawei.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,axelrasmussen@google.com,chenridong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-move-mem_cgroup_usage-memcontrol-v1c.patch added to mm-new branch
Message-Id: <20251216031925.33CA1C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: move mem_cgroup_usage memcontrol-v1.c
has been added to the -mm mm-new branch.  Its filename is
     memcg-move-mem_cgroup_usage-memcontrol-v1c.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-move-mem_cgroup_usage-memcontrol-v1c.patch

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
From: Chen Ridong <chenridong@huawei.com>
Subject: memcg: move mem_cgroup_usage memcontrol-v1.c
Date: Thu, 11 Dec 2025 01:30:18 +0000

Patch series "memcg cleanups", v3.

Two code moves/removals with no behavior change.


This patch (of 2):

Currently, mem_cgroup_usage is only used for v1, just move it to
memcontrol-v1.c

Link: https://lkml.kernel.org/r/20251211013019.2080004-1-chenridong@huaweicloud.com
Link: https://lkml.kernel.org/r/20251211013019.2080004-2-chenridong@huaweicloud.com
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Koutný <mkoutny@suse.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Lu Jialin <lujialin4@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |   22 ++++++++++++++++++++++
 mm/memcontrol-v1.h |    2 --
 mm/memcontrol.c    |   22 ----------------------
 3 files changed, 22 insertions(+), 24 deletions(-)

--- a/mm/memcontrol.c~memcg-move-mem_cgroup_usage-memcontrol-v1c
+++ a/mm/memcontrol.c
@@ -3272,28 +3272,6 @@ void folio_split_memcg_refs(struct folio
 	css_get_many(&__folio_memcg(folio)->css, new_refs);
 }
 
-unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
-{
-	unsigned long val;
-
-	if (mem_cgroup_is_root(memcg)) {
-		/*
-		 * Approximate root's usage from global state. This isn't
-		 * perfect, but the root usage was always an approximation.
-		 */
-		val = global_node_page_state(NR_FILE_PAGES) +
-			global_node_page_state(NR_ANON_MAPPED);
-		if (swap)
-			val += total_swap_pages - get_nr_swap_pages();
-	} else {
-		if (!swap)
-			val = page_counter_read(&memcg->memory);
-		else
-			val = page_counter_read(&memcg->memsw);
-	}
-	return val;
-}
-
 static int memcg_online_kmem(struct mem_cgroup *memcg)
 {
 	struct obj_cgroup *objcg;
--- a/mm/memcontrol-v1.c~memcg-move-mem_cgroup_usage-memcontrol-v1c
+++ a/mm/memcontrol-v1.c
@@ -427,6 +427,28 @@ static int mem_cgroup_move_charge_write(
 }
 #endif
 
+static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
+{
+	unsigned long val;
+
+	if (mem_cgroup_is_root(memcg)) {
+		/*
+		 * Approximate root's usage from global state. This isn't
+		 * perfect, but the root usage was always an approximation.
+		 */
+		val = global_node_page_state(NR_FILE_PAGES) +
+			global_node_page_state(NR_ANON_MAPPED);
+		if (swap)
+			val += total_swap_pages - get_nr_swap_pages();
+	} else {
+		if (!swap)
+			val = page_counter_read(&memcg->memory);
+		else
+			val = page_counter_read(&memcg->memsw);
+	}
+	return val;
+}
+
 static void __mem_cgroup_threshold(struct mem_cgroup *memcg, bool swap)
 {
 	struct mem_cgroup_threshold_ary *t;
--- a/mm/memcontrol-v1.h~memcg-move-mem_cgroup_usage-memcontrol-v1c
+++ a/mm/memcontrol-v1.h
@@ -22,8 +22,6 @@
 	     iter != NULL;				\
 	     iter = mem_cgroup_iter(NULL, iter, NULL))
 
-unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
-
 void drain_all_stock(struct mem_cgroup *root_memcg);
 
 unsigned long memcg_events(struct mem_cgroup *memcg, int event);
_

Patches currently in -mm which might be from chenridong@huawei.com are

memcg-move-mem_cgroup_usage-memcontrol-v1c.patch
memcg-remove-mem_cgroup_size.patch

